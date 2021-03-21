dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."Systems/avionics_api.lua")
dofile(LockOn_Options.script_path.."utils.lua")
dofile(LockOn_Options.script_path.."dump.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_api.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")

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
local ADHSI_VV = get_param_handle("ADHSI_VV")

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

local HUD_DRIFT_CO = get_param_handle("HUD_DRIFT_CO")

-- VARIABLES

-- MAIN
local ufcp_sel_format = UFCP_FORMAT_IDS.MAIN
local ufcp_main_sel = UFCP_MAIN_SEL_IDS.FYT

-- COM 1
local ufcp_com1_mode = UFCP_COM_MODE_IDS.TR
local ufcp_com1_frequency_sel = UFCP_COM_FREQUENCY_SEL_IDS.PRST
local ufcp_com1_channel = 0
local ufcp_com1_frequency = 118
local ufcp_com1_tx = false
local ufcp_com1_rx = false
local ufcp_com1_channels = {118, 119, 120, 121, 122, 123, 124, 125, 126, 127}
local ufcp_com1_max_channel = 78
local ufcp_com1_frequency_manual = 118.0
local ufcp_com1_frequency_next = 136.0
local ufcp_com1_power = UFCP_COM_POWER_IDS.HIGH
local ufcp_com1_modulation = UFCP_COM_MODULATION_IDS.AM
local ufcp_com1_sql = true

-- COM 2
local ufcp_com2_mode = UFCP_COM_MODE_IDS.TR
local ufcp_com2_frequency_sel = UFCP_COM_FREQUENCY_SEL_IDS.PRST
local ufcp_com2_channel = 0
local ufcp_com2_frequency = 118
local ufcp_com2_tx = false
local ufcp_com2_rx = false
local ufcp_com2_channels = {118, 119, 120, 121, 122, 123, 124, 125, 126, 127}
local ufcp_com2_max_channel = 78
local ufcp_com2_frequency_manual = 118.0
local ufcp_com2_frequency_next = 136.0
local ufcp_com2_power = UFCP_COM_POWER_IDS.HIGH
local ufcp_com2_modulation = UFCP_COM_MODULATION_IDS.AM
local ufcp_com2_sql = true
local ufcp_com2_sync = false
local ufcp_com2_por = false

-- IDENT
local ufcp_ident = false
local ufcp_ident_blink = false

-- VV/VAH
local ufcp_vvvah_mode = UFCP_VVVAH_MODE_IDS.OFF
local ufcp_vvvah_mode_last = UFCP_VVVAH_MODE_IDS.OFF

-- WPT
local ufcp_wpt_type = UFCP_WPT_TYPE_IDS.FYT
local ufcp_wpt_fyt_num_last = -1
local ufcp_wpt_fyt_num = 0
local ufcp_wpt_lat = 0
local ufcp_wpt_lon = 0
local ufcp_wpt_elv = 0
local ufcp_wpt_time = 0

-- TIME
local ufcp_time_type =  UFCP_TIME_TYPE_IDS.LC

-- NAV
local ufcp_nav_mode = UFCP_NAV_MODE_IDS.AUTO
local ufcp_nav_time = UFCP_NAV_TIME_IDS.TTD
local ufcp_nav_solution = UFCP_NAV_SOLUTION_IDS.NAV_EGI
local ufcp_nav_egi_error = 35 -- meters

-- DRIFT
local ufcp_drift_co = false;

local elapsed = 0

local ufcp_edit_pos = 0
local ufcp_edit_lim = 0
local ufcp_edit_string = ""
local ufcp_edit_validate = nil

-- METHODS

local function ufcp_on()
    return get_elec_avionics_ok() and get_cockpit_draw_argument_value(480) > 0
end

local function ufcp_edit_clear()
    ufcp_edit_pos = 0
    ufcp_edit_lim = 0
    ufcp_edit_string = ""
    ufcp_edit_validate = nil
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

local function replace_pos(text, c_pos)
    local text_copy = text:sub(1,c_pos-1)
    local val = string.byte(text,c_pos)
    if     val >= string.byte("A") and val <= string.byte("Z") then val = val + 32
    elseif val >= string.byte("0") and val <= string.byte("9") then val = val - 34
    elseif val >= string.byte(" ") and val <= string.byte("+") then val = val - 31
    elseif val >= string.byte(",") and val <= string.byte("/") then val = val - 20
    elseif val == string.byte(":") then val = val - 30
    end
    text_copy = text_copy .. string.char(val)
    text_copy = text_copy .. text:sub(c_pos + 1)
    return text_copy
end

-- MAIN
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
    text = text .. "COM1"
    if ufcp_main_sel == UFCP_MAIN_SEL_IDS.COM1 then text = text .. "^" else text = text .. " " end 
    if ufcp_com1_frequency_sel == UFCP_COM_FREQUENCY_SEL_IDS.PRST then
        text = text .. string.format("%02.0f [%07.3f]     ", ufcp_com1_channel, ufcp_com1_frequency)
    else
        text = text .. string.format("%07.3f          ", ufcp_com1_frequency)
    end
    text = text .. "\n"

    -- Line 3
    text = text .. "COM2"
    if ufcp_main_sel == UFCP_MAIN_SEL_IDS.COM2 then text = text .. "^" else text = text .. " " end 
    if ufcp_com2_frequency_sel == UFCP_COM_FREQUENCY_SEL_IDS.PRST then
        text = text .. string.format("%02.0f [%07.3f]  ", ufcp_com2_channel, ufcp_com2_frequency)
    else
        text = text .. string.format("%07.3f       ", ufcp_com2_frequency)
    end
    if ufcp_com2_sync then text = text .. "SOK" else text = text .. "   " end
    text = text .. "\n"

    -- Line 4
    text = text .. UFCP_TIME_TYPE_IDS[ufcp_time_type]
    if ufcp_main_sel == UFCP_MAIN_SEL_IDS.TIME then text = text .. "^" else text = text .. " " end 
    local time = get_absolute_model_time()
    local time_secs = math.floor(time % 60)
    local time_mins = math.floor((time / 60) % 60)
    local time_hours =  math.floor(time / 3600)

    if time_hours >= 100 then
        time_secs = 59
        time_mins = 59
        time_hours =  99
    end

    text = text .. string.format("%02.0f:%02.0f:%02.0f        ", time_hours, time_mins, time_secs)

    if ufcp_com2_por then text = text .. "POR" else text = text .. "   " end
    text = text .. "\n"

    -- Line 5
    local ufcp_total_fuel = EICAS_FUEL_INIT:get()
    local ufcp_xpdr = 2000
    text = text .. string.format("%04.0fKG      %04.0f  ", ufcp_total_fuel, ufcp_xpdr)
    if ufcp_ident and ufcp_ident_blink then text = text .. "IDNT" else text = text .. "    " end

    UFCP_TEXT:set(text)
end

function SetCommandMain(command,value)
    if command == device_commands.UFCP_JOY_DOWN and value == 1 then
        ufcp_main_sel = (ufcp_main_sel + 1) % 4
    elseif command == device_commands.UFCP_JOY_UP and value == 1 then
        ufcp_main_sel = (ufcp_main_sel - 1) % 4
    elseif command == device_commands.UFCP_1 and value == 1 then
        ufcp_vvvah_mode_sel = ufcp_vvvah_mode
        ufcp_sel_format = UFCP_FORMAT_IDS.VVVAH
    elseif command == device_commands.UFCP_2 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.DA_H
    elseif command == device_commands.UFCP_3 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.F_ACK
    elseif command == device_commands.UFCP_4 and value == 1 then
        ufcp_wpt_sel = UFCP_WPT_SEL_IDS.FYT_WP
        ufcp_sel_format = UFCP_FORMAT_IDS.WPT
        ufcp_edit_clear()
    elseif command == device_commands.UFCP_5 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.XPDR
    elseif command == device_commands.UFCP_6 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.TIME
    elseif command == device_commands.UFCP_ENTR and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.DL_MENU
    elseif command == device_commands.UFCP_7 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.MARK
    elseif command == device_commands.UFCP_8 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.FIX
    elseif command == device_commands.UFCP_9 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.TIP
    elseif command == device_commands.UFCP_JOY_RIGHT and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.MENU
    elseif ufcp_main_sel == UFCP_MAIN_SEL_IDS.FYT and AVIONICS_ANS_MODE:get() ~= AVIONICS_ANS_MODE_IDS.GPS and cmfd ~= nil then
        if command == device_commands.UFCP_UP and value == 1 then 
            cmfd:performClickableAction(device_commands.NAV_INC_FYT, 1, true)
        elseif command == device_commands.UFCP_DOWN and value == 1 then
            cmfd:performClickableAction(device_commands.NAV_DEC_FYT, 1, true)
        end
    elseif ufcp_main_sel == UFCP_MAIN_SEL_IDS.COM1 then
        if ufcp_com1_frequency_sel == UFCP_COM_FREQUENCY_SEL_IDS.PRST then
            if command == device_commands.UFCP_UP and value == 1 and ufcp_com1_channel < ufcp_com1_max_channel then
                ufcp_com1_channel = (ufcp_com1_channel + 1)
                ufcp_com1_frequency = ufcp_com1_channels[ufcp_com1_channel + 1]
            elseif command == device_commands.UFCP_DOWN and value == 1 and ufcp_com1_channel > 0 then
                ufcp_com1_channel = (ufcp_com1_channel - 1)
                ufcp_com1_frequency = ufcp_com1_channels[ufcp_com1_channel + 1]
            end
        end
        if command == device_commands.UFCP_0 and value == 1 then
            if ufcp_com1_frequency_sel == UFCP_COM_FREQUENCY_SEL_IDS.PRST then
                ufcp_com1_frequency_sel = UFCP_COM_FREQUENCY_SEL_IDS.MAN
                ufcp_com1_frequency = ufcp_com1_frequency_manual
            else
                ufcp_com1_frequency_sel = UFCP_COM_FREQUENCY_SEL_IDS.PRST
                ufcp_com1_frequency = ufcp_com1_channels[ufcp_com1_channel + 1]
            end
        end
    elseif ufcp_main_sel == UFCP_MAIN_SEL_IDS.COM2 then
        if ufcp_com2_frequency_sel == UFCP_COM_FREQUENCY_SEL_IDS.PRST then
            if command == device_commands.UFCP_UP and value == 1 and ufcp_com2_channel < ufcp_com2_max_channel then
                ufcp_com2_channel = (ufcp_com2_channel + 1)
                ufcp_com2_frequency = ufcp_com2_channels[ufcp_com2_channel + 1]
            elseif command == device_commands.UFCP_DOWN and value == 1 and ufcp_com2_channel > 0 then
                ufcp_com2_channel = (ufcp_com2_channel - 1)
                ufcp_com2_frequency = ufcp_com2_channels[ufcp_com1_channel + 1]
            end
        end
        if command == device_commands.UFCP_0 and value == 1 then
            if ufcp_com2_frequency_sel == UFCP_COM_FREQUENCY_SEL_IDS.PRST then
                ufcp_com2_frequency_sel = UFCP_COM_FREQUENCY_SEL_IDS.MAN
                ufcp_com2_frequency = ufcp_com2_frequency_manual
            else
                ufcp_com2_frequency_sel = UFCP_COM_FREQUENCY_SEL_IDS.PRST
                ufcp_com2_frequency = ufcp_com2_channels[ufcp_com2_channel + 1]
            end
        end
    end
end

-- COM 1
local ufcp_com1_sel = 0
local function update_com1()
    local text = ""

    -- Line 1
    text = text .. "       COM 1   "
    if ufcp_com1_sel == UFCP_COM1_SEL_IDS.MODE then text = text .. "*" else text = text .. " " end
    if ufcp_com1_mode == UFCP_COM_MODE_IDS.OFF then
        text = text .. "OFF "
    elseif ufcp_com1_mode == UFCP_COM_MODE_IDS.TR then
        text = text .. "TR  "
    elseif ufcp_com1_mode == UFCP_COM_MODE_IDS.TR_G then
        text = text .. "TR+G"
    end
    if ufcp_com1_sel == UFCP_COM1_SEL_IDS.MODE then text = text .. "*" else text = text .. " " end
    text = text .. "\n"

    -- Line 2
    text = text .. " MAN  "
    if ufcp_com1_sel == UFCP_COM1_SEL_IDS.MAN_FREQUENCY then text = text .. "*" else text = text .. " " end
    text = text .. string.format("%07.3f", ufcp_com1_frequency_manual)
    if ufcp_com1_sel == UFCP_COM1_SEL_IDS.MAN_FREQUENCY then text = text .. "*" else text = text .. " " end
    text = text .. "         "
    text = text .. "\n"

    -- Line 3
    text = text .. " PRST "
    if ufcp_com1_sel == UFCP_COM1_SEL_IDS.CHANNEL then text = text .. "*" else text = text .. " " end
    text = text .. string.format("%02.0f", ufcp_com1_channel)
    if ufcp_com1_sel == UFCP_COM1_SEL_IDS.CHANNEL then text = text .. "*" else text = text .. " " end
    text = text .. "^"
    if ufcp_com1_sel == UFCP_COM1_SEL_IDS.PRST_FREQUENCY then text = text .. "*" else text = text .. " " end
    text = text .. string.format("%07.3f", ufcp_com1_channels[ufcp_com1_channel + 1])
    if ufcp_com1_sel == UFCP_COM1_SEL_IDS.PRST_FREQUENCY then text = text .. "*" else text = text .. " " end
    text = text .. " "
    if ucfp_com1_tx then text = text .. "TX" else text = text .. "  " end
    text = text .. " "
    text = text .. "\n"

    -- Line 4
    text = text .. " NEXT "
    if ufcp_com1_sel == UFCP_COM1_SEL_IDS.NEXT_FREQUENCY then text = text .. "*" else text = text .. " " end
    text = text .. string.format("%07.3f", ufcp_com1_frequency_next)
    if ufcp_com1_sel == UFCP_COM1_SEL_IDS.NEXT_FREQUENCY then text = text .. "*" else text = text .. " " end
    text = text .. "     "
    text = text .. " "
    if ucfp_com1_rx then text = text .. "RX" else text = text .. "  " end
    text = text .. " "
    text = text .. "\n"

    -- Line 5
    text = text .. "POWER"
    if ufcp_com1_sel == UFCP_COM1_SEL_IDS.POWER then text = text .. "*" else text = text .. " " end
    if ufcp_com1_power == UFCP_COM_POWER_IDS.HIGH then
        text = text .. "HIGH"
    elseif ufcp_com1_power == UFCP_COM_POWER_IDS.MED then
        text = text .. "MED "
    elseif ufcp_com1_power == UFCP_COM_POWER_IDS.LOW then
        text = text .. "LOW "
    end
    if ufcp_com1_sel == UFCP_COM1_SEL_IDS.POWER then text = text .. "*" else text = text .. " " end
    text = text .. " "
    if ufcp_com1_sel == UFCP_COM1_SEL_IDS.MODULATION then text = text .. "*" else text = text .. " " end
    if ufcp_com1_modulation == UFCP_COM_MODULATION_IDS.FM then
        text = text .. "FM"
    else
        text = text .. "AM"
    end
    if ufcp_com1_sel == UFCP_COM1_SEL_IDS.MODULATION then text = text .. "*" else text = text .. " " end

    if ufcp_com1_sel == UFCP_COM1_SEL_IDS.SQL then text = text .. "*" else text = text .. " " end
    text = text .. "SQL"
    if ufcp_com1_sel == UFCP_COM1_SEL_IDS.SQL then text = text .. "*" else text = text .. " " end
    text = text .. " "

    if ufcp_com1_frequency_sel == UFCP_COM_FREQUENCY_SEL_IDS.MAN then 
        text = replace_pos(text, 23)
        text = replace_pos(text, 27)
    else
        text = replace_pos(text, 48)
        text = replace_pos(text, 53)
    end

    if ufcp_com1_sql then
        text = replace_pos(text, 114)
        text = replace_pos(text, 118)
    end

    UFCP_TEXT:set(text)
end

function SetCommandCom1(command,value)
    if command == device_commands.UFCP_JOY_DOWN and value == 1 then
        ufcp_com1_sel = (ufcp_com1_sel + 1) % 8
    elseif command == device_commands.UFCP_JOY_UP and value == 1 then
        ufcp_com1_sel = (ufcp_com1_sel - 1) % 8
    elseif ufcp_com1_sel == UFCP_COM1_SEL_IDS.MAN_FREQUENCY and command == device_commands.UFCP_0 and value == 1 then
        ufcp_com1_frequency_sel = UFCP_COM_FREQUENCY_SEL_IDS.MAN
        ufcp_com1_frequency = ufcp_com1_frequency_manual
        ufcp_sel_format = UFCP_FORMAT_IDS.MAIN
    elseif ufcp_com1_sel == UFCP_COM1_SEL_IDS.CHANNEL then
        if command == device_commands.UFCP_UP and value == 1 and ufcp_com1_channel < ufcp_com1_max_channel then
            ufcp_com1_channel = (ufcp_com1_channel + 1)
            if ufcp_com1_frequency_sel == UFCP_COM_FREQUENCY_SEL_IDS.PRST then
                ufcp_com1_frequency = ufcp_com1_channels[ufcp_com1_channel + 1]
            end
        elseif command == device_commands.UFCP_DOWN and value == 1 and ufcp_com1_channel > 0 then
            ufcp_com1_channel = (ufcp_com1_channel - 1)
            if ufcp_com1_frequency_sel == UFCP_COM_FREQUENCY_SEL_IDS.PRST then
                ufcp_com1_frequency = ufcp_com1_channels[ufcp_com1_channel + 1]
            end
        elseif command == device_commands.UFCP_0 and value == 1 then
            ufcp_com1_frequency_sel = UFCP_COM_FREQUENCY_SEL_IDS.PRST
            ufcp_com1_frequency = ufcp_com1_channels[ufcp_com1_channel + 1]
            ufcp_sel_format = UFCP_FORMAT_IDS.MAIN
        end
    elseif ufcp_com1_sel == UFCP_COM1_SEL_IDS.PRST_FREQUENCY then

    elseif ufcp_com1_sel == UFCP_COM1_SEL_IDS.NEXT_FREQUENCY and command == device_commands.UFCP_0 and value == 1 then
        local current_frequency_manual = ufcp_com1_frequency_manual
        ufcp_com1_frequency_manual = ufcp_com1_frequency_next
        ufcp_com1_frequency_next = current_frequency_manual
        ufcp_com1_frequency_sel = UFCP_COM_FREQUENCY_SEL_IDS.MAN
        ufcp_com1_frequency = ufcp_com1_frequency_manual
        ufcp_sel_format = UFCP_FORMAT_IDS.MAIN
    elseif ufcp_com1_sel == UFCP_COM1_SEL_IDS.POWER and command == device_commands.UFCP_JOY_RIGHT and value == 1 then
        ufcp_com1_power = (ufcp_com1_power + 1) % 3
    elseif ufcp_com1_sel == UFCP_COM1_SEL_IDS.MODULATION and command == device_commands.UFCP_JOY_RIGHT and value == 1 then
        ufcp_com1_modulation = (ufcp_com1_modulation + 1) % 2
    elseif ufcp_com1_sel == UFCP_COM1_SEL_IDS.SQL and command == device_commands.UFCP_0 and value == 1 then
        ufcp_com1_sql = not ufcp_com1_sql
    elseif ufcp_com1_sel == UFCP_COM1_SEL_IDS.MODE and command == device_commands.UFCP_JOY_RIGHT and value == 1 then
        ufcp_com1_mode = (ufcp_com1_mode + 1) % 3
    end
end

-- COM 2
local ufcp_com2_sel = 0
local function update_com2()
    local text = ""

    if ufcp_sel_format == UFCP_FORMAT_IDS.COM2 then
        -- Line 1
        text = text .. "      "
        if ufcp_com2_sel == UFCP_COM2_SEL_IDS.FORMAT then text = text .. "*" else text = text .. " " end
        text = text .. "COM 2"
        if ufcp_com2_sel == UFCP_COM2_SEL_IDS.FORMAT then text = text .. "*" else text = text .. " " end
        text = text .. "  "
        if ufcp_com2_sel == UFCP_COM2_SEL_IDS.MODE then text = text .. "*" else text = text .. " " end
        if ufcp_com2_mode == UFCP_COM_MODE_IDS.OFF then
            text = text .. "OFF "
        elseif ufcp_com2_mode == UFCP_COM_MODE_IDS.TR then
            text = text .. "TR  "
        elseif ufcp_com2_mode == UFCP_COM_MODE_IDS.TR_G then
            text = text .. "TR+G"
        end
        if ufcp_com2_sel == UFCP_COM2_SEL_IDS.MODE then text = text .. "*" else text = text .. " " end
        text = text .. "\n"

        -- Line 2
        text = text .. " MAN  "
        if ufcp_com2_sel == UFCP_COM2_SEL_IDS.MAN_FREQUENCY then text = text .. "*" else text = text .. " " end
        text = text .. string.format("%07.3f", ufcp_com2_frequency_manual)
        if ufcp_com2_sel == UFCP_COM2_SEL_IDS.MAN_FREQUENCY then text = text .. "*" else text = text .. " " end
        text = text .. "         "
        text = text .. "\n"
    
        -- Line 3
        text = text .. " PRST "
        if ufcp_com2_sel == UFCP_COM2_SEL_IDS.CHANNEL then text = text .. "*" else text = text .. " " end
        text = text .. string.format("%02.0f", ufcp_com2_channel)
        if ufcp_com2_sel == UFCP_COM2_SEL_IDS.CHANNEL then text = text .. "*" else text = text .. " " end
        text = text .. "^"
        if ufcp_com2_sel == UFCP_COM2_SEL_IDS.PRST_FREQUENCY then text = text .. "*" else text = text .. " " end
        text = text .. string.format("%07.3f", ufcp_com2_channels[ufcp_com2_channel + 1])
        if ufcp_com2_sel == UFCP_COM2_SEL_IDS.PRST_FREQUENCY then text = text .. "*" else text = text .. " " end
        text = text .. " "
        if ucfp_com2_tx then text = text .. "TX" else text = text .. "  " end
        text = text .. " "
        text = text .. "\n"
    
        -- Line 4
        text = text .. " NEXT "
        if ufcp_com2_sel == UFCP_COM2_SEL_IDS.NEXT_FREQUENCY then text = text .. "*" else text = text .. " " end
        text = text .. string.format("%07.3f", ufcp_com2_frequency_next)
        if ufcp_com2_sel == UFCP_COM2_SEL_IDS.NEXT_FREQUENCY then text = text .. "*" else text = text .. " " end
        text = text .. "     "
        text = text .. " "
        if ucfp_com1_rx then text = text .. "RX" else text = text .. "  " end
        text = text .. " "
        text = text .. "\n"
    
        -- Line 5
        text = text .. "POWER"
        if ufcp_com2_sel == UFCP_COM2_SEL_IDS.POWER then text = text .. "*" else text = text .. " " end
        if ufcp_com2_power == UFCP_COM_POWER_IDS.HIGH then
            text = text .. "HIGH"
        elseif ufcp_com2_power == UFCP_COM_POWER_IDS.MED then
            text = text .. "MED "
        elseif ufcp_com2_power == UFCP_COM_POWER_IDS.LOW then
            text = text .. "LOW "
        end
        if ufcp_com2_sel == UFCP_COM2_SEL_IDS.POWER then text = text .. "*" else text = text .. " " end
        text = text .. " "
        if ufcp_com2_sel == UFCP_COM2_SEL_IDS.MODULATION then text = text .. "*" else text = text .. " " end
        if ufcp_com2_modulation == UFCP_COM_MODULATION_IDS.FM then
            text = text .. "FM"
        else
            text = text .. "AM"
        end
        if ufcp_com2_sel == UFCP_COM2_SEL_IDS.MODULATION then text = text .. "*" else text = text .. " " end
        if ufcp_com2_sel == UFCP_COM2_SEL_IDS.SQL then text = text .. "*" else text = text .. " " end
        text = text .. "SQL"
        if ufcp_com2_sel == UFCP_COM2_SEL_IDS.SQL then text = text .. "*" else text = text .. " " end
        text = text .. " "

        if ufcp_com2_frequency_sel == UFCP_COM_FREQUENCY_SEL_IDS.MAN then 
            text = replace_pos(text, 23)
            text = replace_pos(text, 27)
        else
            text = replace_pos(text, 48)
            text = replace_pos(text, 53)
        end
    
        if ufcp_com2_sql then
            text = replace_pos(text, 114)
            text = replace_pos(text, 118)
        end
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.COM2_NET then
        text = text .. "COM 2-NET"
    end

    UFCP_TEXT:set(text)
end

function SetCommandCom2(command,value)
    if command == device_commands.UFCP_JOY_DOWN and value == 1 then
        ufcp_com2_sel = (ufcp_com2_sel + 1) % 9
    elseif command == device_commands.UFCP_JOY_UP and value == 1 then
        ufcp_com2_sel = (ufcp_com2_sel - 1) % 9
    elseif ufcp_com2_sel == UFCP_COM2_SEL_IDS.MAN_FREQUENCY and command == device_commands.UFCP_0 and value == 1 then
        ufcp_com2_frequency_sel = UFCP_COM_FREQUENCY_SEL_IDS.MAN
        ufcp_com2_frequency = ufcp_com2_frequency_manual
        ufcp_sel_format = UFCP_FORMAT_IDS.MAIN
    elseif ufcp_com2_sel == UFCP_COM2_SEL_IDS.CHANNEL then
        if command == device_commands.UFCP_UP and value == 1 and ufcp_com2_channel < ufcp_com2_max_channel then
            ufcp_com2_channel = (ufcp_com2_channel + 1)
            if ufcp_com2_frequency_sel == UFCP_COM_FREQUENCY_SEL_IDS.PRST then
                ufcp_com2_frequency = ufcp_com2_channels[ufcp_com2_channel + 1]
            end
        elseif command == device_commands.UFCP_DOWN and value == 1 and ufcp_com2_channel > 0 then
            ufcp_com2_channel = (ufcp_com2_channel - 1)
            if ufcp_com2_frequency_sel == UFCP_COM_FREQUENCY_SEL_IDS.PRST then
                ufcp_com2_frequency = ufcp_com2_channels[ufcp_com2_channel + 1]
            end
        elseif command == device_commands.UFCP_0 and value == 1 then
            ufcp_com2_frequency_sel = UFCP_COM_FREQUENCY_SEL_IDS.PRST
            ufcp_com2_frequency = ufcp_com2_channels[ufcp_com2_channel + 1]
            ufcp_sel_format = UFCP_FORMAT_IDS.MAIN
        end
    elseif ufcp_com2_sel == UFCP_COM2_SEL_IDS.PRST_FREQUENCY then

    elseif ufcp_com2_sel == UFCP_COM2_SEL_IDS.NEXT_FREQUENCY and command == device_commands.UFCP_0 and value == 1 then
        local current_frequency_manual = ufcp_com2_frequency_manual
        ufcp_com2_frequency_manual = ufcp_com2_frequency_next
        ufcp_com2_frequency_next = current_frequency_manual
        ufcp_com2_frequency_sel = UFCP_COM_FREQUENCY_SEL_IDS.MAN
        ufcp_com2_frequency = ufcp_com2_frequency_manual
        ufcp_sel_format = UFCP_FORMAT_IDS.MAIN
    elseif ufcp_com2_sel == UFCP_COM2_SEL_IDS.POWER and command == device_commands.UFCP_JOY_RIGHT and value == 1 then
        ufcp_com2_power = (ufcp_com2_power + 1) % 3
    elseif ufcp_com2_sel == UFCP_COM2_SEL_IDS.MODULATION and command == device_commands.UFCP_JOY_RIGHT and value == 1 then
        ufcp_com2_modulation = (ufcp_com2_modulation + 1) % 2
    elseif ufcp_com2_sel == UFCP_COM2_SEL_IDS.SQL and command == device_commands.UFCP_0 and value == 1 then
        ufcp_com2_sql = not ufcp_com2_sql
    elseif ufcp_com2_sel == UFCP_COM2_SEL_IDS.FORMAT and command == device_commands.UFCP_JOY_RIGHT and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.COM2_NET
    elseif ufcp_com2_sel == UFCP_COM2_SEL_IDS.MODE and command == device_commands.UFCP_JOY_RIGHT and value == 1 then
        ufcp_com2_mode = (ufcp_com2_mode + 1) % 3
    end
end

-- NAV AIDS
local function update_nav_aids()
    local text = ""
    text = text .. "NAV AIDS\n"
    UFCP_TEXT:set(text)
end

function SetCommandNavAids(command,value)

end

-- VV/VAH
local ufcp_vvvah_mode_sel = UFCP_VVVAH_MODE_IDS.OFF
local function update_vvvah()
    local text = ""
    text = text .. "VV/VAH\n\n"
    if ufcp_vvvah_mode_sel == UFCP_VVVAH_MODE_IDS.VAH    then  text = text .. "*VAH*       \n" else text = text .. " VAH        \n" end
    if ufcp_vvvah_mode_sel == UFCP_VVVAH_MODE_IDS.OFF    then  text = text .. "*OFF*       \n" else text = text .. " OFF        \n" end
    if ufcp_vvvah_mode_sel == UFCP_VVVAH_MODE_IDS.VV_VAH then  text = text .. "*VV/VAH*    "   else text = text .. " VV/VAH     " end
    if ufcp_vvvah_mode == UFCP_VVVAH_MODE_IDS.VAH then text = replace_pos(text, 9); text = replace_pos(text, 13); end
    if ufcp_vvvah_mode == UFCP_VVVAH_MODE_IDS.OFF then text = replace_pos(text, 22); text = replace_pos(text, 26); end
    if ufcp_vvvah_mode == UFCP_VVVAH_MODE_IDS.VV_VAH then text = replace_pos(text, 35); text = replace_pos(text, 42); end

    UFCP_TEXT:set(text)
end

local function SetCommandVVVAH(command,value)
    if command == device_commands.UFCP_JOY_DOWN and value == 1 then
        ufcp_vvvah_mode_sel = (ufcp_vvvah_mode_sel + 1) % (UFCP_VVVAH_MODE_IDS.VV_VAH + 1)
    elseif command == device_commands.UFCP_JOY_UP and value == 1 then
        ufcp_vvvah_mode_sel = (ufcp_vvvah_mode_sel - 1) % (UFCP_VVVAH_MODE_IDS.VV_VAH + 1)
    elseif command == device_commands.UFCP_0 and value == 1 then
        ufcp_vvvah_mode = ufcp_vvvah_mode_sel
    end
end

-- DA/H
local function update_da_h()
    local text = ""
    text = text .. "DA/H\n"
    UFCP_TEXT:set(text)
end

function SetCommandDAH(command,value)

end

-- WPT
local ufcp_wpt_sel = UFCP_WPT_SEL_IDS.FYT_WP
local Terrain = require('terrain')
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

local function update_wpt()
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
        ufcp_wpt_continue_edit("", true)
    end
end

-- XPDR
local function update_xpdr()
    local text = ""
    text = text .. "XPDR\n"
    UFCP_TEXT:set(text)
end

function SetCommandXPDR(command,value)

end

-- TIME
local function update_time()
    local text = ""
    text = text .. "TIME\n"
    UFCP_TEXT:set(text)
end

function SetCommandTime(command,value)

end

-- MARK
local function update_mark()
    local text = ""
    text = text .. "MARK\n"
    UFCP_TEXT:set(text)
end

function SetCommandMark(command,value)

end

-- FIX
local function update_fix()
    local text = ""
    text = text .. "FIX\n"
    UFCP_TEXT:set(text)
end

function SetCommandFix(command,value)

end

-- TIP
local function update_tip()
    local text = ""
    text = text .. "TIP\n"
    UFCP_TEXT:set(text)
end

function SetCommandTip(command,value)

end

-- MENU
local ufcp_menu_sel = 0
local function update_menu()
    local text = ""
    text = text .. "MENU\n"
    text = text .. "1LMT 2DTK  3BAL C ACAL\n"
    text = text .. "4NAV 5WS   6EGI E FUEL\n"
    text = text .. "7TAC 8MODE 9OAP O MISC\n"
    UFCP_TEXT:set(text)
end

function SetCommandMenu(command,value)
    if command == device_commands.UFCP_1 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.LMT
    elseif command == device_commands.UFCP_2 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.DTK
    elseif command == device_commands.UFCP_3 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.BAL
    elseif command == device_commands.UFCP_CLR and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.ACAL
    elseif command == device_commands.UFCP_4 and value == 1 then
        ufcp_menu_sel = 0
        ufcp_sel_format = UFCP_FORMAT_IDS.NAV_MODE
    elseif command == device_commands.UFCP_5 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.WS
    elseif command == device_commands.UFCP_6 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.EGI_INS
    elseif command == device_commands.UFCP_ENTR and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.FUEL
    elseif command == device_commands.UFCP_7 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.TAC_MENU
    elseif command == device_commands.UFCP_8 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.MODE
    elseif command == device_commands.UFCP_9 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.OAP
    elseif command == device_commands.UFCP_0 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.MISC
    elseif command == device_commands.UFCP_JOY_RIGHT and value == 1 then
    elseif command == device_commands.UFCP_UP and value == 1 then
    elseif command == device_commands.UFCP_DOWN and value == 1 then
    end
end

-- LMT
local function update_lmt()
    local text = ""
    text = text .. "FLIGHT LIMITS\n"
    UFCP_TEXT:set(text)
end

-- DTK
local function update_dtk()
    local text = ""
    text = text .. "DTK\n"
    UFCP_TEXT:set(text)
end

-- BAL
local function update_bal()
    local text = ""
    text = text .. "BAL\n"
    UFCP_TEXT:set(text)
end

-- NAV
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

-- WS
local function update_ws()
    local text = ""
    text = text .. "WINGSPAN\n"
    UFCP_TEXT:set(text)
end

-- EGI
local function update_egi()
    local text = ""
    text = text .. "EGI\n"
    UFCP_TEXT:set(text)
end

-- TAC
local function update_tac()
    local text = ""
    text = text .. "TAC MENU\n"
    text = text .. "1CTLN 2AVOID 3        \n"
    text = text .. "4     5      6        \n"
    text = text .. "7     8      9        \n"
    UFCP_TEXT:set(text)
end

function SetCommandTacMenu(command,value)
    if command == device_commands.UFCP_1 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.TAC_CTLN
    elseif command == device_commands.UFCP_2 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.TAC_AVOID
    end
end

-- CTLN
local function update_tac_ctln()
    local text = ""
    text = text .. "TAC CTLN\n"
    UFCP_TEXT:set(text)
end

-- AVOID
local function update_tac_avoid()
    local text = ""
    text = text .. "TAC AVOID\n"
    UFCP_TEXT:set(text)
end

-- MODE
local function update_mode()
    local text = ""
    text = text .. "MODE\n"
    UFCP_TEXT:set(text)
end

-- OAP
local function update_oap()
    local text = ""
    text = text .. "OAP\n"
    UFCP_TEXT:set(text)
end

-- ACAL
local function update_acal()
    local text = ""
    text = text .. "ACAL\n"
    UFCP_TEXT:set(text)
end

-- FUEL
local function update_fuel()
    local text = ""
    text = text .. "FUEL\n"
    UFCP_TEXT:set(text)
end

-- MISC
local function update_misc()
    local text = ""
    text = text .. "MISC\n"
    text = text .. "1C/F  2PARA 3FTI  C  \n"
    text = text .. "4DCLT 5CRUS 6DRFT EDL\n"
    text = text .. "7TK/L 8STRM 9FLIR O  \n"
    UFCP_TEXT:set(text)
end

function SetCommandMisc(command,value)
    if command == device_commands.UFCP_1 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.C_F
    elseif command == device_commands.UFCP_2 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.PARA
    elseif command == device_commands.UFCP_3 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.FTI
    elseif command == device_commands.UFCP_4 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.DCLT
    elseif command == device_commands.UFCP_5 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.CRUS
    elseif command == device_commands.UFCP_6 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.DRFT
    elseif command == device_commands.UFCP_ENTR and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.DL_MENU
    elseif command == device_commands.UFCP_7 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.TK_L_DATA
    elseif command == device_commands.UFCP_8 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.STRM
    elseif command == device_commands.UFCP_9 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.FLIR
    end
end

-- C/F
local function update_c_f()
    local text = ""
    text = text .. "C/F\n"
    UFCP_TEXT:set(text)
end

-- PARA
local function update_para()
    local text = ""
    text = text .. "PARA\n"
    UFCP_TEXT:set(text)
end

-- FTI
local function update_fti()
    local text = ""
    text = text .. "FTI\n"
    UFCP_TEXT:set(text)
end

-- DCLT
local function update_dclt()
    local text = ""
    text = text .. "DCLT\n"
    UFCP_TEXT:set(text)
end

-- CRUS
local function update_crus()
    local text = ""
    text = text .. "CRUS\n"
    UFCP_TEXT:set(text)
end

-- DRFT
local function update_drft()
    local text = ""
    text = text .. "DRIFT\n\n"
    text = text .. "*DRIFT C/O*"
    text = text .. "\n\n"
    if ufcp_drift_co then text = replace_pos(text, 8); text = replace_pos(text, 18) end

    UFCP_TEXT:set(text)
end

function SetCommandDrft(command,value)
    if command == device_commands.UFCP_0 and value == 1 then
        ufcp_drift_co = not ufcp_drift_co
    end
end

-- TK/L
local function update_tk_l()
    local text = ""
    text = text .. "TK/L\n"
    UFCP_TEXT:set(text)
end

-- STRM
local function update_strm()
    local text = ""
    text = text .. "STORMSCOPE\n"
    UFCP_TEXT:set(text)
end

-- FLIR
local function update_flir()
    local text = ""
    text = text .. "FLIR\n"
    UFCP_TEXT:set(text)
end

-- DL MENU
local function update_dl_menu()
    local text = ""
    text = text .. "DL MENU\n"
    text = text .. "1SET  2INV  3MSG  C  \n"
    text = text .. "4DLWP 5SNDP 6     E  \n"
    text = text .. "7     8S    9     O  \n"
    UFCP_TEXT:set(text)
end

function SetCommandDlMenu(command,value)
    if command == device_commands.UFCP_1 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.DL_SET
    elseif command == device_commands.UFCP_2 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.DL_INV
    elseif command == device_commands.UFCP_3 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.DL_MSG
    elseif command == device_commands.UFCP_4 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.DLWP
    elseif command == device_commands.UFCP_5 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.SNDP
    end
end

-- DL SET
local function update_dl_set()
    local text = ""
    text = text .. "DL SET\n"
    UFCP_TEXT:set(text)
end

-- DL_INV
local function update_dl_inv()
    local text = ""
    text = text .. "DL INV\n"
    UFCP_TEXT:set(text)
end

-- DL MSG
local function update_dl_msg()
    local text = ""
    text = text .. "DL MSG\n"
    UFCP_TEXT:set(text)
end

-- DLWP
local function update_dlwp()
    local text = ""
    text = text .. "DLWP\n"
    UFCP_TEXT:set(text)
end

-- SNDP
local function update_sndp()
    local text = ""
    text = text .. "SNDP\n"
    UFCP_TEXT:set(text)
end

function update()
    local ufcp_bright = get_cockpit_draw_argument_value(480)
    if ufcp_on() then 
        UFCP_BRIGHT:set(ufcp_bright) 
    else  
        UFCP_BRIGHT:set(0) 
        return 0
    end

    -- UPDATE FORMATS
    if ufcp_sel_format == UFCP_FORMAT_IDS.MAIN then update_main()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.WPT then update_wpt()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.COM1 then update_com1()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.COM2 or ufcp_sel_format == UFCP_FORMAT_IDS.COM2_NET then update_com2()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.NAV_AIDS then update_nav_aids()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.DA_H then update_da_h()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.WPT then update_wpt()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.XPDR then update_xpdr()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.TIME then update_time()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.DL_MENU then update_dl_menu()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.MARK then update_mark()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.FIX then update_fix()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.VVVAH then update_vvvah()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.TIP then update_tip()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.MENU then update_menu()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.LMT then update_lmt()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.DTK then update_dtk()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.BAL then update_bal()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.ACAL then update_acal()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.NAV_MODE or ufcp_sel_format == UFCP_FORMAT_IDS.NAV_MISC then update_nav()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.WS then update_ws()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.EGI_INS or ufcp_sel_format == UFCP_FORMAT_IDS.EGI_GPS then update_egi()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.FUEL then update_fuel()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.TAC_MENU then update_tac()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.TAC_CTLN then update_tac_ctln()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.TAC_AVOID then update_tac_avoid()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.MODE then update_mode()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.OAP then update_oap()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.MISC then update_misc()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.C_F then update_c_f()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.PARA then update_para()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.FTI then update_fti()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.DCLT then update_dclt()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.CRUS then update_crus()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.DRFT then update_drft()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.TK_L_DATA or ufcp_sel_format == UFCP_FORMAT_IDS.TK_L_TKOF or ufcp_sel_format == UFCP_FORMAT_IDS.TK_L_LAND then update_tk_l()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.STRM then update_strm()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.FLIR then update_flir()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.DL_SET then update_dl_set()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.DL_INV then update_dl_inv()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.DL_MSG then update_dl_msg()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.DLWP then update_dlwp()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.SNDP then update_sndp()
    end

    -- UPDATE VV/VAH MODE
    if ufcp_vvvah_mode == UFCP_VVVAH_MODE_IDS.VAH then
        UFCP_VV:set(0)
        ADHSI_VV:set(0)
        UFCP_VAH:set(1)
    elseif ufcp_vvvah_mode == UFCP_VVVAH_MODE_IDS.VV_VAH then 
        if get_avionics_master_mode() == AVIONICS_MASTER_MODE_ID.NAV or get_avionics_master_mode() == AVIONICS_MASTER_MODE_ID.LANDING then
            UFCP_VV:set(1)
            ADHSI_VV:set(1)
        else
            UFCP_VV:set(0)
            ADHSI_VV:set(0)
        end
        UFCP_VAH:set(1)
    elseif ufcp_vvvah_mode == UFCP_VVVAH_MODE_IDS.OFF then 
        UFCP_VV:set(0)
        UFCP_VAH:set(0)
        ADHSI_VV:set(0)
    end

    -- UPDATE DRIFT C/O MODE
    if ufcp_drift_co or get_avionics_master_mode_ag() then
        HUD_DRIFT_CO:set(1)
    else
        HUD_DRIFT_CO:set(0)
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
    if birth=="GROUND_HOT" or birth=="AIR_HOT" then
        dev:performClickableAction(device_commands.UFCP_EGI, 1, true)
        dev:performClickableAction(device_commands.UFCP_DVR, 0, true)
        dev:performClickableAction(device_commands.UFCP_RALT, 1, true)
    elseif birth=="GROUND_COLD" then
        dev:performClickableAction(device_commands.UFCP_EGI, 0.15, true)
        dev:performClickableAction(device_commands.UFCP_DVR, -1, true)
        dev:performClickableAction(device_commands.UFCP_RALT, 0, true)
    end
    dev:performClickableAction(device_commands.UFCP_UFC, 1, true)
    dev:performClickableAction(device_commands.UFCP_DAY_NIGHT, 0, true)

    startup_print("ufcs: postinit end")
end



dev:listen_command(device_commands.UFCP_WARNRST)
dev:listen_command(device_commands.UFCP_4)
dev:listen_command(device_commands.UFCP_BARO_RALT)

local HUD_VAH = get_param_handle("HUD_VAH")
HUD_VAH:set(0)

function SetCommandCommon(command, value)
    if command == device_commands.UFCP_JOY_DOWN and value == 1 then
        ufcp_menu_sel = ufcp_menu_sel + 1
    elseif command == device_commands.UFCP_JOY_UP and value == 1 then
        ufcp_menu_sel = ufcp_menu_sel - 1
    elseif command == device_commands.UFCP_COM1 and value == 1 then
        ucfp_sel_format = UFCP_FORMAT_IDS.COM1
    elseif command == device_commands.UFCP_COM2 and value == 1 then
        ucfp_sel_format = UFCP_FORMAT_IDS.COM2
    elseif command == device_commands.UFCP_NAVAIDS and value == 1 then
        ucfp_sel_format = UFCP_FORMAT_IDS.NAV_AIDS
    end
end

function SetCommand(command,value)
    debug_message_to_user("ufcs: command "..tostring(command).." = "..tostring(value))
    if not ufcp_on() then return 0 end
    if command==device_commands.UFCP_WARNRST and value == 1 then
        alarm:SetCommand(command, value)
        hud:SetCommand(command, value)
    elseif command == device_commands.UFCP_COM1 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.COM1
    elseif command == device_commands.UFCP_COM2 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.COM2
    elseif command == device_commands.UFCP_NAVAIDS and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.NAV_AIDS
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
    elseif command == device_commands.UFCP_VV and value == 1 then
        if ufcp_vvvah_mode == UFCP_VVVAH_MODE_IDS.VV_VAH then 
            ufcp_vvvah_mode = ufcp_vvvah_mode_last
        elseif ufcp_vvvah_mode == UFCP_VVVAH_MODE_IDS.VAH or ufcp_vvvah_mode == UFCP_VVVAH_MODE_IDS.OFF then 
            ufcp_vvvah_mode_last = ufcp_vvvah_mode
            ufcp_vvvah_mode = UFCP_VVVAH_MODE_IDS.VV_VAH
        end
    end

    if ufcp_sel_format == UFCP_FORMAT_IDS.MAIN then SetCommandMain(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.COM1 then SetCommandCom1(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.COM2 then SetCommandCom2(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.VVVAH then SetCommandVVVAH(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.DA_H then SetCommandDAH(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.WPT then SetCommandWpt(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.XPDR then SetCommandXPDR(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.TIME then SetCommandTime(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.MARK then SetCommandMark(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.FIX then SetCommandFix(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.TIP then SetCommandTip(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.MENU then SetCommandMenu(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.NAV_MODE or ufcp_sel_format == UFCP_FORMAT_IDS.NAV_MISC then SetCommandNav(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.TAC_MENU then SetCommandTacMenu(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.MISC then SetCommandMisc(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.DRFT then SetCommandDrft(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.DL_MENU then SetCommandDlMenu(command, value)
    end
end


startup_print("ufcs: load end")
need_to_be_closed = false -- close lua state after initialization


