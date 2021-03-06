dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."Systems/avionics_api.lua")
dofile(LockOn_Options.script_path.."utils.lua")
dofile(LockOn_Options.script_path.."dump.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_api.lua")

startup_print("ufcs: load")

local dev = GetSelf()
local alarm 
local hud

local update_time_step = 0.02 --update will be called 50 times per second
make_default_activity(update_time_step)

local sensor_data = get_base_data()

local UFCP_BRIGHT = get_param_handle("UFCP_BRIGHT")
local UFCP_TEXT = get_param_handle("UFCP_TEXT")
local CMFD_NAV_FYT = get_param_handle("CMFD_NAV_FYT")
local EICAS_FUEL_INIT = get_param_handle("EICAS_FUEL_INIT")
local CMFD_NAV_FYT_OAP_STT = get_param_handle("CMFD_NAV_FYT_OAP_STT")


local ufcp_nav_mode = UFCP_NAV_MODE_IDS.AUTO
local ufcp_nav_time = UFCP_NAV_TIME_IDS.TTD
local ufcp_nav_solution = UFCP_NAV_SOLUTION_IDS.NAV_EGI
local ufcp_nav_egi_error = 35 -- meters

local ufcp_com1_channel = 15
local ufcp_com1_frequency = 302.100

local ufcp_com2_channel = 5
local ufcp_com2_frequency = 124.500
local ufcp_com2_sync = false
local ufcp_com2_por = false

local ufcp_ident = false
local ufcp_ident_blink = false

local ufcp_time_type =  UFCP_TIME_TYPE_IDS.LC

local ufcp_sel_format = UFCP_FORMAT_IDS.MAIN
local ufcp_main_sel = UFCP_MAIN_SEL_IDS.FYT

local elapsed = 0

function update_main()
    elapsed = elapsed + update_time_step
    if elapsed > 0.4 then elapsed = 0
    elseif elapsed > 0.2 then ufcp_ident_blink = false
    else ufcp_ident_blink = true end

    local text = ""
    
    -- Line 1
    if ufcp_nav_mode == UFCP_NAV_MODE_IDS.AUTO then
        text = text .. "AUT"
    elseif ufcp_nav_mode == UFCP_NAV_MODE_IDS.MAN then
        text = text .. "MAN"
    end
    local ans_mode = AVIONICS_ANS_MODE:get()
    if ans_mode == AVIONICS_ANS_MODE_IDS.GPS then
        text = text .. "XX"
    else
        text = text .. string.format("%02.0f", CMFD_NAV_FYT:get())
    end
    if ufcp_main_sel == UFCP_MAIN_SEL_IDS.FYT then text = text .. "^" else text = text .. " " end 
    text = text .. " "
    text = text .. UFCP_NAV_SOLUTION_IDS[ufcp_nav_solution]
    text = text .. " "
    text = text .. "ERR<" .. string.format("%03.0f", ufcp_nav_egi_error)
    text = text .. "\n"

    -- Line 2
    text = text .. string.format("COM1 %02.0f [%07.3f]     ", ufcp_com1_channel, ufcp_com1_frequency)
    text = text .. "\n"

    -- Line 3
    text = text .. string.format("COM2 %02.0f [%07.3f]  ", ufcp_com2_channel, ufcp_com2_frequency)
    if ufcp_com2_sync then text = text .. "SOK" else text = text .. "   " end
    text = text .. "\n"

    -- Line 4
    text = text .. UFCP_TIME_TYPE_IDS[ufcp_time_type]
    local time = get_absolute_model_time()
    local time_secs = math.floor(time % 60)
    local time_mins = math.floor((time / 60) % 60)
    local time_hours =  math.floor(time / 3600)

    if time_hours >= 100 then
        time_secs = 59
        time_mins = 59
        time_hours =  99
    end

    text = text .. string.format(" %02.0f:%02.0f:%02.0f        ", time_hours, time_mins, time_secs)

    if ufcp_com2_por then text = text .. "POR" else text = text .. "   " end
    text = text .. "\n"

    -- Line 5
    local ufcp_total_fuel = EICAS_FUEL_INIT:get()
    local ufcp_xpdr = 2000
    text = text .. string.format("%04.0fKG      %04.0f  ", ufcp_total_fuel, ufcp_xpdr)
    if ufcp_ident and ufcp_ident_blink then text = text .. "IDNT" else text = text .. "    " end

    UFCP_TEXT:set(text)
end


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


local ufcp_wpt_type = UFCP_WPT_TYPE_IDS.FYT
local ufcp_wpt_sel = UFCP_WPT_SEL_IDS.FYT_WP
local ufcp_wpt_fyt_num_last = -1
local ufcp_wpt_fyt_num = 0
local ufcp_wpt_lat = 0
local ufcp_wpt_lon = 0
local ufcp_wpt_elv = 0
local ufcp_wpt_time = 0

local Terrain = require('terrain')


local ufcp_edit_pos = 0
local ufcp_edit_lim = 0
local ufcp_edit_string = ""
local ufcp_edit_validate = nil

local function ufcp_edit_clear()
    ufcp_edit_pos = 0
    ufcp_edit_lim = 0
    ufcp_edit_string = ""
    ufcp_edit_validate = nil
end

local ufcp_wpt_save_now = false

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

local UFCP_EDIT_FIELDS = {
    [UFCP_WPT_SEL_IDS.LAT] = {11, ufcp_wpt_lat_lon_input_validade},
    [UFCP_WPT_SEL_IDS.LON] = {11, ufcp_wpt_lat_lon_input_validade},
    [UFCP_WPT_SEL_IDS.ELV] = {5, ufcp_wpt_input_validade},
    [UFCP_WPT_SEL_IDS.FYT_WP] = {2, ufcp_wpt_input_validade},
    [UFCP_WPT_SEL_IDS.TOFT] = {8, ufcp_wpt_time_input_validade},
}


local function ufcp_continue_edit(text, save)
    if ufcp_edit_pos == 0 then 
        local field_info = UFCP_EDIT_FIELDS[ufcp_wpt_sel]
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

local function replace_text(text, c_start, c_size)
    if ufcp_edit_pos == 0 then return text end
    local text_copy = text:sub(1,c_start-1)
    local text_new = text:sub(c_start, c_start+c_size-1)
    if ufcp_edit_pos > 0 then 
        text_new = "*"
        for i=1,(c_size - ufcp_edit_pos-2) do
            text_new = text_new .. " "
        end
        text_new = text_new .. ufcp_edit_string .. "*"
    end
    for i=1, c_size do
        local val = string.byte(text_new,i)
        if val >= string.byte("A") and val <= string.byte("Z") then val = val + 32
        elseif val >= string.byte("0") and val <= string.byte("9") then val = val - 34
        elseif val >= string.byte(" ") and val <= string.byte("+") then val = val - 31
        elseif val >= string.byte(",") and val <= string.byte("/") then val = val - 20
        elseif val == string.byte(":") then val = val - 30
        end
        text_copy = text_copy .. string.char(val)
    end
    text_copy = text_copy .. text:sub(c_start + c_size)
    return text_copy
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

local ufcp_menu_sel = 0
local function update_menu()
    local text = ""
    text = text .. "MENU\n"
    text = text .. "1LMT 2DTK  3BAL C ACAL\n"
    text = text .. "4NAV 5WS   6EGI E FUEL\n"
    text = text .. "7TAC 8MODE 9OAP O MISC\n"
    UFCP_TEXT:set(text)
end

local function update_nav()
    local text = ""
    if ufcp_sel_format == UFCP_FORMAT_IDS.NAV_MODE then 
        if ufcp_menu_sel > 2 then ufcp_menu_sel = 0 elseif ufcp_menu_sel < 0 then ufcp_menu_sel = 2 end

        if ufcp_menu_sel == 0 then text = text .. "*" else text = text .. " " end
        text = text .. "NAV MODE"
        if ufcp_menu_sel == 0 then text = text .. "*" else text = text .. " " end
        text = text .. "\n"
        text = text .. "   "
        if ufcp_menu_sel == 1 then text = text .. "*" else text = text .. " " end
        if ufcp_nav_mode == UFCP_NAV_MODE_IDS.AUTO then text = text .. "AUTO" else text = text .. "MAN " end
        if ufcp_menu_sel == 1 then text = text .. "*" else text = text .. " " end
        text = text .. "  "
        if ufcp_menu_sel == 2 then text = text .. "*" else text = text .. " " end
        if ufcp_nav_time == UFCP_NAV_TIME_IDS.ETA then text = text .. "ETA"
        elseif ufcp_nav_time == UFCP_NAV_TIME_IDS.TTD then text = text .. "TTG"
        else text = text .. "DT " end
        if ufcp_menu_sel == 2 then text = text .. "*" else text = text .. " " end
        text = text .. "        \n"
        if ufcp_nav_time == UFCP_NAV_TIME_IDS.ETA or ufcp_nav_time == UFCP_NAV_TIME_IDS.DT then
            text = text .. "           FLY  "
            local stt = CMFD_NAV_FYT_OAP_STT:get()
            if stt > 0 then text = text .. string.format("%03.0f", stt) else text = text .. "XXX" end
            text = text .. " GS"
        end
        text = text .. "\n\n"
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.NAV_MISC then
        if ufcp_menu_sel > 0 then ufcp_menu_sel = 0 elseif ufcp_menu_sel < 0 then ufcp_menu_sel = 0 end
        if ufcp_menu_sel == 0 then text = text .. "*" else text = text .. " " end
        text = text .. "NAV MISC"
        if ufcp_menu_sel == 0 then text = text .. "*" else text = text .. " " end
        text = text .. "\n"
        text = text .. "MAGV     AUTO  X  XX.X\n"
        text = text .. "GEO ZONE MAN          \n"
        text = text .. "\n"
        text = text .. "DELTA ZONE +  1.5 HR  "
    end
    UFCP_TEXT:set(text)
end

function update()
    local ufcp_bright = get_cockpit_draw_argument_value(480)
    UFCP_BRIGHT:set(ufcp_bright)
    if ufcp_sel_format == UFCP_FORMAT_IDS.MAIN then update_main()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.WPT then update_wpt()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.MENU then update_menu()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.NAV_MODE or ufcp_sel_format == UFCP_FORMAT_IDS.NAV_MISC then update_nav()
    end
    UFCP_NAV_MODE:set(ufcp_nav_mode)
    UFCP_NAV_TIME:set(ufcp_nav_time)
end

local cmfd
function post_initialize()
    startup_print("ufcs: postinit start")

    cmfd = GetDevice(devices.CMFD)
    local birth = LockOn_Options.init_conditions.birth_place
    alarm = GetDevice(devices.ALARM)
    hud = GetDevice(devices.HUD)
    if birth=="GROUND_HOT" then
        dev:performClickableAction(device_commands.UFCP_UFC, 1, true)
    elseif birth=="AIR_HOT" then
        dev:performClickableAction(device_commands.UFCP_UFC, 1, true)
    elseif birth=="GROUND_COLD" then
        dev:performClickableAction(device_commands.UFCP_UFC, 0, true)
    end
    startup_print("ufcs: postinit end")
end



dev:listen_command(device_commands.UFCP_WARNRST)
dev:listen_command(device_commands.UFCP_4)
dev:listen_command(device_commands.UFCP_BARO_RALT)



function SetCommandWpt(command,value)
    if command == device_commands.UFCP_1 and value == 1 then
        ufcp_continue_edit("1")
    elseif command == device_commands.UFCP_2 and value == 1 then
        ufcp_continue_edit("2")
    elseif command == device_commands.UFCP_3 and value == 1 then
        ufcp_continue_edit("3")
    elseif command == device_commands.UFCP_4 and value == 1 then
        ufcp_continue_edit("4")
    elseif command == device_commands.UFCP_5 and value == 1 then
        ufcp_continue_edit("5")
    elseif command == device_commands.UFCP_6 and value == 1 then
        ufcp_continue_edit("6")
    elseif command == device_commands.UFCP_7 and value == 1 then
        ufcp_continue_edit("7")
    elseif command == device_commands.UFCP_8 and value == 1 then
        ufcp_continue_edit("8")
    elseif command == device_commands.UFCP_9 and value == 1 then
        ufcp_continue_edit("9")
    elseif command == device_commands.UFCP_0 and value == 1 then
        ufcp_continue_edit("0")
    elseif command == device_commands.UFCP_UP and value == 1 then
        if ufcp_wpt_sel == UFCP_WPT_SEL_IDS.FYT_WP  and cmfd ~= nil then ufcp_wpt_fyt_num = (ufcp_wpt_fyt_num + 1) % 100 end
    elseif command == device_commands.UFCP_DOWN and value == 1 then
        if ufcp_wpt_sel == UFCP_WPT_SEL_IDS.FYT_WP  and cmfd ~= nil then ufcp_wpt_fyt_num = (ufcp_wpt_fyt_num - 1) % 100 end
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
        ufcp_continue_edit("", true)
    end
end


local HUD_VAH = get_param_handle("HUD_VAH")
HUD_VAH:set(1)

function SetCommandMain(command,value)
    if command == device_commands.UFCP_1 and value == 1 then
        HUD_VAH:set((HUD_VAH:get() + 1) % 2)
    elseif command == device_commands.UFCP_4 and value == 1 then
        ufcp_wpt_sel = UFCP_WPT_SEL_IDS.FYT_WP
        ufcp_sel_format = UFCP_FORMAT_IDS.WPT
    elseif command == device_commands.UFCP_JOY_RIGHT and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.MENU
    elseif command == device_commands.UFCP_UP and value == 1 then
        if ufcp_main_sel == UFCP_MAIN_SEL_IDS.FYT and AVIONICS_ANS_MODE:get() ~= AVIONICS_ANS_MODE_IDS.GPS and cmfd ~= nil then cmfd:performClickableAction(device_commands.NAV_INC_FYT, 1, true) end
    elseif command == device_commands.UFCP_DOWN and value == 1 then
        if ufcp_main_sel == UFCP_MAIN_SEL_IDS.FYT and AVIONICS_ANS_MODE:get() ~= AVIONICS_ANS_MODE_IDS.GPS and cmfd ~= nil then cmfd:performClickableAction(device_commands.NAV_DEC_FYT, 1, true) end
    end
end

function SetCommandMenu(command,value)
    if command == device_commands.UFCP_1 and value == 1 then
    elseif command == device_commands.UFCP_4 and value == 1 then
        ufcp_menu_sel = 0
        ufcp_sel_format = UFCP_FORMAT_IDS.NAV_MODE
    elseif command == device_commands.UFCP_JOY_RIGHT and value == 1 then
    elseif command == device_commands.UFCP_UP and value == 1 then
    elseif command == device_commands.UFCP_DOWN and value == 1 then
    end
end


function SetCommandCommon(command, value)
    if command == device_commands.UFCP_JOY_DOWN and value == 1 then
        ufcp_menu_sel = ufcp_menu_sel + 1
    elseif command == device_commands.UFCP_JOY_UP and value == 1 then
        ufcp_menu_sel = ufcp_menu_sel - 1
    end
end
function SetCommandNav(command,value)
    if ufcp_sel_format == UFCP_FORMAT_IDS.NAV_MODE then 
        if command == device_commands.UFCP_JOY_RIGHT and value == 1 and ufcp_menu_sel == 0 then
            ufcp_menu_sel = 0
            ufcp_sel_format = UFCP_FORMAT_IDS.NAV_MISC
        elseif command == device_commands.UFCP_JOY_RIGHT and value == 1 and ufcp_menu_sel == 1 then
            ufcp_nav_mode = (ufcp_nav_mode + 1) % (UFCP_NAV_MODE_IDS.END)
        elseif command == device_commands.UFCP_JOY_RIGHT and value == 1 and ufcp_menu_sel == 2 then
            ufcp_nav_time = (ufcp_nav_time + 1) % (UFCP_NAV_TIME_IDS.END)
        end
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.NAV_MISC then
        if command == device_commands.UFCP_JOY_RIGHT and value == 1 and ufcp_menu_sel == 0 then
            ufcp_menu_sel = 0
            ufcp_sel_format = UFCP_FORMAT_IDS.NAV_MODE
        elseif command == device_commands.UFCP_JOY_RIGHT and value == 1 and ufcp_menu_sel == 1 then
            ufcp_nav_mode = (ufcp_nav_mode + 1) % #UFCP_NAV_MODE_IDS
        elseif command == device_commands.UFCP_JOY_RIGHT and value == 1 and ufcp_menu_sel == 2 then
            ufcp_nav_time = (ufcp_nav_time + 1) % #UFCP_NAV_TIME_IDS
        end
    end

    if command == device_commands.UFCP_1 and value == 1 then
    elseif command == device_commands.UFCP_4 and value == 1 then
    elseif command == device_commands.UFCP_JOY_RIGHT and value == 1 then
    elseif command == device_commands.UFCP_UP and value == 1 then
    elseif command == device_commands.UFCP_DOWN and value == 1 then
    end
    SetCommandCommon(command, value)
end

function SetCommand(command,value)
    debug_message_to_user("ufcs: command "..tostring(command).." = "..tostring(value))
    if command==device_commands.UFCP_WARNRST and value == 1 then
        alarm:SetCommand(command, value)
        hud:SetCommand(command, value)
    elseif command == device_commands.UFCP_A_G and value == 1 then
        set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.CCIP)
    elseif command == device_commands.UFCP_A_A and value == 1 then
        set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.DGFT_B)
    elseif command == device_commands.UFCP_NAV and value == 1 then
        set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.NAV)
    elseif command == device_commands.UFCP_UFC then
    elseif command == device_commands.UFCP_JOY_LEFT and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.MAIN
    elseif command == device_commands.UFCP_BARO_RALT and value == 1 then
        local master_mode = get_avionics_master_mode()
        local master_mode_last = master_mode
        if master_mode == AVIONICS_MASTER_MODE_ID.GUN then master_mode = AVIONICS_MASTER_MODE_ID.GUN_R 
        elseif master_mode == AVIONICS_MASTER_MODE_ID.GUN_R then master_mode = AVIONICS_MASTER_MODE_ID.GUN 
        elseif master_mode == AVIONICS_MASTER_MODE_ID.CCIP then master_mode = AVIONICS_MASTER_MODE_ID.CCIP_R
        elseif master_mode == AVIONICS_MASTER_MODE_ID.CCIP_R then master_mode = AVIONICS_MASTER_MODE_ID.CCIP
        elseif master_mode == AVIONICS_MASTER_MODE_ID.DTOS then master_mode = AVIONICS_MASTER_MODE_ID.DTOS_R
        elseif master_mode == AVIONICS_MASTER_MODE_ID.DTOS_R then master_mode = AVIONICS_MASTER_MODE_ID.DTOS
        elseif master_mode == AVIONICS_MASTER_MODE_ID.FIX then master_mode = AVIONICS_MASTER_MODE_ID.FIX_R
        elseif master_mode == AVIONICS_MASTER_MODE_ID.FIX_R then master_mode = AVIONICS_MASTER_MODE_ID.FIX
        elseif master_mode == AVIONICS_MASTER_MODE_ID.MARK then master_mode = AVIONICS_MASTER_MODE_ID.MARK_R
        elseif master_mode == AVIONICS_MASTER_MODE_ID.MARK_R then master_mode = AVIONICS_MASTER_MODE_ID.MARK
        end
        if master_mode ~= master_mode_last then
            set_avionics_master_mode(master_mode)
        end
    end

    if ufcp_sel_format == UFCP_FORMAT_IDS.MAIN then SetCommandMain(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.WPT then SetCommandWpt(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.MENU then SetCommandMenu(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.NAV_MODE or ufcp_sel_format == UFCP_FORMAT_IDS.NAV_MISC then SetCommandNav(command, value)
    end
end


startup_print("ufcs: load end")
need_to_be_closed = false -- close lua state after initialization


