shape_name   	   = "Cockpit_A-29B"
is_EDM			   = true
new_model_format   = true
ambient_light    = {255,255,255}
ambient_color_day_texture    = {72, 100, 160}
ambient_color_night_texture  = {40, 60 ,150}
ambient_color_from_devices   = {50, 50, 40}
ambient_color_from_panels	 = {35, 25, 25}
-- fc3_cockpit_draw_args = true
-- ed_fm_set_fc3_cockpit_draw_args_v2
-- use_external_shape=false
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
    center_point 	= {0.493,0,0.00},
    width 		 	= 1.0, --1.2,
    aspect 		 	= 1.0,
	rotation 	 	= math.rad(-1);
	animation_speed = 2.0;
	near_clip 		= 0.1;
	middle_clip		= 10;
	far_clip		= 5000;
}

mirrors_draw                    = CreateGauge()
mirrors_draw.arg_number         = 183
mirrors_draw.input              = {0,1}
mirrors_draw.output             = {0,1}
mirrors_draw.controller         = controllers.mirrors_draw


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
StickPitch.arg_number				= 3
StickPitch.input					= {-100, 100}
StickPitch.output					= {-1, 1}
StickPitch.controller				= controllers.base_gauge_StickPitchPosition

StickBank							= CreateGauge()
StickBank.arg_number				= 2
StickBank.input						= {-100, 100}
StickBank.output					= {1, -1}
StickBank.controller				= controllers.base_gauge_StickRollPosition

-- Throttle							= CreateGauge()
-- Throttle.arg_number					= 80
-- Throttle.input						= {0, 1}
-- Throttle.output						= {0, 1}
-- Throttle.controller					= controllers.base_gauge_ThrottleLeftPosition

Throttle							= CreateGauge("parameter")
Throttle.arg_number					= 80
Throttle.input						= {-1, 1}
Throttle.output						= {-1, 1}
Throttle.parameter_name				= "ENGINE_THROTTLE"

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

GearNoseLight	            	= CreateGauge("parameter")
GearNoseLight.arg_number     	= 209
GearNoseLight.input          	= {0,1}
GearNoseLight.output         	= {0,1}
GearNoseLight.parameter_name	= "GEAR_NOSE_LIGHT"

GearLeftLight	            	= CreateGauge("parameter")
GearLeftLight.arg_number     	= 210
GearLeftLight.input          	= {0,1}
GearLeftLight.output         	= {0,1}
GearLeftLight.parameter_name	= "GEAR_LEFT_LIGHT"

GearRightLight	            	= CreateGauge("parameter")
GearRightLight.arg_number     	= 211
GearRightLight.input          	= {0,1}
GearRightLight.output         	= {0,1}
GearRightLight.parameter_name	= "GEAR_RIGHT_LIGHT"

GearHandleLight	           		= CreateGauge("parameter")
GearHandleLight.arg_number 	 	= 212
GearHandleLight.input      	 	= {0,1}
GearHandleLight.output     	 	= {0,1}
GearHandleLight.parameter_name	= "GEAR_HANDLE_LIGHT"

UFCPLight	           		= CreateGauge("parameter")
UFCPLight.arg_number 	 	= 489
UFCPLight.input      	 	= {0,1}
UFCPLight.output     	 	= {0,1}
UFCPLight.parameter_name	= "UFCP_BRIGHT"

local object = CreateGauge("parameter")
object.arg_number 	 	= 213
object.input      	 	= {0,1}
object.output     	 	= {0,1}
object.parameter_name	= "AP_RP"

object = CreateGauge("parameter")
object.arg_number 	 	= 214
object.input      	 	= {0,1}
object.output     	 	= {0,1}
object.parameter_name	= "AP_HDG"

object = CreateGauge("parameter")
object.arg_number 	 	= 215
object.input      	 	= {0,1}
object.output     	 	= {0,1}
object.parameter_name	= "AP_ALT"

object = CreateGauge("parameter")
object.arg_number 	 	= 216
object.input      	 	= {0,1}
object.output     	 	= {0,1}
object.parameter_name	= "AP_TEST"

object = CreateGauge("parameter")
object.arg_number 	 	= 217
object.input      	 	= {0,1}
object.output     	 	= {0,1}
object.parameter_name	= "AP_TEST_ERROR"

object = CreateGauge("parameter")
object.arg_number 	 	= 218
object.input      	 	= {0,1}
object.output     	 	= {0,1}
object.parameter_name	= "AP_NAV"

object = CreateGauge("parameter")
object.arg_number 	 	= 219
object.input      	 	= {0,1}
object.output     	 	= {0,1}
object.parameter_name	= "AP_NAV_ERROR"

object = CreateGauge("parameter")
object.arg_number 	 	= 220
object.input      	 	= {0,1}
object.output     	 	= {0,1}
object.parameter_name	= "AP_APR"

object = CreateGauge("parameter")
object.arg_number 	 	= 221
object.input      	 	= {0,1}
object.output     	 	= {0,1}
object.parameter_name	= "AP_APR_ERROR"

object = CreateGauge("parameter")
object.arg_number 	 	= 222
object.input      	 	= {0,1}
object.output     	 	= {0,1}
object.parameter_name	= "AP_GS"

object = CreateGauge("parameter")
object.arg_number 	 	= 223
object.input      	 	= {0,1}
object.output     	 	= {0,1}
object.parameter_name	= "AP_GS_ERROR"

object = CreateGauge("parameter")
object.arg_number 	 	= 224
object.input      	 	= {0,1}
object.output     	 	= {0,1}
object.parameter_name	= "AP_ON"

object = CreateGauge("parameter")
object.arg_number 	 	= 225
object.input      	 	= {0,1}
object.output     	 	= {0,1}
object.parameter_name	= "AP_ERROR"




need_to_be_closed = true -- close lua state after initialization

Z_test =
{
	near = 0.05,
	far  = 4.0,
}

-- livery = "FAB"

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




/* protected: virtual void __cdecl cockpit::ccMainPanel::register_gauge_controllers(struct lua_State * __ptr64,int) __ptr64 */

void __thiscall cockpit::ccMainPanel::register_gauge_controllers(ccMainPanel *this,lua_State *param_1,int param_2)

{
                    /* 0x1b8e20  4479  ?register_gauge_controllers@ccMainPanel@cockpit@@MEAAXPEAUlua_State@@H@Z */
  lua_pushstring(param_1,"day_night_texture_switcher");
  lua_pushlightuserdata(param_1,&l_day_night_texture_switcher);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"mirrors_draw");
  lua_pushlightuserdata(param_1,l_mirrors_draw);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"pilot_draw");
  lua_pushlightuserdata(param_1,&_pilot_draw);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"Panel_Shake_Y");
  lua_pushlightuserdata(param_1,&l_Panel_Shake_Y);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"Panel_Shake_Z");
  lua_pushlightuserdata(param_1,l_Panel_Shake_Z);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"Panel_Rot_X");
  lua_pushlightuserdata(param_1,&l_Panel_Rot_X);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"head_shift_X");
  lua_pushlightuserdata(param_1,&l_head_shift_X);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"head_shift_Y");
  lua_pushlightuserdata(param_1,&l_head_shift_Y);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"head_shift_Z");
  lua_pushlightuserdata(param_1,&l_head_shift_Z);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"canopy");
  lua_pushlightuserdata(param_1,l_canopy);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_RadarAltitude");
  lua_pushlightuserdata(param_1,l_base_gauge_RadarAltitude);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_BarometricAltitude");
  lua_pushlightuserdata(param_1,l_base_gauge_BarometricAltitude);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_AngleOfAttack");
  lua_pushlightuserdata(param_1,&l_base_gauge_AngleOfAttack);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_AngleOfSlide");
  lua_pushlightuserdata(param_1,FUN_1801b3a10);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_VerticalVelocity");
  lua_pushlightuserdata(param_1,FUN_1801b4c70);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_TrueAirSpeed");
  lua_pushlightuserdata(param_1,FUN_1801b4b90);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_IndicatedAirSpeed");
  lua_pushlightuserdata(param_1,FUN_1801b4110);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_MachNumber");
  lua_pushlightuserdata(param_1,FUN_1801b4340);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_VerticalAcceleration");
  lua_pushlightuserdata(param_1,FUN_1801b4c00);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_HorizontalAcceleration");
  lua_pushlightuserdata(param_1,FUN_1801b40a0);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_LateralAcceleration");
  lua_pushlightuserdata(param_1,FUN_1801b41f0);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_RateOfRoll");
  lua_pushlightuserdata(param_1,FUN_1801b4650);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_RateOfYaw");
  lua_pushlightuserdata(param_1,FUN_1801b46c0);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_RateOfPitch");
  lua_pushlightuserdata(param_1,FUN_1801b45e0);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_Roll");
  lua_pushlightuserdata(param_1,FUN_1801b4810);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_MagneticHeading");
  lua_pushlightuserdata(param_1,FUN_1801b43b0);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_Pitch");
  lua_pushlightuserdata(param_1,FUN_1801b4500);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_Heading");
  lua_pushlightuserdata(param_1,FUN_1801b3f50);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_EngineLeftFuelConsumption");
  lua_pushlightuserdata(param_1,FUN_1801b3bd0);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_EngineRightFuelConsumption");
  lua_pushlightuserdata(param_1,FUN_1801b3d20);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_EngineLeftTemperatureBeforeTurbine");
  lua_pushlightuserdata(param_1,FUN_1801b3cb0);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_EngineRightTemperatureBeforeTurbine");
  lua_pushlightuserdata(param_1,FUN_1801b3e00);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_EngineLeftRPM");
  lua_pushlightuserdata(param_1,FUN_1801b3c40);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_EngineRightRPM");
  lua_pushlightuserdata(param_1,FUN_1801b3d90);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_WOW_RightMainLandingGear");
  lua_pushlightuserdata(param_1,FUN_1801b4dc0);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_WOW_LeftMainLandingGear");
  lua_pushlightuserdata(param_1,FUN_1801b4ce0);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_WOW_NoseLandingGear");
  lua_pushlightuserdata(param_1,FUN_1801b4d50);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_RightMainLandingGearDown");
  lua_pushlightuserdata(param_1,FUN_1801b4730);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_LeftMainLandingGearDown");
  lua_pushlightuserdata(param_1,FUN_1801b4260);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_NoseLandingGearDown");
  lua_pushlightuserdata(param_1,FUN_1801b4420);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_RightMainLandingGearUp");
  lua_pushlightuserdata(param_1,FUN_1801b47a0);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_LeftMainLandingGearUp");
  lua_pushlightuserdata(param_1,FUN_1801b42d0);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_NoseLandingGearUp");
  lua_pushlightuserdata(param_1,FUN_1801b4490);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_LandingGearHandlePos");
  lua_pushlightuserdata(param_1,FUN_1801b4180);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_StickRollPosition");
  lua_pushlightuserdata(param_1,FUN_1801b49d0);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_StickPitchPosition");
  lua_pushlightuserdata(param_1,FUN_1801b4960);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_RudderPosition");
  lua_pushlightuserdata(param_1,FUN_1801b4880);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_ThrottleLeftPosition");
  lua_pushlightuserdata(param_1,FUN_1801b4a40);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_ThrottleRightPosition");
  lua_pushlightuserdata(param_1,FUN_1801b4ab0);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_HelicopterCollective");
  lua_pushlightuserdata(param_1,FUN_1801b3fc0);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_HelicopterCorrection");
  lua_pushlightuserdata(param_1,FUN_1801b4030);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_CanopyPos");
  lua_pushlightuserdata(param_1,l_canopy);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_CanopyState");
  lua_pushlightuserdata(param_1,FUN_1801b3b60);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_FlapsRetracted");
  lua_pushlightuserdata(param_1,FUN_1801b3ee0);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_SpeedBrakePos");
  lua_pushlightuserdata(param_1,FUN_1801b48f0);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_FlapsPos");
  lua_pushlightuserdata(param_1,FUN_1801b3e70);
  lua_settable(param_1,param_2);
  lua_pushstring(param_1,"base_gauge_TotalFuelWeight");
  lua_pushlightuserdata(param_1,FUN_1801b4b20);
  lua_settable(param_1,param_2);
  return;
}

--]]
