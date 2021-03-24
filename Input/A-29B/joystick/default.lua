local cockpit = folder.."../../../Cockpit/Scripts/"
dofile(cockpit.."devices.lua")
dofile(cockpit.."command_defs.lua")

local res = external_profile("Config/Input/Aircrafts/common_joystick_binding.lua")

join(res.keyCommands,{





    --Flight Control
{down = iCommandPlaneUpStart,				up = iCommandPlaneUpStop,			name = _('Aircraft Pitch Down'),	category = _('Flight Control')},
{down = iCommandPlaneDownStart,				up = iCommandPlaneDownStop,			name = _('Aircraft Pitch Up'),		category = _('Flight Control')},
{down = iCommandPlaneLeftStart,				up = iCommandPlaneLeftStop,			name = _('Aircraft Bank Left'),		category = _('Flight Control')},
{down = iCommandPlaneRightStart,			up = iCommandPlaneRightStop,		name = _('Aircraft Bank Right'),	category = _('Flight Control')},
{down = iCommandPlaneLeftRudderStart,		up = iCommandPlaneLeftRudderStop,	name = _('Aircraft Rudder Left'),	category = _('Flight Control')},
{down = iCommandPlaneRightRudderStart,		up = iCommandPlaneRightRudderStop,	name = _('Aircraft Rudder Right'),	category = _('Flight Control')},

{pressed = iCommandThrottleIncrease, up = iCommandThrottleStop,  name = _('Throttle Up'),			category = _('Flight Control')},
{pressed = iCommandThrottleDecrease, up = iCommandThrottleStop,  name = _('Throttle Down'),			category = _('Flight Control')},

{down = iCommandPlaneAUTIncreaseRegime,			name = _('Throttle Step Up'),			category = _('Flight Control')},
{down = iCommandPlaneAUTDecreaseRegime,			name = _('Throttle Step Down'),			category = _('Flight Control')},

{pressed = iCommandPlaneTrimLeftRudder,	up = iCommandPlaneTrimStop, name = _('Trim: Rudder Left'),		category = _('Flight Control')},
{pressed = iCommandPlaneTrimRightRudder,up = iCommandPlaneTrimStop, name = _('Trim: Rudder Right'),		category = _('Flight Control')},

-- Systems
{down = iCommandPlaneAirBrake,				name = _('Airbrake'),					category = _('Systems')},
{down = iCommandPlaneAirBrakeOn, up = iCommandPlaneAirBrakeOn,				name = _('Airbrake On'),							category = _('Systems'), value_down =  1.0,		value_up = 0.0},
{down = iCommandPlaneAirBrakeOff,up = iCommandPlaneAirBrakeOff,			    name = _('Airbrake Off'),							category = _('Systems'), value_down =  1.0,		value_up = 0.0},
{down = iCommandPlaneWingtipSmokeOnOff,		name = _('Smoke'),						category = _('Systems')},
{down = iCommandPlaneCockpitIllumination,	name = _('Illumination Cockpit'),		category = _('Systems')},
{down = iCommandPlaneLightsOnOff,			name = _('Navigation lights'),			category = _('Systems')},
{down = iCommandPlaneHeadLightOnOff,		name = _('Gear Light Near/Far/Off'),	category = _('Systems')},
{down = iCommandPlaneFlaps,					name = _('Flaps Up/Down'),				category = _('Systems')},
{down = iCommandPlaneFlapsOn,				name = _('Flaps Landing Position'),		category = _('Systems')},
{down = iCommandPlaneFlapsOff,				name = _('Flaps Up'),					category = _('Systems')},
{down = iCommandPlaneGear,					name = _('Landing Gear Up/Down'),		category = _('Systems')},
{down = iCommandPlaneGearUp,				name = _('Landing Gear Up'),			category = _('Systems')},
{down = iCommandPlaneGearDown,				name = _('Landing Gear Down'),			category = _('Systems')},
{down = iCommandPlaneWheelBrakeOn, up = iCommandPlaneWheelBrakeOff,			name = _('Wheel Brake On'),		category = _('Systems')},
{down = iCommandPlaneFonar,					name = _('Canopy Open/Close'),			category = _('Systems')},
{down = iCommandPlaneResetMasterWarning,	name = _('Audible Warning Reset'),		category = _('Systems')},
{down = iCommandPlaneJettisonWeapons,up = iCommandPlaneJettisonWeaponsUp,	name = _('Weapons Jettison'),	category = _('Systems')},
{down = iCommandPlaneEject,					name = _('Eject (3 times)'),			category = _('Systems')},
{pressed = iCommandHUDBrightnessUp,			name = _('HUD Brightness up'),			category = _('Systems')},
{pressed = iCommandHUDBrightnessDown,		name = _('HUD Brightness down'),		category = _('Systems')},

-- Stick
{pressed = iCommandPlaneTrimUp,			up = iCommandPlaneTrimStop, name = _('Trim: Nose Up'),			category = {_('Stick'), _('HOTAS')}},
{pressed = iCommandPlaneTrimDown,		up = iCommandPlaneTrimStop, name = _('Trim: Nose Down'),		category = {_('Stick'), _('HOTAS')}},
{pressed = iCommandPlaneTrimLeft,		up = iCommandPlaneTrimStop, name = _('Trim: Left Wing Down'),	category = {_('Stick'), _('HOTAS')}},
{pressed = iCommandPlaneTrimRight,		up = iCommandPlaneTrimStop, name = _('Trim: Right Wing Down'),	category = {_('Stick'), _('HOTAS')}},

{down = Keys.StickStep,	            up = Keys.StickStep,        name = _('Step'),		                category = {_('Stick'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},
{down = Keys.StickDesignate,	    up = Keys.StickDesignate,   name = _('Designate'),                  category = {_('Stick'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},
{down = Keys.StickUndesignate,	    up = Keys.StickUndesignate, name = _('Undesignate'),	            category = {_('Stick'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},

{down = Keys.MasterModeSw,	        up = Keys.MasterModeSw,     name = _('Main Mode Switch - NAV'),     category = {_('Stick'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},
{down = Keys.MasterModeSw,	        up = Keys.MasterModeSw,     name = _('Main Mode Switch - A/G'),     category = {_('Stick'), _('HOTAS')}, value_down =  2.0,		value_up = 0.0},
{down = Keys.MasterModeSw,	        up = Keys.MasterModeSw,     name = _('Main Mode Switch - A/A INT'),	category = {_('Stick'), _('HOTAS')}, value_down =  3.0,		value_up = 0.0},
{down = Keys.MasterModeSw,	        up = Keys.MasterModeSw,     name = _('Main Mode Switch - A/A DGFT'),category = {_('Stick'), _('HOTAS')}, value_down =  4.0,		value_up = 0.0},

{down = Keys.APDisengage,	        up = Keys.APDisengage,      name = _('Autopilot Disengage'),        category = {_('Stick'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},
{down = Keys.APOvrd,                up = Keys.APOvrd,           name = _('Autopilot Override'),         category = {_('Stick'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},

{down = Keys.Call,	                up = Keys.Call,             name = _('Call'),                       category = {_('Stick'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},

{down = Keys.Trigger,	            up = Keys.Trigger,          name = _('Gun Trigger First Detent'),   category = {_('Stick'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},
{down = Keys.Trigger,	            up = Keys.Trigger,          name = _('Gun Trigger Second Detent'),  category = {_('Stick'), _('HOTAS')}, value_down =  2.0,		value_up = 0.0},
{down = Keys.WeaponRelease,	        up = Keys.WeaponRelease,	name = _('Weapon Release Button (WRB)'),category = {_('Stick'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},

{down = Keys.DisplayMngt,           up = Keys.DisplayMngt,      name = _('DMS Fwd - HUD'),              category = {_('Stick'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},
{down = Keys.DisplayMngt,           up = Keys.DisplayMngt,      name = _('DMS Aft - No Function'),      category = {_('Stick'), _('HOTAS')}, value_down =  2.0,		value_up = 0.0},
{down = Keys.DisplayMngt,           up = Keys.DisplayMngt,      name = _('DMS Left - CMFD #1'),         category = {_('Stick'), _('HOTAS')}, value_down =  3.0,		value_up = 0.0},
{down = Keys.DisplayMngt,           up = Keys.DisplayMngt,      name = _('DMS Right - CMFD #2'),        category = {_('Stick'), _('HOTAS')}, value_down =  4.0,		value_up = 0.0},
{down = Keys.DisplayMngt,           up = Keys.DisplayMngt,      name = _('DMS Depress - Autopilot'),    category = {_('Stick'), _('HOTAS')}, value_down =  5.0,		value_up = 0.0},


{down = Keys.GunSelDist,            up = Keys.GunSelDist,        name = _('Machine Gun Selection'),     category = {_('Throttle'), _('HOTAS')}, value_down =  -1.0,		value_up = 0.0},
{down = Keys.GunSelDist,            up = Keys.GunSelDist,        name = _('Machine Gun Distance'),      category = {_('Throttle'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},
{down = Keys.GunRearm,              up = Keys.GunRearm,          name = _('Machine Gun Rearm'),         category = {_('Throttle'), _('HOTAS')}, value_down =  -1.0,		value_up = 0.0},
{down = Keys.Cage,                  up = Keys.Cage,              name = _('Cage / Uncage'),             category = {_('Throttle'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},
{down = Keys.TDCX,                  up = Keys.TDCX,              name = _('TDC Slew Left'),             category = {_('Throttle'), _('HOTAS')}, value_down =  -1.0,		value_up = 0.0},
{down = Keys.TDCX,                  up = Keys.TDCX,              name = _('TDC Slew Right'),            category = {_('Throttle'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},
{down = Keys.TDCY,                  up = Keys.TDCY,              name = _('TDC Slew Up'),               category = {_('Throttle'), _('HOTAS')}, value_down =  1.0,		value_up = 0.0},
{down = Keys.TDCY,                  up = Keys.TDCY,              name = _('TDC Slew Down'),             category = {_('Throttle'), _('HOTAS')}, value_down =  -1.0,		value_up = 0.0},


-- -- Weapons                                                                        
-- {combos = defaultDeviceAssignmentFor("fire"),	down = iCommandPlaneFire, up = iCommandPlaneFireOff, name = _('Weapon Fire'),	category = _('Weapons')},
-- {combos = {{key = 'JOY_BTN2'}},                 down = Keys.WeaponReleaseOn,	up = Keys.WeaponReleaseOff, name = _('Weapon Release Button (WRB)'), category = _('Weapons')},
-- {combos = {{key = 'JOY_BTN4'}},					down = iCommandPlaneChangeWeapon,				name = _('Weapon Change'),		category = _('Weapons')},
-- {combos = {{key = 'JOY_BTN5'}},					down = iCommandPlaneModeCannon,					name = _('Cannon'),				category = _('Weapons')},

-- Countermeasures
-- {down = iCommandPlaneDropSnar,		name = _('Countermeasures Continuously Dispense'),	category = _('Countermeasures') , features = {"Countermeasures"}},
-- {down = iCommandPlaneDropSnarOnce,	up = iCommandPlaneDropSnarOnceOff,	name = _('Countermeasures Release'),	category = _('Countermeasures') , features = {"Countermeasures"}},
-- {down = iCommandPlaneDropFlareOnce, name = _('Countermeasures Flares Dispense'),		category = _('Countermeasures') , features = {"Countermeasures"}},
-- {down = iCommandPlaneDropChaffOnce, name = _('Countermeasures Chaff Dispense'),			category = _('Countermeasures') , features = {"Countermeasures"}},
-- {down = iCommandActiveJamming,		name = _('ECM'),									category = _('Countermeasures') , features = {"ECM"}},


















-- {pressed = iCommandAltimeterPressureIncrease,	up = iCommandAltimeterPressureStop, name = _('Altimeter Pressure Increase'), category = _('Systems')},
-- {pressed = iCommandAltimeterPressureDecrease, up = iCommandAltimeterPressureStop, name = _('Altimeter Pressure Decrease'), category = _('Systems')},


-- {down = iCommandPlaneAutopilot, name = _('Autopilot'), category = _('Autopilot')},
-- {down = iCommandPlaneAUTOnOff, name = _('Autothrust'), category = _('Autopilot')},
-- {down = iCommandPlaneSAUHBarometric, name = _('Autopilot - Barometric Altitude Hold \'H\''), category = _('Autopilot')},
-- --{down = iCommandPlaneAutopilotOverrideOn, up = iCommandPlaneAutopilotOverrideOff, name = _('Autopilot override (Su-25T)'), category = _('Autopilot')},
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
