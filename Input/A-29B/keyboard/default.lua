local cockpit = folder.."../../../Cockpit/Scripts/"
dofile(cockpit.."devices.lua")
dofile(cockpit.."command_defs.lua")

local res = external_profile("Config/Input/Aircrafts/common_keyboard_binding.lua")

join(res.keyCommands,{





-- Flight Control
{combos = {{key = 'Up'}},		down = iCommandPlaneUpStart,			up = iCommandPlaneUpStop,			name = _('Aircraft Pitch Down'),	category = _('Flight Control')},
{combos = {{key = 'Down'}},		down = iCommandPlaneDownStart,			up = iCommandPlaneDownStop,			name = _('Aircraft Pitch Up'),		category = _('Flight Control')},
{combos = {{key = 'Left'}},		down = iCommandPlaneLeftStart,			up = iCommandPlaneLeftStop,			name = _('Aircraft Bank Left'),		category = _('Flight Control')},
{combos = {{key = 'Right'}},	down = iCommandPlaneRightStart,			up = iCommandPlaneRightStop,		name = _('Aircraft Bank Right'),	category = _('Flight Control')},
{combos = {{key = 'Z'}},		down = iCommandPlaneLeftRudderStart,	up = iCommandPlaneLeftRudderStop,	name = _('Aircraft Rudder Left'),	category = _('Flight Control')},
{combos = {{key = 'X'}},		down = iCommandPlaneRightRudderStart,	up = iCommandPlaneRightRudderStop,	name = _('Aircraft Rudder Right'),	category = _('Flight Control')},


{combos = {{key = 'Num+'}}, 						pressed = iCommandThrottleIncrease,		up = iCommandThrottleStop,  name = _('Throttle Up'),		category = _('Flight Control')},
{combos = {{key = 'Num-'}}, 						pressed = iCommandThrottleDecrease,		up = iCommandThrottleStop,  name = _('Throttle Down'),		category = _('Flight Control')},

{combos = {{key = 'PageUp'}},							down = iCommandPlaneAUTIncreaseRegime,		name = _('Throttle Step Up'),			category = _('Flight Control')},
{combos = {{key = 'PageDown'}},							down = iCommandPlaneAUTDecreaseRegime,		name = _('Throttle Step Down'),			category = _('Flight Control')},

{combos = {{key = 'Z', reformers = {'RCtrl'}}},	pressed = iCommandPlaneTrimLeftRudder,	up = iCommandPlaneTrimStop, name = _('Trim: Rudder Left'),		category = _('Flight Control')},
{combos = {{key = 'X', reformers = {'RCtrl'}}},	pressed = iCommandPlaneTrimRightRudder,	up = iCommandPlaneTrimStop, name = _('Trim: Rudder Right'),		category = _('Flight Control')},

-- Systems
{combos = {{key = 'B'}},							down = iCommandPlaneAirBrake,				name = _('Airbrake'),								category = _('Systems') , features = {"airbrake"}},
{combos = {{key = 'B', reformers = {'LShift'}}},	down = iCommandPlaneAirBrakeOn,				name = _('Airbrake On'),							category = _('Systems') , features = {"airbrake"}},
{combos = {{key = 'B', reformers = {'LCtrl'}}},		down = iCommandPlaneAirBrakeOff,			name = _('Airbrake Off'),							category = _('Systems') , features = {"airbrake"}},
{combos = {{key = 'T'}},							down = iCommandPlaneWingtipSmokeOnOff,		name = _('Smoke'),									category = _('Systems')},
{combos = {{key = 'L'}},							down = iCommandPlaneCockpitIllumination,	name = _('Illumination Cockpit'),					category = _('Systems')},
{combos = {{key = 'L', reformers = {'RCtrl'}}},		down = iCommandPlaneLightsOnOff,			name = _('Navigation lights'),						category = _('Systems')},
{combos = {{key = 'L', reformers = {'RAlt'}}},		down = iCommandPlaneHeadLightOnOff,			name = _('Gear Light Near/Far/Off'),				category = _('Systems')},
{combos = {{key = 'F'}},							down = iCommandPlaneFlaps,					name = _('Flaps Up/Down'),							category = _('Systems')},
{combos = {{key = 'F', reformers = {'LShift'}}},	down = iCommandPlaneFlapsOn,				name = _('Flaps Landing Position'),					category = _('Systems')},
{combos = {{key = 'F', reformers = {'LCtrl'}}},		down = iCommandPlaneFlapsOff,				name = _('Flaps Up'),								category = _('Systems')},
{combos = {{key = 'G'}},							down = iCommandPlaneGear,					name = _('Landing Gear Up/Down'),					category = _('Systems')},
{combos = {{key = 'G', reformers = {'LCtrl'}}},		down = iCommandPlaneGearUp,					name = _('Landing Gear Up'),						category = _('Systems')},
{combos = {{key = 'G', reformers = {'LShift'}}},	down = iCommandPlaneGearDown,				name = _('Landing Gear Down'),						category = _('Systems')},
{combos = {{key = 'W'}},							down = iCommandPlaneWheelBrakeOn, up = iCommandPlaneWheelBrakeOff, name = _('Wheel Brake On'),	category = _('Systems')},
{combos = {{key = 'C', reformers = {'LCtrl'}}},		down = iCommandPlaneFonar,					name = _('Canopy Open/Close'),						category = _('Systems')},
{combos = {{key = 'N', reformers = {'RShift'}}},	down = iCommandPlaneResetMasterWarning,		name = _('Audible Warning Reset'),					category = _('Systems')},
{combos = {{key = 'W', reformers = {'LCtrl'}}},		down = iCommandPlaneJettisonWeapons,up = iCommandPlaneJettisonWeaponsUp, name = _('Weapons Jettison'), category = _('Systems')},
{combos = {{key = 'E', reformers = {'LCtrl'}}},		down = iCommandPlaneEject,					name = _('Eject (3 times)'),						category = _('Systems')},
{combos = {{key = 'H', reformers = {'RCtrl','RShift'}}}, pressed = iCommandHUDBrightnessUp,		name = _('HUD Brightness up'),						category = _('Systems') , features = {"HUDbrightness"}},
{combos = {{key = 'H', reformers = {'RShift','RAlt'}}}, pressed = iCommandHUDBrightnessDown,	name = _('HUD Brightness down'),					category = _('Systems') , features = {"HUDbrightness"}},

-- Stick
{combos = {{key = '.', reformers = {'RCtrl'}}},	pressed = iCommandPlaneTrimUp,			up = iCommandPlaneTrimStop, name = _('Trim: Nose Up'),			category = {_('Stick'), _('HOTAS')}},
{combos = {{key = ';', reformers = {'RCtrl'}}},	pressed = iCommandPlaneTrimDown,		up = iCommandPlaneTrimStop, name = _('Trim: Nose Down'),		category = {_('Stick'), _('HOTAS')}},
{combos = {{key = ',', reformers = {'RCtrl'}}},	pressed = iCommandPlaneTrimLeft,		up = iCommandPlaneTrimStop, name = _('Trim: Left Wing Down'),	category = {_('Stick'), _('HOTAS')}},
{combos = {{key = '/', reformers = {'RCtrl'}}},	pressed = iCommandPlaneTrimRight,		up = iCommandPlaneTrimStop, name = _('Trim: Right Wing Down'),	category = {_('Stick'), _('HOTAS')}},

{combos = {{key = 'D'}},	                        down = Keys.StickStep,	            up = Keys.StickStep,        name = _('Step'),		            category = {_('Stick'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},
{combos = {{key = 'Enter'}},	                    down = Keys.StickDesignate,	        up = Keys.StickDesignate,   name = _('Designate'),              category = {_('Stick'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},
{combos = {{key = 'Enter', reformers = {'RShift'}}},down = Keys.StickUndesignate,	    up = Keys.StickUndesignate, name = _('Undesignate'),	        category = {_('Stick'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},

{combos = {{key = '1'}},                            down = Keys.MasterModeSw,	            up = Keys.MasterModeSw,       name = _('Main Mode Switch - NAV'),     category = {_('Stick'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},
{combos = {{key = '2'}},                            down = Keys.MasterModeSw,	            up = Keys.MasterModeSw,       name = _('Main Mode Switch - A/G'),     category = {_('Stick'), _('HOTAS')}, value_down =  2.0,		value_up = 0.0},
{combos = {{key = '3'}},                            down = Keys.MasterModeSw,	            up = Keys.MasterModeSw,       name = _('Main Mode Switch - A/A INT'),	category = {_('Stick'), _('HOTAS')}, value_down =  3.0,		value_up = 0.0},
{combos = {{key = '4'}},                            down = Keys.MasterModeSw,	            up = Keys.MasterModeSw,       name = _('Main Mode Switch - A/A DGFT'),category = {_('Stick'), _('HOTAS')}, value_down =  4.0,		value_up = 0.0},

{                                                   down = Keys.APDisengage,            up = Keys.APDisengage,      name = _('Autopilot Disengage'),        category = {_('Stick'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},
{                                                   down = Keys.APOvrd,                 up = Keys.APOvrd,           name = _('Autopilot Override'),         category = {_('Stick'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},

{                                                   down = Keys.Call,	                up = Keys.Call,             name = _('Call'),                       category = {_('Stick'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},

{                                                   down = Keys.Trigger,	            up = Keys.Trigger,          name = _('Gun Trigger First Detent'),   category = {_('Stick'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},
{combos = {{key = 'Space'}},                        down = Keys.Trigger,	            up = Keys.Trigger,          name = _('Gun Trigger Second Detent'),  category = {_('Stick'), _('HOTAS')}, value_down =  2.0,		value_up = 0.0},
{combos = {{key = 'Space',	reformers = {'RAlt'}}},	down = Keys.WeaponRelease,	        up = Keys.WeaponRelease,	name = _('Weapon Release Button (WRB)'),category = {_('Stick'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},

{                                                   down = Keys.DisplayMngt,            up = Keys.DisplayMngt,      name = _('DMS Fwd - HUD'),              category = {_('Stick'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},
{                                                   down = Keys.DisplayMngt,            up = Keys.DisplayMngt,      name = _('DMS Aft - No Function'),      category = {_('Stick'), _('HOTAS')}, value_down =  2.0,		value_up = 0.0},
{                                                   down = Keys.DisplayMngt,            up = Keys.DisplayMngt,      name = _('DMS Left - CMFD #1'),         category = {_('Stick'), _('HOTAS')}, value_down =  3.0,		value_up = 0.0},
{                                                   down = Keys.DisplayMngt,            up = Keys.DisplayMngt,      name = _('DMS Right - CMFD #2'),        category = {_('Stick'), _('HOTAS')}, value_down =  4.0,		value_up = 0.0},
{                                                   down = Keys.DisplayMngt,            up = Keys.DisplayMngt,      name = _('DMS Depress - Autopilot'),    category = {_('Stick'), _('HOTAS')}, value_down =  5.0,		value_up = 0.0},


{                                                   down = Keys.GunSelDist,            up = Keys.GunSelDist,        name = _('Machine Gun Selection'),      category = {_('Throttle'), _('HOTAS')}, value_down =  -1.0,		value_up = 0.0},
{                                                   down = Keys.GunSelDist,            up = Keys.GunSelDist,        name = _('Machine Gun Distance'),       category = {_('Throttle'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},
{                                                   down = Keys.GunRearm,              up = Keys.GunRearm,          name = _('Machine Gun Rearm'),          category = {_('Throttle'), _('HOTAS')}, value_down =  -1.0,		value_up = 0.0},
{                                                   down = Keys.Cage,                  up = Keys.Cage,              name = _('Cage / Uncage'),              category = {_('Throttle'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},
{                                                   down = Keys.TDCX,                  up = Keys.TDCX,              name = _('TDC Slew Left'),              category = {_('Throttle'), _('HOTAS')}, value_down =  -1.0,		value_up = 0.0},
{                                                   down = Keys.TDCX,                  up = Keys.TDCX,              name = _('TDC Slew Right'),             category = {_('Throttle'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},
{                                                   down = Keys.TDCY,                  up = Keys.TDCY,              name = _('TDC Slew Up'),                category = {_('Throttle'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},
{                                                   down = Keys.TDCY,                  up = Keys.TDCY,              name = _('TDC Slew Down'),              category = {_('Throttle'), _('HOTAS')}, value_down =  -1.0,		value_up = 0.0},


-- {combos = {{key = 'Space'}},							down = hotas_commands.STICK_TRIGGER_2ND_DETENT,		up = hotas_commands.STICK_TRIGGER_2ND_DETENT,		cockpit_device_id = devices.HOTAS,	value_down =  1.0,		value_up = 0.0,	name = _('Gun Trigger - SECOND DETENT (Press to shoot)'),				category = {_('Stick'), _('HOTAS')}},
-- {combos = {{key = ';',		reformers = {'RCtrl'}}},	pressed = hotas_commands.STICK_TRIMMER_DOWN,		up = hotas_commands.STICK_TRIMMER_DOWN,				cockpit_device_id = devices.HOTAS,	value_pressed =  1.0,	value_up = 0.0,	name = _('Trimmer Switch - PUSH(DESCEND)'),								category = {_('Stick'), _('Flight Control'), _('HOTAS')}},
-- {combos = {{key = '.',		reformers = {'RCtrl'}}},	pressed = hotas_commands.STICK_TRIMMER_UP,			up = hotas_commands.STICK_TRIMMER_UP,				cockpit_device_id = devices.HOTAS,	value_pressed =  1.0,	value_up = 0.0,	name = _('Trimmer Switch - PULL(CLIMB)'),								category = {_('Stick'), _('Flight Control'), _('HOTAS')}},
-- {combos = {{key = ',',		reformers = {'RCtrl'}}},	pressed = hotas_commands.STICK_TRIMMER_LEFT,		up = hotas_commands.STICK_TRIMMER_LEFT,				cockpit_device_id = devices.HOTAS,	value_pressed =  1.0,	value_up = 0.0,	name = _('Trimmer Switch - LEFT WING DOWN'),							category = {_('Stick'), _('Flight Control'), _('HOTAS')}},
-- {combos = {{key = '/',		reformers = {'RCtrl'}}},	pressed = hotas_commands.STICK_TRIMMER_RIGHT,		up = hotas_commands.STICK_TRIMMER_RIGHT,			cockpit_device_id = devices.HOTAS,	value_pressed =  1.0,	value_up = 0.0,	name = _('Trimmer Switch - RIGHT WING DOWN'),							category = {_('Stick'), _('Flight Control'), _('HOTAS')}},
-- {combos = {{key = 'A'}},								down = hotas_commands.STICK_PADDLE,					up = hotas_commands.STICK_PADDLE,					cockpit_device_id = devices.HOTAS,	value_down =  1.0,		value_up = 0.0,	name = _('Autopilot/Nosewheel Steering Disengage (Paddle) Switch'),		category = {_('Stick'), _('HOTAS')}},
-- {combos = {{key = 'S'}},								down = hotas_commands.STICK_UNDESIGNATE,			up = hotas_commands.STICK_UNDESIGNATE,				cockpit_device_id = devices.HOTAS,	value_down =  1.0,		value_up = 0.0,	name = _('Undesignate/Nose Wheel Steer Switch'),						category = {_('Stick'), _('HOTAS')}},
-- {combos = {{key = 'W',		reformers = {'LShift'}}},	down = hotas_commands.STICK_WEAPON_SELECT_FWD,		up = hotas_commands.STICK_WEAPON_SELECT_FWD,		cockpit_device_id = devices.HOTAS,	value_down =  1.0,		value_up = 0.0,	name = _('Select Sparrow'),												category = {_('Stick'), _('HOTAS')}},
-- {combos = {{key = 'X',		reformers = {'LShift'}}},	down = hotas_commands.STICK_WEAPON_SELECT_AFT,		up = hotas_commands.STICK_WEAPON_SELECT_AFT,		cockpit_device_id = devices.HOTAS,	value_down =  1.0,		value_up = 0.0,	name = _('Select Gun'),													category = {_('Stick'), _('HOTAS')}},
-- {combos = {{key = 'D',		reformers = {'LShift'}}},	down = hotas_commands.STICK_WEAPON_SELECT_IN,		up = hotas_commands.STICK_WEAPON_SELECT_IN,			cockpit_device_id = devices.HOTAS,	value_down =  1.0,		value_up = 0.0,	name = _('Select AMRAAM'),												category = {_('Stick'), _('HOTAS')}},
-- {combos = {{key = 'S',		reformers = {'LShift'}}},	down = hotas_commands.STICK_WEAPON_SELECT_DOWN,		up = hotas_commands.STICK_WEAPON_SELECT_DOWN,		cockpit_device_id = devices.HOTAS,	value_down =  1.0,		value_up = 0.0,	name = _('Select Sidewinder'),											category = {_('Stick'), _('HOTAS')}},
-- {combos = {{key = 'R'}},								down = hotas_commands.STICK_RECCE_EVENT_MARK,		up = hotas_commands.STICK_RECCE_EVENT_MARK,			cockpit_device_id = devices.HOTAS,	value_down =  1.0,		value_up = 0.0,	name = _('RECCE Event Mark Switch'),									category = {_('Stick'), _('HOTAS')}},	-- ATTENTION!!! not used (do not assign combos)
-- {combos = {{key = ';',		reformers = {'RAlt'}}},		down = hotas_commands.STICK_SENSOR_CONTROL_FWD,		up = hotas_commands.STICK_SENSOR_CONTROL_FWD,		cockpit_device_id = devices.HOTAS,	value_down =  1.0,		value_up = 0.0,	name = _('Sensor Control Switch - Fwd'),								category = {_('Stick'), _('HOTAS')}},
-- {combos = {{key = '.',		reformers = {'RAlt'}}},		down = hotas_commands.STICK_SENSOR_CONTROL_AFT,		up = hotas_commands.STICK_SENSOR_CONTROL_AFT,		cockpit_device_id = devices.HOTAS,	value_down =  1.0,		value_up = 0.0,	name = _('Sensor Control Switch - Aft'),								category = {_('Stick'), _('HOTAS')}},
-- {combos = {{key = ',',		reformers = {'RAlt'}}},		down = hotas_commands.STICK_SENSOR_CONTROL_LEFT,	up = hotas_commands.STICK_SENSOR_CONTROL_LEFT,		cockpit_device_id = devices.HOTAS,	value_down =  1.0,		value_up = 0.0,	name = _('Sensor Control Switch - Left'),								category = {_('Stick'), _('HOTAS')}},
-- {combos = {{key = '/',		reformers = {'RAlt'}}},		down = hotas_commands.STICK_SENSOR_CONTROL_RIGHT,	up = hotas_commands.STICK_SENSOR_CONTROL_RIGHT,		cockpit_device_id = devices.HOTAS,	value_down =  1.0,		value_up = 0.0,	name = _('Sensor Control Switch - Right'),								category = {_('Stick'), _('HOTAS')}},
-- {														down = hotas_commands.STICK_SENSOR_CONTROL_DEPRESS,	up = hotas_commands.STICK_SENSOR_CONTROL_DEPRESS,	cockpit_device_id = devices.HOTAS,	value_down =  1.0,		value_up = 0.0,	name = _('Sensor Control Switch - Depress'),							category = {_('Stick'), _('HOTAS')}},

-- {									down = cpt_commands.StickHide,		cockpit_device_id = devices.CPT_MECHANICS,	value_down =  1.0,	name = _('Control Stick - HIDE'),			category = {_('Stick'), _('HOTAS')}},
-- {									down = cpt_commands.StickHide,		cockpit_device_id = devices.CPT_MECHANICS,	value_down =  0.0,	name = _('Control Stick - SHOW'),			category = {_('Stick'), _('HOTAS')}},
-- {combos = {{key = 'Back'}},	down = cpt_commands.StickHide_EXT,	cockpit_device_id = devices.CPT_MECHANICS,	value_down =  1.0,	name = _('Control Stick - HIDE/SHOW'),		category = {_('Stick'), _('HOTAS')}},

-- Countermeasures
-- {combos = {{key = 'Q', reformers = {'LShift'}}},	down = iCommandPlaneDropSnar,			name = _('Countermeasures Continuously Dispense'),					category = _('Countermeasures') , features = {"Countermeasures"}},
-- {combos = {{key = 'Q'}},							down = iCommandPlaneDropSnarOnce, up = iCommandPlaneDropSnarOnceOff, name = _('Countermeasures Release'),	category = _('Countermeasures') , features = {"Countermeasures"}},
-- {combos = {{key = 'Delete'}},						down = iCommandPlaneDropFlareOnce,		name = _('Countermeasures Flares Dispense'),						category = _('Countermeasures') , features = {"Countermeasures"}},
-- {combos = {{key = 'Insert'}},						down = iCommandPlaneDropChaffOnce,		name = _('Countermeasures Chaff Dispense'),							category = _('Countermeasures') , features = {"Countermeasures"}},
-- {combos = {{key = 'E'}},							down = iCommandActiveJamming,			name = _('ECM'),													category = _('Countermeasures') , features = {"ECM"}},











    -- {combos = {{key = '=', reformers = {'RShift'}}}, pressed = iCommandAltimeterPressureIncrease,	up = iCommandAltimeterPressureStop, name = _('Altimeter Pressure Increase'), category = _('Systems')},
-- {combos = {{key = '-', reformers = {'RShift'}}}, pressed = iCommandAltimeterPressureDecrease, up = iCommandAltimeterPressureStop, name = _('Altimeter Pressure Decrease'), category = _('Systems')},

-- -- Autopilot
-- {combos = {{key = 'A'}}, down = iCommandPlaneAutopilot, name = _('Autopilot'), category = _('Autopilot')},
-- {combos = {{key = 'J'}}, down = iCommandPlaneAUTOnOff, name = _('Autothrust'), category = _('Autopilot')},
-- {combos = {{key = 'H'}}, down = iCommandPlaneSAUHBarometric, name = _('Autopilot - Barometric Altitude Hold \'H\''), category = _('Autopilot')},
-- {combos = {{key = '1', reformers = {'LAlt'}}}, down = iCommandPlaneStabTangBank, name = _('Autopilot - Attitude Hold'), category = _('Autopilot')},
-- {combos = {{key = '2', reformers = {'LAlt'}}}, down = iCommandPlaneStabHbarBank, name = _('Autopilot - Altitude And Roll Hold'), category = _('Autopilot')},
-- {combos = {{key = '3', reformers = {'LAlt'}}}, down = iCommandPlaneStabHorizon,	name = _('Autopilot - Transition To Level Flight Control'), category = _('Autopilot')},
-- {combos = {{key = '4', reformers = {'LAlt'}}}, down = iCommandPlaneStabHbar, name = _('Autopilot - Barometric Altitude Hold'), category = _('Autopilot')},
-- {combos = {{key = '5', reformers = {'LAlt'}}}, down = iCommandPlaneStabHrad, name = _('Autopilot - Radar Altitude Hold'), category = _('Autopilot')},
-- {combos = {{key = '6', reformers = {'LAlt'}}}, down = iCommandPlaneRouteAutopilot, name = _('Autopilot - \'Route following\''), category = _('Autopilot')},
-- {combos = {{key = '9', reformers = {'LAlt'}}}, down = iCommandPlaneStabCancel, name = _('Autopilot Disengage'), category = _('Autopilot')},

-- -- Systems
-- {combos = {{key = 'R', reformers = {'LCtrl'}}}, down = iCommandPlaneAirRefuel, name = _('Refueling Boom'), category = _('Systems')},
-- {combos = {{key = 'G', reformers = {'LAlt'}}}, down = iCommandPlaneHook, name = _('Tail Hook'), category = _('Systems')},
-- {combos = {{key = 'P', reformers = {'RCtrl'}}}, down = iCommandPlanePackWing, name = _('Folding Wings'), category = _('Systems')},

-- -- Modes
-- {combos = {{key = '2'}}, down = iCommandPlaneModeBVR, name = _('(2) Beyond Visual Range Mode'), category = _('Modes')},
-- {combos = {{key = '3'}}, down = iCommandPlaneModeVS, name = _('(3) Close Air Combat Vertical Scan Mode'), category = _('Modes')},
-- {combos = {{key = '4'}}, down = iCommandPlaneModeBore, name = _('(4) Close Air Combat Bore Mode'), category = _('Modes')},
-- {combos = {{key = '5'}}, down = iCommandPlaneModeHelmet, name = _('(5) Close Air Combat HMD Helmet Mode'), category = _('Modes')},
-- {combos = {{key = '6'}}, down = iCommandPlaneModeFI0, name = _('(6) Longitudinal Missile Aiming Mode'), category = _('Modes')},
-- {combos = {{key = '7'}}, down = iCommandPlaneModeGround, name = _('(7) Air-To-Ground Mode'), category = _('Modes')},
-- {combos = {{key = '8'}}, down = iCommandPlaneModeGrid, name = _('(8) Gunsight Reticle Switch'), category = _('Modes')},

-- -- Flight Control
-- {combos = {{key = 'T', reformers = {'LCtrl'}}}, down = iCommandPlaneTrimCancel, name = _('Trim Reset'), category = _('Flight Control')},

-- -- Sensors
-- {combos = {{key = 'Enter'}}, down = iCommandPlaneChangeLock, up = iCommandPlaneChangeLockUp, name = _('Target Lock'), category = _('Sensors')},
-- {combos = {{key = 'Back'}}, down = iCommandSensorReset, name = _('Return To Search'), category = _('Sensors')},
-- {combos = {{key = 'I'}}, down = iCommandPlaneRadarOnOff, name = _('Radar On/Off'), category = _('Sensors')},
-- {combos = {{key = 'I', reformers = {'RAlt'}}}, down = iCommandPlaneRadarChangeMode, name = _('Radar RWS/TWS Mode Select'), category = _('Sensors')},
-- {combos = {{key = 'I', reformers = {'RCtrl'}}}, down = iCommandPlaneRadarCenter, name = _('Target Designator To Center'), category = _('Sensors')},
-- {combos = {{key = 'I', reformers = {'RShift'}}}, down = iCommandPlaneChangeRadarPRF, name = _('Radar Pulse Repeat Frequency Select'), category = _('Sensors')},
-- {combos = {{key = 'O'}}, down = iCommandPlaneEOSOnOff, name = _('Electro-Optical System On/Off'), category = _('Sensors')},
-- {combos = {{key = 'O', reformers = {'RCtrl'}}}, down = iCommandPlaneNightTVOnOff, name = _('Night Vision (FLIR or LLTV) On/Off'), category = _('Sensors')},
-- {combos = {{key = ';'}}, pressed = iCommandPlaneRadarUp, up = iCommandPlaneRadarStop, name = _('Target Designator Up'), category = _('Sensors')},
-- {combos = {{key = '.'}}, pressed = iCommandPlaneRadarDown, up = iCommandPlaneRadarStop, name = _('Target Designator Down'), category = _('Sensors')},
-- {combos = {{key = ','}}, pressed = iCommandPlaneRadarLeft, up = iCommandPlaneRadarStop, name = _('Target Designator Left'), category = _('Sensors')},
-- {combos = {{key = '/'}}, pressed = iCommandPlaneRadarRight, up = iCommandPlaneRadarStop, name = _('Target Designator Right'), category = _('Sensors')},
-- {combos = {{key = ';', reformers = {'RShift'}}}, pressed = iCommandSelecterUp, up = iCommandSelecterStop, name = _('Scan Zone Up'), category = _('Sensors')},
-- {combos = {{key = '.', reformers = {'RShift'}}}, pressed = iCommandSelecterDown, up = iCommandSelecterStop, name = _('Scan Zone Down'), category = _('Sensors')},
-- {combos = {{key = ',', reformers = {'RShift'}}}, pressed = iCommandSelecterLeft, up = iCommandSelecterStop, name = _('Scan Zone Left'), category = _('Sensors')},
-- {combos = {{key = '/', reformers = {'RShift'}}}, pressed = iCommandSelecterRight, up = iCommandSelecterStop, name = _('Scan Zone Right'), category = _('Sensors')},
-- {combos = {{key = '='}}, down = iCommandPlaneZoomIn, name = _('Display Zoom In'), category = _('Sensors')},
-- {combos = {{key = '-'}}, down = iCommandPlaneZoomOut, name = _('Display Zoom Out'), category = _('Sensors')},
-- {combos = {{key = '-', reformers = {'RCtrl'}}}, down = iCommandDecreaseRadarScanArea, name = _('Radar Scan Zone Decrease'), category = _('Sensors')},
-- {combos = {{key = '=', reformers = {'RCtrl'}}}, down = iCommandIncreaseRadarScanArea, name = _('Radar Scan Zone Increase'), category = _('Sensors')},
-- {combos = {{key = '=', reformers = {'RAlt'}}}, pressed = iCommandPlaneIncreaseBase_Distance, up = iCommandPlaneStopBase_Distance, name = _('Target Specified Size Increase'), category = _('Sensors')},
-- {combos = {{key = '-', reformers = {'RAlt'}}}, pressed = iCommandPlaneDecreaseBase_Distance, up = iCommandPlaneStopBase_Distance, name = _('Target Specified Size Decrease'), category = _('Sensors')},
-- {combos = {{key = 'R', reformers = {'RShift'}}}, down = iCommandChangeRWRMode, name = _('RWR/SPO Mode Select'), category = _('Sensors')},
-- {combos = {{key = ',', reformers = {'RAlt'}}}, down = iCommandPlaneThreatWarnSoundVolumeDown, name = _('RWR/SPO Sound Signals Volume Down'), category = _('Sensors')},
-- {combos = {{key = '.', reformers = {'RAlt'}}}, down = iCommandPlaneThreatWarnSoundVolumeUp, name = _('RWR/SPO Sound Signals Volume Up'), category = _('Sensors')},

-- -- Weapons                                                                        
-- {combos = {{key = 'V', reformers = {'LCtrl'}}}, down = iCommandPlaneSalvoOnOff, name = _('Salvo Mode'), category = _('Weapons')},
-- {combos = {{key = 'Space', reformers = {'RAlt'}}}, down = iCommandPlanePickleOn,	up = iCommandPlanePickleOff, name = _('Weapon Release'), category = _('Weapons')},
-- {combos = {{key = 'C', reformers = {'LShift'}}}, down = iCommandChangeGunRateOfFire, name = _('Cut Of Burst select'), category = _('Weapons')},
-- {combos = {{key = 'H', reformers = {'RShift'}}}, down = iCommandPlaneHUDFilterOnOff, name = _('HUD Filter On Off'), category = _('Weapons')},
-- {down = iCommandPlaneRightMFD_OSB1 , name = _('MFD HUD Repeater Mode On Off'), category = _('Systems')},

})
return res
