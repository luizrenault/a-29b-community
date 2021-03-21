dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."Systems/avionics_api.lua")
dofile(LockOn_Options.script_path.."utils.lua")
dofile(LockOn_Options.script_path.."dump.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_api.lua")

startup_print("ufcs: load")

local dev = GetSelf()
local alarm 
local hud

update_time_step = 0.02 --update will be called 50 times per second
make_default_activity(update_time_step)

local sensor_data = get_base_data()

local UFCP_BRIGHT = get_param_handle("UFCP_BRIGHT")
local ADHSI_VV = get_param_handle("ADHSI_VV")

-- METHODS

local function ufcp_on()
    return get_elec_avionics_ok() and get_cockpit_draw_argument_value(480) > 0
end

ufcp_sel_format = UFCP_FORMAT_IDS.MAIN
ufcp_edit_pos = 0
ufcp_edit_lim = 0
ufcp_edit_string = ""
ufcp_edit_validate = nil

ufcp_cmfd_ref = nil

ufcp_time_type =  UFCP_TIME_TYPE_IDS.LC
ufcp_ident = false
ufcp_ident_blink = false
elapsed = 0

ufcp_nav_mode = UFCP_NAV_MODE_IDS.AUTO
ufcp_nav_time = UFCP_NAV_TIME_IDS.TTD
ufcp_nav_solution = UFCP_NAV_SOLUTION_IDS.NAV_EGI
ufcp_nav_egi_error = 35 -- meters


-- COM1
ufcp_com1_mode = UFCP_COM_MODE_IDS.TR
ufcp_com1_frequency_sel = UFCP_COM_FREQUENCY_SEL_IDS.PRST
ufcp_com1_channel = 0
ufcp_com1_frequency = 118
ufcp_com1_tx = false
ufcp_com1_rx = false
ufcp_com1_channels = {118, 119, 120, 121, 122, 123, 124, 125, 126, 127}
ufcp_com1_max_channel = 78
ufcp_com1_frequency_manual = 118.0
ufcp_com1_frequency_next = 136.0
ufcp_com1_power = UFCP_COM_POWER_IDS.HIGH
ufcp_com1_modulation = UFCP_COM_MODULATION_IDS.AM
ufcp_com1_sql = true

-- COM2
ufcp_com2_mode = UFCP_COM_MODE_IDS.TR
ufcp_com2_frequency_sel = UFCP_COM_FREQUENCY_SEL_IDS.PRST
ufcp_com2_channel = 0
ufcp_com2_frequency = 118
ufcp_com2_tx = false
ufcp_com2_rx = false
ufcp_com2_channels = {118, 119, 120, 121, 122, 123, 124, 125, 126, 127}
ufcp_com2_max_channel = 78
ufcp_com2_frequency_manual = 118.0
ufcp_com2_frequency_next = 136.0
ufcp_com2_power = UFCP_COM_POWER_IDS.HIGH
ufcp_com2_modulation = UFCP_COM_MODULATION_IDS.AM
ufcp_com2_sql = true
ufcp_com2_sync = false
ufcp_com2_por = false

-- VV/VAH
ufcp_vvvah_mode = UFCP_VVVAH_MODE_IDS.OFF
ufcp_vvvah_mode_last = UFCP_VVVAH_MODE_IDS.OFF


function ufcp_edit_clear()
    ufcp_edit_pos = 0
    ufcp_edit_lim = 0
    ufcp_edit_string = ""
    ufcp_edit_validate = nil
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

dofile(LockOn_Options.script_path.."Systems/ufcp_main.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_com1.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_com2.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_navaids.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_vvvah.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_dah.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_wpt.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_xpdr.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_time.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_mark.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_fix.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_tip.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_menu.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_lmt.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_dtk.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_bal.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_acal.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_nav.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_ws.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_egi.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_fuel.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_tac.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_mode.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_oap.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_cf.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_para.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_fti.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_dclt.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_crus.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_drft.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_tkl.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_strm.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_flir.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_dl.lua")


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
        UFCP_DRIFT_CO:set(1)
    else
        UFCP_DRIFT_CO:set(0)
    end

    UFCP_NAV_MODE:set(ufcp_nav_mode)
    UFCP_NAV_TIME:set(ufcp_nav_time)
end

function post_initialize()
    startup_print("ufcs: postinit start")

    ufcp_cmfd_ref = GetDevice(devices.CMFD)
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

function SetCommandCommon(command, value)
    if command == device_commands.UFCP_COM1 and value == 1 then
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
    -- TODO is this still used?
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
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.NAV_AIDS then SetCommandNavAids(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.VVVAH then SetCommandVVVAH(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.DA_H then SetCommandDAH(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.WPT then SetCommandWpt(command, value)
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
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.TK_L_DATA or ufcp_sel_format == UFCP_FORMAT_IDS.TK_L_TKOF or ufcp_sel_format == UFCP_FORMAT_IDS.TK_L_LAND then SetCommandTkL()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.STRM then SetCommandStrm()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.FLIR then SetCommandFlir()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.DL_MENU then SetCommandDlMenu(command, value)
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.DL_SET then SetCommandDlSet()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.DL_INV then SetCommandDlInv()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.DL_MSG then SetCommandDlMsg()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.DLWP then SetCommandDlwp()
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.SNDP then SetCommandSndp()
    end
end


startup_print("ufcs: load end")
need_to_be_closed = false -- close lua state after initialization


