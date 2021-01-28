dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")

-- dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
-- dofile(LockOn_Options.script_path.."Systems/hydraulic_system_api.lua")

local dev = GetSelf()

local update_time_step = 0.02
make_default_activity(update_time_step) -- enables call to update

local sensor_data = get_base_data()

function post_initialize()
end

local BFI_ROLL_param = get_param_handle("BFI_ROLL")
local BFI_PITCH_param = get_param_handle("BFI_PITCH")
local IAS_param = get_param_handle("IAS")
local ALT_param = get_param_handle("ALT")
local DC_param = get_param_handle("DC")
local hdd_001_brightness_param = get_param_handle("hdd_001_brightness")
local hdd_002_brightness_param = get_param_handle("hdd_002_brightness")
local HDD001_PFD_param = get_param_handle("HDD001_PFD")
local HDD002_PFD_param = get_param_handle("HDD002_PFD")
local HDD002_Engine_Status_param = get_param_handle("HDD002_Engine_Status")
local BFI_param = get_param_handle("BFI")
local BFI_brightness_param = get_param_handle("BFI_brightness")



local MPS_TO_KNOTS = 1.94384
local meters_to_feet = 3.2808399

local BFI_BARO_param = get_param_handle("BFI_BARO")
local BFI_MB_param = get_param_handle("BFI_MB")


dev:listen_command(device_commands.AltPressureKnob)
dev:listen_command(device_commands.AltPressureStd)



local ALT_PRESSURE_STD = 29.92 -- in Hg
local ALT_PRESSURE_MAX = 30.99 -- in Hg
local ALT_PRESSURE_MIN = 29.10 -- in Hg

function SetCommand(command,value)
	if command==device_commands.AltPressureKnob then
		local baro=BFI_BARO_param:get()
		
		if value>0 then
			baro=baro+0.01
		else
			baro=baro-0.01
		end
		if baro>ALT_PRESSURE_MAX then baro=ALT_PRESSURE_MAX end
		if baro<ALT_PRESSURE_MIN then baro=ALT_PRESSURE_MIN end
		BFI_BARO_param:set(baro)
	elseif command==device_commands.AltPressureStd then
		BFI_BARO_param:set(ALT_PRESSURE_STD)
	end
end


function post_initialize()
	
	DC_param:set(28.0)
    hdd_001_brightness_param:set(1.0)
    hdd_002_brightness_param:set(1.0)
    HDD001_PFD_param:set(1.0)
    HDD002_PFD_param:set(1.0)
    HDD002_Engine_Status_param:set(1.0)
    BFI_param:set(1.0)
    BFI_brightness_param:set(1.0)

	BFI_BARO_param:set(ALT_PRESSURE_STD)
end



-- local update_time_step = 0.0167
-- make_default_activity(update_time_step)

local DRAW_FAN			 = 	324
local PropStepLim		 =  0.0833
local propState         =   -1
local propMaxRPM		= 250

function update()
	--Test set anim argument
	IAS_param:set(sensor_data.getIndicatedAirSpeed()*MPS_TO_KNOTS)
	BFI_ROLL_param:set(sensor_data.getRoll())
	BFI_PITCH_param:set(sensor_data.getPitch())



	BFI_MB_param:set(BFI_BARO_param:get()*33.8639)


	ALT_param:set(sensor_data.getBarometricAltitude()*meters_to_feet+(BFI_BARO_param:get()-ALT_PRESSURE_STD)*1000)

	local propRPM = sensor_data.getEngineLeftRPM()
	--sensor is from 0 to 100 so it is divided by 100 and multiplied by the prop max RPM.
	propStep = 3*propRPM*update_time_step/60
	--keeps prop animation between 0 and 1
	propState = (propState + propStep)%1
	if propRPM < 50 then
		set_aircraft_draw_argument_value(DRAW_FAN,1-propState)
	else
		set_aircraft_draw_argument_value(DRAW_FAN,20)
	end

	local ROLL_STATE = sensor_data:getStickPitchPosition() / 100
	set_aircraft_draw_argument_value(11, ROLL_STATE) -- right aileron
	set_aircraft_draw_argument_value(12, -ROLL_STATE) -- left aileron
	

	local PITCH_STATE = sensor_data:getStickRollPosition() / 100
	set_aircraft_draw_argument_value(15, PITCH_STATE) -- right elevator
	set_aircraft_draw_argument_value(16, PITCH_STATE) -- left elevator

	local RUDDER_STATE = sensor_data:getRudderPosition() / 100
	set_aircraft_draw_argument_value(17, -RUDDER_STATE)
	set_aircraft_draw_argument_value(2, -RUDDER_STATE)
end

need_to_be_closed = false -- close lua state after initialization
