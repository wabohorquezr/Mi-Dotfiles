------------------
---- MONITORS ----
------------------

hl.monitor({
    output   = "",
    mode     = "highres",
    position = "auto",
    scale    = 1,
})


---------------------
---- MY PROGRAMS ----
---------------------

local mainMod     = "SUPER"
local terminal    = "kitty"
local fileManager = "ranger"
local menu        = "rofi -show run"
local inter       = "impala"
local bluet       = "bluetui"


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function () 
    hl.exec_cmd("hyprctl setcursor oreo_white_cursors 24")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme 'oreo_white_cursors'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size 24")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("waybar")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_THEME", "oreo_white_cursors")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 20,
        border_size = 2,
        col = {
            active_border   = { colors = {"rgba(33ccffee)", "rgba(00ff99ee)"}, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },
    decoration = {
        rounding       = 10,
        rounding_power = 2,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },
        blur = {
            enabled   = true,
            size      = 3,
            passes    = 1,
            vibrancy  = 0.1696,
        },
    },
    animations = {
        enabled = true,
    },
})

hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 238.1191, damping = 24.21279333 })

hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })

hl.config({
    dwindle = { preserve_split = true },
    master = { new_status = "master" },
    misc = { force_default_wallpaper = -1, disable_hyprland_logo = false },
    layers = { allow_new_top_layers_over_existing_fullscreen = true },
    input = {
        kb_layout = "us",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = { natural_scroll = false },
    },
})


---------------------
---- KEYBINDINGS ----
---------------------

hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(terminal .. " -e " .. fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd(terminal .. " -e " .. inter))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(terminal .. " -e " .. bluet))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("~/.config/rofi/scripts/wallpaper.sh"))

-- Abre Rofi al soltar la tecla SUPER sola (sin combinaciones previas)
hl.bind(mainMod .. " + Super_L", hl.dsp.exec_cmd("killall rofi || rofi -show drun -show-icons -icon-theme 'Papirus'"), { release = true })

hl.bind(mainMod .. " + backslash", hl.dsp.exec_cmd("~/.config/rofi/scripts/menu-atajos.sh"))

-- Sensor de tapa (Lid Switch)
hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("~/.config/hypr/scripts/lid.sh close"), { locked = true })
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("~/.config/hypr/scripts/lid.sh open"), { locked = true })

-- Navegación entre ventanas
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + grave", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + CTRL + SHIFT + grave", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mainMod .. " + SHIFT + grave", hl.dsp.window.move({ workspace = 1 }))

-- Control de ventanas con ratón
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Workspaces del 1 al 10
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Pantalla completa
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("hyprctl dispatch fullscreen 1"))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.exec_cmd("hyprctl dispatch fullscreen 0"))

-- Portapapeles y capturas
hl.bind("SUPER + slash", hl.dsp.exec_cmd("cliphist list | rofi -dmenu -p 'Historial' | cliphist decode | wl-copy"))
hl.bind("Print", hl.dsp.exec_cmd("grim - | wl-copy"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("sh -c 'grim -g \"$(slurp)\" - | tee ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png | wl-copy && notify-send \"Captura tomada\" \"Guardada y copiada al portapapeles\"'"))

-- Controles multimedia y brillo
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 2.5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 2.5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})
