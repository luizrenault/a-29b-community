shape_name   	   = "Cockpit_A-29B"
is_EDM			   = true
new_model_format   = true
ambient_light    = {255,255,255}
ambient_color_day_texture    = {72, 100, 160}
ambient_color_night_texture  = {40, 60 ,150}
ambient_color_from_devices   = {50, 50, 40}
ambient_color_from_panels	 = {35, 25, 25}

local ft_to_meter = 0.3048

dusk_border					 = 0.4
draw_pilot					 = false

external_model_canopy_arg	 = 38

use_external_views = false

day_texture_set_value   = 0.0
night_texture_set_value = 0.1

local controllers = LoRegisterPanelControls()

mirrors_data =
{
    center_point 	= {0.2,0.1,0.00},
    width 		 	= 0.8, --1.2,
    aspect 		 	= 1.5,
	rotation 	 	= math.rad(1);
	animation_speed = 2.0;
	near_clip 		= 0.1;
	middle_clip		= 10;
	far_clip		= 60000;
}

Canopy    							= CreateGauge()
Canopy.arg_number 					= 26
Canopy.input   						= {0,1}
Canopy.output  						= {0,1}
Canopy.controller 					= controllers.base_gauge_CanopyPos

HideStick                       	= CreateGauge("parameter")
HideStick.arg_number            	= 153
HideStick.parameter_name        	= "HIDE_STICK"
HideStick.input                 	= {0.0, 1.0}
HideStick.output                	= {0.0, 1.0}

StickPitch							= CreateGauge()
StickPitch.arg_number				= 2
StickPitch.input					= {-100, 100}
StickPitch.output					= {1, -1}
StickPitch.controller				= controllers.base_gauge_StickPitchPosition

StickBank							= CreateGauge()
StickBank.arg_number				= 3
StickBank.input						= {-100, 100}
StickBank.output					= {-1, 1}
StickBank.controller				= controllers.base_gauge_StickRollPosition

Throttle							= CreateGauge()
Throttle.arg_number					= 80
Throttle.input						= {0, 1}
Throttle.output						= {0.2, 1}
Throttle.controller					= controllers.base_gauge_ThrottleLeftPosition

-- WheelBrkLeft						= CreateGauge()
-- WheelBrkLeft.arg_number				= 5
-- WheelBrkLeft.input					= {0, 1}
-- WheelBrkLeft.output					= {0, 1}
-- WheelBrkLeft.controller				= controllers.base_gauge_RudderPosition

-- WheelBrkRight						= CreateGauge()
-- WheelBrkRight.arg_number			= 6
-- WheelBrkRight.input					= {0, 1}
-- WheelBrkRight.output				= {0, 1}
-- WheelBrkRight.controller			= controllers.base_gauge_RudderPosition

RudderPedals						= CreateGauge()
RudderPedals.arg_number				= 4
RudderPedals.input					= {-100, 100}
RudderPedals.output					= {-1, 1}
RudderPedals.controller				= controllers.base_gauge_RudderPosition

LeftBrakePedal						= CreateGauge("parameter")
LeftBrakePedal.arg_number			= 5
LeftBrakePedal.input				= {-1,1}
LeftBrakePedal.output				= {0,1}
LeftBrakePedal.parameter_name		= "LEFT_BRAKE_PEDAL"

RightBrakePedal						= CreateGauge("parameter")
RightBrakePedal.arg_number			= 6
RightBrakePedal.input				= {-1,1}
RightBrakePedal.output				= {0,1}
RightBrakePedal.parameter_name		= "RIGHT_BRAKE_PEDAL"


-- Propeller							= CreateGauge()
-- Propeller.arg_number				= 324
-- Propeller.input						= {0, 100}
-- Propeller.output					= {0, 1}
-- Propeller.controller				= controllers.base_gauge_EngineLeftRPM

VerticalVelocity					= CreateGauge()
VerticalVelocity.arg_number			= 662
VerticalVelocity.input				= {-6000*ft_to_meter/60, -4000*ft_to_meter/60, -2000*ft_to_meter/60, -1000*ft_to_meter/60, -500*ft_to_meter/60, 0, 500*ft_to_meter/60, 1000*ft_to_meter/60, 2000*ft_to_meter/60, 4000*ft_to_meter/60, 6000*ft_to_meter/60} --1000ft/min => m/s
VerticalVelocity.output				= {-1.0, -0.76, -0.50, -0.29, -0.15, 0.0, 0.15, 0.29, 0.50, 0.76, 1.0}
VerticalVelocity.controller			= controllers.base_gauge_VerticalVelocity

local RADIANS_TO_DEGREES = 57.2958


ASIRoll                 = CreateGauge()
ASIRoll.arg_number      = 752
ASIRoll.input           = {-180/RADIANS_TO_DEGREES, 180/RADIANS_TO_DEGREES}
ASIRoll.output          = {1.0, -1.0}
ASIRoll.controller		= controllers.base_gauge_Roll

ASIPitch                = CreateGauge()
ASIPitch.arg_number     = 753
ASIPitch.input          = {-90/RADIANS_TO_DEGREES, 90/RADIANS_TO_DEGREES}
ASIPitch.output         = {-1.0, 1.0}
ASIPitch.controller		= controllers.base_gauge_Pitch

ASIOff                = CreateGauge("parameter")
ASIOff.arg_number     = 754
ASIOff.input          = {0, 1}
ASIOff.output         = {0, 1}
ASIOff.parameter_name		= "ELEC_AVIONICS_OK"

PnlBacklight	                 = CreateGauge("parameter")
PnlBacklight.arg_number      	= 201
PnlBacklight.input           	= {0,1}
PnlBacklight.output          	= {0,1}
PnlBacklight.parameter_name		= "PNL_BACKLIGHT"

CslBacklight	                 = CreateGauge("parameter")
CslBacklight.arg_number      	= 202
CslBacklight.input           	= {0,1}
CslBacklight.output          	= {0,1}
CslBacklight.parameter_name		= "CSL_BACKLIGHT"

Chartlight	                 	= CreateGauge("parameter")
Chartlight.arg_number      	= 203
Chartlight.input           	= {0,1}
Chartlight.output          	= {0,1}
Chartlight.parameter_name		= "CHART_LIGHT"

Stormlight	                 	= CreateGauge("parameter")
Stormlight.arg_number      	= 204
Stormlight.input           	= {0,1}
Stormlight.output          	= {0,1}
Stormlight.parameter_name		= "STORM_LIGHT"

WarningLight	                 = CreateGauge("parameter")
WarningLight.arg_number      	= 205
WarningLight.input           	= {0,1}
WarningLight.output          	= {0,1}
WarningLight.parameter_name		= "WARNING_LIGHT"

CautionLight	                 = CreateGauge("parameter")
CautionLight.arg_number      	= 206
CautionLight.input           	= {0,1}
CautionLight.output          	= {0,1}
CautionLight.parameter_name		= "CAUTION_LIGHT"

FireLight	               		= CreateGauge("parameter")
FireLight.arg_number     	 	= 207
FireLight.input          	 	= {0,1}
FireLight.output         	 	= {0,1}
FireLight.parameter_name		= "FIRE_LIGHT"

PBrakeLight	               		= CreateGauge("parameter")
PBrakeLight.arg_number     	 	= 208
PBrakeLight.input          	 	= {0,1}
PBrakeLight.output         	 	= {0,1}
PBrakeLight.parameter_name		= "PBRAKE_LIGHT"


need_to_be_closed = true -- close lua state after initialization

Z_test =
{
	near = 0.05,
	far  = 4.0,
}

livery = "default"

--[[ available functions

 --base_gauge_RadarAltitude
 --base_gauge_BarometricAltitude
 --base_gauge_AngleOfAttack
 --base_gauge_AngleOfSlide
 --base_gauge_VerticalVelocity
 --base_gauge_TrueAirSpeed
 --base_gauge_IndicatedAirSpeed
 --base_gauge_MachNumber
 --base_gauge_VerticalAcceleration --Ny
 --base_gauge_HorizontalAcceleration --Nx
 --base_gauge_LateralAcceleration --Nz
 --base_gauge_RateOfRoll
 --base_gauge_RateOfYaw
 --base_gauge_RateOfPitch
 --base_gauge_Roll
 --base_gauge_MagneticHeading
 --base_gauge_Pitch
 --base_gauge_Heading
 --base_gauge_EngineLeftFuelConsumption
 --base_gauge_EngineRightFuelConsumption
 --base_gauge_EngineLeftTemperatureBeforeTurbine
 --base_gauge_EngineRightTemperatureBeforeTurbine
 --base_gauge_EngineLeftRPM
 --base_gauge_EngineRightRPM
 --base_gauge_WOW_RightMainLandingGear
 --base_gauge_WOW_LeftMainLandingGear
 --base_gauge_WOW_NoseLandingGear
 --base_gauge_RightMainLandingGearDown
 --base_gauge_LeftMainLandingGearDown
 --base_gauge_NoseLandingGearDown
 --base_gauge_RightMainLandingGearUp
 --base_gauge_LeftMainLandingGearUp
 --base_gauge_NoseLandingGearUp
 --base_gauge_LandingGearHandlePos
 --base_gauge_StickRollPosition
 --base_gauge_StickPitchPosition
 --base_gauge_RudderPosition
 --base_gauge_ThrottleLeftPosition
 --base_gauge_ThrottleRightPosition
 --base_gauge_HelicopterCollective
 --base_gauge_HelicopterCorrection
 --base_gauge_CanopyPos
 --base_gauge_CanopyState
 --base_gauge_FlapsRetracted
 --base_gauge_SpeedBrakePos
 --base_gauge_FlapsPos
 --base_gauge_TotalFuelWeight

--]]
