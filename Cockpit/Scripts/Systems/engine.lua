
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")
dofile(LockOn_Options.script_path.."Systems/alarm_api.lua")
dofile(LockOn_Options.script_path.."Systems/engine_api.lua")
dofile(LockOn_Options.script_path.."utils.lua")

local ENGINE_ON_FIRE = get_param_handle("ENGINE_ON_FIRE")
ENGINE_ON_FIRE:set(0)   -- TODO detect when aircraft is on fire

local elec_main_bar_ok=get_param_handle("ELEC_MAIN_BAR_OK") -- 1 or 0
local elec_hot_ok=get_param_handle("ELEC_HOT_OK") -- 1 or 0
local elec_emergency_ok=get_param_handle("ELEC_EMERGENCY_OK") -- 1 or 0
local engine_starter=get_param_handle("ENGINE_STARTER") -- 1 or 0


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
local eng_man_warning = 0

local starter_on = false
local ign_on = false

local function is_starter_power_supply_on()
    local power_on = (elec_main_bar_ok:get() == 1 and sensor_data.getWOW_LeftMainLandingGear() > 0) or (elec_hot_ok:get() == 1 and sensor_data.getWOW_LeftMainLandingGear() == 0)
    return power_on
end

function update()
    local throttle = sensor_data.getThrottleLeftPosition()

    local ign_sw=get_cockpit_draw_argument_value(922) -- ignition
    local fuelbld_sw=get_cockpit_draw_argument_value(871) -- shutoff
    local pmu_sw=get_cockpit_draw_argument_value(921)

    local ng = sensor_data.getEngineLeftRPM()

    local has_fuel_supply = ENGINE_state ~= ENGINE_STATE_IDS.CUTOFF and fuelbld_sw <= 0

    -- Ignition
    ign_on = (ign_sw > 0 or (ign_sw == 0 and throttle <= 0.01 and ng < 64 and ng > 13)) and elec_emergency_ok:get() == 1

    -- If there is no power supply, turn off starter
    if not is_starter_power_supply_on() then
        starter_on = false
    end

    -- Starter will turn off if RPM is above 50%
    if starter_on and ng > 50 then
        starter_on = false
    end

    -- Starter is on and NG is below 20%
    if starter_on and ng < 20 then
        -- Start engine
        dispatch_action(nil,iCommandEnginesStart,0)
    end

    -- Starter is on and fuel is being supplied
    if ng >=13 and ng < 50 and has_fuel_supply and starter_on and ign_on then
        -- Continue starting
    end

    -- Starter is on but there is no fuel supplied
    if ng >= 20 and ng < 50 and (not has_fuel_supply or not ign_on) then
        -- Stop starting
        dispatch_action(nil,iCommandEnginesStop,0)
    end

    -- NG is above 50% and fuel is being supplied, and ignition is on
    if ng >= 50 and has_fuel_supply and ign_sw >= 0 then
        dispatch_action(nil,iCommandEnginesStart,0)
    end

    -- Fuel was cut off and starter is not on
    if not starter_on and not has_fuel_supply then
        -- Shut down
        dispatch_action(nil,iCommandEnginesStop,0)
    end

    engine_starter:set(starter_on and 1 or 0)

    if ENGINE_state == ENGINE_STATE_IDS.ON then
        throttle_clickable_ref:hide(throttle>0.01)
    elseif ENGINE_state == ENGINE_STATE_IDS.ST then
        if sensor_data.getEngineLeftRPM()>55 and throttle > 0.01 then ENGINE_state = ENGINE_STATE_IDS.ON end
        throttle_clickable_ref:hide(false)
        throttle = -0.5
    elseif ENGINE_state == ENGINE_STATE_IDS.CUTOFF then 
        throttle_clickable_ref:hide(false)
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

    -- Fire alarm
    if is_engine_on_fire() then
        set_warning(WARNING_ID.FIRE, 1)
        fire_warning = 1
    elseif not is_engine_on_fire() then
        set_warning(WARNING_ID.FIRE, 0)
        fire_warning = 0
    end

    -- PMU manual
    if pmu_sw == 0 and eng_man_warning == 0 then
        set_warning(WARNING_ID.ENG_MAN, 1)
        eng_man_warning = 1
    elseif pmu_sw == 1 and eng_man_warning == 1 then
        set_warning(WARNING_ID.ENG_MAN, 0)
        eng_man_warning = 0
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
            engine_starter_start()
        elseif value==-1 then
            engine_starter_intrpt()
        end
    elseif command == device_commands.ThrottleClick then
        if value == -1 and (ENGINE_state == ENGINE_STATE_IDS.ON or ENGINE_state == ENGINE_STATE_IDS.ST) and sensor_data.getThrottleLeftPosition() < 0.1 then
            ENGINE_state = ENGINE_STATE_IDS.CUTOFF
        elseif value == 1 and ENGINE_state == ENGINE_STATE_IDS.CUTOFF then
            ENGINE_state = ENGINE_STATE_IDS.ST
        elseif value == 1 and ENGINE_state == ENGINE_STATE_IDS.ST then
            ENGINE_state = ENGINE_STATE_IDS.ON
        end
    elseif command == Keys.Cutoff then
        if value == 1 then 
            ENGINE_state = ENGINE_STATE_IDS.CUTOFF
        else
            ENGINE_state = ENGINE_STATE_IDS.ST
        end
    elseif command == iCommandPlaneThrustCommon then
    elseif command == device_commands.FuelHydBleed and value == 1 then
    elseif command == device_commands.EngineIgnition and value == -1 then 
    elseif command == device_commands.EngineInnSep then set_advice(ADVICE_ID.INERT_SEP,value)
    end
end

function engine_starter_start()
    local power_on = is_starter_power_supply_on()

    if power_on then
        starter_on = true
    end
end

function engine_starter_intrpt()
    starter_on = false
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
