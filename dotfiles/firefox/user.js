// Avoid WebRTC leaks
// Now using WebRTC Control
//user_pref("media.peerconnection.enabled", false);
// Restore session on startup
user_pref("browser.sessionstore.resume_session_once", true);
user_pref("browser.sessionstore.resume_from_crash", true);
user_pref("browser.sessionstore.resuming_after_os_restart", true);
user_pref("browser.sessionstore.max_resumed_crashes", 2);
// Black theme
user_pref("widget.content.gtk-theme-override", "arc");
// https://wiki.archlinux.org/index.php/Firefox/Tweaks#Unreadable_input_fields_with_dark_GTK+_themes
user_pref("browser.display.use_system_colors", false);
// Disable automatic updates (Useless on NixOS)
user_pref("app.update.auto", false);
// Remove update messages
user_pref("app.update.silent", false);
// Dark about:config
user_pref("browser.in-content.dark-mode", true);
