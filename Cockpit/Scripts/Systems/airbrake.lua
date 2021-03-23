dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")

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
local speedbrake_emer_countdown = 0

local speedbrake_max_effective_knots = 320
local speedbrake_blowback_knots = 350
local a29_max_speed_knots = 380 -- approx, only used to calc linear speedbrake closing, and irrelevant past blowback speed anyway


dev:listen_command(iCommandPlaneAirBrake)
dev:listen_command(iCommandPlaneAirBrakeOn)
dev:listen_command(iCommandPlaneAirBrakeOff)
dev:listen_command(device_commands.speedbrake)
dev:listen_command(device_commands.speedbrake_emer)


function update()
	if (ABRAKE_COMMAND == 0 and ABRAKE_STATE > 0) then
		ABRAKE_STATE = ABRAKE_STATE - 0.01 -- lower airbrake in increments of 0.01 (50x per second)
        if ABRAKE_STATE < 0 then
            ABRAKE_STATE = 0
        end
	else
		if (ABRAKE_COMMAND == 1) then
            local knots = sensor_data.getTrueAirSpeed()*1.9438444924574
            if knots > speedbrake_max_effective_knots then
                if knots > speedbrake_blowback_knots then
                    -- blowback pressure relief valve opens
                    ABRAKE_TARGET = 0
                    -- not sure whether blowback really means speedbrakes are closed fully, since
                    -- other places in NATOPS say "speedbrakes are partially effective up to maximum speed capabilities of the aircraft"
                    -- and "A blowback feature allows the speedbrakes to begin closing when the hydraulic pressure exceeds the pressure
                    -- at which the blowback relief valve opens (3650 psi), thus preventing damage to the speedbrake system. The speedbrakes
                    -- begin to blow back at approximately 490 KIAS"
                else
                    -- partially open and partially effective up to max speed of aircraft
                    -- "The speedbrakes will not open fully above 440 KIAS"
                    -- "Maximum speed for fully effective opening of speedbrakes is 440 KIAS. However, speedbrakes are
                    -- partially effective up to maximum speed capabilities of the aircraft."
                    local reduction = (knots - speedbrake_max_effective_knots) / (a29_max_speed_knots - speedbrake_max_effective_knots)  -- simplistically assume linear reduction from 440 to 540kts
                    if reduction > 1 then
                        reduction = 1
                    end
                    ABRAKE_TARGET = 1 - reduction
                end
            else
                ABRAKE_TARGET = 1
            end
            if (ABRAKE_STATE < ABRAKE_TARGET) then
                ABRAKE_STATE = ABRAKE_STATE + 0.01 -- raise airbrake in increment of 0.01 (50x per second)
                if ABRAKE_STATE > ABRAKE_TARGET then
                    ABRAKE_STATE = ABRAKE_TARGET
                end
            elseif (ABRAKE_STATE > ABRAKE_TARGET) then
                ABRAKE_STATE = ABRAKE_STATE - 0.01 -- lower airbrake in increments of 0.01 (50x per second)
                if ABRAKE_STATE < ABRAKE_TARGET then
                    ABRAKE_STATE = ABRAKE_TARGET
                end
            end
		end
	end
    if (speedbrake_emer_countdown>0) then
        speedbrake_emer_countdown=speedbrake_emer_countdown-update_time_step
        if speedbrake_emer_countdown<=0 then
            speedbrake_emer_countdown=0
            dev:performClickableAction(device_commands.speedbrake_emer, 0, false)
        end
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
    print_message_to_user("airbrake: command "..tostring(command).." = "..tostring(value))
	if command == iCommandPlaneAirBrake then
        if get_elec_mon_dc_ok() then
            ABRAKE_COMMAND = 1 - ABRAKE_COMMAND
            dev:performClickableAction(device_commands.speedbrake, ABRAKE_COMMAND, false)
        end
    elseif command == iCommandPlaneAirBrakeOn then
        if get_elec_mon_dc_ok() then
            ABRAKE_COMMAND = 1
            dev:performClickableAction(device_commands.speedbrake, ABRAKE_COMMAND, false)
        end
    elseif command == iCommandPlaneAirBrakeOff then
        if get_elec_mon_dc_ok()  then
            ABRAKE_COMMAND = 0
            dev:performClickableAction(device_commands.speedbrake, ABRAKE_COMMAND, false)
        end
    elseif command == device_commands.speedbrake then
        if get_elec_mon_dc_ok() then
            ABRAKE_COMMAND = value
        end
    elseif command == device_commands.speedbrake_emer then
        if (value==1 or value==-1) then
            speedbrake_emer_countdown=0.25 -- seconds until bungee knob reset
            if value==1 then
                ABRAKE_COMMAND = 1
            else
                ABRAKE_COMMAND = 0
            end
        end
    end
end


startup_print("airbrake: load end")
need_to_be_closed = false -- close lua state after initialization


