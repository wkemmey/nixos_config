{ host, ... }:
{
  windowrule = [
    # Lightworks-specific fixes for rendering issues
    # Force XWayland rendering (Lightworks doesn't support native Wayland)
    "tag +video-editor, class:^(lightworks)$"

    # Disable window effects that can interfere with Lightworks rendering
    "noblur, class:^(lightworks)$"
    "noborder, class:^(lightworks)$, fullscreen:1"
    "noshadow, class:^(lightworks)$"

    # Force opaque rendering (no transparency)
    "opaque, class:^(lightworks)$"

    # Disable VRR/VFR for Lightworks to prevent frame timing issues
    "immediate, class:^(lightworks)$"

    # Keep Lightworks windows on top of other video-editor tagged windows
    "stayfocused, class:^(lightworks)$, floating:1"

    # Center any Lightworks dialogs
    "center, class:^(lightworks)$, floating:1"
    "float, class:^(lightworks)$, title:^((?!Lightworks).)*$"

    # Maximize main Lightworks window
    "maximize, class:^(lightworks)$, title:^(Lightworks)$"

    # Prevent idle while Lightworks is running
    "idleinhibit always, class:^(lightworks)$"
  ];
}
