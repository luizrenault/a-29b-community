dofile(LockOn_Options.script_path.."command_defs.lua")

local dev = GetSelf()

local update_time_step = 0.02 --update will be called 50 times per second
make_default_activity(update_time_step)

export_prefix = "FLIR"

thermal = {
    fov = {math.rad(30), math.rad(5.7), math.rad(1.4)},    -- list, in rad
    digital_zoom = {1, 2},
    resolution = {640, 480},                -- w, h, in pixels
    sensor_resolution = {320, 240},         -- w, h, in pixels
    wavelength = {3, 5},                    -- min, max, in um
}

visible = {
    fov = {math.rad(2.7), math.rad(28)},    -- min, max, in rad
    color = true,
    resolution = {625, 480},                -- w, h, in pixels
    digital_zoom = 12,                      -- max
}

spotter = {
    color = true,
    resolution = {582, 480},                -- w, h, in pixels
    fov = 0.4,                              -- fixed
    default_code = 1688,
}

rangefinder = {
    max_range = 20000,                      -- in m
}

designator = {
    power = 2,                              -- in W
    default_code = 1688,
}

pointer = {
    power = 0.1,                            -- in W
}

electrical = {
    -- power_bus_handle = "FLIR_POWER_OK"      -- comment to connect to avSimpleElectricSystem
    consumption = 200,                      -- in W
    voltage = {22, 29},                     -- min, max, in V
}

mechanical = {
    az = {math.rad(-180), math.rad(180)},      -- min, max, in rad
    el = {math.rad(-120), math.rad(30)},
    stabilization = true,
    max_airspeed = 405,                     -- kias
    station = 5,                            -- Weapon Station
    pos = {1.0,-1.40, 0},                     -- x along aircraft axis, y height, z lateral, in meters
    temperature = {-40, 55},                -- min, max, in deg celsius
}

function update()
    -- print_message_to_user("LR::avSimplestFLIR")
end

function post_initialize()
    -- print_message_to_user("LR::avSimplestFLIR")
end


function SetCommand(command, value)
    -- print_message_to_user("flir: command "..tostring(command).." = "..tostring(value))
end

need_to_be_closed = false


