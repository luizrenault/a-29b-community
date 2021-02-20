dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."Systems/avionics_api.lua")

startup_print("ufcs: load")

local dev = GetSelf()
local alarm 
local hud

local update_time_step = 0.02 --update will be called 50 times per second
make_default_activity(update_time_step)

local sensor_data = get_base_data()

function update()
end

function post_initialize()
    startup_print("ufcs: postinit start")
    local birth = LockOn_Options.init_conditions.birth_place
    alarm = GetDevice(devices.ALARM)
    hud = GetDevice(devices.HUD)
    if birth=="GROUND_HOT" then
    elseif birth=="AIR_HOT" then
    elseif birth=="GROUND_COLD" then
        -- dev:performClickableAction(device_commands.EnvTemp, 0.5, true)
    end
    startup_print("ufcs: postinit end")
end

dev:listen_command(device_commands.UFCP_WARNRST)

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
    elseif command == iCommandEnginesStop then
        -- dev:performClickableAction(device_commands.EngineStart, 0, true)
    end
end


startup_print("ufcs: load end")
need_to_be_closed = false -- close lua state after initialization


