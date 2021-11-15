local cockpit = folder.."../../../Cockpit/Scripts/"
dofile(cockpit.."devices.lua")
dofile(cockpit.."command_defs.lua")

local res = external_profile("Config/Input/Aircrafts/common_joystick_binding.lua")

join(res.keyCommands,{





    --Flight Control
{down = iCommandPlaneUpStart,				                up = iCommandPlaneUpStop,			                name = _('Aircraft Pitch Down'),	                            category = _('Flight Control')},
{down = iCommandPlaneDownStart,				                up = iCommandPlaneDownStop,			                name = _('Aircraft Pitch Up'),		                            category = _('Flight Control')},
{down = iCommandPlaneLeftStart,				                up = iCommandPlaneLeftStop,			                name = _('Aircraft Bank Left'),		                            category = _('Flight Control')},
{down = iCommandPlaneRightStart,			                up = iCommandPlaneRightStop,		                name = _('Aircraft Bank Right'),	                            category = _('Flight Control')},
{down = iCommandPlaneLeftRudderStart,		                up = iCommandPlaneLeftRudderStop,	                name = _('Aircraft Rudder Left'),	                            category = _('Flight Control')},
{down = iCommandPlaneRightRudderStart,		                up = iCommandPlaneRightRudderStop,	                name = _('Aircraft Rudder Right'),	                            category = _('Flight Control')},


{pressed = iCommandThrottleIncrease,                        up = iCommandThrottleStop,                          name = _('Throttle Up'),			                            category = _('Flight Control')},
{pressed = iCommandThrottleDecrease,                        up = iCommandThrottleStop,                          name = _('Throttle Down'),			                            category = _('Flight Control')},
{down = Keys.Cutoff,               		                    up = Keys.Cutoff,                                   name = _('Engine Cutoff else other'),		                    category = _('Flight Control'),                value_down =  1.0,		value_up = 0.0},


{down = iCommandPlaneAUTIncreaseRegime,			                                                                name = _('Throttle Step Up'),			                        category = _('Flight Control')},
{down = iCommandPlaneAUTDecreaseRegime,			                                                                name = _('Throttle Step Down'),			                        category = _('Flight Control')},

{pressed = iCommandPlaneTrimLeftRudder,	                    up = iCommandPlaneTrimStop,                         name = _('Trim: Rudder Left'),		                            category = _('Flight Control')},
{pressed = iCommandPlaneTrimRightRudder,                    up = iCommandPlaneTrimStop,                         name = _('Trim: Rudder Right'),		                            category = _('Flight Control')},

-- Systems          
{down = iCommandPlaneAirBrake,				                                                                    name = _('Airbrake'),					                        category = _('Systems')},
{down = iCommandPlaneAirBrakeOn,                            up = iCommandPlaneAirBrakeOn,				        name = _('Airbrake On'),							            category = _('Systems'),                        value_down =  1.0,		value_up = 0.0},
{down = iCommandPlaneAirBrakeOff,                           up = iCommandPlaneAirBrakeOff,			            name = _('Airbrake Off'),							            category = _('Systems'),                        value_down =  1.0,		value_up = 0.0},
{down = iCommandPlaneWingtipSmokeOnOff,		                                                                    name = _('Smoke'),						                        category = _('Systems')},
{down = iCommandPlaneCockpitIllumination,	                                                                    name = _('Illumination Cockpit'),		                        category = _('Systems')},
{down = iCommandPlaneLightsOnOff,			                                                                    name = _('Navigation lights'),			                        category = _('Systems')},
{down = iCommandPlaneHeadLightOnOff,		                                                                    name = _('Gear Light Near/Far/Off'),	                        category = _('Systems')},
{down = iCommandPlaneFlaps,					                                                                    name = _('Flaps Up/Down'),				                        category = _('Systems')},
{down = iCommandPlaneFlapsOn,				                                                                    name = _('Flaps Landing Position'),		                        category = _('Systems')},
{down = iCommandPlaneFlapsOff,				                                                                    name = _('Flaps Up'),					                        category = _('Systems')},
{down = iCommandPlaneGear,					                                                                    name = _('Landing Gear Up/Down'),		                        category = _('Systems')},
{down = iCommandPlaneGearUp,				                                                                    name = _('Landing Gear Up'),			                        category = _('Systems')},
{down = iCommandPlaneGearDown,				                                                                    name = _('Landing Gear Down'),			                        category = _('Systems')},
{down = iCommandPlaneGearUp,					            up = iCommandPlaneGearDown,                         name = _('Landing Gear Down else Up'),		                    category = _('Systems')},
{down = iCommandPlaneWheelBrakeOn,                          up = iCommandPlaneWheelBrakeOff,			        name = _('Wheel Brake On'),		                                category = _('Systems')},
-- {down = iCommandPlaneWheelBrakeLeftOn,	                    up = iCommandPlaneWheelBrakeLeftOff,		        name = _('Wheel Brake Left - ON/OFF'),		                    category = {_('Systems')}},
-- {down = iCommandPlaneWheelBrakeRightOn,	                    up = iCommandPlaneWheelBrakeRightOff,		        name = _('Wheel Brake Right - ON/OFF'),		                    category = {_('Systems')}},
{down = iCommandPlaneFonar,					                                                                    name = _('Canopy Open/Close'),					                category = _('Systems')},
{down = iCommandPlaneResetMasterWarning,		                                                                name = _('Audible Warning Reset'),				                category = _('Systems')},
{down = Keys.JettisonWeapons,                               up = Keys.JettisonWeapons,                          name = _('Weapons Jettison'),                                   category = _('Systems'),                        value_down =  1.0,		value_up = 0.0},
{down = iCommandPlaneEject,					                                                                    name = _('Eject (3 times)'),					                category = _('Systems')},

{pressed = iCommandHUDBrightnessUp,			                                                                    name = _('HUD Brightness up'),			                        category = _('Systems')},
{pressed = iCommandHUDBrightnessDown,		                                                                    name = _('HUD Brightness down'),		                        category = _('Systems')},

-- {down = iCommandPilotSeatAdjustmentUp,	                    up = iCommandPilotSeatAdjustmentStop,		        name = _('SEAT ADJ Switch - UP/OFF'),		                    category = {_('Systems')}},
-- {down = iCommandPilotSeatAdjustmentDown,	                up = iCommandPilotSeatAdjustmentStop,		        name = _('SEAT ADJ Switch - DOWN/OFF'),		                    category = {_('Systems')}},

{pressed = iCommandAltimeterPressureIncrease,	            up = iCommandAltimeterPressureStop,                 name = _('Altimeter Pressure Increase'),                        category = _('Systems')},
{pressed = iCommandAltimeterPressureDecrease,               up = iCommandAltimeterPressureStop,                 name = _('Altimeter Pressure Decrease'),                        category = _('Systems')},

-- Stick
{pressed = iCommandPlaneTrimUp,			                    up = iCommandPlaneTrimStop,                         name = _('Trim: Nose Up'),			                            category = {_('Stick'), _('HOTAS')}},
{pressed = iCommandPlaneTrimDown,		                    up = iCommandPlaneTrimStop,                         name = _('Trim: Nose Down'),		                            category = {_('Stick'), _('HOTAS')}},
{pressed = iCommandPlaneTrimLeft,		                    up = iCommandPlaneTrimStop,                         name = _('Trim: Left Wing Down'),	                            category = {_('Stick'), _('HOTAS')}},
{pressed = iCommandPlaneTrimRight,		                    up = iCommandPlaneTrimStop,                         name = _('Trim: Right Wing Down'),	                            category = {_('Stick'), _('HOTAS')}},
    
{down = Keys.StickStep,	                                    up = Keys.StickStep,                                name = _('Step'),		                                        category = {_('Stick'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},
{down = Keys.StickDesignate,	                            up = Keys.StickDesignate,                           name = _('Designate'),                                          category = {_('Stick'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},
{down = Keys.StickUndesignate,	                            up = Keys.StickUndesignate,                         name = _('Undesignate'),	                                    category = {_('Stick'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},

{down = Keys.MasterModeSw,	                                up = Keys.MasterModeSw,                             name = _('Main Mode Switch - NAV'),                             category = {_('Stick'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},
{down = Keys.MasterModeSw,	                                up = Keys.MasterModeSw,                             name = _('Main Mode Switch - A/G'),                             category = {_('Stick'), _('HOTAS')}, value_down =  2.0,		value_up = 0.0},
{down = Keys.MasterModeSw,	                                up = Keys.MasterModeSw,                             name = _('Main Mode Switch - A/A INT'),	                        category = {_('Stick'), _('HOTAS')}, value_down =  3.0,		value_up = 0.0},
{down = Keys.MasterModeSw,	                                up = Keys.MasterModeSw,                             name = _('Main Mode Switch - A/A DGFT'),                        category = {_('Stick'), _('HOTAS')}, value_down =  4.0,		value_up = 0.0},

{down = Keys.APDisengage,	                                up = Keys.APDisengage,                              name = _('Autopilot Disengage'),                                category = {_('Stick'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},
{down = Keys.APOvrd,                                        up = Keys.APOvrd,                                   name = _('Autopilot Override'),                                 category = {_('Stick'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},

{down = Keys.Call,	                                        up = Keys.Call,                                     name = _('Call'),                                               category = {_('Stick'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},

{down = Keys.Trigger,	                                    up = Keys.Trigger,                                  name = _('Gun Trigger First Detent'),                           category = {_('Stick'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},
{down = Keys.Trigger,	                                    up = Keys.Trigger,                                  name = _('Gun Trigger Second Detent'),                          category = {_('Stick'), _('HOTAS')}, value_down =  2.0,		value_up = 0.0},
{down = Keys.WeaponRelease,	                                up = Keys.WeaponRelease,	                        name = _('Weapon Release Button (WRB)'),                        category = {_('Stick'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},

{down = Keys.DisplayMngt,                                   up = Keys.DisplayMngt,                              name = _('DMS Fwd - HUD'),                                      category = {_('Stick'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},
{down = Keys.DisplayMngt,                                   up = Keys.DisplayMngt,                              name = _('DMS Aft - No Function'),                              category = {_('Stick'), _('HOTAS')}, value_down =  2.0,		value_up = 0.0},
{down = Keys.DisplayMngt,                                   up = Keys.DisplayMngt,                              name = _('DMS Left - CMFD #1'),                                 category = {_('Stick'), _('HOTAS')}, value_down =  3.0,		value_up = 0.0},
{down = Keys.DisplayMngt,                                   up = Keys.DisplayMngt,                              name = _('DMS Right - CMFD #2'),                                category = {_('Stick'), _('HOTAS')}, value_down =  4.0,		value_up = 0.0},
{down = Keys.DisplayMngt,                                   up = Keys.DisplayMngt,                              name = _('DMS Depress - Autopilot'),                            category = {_('Stick'), _('HOTAS')}, value_down =  5.0,		value_up = 0.0},


--Throttle
{down = Keys.GunSelDist,                                    up = Keys.GunSelDist,                               name = _('Machine Gun Selection'),                              category = {_('Throttle'), _('HOTAS')}, value_down =  -1.0,		value_up = 0.0},
{down = Keys.GunSelDist,                                    up = Keys.GunSelDist,                               name = _('Machine Gun Distance'),                               category = {_('Throttle'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},
{down = Keys.GunRearm,                                      up = Keys.GunRearm,                                 name = _('Machine Gun Rearm'),                                  category = {_('Throttle'), _('HOTAS')}, value_down =  -1.0,		value_up = 0.0},
{down = Keys.Cage,                                          up = Keys.Cage,                                     name = _('Cage / Uncage'),                                      category = {_('Throttle'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},
{down = Keys.TDCX,                                          up = Keys.TDCX,                                     name = _('TDC Slew Left'),                                      category = {_('Throttle'), _('HOTAS')}, value_down =  -1.0,		value_up = 0.0},
{down = Keys.TDCX,                                          up = Keys.TDCX,                                     name = _('TDC Slew Right'),                                     category = {_('Throttle'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},
{down = Keys.TDCY,                                          up = Keys.TDCY,                                     name = _('TDC Slew Up'),                                        category = {_('Throttle'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},
{down = Keys.TDCY,                                          up = Keys.TDCY,                                     name = _('TDC Slew Down'),                                      category = {_('Throttle'), _('HOTAS')}, value_down =  -1.0,		value_up = 0.0},
{down = Keys.COM1,                                          up = Keys.COM1,                                     name = _('COM Fwd - COM1 (V/UHF1)'),                            category = {_('Throttle'), _('HOTAS'), _('Communications')}, value_down =  1.0,		value_up = 0.0},
{down = Keys.COM2,                                          up = Keys.COM2,                                     name = _('COM Aft - COM2 (V/UHF2)'),                            category = {_('Throttle'), _('HOTAS'), _('Communications')}, value_down =  1.0,		value_up = 0.0},
{down = Keys.COM3,                                          up = Keys.COM3,                                     name = _('COM Up - COM3 (HF)'),                                 category = {_('Throttle'), _('HOTAS'), _('Communications')}, value_down =  1.0,		value_up = 0.0},
    
--NightVision                   
{down    = iCommandViewNightVisionGogglesOn   ,                                                                 name = _('Toggle goggles')   ,                                  category = _('Sensors')},
{pressed = iCommandPlane_Helmet_Brightess_Up  ,                                                                 name = _('Gain goggles up')  ,                                  category = _('Sensors')},
{pressed = iCommandPlane_Helmet_Brightess_Down,                                                                 name = _('Gain goggles down'),                                  category = _('Sensors')},


-- Autopilot
-- {down = iCommandPlaneAutopilot,                                                                                 name = _('Autopilot'),                                          category = _('Autopilot')},
-- {down = iCommandPlaneAUTOnOff,                                                                                  name = _('Autothrust'),                                         category = _('Autopilot')},
-- {down = iCommandPlaneSAUHBarometric,                                                                            name = _('Autopilot - Barometric Altitude Hold \'H\''),         category = _('Autopilot')},
-- {down = iCommandPlaneStabTangBank,                                                                              name = _('Autopilot - Attitude Hold'),                          category = _('Autopilot')},
-- {down = iCommandPlaneStabHbarBank,                                                                              name = _('Autopilot - Altitude And Roll Hold'),                 category = _('Autopilot')},
-- {down = iCommandPlaneStabHorizon,	                                                                            name = _('Autopilot - Transition To Level Flight Control'),     category = _('Autopilot')},
-- {down = iCommandPlaneStabHbar,                                                                                  name = _('Autopilot - Barometric Altitude Hold'),               category = _('Autopilot')},
-- {down = iCommandPlaneStabHrad,                                                                                  name = _('Autopilot - Radar Altitude Hold'),                    category = _('Autopilot')},
-- {down = iCommandPlaneRouteAutopilot,                                                                            name = _('Autopilot - \'Route following\''),                    category = _('Autopilot')},
-- {down = iCommandPlaneStabCancel,                                                                                name = _('Autopilot Disengage'),                                category = _('Autopilot')},
-- {down = iCommandPlaneAutopilotOverrideOn, up = iCommandPlaneAutopilotOverrideOff, name = _('Autopilot override'), category = _('Autopilot')},

-- Countermeasures
-- {down = iCommandPlaneDropSnar,			                                                                        name = _('Countermeasures Continuously Dispense'),				category = _('Countermeasures') , features = {"Countermeasures"}},
-- {down = iCommandPlaneDropSnarOnce,                          up = iCommandPlaneDropSnarOnceOff,                  name = _('Countermeasures Release'),	                        category = _('Countermeasures') , features = {"Countermeasures"}},
{down = iCommandPlaneDropFlareOnce,		                                                                        name = _('Countermeasures Flares Dispense'),					category = _('Countermeasures') , features = {"Countermeasures"}},
{down = iCommandPlaneDropChaffOnce,		                                                                        name = _('Countermeasures Chaff Dispense'),						category = _('Countermeasures') , features = {"Countermeasures"}},


-- UFCP 
{down = device_commands.UFCP_0,                                 up = device_commands.UFCP_0,                    name = _('UFCP 0'),			                                    category = {_('UFCP')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.UFCP},
{down = device_commands.UFCP_1,                                 up = device_commands.UFCP_1,                    name = _('UFCP 1'),			                                    category = {_('UFCP')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.UFCP},
{down = device_commands.UFCP_2,                                 up = device_commands.UFCP_2,                    name = _('UFCP 2'),			                                    category = {_('UFCP')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.UFCP},
{down = device_commands.UFCP_3,                                 up = device_commands.UFCP_3,                    name = _('UFCP 3'),			                                    category = {_('UFCP')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.UFCP},
{down = device_commands.UFCP_4,                                 up = device_commands.UFCP_4,                    name = _('UFCP 4'),			                                    category = {_('UFCP')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.UFCP},
{down = device_commands.UFCP_5,                                 up = device_commands.UFCP_5,                    name = _('UFCP 5'),			                                    category = {_('UFCP')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.UFCP},
{down = device_commands.UFCP_6,                                 up = device_commands.UFCP_6,                    name = _('UFCP 6'),			                                    category = {_('UFCP')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.UFCP},
{down = device_commands.UFCP_7,                                 up = device_commands.UFCP_7,                    name = _('UFCP 7'),			                                    category = {_('UFCP')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.UFCP},
{down = device_commands.UFCP_8,                                 up = device_commands.UFCP_8,                    name = _('UFCP 8'),			                                    category = {_('UFCP')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.UFCP},
{down = device_commands.UFCP_9,                                 up = device_commands.UFCP_9,                    name = _('UFCP 9'),			                                    category = {_('UFCP')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.UFCP},
{down = device_commands.UFCP_CLR,                               up = device_commands.UFCP_CLR,                  name = _('UFCP CLR'),			                                category = {_('UFCP')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.UFCP},
{down = device_commands.UFCP_ENTR,                              up = device_commands.UFCP_ENTR,                 name = _('UFCP ENTR'),			                                category = {_('UFCP')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.UFCP},
{down = device_commands.UFCP_IDNT,                              up = device_commands.UFCP_IDNT,                 name = _('UFCP IDNT'),			                                category = {_('UFCP')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.UFCP},
{down = device_commands.UFCP_CZ,                                up = device_commands.UFCP_CZ,                   name = _('UFCP CZ'),			                                category = {_('UFCP')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.UFCP},
{down = device_commands.UFCP_AIRSPD,                            up = device_commands.UFCP_AIRSPD,               name = _('UFCP AIRSPD'),			                            category = {_('UFCP')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.UFCP},
{down = device_commands.UFCP_WARNRST,                           up = device_commands.UFCP_WARNRST,              name = _('UFCP WARN RST'),			                            category = {_('UFCP')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.UFCP},
{down = device_commands.UFCP_COM1,                              up = device_commands.UFCP_COM1,                 name = _('UFCP COM1'),			                                category = {_('UFCP')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.UFCP},
{down = device_commands.UFCP_COM2,                              up = device_commands.UFCP_COM2,                 name = _('UFCP COM2'),			                                category = {_('UFCP')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.UFCP},
{down = device_commands.UFCP_NAVAIDS,                           up = device_commands.UFCP_NAVAIDS,              name = _('UFCP NAV AIDS'),			                            category = {_('UFCP')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.UFCP},
{down = device_commands.UFCP_A_G,                               up = device_commands.UFCP_A_G,                  name = _('UFCP A/G'),			                                category = {_('UFCP')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.UFCP},
{down = device_commands.UFCP_NAV,                               up = device_commands.UFCP_NAV,                  name = _('UFCP NAV'),			                                category = {_('UFCP')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.UFCP},
{down = device_commands.UFCP_A_A,                               up = device_commands.UFCP_A_A,                  name = _('UFCP A/A'),			                                category = {_('UFCP')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.UFCP},
{down = device_commands.UFCP_BARO_RALT,                         up = device_commands.UFCP_BARO_RALT,            name = _('UFCP BARO RALT'),			                            category = {_('UFCP')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.UFCP},
{down = device_commands.UFCP_UP,                                up = device_commands.UFCP_UP,                   name = _('UFCP UP'),			                                category = {_('UFCP')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.UFCP},
{down = device_commands.UFCP_DOWN,                              up = device_commands.UFCP_DOWN,                 name = _('UFCP DOWN'),			                                category = {_('UFCP')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.UFCP},
{down = device_commands.UFCP_JOY_UP,                            up = device_commands.UFCP_JOY_UP,               name = _('UFCP JOY UP'),			                            category = {_('UFCP')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.UFCP},
{down = device_commands.UFCP_JOY_DOWN,                          up = device_commands.UFCP_JOY_DOWN,             name = _('UFCP JOY DOWN'),			                            category = {_('UFCP')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.UFCP},
{down = device_commands.UFCP_JOY_LEFT,                          up = device_commands.UFCP_JOY_LEFT,             name = _('UFCP JOY LEFT'),			                            category = {_('UFCP')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.UFCP},
{down = device_commands.UFCP_JOY_RIGHT,                         up = device_commands.UFCP_JOY_RIGHT,            name = _('UFCP JOY RIGHT'),			                            category = {_('UFCP')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.UFCP},                



-- CMFD1
{down = device_commands.CMFD1OSS1,                              up = device_commands.CMFD1OSS1,                 name = _('CMFD1 OSS1'),			                                category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD1OSS2,                              up = device_commands.CMFD1OSS2,                 name = _('CMFD1 OSS2'),			                                category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD1OSS3,                              up = device_commands.CMFD1OSS3,                 name = _('CMFD1 OSS3'),			                                category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD1OSS4,                              up = device_commands.CMFD1OSS4,                 name = _('CMFD1 OSS4'),			                                category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD1OSS5,                              up = device_commands.CMFD1OSS5,                 name = _('CMFD1 OSS5'),			                                category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD1OSS6,                              up = device_commands.CMFD1OSS6,                 name = _('CMFD1 OSS6'),			                                category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD1OSS7,                              up = device_commands.CMFD1OSS7,                 name = _('CMFD1 OSS7'),			                                category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD1OSS8,                              up = device_commands.CMFD1OSS8,                 name = _('CMFD1 OSS8'),			                                category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD1OSS9,                              up = device_commands.CMFD1OSS9,                 name = _('CMFD1 OSS9'),			                                category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD1OSS10,                             up = device_commands.CMFD1OSS10,                name = _('CMFD1 OSS10'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD1OSS11,                             up = device_commands.CMFD1OSS11,                name = _('CMFD1 OSS11'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD1OSS12,                             up = device_commands.CMFD1OSS12,                name = _('CMFD1 OSS12'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD1OSS13,                             up = device_commands.CMFD1OSS13,                name = _('CMFD1 OSS13'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD1OSS14,                             up = device_commands.CMFD1OSS14,                name = _('CMFD1 OSS14'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD1OSS15,                             up = device_commands.CMFD1OSS15,                name = _('CMFD1 OSS15'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD1OSS16,                             up = device_commands.CMFD1OSS16,                name = _('CMFD1 OSS16'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD1OSS17,                             up = device_commands.CMFD1OSS17,                name = _('CMFD1 OSS17'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD1OSS18,                             up = device_commands.CMFD1OSS18,                name = _('CMFD1 OSS18'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD1OSS19,                             up = device_commands.CMFD1OSS19,                name = _('CMFD1 OSS19'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD1OSS20,                             up = device_commands.CMFD1OSS20,                name = _('CMFD1 OSS20'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD1OSS21,                             up = device_commands.CMFD1OSS21,                name = _('CMFD1 OSS21'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD1OSS22,                             up = device_commands.CMFD1OSS22,                name = _('CMFD1 OSS22'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD1OSS23,                             up = device_commands.CMFD1OSS23,                name = _('CMFD1 OSS23'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD1OSS24,                             up = device_commands.CMFD1OSS24,                name = _('CMFD1 OSS24'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD1OSS25,                             up = device_commands.CMFD1OSS25,                name = _('CMFD1 OSS25'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD1OSS26,                             up = device_commands.CMFD1OSS26,                name = _('CMFD1 OSS26'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD1OSS27,                             up = device_commands.CMFD1OSS27,                name = _('CMFD1 OSS27'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD1OSS28,                             up = device_commands.CMFD1OSS28,                name = _('CMFD1 OSS28'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD1ButtonBright,                      up = device_commands.CMFD1ButtonBright,         name = _('CMFD1 Brightness Up'),                                category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD1ButtonBright,                      up = device_commands.CMFD1ButtonBright,         name = _('CMFD1 Brightness Down'),                              category = {_('CMFD')},			            value_down =  -1.0,     value_up =  0.0,                                               cockpit_device_id = devices.CMFD},

-- CMFD2                
{down = device_commands.CMFD2OSS1,                              up = device_commands.CMFD2OSS1,                 name = _('CMFD2 OSS1'),			                                category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD2OSS2,                              up = device_commands.CMFD2OSS2,                 name = _('CMFD2 OSS2'),			                                category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD2OSS3,                              up = device_commands.CMFD2OSS3,                 name = _('CMFD2 OSS3'),			                                category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD2OSS4,                              up = device_commands.CMFD2OSS4,                 name = _('CMFD2 OSS4'),			                                category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD2OSS5,                              up = device_commands.CMFD2OSS5,                 name = _('CMFD2 OSS5'),			                                category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD2OSS6,                              up = device_commands.CMFD2OSS6,                 name = _('CMFD2 OSS6'),			                                category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD2OSS7,                              up = device_commands.CMFD2OSS7,                 name = _('CMFD2 OSS7'),			                                category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD2OSS8,                              up = device_commands.CMFD2OSS8,                 name = _('CMFD2 OSS8'),			                                category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD2OSS9,                              up = device_commands.CMFD2OSS9,                 name = _('CMFD2 OSS9'),			                                category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD2OSS10,                             up = device_commands.CMFD2OSS10,                name = _('CMFD2 OSS10'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD2OSS11,                             up = device_commands.CMFD2OSS11,                name = _('CMFD2 OSS11'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD2OSS12,                             up = device_commands.CMFD2OSS12,                name = _('CMFD2 OSS12'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD2OSS13,                             up = device_commands.CMFD2OSS13,                name = _('CMFD2 OSS13'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD2OSS14,                             up = device_commands.CMFD2OSS14,                name = _('CMFD2 OSS14'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD2OSS15,                             up = device_commands.CMFD2OSS15,                name = _('CMFD2 OSS15'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD2OSS16,                             up = device_commands.CMFD2OSS16,                name = _('CMFD2 OSS16'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD2OSS17,                             up = device_commands.CMFD2OSS17,                name = _('CMFD2 OSS17'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD2OSS18,                             up = device_commands.CMFD2OSS18,                name = _('CMFD2 OSS18'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD2OSS19,                             up = device_commands.CMFD2OSS19,                name = _('CMFD2 OSS19'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD2OSS20,                             up = device_commands.CMFD2OSS20,                name = _('CMFD2 OSS20'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD2OSS21,                             up = device_commands.CMFD2OSS21,                name = _('CMFD2 OSS21'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD2OSS22,                             up = device_commands.CMFD2OSS22,                name = _('CMFD2 OSS22'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD2OSS23,                             up = device_commands.CMFD2OSS23,                name = _('CMFD2 OSS23'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD2OSS24,                             up = device_commands.CMFD2OSS24,                name = _('CMFD2 OSS24'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD2OSS25,                             up = device_commands.CMFD2OSS25,                name = _('CMFD2 OSS25'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD2OSS26,                             up = device_commands.CMFD2OSS26,                name = _('CMFD2 OSS26'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD2OSS27,                             up = device_commands.CMFD2OSS27,                name = _('CMFD2 OSS27'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD2OSS28,                             up = device_commands.CMFD2OSS28,                name = _('CMFD2 OSS28'),			                            category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD2ButtonBright,                      up = device_commands.CMFD2ButtonBright,         name = _('CMFD2 Brightness Up'),                                category = {_('CMFD')},			            value_down =  1.0,      value_up =  0.0,                                               cockpit_device_id = devices.CMFD},
{down = device_commands.CMFD2ButtonBright,                      up = device_commands.CMFD2ButtonBright,         name = _('CMFD2 Brightness Down'),                              category = {_('CMFD')},			            value_down =  -1.0,     value_up =  0.0,                                               cockpit_device_id = devices.CMFD},

-- mirrors
{down = iCommandToggleMirrors,                                                                                  name = _('Toggle Mirrors'),                   category = {_('View Cockpit')}},

-- -- Weapons                                                                        
-- {combos = defaultDeviceAssignmentFor("fire"),	down = iCommandPlaneFire, up = iCommandPlaneFireOff, name = _('Weapon Fire'),	category = _('Weapons')},
-- {combos = {{key = 'JOY_BTN2'}},                 down = Keys.WeaponReleaseOn,	up = Keys.WeaponReleaseOff, name = _('Weapon Release Button (WRB)'), category = _('Weapons')},
-- {combos = {{key = 'JOY_BTN4'}},					down = iCommandPlaneChangeWeapon,				name = _('Weapon Change'),		category = _('Weapons')},
-- {combos = {{key = 'JOY_BTN5'}},					down = iCommandPlaneModeCannon,					name = _('Cannon'),				category = _('Weapons')},



-- {down = iCommandPlaneAutopilot, name = _('Autopilot'), category = _('Autopilot')},
-- {down = iCommandPlaneAUTOnOff, name = _('Autothrust'), category = _('Autopilot')},
-- {down = iCommandPlaneSAUHBarometric, name = _('Autopilot - Barometric Altitude Hold \'H\''), category = _('Autopilot')},
--{down = iCommandPlaneAutopilotOverrideOn, up = iCommandPlaneAutopilotOverrideOff, name = _('Autopilot override (Su-25T)'), category = _('Autopilot')},
-- {down = iCommandPlaneStabTangBank, name = _('Autopilot - Attitude Hold'), category = _('Autopilot')},
-- {down = iCommandPlaneStabHbarBank, name = _('Autopilot - Altitude And Roll Hold'), category = _('Autopilot')},
-- {down = iCommandPlaneStabHorizon,	name = _('Autopilot - Transition To Level Flight Control'), category = _('Autopilot')},
-- {down = iCommandPlaneStabHbar, name = _('Autopilot - Barometric Altitude Hold'), category = _('Autopilot')},
-- {down = iCommandPlaneStabHrad, name = _('Autopilot - Radar Altitude Hold'), category = _('Autopilot')},
-- {down = iCommandPlaneRouteAutopilot, name = _('Autopilot - \'Route following\''), category = _('Autopilot')},
-- {down = iCommandPlaneStabCancel, name = _('Autopilot Disengage'), category = _('Autopilot')},

-- -- Systems
-- {down = iCommandPlaneAirRefuel, name = _('Refueling Boom'), category = _('Systems')},
-- {down = iCommandPlaneHook, name = _('Tail Hook'), category = _('Systems')},
-- {down = iCommandPlanePackWing, name = _('Folding Wings'), category = _('Systems')},
-- {down = iCommandPlaneTrimCancel, name = _('Trim Reset'), category = _('Flight Control')},

-- -- Modes
-- {down = iCommandPlaneModeBVR, name = _('(2) Beyond Visual Range Mode'), category = _('Modes')},
-- {down = iCommandPlaneModeVS, name = _('(3) Close Air Combat Vertical Scan Mode'), category = _('Modes')},
-- {down = iCommandPlaneModeBore, name = _('(4) Close Air Combat Bore Mode'), category = _('Modes')},
-- {down = iCommandPlaneModeHelmet, name = _('(5) Close Air Combat HMD Helmet Mode'), category = _('Modes')},
-- {down = iCommandPlaneModeFI0, name = _('(6) Longitudinal Missile Aiming Mode'), category = _('Modes')},
-- {down = iCommandPlaneModeGround, name = _('(7) Air-To-Ground Mode'), category = _('Modes')},
-- {down = iCommandPlaneModeGrid, name = _('(8) Gunsight Reticle Switch'), category = _('Modes')},

-- -- Sensors
-- {combos = {{key = 'JOY_BTN3'}}, down = iCommandPlaneChangeLock, up = iCommandPlaneChangeLockUp, name = _('Target Lock'), category = _('Sensors')},
-- {down = iCommandSensorReset, name = _('Return To Search'), category = _('Sensors')},
-- {down = iCommandPlaneRadarOnOff, name = _('Radar On/Off'), category = _('Sensors')},
-- {down = iCommandPlaneRadarChangeMode, name = _('Radar RWS/TWS Mode Select'), category = _('Sensors')},
-- {down = iCommandPlaneRadarCenter, name = _('Target Designator To Center'), category = _('Sensors')},
-- {down = iCommandPlaneChangeRadarPRF, name = _('Radar Pulse Repeat Frequency Select'), category = _('Sensors')},
-- {down = iCommandPlaneEOSOnOff, name = _('Electro-Optical System On/Off'), category = _('Sensors')},
-- {pressed = iCommandPlaneRadarUp, up = iCommandPlaneRadarStop, name = _('Target Designator Up'), category = _('Sensors')},
-- {pressed = iCommandPlaneRadarDown, up = iCommandPlaneRadarStop, name = _('Target Designator Down'), category = _('Sensors')},
-- {pressed = iCommandPlaneRadarLeft, up = iCommandPlaneRadarStop, name = _('Target Designator Left'), category = _('Sensors')},
-- {pressed = iCommandPlaneRadarRight, up = iCommandPlaneRadarStop, name = _('Target Designator Right'), category = _('Sensors')},
-- {pressed = iCommandSelecterUp, up = iCommandSelecterStop, name = _('Scan Zone Up'), category = _('Sensors')},
-- {pressed = iCommandSelecterDown, up = iCommandSelecterStop, name = _('Scan Zone Down'), category = _('Sensors')},
-- {pressed = iCommandSelecterLeft, up = iCommandSelecterStop, name = _('Scan Zone Left'), category = _('Sensors')},
-- {pressed = iCommandSelecterRight, up = iCommandSelecterStop, name = _('Scan Zone Right'), category = _('Sensors')},
-- {down = iCommandPlaneZoomIn, name = _('Display Zoom In'), category = _('Sensors')},
-- {down = iCommandPlaneZoomOut, name = _('Display Zoom Out'), category = _('Sensors')},
-- --{down = iCommandPlaneLaunchPermissionOverride, name = _('Launch Permission Override'), category = _('Sensors')},
-- {down = iCommandDecreaseRadarScanArea, name = _('Radar Scan Zone Decrease'), category = _('Sensors')},
-- {down = iCommandIncreaseRadarScanArea, name = _('Radar Scan Zone Increase'), category = _('Sensors')},
-- {pressed = iCommandPlaneIncreaseBase_Distance, up = iCommandPlaneStopBase_Distance, name = _('Target Specified Size Increase'), category = _('Sensors')},
-- {pressed = iCommandPlaneDecreaseBase_Distance, up = iCommandPlaneStopBase_Distance, name = _('Target Specified Size Decrease'), category = _('Sensors')},
-- {down = iCommandChangeRWRMode, name = _('RWR/SPO Mode Select'), category = _('Sensors')},
-- {down = iCommandPlaneThreatWarnSoundVolumeDown, name = _('RWR/SPO Sound Signals Volume Down'), category = _('Sensors')},
-- {down = iCommandPlaneThreatWarnSoundVolumeUp, name = _('RWR/SPO Sound Signals Volume Up'), category = _('Sensors')},

-- -- Weapons                                                                        
-- {down = iCommandPlaneSalvoOnOff, name = _('Salvo Mode'), category = _('Weapons')},
-- {down = iCommandChangeGunRateOfFire, name = _('Cut Of Burst select'), category = _('Weapons')},
-- {down = iCommandPlaneHUDFilterOnOff, name = _('HUD Filter On Off'), category = _('Weapons')},
-- {down = iCommandPlaneRightMFD_OSB1 , name = _('MFD HUD Repeater Mode On Off'), category = _('Systems')},


})

-- joystick axes 
join(res.axisCommands,{
    {                                               action = iCommandPlaneRoll,			name = _('Roll')},
    {                                               action = iCommandPlanePitch,		name = _('Pitch')},
    {                                               action = iCommandPlaneRudder,		name = _('Rudder')},
    {                                               action = iCommandPlaneThrustCommon, name = _('Thrust')},
    {                                               action = Keys.AirBrake,             name = _('Airbrake')},
    {                                               action = iCommandWheelBrake,		name = _('Wheel Brake'),		category = {_('Systems')}},
    {												action = iCommandLeftWheelBrake,	name = _('Wheel Brake Left'),	category = {_('Systems')}},
    {												action = iCommandRightWheelBrake,	name = _('Wheel Brake Right'),	category = {_('Systems')}},
    {												action = iCommandRightWheelBrake,	name = _('Wheel Brake Right'),	category = {_('Systems')}},
    {                                               action = Keys.TDCX,                 name = _('TDC Slew Vertical'),  category = {_('Throttle'), _('HOTAS')}},
    {                                               action = Keys.TDCY,                 name = _('TDC Slew Horizontal'),category = {_('Throttle'), _('HOTAS')}},
})

return res
