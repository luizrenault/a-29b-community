dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")

-- dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
-- dofile(LockOn_Options.script_path.."Systems/hydraulic_system_api.lua")

local dev = GetSelf()

local update_time_step = 0.02
make_default_activity(update_time_step) -- enables call to update

local sensor_data = get_base_data()

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

local iCommandAltimeterPressureIncrease = 316
local iCommandAltimeterPressureDecrease = 317
local iCommandAltimeterPressureStop = 318


local ALT_PRESSURE_STD = 29.92 -- in Hg
local ALT_PRESSURE_MAX = 30.99 -- in Hg
local ALT_PRESSURE_MIN = 29.10 -- in Hg


local balt_init
local alt_init
function post_initialize()
	dispatch_action(nil, iCommandAltimeterPressureIncrease)
	dispatch_action(nil, iCommandAltimeterPressureDecrease)

	DC_param:set(24.0)
    hdd_001_brightness_param:set(1.0)
    hdd_002_brightness_param:set(1.0)
    HDD001_PFD_param:set(1.0)
    HDD002_PFD_param:set(1.0)
    HDD002_Engine_Status_param:set(1.0)
    BFI_param:set(1.0)
    BFI_brightness_param:set(1.0)

	BFI_BARO_param:set(ALT_PRESSURE_STD)
	set_aircraft_draw_argument_value(DRAW_FAN,-1)
    dev:performClickableAction(device_commands.EmerSpdBrk, -1, true)
    dev:performClickableAction(device_commands.AUDIO_COM1_VOL, 1, true)
    dev:performClickableAction(device_commands.AUDIO_COM2_VOL, 0.8, true)

end



-- local update_time_step = 0.0167
-- make_default_activity(update_time_step)

local DRAW_FAN			 = 	407
local PropStepLim		 =  0.0833
local propState         =   0
local propMaxRPM		= 2000
local bfi_bright = 1

local adjust = true

local EICAS_NP = get_param_handle("EICAS_NP")

function update()
	if adjust then -- workaround for getBarometricAltitude
		local x, y, z = sensor_data.getSelfCoordinates()
		local dif = math.floor(y/10) - math.floor(sensor_data.getBarometricAltitude()/10)
		if dif > 0 then
			for i=1, math.floor(math.abs(dif/3)) do
				dispatch_action(nil, iCommandAltimeterPressureIncrease)
			end
			dispatch_action(nil, iCommandAltimeterPressureIncrease)
		elseif dif < 0 then
			for i=1, math.floor(math.abs(dif/3)) do
				dispatch_action(nil, iCommandAltimeterPressureDecrease)
			end
			dispatch_action(nil, iCommandAltimeterPressureDecrease)
		else
			adjust = false
		end
		return 0
	end


	--Test set anim argument
	-- IAS_param:set(sensor_data.getTrueAirSpeed()*MPS_TO_KNOTS)
	IAS_param:set(sensor_data.getIndicatedAirSpeed()*MPS_TO_KNOTS)
	BFI_ROLL_param:set(sensor_data.getRoll())
	BFI_PITCH_param:set(sensor_data.getPitch())
	BFI_brightness_param:set(2^(-10+bfi_bright*10))


	BFI_MB_param:set(BFI_BARO_param:get()*33.8639)

	ALT_param:set(sensor_data.getBarometricAltitude() * meters_to_feet)
	-- ALT_param:set(sensor_data.getBarometricAltitude()*meters_to_feet+(BFI_BARO_param:get()-ALT_PRESSURE_STD)*1000)

	local propRPM = EICAS_NP:get() / 100 * propMaxRPM
	--sensor is from 0 to 100 so it is divided by 100 and multiplied by the prop max RPM.
	
	local propStep = propRPM / 60 * update_time_step

	--keeps prop animation between 0 and 1
	if propRPM < 800 then
		propState = (propState + propStep)%1
		set_aircraft_draw_argument_value(475,0)
		set_aircraft_draw_argument_value(DRAW_FAN,propState)
		set_aircraft_draw_argument_value(413,1)
	else
		propState = (propState + propStep/100)%1
		set_aircraft_draw_argument_value(413,0)
		set_aircraft_draw_argument_value(475,-1)
		set_aircraft_draw_argument_value(DRAW_FAN,propState)
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


dev:listen_command(iCommandAltimeterPressureIncrease)
dev:listen_command(iCommandAltimeterPressureDecrease)

function SetCommand(command,value)
	if command==device_commands.AltPressureKnob then
		if value>0 then
			dispatch_action(nil, iCommandAltimeterPressureIncrease)
		else
			dispatch_action(nil, iCommandAltimeterPressureDecrease)
		end
	elseif command == iCommandAltimeterPressureIncrease then
		if adjust then return 0 end
		local baro=BFI_BARO_param:get()
		baro=baro+0.01
		if baro>ALT_PRESSURE_MAX then 
			dispatch_action(nil, iCommandAltimeterPressureDecrease)
		end
		BFI_BARO_param:set(baro)
	elseif command == iCommandAltimeterPressureDecrease then
		if adjust then return 0 end
		local baro=BFI_BARO_param:get()
		baro=baro-0.01
		if baro<ALT_PRESSURE_MIN then 
			dispatch_action(nil, iCommandAltimeterPressureIncrease)
		end
		BFI_BARO_param:set(baro)
	elseif command==device_commands.AltPressureStd then
		local baro=BFI_BARO_param:get()
		if baro > ALT_PRESSURE_STD then command = iCommandAltimeterPressureDecrease
		elseif baro < ALT_PRESSURE_STD then command = iCommandAltimeterPressureIncrease
		end
		local clicks = math.abs(baro-ALT_PRESSURE_STD)/0.01
		while clicks > 1 do
			dispatch_action(nil, command)
			clicks = clicks -1
		end
	elseif command==device_commands.BFI_BRIGHT then
		if value == 1 then 
			bfi_bright = (bfi_bright + 0.1) % 1.0
		end
	end
end

need_to_be_closed = false -- close lua state after initialization
