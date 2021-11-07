local CMFD_NAV_GET_INDEX = get_param_handle("CMFD_NAV_GET_INDEX")
local CMFD_NAV_GET_LAT = get_param_handle("CMFD_NAV_GET_LAT")
local CMFD_NAV_GET_LON = get_param_handle("CMFD_NAV_GET_LON")
local CMFD_NAV_GET_ELV = get_param_handle("CMFD_NAV_GET_ELV")
local CMFD_NAV_GET_TIME = get_param_handle("CMFD_NAV_GET_TIME")
local CMFD_NAV_GET_RDY = get_param_handle("CMFD_NAV_GET_RDY")
local CMFD_NAV_SET_INDEX = get_param_handle("CMFD_NAV_SET_INDEX")
local CMFD_NAV_SET_LAT = get_param_handle("CMFD_NAV_SET_LAT")
local CMFD_NAV_SET_LON = get_param_handle("CMFD_NAV_SET_LON")
local CMFD_NAV_SET_ELV = get_param_handle("CMFD_NAV_SET_ELV")
local CMFD_NAV_SET_TIME = get_param_handle("CMFD_NAV_SET_TIME")
local CMFD_NAV_FYT = get_param_handle("CMFD_NAV_FYT")
local CMFD_NAV_FYT_SET = get_param_handle("CMFD_NAV_FYT_SET")

-- Constants
local GEO_SEL_IDS = {
    FYT = 0,
    NUM = 0,
    LAT = 1,
    LON = 2,
    ELEV = 3,
    TOFT = 4,
    PAGE = 5
}

local UTM_SEL_IDS = {
    FYT = 0,
    NUM = 0,
    GZ_LON = 1,
    GZ_LAT = 2,
    DG_LON = 3,
    DG_LAT = 4,
    EASTING = 5,
    NORTHING = 6,
    ELEV = 7,
    TOFT = 8,
    PAGE = 9
}

-- Variables
ufcp_wpt_fyt = true
ufcp_wpt_num_last = -1
ufcp_wpt_num = 0
ufcp_wpt_lat = 0
ufcp_wpt_lon = 0
ufcp_wpt_elev = 0
ufcp_wpt_time = 0

local ufcp_wpt_utm = {
    gridzone = "XXX",
    digraph = "XX",
    easting = "XXXX",
    northing = "XXXX",
    active = false,
    sel = 0,
    max_sel = 10,
}


local ufcp_wpt_save_now = false


ufcp_wpt_sel = 0
local ufcp_wpt_max_sel = 6


-- Methods

-- FYT query
-- Check if query is free by asserting that CMFD_NAV_GET_RDY == -1 and CMFD_NAV_GET_RDY == 0
-- Set CMFD_NAV_GET_INDEX to desired FYT index
-- Read LAT, LON, ELV and TIME when  CMFD_NAV_GET_RDY == 1
-- Set CMFD_NAV_GET_RDY = -1 and CMFD_NAV_GET_RDY = 0 to release query
local function ufcp_wpt_load()
    if ufcp_wpt_num ~= ufcp_wpt_num_last then
        if CMFD_NAV_GET_INDEX:get() < 0 and CMFD_NAV_GET_RDY:get() == 0 then
            -- start query
            CMFD_NAV_GET_INDEX:set(ufcp_wpt_num)
        elseif CMFD_NAV_GET_INDEX:get() == ufcp_wpt_num and CMFD_NAV_GET_RDY:get() == 1 then
            -- read and free query
            ufcp_wpt_lat = CMFD_NAV_GET_LAT:get()
            ufcp_wpt_lon = CMFD_NAV_GET_LON:get()
            ufcp_wpt_elev = CMFD_NAV_GET_ELV:get()
            ufcp_wpt_time = CMFD_NAV_GET_TIME:get()
            CMFD_NAV_GET_INDEX:set(-1)
            CMFD_NAV_GET_RDY:set(0)
            ufcp_wpt_num_last = ufcp_wpt_num

            local mgrs = coordinate:LLtoMGRS(ufcp_wpt_lat, ufcp_wpt_lon)
            ufcp_wpt_utm.gridzone = mgrs.gridzone
            ufcp_wpt_utm.digraph = mgrs.digraph
            ufcp_wpt_utm.easting = mgrs.easting
            ufcp_wpt_utm.northing = mgrs.northing
        end
    end
end

local function ufcp_wpt_save()
    if ufcp_wpt_save_now then
        if CMFD_NAV_SET_INDEX:get() < 0  then
            CMFD_NAV_SET_LAT:set(ufcp_wpt_lat)
            CMFD_NAV_SET_LON:set(ufcp_wpt_lon)
            CMFD_NAV_SET_ELV:set(ufcp_wpt_elev)
            CMFD_NAV_SET_TIME:set(ufcp_wpt_time)
            CMFD_NAV_SET_INDEX:set(ufcp_wpt_num)
            ufcp_wpt_save_now = false
        end
    end
end

-- DEBUG
--[[function update_wpt()
    local text = ""
    text = text .. " WPT "

    UFCP_TEXT:set(text)
end]]

local function valid_geo_input()
    if ufcp_wpt_lat < -90 or ufcp_wpt_lat > 90 then
        return false
    end

    if ufcp_wpt_lon < -180 or ufcp_wpt_lon > 180 then
        return false
    end

    if ufcp_wpt_elev < -1500 or ufcp_wpt_elev > 40000 then
        return false
    end

    return true
end

local function valid_utm_input()
    if tonumber(ufcp_wpt_utm.gridzone:sub(1,2)) == nil then
        return false
    end

    if tonumber(ufcp_wpt_utm.easting) == nil then
        return false
    end

    if tonumber(ufcp_wpt_utm.northing) == nil then
        return false
    end

    return true
end

local function ufcp_wpt_num_validate(text, save)
    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and number >= 0 and number <= 99 then
            if ufcp_wpt_fyt then
                CMFD_NAV_FYT_SET:set(number) -- Try to set the fyt to the selected value
            else
                ufcp_wpt_num = number
            end

            text = ""
            SetCommandWpt(device_commands.UFCP_JOY_DOWN, 1)
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local function ufcp_wpt_lat_validate(text, save)
    -- Check if hemisphere is on auto
    if text:len() == 1 then
        if ufcp_nav_misc_zone_auto then
            if ufcp_nav_misc_zone_y == 1 then text = "N " .. text
            elseif ufcp_nav_misc_zone_y == -1 then text = "S " .. text
            else text=""
            end
        else
            if text == "2" then text = "N "
            elseif text == "8" then text = "S "
            else text=""
            end
        end
    end

    -- Fill the remaining digits on enter
    if save then while text:len() < 5 do text = text .. "0" end end

    if text:len() == 5 then
        text = text:sub(1,4) .. "$" .. text:sub(5,5)
    end

    -- Fill the remaining digits on enter
    if save then while text:len() < 8 do text = text .. "0" end end
    
    if text:len() == 8 then
        text = text:sub(1,7) .. "." .. text:sub(8,8)
    end

    -- Fill the remaining digits on enter
    if save then while text:len() < 10 do text = text .. "0" end end

    if text:len() == 10 then
        text = text .. "'"
    end

    if text:len() >= ufcp_edit_lim or save then
        local number = (text:sub(1,1) == "N" and 1 or -1) * (tonumber(text:sub(3,4) + tonumber(text:sub(6,7) / 60 + tonumber(text:sub(9,10) / 6000))))
        if number >= -90 and number <= 90 then
            ufcp_wpt_lat = number
            if valid_geo_input() then
                ufcp_wpt_save_now = true
            end
            text = ""
            ufcp_wpt_sel = ufcp_wpt_sel + 1 % ufcp_wpt_max_sel
        else
            ufcp_edit_invalid = true
        end
    end

    return text
end

local function ufcp_wpt_lon_validate(text, save)
        -- Check if hemisphere is on auto
    if text:len() == 1 then
        if ufcp_nav_misc_zone_auto then
            if ufcp_nav_misc_zone_x == 1 then text = "E" .. text
            elseif ufcp_nav_misc_zone_x == -1 then text = "W" .. text
            else text=""
            end
        else
            if text == "4" then text = "E"
            elseif text == "6" then text = "W"
            else text=""
            end
        end
    end

    -- Fill the remaining digits on enter
    if save then while text:len() < 5 do text = text .. "0" end end

    if text:len() == 5 then
        text = text:sub(1,4) .. "$" .. text:sub(5,5)
    end

    -- Fill the remaining digits on enter
    if save then while text:len() < 8 do text = text .. "0" end end
    
    if text:len() == 8 then
        text = text:sub(1,7) .. "." .. text:sub(8,8)
    end

    -- Fill the remaining digits on enter
    if save then while text:len() < 10 do text = text .. "0" end end

    if text:len() == 10 then
        text = text .. "'"
    end

    if text:len() >= ufcp_edit_lim or save then
        local number = (text:sub(1,1) == "E" and 1 or -1) * (tonumber(text:sub(2,4) + tonumber(text:sub(6,7) / 60 + tonumber(text:sub(9,10) / 6000))))
        if number >= -180 and number <= 180 then
            ufcp_wpt_lon = number
            if valid_geo_input() then
                ufcp_wpt_save_now = true
            end
            text = ""
            ufcp_wpt_sel = ufcp_wpt_sel + 1 % ufcp_wpt_max_sel
        else
            ufcp_edit_invalid = true
        end
    end
    
    return text
end

local function ufcp_wpt_elev_validate(text, save)
    if text == "0" then
        text = "-"
    end

    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and number >= -1500 and number <= 40000 then
            ufcp_wpt_elev = number
            if valid_geo_input() then
                ufcp_wpt_save_now = true
            end
            text = ""

            -- Move to the next field
            if not ufcp_wpt_utm.active then
                ufcp_wpt_sel = ufcp_wpt_sel + 1 % ufcp_wpt_max_sel
            else
                ufcp_wpt_utm.sel = ufcp_wpt_utm.sel + 1 % ufcp_wpt_utm.max_sel
            end
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local function ufcp_wpt_toft_validate(text, save)
    text = text:gsub(":", "")

    -- Fill the remaining digits on enter
    if save then
        while text:len() < ufcp_edit_lim - 2 do
            text = "0" .. text
        end
    end

    if text:len() > 2 then
        text = text:sub(1, text:len()-2) .. ":" .. text:sub(text:len()-1,text:len())
    end
    if text:len() > 5 then
        text = text:sub(1, text:len()-5) .. ":" .. text:sub(text:len()-4,text:len())
    end

    if text:len() >= ufcp_edit_lim or save then
        local length = text:len()
        if tonumber(text:sub(length-1, length)) < 60
        and (length < 4 or tonumber(text:sub(length-4, length-3)) < 60)
        and (length < 8 or tonumber(text:sub(length-7, length-6)) < 24)
        then    --check if time string is valid
            local number = tonumber(text:sub(length-1, length)) + tonumber(text:sub(length-4, length-3)) * 60 + tonumber(text:sub(length-7, length-6)) * 3600
            ufcp_wpt_time = number
            if valid_geo_input() then
                ufcp_wpt_save_now = true
            end

            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

-- Update the lat and lon based on mgrs variables
local function mgrs_to_ll()
    local ll = coordinate:MGRStoLL(ufcp_wpt_utm.gridzone, ufcp_wpt_utm.digraph, ufcp_wpt_utm.easting, ufcp_wpt_utm.northing)
    ufcp_wpt_lat = ll.latitude
    ufcp_wpt_lon = ll.longitude
end

local function ufcp_wpt_utm_gridzone_validate(text, save)
    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and number >= 1 and number <= 60 then
            ufcp_wpt_utm.gridzone = string.format("%02d", number) .. ufcp_wpt_utm.gridzone:sub(3,3)
            if valid_utm_input() then
                mgrs_to_ll()
            
                if valid_geo_input() then
                    ufcp_wpt_save_now = true
                end
            end
            text = ""
            ufcp_wpt_utm.sel = ufcp_wpt_utm.sel + 1 % ufcp_wpt_utm.max_sel
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local function ufcp_wpt_utm_easting_validate(text, save)
    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        number = number * 10 -- The input format is 4 digits, while the full format is 5 digits
        if number ~= nil then
            ufcp_wpt_utm.easting = string.format("%05d", number)
            if valid_utm_input() then
                mgrs_to_ll()
            
                if valid_geo_input() then
                    ufcp_wpt_save_now = true
                end
            end
            text = ""
            ufcp_wpt_utm.sel = ufcp_wpt_utm.sel + 1 % ufcp_wpt_utm.max_sel
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local function ufcp_wpt_utm_northing_validate(text, save)
    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        number = number * 10 -- The input format is 4 digits, while the full format is 5 digits
        if number ~= nil then
            ufcp_wpt_utm.northing = string.format("%05d", number)
            if valid_utm_input() then
                mgrs_to_ll()
            
                if valid_geo_input() then
                    ufcp_wpt_save_now = true
                end
            end
            text = ""
            ufcp_wpt_utm.sel = ufcp_wpt_utm.sel + 1 % ufcp_wpt_utm.max_sel
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local function sel_next_gz_lat()
    local letter = ufcp_wpt_utm.gridzone:sub(3,3)
    local letterIdx = 1
    for i, v in ipairs(coordinate.digraphArrayN) do
        if v == letter then
            letterIdx = i + 1
            break
        end
    end
    
    letterIdx = math.max(math.min(letterIdx % 23, 22), 3)
    letter = coordinate.digraphArrayN[letterIdx]
    
    ufcp_wpt_utm.gridzone = ufcp_wpt_utm.gridzone:sub(1,2) .. letter
    if valid_utm_input() then
        mgrs_to_ll()
    
        if valid_geo_input() then
            ufcp_wpt_save_now = true
        end
    end
end

local function sel_next_dg_lon()
    local letter = ufcp_wpt_utm.digraph:sub(1,1)
    local letterIdx = 1
    for i, v in ipairs(coordinate.digraphArrayN) do
        if v == letter then
            letterIdx = i + 1
            break
        end
    end
    
    letterIdx = (letterIdx - 1) % 24 + 1
    letter = coordinate.digraphArrayN[letterIdx]
    
    ufcp_wpt_utm.digraph = letter .. ufcp_wpt_utm.digraph:sub(2,2)
    if valid_utm_input() then
        mgrs_to_ll()
    
        if valid_geo_input() then
            ufcp_wpt_save_now = true
        end
    end
end

local function sel_next_dg_lat()
    local letter = ufcp_wpt_utm.digraph:sub(2,2)
    local letterIdx = 1
    for i, v in ipairs(coordinate.digraphArrayN) do
        if v == letter then
            letterIdx = i + 1
            break
        end
    end
    
    letterIdx = (letterIdx - 1) % 24 + 1
    letter = coordinate.digraphArrayN[letterIdx]
    
    ufcp_wpt_utm.digraph = ufcp_wpt_utm.digraph:sub(1,1) .. letter
    if valid_utm_input() then
        mgrs_to_ll()
    
        if valid_geo_input() then
            ufcp_wpt_save_now = true
        end
    end
end

local GEO_FIELD_INFO = {
    [GEO_SEL_IDS.NUM] = {2, ufcp_wpt_num_validate},
    [GEO_SEL_IDS.LAT] = {11, ufcp_wpt_lat_validate},
    [GEO_SEL_IDS.LON] = {11, ufcp_wpt_lon_validate},
    [GEO_SEL_IDS.ELEV] = {5, ufcp_wpt_elev_validate},
    [GEO_SEL_IDS.TOFT] = {8, ufcp_wpt_toft_validate}
}

local UTM_FIELD_INFO = {
    [UTM_SEL_IDS.NUM] = {2, ufcp_wpt_num_validate},
    [UTM_SEL_IDS.GZ_LON] = {2, ufcp_wpt_utm_gridzone_validate},
    [UTM_SEL_IDS.EASTING] = {4, ufcp_wpt_utm_easting_validate},
    [UTM_SEL_IDS.NORTHING] = {4, ufcp_wpt_utm_northing_validate},
    [UTM_SEL_IDS.ELEV] = {5, ufcp_wpt_elev_validate},
    [UTM_SEL_IDS.TOFT] = {8, ufcp_wpt_toft_validate}
}

-- RELEASE
function update_wpt()
    local text = ""

    -- Make sure we have the current FYT
    if ufcp_wpt_fyt then
        ufcp_wpt_num = CMFD_NAV_FYT:get()
    end

    ufcp_wpt_save()
    ufcp_wpt_load()

    local time_secs = math.floor(ufcp_wpt_time % 60)
    local time_mins = math.floor((ufcp_wpt_time / 60) % 60)
    local time_hours =  math.floor(ufcp_wpt_time / 3600)

    if time_hours >= 100 then
        time_secs = 59
        time_mins = 59
        time_hours =  99
    end

    local ll = coordinate.LLtoDMMString(ufcp_wpt_lat, ufcp_wpt_lon)

    if not ufcp_wpt_utm.active then 
        -- Fyt/WP
        text = text .. "        FYT/WPT"
        text = text .. " " --if ufcp_wpt_sel == GEO_SEL_IDS.FYT then text = text .. "*" else text = text .. " " end
        if ufcp_wpt_fyt then text = text .. "FYT" else text = text .. "WP " end
        if ufcp_wpt_sel == GEO_SEL_IDS.FYT or ufcp_wpt_sel == GEO_SEL_IDS.NUM then text = text .. "*" else text = text .. " " end

        -- Number
        if ufcp_wpt_sel == GEO_SEL_IDS.NUM and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit(true) else text = text .. string.format("%02d", ufcp_wpt_num) end
        if ufcp_wpt_sel == GEO_SEL_IDS.NUM then text = text .. "*" else text = text .. " " end
        text = text .. "^\n"

        -- Page
        if ufcp_wpt_sel == GEO_SEL_IDS.PAGE then text = text .. "*" else text = text .. " " end
        text = text .. "GEO"
        if ufcp_wpt_sel == GEO_SEL_IDS.PAGE then text = text .. "*" else text = text .. " " end

        text = text .. " LAT "

        -- Latitude
        if ufcp_wpt_sel == GEO_SEL_IDS.LAT then text = text .. "*" else text = text .. " " end
        if ufcp_wpt_sel == GEO_SEL_IDS.LAT and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit() else text = text .. ll.latitude end
        if ufcp_wpt_sel == GEO_SEL_IDS.LAT then text = text .. "*" else text = text .. " " end

        text = text .. " \n"

        -- Longitude
        text = text .. "      LON "
        if ufcp_wpt_sel == GEO_SEL_IDS.LON then text = text .. "*" else text = text .. " " end
        if ufcp_wpt_sel == GEO_SEL_IDS.LON and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit() else text = text .. ll.longitude end
        if ufcp_wpt_sel == GEO_SEL_IDS.LON then text = text .. "*" else text = text .. " " end

        text = text .. " \n"

        -- Elevation
        text = text .. "     ELEV  "
        if ufcp_wpt_sel == GEO_SEL_IDS.ELEV then text = text .. "*" else text = text .. " " end
        if ufcp_wpt_sel == GEO_SEL_IDS.ELEV and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit(true) else text = text .. (ufcp_wpt_elev >= -1500 and string.format("%5d", ufcp_wpt_elev) or "XXXXX") end
        if ufcp_wpt_sel == GEO_SEL_IDS.ELEV then text = text .. "*" else text = text .. " " end

        text = text .. "F     \n"

        -- TOFT
        text = text .. "     TOFT  "
        if ufcp_wpt_sel == GEO_SEL_IDS.TOFT then text = text .. "*" else text = text .. " " end
        if ufcp_wpt_sel == GEO_SEL_IDS.TOFT and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit(true) else text = text .. string.format("%02.0f:%02.0f:%02.0f", time_hours, time_mins, time_secs) end
        if ufcp_wpt_sel == GEO_SEL_IDS.TOFT then text = text .. "*" else text = text .. " " end

        text = text .. "   "

        if ufcp_wpt_sel == GEO_SEL_IDS.NUM and ufcp_edit_pos > 0 then
            text = replace_pos(text, 20)
            text = replace_pos(text, 23)
        elseif ufcp_wpt_sel == GEO_SEL_IDS.LAT and ufcp_edit_pos > 0 then
            text = replace_pos(text, 36)
            text = replace_pos(text, 48)
        elseif ufcp_wpt_sel == GEO_SEL_IDS.LON and ufcp_edit_pos > 0 then
            text = replace_pos(text, 61)
            text = replace_pos(text, 73)
        elseif ufcp_wpt_sel == GEO_SEL_IDS.ELEV and ufcp_edit_pos > 0 then
            text = replace_pos(text, 87)
            text = replace_pos(text, 93)
        elseif ufcp_wpt_sel == GEO_SEL_IDS.TOFT and ufcp_edit_pos > 0 then
            text = replace_pos(text, 112)
            text = replace_pos(text, 121)
        end
    elseif ufcp_wpt_utm.active then
         -- Fyt/WP
         text = text .. "        FYT/WPT"
         text = text .. " " --if ufcp_wpt_sel == GEO_SEL_IDS.FYT then text = text .. "*" else text = text .. " " end
         if ufcp_wpt_fyt then text = text .. "FYT" else text = text .. "WP " end
         if ufcp_wpt_utm.sel == UTM_SEL_IDS.FYT or ufcp_wpt_utm.sel == UTM_SEL_IDS.NUM then text = text .. "*" else text = text .. " " end
 
         -- Number
         if ufcp_wpt_utm.sel == UTM_SEL_IDS.NUM and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit(true) else text = text .. string.format("%02d", ufcp_wpt_num) end
         if ufcp_wpt_utm.sel == UTM_SEL_IDS.NUM then text = text .. "*" else text = text .. " " end
         text = text .. "^\n"

         -- Page
        if ufcp_wpt_utm.sel == UTM_SEL_IDS.PAGE then text = text .. "*" else text = text .. " " end
        text = text .. "UTM"
        if ufcp_wpt_utm.sel == UTM_SEL_IDS.PAGE then text = text .. "*" else text = text .. " " end

        -- Grid zone
        text = text .. "GZ"

        if ufcp_wpt_utm.sel == UTM_SEL_IDS.GZ_LON then text = text .. "*" else text = text .. " " end
        if ufcp_wpt_utm.sel == UTM_SEL_IDS.GZ_LON and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit(true) else text = text .. string.sub(ufcp_wpt_utm.gridzone, 1, 2) end
        if ufcp_wpt_utm.sel == UTM_SEL_IDS.GZ_LON or ufcp_wpt_utm.sel == UTM_SEL_IDS.GZ_LAT then text = text .. "*" else text = text .. " " end
        text = text .. string.sub(ufcp_wpt_utm.gridzone, 3, 3)
        if ufcp_wpt_utm.sel == UTM_SEL_IDS.GZ_LAT then text = text .. "*" else text = text .. " " end

        -- Digraph
        text = text .. "     "
        if ufcp_wpt_utm.sel == UTM_SEL_IDS.DG_LON then text = text .. "*" else text = text .. " " end
        text = text .. string.sub(ufcp_wpt_utm.digraph, 1, 1)
        if ufcp_wpt_utm.sel == UTM_SEL_IDS.DG_LON or ufcp_wpt_utm.sel == UTM_SEL_IDS.DG_LAT then text = text .. "*" else text = text .. " " end
        text = text .. string.sub(ufcp_wpt_utm.digraph, 2, 2)
        if ufcp_wpt_utm.sel == UTM_SEL_IDS.DG_LAT then text = text .. "*" else text = text .. " " end

        text = text .. " \n"

        -- Easting
        text = text .. "        E"
        if ufcp_wpt_utm.sel == UTM_SEL_IDS.EASTING then text = text .. "*" else text = text .. " " end
        if ufcp_wpt_utm.sel == UTM_SEL_IDS.EASTING and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit(true) else text = text .. (tonumber(ufcp_wpt_utm.easting) >= 0 and string.sub(ufcp_wpt_utm.easting, 1, 4) or "XXXX") end
        if ufcp_wpt_utm.sel == UTM_SEL_IDS.EASTING then text = text .. "*" else text = text .. " " end

        -- Northing
        text = text .. " N "
        if ufcp_wpt_utm.sel == UTM_SEL_IDS.NORTHING then text = text .. "*" else text = text .. " " end
        if ufcp_wpt_utm.sel == UTM_SEL_IDS.NORTHING and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit(true) else text = text .. (tonumber(ufcp_wpt_utm.northing) >= 0 and string.sub(ufcp_wpt_utm.northing, 1, 4) or "XXXX") end
        if ufcp_wpt_utm.sel == UTM_SEL_IDS.NORTHING then text = text .. "*" else text = text .. " " end

        text = text .. "\n"
        
        -- Elevation
        text = text .. "     ELEV  "
        if ufcp_wpt_utm.sel == UTM_SEL_IDS.ELEV then text = text .. "*" else text = text .. " " end
        if ufcp_wpt_utm.sel == UTM_SEL_IDS.ELEV and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit(true) else text = text .. (ufcp_wpt_elev >= -1500 and string.format("%5d", ufcp_wpt_elev) or "XXXXX") end
        if ufcp_wpt_utm.sel == UTM_SEL_IDS.ELEV then text = text .. "*" else text = text .. " " end

        text = text .. "F     \n"

        -- TOFT
        text = text .. "     TOFT  "
        if ufcp_wpt_utm.sel == UTM_SEL_IDS.TOFT then text = text .. "*" else text = text .. " " end
        if ufcp_wpt_utm.sel == UTM_SEL_IDS.TOFT and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit(true) else text = text .. string.format("%02.0f:%02.0f:%02.0f", time_hours, time_mins, time_secs) end
        if ufcp_wpt_utm.sel == UTM_SEL_IDS.TOFT then text = text .. "*" else text = text .. " " end

        text = text .. "   "

        if ufcp_wpt_utm.sel == UTM_SEL_IDS.NUM and ufcp_edit_pos > 0 then
            text = replace_pos(text, 20)
            text = replace_pos(text, 23)
        elseif ufcp_wpt_utm.sel == UTM_SEL_IDS.GZ_LON and ufcp_edit_pos > 0 then
            text = replace_pos(text, 33)
            text = replace_pos(text, 36)
        elseif ufcp_wpt_utm.sel == UTM_SEL_IDS.EASTING and ufcp_edit_pos > 0 then
            text = replace_pos(text, 60)
            text = replace_pos(text, 65)
        elseif ufcp_wpt_utm.sel == UTM_SEL_IDS.NORTHING and ufcp_edit_pos > 0 then
            text = replace_pos(text, 69)
            text = replace_pos(text, 74)
        elseif ufcp_wpt_utm.sel == UTM_SEL_IDS.ELEV and ufcp_edit_pos > 0 then
            text = replace_pos(text, 87)
            text = replace_pos(text, 93)
        elseif ufcp_wpt_utm.sel == UTM_SEL_IDS.TOFT and ufcp_edit_pos > 0 then
            text = replace_pos(text, 112)
            text = replace_pos(text, 121)
        end
    end

    UFCP_TEXT:set(text)
end

function SetCommandWpt(command,value)
    -- Move cursor
    if not ufcp_wpt_utm.active then 
        if command == device_commands.UFCP_JOY_DOWN and ufcp_edit_pos == 0 and value == 1 then
            ufcp_wpt_sel = (ufcp_wpt_sel + 1) % ufcp_wpt_max_sel
        elseif command == device_commands.UFCP_JOY_UP and ufcp_edit_pos == 0 and value == 1 then
            ufcp_wpt_sel = (ufcp_wpt_sel - 1) % ufcp_wpt_max_sel
        end
    elseif ufcp_wpt_utm.active then
        if command == device_commands.UFCP_JOY_DOWN and ufcp_edit_pos == 0 and value == 1 then
            ufcp_wpt_utm.sel = (ufcp_wpt_utm.sel + 1) % ufcp_wpt_utm.max_sel
        elseif command == device_commands.UFCP_JOY_UP and ufcp_edit_pos == 0 and value == 1 then
            ufcp_wpt_utm.sel = (ufcp_wpt_utm.sel - 1) % ufcp_wpt_utm.max_sel
        end
    end

    -- Switch to UTM subformat
    if command == device_commands.UFCP_JOY_RIGHT and value == 1 then
        if (not ufcp_wpt_utm.active and ufcp_wpt_sel == GEO_SEL_IDS.PAGE) or (ufcp_wpt_utm.active and ufcp_wpt_utm.sel == UTM_SEL_IDS.PAGE) then 
            ufcp_wpt_utm.active = not ufcp_wpt_utm.active
            ufcp_wpt_utm.sel = UTM_SEL_IDS.PAGE
            ufcp_wpt_sel = GEO_SEL_IDS.PAGE
        end
    end

    -- Switch between FYT and WP modes
    if (not ufcp_wpt_utm.active and ufcp_wpt_sel == GEO_SEL_IDS.FYT) or (ufcp_wpt_utm.active and ufcp_wpt_utm.sel == UTM_SEL_IDS.FYT) then
        if command == device_commands.UFCP_JOY_RIGHT and value == 1 then
            if not ufcp_wpt_fyt then
                CMFD_NAV_FYT_SET:set(ufcp_wpt_num) -- Try to set the fyt to the selected value
            end
            ufcp_wpt_fyt = not ufcp_wpt_fyt
        end
    end

    -- Increase/decrease
    if (not ufcp_wpt_utm.active and ufcp_wpt_sel == GEO_SEL_IDS.NUM) or (ufcp_wpt_utm.active and ufcp_wpt_utm.sel == UTM_SEL_IDS.NUM) then
        if command == device_commands.UFCP_UP and value == 1 then
            if ufcp_wpt_fyt == true then
                if ufcp_cmfd_ref ~= nil then
                    ufcp_cmfd_ref:performClickableAction(device_commands.NAV_INC_FYT, 1, true)
                end
            else 
                ufcp_wpt_num = (ufcp_wpt_num + 1) % 100
            end
        elseif command == device_commands.UFCP_DOWN and value == 1 then
            if ufcp_wpt_fyt == true then
                if ufcp_cmfd_ref ~= nil then
                    ufcp_cmfd_ref:performClickableAction(device_commands.NAV_DEC_FYT, 1, true)
                end
            else 
                ufcp_wpt_num = (ufcp_wpt_num - 1) % 100
            end
        end
    end

    -- Input
    if not ufcp_wpt_utm.active then
        if ufcp_wpt_sel == GEO_SEL_IDS.NUM or 
        ufcp_wpt_sel == GEO_SEL_IDS.LAT or 
        ufcp_wpt_sel == GEO_SEL_IDS.LON or 
        ufcp_wpt_sel == GEO_SEL_IDS.ELEV or 
        ufcp_wpt_sel == GEO_SEL_IDS.TOFT then
            if command == device_commands.UFCP_1 and value == 1 then
                ufcp_continue_edit("1", GEO_FIELD_INFO[ufcp_wpt_sel], false)
            elseif command == device_commands.UFCP_2 and value == 1 then
                ufcp_continue_edit("2", GEO_FIELD_INFO[ufcp_wpt_sel], false)
            elseif command == device_commands.UFCP_3 and value == 1 then
                ufcp_continue_edit("3", GEO_FIELD_INFO[ufcp_wpt_sel], false)
            elseif command == device_commands.UFCP_4 and value == 1 then
                ufcp_continue_edit("4", GEO_FIELD_INFO[ufcp_wpt_sel], false)
            elseif command == device_commands.UFCP_5 and value == 1 then
                ufcp_continue_edit("5", GEO_FIELD_INFO[ufcp_wpt_sel], false)
            elseif command == device_commands.UFCP_6 and value == 1 then
                ufcp_continue_edit("6", GEO_FIELD_INFO[ufcp_wpt_sel], false)
            elseif command == device_commands.UFCP_7 and value == 1 then
                ufcp_continue_edit("7", GEO_FIELD_INFO[ufcp_wpt_sel], false)
            elseif command == device_commands.UFCP_8 and value == 1 then
                ufcp_continue_edit("8", GEO_FIELD_INFO[ufcp_wpt_sel], false)
            elseif command == device_commands.UFCP_9 and value == 1 then
                ufcp_continue_edit("9", GEO_FIELD_INFO[ufcp_wpt_sel], false)
            elseif command == device_commands.UFCP_0 and value == 1 then
                ufcp_continue_edit("0", GEO_FIELD_INFO[ufcp_wpt_sel], false)
            elseif command == device_commands.UFCP_ENTR and value == 1 then
                ufcp_continue_edit("", GEO_FIELD_INFO[ufcp_wpt_sel], true)
            end
        end
    elseif ufcp_wpt_utm.active then
        if ufcp_wpt_utm.sel == UTM_SEL_IDS.NUM or 
        ufcp_wpt_utm.sel == UTM_SEL_IDS.GZ_LON or 
        ufcp_wpt_utm.sel == UTM_SEL_IDS.EASTING or 
        ufcp_wpt_utm.sel == UTM_SEL_IDS.NORTHING or 
        ufcp_wpt_utm.sel == UTM_SEL_IDS.ELEV or 
        ufcp_wpt_utm.sel == UTM_SEL_IDS.TOFT then
            if command == device_commands.UFCP_1 and value == 1 then
                ufcp_continue_edit("1", UTM_FIELD_INFO[ufcp_wpt_utm.sel], false)
            elseif command == device_commands.UFCP_2 and value == 1 then
                ufcp_continue_edit("2", UTM_FIELD_INFO[ufcp_wpt_utm.sel], false)
            elseif command == device_commands.UFCP_3 and value == 1 then
                ufcp_continue_edit("3", UTM_FIELD_INFO[ufcp_wpt_utm.sel], false)
            elseif command == device_commands.UFCP_4 and value == 1 then
                ufcp_continue_edit("4", UTM_FIELD_INFO[ufcp_wpt_utm.sel], false)
            elseif command == device_commands.UFCP_5 and value == 1 then
                ufcp_continue_edit("5", UTM_FIELD_INFO[ufcp_wpt_utm.sel], false)
            elseif command == device_commands.UFCP_6 and value == 1 then
                ufcp_continue_edit("6", UTM_FIELD_INFO[ufcp_wpt_utm.sel], false)
            elseif command == device_commands.UFCP_7 and value == 1 then
                ufcp_continue_edit("7", UTM_FIELD_INFO[ufcp_wpt_utm.sel], false)
            elseif command == device_commands.UFCP_8 and value == 1 then
                ufcp_continue_edit("8", UTM_FIELD_INFO[ufcp_wpt_utm.sel], false)
            elseif command == device_commands.UFCP_9 and value == 1 then
                ufcp_continue_edit("9", UTM_FIELD_INFO[ufcp_wpt_utm.sel], false)
            elseif command == device_commands.UFCP_0 and value == 1 then
                ufcp_continue_edit("0", UTM_FIELD_INFO[ufcp_wpt_utm.sel], false)
            elseif command == device_commands.UFCP_ENTR and value == 1 then
                ufcp_continue_edit("", UTM_FIELD_INFO[ufcp_wpt_utm.sel], true)
            end
        end

        if command == device_commands.UFCP_JOY_RIGHT and value == 1 then
            if ufcp_wpt_utm.sel == UTM_SEL_IDS.GZ_LAT then
                sel_next_gz_lat()
            elseif ufcp_wpt_utm.sel == UTM_SEL_IDS.DG_LON then
                sel_next_dg_lon()
            elseif ufcp_wpt_utm.sel == UTM_SEL_IDS.DG_LAT then
                sel_next_dg_lat()
            end
        end
    end
end