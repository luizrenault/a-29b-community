
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")
dofile(LockOn_Options.script_path.."Systems/alarm_api.lua")
dofile(LockOn_Options.script_path.."Systems/engine_api.lua")
dofile(LockOn_Options.script_path.."utils.lua")

local ENGINE_ON_FIRE = get_param_handle("ENGINE_ON_FIRE")
ENGINE_ON_FIRE:set(0)   -- TODO detect when aircraft is on fire

startup_print("engine: load")

local dev = GetSelf()

local update_time_step = 0.02 --update will be called 50 times per second
make_default_activity(update_time_step)

local sensor_data = get_base_data()

local throttle_position_wma = WMA(0.35, 0)

local iCommandEnginesStart = 309
local iCommandEnginesStop  = 310
local iCommandPlaneThrustCommon = 2004

local ENGINE = {
    THROTTLE = get_param_handle("ENGINE_THROTTLE")
}

local ENGINE_STATE_IDS = {
    CUTOFF = 0,
    ST = 1,
    ON = 2,
}

local ENGINE_state = ENGINE_STATE_IDS.CUTOFF

local prev_throttle_pos = 0
local throttle_clickable_ref

local fire_warning = 0

function update()
    local throttle = sensor_data.getThrottleLeftPosition()
    if ENGINE_state == ENGINE_STATE_IDS.ON then
        throttle_clickable_ref:hide(throttle>0.01)
    elseif ENGINE_state == ENGINE_STATE_IDS.ST then
        if sensor_data.getEngineLeftRPM()>55 and throttle > 0.01 then ENGINE_state = ENGINE_STATE_IDS.ON end
        throttle_clickable_ref:hide(false)
        throttle = -0.5
    elseif ENGINE_state == ENGINE_STATE_IDS.CUTOFF then 
        throttle_clickable_ref:hide(false)
        local rpm = sensor_data.getEngineLeftRPM()
        if rpm >=15 then engine_stop() end
        throttle = -1
    end

    local throttle_pos = throttle_position_wma:get_WMA(throttle)
    if prev_throttle_pos ~= throttle_pos then
        if throttle <= 0.01 then
            throttle_clickable_ref:update() -- ensure it is clickable at the correct position
        end
        prev_throttle_pos = throttle_pos
    end
    ENGINE.THROTTLE:set(throttle_position_wma:get_WMA(throttle))

    if is_engine_on_fire() then
        set_warning(WARNING_ID.FIRE, 1)
        fire_warning = 1
    elseif not is_engine_on_fire() then
        set_warning(WARNING_ID.FIRE, 0)
        fire_warning = 0
    end
end

function post_initialize()
    startup_print("engine: postinit start")
    throttle_clickable_ref = get_clickable_element_reference("PNT_911")
    local birth = LockOn_Options.init_conditions.birth_place

    if birth=="GROUND_HOT" or birth=="AIR_HOT" then
        dev:performClickableAction(device_commands.EngineStart, 0, true)
        dev:performClickableAction(device_commands.FuelHydBleed, -1, true)
        ENGINE_state = ENGINE_STATE_IDS.ON
    elseif birth=="GROUND_COLD" then
        dev:performClickableAction(device_commands.EngineStart, 0, true)
        dev:performClickableAction(device_commands.FuelHydBleed, -1, true)
        ENGINE_state = ENGINE_STATE_IDS.CUTOFF
    end
    dev:performClickableAction(device_commands.EnginePMU, 1, true)
    dev:performClickableAction(device_commands.EngineIgnition, 0, true)
startup_print("engine: postinit end")
end


dev:listen_command(iCommandEnginesStart)
dev:listen_command(iCommandEnginesStop)
dev:listen_command(iCommandPlaneThrustCommon)

dev:listen_command(device_commands.EnginePMU)
dev:listen_command(device_commands.EngineIgnition)
dev:listen_command(device_commands.EngineStart)
dev:listen_command(device_commands.FuelHydBleed)
dev:listen_command(device_commands.ThrottleAxis)

dev:listen_command(Keys.Cutoff)

function SetCommand(command,value)
    debug_message_to_user("engine: command "..tostring(command).." = "..tostring(value))
    if command==device_commands.EngineStart then
        if value==1 then 
            engine_try_start()
        elseif value==-1 then
            engine_try_start_interrupt()
        end
    elseif command == device_commands.ThrottleClick then
        if value == -1 and (ENGINE_state == ENGINE_STATE_IDS.ON or ENGINE_state == ENGINE_STATE_IDS.ST) and sensor_data.getThrottleLeftPosition() < 0.1 then
            ENGINE_state = ENGINE_STATE_IDS.CUTOFF
            engine_stop()
        elseif value == 1 and ENGINE_state == ENGINE_STATE_IDS.CUTOFF then
            ENGINE_state = ENGINE_STATE_IDS.ST
        elseif value == 1 and ENGINE_state == ENGINE_STATE_IDS.ST then
            ENGINE_state = ENGINE_STATE_IDS.ON
        end
    elseif command == Keys.Cutoff then
        if value == 1 then 
            ENGINE_state = ENGINE_STATE_IDS.CUTOFF
            engine_stop()
        else
            ENGINE_state = ENGINE_STATE_IDS.ST
        end
    elseif command == iCommandPlaneThrustCommon then
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
