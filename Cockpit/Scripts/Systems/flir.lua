dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")

local dev = GetSelf()

local update_time_step = 0.02 --update will be called 50 times per second
make_default_activity(update_time_step)
show_param_handles_list()


export_prefix = "FLIR"

thermal = {
    fov = {math.rad(0.8), math.rad(25)},    -- min, max, in rad
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

axis = {
    az = {math.rad(0), math.rad(360)},      -- min, max, in rad
    stabilization = true,
}

mechanical = {
    max_airspeed = 405,                     -- kias
    station = 0,                            -- Weapon Station
    pos = {4.0,0.45,0},                     -- x along aircraft axis, y height, z lateral, in meters
    temperature = {-40, 55},                -- min, max, in deg celsius
}

function update()
    -- print_message_to_user("LR::avSimplestFLIR")
end

function post_initialize()
    print_message_to_user("LR::avSimplestFLIR")
end


local iCommandPlaneDesignate_CageOn = 439
local iCommandPlaneDesignate_CageOff = 440
local iCommandSelecterLeft = 139
local iCommandSelecterRight = 140
local iCommandSelecterUp = 141
local iCommandSelecterDown = 142


dev:listen_command(Keys.Cage)
dev:listen_command(Keys.TDCX)
dev:listen_command(Keys.TDCY)


local caged = true

function SetCommand(command, value)
    -- print_message_to_user("flir: command "..tostring(command).." = "..tostring(value))
    if command == Keys.Cage then
        if value == 1 then
            if caged == true then
                caged = false
                dev:performClickableAction(iCommandPlaneDesignate_CageOff, value);
            else
                caged = true
                dev:performClickableAction(iCommandPlaneDesignate_CageOn, value);
            end
        end
    elseif command == Keys.TDCX then
        if value > 0  then
            dev:performClickableAction(iCommandSelecterRight, math.abs(value));
        elseif value < 0 then
            dev:performClickableAction(iCommandSelecterLeft, math.abs(value));
        else
            dev:performClickableAction(iCommandSelecterLeft, 0);
            dev:performClickableAction(iCommandSelecterRight, 0);
        end
    elseif command == Keys.TDCY then
        if value > 0  then
            dev:performClickableAction(iCommandSelecterUp, math.abs(value));
        elseif value < 0 then
            dev:performClickableAction(iCommandSelecterDown, math.abs(value));
        else
            dev:performClickableAction(iCommandSelecterUp, 0);
            dev:performClickableAction(iCommandSelecterDown, 0);
        end
    end
end

need_to_be_closed = false


