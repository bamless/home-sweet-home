-- This is an example Hyprland Lua config file.
-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/Start/

-- Please note not all available settings / options are set here.
-- For a full list, see the wiki.

-- You can split this configuration into multiple files.
-- Create your files separately and then require them from this file, e.g.:
-- require("myColors")


------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

-- Unscale XWayland
hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})


---------------
--- PLUGINS ---
---------------

-- Configure hy3.
-- See https://github.com/outfoxxed/hy3#configuration
hl.config({
    plugin = {
        hy3 = {
            autotile = {
                enable = true,
            },
        },
    },
})


---------------------
---- MY PROGRAMS ----
---------------------

-- Lua config basics: https://wiki.hypr.land/Configuring/Start/
local terminal = "alacritty"
local menu = os.getenv("HOME") .. "/.config/rofi/launchers/type-1/launcher.sh"
local menuTheme = "-theme " .. os.getenv("HOME") .. "/.config/rofi/launchers/type-1/style-5.rasi"


-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpm reload -n")
    hl.exec_cmd('tmux setenv -g HYPRLAND_INSTANCE_SIGNATURE "$HYPRLAND_INSTANCE_SIGNATURE"')
    hl.exec_cmd(os.getenv("HOME") .. "/.config/i3/scripts/polkit-agent.sh")

    -- APPS
    -- Keep the terminal on workspace 1 without switching to it.
    hl.exec_cmd("uwsm app -- " .. terminal, { workspace = "1 silent" })
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
-- NOTE: since this config launches apps through uwsm, Hyprland recommends putting
-- most toolkit/NVIDIA/cursor variables in ~/.config/uwsm/env, and HYPR*/AQ_* in
-- ~/.config/uwsm/env-hyprland. These are kept here to preserve your current config.
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- NVIDIA specific settings
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

-- QT Theming
-- hl.env("QT_SCALE_FACTOR", "2")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct:qt6ct")


-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 10,

        border_size = 1,

        -- See https://wiki.hypr.land/Configuring/Basics/Variables/#variable-types
        -- for color value types.
        col = {
            active_border = {
                colors = { "rgba(33ccffee)", "rgba(00ff99ee)" },
                angle = 45,
            },
            inactive_border = "rgba(595959aa)",
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps.
        resize_on_border = false,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/
        -- before you turn this on.
        allow_tearing = false,

        layout = "hy3",
    },

    decoration = {
        rounding = 8,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },

        blur = {
            enabled  = true,
            size     = 5,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("myBezier", {
    type = "bezier",
    points = { { 0.05, 0.9 }, { 0.1, 1.05 } },
})

hl.animation({ leaf = "windows",          enabled = true, speed = 2, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut",       enabled = true, speed = 2, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border",           enabled = true, speed = 6, bezier = "default" })
hl.animation({ leaf = "borderangle",      enabled = true, speed = 6, bezier = "default" })
hl.animation({ leaf = "fade",             enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "workspaces",       enabled = true, speed = 2, bezier = "default" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 3, bezier = "default", style = "fade" })

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
    master = {
        new_status = "master",
    },
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/#misc
hl.config({
    misc = {
        force_default_wallpaper = -1,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = false,   -- If true disables the random Hyprland logo / anime girl background. :(
        disable_splash_rendering = true,
    },
})

-- Swaync
-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/#layer-rules
hl.layer_rule({
    name = "layerrule-1",
    match = { namespace = "swaync-control-center" },
    blur = true,
    ignore_alpha = 0.5,
})

hl.layer_rule({
    name = "layerrule-2",
    match = { namespace = "swaync-notification-window" },
    blur = true,
    ignore_alpha = 0.5,
})

hl.layer_rule({
    name = "layerrule-3",
    match = { namespace = "gtk-layer-shell" },
    blur = true,
})


---------------
---- INPUT ----
---------------

-- https://wiki.hypr.land/Configuring/Basics/Variables/#input
hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,
        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = true,
        },
    },
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5,
})


---------------------
---- KEYBINDINGS ----
---------------------

-- See https://wiki.hypr.land/Configuring/Basics/Binds/
local mainMod = "SUPER" -- Sets "Windows" key as main modifier
local hy3 = hl.plugin.hy3

-- Lock & suspend
hl.bind(mainMod .. " + CTRL + P", hl.dsp.exec_cmd("systemctl suspend"))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("systemctl suspend"), { locked = true })

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + X", hy3.kill_active())
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd('loginctl terminate-user ""'))
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.window.float({ action = "toggle" }))
-- Old config had an empty `layoutmsg` bind here for dwindle; it had no useful argument.
-- hl.bind(mainMod .. " + E", hl.dsp.layout("...")) -- dwindle
-- hl.bind(mainMod .. " + P", hl.dsp.window.pseudo()) -- dwindle

-- rofi
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd('rofi ' .. menuTheme .. ' -show calc -modi calc -no-show-match -no-sort -calc-command "echo -n \'{result}\' | xclip -sel c"'))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("rofi " .. menuTheme .. " -show window -theme " .. os.getenv("HOME") .. "/.config/rofi/launchers/type-1/style-5.rasi"))

-- Other apps
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("1password --quick-access"))

-- i3 my beloved <3
hl.bind(mainMod .. " + W", hy3.change_group("tab"))
hl.bind(mainMod .. " + E", hy3.change_group("opposite")) -- untab / opposite, preserving your old bind
hl.bind(mainMod .. " + Z", hy3.make_group("h"))
hl.bind(mainMod .. " + V", hy3.make_group("v"))
hl.bind(mainMod .. " + A", hy3.change_focus("raise"))
hl.bind(mainMod .. " + D", hy3.change_focus("lower"))

-- Move focus with mainMod + hjkl
hl.bind(mainMod .. " + H", hy3.move_focus("l"))
hl.bind(mainMod .. " + L", hy3.move_focus("r"))
hl.bind(mainMod .. " + K", hy3.move_focus("u"))
hl.bind(mainMod .. " + J", hy3.move_focus("d"))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hy3.move_to_workspace(tostring(i), { follow = false }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + SHIFT + H", hy3.move_window("l"))
hl.bind(mainMod .. " + SHIFT + L", hy3.move_window("r"))
hl.bind(mainMod .. " + SHIFT + K", hy3.move_window("u"))
hl.bind(mainMod .. " + SHIFT + J", hy3.move_window("d"))

-- Screenshot
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("hyprshot -m output"))
hl.bind(mainMod .. " + SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind(mainMod .. " + CTRL + PRINT", hl.dsp.exec_cmd("hyprshot -m window"))

-- Color picker
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("hyprpicker | wl-copy"))

-- Swaync
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw"))

-- --- Resize submap ---
-- See https://wiki.hypr.land/Configuring/Basics/Binds/#submaps
hl.bind(mainMod .. " + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
    hl.bind("L", hl.dsp.window.resize({ x = 25,  y = 0,   relative = true }), { repeating = true }) -- Increase width
    hl.bind("H", hl.dsp.window.resize({ x = -25, y = 0,   relative = true }), { repeating = true }) -- Decrease width
    hl.bind("K", hl.dsp.window.resize({ x = 0,   y = -25, relative = true }), { repeating = true }) -- Decrease height
    hl.bind("J", hl.dsp.window.resize({ x = 0,   y = 25,  relative = true }), { repeating = true }) -- Increase height

    -- Exit resize mode
    hl.bind("escape", hl.dsp.submap("reset"))
    hl.bind("Return", hl.dsp.submap("reset"))
end)
-- --- Resize submap end ---

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("light -A 10 && pkill -RTMIN+8 waybar"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("light -U 10 && pkill -RTMIN+8 waybar"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/ for more
-- See https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/ for workspace rules

-- Show polkit agent popup in current workspace instead of always on workspace 1.
hl.window_rule({
    name = "polkit_agent",
    match = { class = "polkit-mate-authentication-agent-1" },
    float = true,
    center = true,
    workspace = "special:polkit",
    suppress_event = "activate",
})

-- Ignore maximize requests from apps. You'll probably like this.
hl.window_rule({
    name = "windowrule-1",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
    name = "windowrule-2",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})

hl.window_rule({
    name = "windowrule-3",
    match = { class = "^(Google-chrome)$" },
    tile = true,
})
