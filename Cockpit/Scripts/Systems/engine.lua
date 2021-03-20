
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")
dofile(LockOn_Options.script_path.."Systems/alarm_api.lua")

startup_print("engine: load")

local dev = GetSelf()

local update_time_step = 0.02 --update will be called 50 times per second
make_default_activity(update_time_step)

local sensor_data = get_base_data()

function update()
end

function post_initialize()
    startup_print("engine: postinit start")
    local birth = LockOn_Options.init_conditions.birth_place

    if birth=="GROUND_HOT" or birth=="AIR_HOT" then
        dev:performClickableAction(device_commands.EngineStart, 0, true)
        dev:performClickableAction(device_commands.FuelHydBleed, -1, true)
    elseif birth=="GROUND_COLD" then
        dev:performClickableAction(device_commands.EngineStart, 0, true)
        dev:performClickableAction(device_commands.FuelHydBleed, -1, true)
    end
    dev:performClickableAction(device_commands.EnginePMU, 1, true)
    dev:performClickableAction(device_commands.EngineIgnition, 0, true)
startup_print("engine: postinit end")
end


local iCommandEnginesStart = 309
local iCommandEnginesStop  = 310
dev:listen_command(iCommandEnginesStart)
dev:listen_command(iCommandEnginesStop)

dev:listen_command(device_commands.EnginePMU)
dev:listen_command(device_commands.EngineIgnition)
dev:listen_command(device_commands.EngineStart)
dev:listen_command(device_commands.FuelHydBleed)

function SetCommand(command,value)
    debug_message_to_user("engine: command "..tostring(command).." = "..tostring(value))
    if command==device_commands.EngineStart then
        if value==1 then 
            engine_try_start()
        elseif value==-1 then
            engine_try_start_interrupt()
        end
    elseif command == iCommandEnginesStart then
        debug_message_to_user("Engine Start")
    elseif command == iCommandEnginesStop then
        debug_message_to_user("Engine Stop")
        -- dev:performClickableAction(device_commands.EngineStart, 0, true)
    elseif command == device_commands.FuelHydBleed and value == 1 then
        engine_stop()
    elseif command == device_commands.EngineIgnition and value == -1 then 
    elseif command == device_commands.EngineInnSep then set_advice(ADVICE_ID.INERT_SEP,value)
    end
end

function engine_try_start()
    local bat_sw=get_cockpit_draw_argument_value(961) == 0
    local ign_sw=get_cockpit_draw_argument_value(922) >= 0
    local fuelbld_sw=get_cockpit_draw_argument_value(871) <= 0
    local fuelmainpump_sw=get_cockpit_draw_argument_value(801) == 1
    local pmu_sw=get_cockpit_draw_argument_value(921) == 1
    
    if bat_sw and ign_sw and fuelbld_sw and pmu_sw then
        debug_message_to_user("Starter On")
        dispatch_action(nil,iCommandEnginesStart,0)
    end
end

function engine_try_start_interrupt()
    if sensor_data.getEngineLeftRPM() <= 50 then
        debug_message_to_user("Starter Interrupt")
        dispatch_action(nil,iCommandEnginesStop,0)
    end
end

function engine_stop()
    debug_message_to_user("Engine stopping")
    dispatch_action(nil,iCommandEnginesStop,0)
end


startup_print("engine: load end")
need_to_be_closed = false -- close lua state after initialization

-- iCommandEnginesStart 309
-- iCommandEnginesStop  310
-- iCommandLeftEngineStart
-- iCommandLeftEngineStop
-- iCommandRightEngineStart
-- iCommandRightEngineStop
-- - SE A NP ≥ 106% POR MAIS DE 3 SEGUNDOS NO MODO AUTOMÁTICO, A PMU REVERTE PARA O MODO MANUAL.
