-- Constants
local CMFD_NAV_SET_INDEX = get_param_handle("CMFD_NAV_SET_INDEX")
local CMFD_NAV_SET_LAT = get_param_handle("CMFD_NAV_SET_LAT")
local CMFD_NAV_SET_LON = get_param_handle("CMFD_NAV_SET_LON")
local CMFD_NAV_SET_ELV = get_param_handle("CMFD_NAV_SET_ELV")
local CMFD_NAV_SET_TIME = get_param_handle("CMFD_NAV_SET_TIME")

-- Inits

ufcp_mark_mode = UFCP_MARK_MODE_IDS.ONTOP
ufcp_mark_mkpt = 89
ufcp_mark_lat = nil
ufcp_mark_lon = nil
ufcp_mark_elev = nil
ufcp_mark_designated = false


-- Methods

local function ufcp_wpt_save()
    if CMFD_NAV_SET_INDEX:get() < 0  then
        CMFD_NAV_SET_LAT:set(ufcp_mark_lat)
        CMFD_NAV_SET_LON:set(ufcp_mark_lon)
        CMFD_NAV_SET_ELV:set(ufcp_mark_elev)
        CMFD_NAV_SET_TIME:set(get_absolute_model_time())
        CMFD_NAV_SET_INDEX:set(ufcp_mark_mkpt)
    end
end

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

function mark()
    local get_method
    if ufcp_mark_mode == UFCP_MARK_MODE_IDS.ONTOP then
        get_method = get_ontop
    elseif ufcp_mark_mode == UFCP_MARK_MODE_IDS.HUD then
        get_method = get_hud
    elseif ufcp_mark_mode == UFCP_MARK_MODE_IDS.FLIR then
        get_method = get_flir
    end

    -- TODO elevation should be picked from BARO when it's the selected sensor or when RALT is not available

    ufcp_mark_lat, ufcp_mark_lon, ufcp_mark_elev = get_method()
    ufcp_mark_designated = true
end

local function save()
    if ufcp_mark_lat ~= nil and ufcp_mark_lon ~= nil and ufcp_mark_elev ~= nil then
        ufcp_wpt_save()
        
        ufcp_sel_format = UFCP_FORMAT_IDS.MAIN
        ufcp_mark_mkpt = ((ufcp_mark_mkpt-80) - 1) % 10 + 80    -- Update to next MKPT
    end
end

local function clear()
    ufcp_mark_designated = false
    ufcp_mark_lat = nil
    ufcp_mark_lon = nil
    ufcp_mark_elev = nil
end

function update_mark()
    ufcp_nav_only()
    
    local lat = nil
    local lon = nil
    local elev = nil

    if ufcp_mark_designated then
        lat = ufcp_mark_lat
        lon = ufcp_mark_lon
        elev = ufcp_mark_elev
    elseif ufcp_mark_mode == UFCP_MARK_MODE_IDS.ONTOP then
        lat, lon, elev = get_ontop()
    elseif ufcp_mark_mode == UFCP_MARK_MODE_IDS.ONTOP then
        lat, lon, elev = get_hud()
    elseif ufcp_mark_mode == UFCP_MARK_MODE_IDS.ONTOP then
        lat, lon, elev = get_flir()
    end

    local text = ""
    text = text .. "   MARK *"

    -- Mode
    if ufcp_mark_mode == UFCP_MARK_MODE_IDS.ONTOP then
        text = text .. "ONTOP"
    elseif ufcp_mark_mode == UFCP_MARK_MODE_IDS.HUD then
        text = text .. "HUD  "
    elseif ufcp_mark_mode == UFCP_MARK_MODE_IDS.FLIR then
        text = text .. "FLIR "
    end

    text = text .. "*\n"

    -- Mark Waypoint
    text = text .. "MKPT  " .. ufcp_mark_mkpt .. "       \n"

    -- Latitude
    text = text .. "LAT  "
    if lat ~= nil then
        if lat >= 0 then text = text .. "N " else text = text .. "S " end
        text = text .. string.format("%02.0f$%05.2f'", math.floor(math.abs(lat)), (math.abs(lat)-math.floor(math.abs(lat)))*60)
    else
        text = text .. "N XX$XX.XX'"
    end
    text = text .. " \n"

    -- Longitude
    text = text .. "LON  "
    if lon ~= nil then
        if lon >= 0 then text = text .. "E" else text = text .. "W" end
        text = text .. string.format("%03.0f$%05.2f'", math.floor(math.abs(lon)), (math.abs(lon)-math.floor(math.abs(lon)))*60)
    else
        text = text .. "EXXX$XX.XX'"
    end
    text = text .. " \n"

    -- Elevation
    text = text .. "ELEV "
    if elev ~= nil then
        text = text .. string.format("%4d", elev)
    else
        text = text .. "XXXX"
    end
    text = text .. " FT     "

    if ufcp_mark_designated then
       text = blink_text(text,33,3)
       text = blink_text(text,51,3)
    end

    UFCP_TEXT:set(text)
end

function SetCommandMark(command,value)
    -- TODO pressing Designate on the Joystick should have the same effect as pressing UFCP_7 (MARK)
    if command == device_commands.UFCP_JOY_RIGHT and value == 1 then
        ufcp_mark_mode = (ufcp_mark_mode+1) % 3
        clear()
    elseif command == device_commands.UFCP_ENTR and value == 1 then
        if ufcp_mark_designated then
            save()
        else
            mark()
            save()
        end
    elseif command == device_commands.UFCP_CLR and value == 1 then
        clear()
    elseif (command == device_commands.UFCP_7 and value == 1)
    -- or (elseif command == device_commands.DESIGNATE and value == 1)
    then
        ufcp_mark_mode = UFCP_MARK_MODE_IDS.ONTOP
        mark()
    end
end