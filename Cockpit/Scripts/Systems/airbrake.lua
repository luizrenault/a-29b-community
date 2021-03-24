dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")
dofile(LockOn_Options.script_path.."Systems/weapon_system_api.lua")

startup_print("airbrake: load")

local dev = GetSelf()

local update_time_step = 0.02 --update will be called 50 times per second
make_default_activity(update_time_step)

local sensor_data = get_base_data()

local iCommandPlaneAirBrake  = 73 -- This is the number of the command from command_defs
local iCommandPlaneAirBrakeOn = 147
local iCommandPlaneAirBrakeOff = 148

--Creating local variables
local ABRAKE_COMMAND	=	0				
local ABRAKE_STATE	=	0
local ABRAKE_TARGET = 0

dev:listen_command(Keys.AirBrake)
dev:listen_command(iCommandPlaneAirBrake)
dev:listen_command(iCommandPlaneAirBrakeOn)
dev:listen_command(iCommandPlaneAirBrakeOff)
dev:listen_command(device_commands.speedbrake)
dev:listen_command(device_commands.speedbrake_emer)

function update()
	if get_wpn_ventral_free() then 
        if (ABRAKE_COMMAND == -1 and ABRAKE_STATE > 0) or (ABRAKE_COMMAND == 0 and ABRAKE_TARGET < ABRAKE_STATE) then
            ABRAKE_STATE = ABRAKE_STATE - 0.01 -- lower airbrake in increments of 0.01 (50x per second)
            if ABRAKE_STATE < 0 then
                ABRAKE_STATE = 0
                ABRAKE_COMMAND = 0
                ABRAKE_TARGET = 0
            end
        elseif (ABRAKE_COMMAND == 1 and ABRAKE_STATE < 1) or (ABRAKE_COMMAND == 0 and ABRAKE_TARGET > ABRAKE_STATE) then
            ABRAKE_STATE = ABRAKE_STATE + 0.01 -- raise airbrake in increments of 0.01 (50x per second)
            if ABRAKE_STATE > 1 then
                ABRAKE_STATE = 1
                ABRAKE_COMMAND = 0
                ABRAKE_TARGET = 1
            end
        else
            ABRAKE_COMMAND = 0
            ABRAKE_TARGET = ABRAKE_STATE
        end
    else
        ABRAKE_COMMAND = 0
        ABRAKE_STATE = 0
        ABRAKE_TARGET = 0
    end
    set_aircraft_draw_argument_value(21,ABRAKE_STATE)
end

function post_initialize()
    startup_print("airbrake: postinit start")
    local birth = LockOn_Options.init_conditions.birth_place

    if birth=="GROUND_HOT" then
        -- dev:performClickableAction(device_commands.EnvTemp, 0.5, true)
    elseif birth=="AIR_HOT" then
    elseif birth=="GROUND_COLD" then
    end
    startup_print("airbrake: postinit end")
end

local function get_elec_mon_dc_ok()
    return true
end

function SetCommand(command, value)
    debug_message_to_user("airbrake: command "..tostring(command).." = "..tostring(value))
	if command == Keys.AirBrake then
        if get_elec_mon_dc_ok() then
            ABRAKE_COMMAND = 0
            ABRAKE_TARGET = value
        end
    elseif command == iCommandPlaneAirBrake then
        if get_elec_mon_dc_ok() then
            ABRAKE_COMMAND = 0
            if ABRAKE_TARGET > 0 then ABRAKE_TARGET = 0 else ABRAKE_TARGET = 1 end
        end
    elseif command == iCommandPlaneAirBrakeOn then
        if get_elec_mon_dc_ok() and value == 1 then
            ABRAKE_COMMAND = 1
        else 
            ABRAKE_COMMAND = 0
            ABRAKE_TARGET = ABRAKE_STATE
        end
    elseif command == iCommandPlaneAirBrakeOff then
        if get_elec_mon_dc_ok() and value == 1 then
            ABRAKE_COMMAND = -1
        else 
            ABRAKE_COMMAND = 0
            ABRAKE_TARGET = ABRAKE_STATE
        end
    end
end


startup_print("airbrake: load end")
need_to_be_closed = false -- close lua state after initialization


