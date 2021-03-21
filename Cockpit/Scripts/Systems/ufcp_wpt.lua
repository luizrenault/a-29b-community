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

-- Constants

UFCP_WPT_TYPE_IDS = {
    FYT = 0,
    WP = 1,
}
UFCP_WPT_TYPE_IDS[UFCP_WPT_TYPE_IDS.FYT] = "FYT"
UFCP_WPT_TYPE_IDS[UFCP_WPT_TYPE_IDS.WP] = " WP"

UFCP_WPT_SEL_IDS = {
    FYT_WP = 0,
    -- GEO_UTM = 1,
    LAT = 1,
    LON = 2,
    ELV = 3,
    TOFT = 4,

    END = 5,
}

-- Variables

ufcp_wpt_type = UFCP_WPT_TYPE_IDS.FYT
ufcp_wpt_fyt_num_last = -1
ufcp_wpt_fyt_num = 0
ufcp_wpt_lat = 0
ufcp_wpt_lon = 0
ufcp_wpt_elv = 0
ufcp_wpt_time = 0

local ufcp_wpt_sel = UFCP_WPT_SEL_IDS.FYT_WP
local Terrain = require('terrain')
local ufcp_wpt_save_now = false

-- Methods

local function ufcp_wpt_load()
    if ufcp_wpt_fyt_num ~= ufcp_wpt_fyt_num_last then
        if CMFD_NAV_GET_INDEX:get() < 0 and CMFD_NAV_GET_RDY:get() == 0 then
            -- start query
            CMFD_NAV_GET_INDEX:set(ufcp_wpt_fyt_num)
        elseif CMFD_NAV_GET_INDEX:get() == ufcp_wpt_fyt_num and CMFD_NAV_GET_RDY:get() == 1 then
            -- read and free query
            ufcp_wpt_lat = CMFD_NAV_GET_LAT:get()
            ufcp_wpt_lon = CMFD_NAV_GET_LON:get()
            ufcp_wpt_elv = CMFD_NAV_GET_ELV:get()
            ufcp_wpt_time = CMFD_NAV_GET_TIME:get()
            CMFD_NAV_GET_INDEX:set(-1)
            CMFD_NAV_GET_RDY:set(0)
            ufcp_wpt_fyt_num_last = ufcp_wpt_fyt_num
        end
    end
end

local function ufcp_wpt_save()
    if ufcp_wpt_save_now then
        if CMFD_NAV_SET_INDEX:get() < 0  then
            CMFD_NAV_SET_LAT:set(ufcp_wpt_lat)
            CMFD_NAV_SET_LON:set(ufcp_wpt_lon)
            CMFD_NAV_SET_ELV:set(ufcp_wpt_elv)
            CMFD_NAV_SET_TIME:set(ufcp_wpt_time)
            CMFD_NAV_SET_INDEX:set(ufcp_wpt_fyt_num)
            ufcp_wpt_save_now = false
        end
    end
end

local function ufcp_wpt_input_validade(text, save)
    if save then
        local value = tonumber(text)
        if ufcp_wpt_sel == UFCP_WPT_SEL_IDS.ELV and value then
            ufcp_wpt_elv = value
            ufcp_edit_clear()
            ufcp_wpt_save_now = true
            SetCommandWpt(device_commands.UFCP_JOY_DOWN, 1)
        elseif ufcp_wpt_sel == UFCP_WPT_SEL_IDS.FYT_WP and value then
            ufcp_wpt_fyt_num = value
            ufcp_edit_clear()
            SetCommandWpt(device_commands.UFCP_JOY_DOWN, 1)
        end
    end
    return text
end

local function ufcp_wpt_time_input_validade(text, save)
    if text:len() == 2 then text = text .. ':'
    elseif text:len() == 5 then text = text .. ':'
    elseif text:len() == ufcp_edit_lim and save then
        local hour = tonumber(text:sub(1,2))
        local min = tonumber(text:sub(4,5))
        local sec = tonumber(text:sub(7,8))

        if hour < 24 and min < 60 and sec < 60 then
            ufcp_wpt_time = sec + min * 60 + hour * 3600
            ufcp_edit_clear()
            ufcp_wpt_save_now = true
        end
    end
    return text
end

local function ufcp_wpt_lat_lon_input_validade(text, save)
    -- local reference = "E XXºXX.XX'"
    if text:len() == 1 then
        if     ufcp_wpt_sel == UFCP_WPT_SEL_IDS.LAT and text == "2" then text = "N "
        elseif ufcp_wpt_sel == UFCP_WPT_SEL_IDS.LAT and text == "8" then text = "S "
        elseif ufcp_wpt_sel == UFCP_WPT_SEL_IDS.LON and text == "4" then text = "E"
        elseif ufcp_wpt_sel == UFCP_WPT_SEL_IDS.LON and text == "6" then text = "W"
        else
            text=""
        end
    elseif text:len() == 4 then text = text .. '$'
    elseif text:len() == 7 then text = text .. '.'
    elseif text:len() == 10 then text = text .. '\''
    elseif text:len() == ufcp_edit_lim and save then
        local hemis = text:sub(1,1)
        local deg = text:sub(2,4)
        local min = text:sub(6,10)
        local coord = tonumber(deg) + tonumber(min)/60
        if  (((hemis == "N" or hemis == "S") and tonumber(deg) <= 90) or ((hemis == "E" or hemis == "W") and tonumber(deg) <= 180)) and tonumber(min) < 60 then 
            if hemis == "S" then coord = -coord end
            if hemis == "W" then coord = -coord end
            if ufcp_wpt_sel == UFCP_WPT_SEL_IDS.LAT then 
                if coord ~= 0 then 
                    ufcp_wpt_lat = coord
                    ufcp_edit_clear()
                    ufcp_wpt_save_now = true
                    SetCommandWpt(device_commands.UFCP_JOY_DOWN, 1)
                end
            elseif ufcp_wpt_sel == UFCP_WPT_SEL_IDS.LON then 
                if coord ~= 0 then
                    ufcp_wpt_lon = coord
                    ufcp_edit_clear()
                    ufcp_wpt_save_now = true
                    SetCommandWpt(device_commands.UFCP_JOY_DOWN, 1)
                end
            end
        end
    end
    return text
end

local UFCP_WPT_FIELDS = {
    [UFCP_WPT_SEL_IDS.LAT] = {11, ufcp_wpt_lat_lon_input_validade},
    [UFCP_WPT_SEL_IDS.LON] = {11, ufcp_wpt_lat_lon_input_validade},
    [UFCP_WPT_SEL_IDS.ELV] = {5, ufcp_wpt_input_validade},
    [UFCP_WPT_SEL_IDS.FYT_WP] = {2, ufcp_wpt_input_validade},
    [UFCP_WPT_SEL_IDS.TOFT] = {8, ufcp_wpt_time_input_validade},
}

local function ufcp_wpt_continue_edit(text, save)
    if ufcp_edit_pos == 0 then 
        local field_info = UFCP_WPT_FIELDS[ufcp_wpt_sel]

        if field_info then
            ufcp_edit_string = ""
            ufcp_edit_lim = field_info[1] or 1
            ufcp_edit_validate = field_info[2]
        else 
            return 0
        end
    end

    local available = ufcp_edit_lim - ufcp_edit_pos
    if available < text:len() then text=text:sub(1,available) end
    ufcp_edit_string = ufcp_edit_string .. text
    if ufcp_edit_validate then ufcp_edit_string = ufcp_edit_validate(ufcp_edit_string, save) end
    if ufcp_edit_string:len() > ufcp_edit_lim then ufcp_edit_string = ufcp_edit_string:sub(1,ufcp_edit_lim) end
    ufcp_edit_pos = ufcp_edit_string:len()
end

function update_wpt()
    ufcp_wpt_save()
    ufcp_wpt_load()

    local text = ""

    -- Line 1
    text = text .. "        FYT/WPT "
    text = text .. UFCP_WPT_TYPE_IDS[ufcp_wpt_type]
    if ufcp_wpt_sel ==  UFCP_WPT_SEL_IDS.FYT_WP then text = text .. "*" else text = text .. " " end
    text = text .. string.format("%02.0f", ufcp_wpt_fyt_num)
    if ufcp_wpt_sel ==  UFCP_WPT_SEL_IDS.FYT_WP then text = text .. "*^" else text = text .. "  " end
    text = text .. "\n"

    -- Line 2
    if ufcp_wpt_sel == UFCP_WPT_SEL_IDS.GEO_UTM then text = text .. "*" else text = text .. " " end
    text = text .. "GEO"
    if ufcp_wpt_sel == UFCP_WPT_SEL_IDS.GEO_UTM then text = text .. "*" else text = text .. " " end
    text = text .. " LAT "
    if ufcp_wpt_sel == UFCP_WPT_SEL_IDS.LAT then text = text .. "*" else text = text .. " " end
    if ufcp_wpt_lat <0 then text = text .. "S" else text = text .. "N" end

    text = text .. string.format(" %02.0f$%05.2f'", math.floor(math.abs(ufcp_wpt_lat)), (math.abs(ufcp_wpt_lat) - math.floor(math.abs(ufcp_wpt_lat)))*60)
    if ufcp_wpt_sel == UFCP_WPT_SEL_IDS.LAT then text = text .. "*" else text = text .. " " end

    text = text .. " \n"

    -- Line 3
    text = text .. "      LON "
    if ufcp_wpt_sel == UFCP_WPT_SEL_IDS.LON then text = text .. "*" else text = text .. " " end
    if ufcp_wpt_lon >=0 then text = text .. "E" else text = text .. "W" end
    text = text .. string.format("%03.0f$%05.2f'", math.floor(math.abs(ufcp_wpt_lon)), (math.abs(ufcp_wpt_lon) - math.floor(math.abs(ufcp_wpt_lon)))*60)
    if ufcp_wpt_sel == UFCP_WPT_SEL_IDS.LON then text = text .. "*" else text = text .. " " end
    text = text .. " \n"

    -- Line 4
    text = text .. "      ELEV "
    if ufcp_wpt_sel == UFCP_WPT_SEL_IDS.ELV then text = text .. "*" else text = text .. " " end
    text = text .. string.format("%5.0f", ufcp_wpt_elv)
    if ufcp_wpt_sel == UFCP_WPT_SEL_IDS.ELV then text = text .. "*" else text = text .. " " end
    text = text .. "F     \n"

    -- Line 5
    text = text .. "      TOFT "
    local time_secs = math.floor(ufcp_wpt_time % 60)
    local time_mins = math.floor((ufcp_wpt_time / 60) % 60)
    local time_hours =  math.floor(ufcp_wpt_time / 3600)

    if time_hours >= 100 then
        time_secs = 59
        time_mins = 59
        time_hours =  99
    end
    if ufcp_wpt_sel == UFCP_WPT_SEL_IDS.TOFT then text = text .. "*" else text = text .. " " end
    text = text .. string.format("%02.0f:%02.0f:%02.0f", time_hours, time_mins, time_secs)
    if ufcp_wpt_sel == UFCP_WPT_SEL_IDS.TOFT then text = text .. "*" else text = text .. " " end
    text = text .. "   "

    if ufcp_wpt_sel == UFCP_WPT_SEL_IDS.FYT_WP then text = replace_text(text, 20,4) end
    if ufcp_wpt_sel == UFCP_WPT_SEL_IDS.LAT then text = replace_text(text, 36,13) end
    if ufcp_wpt_sel == UFCP_WPT_SEL_IDS.LON then text = replace_text(text, 61,13) end
    if ufcp_wpt_sel == UFCP_WPT_SEL_IDS.ELV then text = replace_text(text, 87,7) end
    if ufcp_wpt_sel == UFCP_WPT_SEL_IDS.TOFT then text = replace_text(text, 112,10) end

    UFCP_TEXT:set(text)
end

function SetCommandWpt(command,value)
    if command == device_commands.UFCP_1 and value == 1 then
        ufcp_wpt_continue_edit("1")
    elseif command == device_commands.UFCP_2 and value == 1 then
        ufcp_wpt_continue_edit("2")
    elseif command == device_commands.UFCP_3 and value == 1 then
        ufcp_wpt_continue_edit("3")
    elseif command == device_commands.UFCP_4 and value == 1 then
        ufcp_wpt_continue_edit("4")
    elseif command == device_commands.UFCP_5 and value == 1 then
        ufcp_wpt_continue_edit("5")
    elseif command == device_commands.UFCP_6 and value == 1 then
        ufcp_wpt_continue_edit("6")
    elseif command == device_commands.UFCP_7 and value == 1 then
        ufcp_wpt_continue_edit("7")
    elseif command == device_commands.UFCP_8 and value == 1 then
        ufcp_wpt_continue_edit("8")
    elseif command == device_commands.UFCP_9 and value == 1 then
        ufcp_wpt_continue_edit("9")
    elseif command == device_commands.UFCP_0 and value == 1 then
        ufcp_wpt_continue_edit("0")
    elseif command == device_commands.UFCP_UP and value == 1 then
        if ufcp_wpt_sel == UFCP_WPT_SEL_IDS.FYT_WP  and ufcp_cmfd_ref ~= nil then ufcp_wpt_fyt_num = (ufcp_wpt_fyt_num + 1) % 100 end
    elseif command == device_commands.UFCP_DOWN and value == 1 then
        if ufcp_wpt_sel == UFCP_WPT_SEL_IDS.FYT_WP  and ufcp_cmfd_ref ~= nil then ufcp_wpt_fyt_num = (ufcp_wpt_fyt_num - 1) % 100 end
    elseif command == device_commands.UFCP_JOY_UP and value == 1 then
        ufcp_wpt_sel = (ufcp_wpt_sel - 1) % UFCP_WPT_SEL_IDS.END
        ufcp_edit_clear()
    elseif command == device_commands.UFCP_JOY_DOWN and value == 1 then
        ufcp_wpt_sel = (ufcp_wpt_sel + 1) % UFCP_WPT_SEL_IDS.END
        ufcp_edit_clear()
    elseif command == device_commands.UFCP_JOY_RIGHT and value == 1 then
    elseif command == device_commands.UFCP_CLR and value == 1 then
        ufcp_edit_clear()
    elseif command == device_commands.UFCP_ENTR and value == 1 then
        ufcp_wpt_continue_edit("", true)
    end
end