dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")
dofile(LockOn_Options.script_path.."Systems/alarm_api.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")

startup_print("iceprot: load")

local dev = GetSelf()

local update_time_step = 0.1
make_default_activity(update_time_step)

local sensor_data = get_base_data()

local windshield_time = 0
local pitot_pri = 0
local pitot_sec = 0
local prop_deice = 0

local pitot_pri_caution = 0
local pitot_sec_caution = 0
local prop_deice_caution = 0


function update()
    if windshield_time > 0 then 
        windshield_time = windshield_time - update_time_step
        if windshield_time == 0 then windshield_time = -1 end
    elseif windshield_time < 0 then 
        set_advice(ADVICE_ID.WS_DEICE,0) 
        windshield_time = 0
    end


    if (pitot_pri == 0 or (pitot_pri == 1 and not get_elec_main_bar_ok())) and pitot_pri_caution == 0 then 
        set_caution(CAUTION_ID.PITO_TAT,1) 
        pitot_pri_caution = 1
    elseif (pitot_pri == 1 and get_elec_main_bar_ok()) and pitot_pri_caution == 1 then 
        set_caution(CAUTION_ID.PITO_TAT,0) 
        pitot_pri_caution = 0
    end

    if (pitot_sec == 0 or (pitot_sec == 1 and not get_elec_emergency_ok())) and pitot_sec_caution == 0 then 
        set_caution(CAUTION_ID.S_PITOT,1) 
        pitot_sec_caution = 1
    elseif (pitot_sec == 1 and get_elec_emergency_ok()) and pitot_sec_caution == 1 then 
        set_caution(CAUTION_ID.S_PITOT,0) 
        pitot_sec_caution = 0
    end

    if (prop_deice == 1 and not get_elec_main_bar_ok()) and prop_deice_caution == 0 then 
        set_caution(CAUTION_ID.PROP_DEIC,1) 
        prop_deice_caution = 1
    elseif (prop_deice == 1 and get_elec_main_bar_ok()) and prop_deice_caution == 1 then 
        set_caution(CAUTION_ID.PROP_DEIC,0) 
        prop_deice_caution = 0
    end

end

function post_initialize()
    startup_print("iceprot: postinit start")
    local birth = LockOn_Options.init_conditions.birth_place

    if birth=="GROUND_HOT" then
        dev:performClickableAction(device_commands.IcePropeller, 0, true)
        dev:performClickableAction(device_commands.IceWindshield, 0, true)
        dev:performClickableAction(device_commands.IcePitotPri, 1, true)
        dev:performClickableAction(device_commands.IcePitotSec, 1, true)
    elseif birth=="AIR_HOT" then
        dev:performClickableAction(device_commands.IcePropeller, 0, true)
        dev:performClickableAction(device_commands.IceWindshield, 0, true)
        dev:performClickableAction(device_commands.IcePitotPri, 1, true)
        dev:performClickableAction(device_commands.IcePitotSec, 1, true)
    elseif birth=="GROUND_COLD" then
        dev:performClickableAction(device_commands.IcePropeller, 0, true)
        dev:performClickableAction(device_commands.IceWindshield, -1, true)
        dev:performClickableAction(device_commands.IcePitotPri, 0, true)
        dev:performClickableAction(device_commands.IcePitotSec, 0, true)
    end
    startup_print("iceprot: postinit end")
end

dev:listen_command(device_commands.IcePropeller)
dev:listen_command(device_commands.IceWindshield)
dev:listen_command(device_commands.IcePitotPri)
dev:listen_command(device_commands.IcePitotSec)

function SetCommand(command,value)
    debug_message_to_user("iceprot: command "..tostring(command).." = "..tostring(value))
    if command==device_commands.IcePitotPri then
        pitot_pri = value
    elseif command == device_commands.IcePitotSec then
        pitot_sec = value
    elseif command == device_commands.IcePropeller then
        prop_deice = value
    elseif command == device_commands.IceWindshield then
        if value == 1 and sensor_data.getWOW_LeftMainLandingGear() == 0 then 
            set_advice(ADVICE_ID.WS_DEICE,1) 
            windshield_time = 30
        elseif value == -1 then 
            set_advice(ADVICE_ID.WS_DEICE,0) 
            windshield_time = 0
        end
    end
end




startup_print("iceprot: load end")
need_to_be_closed = false -- close lua state after initialization


