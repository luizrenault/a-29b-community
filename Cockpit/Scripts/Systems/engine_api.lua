local sensor_data = get_base_data()

local ENGINE_ON_FIRE = get_param_handle("ENGINE_ON_FIRE")
local ENGINE_FIRE_TEST = get_param_handle("ENGINE_FIRE_TEST")

function get_engine_on()
    return sensor_data.getEngineLeftRPM()>=50
end

function is_engine_on_fire()
    return ENGINE_FIRE_TEST:get() == 1 or ENGINE_ON_FIRE:get() == 1
end