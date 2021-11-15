-- Constants
local CMFD_NAV_FYT = get_param_handle("CMFD_NAV_FYT")


local SEL_IDS = {
    FYT = 0,
}

-- Inits
ufcp_fix_mode = UFCP_MARK_MODE_IDS.ONTOP
ufcp_fix_wp = 0
ufcp_fix_wp_type = 0
ufcp_fix_lat = nil
ufcp_fix_lon = nil
ufcp_fix_elev = nil
ufcp_fix_delta = 0
ufcp_fix_designated = false

-- Methods

local function get_ontop()
    local lat_m, alt_m, lon_m = sensor_data.getSelfCoordinates()
    local lat, lon = Terrain.convertMetersToLatLon(lat_m, lon_m)
    local elev = alt_m * 3.28084

    return lat, lon, elev
end

local function get_hud()
    -- TOOD Get HUD coordinates
    local lat = nil
    local lon = nil
    local elev = nil

    return lat, lon, elev
end

local function get_flir()
    -- Get FLIR coordinates
    local lat = nil
    local lon = nil
    local elev = nil

    return lat, lon, elev
end

local function get_delta() 
    -- TODO calculate the delta

    return 0
end

function fix() 
    local get_method
    if ufcp_mark_mode == UFCP_MARK_MODE_IDS.ONTOP then
        get_method = get_ontop
    elseif ufcp_mark_mode == UFCP_MARK_MODE_IDS.HUD then
        get_method = get_hud
    elseif ufcp_mark_mode == UFCP_MARK_MODE_IDS.FLIR then
        get_method = get_flir
    end

    -- TODO elevation should be picked from BARO when it's the selected sensor or when RALT is not available

    ufcp_fix_wp = CMFD_NAV_FYT:get()
    ufcp_fix_lat, ufcp_fix_lon, ufcp_fix_elev = get_method()
    ufcp_fix_designated = true
    ufcp_fix_delta = get_delta()

end

local function save()
    if ufcp_fix_lat ~= nil and ufcp_fix_lon ~= nil and ufcp_fix_elev ~= nil then
        -- TODO update inertial system.

        ufcp_sel_format = UFCP_FORMAT_IDS.MAIN
    end
end

local function clear()
    ufcp_fix_designated = false
    ufcp_fix_lat = nil
    ufcp_fix_lon = nil
    ufcp_fix_elev = nil
end

function update_fix()
    ufcp_nav_only()
    ufcp_ins_only()
    
    local text = ""
    text = text .. "  FIX *"

    -- Mode
    if ufcp_fix_mode == UFCP_MARK_MODE_IDS.ONTOP then
        text = text .. "ONTOP"
    elseif ufcp_fix_mode == UFCP_MARK_MODE_IDS.HUD then
        text = text .. "HUD  "
    elseif ufcp_fix_mode == UFCP_MARK_MODE_IDS.FLIR then
        text = text .. "FLIR "
    end

    text = text .. "*\n\n"

    -- WP
    text = text .. "WPN " .. string.format("%2d", ufcp_fix_wp) .. "^\n\n"

    -- Delta
    text = text .. "  DELTA " .. string.format("%04.1f", ufcp_fix_delta) .. " NM"

    UFCP_TEXT:set(text)
end

function SetCommandFix(command,value)
    if command == device_commands.UFCP_JOY_RIGHT and value == 1 then
        ufcp_fix_mode = (ufcp_fix_mode+1) % 3
        clear()
    elseif command == device_commands.UFCP_ENTR and value == 1 then
        if ufcp_fix_designated then
            save()
        else
            fix()
        end
    elseif ufcp_main_sel == SEL_IDS.FYT and AVIONICS_ANS_MODE:get() ~= AVIONICS_ANS_MODE_IDS.GPS and ufcp_cmfd_ref ~= nil then
        if command == device_commands.UFCP_UP and value == 1 then 
            -- TODO Increase to a valid waypoint
        elseif command == device_commands.UFCP_DOWN and value == 1 then
            -- TODO Decrease to a valid waypoint
        end
    elseif command == device_commands.UFCP_CLR and value == 1 then
        clear()
    end
end