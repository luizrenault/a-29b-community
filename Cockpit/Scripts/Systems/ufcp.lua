dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."Systems/avionics_api.lua")
dofile(LockOn_Options.script_path.."utils.lua")
dofile(LockOn_Options.script_path.."dump.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_api.lua")
dofile(LockOn_Options.script_path.."Systems/weapon_system_api.lua")
dofile(LockOn_Options.script_path.."Systems/coordinate_api.lua")

startup_print("ufcs: load")

dev = GetSelf()
local alarm 
local hud
local cmfd

update_time_step = 0.02 --update will be called 50 times per second
make_default_activity(update_time_step)

sensor_data = get_base_data()
Terrain = require('terrain')

local UFCP_BRIGHT = get_param_handle("UFCP_BRIGHT")
local ADHSI_VV = get_param_handle("ADHSI_VV")
local TIME_RUN = get_param_handle("UFCP_TIME_RUN")
local DVR_SWITCH_STATE = get_param_handle("UFCP_DVR_SWITCH_STATE")
local RALT_SWITCH_STATE = get_param_handle("UFCP_RALT_SWITCH_STATE")

-- Variables
ufcp_sel_format = UFCP_FORMAT_IDS.MAIN
ufcp_ident = false
ufcp_ident_blink = false
elapsed = 0
local ufcp_overriden_format = UFCP_FORMAT_IDS.MAIN

-- Data insertion
ufcp_edit_pos = 0
ufcp_edit_lim = 0
ufcp_edit_string = ""
ufcp_edit_validate = nil
ufcp_edit_field_info = nil
ufcp_edit_invalid = false
ufcp_edit_backspace = false

ufcp_cmfd_ref = nil


-- METHODS

-- Check if an array has a specific element.
function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

-- Used by COM1 and COM2 formats
function is_com_frequency(frequency)
    if frequency < 108 then return false
    elseif frequency >= 174 and frequency < 225 then return false
    elseif frequency >= 400 then return false
    elseif (frequency < 118 or frequency >= 137) and (frequency * 1000) % 25 > 0 then return false
    elseif frequency >= 118 and frequency < 137 and not has_value({0,8,16,25,33,41}, (frequency * 1000) % 50) then return false
    else return true
    end
end

local function ufcp_on()
    return get_elec_avionics_ok() and get_cockpit_draw_argument_value(480) > 0
end

-- Clears the data being inserted.
function ufcp_edit_clear()
    ufcp_edit_pos = 0
    ufcp_edit_lim = 0
    ufcp_edit_string = ""
    ufcp_edit_validate = nil
    ufcp_edit_field_info = nil
    ufcp_edit_invalid = false
    ufcp_edit_backspace = false
end

-- Returns the inputed data plus blank spaces to fill the size limit
function ufcp_print_edit(rtl)
    local available = ufcp_edit_lim - ufcp_edit_pos
    local blank = ""
    for i = 1,available do blank = blank .. " " end

    -- if rtl, it will align the input to the right
    local text = ""
    if rtl then text = blank .. ufcp_edit_string else text = ufcp_edit_string .. blank end

    if ufcp_edit_invalid then text = blink_text(text,1,text:len()) end
    return text
end

-- Called by the CLR button. Pressing once erases the last digit. Pressing again clears everything.
function ufcp_undo_edit()
    if ufcp_edit_pos > 0 then
        if ufcp_edit_backspace or ufcp_edit_invalid then
            -- Erase everything
            ufcp_edit_clear()
        else
            -- Erase a single digit
            ufcp_edit_backspace = true
            ufcp_edit_string = ufcp_edit_string:sub(1, ufcp_edit_pos-1)
            ufcp_edit_pos = ufcp_edit_string:len()
        end
    end
end

function ufcp_continue_edit(text, field_info, save)
    -- field_info should be an array, the first value being the total amount of characters
    -- the input should have, and the second one being a method to validate that input,
    -- with a 'text' string and an optional 'save' bool as parameters.
    -- Example: field_info = {3, ufcp_xpdr_code_validate}

    if field_info == nil then   -- nothing to do here
        return
    end

    -- Hasn't started editing yet
    if ufcp_edit_field_info ~= field_info then
        ufcp_edit_clear()
        ufcp_edit_field_info = field_info
        ufcp_edit_lim = field_info[1] or 1  -- set the total of characters
        ufcp_edit_validate = field_info[2]  -- set the validate method
    end

    

    local available = ufcp_edit_lim - ufcp_edit_pos -- how many characters are left
    if available < text:len() then text=text:sub(1,available) end -- text cant be larger than available space
    ufcp_edit_string = ufcp_edit_string .. text -- add the character to edit string
    ufcp_edit_backspace = false -- resets the CLR button
    if ufcp_edit_validate then ufcp_edit_string = ufcp_edit_validate(ufcp_edit_string, save) end    -- try to validate the input
    if ufcp_edit_string:len() > ufcp_edit_lim then ufcp_edit_string = ufcp_edit_string:sub(1,ufcp_edit_lim) end -- text cant be larger than available space
    ufcp_edit_pos = ufcp_edit_string:len()  -- update the cursor position
end

function replace_text(text, c_start, c_size)
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

function blink_text(text, c_start, c_size)
    local text_copy = text:sub(1,c_start-1)
    local text_new = text:sub(c_start, c_start+c_size-1)

    local interval = math.floor(2 * get_absolute_model_time() % 2)

    for i=1, c_size do
        if interval == 0 then
            text_copy = text_copy .. string.char(string.byte(text_new,i))
        else
            text_copy = text_copy .. string.char(string.byte(" "))
        end
    end
    text_copy = text_copy .. text:sub(c_start + c_size)
    return text_copy
end

function replace_pos(text, c_pos)
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

function seconds_to_string(time)
    local time_sign = ""
    if time < 0 then time_sign = "-"; time = -time end
        
    local time_secs = math.floor(time % 60)
    local time_mins = math.floor((time / 60) % 60)
    local time_hours =  math.floor(time / 3600)

    if time_hours >= 100 then
        time_secs = 59
        time_mins = 59
        time_hours = 99
    end

    return time_sign .. string.format("%02.0f:%02.0f:%02.0f", time_hours, time_mins, time_secs)
end

local return_to_main_time = -1.0
-- Return to MAIN if current master mode is A/G or AA and the format only works in NAV.
function ufcp_nav_only()
    local master_mode = get_avionics_master_mode()
    if get_avionics_master_mode_aa(master_mode) or get_avionics_master_mode_ag(master_mode) then
        -- Return to MAIN after 0.5 seconds
        if return_to_main_time == -1.0 then
            return_to_main_time = ufcp_time + 0.5
        end

        if ufcp_time > return_to_main_time then
            ufcp_edit_clear()
            ufcp_sel_format = UFCP_FORMAT_IDS.MAIN
            return_to_main_time = -1.0
        end
    else
        return_to_main_time = -1.0
    end
end

-- TODO Will do nothing until INS is implemented.
-- Return to MAIN if current EGI mode is not INS and the format only works in INS.
local return_to_main_time2 = -1.0
function ufcp_ins_only()
    if true then
        -- Return to MAIN after 0.5 seconds
        if return_to_main_time2 == -1.0 then
            return_to_main_time2 = ufcp_time + 0.5
        end

        if ufcp_time > return_to_main_time2 then
            ufcp_edit_clear()
            ufcp_sel_format = UFCP_FORMAT_IDS.MAIN
            return_to_main_time2 = -1.0
        end
    else
        return_to_main_time2 = -1.0
    end
end

dofile(LockOn_Options.script_path.."Systems/UFCP/main.lua")
dofile(LockOn_Options.script_path.."Systems/UFCP/ufcp_com1.lua")
dofile(LockOn_Options.script_path.."Systems/UFCP/ufcp_com2.lua")
dofile(LockOn_Options.script_path.."Systems/UFCP/navaids.lua")
dofile(LockOn_Options.script_path.."Systems/UFCP/vvvah.lua")
dofile(LockOn_Options.script_path.."Systems/UFCP/dah.lua")
dofile(LockOn_Options.script_path.."Systems/UFCP/wpt.lua")
dofile(LockOn_Options.script_path.."Systems/UFCP/xpdr.lua")
dofile(LockOn_Options.script_path.."Systems/UFCP/time.lua")
dofile(LockOn_Options.script_path.."Systems/UFCP/mark.lua")
dofile(LockOn_Options.script_path.."Systems/UFCP/fix.lua")
dofile(LockOn_Options.script_path.."Systems/UFCP/tip.lua")
dofile(LockOn_Options.script_path.."Systems/UFCP/menu.lua")
dofile(LockOn_Options.script_path.."Systems/UFCP/lmt.lua")
dofile(LockOn_Options.script_path.."Systems/UFCP/dtk.lua")
dofile(LockOn_Options.script_path.."Systems/UFCP/bal.lua")
dofile(LockOn_Options.script_path.."Systems/UFCP/acal.lua")
dofile(LockOn_Options.script_path.."Systems/UFCP/nav.lua")
dofile(LockOn_Options.script_path.."Systems/UFCP/ws.lua")
dofile(LockOn_Options.script_path.."Systems/UFCP/egi.lua")
dofile(LockOn_Options.script_path.."Systems/UFCP/fuel.lua")
dofile(LockOn_Options.script_path.."Systems/UFCP/tac.lua")
dofile(LockOn_Options.script_path.."Systems/UFCP/mode.lua")
dofile(LockOn_Options.script_path.."Systems/UFCP/oap.lua")
dofile(LockOn_Options.script_path.."Systems/UFCP/cf.lua")
dofile(LockOn_Options.script_path.."Systems/UFCP/para.lua")
dofile(LockOn_Options.script_path.."Systems/UFCP/fti.lua")
dofile(LockOn_Options.script_path.."Systems/UFCP/dclt.lua")
dofile(LockOn_Options.script_path.."Systems/UFCP/crus.lua")
dofile(LockOn_Options.script_path.."Systems/UFCP/drft.lua")
dofile(LockOn_Options.script_path.."Systems/UFCP/tkl.lua")
dofile(LockOn_Options.script_path.."Systems/UFCP/strm.lua")
dofile(LockOn_Options.script_path.."Systems/UFCP/flir.lua")
dofile(LockOn_Options.script_path.."Systems/UFCP/dl.lua")


function update()
    local ufcp_bright = get_cockpit_draw_argument_value(480)
    update_egir()

    ufcp_com1_check()
    ufcp_com2_check()

    UFCP_COM1_FREQ:set(ufcp_com1_frequency)
    UFCP_COM1_MOD:set(ufcp_com1_modulation)
    UFCP_COM1_SQL:set(ufcp_com1_sql and 1 or 0)
    UFCP_COM1_PWR:set(ufcp_com1_power)
    if get_elec_emergency_ok() then 
        UFCP_COM1_MODE:set(ufcp_com1_mode)
    else
        UFCP_COM1_MODE:set(0)
    end    

    UFCP_COM2_FREQ:set(ufcp_com2_frequency)
    UFCP_COM2_MOD:set(ufcp_com2_modulation)
    UFCP_COM2_SQL:set(ufcp_com2_sql and 1 or 0)
    UFCP_COM2_PWR:set(ufcp_com2_power)
    if get_elec_avionics_ok() then
        UFCP_COM2_MODE:set(ufcp_com2_mode)
    else
        UFCP_COM2_MODE:set(0)
    end    


    if ufcp_on() then 
        UFCP_BRIGHT:set(ufcp_bright) 
    else  
        UFCP_BRIGHT:set(0) 
        return 0
    end

    -- UPDATE FORMATS
    if ufcp_sel_format == UFCP_FORMAT_IDS.MAIN then update_main()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.COM1 then update_com1()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.COM2 or ufcp_sel_format == UFCP_FORMAT_IDS.COM2_NET then update_com2()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.NAV_AIDS then update_nav_aids()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.DA_H then update_da_h()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.WPT or ufcp_sel_format == UFCP_FORMAT_IDS.WPT_UTM then update_wpt()
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

    -- UPDATE TIME MODE
    local interval = get_absolute_model_time() - ufcp_time
    ufcp_time = ufcp_time + interval
    ufcp_time_run = ufcp_time_run + interval
    if ufcp_main_stopwatch_running then ufcp_main_stopwatch = ufcp_main_stopwatch + interval end
    if ufcp_time_run >= 86400 then ufcp_time_run = ufcp_time_run - 86400 end
    TIME_RUN:set(math.floor(ufcp_time)) -- TODO DT should be calculated using this instead of get_absolute_model_time()

    -- UPDATE DRIFT C/O MODE
    -- if ufcp_drift_co or get_avionics_master_mode_ag() then
    if ufcp_drift_co then
        UFCP_DRIFT_CO:set(1)
    else
        UFCP_DRIFT_CO:set(0)
    end

    -- UPDATE VUHF GUARD
    if get_vuhf_guard_on() then -- Should it only work when both MDPs are off?
        -- Set COM1 to 121.5
        ufcp_com1_frequency_manual = 121.5
        ufcp_com1_frequency_sel = UFCP_COM_FREQUENCY_SEL_IDS.MAN
        ufcp_com1_frequency = ufcp_com1_frequency_manual

        -- Set COM2 to 243.0
        ufcp_com2_frequency_manual = 243
        ufcp_com2_frequency_sel = UFCP_COM_FREQUENCY_SEL_IDS.MAN
        ufcp_com2_frequency = ufcp_com2_frequency_manual
    end

    UFCP_NAV_MODE:set(ufcp_nav_mode)
    UFCP_NAV_TIME:set(ufcp_nav_time)
end

function post_initialize()
    startup_print("ufcs: postinit start")
    post_initialize_egi()

    ufcp_cmfd_ref = GetDevice(devices.CMFD)
    local birth = LockOn_Options.init_conditions.birth_place
    alarm = GetDevice(devices.ALARM)
    hud = GetDevice(devices.HUD)
    cmfd = GetDevice(devices.CMFD)
    if birth=="GROUND_HOT" or birth=="AIR_HOT" then
        dev:performClickableAction(device_commands.UFCP_DVR, 1, true)
        dev:performClickableAction(device_commands.UFCP_RALT, 1, true)
        DVR_SWITCH_STATE:set(1)
        RALT_SWITCH_STATE:set(1)
    elseif birth=="GROUND_COLD" then
        dev:performClickableAction(device_commands.UFCP_DVR, -1, true)
        dev:performClickableAction(device_commands.UFCP_RALT, 0, true)
        DVR_SWITCH_STATE:set(-1)
        RALT_SWITCH_STATE:set(0)
    end
    dev:performClickableAction(device_commands.UFCP_UFC, 1, true)
    dev:performClickableAction(device_commands.UFCP_DAY_NIGHT, 0, true)

    startup_print("ufcs: postinit end")
end

dev:listen_command(device_commands.UFCP_WARNRST)
dev:listen_command(device_commands.UFCP_4)
dev:listen_command(device_commands.UFCP_BARO_RALT)
dev:listen_command(device_commands.UFCP_DVR)

function SetCommandCommon(command, value)
    -- Control keys
    if command == device_commands.UFCP_CLR and value == 1 then
        ufcp_undo_edit()
    elseif command == device_commands.UFCP_ENTR and value == 1 then

    elseif command == device_commands.UFCP_UP and value == 1 then
        -- TODO holding INC or DEC, the value increases or decreases 3 units per second.
    elseif command == device_commands.UFCP_DOWN and value == 1 then

    end
end

function SetCommand(command,value)
    debug_message_to_user("ufcp: command "..tostring(command).." = "..tostring(value))
    if not ufcp_on() then return 0 end
    if command==device_commands.UFCP_WARNRST and value == 1 then
        alarm:SetCommand(command, value)
        hud:SetCommand(command, value)

    -- Override keys
    -- Pressing these buttons when the formats are already shown returns to the last format.
    elseif command == device_commands.UFCP_COM1 and value == 1 then
        if ufcp_sel_format ~= UFCP_FORMAT_IDS.COM1 then 
            ufcp_edit_clear() 
            ufcp_overriden_format = ufcp_sel_format
            ufcp_sel_format = UFCP_FORMAT_IDS.COM1
        else
            ufcp_sel_format = ufcp_overriden_format
        end
    elseif command == device_commands.UFCP_COM2 and value == 1 then
        if ufcp_sel_format ~= UFCP_FORMAT_IDS.COM2 then 
            ufcp_edit_clear() 
            ufcp_overriden_format = ufcp_sel_format
            ufcp_sel_format = UFCP_FORMAT_IDS.COM2
        else
            ufcp_sel_format = ufcp_overriden_format
        end
    elseif command == device_commands.UFCP_NAVAIDS and value == 1 then
        if ufcp_sel_format ~= UFCP_FORMAT_IDS.NAV_AIDS then 
            ufcp_edit_clear() 
            ufcp_overriden_format = ufcp_sel_format
            ufcp_sel_format = UFCP_FORMAT_IDS.NAV_AIDS
        else
            ufcp_sel_format = ufcp_overriden_format
        end
    -- Master mode keys
    elseif command == device_commands.UFCP_A_G and value == 1 then
        if not get_avionics_master_mode_ag() then
            set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.A_G)
        end
    elseif command == device_commands.UFCP_A_A and value == 1 then
        set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.DGFT_B)
    elseif command == device_commands.UFCP_NAV and value == 1 then
        set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.NAV)
    elseif command == device_commands.UFCP_UFC then
    elseif command == device_commands.UFCP_JOY_LEFT and value == 1 then
        ufcp_edit_clear()
        ufcp_sel_format = UFCP_FORMAT_IDS.MAIN
    elseif command == device_commands.UFCP_BARO_RALT and value == 1 then
        WPN_RALT:set((WPN_RALT:get() + 1) % 2)
    -- TODO is this still used? Yes, because has to monitor changes from CMFD.
    elseif command == device_commands.UFCP_VV and value == 1 then
        if ufcp_vvvah_mode == UFCP_VVVAH_MODE_IDS.VV_VAH then 
            ufcp_vvvah_mode = ufcp_vvvah_mode_last
        elseif ufcp_vvvah_mode == UFCP_VVVAH_MODE_IDS.VAH or ufcp_vvvah_mode == UFCP_VVVAH_MODE_IDS.OFF then
            ufcp_vvvah_mode_last = ufcp_vvvah_mode
            ufcp_vvvah_mode = UFCP_VVVAH_MODE_IDS.VV_VAH
        end
    elseif command == device_commands.UFCP_DVR then
        cmfd:SetCommand(command, value) -- This is not reached somehow...
        DVR_SWITCH_STATE:set(value) -- So I set this.
    elseif command == device_commands.UFCP_RALT  then
        RALT_SWITCH_STATE:set(value)
    end

    SetCommandCommon(command, value)

    if ufcp_sel_format == UFCP_FORMAT_IDS.MAIN then SetCommandMain(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.COM1 then SetCommandCom1(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.COM2 or ufcp_sel_format == UFCP_FORMAT_IDS.COM2_NET then SetCommandCom2(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.NAV_AIDS then SetCommandNavAids(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.VVVAH then SetCommandVVVAH(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.DA_H then SetCommandDAH(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.WPT or ufcp_sel_format == UFCP_FORMAT_IDS.WPT_UTM then SetCommandWpt(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.XPDR then SetCommandXPDR(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.TIME then SetCommandTime(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.MARK then SetCommandMark(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.FIX then SetCommandFix(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.TIP then SetCommandTip(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.MENU then SetCommandMenu(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.LMT then SetCommandLmt(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.DTK then SetCommandDtk(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.BAL then SetCommandBal(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.ACAL then SetCommandACal(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.NAV_MODE or ufcp_sel_format == UFCP_FORMAT_IDS.NAV_MISC then SetCommandNav(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.WS then SetCommandWs(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.EGI_INS or ufcp_sel_format == UFCP_FORMAT_IDS.EGI_GPS then SetCommandEgi(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.FUEL then SetCommandFuel(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.TAC_MENU then SetCommandTacMenu(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.TAC_CTLN then SetCommandTacCtln(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.TAC_AVOID then SetCommandTacAvoid(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.MODE then SetCommandMode(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.OAP then SetCommandOAP(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.MISC then SetCommandMisc(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.C_F then SetCommandCF(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.PARA then SetCommandPara(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.FTI then SetCommandFTI(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.DCLT then SetCommandDclt(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.CRUS then SetCommandCrus(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.DRFT then SetCommandDrft(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.TK_L_DATA or ufcp_sel_format == UFCP_FORMAT_IDS.TK_L_TKOF or ufcp_sel_format == UFCP_FORMAT_IDS.TK_L_LAND then SetCommandTkL(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.STRM then SetCommandStrm(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.FLIR then SetCommandFlir(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.DL_MENU then SetCommandDlMenu(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.DL_SET then SetCommandDlSet(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.DL_INV then SetCommandDlInv(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.DL_MSG then SetCommandDlMsg(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.DLWP then SetCommandDlwp(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.SNDP then SetCommandSndp(command, value)
    end

    if command == device_commands.UFCP_EGI then SetCommandEgi(command, value)
    end
end


startup_print("ufcs: load end")
need_to_be_closed = false -- close lua state after initialization


