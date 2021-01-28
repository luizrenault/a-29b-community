local res = external_profile("Config/Input/Aircrafts/base_joystick_binding.lua")

join(res.keyCommands,{

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


-- })
-- -- joystick axes 
-- join(res.axisCommands,{
-- {action = iCommandPlaneSelecterHorizontalAbs, name = _('TDC Slew Horizontal')},
-- {action = iCommandPlaneSelecterVerticalAbs	, name = _('TDC Slew Vertical')},
-- {action = iCommandPlaneRadarHorizontalAbs	, name = _('Radar Range')},
-- {action = iCommandPlaneRadarVerticalAbs		, name = _('Radar Vertical')},

-- {action = iCommandPlaneMFDZoomAbs 			, name = _('MFD Range')},
-- {action = iCommandPlaneBase_DistanceAbs 	, name = _('Target Base')},
})
return res
