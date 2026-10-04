-- -----------------------------------------------------
-- Custom (personal additions, kept across ML4W updates)
-- Loaded by ML4W's hyprland.lua after its conf/* files,
-- so settings here override ML4W's defaults.
-- -----------------------------------------------------

-- Keyboard layout: Finnish without dead keys, so ^ ~ ´ ` ¨ type immediately
hl.config({
    input = {
        kb_layout  = "fi",
        kb_variant = "nodeadkeys",
    },
})

-- NVIDIA GTX 1060 (same as ML4W's "nvidia" environment variant)
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

-- MSI MAG251RX: its preferred mode is 60 Hz, so ask for 240 Hz explicitly
hl.monitor({
    output   = "DP-1",
    mode     = "1920x1080@239.96",
    position = "0x0",
    scale    = 1,
})

-- Laptop panel (eDP-1) is failing (line noise), so turn it off whenever the
-- external monitor on DP-1 is connected. Checked when the config loads (login or
-- `hyprctl reload`): booting without DP-1 keeps the panel on instead of a black screen.
local function connector_connected(name)
    for card = 0, 3 do
        local f = io.open("/sys/class/drm/card" .. card .. "-" .. name .. "/status", "r")
        if f then
            local status = f:read("*l")
            f:close()
            return status == "connected"
        end
    end
    return false
end

if connector_connected("DP-1") then
    hl.monitor({ output = "eDP-1", disabled = true })
end

-- 1Password: start hidden in the tray
hl.on("hyprland.start", function ()
    hl.exec_cmd("1password --silent")
end)

-- Logitech MX Anywhere 2 (Unifying receiver, 1000 DPI set in Solaar)
hl.device({
    name          = "logitech-mx-anywhere-2-1",
    sensitivity   = -0.25,    -- -1.0 (slow) … 1.0 (fast); with flat accel ≈ 0.75x speed
    accel_profile = "flat",   -- no acceleration
    scroll_factor = 1.5,
})

-- 1Password (its in-app global shortcuts don't work under Wayland)
hl.bind("CTRL + SHIFT + space",       hl.dsp.exec_cmd("1password --quick-access"), { description = "1Password Quick Access" })
hl.bind("SUPER + SHIFT + P",          hl.dsp.exec_cmd("1password"),                { description = "Open 1Password" })
