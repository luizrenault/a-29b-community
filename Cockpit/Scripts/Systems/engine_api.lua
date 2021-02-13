local sensor_data = get_base_data()

function get_engine_on()
    return sensor_data.getEngineLeftRPM()>=50
end