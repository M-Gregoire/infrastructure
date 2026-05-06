#!/usr/bin/env python3
"""pi-oauth - OAuth CLI for Atlassian (Jira/Confluence) and Slack"""

import os
import sys
import json
import base64
import hashlib
import secrets
import subprocess
import urllib.parse
import urllib.request
import urllib.error
import http.server
import webbrowser
from datetime import datetime, timezone

KEYCHAIN_SERVICE = "pi-oauth"

# Datadog-specific config from env (set in infrastructure-private)
_ATL_CLOUD_ID = os.environ.get("PI_OAUTH_ATLASSIAN_CLOUD_ID", "")
_JIRA_PROJECT = os.environ.get("PI_OAUTH_JIRA_PROJECT", "PSEC")

# ---------------------------------------------------------------------------
# Keychain
# ---------------------------------------------------------------------------


def kc_set(key: str, value: str):
    subprocess.run(
        [
            "security", "add-generic-password",
            "-a", key, "-s", KEYCHAIN_SERVICE, "-w", value, "-U",
        ],
        check=True,
        capture_output=True,
    )


def kc_get(key: str) -> str | None:
    r = subprocess.run(
        [
            "security", "find-generic-password",
            "-a", key, "-s", KEYCHAIN_SERVICE, "-w",
        ],
        capture_output=True,
        text=True,
    )
    return r.stdout.strip() if r.returncode == 0 else None


def kc_delete(key: str):
    subprocess.run(
        [
            "security", "delete-generic-password",
            "-a", key, "-s", KEYCHAIN_SERVICE,
        ],
        capture_output=True,
    )


# ---------------------------------------------------------------------------
# OAuth helpers
# ---------------------------------------------------------------------------

def pkce_pair() -> tuple[str, str]:
    verifier = (
        base64.urlsafe_b64encode(secrets.token_bytes(32))
        .rstrip(b"=")
        .decode()
    )
    challenge = (
        base64.urlsafe_b64encode(
            hashlib.sha256(verifier.encode()).digest()
        )
        .rstrip(b"=")
        .decode()
    )
    return verifier, challenge


class _CallbackHandler(http.server.BaseHTTPRequestHandler):
    result: dict = {}

    def do_GET(self):
        parsed = urllib.parse.urlparse(self.path)
        params = urllib.parse.parse_qs(parsed.query)
        _CallbackHandler.result = {k: v[0] for k, v in params.items()}
        self.send_response(200)
        self.send_header("Content-Type", "text/html")
        self.end_headers()
        self.wfile.write(b"<h1>Auth complete. Close this tab.</h1>")

    def log_message(self, *_):
        pass


def _wait_for_callback(port: int) -> dict:
    _CallbackHandler.result = {}
    server = http.server.HTTPServer(("localhost", port), _CallbackHandler)
    server.handle_request()
    return _CallbackHandler.result


def _post_json(url: str, data: dict, headers: dict = {}) -> dict:
    req = urllib.request.Request(
        url,
        data=json.dumps(data).encode(),
        headers={
            "Content-Type": "application/json",
            "Accept": "application/json",
            "User-Agent": "pi-oauth/1.0",
            **headers,
        },
    )
    with urllib.request.urlopen(req) as resp:
        return json.loads(resp.read())


def _post_form(url: str, data: dict, headers: dict = {}) -> dict:
    req = urllib.request.Request(
        url,
        data=urllib.parse.urlencode(data).encode(),
        headers={
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept": "application/json",
            "User-Agent": "pi-oauth/1.0",
            **headers,
        },
    )
    with urllib.request.urlopen(req) as resp:
        return json.loads(resp.read())


# ---------------------------------------------------------------------------
# Atlassian — OAuth 2.0 PKCE via MCP server + MCP JSON-RPC calls
#
# Same flow Claude uses:
#   Discovery:  https://mcp.atlassian.com/.well-known/oauth-authorization-server
#   Register:   https://cf.mcp.atlassian.com/v1/register  (dynamic, RFC 7591)
#   Authorize:  https://mcp.atlassian.com/v1/authorize
#   Token:      https://cf.mcp.atlassian.com/v1/token
#   MCP server: https://mcp.atlassian.com/v1/mcp  (JSON-RPC over HTTP)
# ---------------------------------------------------------------------------

_ATL_REGISTER_URL = "https://cf.mcp.atlassian.com/v1/register"
_ATL_AUTH_URL = "https://mcp.atlassian.com/v1/authorize"
_ATL_TOKEN_URL = "https://cf.mcp.atlassian.com/v1/token"
_ATL_MCP_URL = "https://mcp.atlassian.com/v1/mcp"
_ATL_REDIRECT = "http://localhost:18080/callback"
_ATL_SCOPES = (
    "read:jira-work write:jira-work manage:jira-project "
    "read:confluence-content.all read:confluence-space.summary "
    "write:confluence-content offline_access"
)


def _atl_ensure_client() -> str:
    client_id = kc_get("atlassian_client_id")
    if client_id:
        return client_id
    print("Registering pi-oauth with Atlassian MCP...")
    reg = _post_json(_ATL_REGISTER_URL, {
        "client_name": "pi-oauth",
        "redirect_uris": [_ATL_REDIRECT],
        "token_endpoint_auth_method": "none",
        "grant_types": ["authorization_code", "refresh_token"],
        "response_types": ["code"],
    })
    client_id = reg["client_id"]
    kc_set("atlassian_client_id", client_id)
    print(f"✓ Registered (client_id: {client_id[:8]}...)")
    return client_id


def atlassian_auth():
    client_id = _atl_ensure_client()
    verifier, challenge = pkce_pair()
    state = secrets.token_urlsafe(16)

    url = _ATL_AUTH_URL + "?" + urllib.parse.urlencode({
        "client_id": client_id,
        "scope": _ATL_SCOPES,
        "redirect_uri": _ATL_REDIRECT,
        "state": state,
        "response_type": "code",
        "code_challenge": challenge,
        "code_challenge_method": "S256",
    })

    print("Opening browser for Atlassian auth...")
    webbrowser.open(url)

    cb = _wait_for_callback(18080)
    if cb.get("state") != state:
        raise RuntimeError("State mismatch — possible CSRF")

    token = _post_form(_ATL_TOKEN_URL, {
        "grant_type": "authorization_code",
        "client_id": client_id,
        "code": cb["code"],
        "redirect_uri": _ATL_REDIRECT,
        "code_verifier": verifier,
    })

    kc_set("atlassian_access_token", token["access_token"])
    if "refresh_token" in token:
        kc_set("atlassian_refresh_token", token["refresh_token"])
    print("✓ Atlassian authenticated")


def _atl_refresh() -> bool:
    client_id = kc_get("atlassian_client_id")
    refresh = kc_get("atlassian_refresh_token")
    if not client_id or not refresh:
        return False
    try:
        token = _post_form(_ATL_TOKEN_URL, {
            "grant_type": "refresh_token",
            "client_id": client_id,
            "refresh_token": refresh,
        })
        kc_set("atlassian_access_token", token["access_token"])
        if "refresh_token" in token:
            kc_set("atlassian_refresh_token", token["refresh_token"])
        return True
    except Exception:
        return False


def _atl_token() -> str:
    token = kc_get("atlassian_access_token")
    if not token:
        print("Not authenticated. Run: pi-oauth auth atlassian")
        sys.exit(1)
    return token


# ---------------------------------------------------------------------------
# MCP JSON-RPC over HTTP (streamable transport)
# ---------------------------------------------------------------------------

_mcp_session_id: str | None = None


def _mcp_ensure_session():
    """Send MCP initialize to establish a session ID."""
    global _mcp_session_id
    if _mcp_session_id:
        return
    token = _atl_token()
    body = json.dumps({
        "jsonrpc": "2.0",
        "id": 0,
        "method": "initialize",
        "params": {
            "protocolVersion": "2024-11-05",
            "capabilities": {},
            "clientInfo": {"name": "pi-oauth", "version": "1.0"},
        },
    }).encode()
    req = urllib.request.Request(
        _ATL_MCP_URL,
        data=body,
        headers={
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json",
            "Accept": "application/json, text/event-stream",
            "User-Agent": "pi-oauth/1.0",
        },
    )
    try:
        with urllib.request.urlopen(req) as resp:
            sid = resp.headers.get("Mcp-Session-Id")
            if sid:
                _mcp_session_id = sid
    except urllib.error.HTTPError as e:
        raise RuntimeError(
            f"MCP init failed {e.code}: {e.read().decode()}"
        ) from e


def _mcp_call(tool: str, arguments: dict, *, _retry: bool = True) -> dict:
    """Call an MCP tool via JSON-RPC HTTP POST. Handles SSE responses."""
    global _mcp_session_id
    _mcp_ensure_session()
    token = _atl_token()
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json",
        "Accept": "application/json, text/event-stream",
        "User-Agent": "pi-oauth/1.0",
    }
    if _mcp_session_id:
        headers["Mcp-Session-Id"] = _mcp_session_id

    body = json.dumps({
        "jsonrpc": "2.0",
        "id": 1,
        "method": "tools/call",
        "params": {"name": tool, "arguments": arguments},
    }).encode()

    req = urllib.request.Request(_ATL_MCP_URL, data=body, headers=headers)
    try:
        with urllib.request.urlopen(req) as resp:
            # Capture session id for subsequent calls
            sid = resp.headers.get("Mcp-Session-Id")
            if sid:
                _mcp_session_id = sid
            ct = resp.headers.get("Content-Type", "")
            raw = resp.read().decode()
    except urllib.error.HTTPError as e:
        if e.code == 401 and _retry and _atl_refresh():
            return _mcp_call(tool, arguments, _retry=False)
        body_err = e.read().decode()
        raise RuntimeError(f"MCP HTTP {e.code}: {body_err}") from e

    # Parse: may be application/json or text/event-stream
    if "text/event-stream" in ct:
        # Extract the last "data: {...}" line that contains a result
        result = None
        for line in raw.splitlines():
            if line.startswith("data:"):
                data_str = line[5:].strip()
                if data_str == "[DONE]":
                    continue
                try:
                    result = json.loads(data_str)
                except json.JSONDecodeError:
                    pass
        if result is None:
            raise RuntimeError(f"No JSON in SSE response: {raw[:200]}")
        raw_obj = result
    else:
        raw_obj = json.loads(raw)

    if "error" in raw_obj:
        raise RuntimeError(f"MCP error: {raw_obj['error']}")

    # Unwrap tool result: result.content[0].text
    content = raw_obj.get("result", {}).get("content", [])
    for item in content:
        if item.get("type") == "text":
            try:
                return json.loads(item["text"])
            except json.JSONDecodeError:
                return {"text": item["text"]}
    return raw_obj.get("result", {})


# ---------------------------------------------------------------------------
# Jira helpers via MCP
# ---------------------------------------------------------------------------

def _cloud_id() -> str:
    if not _ATL_CLOUD_ID:
        print(
            "PI_OAUTH_ATLASSIAN_CLOUD_ID not set."
            " Check infrastructure-private config."
        )
        sys.exit(1)
    return _ATL_CLOUD_ID


def _jira_search(jql: str, fields: list[str] | None = None) -> dict:
    args: dict = {"cloudId": _cloud_id(), "jql": jql, "maxResults": 50}
    if fields:
        args["fields"] = ",".join(fields)
    return _mcp_call("searchJiraIssuesUsingJql", args)


def _jira_get_issue(key: str) -> dict:
    return _mcp_call("getJiraIssue", {
        "cloudId": _cloud_id(), "issueIdOrKey": key,
    })


def _jira_transition(key: str, transition_id: str) -> dict:
    return _mcp_call("transitionJiraIssue", {
        "cloudId": _cloud_id(),
        "issueIdOrKey": key,
        "transitionId": transition_id,
    })


def _jira_create(fields: dict) -> dict:
    return _mcp_call("createJiraIssue", {
        "cloudId": _cloud_id(), "fields": fields,
    })


def _jira_get_transitions(key: str) -> dict:
    return _mcp_call("getTransitionsForJiraIssue", {
        "cloudId": _cloud_id(), "issueIdOrKey": key,
    })


def _confluence_search_mcp(cql: str) -> dict:
    return _mcp_call("searchConfluenceUsingCql", {
        "cloudId": _cloud_id(), "cql": cql, "limit": 10,
    })


# ---------------------------------------------------------------------------
# Jira commands
# ---------------------------------------------------------------------------

_STATUS_COLORS = {
    "To Do": "\033[90m",
    "In Progress": "\033[33m",
    "Done": "\033[32m",
    "Blocked": "\033[31m",
}
_RESET = "\033[0m"


def _color(status: str) -> str:
    c = _STATUS_COLORS.get(status, "")
    return f"{c}{status}{_RESET}" if c else status


def jira_sprint():
    project = _JIRA_PROJECT
    result = _jira_search(
        f"project = {project} AND assignee = currentUser()"
        " AND sprint in openSprints()"
        " ORDER BY status DESC, priority DESC",
    )
    issues = result.get("issues", [])
    if not issues:
        print("No issues in current sprint.")
        return

    sprint_name = sprint_end = ""
    for issue in issues:
        sprints = issue["fields"].get("customfield_10020") or []
        for s in sprints:
            if s.get("state") == "active":
                sprint_name = s.get("name", "")
                sprint_end = s.get("endDate", "")[:10]
                break
        if sprint_name:
            break

    header = sprint_name or "Current Sprint"
    end_str = f"  (ends {sprint_end})" if sprint_end else ""
    print(f"\n\033[1mSprint: {header}\033[0m{end_str}\n")
    print(f"{'Key':<12} {'Status':<20} Summary")
    print("─" * 90)

    done_count = total_count = 0
    for i in issues:
        f = i["fields"]
        status = f["status"]["name"]
        total_count += 1
        if f["status"]["statusCategory"]["key"] == "done":
            done_count += 1
        cstatus = f"{_color(status):<20}"
        print(f"{i['key']:<12} {cstatus} {f['summary'][:58]}")

    print(f"\nTotal: {total_count}  Done: {done_count}  Remaining: {total_count - done_count}")


def jira_issue(key: str):
    issue = _jira_get_issue(key)
    f = issue["fields"]
    pts = f.get("customfield_10024", "?")
    print(f"\n\033[1m[{key}]\033[0m {f['summary']}")
    print(
        f"Status: {_color(f['status']['name'])}"
        f"  Priority: {f['priority']['name']}"
        f"  Points: {pts}"
    )
    desc = f.get("description")
    if desc and isinstance(desc, dict):
        print()
        _render_adf(desc)


def _render_adf(node: dict, indent: int = 0):
    t = node.get("type")
    content = node.get("content", [])
    if t == "text":
        print(" " * indent + node.get("text", ""), end="")
    elif t in ("paragraph", "heading"):
        for c in content:
            _render_adf(c, indent)
        print()
    elif t == "bulletList":
        for item in content:
            print(" " * indent + "• ", end="")
            for c in item.get("content", []):
                _render_adf(c, indent + 2)
    elif t == "orderedList":
        for idx, item in enumerate(content, 1):
            print(" " * indent + f"{idx}. ", end="")
            for c in item.get("content", []):
                _render_adf(c, indent + 3)
    elif t == "codeBlock":
        print()
        for c in content:
            print("  " + c.get("text", ""))
    else:
        for c in content:
            _render_adf(c, indent)


def jira_transition(key: str, status: str):
    result = _jira_get_transitions(key)
    transitions = result.get("transitions", [])
    match = next(
        (t for t in transitions if status.lower() in t["name"].lower()),
        None,
    )
    if not match:
        names = [t["name"] for t in transitions]
        print(
            f"No match for '{status}'."
            f" Available: {', '.join(names)}"
        )
        sys.exit(1)
    _jira_transition(key, match["id"])
    print(f"✓ {key} → {match['name']}")


# ---------------------------------------------------------------------------
# Confluence commands
# ---------------------------------------------------------------------------

def confluence_search(query: str):
    cql = f'text ~ "{query}" AND space.type = "global"'
    result = _confluence_search_mcp(cql)
    results = result.get("results", [])
    if not results:
        print("No results.")
        return
    print()
    for r in results:
        title = r.get("title", "?")
        space = r.get("resultGlobalContainer", {}).get("title", "?")
        base = "https://datadoghq.atlassian.net/wiki"
        url = base + r.get("url", "")
        excerpt = r.get("excerpt", "").replace("\n", " ")[:100]
        print(f"\033[1m{title}\033[0m  [{space}]")
        print(f"  {url}")
        if excerpt:
            print(f"  {excerpt}")
        print()


# ---------------------------------------------------------------------------
# Slack
#
# Discovery: https://mcp.slack.com/.well-known/oauth-authorization-server
#   authorization_endpoint: https://slack.com/oauth/v2_user/authorize
#   token_endpoint: https://slack.com/api/oauth.v2.user.access
#   token_endpoint_auth_methods: ["client_secret_post"]  (no dyn. reg.)
#
# Requires a registered Slack app with client_id + client_secret.
# To reuse Claude's client_id: find it in the OAuth URL when Claude
# first connects to Slack (look for client_id= in the browser URL).
# ---------------------------------------------------------------------------

_SLACK_AUTH_URL = "https://slack.com/oauth/v2_user/authorize"
_SLACK_TOKEN_URL = "https://slack.com/api/oauth.v2.user.access"
_SLACK_REDIRECT = "http://localhost:18081/callback"
_SLACK_SCOPES = (
    "search:read.public,search:read.private,"
    "chat:write,channels:history,channels:read,"
    "users:read"
)


def slack_auth():
    client_id = kc_get("slack_client_id")
    if not client_id:
        print(
            "Slack requires a registered app client_id."
            " To reuse Claude's app:"
        )
        print(
            "  Start a fresh Claude session, connect Slack MCP,"
            " and copy the client_id= from the browser OAuth URL."
        )
        client_id = input("Client ID: ").strip()
        kc_set("slack_client_id", client_id)

    client_secret = kc_get("slack_client_secret")
    if not client_secret:
        client_secret = input(
            "Client Secret (leave blank if public client): "
        ).strip()
        if client_secret:
            kc_set("slack_client_secret", client_secret)

    state = secrets.token_urlsafe(16)
    url = _SLACK_AUTH_URL + "?" + urllib.parse.urlencode({
        "client_id": client_id,
        "scope": _SLACK_SCOPES,
        "redirect_uri": _SLACK_REDIRECT,
        "state": state,
    })

    print("Opening browser for Slack auth...")
    webbrowser.open(url)

    cb = _wait_for_callback(18081)
    if cb.get("state") != state:
        raise RuntimeError("State mismatch — possible CSRF")

    post_data: dict = {
        "code": cb["code"],
        "client_id": client_id,
        "redirect_uri": _SLACK_REDIRECT,
    }
    if client_secret:
        post_data["client_secret"] = client_secret

    token = _post_form(_SLACK_TOKEN_URL, post_data)
    if not token.get("ok"):
        raise RuntimeError(
            f"Slack auth failed: {token.get('error')}"
        )

    access_token = token.get(
        "access_token"
    ) or token.get("authed_user", {}).get("access_token")
    if not access_token:
        raise RuntimeError("No access_token in Slack response")

    kc_set("slack_access_token", access_token)
    print("✓ Slack authenticated")


def _slack_token() -> str:
    token = kc_get("slack_access_token")
    if not token:
        print("Not authenticated. Run: pi-oauth auth slack")
        sys.exit(1)
    return token


def _slack_api(method: str, **kwargs) -> dict:
    req = urllib.request.Request(
        f"https://slack.com/api/{method}",
        data=urllib.parse.urlencode(kwargs).encode(),
        headers={
            "Authorization": f"Bearer {_slack_token()}",
            "Content-Type": "application/x-www-form-urlencoded",
        },
    )
    with urllib.request.urlopen(req) as resp:
        result = json.loads(resp.read())
    if not result.get("ok"):
        raise RuntimeError(
            f"Slack API error: {result.get('error')}"
        )
    return result


def slack_search(query: str):
    result = _slack_api(
        "search.messages", query=query, count=10, sort="timestamp"
    )
    matches = result.get("messages", {}).get("matches", [])
    if not matches:
        print("No results.")
        return
    print()
    for m in matches:
        ts = datetime.fromtimestamp(
            float(m["ts"]), tz=timezone.utc
        ).strftime("%Y-%m-%d %H:%M")
        channel = m.get("channel", {}).get("name", "?")
        user = m.get("username", "?")
        text = m.get("text", "").replace("\n", " ")[:100]
        print(
            f"\033[90m{ts}\033[0m \033[1m#{channel}\033[0m {user}"
        )
        print(f"  {text}")
        print()


def slack_send(channel: str, message: str):
    _slack_api("chat.postMessage", channel=channel, text=message)
    print(f"✓ Sent to {channel}")


# ---------------------------------------------------------------------------
# Auth status / revoke
# ---------------------------------------------------------------------------

def auth_status():
    def _s(k):
        return "✓ set" if kc_get(k) else "✗ missing"

    print("Atlassian:")
    print(f"  access_token : {_s('atlassian_access_token')}")
    print(f"  refresh_token: {_s('atlassian_refresh_token')}")
    print(f"  client_id    : {_s('atlassian_client_id')}")
    print("Slack:")
    print(f"  access_token : {_s('slack_access_token')}")
    print(f"  client_id    : {_s('slack_client_id')}")


def auth_revoke(service: str):
    if service == "atlassian":
        for k in [
            "atlassian_access_token",
            "atlassian_refresh_token",
            "atlassian_client_id",
        ]:
            kc_delete(k)
        print("✓ Atlassian credentials removed")
    elif service == "slack":
        for k in [
            "slack_access_token",
            "slack_client_id",
            "slack_client_secret",
        ]:
            kc_delete(k)
        print("✓ Slack credentials removed")
    else:
        print(f"Unknown service: {service}")
        sys.exit(1)


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

USAGE = """\
pi-oauth - OAuth CLI for Atlassian and Slack

  auth:
    pi-oauth auth atlassian           OAuth PKCE via MCP (like Claude)
    pi-oauth auth slack               OAuth 2.0 (needs client_id)
    pi-oauth auth status              Show credential status
    pi-oauth auth revoke atlassian    Remove Atlassian credentials
    pi-oauth auth revoke slack        Remove Slack credentials

  jira:
    pi-oauth jira sprint              Current sprint overview
    pi-oauth jira <KEY>               Show issue detail
    pi-oauth jira <KEY> <status>      Transition issue (partial match)

  confluence:
    pi-oauth confluence search <query>

  slack:
    pi-oauth slack search <query>
    pi-oauth slack send <#channel> <message>
"""


def main():
    args = sys.argv[1:]
    if not args:
        print(USAGE)
        return

    match args:
        case ["auth", "atlassian"]:
            atlassian_auth()
        case ["auth", "slack"]:
            slack_auth()
        case ["auth", "status"]:
            auth_status()
        case ["auth", "revoke", service]:
            auth_revoke(service)
        case ["jira", "sprint"]:
            jira_sprint()
        case ["jira", key] if key and ("-" in key or key.isupper()):
            jira_issue(key)
        case ["jira", key, *rest]:
            jira_transition(key, " ".join(rest))
        case ["confluence", "search", *words]:
            confluence_search(" ".join(words))
        case ["slack", "search", *words]:
            slack_search(" ".join(words))
        case ["slack", "send", channel, *words]:
            slack_send(channel, " ".join(words))
        case _:
            print(USAGE)
            sys.exit(1)


if __name__ == "__main__":
    main()
