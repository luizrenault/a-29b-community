dofile(LockOn_Options.script_path.."clickable_defs.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."devices.lua")
--dofile(LockOn_Options.script_path.."sounds.lua")
--dofile(LockOn_Options.common_script_path..'localizer.lua')

-- local gettext = require("i_18n")
-- _ = gettext.translate



elements = {}

-- Mirrors
elements["PNT_MIRROR_LEFT"]  = default_2_position_tumb("Toggle Mirrors", 0, 1625, nil)
elements["PNT_MIRROR_RIGHT"] = default_2_position_tumb("Toggle Mirrors", 0, 1625, nil)

elements["PNT_2"] = default_2_position_tumb("Hide Stick Toggle", devices.GEAR, Keys.ToggleStick, nil)

elements["PNT_129"] = default_2_position_tumb("Canopy", devices.CANOPY, Keys.Canopy, 129)
-- elements["PNT_129"].animated        = {true, true}
-- elements["PNT_129"].animation_speed = {2, 2} 




-- ELECTRICAL
elements["PNT_961"] = default_3_1_position_tumb("Battery (Reset/On/Off)",                       devices.ELECTRIC_SYSTEM, device_commands.ElecBatt,       961,nil,true,TOGGLECLICK_MID_FWD)
elements["PNT_962"] = default_2_position_tumb("Generator (On/Off-Reset)",                       devices.ELECTRIC_SYSTEM, device_commands.ElecGen,        962,TOGGLECLICK_MID_FWD)
elements["PNT_963"] = default_2_position_tumb("External Power (ON/Off)",                        devices.ELECTRIC_SYSTEM, device_commands.ElecExtPwr,     963,TOGGLECLICK_MID_FWD)
elements["PNT_964"] = default_2_position_tumb("Backup (Auto/Off)",                              devices.ELECTRIC_SYSTEM, device_commands.ElecBkp,        964,TOGGLECLICK_MID_FWD)
elements["PNT_965"] = default_3_position_tumb("Emergency Override (Emergency/Auto/Auto)",       devices.ELECTRIC_SYSTEM, device_commands.ElecEmer,       965,nil,true,TOGGLECLICK_MID_FWD)
elements["PNT_966"] = default_3_position_tumb("Aircraft Interconnect (On/Off/Off)",             devices.ELECTRIC_SYSTEM, device_commands.ElecAcftIntc,   966,nil,true,TOGGLECLICK_MID_FWD)


-- BASIC FLIGHT INSTRUMENT
elements["PNT_951"] = default_button("Bright",                                                  devices.EXTANIM,         device_commands.BFI_BRIGHT, 951)
elements["PNT_952"] = default_button("STD",                                                     devices.EXTANIM,         device_commands.AltPressureStd, 952)
elements["PNT_953"] = default_axis("BARO",                                                      devices.EXTANIM,         device_commands.AltPressureKnob, 953, 0.0, 0.2, false, true)

-- ICE PROTECTION
elements["PNT_991"] = default_2_position_tumb("Propeller (On/Off)",                             devices.ICEPROT, device_commands.IcePropeller,   991,TOGGLECLICK_MID_FWD)
elements["PNT_992"] = default_3_1_position_tumb("Windshield (Start/Set/Off)",                   devices.ICEPROT, device_commands.IceWindshield,  992,nil,true,TOGGLECLICK_MID_FWD)
elements["PNT_993"] = default_2_position_tumb("Pitot / Stat - Pri/Tat (On/Off)",                devices.ICEPROT, device_commands.IcePitotPri,    993,TOGGLECLICK_MID_FWD)
elements["PNT_994"] = default_2_position_tumb("Pitot / Stat - Sec (On/Off)",                    devices.ICEPROT, device_commands.IcePitotSec,    994,TOGGLECLICK_MID_FWD)

-- INTERNAL LIGHTS
elements["PNT_941"] = default_axis_limited("Panel (Off/Brightness)",                            devices.INTLIGHTS, device_commands.IntLightPnl,    941, 0.0,0.15)
elements["PNT_942"] = default_2_position_tumb("Storm (On/Off)",                                 devices.INTLIGHTS, device_commands.IntLightStorm,  942,TOGGLECLICK_MID_FWD)
elements["PNT_943"] = default_axis_limited("Console (Off/Brightness)",                          devices.INTLIGHTS, device_commands.IntLightCsl,    943, 0.0,0.15)
elements["PNT_944"] = springloaded_3_pos_tumb("Alarm Test (Panel/Fire)",                        devices.INTLIGHTS, device_commands.IntLightAlm,    944, true)
elements["PNT_945"] = default_axis_limited("Chart (Off/Brightness)",                            devices.INTLIGHTS, device_commands.IntLightChart,  945, 0.0,0.15)
elements["PNT_946"] = default_2_position_tumb("Nightvision (NVG/Norm)",                         devices.INTLIGHTS, device_commands.IntLightNvg,    946,TOGGLECLICK_MID_FWD)


-- EXTERNAL LIGHTS
elements["PNT_931"] = default_2_position_tumb("Search (On/Off)",                                devices.EXTLIGHTS, device_commands.ExtLightSearch, 931,TOGGLECLICK_MID_FWD)
elements["PNT_932"] = default_2_position_tumb("Beacon (On/Off)",                                devices.EXTLIGHTS, device_commands.ExtLightBeacon, 932,TOGGLECLICK_MID_FWD)
elements["PNT_933"] = default_2_position_tumb("Strobe (On/Off)",                                devices.EXTLIGHTS, device_commands.ExtLightStrobe, 933,TOGGLECLICK_MID_FWD)
elements["PNT_934"] = default_2_position_tumb("Formation Infrared (On/Off)",                    devices.EXTLIGHTS, device_commands.ExtLightInfrared, 934,TOGGLECLICK_MID_FWD)
elements["PNT_935"] = default_3_position_tumb("Formation Normal (Brt/Dim/Off)",                 devices.EXTLIGHTS, device_commands.ExtLightNormal, 935,nil,true,TOGGLECLICK_MID_FWD)
elements["PNT_936"] = default_2_position_tumb("Navigation (On/Off)",                            devices.EXTLIGHTS, device_commands.ExtLightNav,    936,TOGGLECLICK_MID_FWD)
elements["PNT_937"] = default_3_position_tumb("Taxi (On/Auto/Off)",                             devices.EXTLIGHTS, device_commands.ExtLightTaxi,   937,nil,true,TOGGLECLICK_MID_FWD)
elements["PNT_938"] = default_2_position_tumb("Landing (On/Off)",                               devices.EXTLIGHTS, device_commands.ExtLightLng,    938,TOGGLECLICK_MID_FWD)

-- ENGINE
elements["PNT_921"] = default_2_position_tumb("PMU (Auto/Manual)",                              devices.ENGINE,  device_commands.EnginePMU,      921,TOGGLECLICK_MID_FWD)
elements["PNT_922"] = default_3_position_tumb("Ignition (On/Auto/Off)",                         devices.ENGINE,  device_commands.EngineIgnition, 922,nil,true,TOGGLECLICK_MID_FWD)
elements["PNT_923"] = springloaded_3_pos_tumb("Start (Start/No Function/Interrupt",	    	    devices.ENGINE,	 device_commands.EngineStart,    923, true)
elements["PNT_924"] = default_2_position_tumb("Innertial Separation (Open/Close)",              devices.ENGINE,  device_commands.EngineInnSep,   924,TOGGLECLICK_MID_FWD)
-- FUEL / HYDRAULIC / BLEED SHUTOFF
elements["PNT_871"] = default_3_position_tumb("Fuel/Hydraulic/Bleed Shutoff (Open/Close/Close)",devices.ENGINE,  device_commands.FuelHydBleed,   871,nil,false,TOGGLECLICK_MID_FWD)

-- THROTTLE
elements["PNT_911"] = springloaded_3_pos_tumb("Throttle",                                       devices.ENGINE,  device_commands.ThrottleClick,  911, true)
elements["PNT_912"] = default_2_position_tumb("Flaps (Up/Down)",     		                    devices.FLAPS, 	 device_commands.flaps,          912,TOGGLECLICK_MID_FWD); elements["PNT_912"].arg_value = {1, -1}
-- elements["PNT_913"] = default_movable_axis("Friction",                                          devices.EXTANIM, device_commands.Friction,       913, 0.0,0.1, true, false)

-- TRIMS
elements["PNT_901"] = springloaded_3_pos_tumb("Aileron Emergency (Left/Stop/Right)",            devices.AVIONICS, device_commands.TrimEmerAil,    901,true,TOGGLECLICK_MID_FWD)
elements["PNT_902"] = springloaded_3_pos_tumb("Elevator Emergency (Down/Stop/Up)",              devices.AVIONICS, device_commands.TrimEmerElev,   902,true,TOGGLECLICK_MID_FWD)
elements["PNT_903"] = default_3_1_position_tumb("Auto Rudder (Engage/Power/Off)",               devices.AVIONICS, device_commands.AutoRudder,     903,nil,true,TOGGLECLICK_MID_FWD)

-- SEAT
elements["PNT_891"] = springloaded_3_pos_tumb("Seat (Up/Stop/Down)",                            devices.EXTANIM, device_commands.SeatAdj,        891,true,TOGGLECLICK_MID_FWD)

-- EMERGENCY SPEED BREAK
elements["PNT_881"] = default_3_position_tumb("Emergency Spead Break (Close/Off/Normal)",       devices.EXTANIM, device_commands.EmerSpdBrk, 881,nil,true,TOGGLECLICK_MID_FWD)


-- ANTI-G TEST
elements["PNT_861"] = default_button("Anti-G Suit Test",                                        devices.EXTANIM, device_commands.AntiG, 861)


-- AVIONICS
elements["PNT_841"] = default_2_position_tumb("MDP 1 (On/Off)",                                 devices.ELECTRIC_SYSTEM, device_commands.AviMdp1,        841,TOGGLECLICK_RIGHT_FWD)
elements["PNT_842"] = default_2_position_tumb("MDP 2 (On/Off)",                                 devices.ELECTRIC_SYSTEM, device_commands.AviMdp2,        842,TOGGLECLICK_RIGHT_FWD)
elements["PNT_843"] = default_2_position_tumb("Avionics Master (On/Off)",                       devices.ELECTRIC_SYSTEM, device_commands.AviMst,         843,TOGGLECLICK_RIGHT_FWD)
elements["PNT_844"] = default_2_position_tumb("SMS (On/Off)",                                   devices.ELECTRIC_SYSTEM, device_commands.AviSms,         844,TOGGLECLICK_RIGHT_FWD)
elements["PNT_845"] = default_2_position_tumb("V/UHF (Guard/Normal)",                           devices.ELECTRIC_SYSTEM, device_commands.AviVuhf,        845,TOGGLECLICK_RIGHT_FWD)

-- ENVIRONMENTAL CONTROL SYSTEM
elements["PNT_831"] = default_movable_axis("Temperature (Cold/Hot)",                            devices.ENVIRON, device_commands.EnvTemp,        831, 0.0,0.1, true, false)
elements["PNT_832"] = default_2_position_tumb("Air Conditioner (On/Off)",                       devices.ENVIRON, device_commands.EnvAC,          832,TOGGLECLICK_RIGHT_FWD)
elements["PNT_833"] = default_2_position_tumb("ECS (Auto/Manual)",                              devices.ENVIRON, device_commands.EnvECS,         833,TOGGLECLICK_RIGHT_FWD)
elements["PNT_834"] = default_2_position_tumb("Recirculating Fan (On/Off)",                     devices.ENVIRON, device_commands.EnvRecFan,      834,TOGGLECLICK_RIGHT_FWD)

-- LANDING GEAR
elements["PNT_821"] = default_2_position_tumb("Landing Gear (Up/Down)",                         devices.GEAR,    device_commands.LndGear,        821,TOGGLECLICK_LEFT_FWD)
elements["PNT_821"].arg_value = {1, -1}
elements["PNT_822"] = default_button("Beep Supress",                                            devices.GEAR,    device_commands.LndGearBeep,    822)
elements["PNT_823"] = default_button("Down Lock Override",                                      devices.GEAR,    device_commands.LndGearOvr,     823)
elements["PNT_851"] = default_2_position_tumb("Gear Emergency Down (Emergency Down/Normal)",    devices.GEAR,    device_commands.LndGearEmer, 	 851,TOGGLECLICK_LEFT_AFT)


-- FUEL
elements["PNT_801"] = multiposition_switch_limited("Fuel Main Pump (Auto/Off)",                 devices.FUEL, device_commands.FuelMain,         801, 2, 1.0, false, 0, KNOBCLICK_MID_FWD)
elements["PNT_802"] = multiposition_switch_limited("Fuel Aux Pump (LH/Auto/RH/Both)",           devices.FUEL, device_commands.FuelAux,          802, 4,0.25, false, KNOBCLICK_MID_FWD)
elements["PNT_803"] = default_3_position_tumb("Fuel Transfer (U-Wing/Ventral-Auto/Off)",        devices.FUEL, device_commands.FuelXfr,          803, nil,true,TOGGLECLICK_MID_FWD)

-- PARKING BRAKES
elements["PNT_791"] = default_3_position_tumb("Emergency/Parking Brakes",                       devices.BRAKES, device_commands.EmerParkBrake, 791, nil, true, TOGGLECLICK_MID_FWD)

-- WEAPONS
elements["PNT_781"] = default_3_position_tumb("Mass (Sim/Save/Live)",                           devices.WEAPON_SYSTEM, device_commands.Mass,   781,nil,true,KNOBCLICK_MID_FWD)
elements["PNT_782"] = default_3_position_tumb("Late Arm (On/Safe)",                             devices.WEAPON_SYSTEM, device_commands.LateArm,       782,nil,true,TOGGLECLICK_MID_FWD)
elements["PNT_811"] = default_button("Salvo",                                                   devices.WEAPON_SYSTEM, device_commands.Salvo,         811)

-- ELT
elements["PNT_741"] = default_3_position_tumb("ELT (On/Arm-Reset)",                             devices.EXTANIM, device_commands.EltOn,        741,nil,true,TOGGLECLICK_MID_FWD)
-- PIC NAV
elements["PNT_742"] = springloaded_3_pos_tumb("Manual Sync (CW/CCW)",                           devices.EXTANIM, device_commands.PicNavMan,     742,true,TOGGLECLICK_MID_FWD)
elements["PNT_743"] = default_3_position_tumb("Slave (Free/Slave/Fast Slave)",                  devices.EXTANIM, device_commands.PicNavSlave,   743,nil,true,TOGGLECLICK_MID_FWD)

-- AUDIO
elements["PNT_761"] = default_2_position_tumb("Audio Selector (Normal/Backup)",                 devices.EXTANIM, device_commands.AudioNormal,        761,TOGGLECLICK_MID_FWD); elements["PNT_761"].arg_value = {1, -1}
elements["PNT_762"] = default_movable_axis("COM 1 Audio",      		           					devices.EXTANIM, device_commands.AUDIO_COM1_VOL,     762)
elements["PNT_763"] = default_movable_axis("COM 2 Audio",      		           					devices.EXTANIM, device_commands.AUDIO_COM2_VOL,     763)
elements["PNT_764"] = default_movable_axis("COM 3 Audio",      		           					devices.EXTANIM, device_commands.AUDIO_COM3_VOL,     764)
elements["PNT_765"] = default_movable_axis("COM 4 Audio",      		           					devices.EXTANIM, device_commands.AUDIO_COM4_VOL,     765)
elements["PNT_766"] = default_movable_axis("ADF",		      		           					devices.EXTANIM, device_commands.AUDIO_ADF_VOL,      766)
elements["PNT_767"] = default_movable_axis("NAV", 		     		           					devices.EXTANIM, device_commands.AUDIO_NAV_VOL,      767)
elements["PNT_768"] = default_movable_axis("Missile",	      		           					devices.EXTANIM, device_commands.AUDIO_MSL_VOL,      768)
elements["PNT_769"] = default_movable_axis("MKR",		      		           					devices.EXTANIM, device_commands.AUDIO_MKR_VOL,      769)
elements["PNT_770"] = default_movable_axis("Volume",	      		           					devices.EXTANIM, device_commands.AUDIO_VOL,		     770)
elements["PNT_771"] = default_movable_axis("VOX",      		           							devices.EXTANIM, device_commands.AUDIO_VOX,     	 771)

-- ASI
elements["PNT_751"] = 
{
    class				= {class_type.BTN, class_type.LEV},
	hint				= ("Cage/Adjust (Cage/Up/Down)"),
	device				= devices.EXTANIM,
	action				= {device_commands.ASICage, device_commands.ASIAdjust},
	stop_action			= {device_commands.ASICage, 0},
	is_repeatable		= {},
	arg					= {756, 755},
	arg_value			= {1.0, 1.0},
	arg_lim				= {{0, 1}, {-1, 1}},
	relative			= {false, false},
	cycle				= false,
	gain				= {1.0, 0.02},
	use_release_message	= {true, false},
	use_OBB 			= true,
}

-- CMFD1
elements["PNT_501"] = default_button("CMFD #1 OSS 1",                                        devices.CMFD, device_commands.CMFD1OSS1,         501)
elements["PNT_502"] = default_button("CMFD #1 OSS 2",                                        devices.CMFD, device_commands.CMFD1OSS2,         502)
elements["PNT_503"] = default_button("CMFD #1 OSS 3",                                        devices.CMFD, device_commands.CMFD1OSS3,         503)
elements["PNT_504"] = default_button("CMFD #1 OSS 4",                                        devices.CMFD, device_commands.CMFD1OSS4,         504)
elements["PNT_505"] = default_button("CMFD #1 OSS 5",                                        devices.CMFD, device_commands.CMFD1OSS5,         505)
elements["PNT_506"] = default_button("CMFD #1 OSS 6",                                        devices.CMFD, device_commands.CMFD1OSS6,         506)
elements["PNT_507"] = default_button("CMFD #1 OSS 7",                                        devices.CMFD, device_commands.CMFD1OSS7,         507)
elements["PNT_508"] = default_button("CMFD #1 OSS 8",                                        devices.CMFD, device_commands.CMFD1OSS8,         508)
elements["PNT_509"] = default_button("CMFD #1 OSS 9",                                        devices.CMFD, device_commands.CMFD1OSS9,         509)
elements["PNT_510"] = default_button("CMFD #1 OSS 10",                                       devices.CMFD, device_commands.CMFD1OSS10,        510)
elements["PNT_511"] = default_button("CMFD #1 OSS 11",                                       devices.CMFD, device_commands.CMFD1OSS11,        511)
elements["PNT_512"] = default_button("CMFD #1 OSS 12",                                       devices.CMFD, device_commands.CMFD1OSS12,        512)
elements["PNT_513"] = default_button("CMFD #1 OSS 13",                                       devices.CMFD, device_commands.CMFD1OSS13,        513)
elements["PNT_514"] = default_button("CMFD #1 OSS 14",                                       devices.CMFD, device_commands.CMFD1OSS14,        514)
elements["PNT_515"] = default_button("CMFD #1 OSS 15",                                       devices.CMFD, device_commands.CMFD1OSS15,        515)
elements["PNT_516"] = default_button("CMFD #1 OSS 16",                                       devices.CMFD, device_commands.CMFD1OSS16,        516)
elements["PNT_517"] = default_button("CMFD #1 OSS 17",                                       devices.CMFD, device_commands.CMFD1OSS17,        517)
elements["PNT_518"] = default_button("CMFD #1 OSS 18",                                       devices.CMFD, device_commands.CMFD1OSS18,        518)
elements["PNT_519"] = default_button("CMFD #1 OSS 19",                                       devices.CMFD, device_commands.CMFD1OSS19,        519)
elements["PNT_520"] = default_button("CMFD #1 OSS 20",                                       devices.CMFD, device_commands.CMFD1OSS20,        520)
elements["PNT_521"] = default_button("CMFD #1 OSS 21",                                       devices.CMFD, device_commands.CMFD1OSS21,        521)
elements["PNT_522"] = default_button("CMFD #1 OSS 22",                                       devices.CMFD, device_commands.CMFD1OSS22,        522)
elements["PNT_523"] = default_button("CMFD #1 OSS 23",                                       devices.CMFD, device_commands.CMFD1OSS23,        523)
elements["PNT_524"] = default_button("CMFD #1 OSS 24",                                       devices.CMFD, device_commands.CMFD1OSS24,        524)
elements["PNT_525"] = default_button("CMFD #1 OSS 25",                                       devices.CMFD, device_commands.CMFD1OSS25,        525)
elements["PNT_526"] = default_button("CMFD #1 OSS 26",                                       devices.CMFD, device_commands.CMFD1OSS26,        526)
elements["PNT_527"] = default_button("CMFD #1 OSS 27",                                       devices.CMFD, device_commands.CMFD1OSS27,        527)
elements["PNT_528"] = default_button("CMFD #1 OSS 28",                                       devices.CMFD, device_commands.CMFD1OSS28,        528)
elements["PNT_529"] = default_2_position_tumb("CMFD #1 Power (On/Off)",                      devices.CMFD, device_commands.CMFD1ButtonOn,        529, KNOBCLICK_MID_FWD)
elements["PNT_530"] = springloaded_3_pos_tumb("CMFD #1 Gain",                                devices.CMFD, device_commands.CMFD1ButtonGain,      530, true, PUSHPRESS)
elements["PNT_531"] = springloaded_3_pos_tumb("CMFD #1 Symbology",                           devices.CMFD, device_commands.CMFD1ButtonSymb,      531, true, PUSHPRESS)
elements["PNT_532"] = springloaded_3_pos_tumb("CMFD #1 Bright",                              devices.CMFD, device_commands.CMFD1ButtonBright,    532, true, PUSHPRESS)

-- CMFD2
elements["PNT_551"] = default_button("CMFD #2 OSS 1",                                        devices.CMFD, device_commands.CMFD2OSS1,         551)
elements["PNT_552"] = default_button("CMFD #2 OSS 2",                                        devices.CMFD, device_commands.CMFD2OSS2,         552)
elements["PNT_553"] = default_button("CMFD #2 OSS 3",                                        devices.CMFD, device_commands.CMFD2OSS3,         553)
elements["PNT_554"] = default_button("CMFD #2 OSS 4",                                        devices.CMFD, device_commands.CMFD2OSS4,         554)
elements["PNT_555"] = default_button("CMFD #2 OSS 5",                                        devices.CMFD, device_commands.CMFD2OSS5,         555)
elements["PNT_556"] = default_button("CMFD #2 OSS 6",                                        devices.CMFD, device_commands.CMFD2OSS6,         556)
elements["PNT_557"] = default_button("CMFD #2 OSS 7",                                        devices.CMFD, device_commands.CMFD2OSS7,         557)
elements["PNT_558"] = default_button("CMFD #2 OSS 8",                                        devices.CMFD, device_commands.CMFD2OSS8,         558)
elements["PNT_559"] = default_button("CMFD #2 OSS 9",                                        devices.CMFD, device_commands.CMFD2OSS9,         559)
elements["PNT_560"] = default_button("CMFD #2 OSS 10",                                       devices.CMFD, device_commands.CMFD2OSS10,        560)
elements["PNT_561"] = default_button("CMFD #2 OSS 11",                                       devices.CMFD, device_commands.CMFD2OSS11,        561)
elements["PNT_562"] = default_button("CMFD #2 OSS 12",                                       devices.CMFD, device_commands.CMFD2OSS12,        562)
elements["PNT_563"] = default_button("CMFD #2 OSS 13",                                       devices.CMFD, device_commands.CMFD2OSS13,        563)
elements["PNT_564"] = default_button("CMFD #2 OSS 14",                                       devices.CMFD, device_commands.CMFD2OSS14,        564)
elements["PNT_565"] = default_button("CMFD #2 OSS 15",                                       devices.CMFD, device_commands.CMFD2OSS15,        565)
elements["PNT_566"] = default_button("CMFD #2 OSS 16",                                       devices.CMFD, device_commands.CMFD2OSS16,        566)
elements["PNT_567"] = default_button("CMFD #2 OSS 17",                                       devices.CMFD, device_commands.CMFD2OSS17,        567)
elements["PNT_568"] = default_button("CMFD #2 OSS 18",                                       devices.CMFD, device_commands.CMFD2OSS18,        568)
elements["PNT_569"] = default_button("CMFD #2 OSS 19",                                       devices.CMFD, device_commands.CMFD2OSS19,        569)
elements["PNT_570"] = default_button("CMFD #2 OSS 20",                                       devices.CMFD, device_commands.CMFD2OSS20,        570)
elements["PNT_571"] = default_button("CMFD #2 OSS 21",                                       devices.CMFD, device_commands.CMFD2OSS21,        571)
elements["PNT_572"] = default_button("CMFD #2 OSS 22",                                       devices.CMFD, device_commands.CMFD2OSS22,        572)
elements["PNT_573"] = default_button("CMFD #2 OSS 23",                                       devices.CMFD, device_commands.CMFD2OSS23,        573)
elements["PNT_574"] = default_button("CMFD #2 OSS 24",                                       devices.CMFD, device_commands.CMFD2OSS24,        574)
elements["PNT_575"] = default_button("CMFD #2 OSS 25",                                       devices.CMFD, device_commands.CMFD2OSS25,        575)
elements["PNT_576"] = default_button("CMFD #2 OSS 26",                                       devices.CMFD, device_commands.CMFD2OSS26,        576)
elements["PNT_577"] = default_button("CMFD #2 OSS 27",                                       devices.CMFD, device_commands.CMFD2OSS27,        577)
elements["PNT_578"] = default_button("CMFD #2 OSS 28",                                       devices.CMFD, device_commands.CMFD2OSS28,        578)
elements["PNT_579"] = default_2_position_tumb("CMFD #2 Power (On/Off)",                      devices.CMFD, device_commands.CMFD2ButtonOn,        579, KNOBCLICK_MID_FWD)
elements["PNT_580"] = springloaded_3_pos_tumb("CMFD #2 Gain",                                devices.CMFD, device_commands.CMFD2ButtonGain,      580, true, PUSHPRESS)
elements["PNT_581"] = springloaded_3_pos_tumb("CMFD #2 Symbology",                           devices.CMFD, device_commands.CMFD2ButtonSymb,      581, true, PUSHPRESS)
elements["PNT_582"] = springloaded_3_pos_tumb("CMFD #2 Bright",                              devices.CMFD, device_commands.CMFD2ButtonBright,    582, true, PUSHPRESS)

-- CLOCK
elements["PNT_491"] = default_button("Clock Selection",                                     devices.EXTANIM, device_commands.ClockSel,           491)
elements["PNT_492"] = default_button("Clock Control",                                       devices.EXTANIM, device_commands.ClockCtrl,          492)

-- UFCP
elements["PNT_451"] = default_button("COM 1",                                           	devices.UFCP, device_commands.UFCP_COM1,          	451)
elements["PNT_452"] = default_button("COM 2",                                           	devices.UFCP, device_commands.UFCP_COM2,          	452)
elements["PNT_453"] = default_button("NAV AIDS",                                           	devices.UFCP, device_commands.UFCP_NAVAIDS,     	453)
elements["PNT_454"] = default_button("A/G",                                           		devices.UFCP, device_commands.UFCP_A_G,          	454)
elements["PNT_455"] = default_button("NAV",                                           		devices.UFCP, device_commands.UFCP_NAV,          	455)
elements["PNT_456"] = default_button("A/A",                                           		devices.UFCP, device_commands.UFCP_A_A,          	456)
elements["PNT_457"] = default_button("BARO/RALT",                                         	devices.UFCP, device_commands.UFCP_BARO_RALT,       457)
elements["PNT_458"] = default_button("IDNT",                                           		devices.UFCP, device_commands.UFCP_IDNT,          	458)
elements["PNT_459"] = default_button("1",                                           		devices.UFCP, device_commands.UFCP_1,          		459)
elements["PNT_460"] = default_button("2",                                           		devices.UFCP, device_commands.UFCP_2,          		460)
elements["PNT_461"] = default_button("3",                                     				devices.UFCP, device_commands.UFCP_3,          		461)
elements["PNT_462"] = default_button("4",                                     				devices.UFCP, device_commands.UFCP_4,          		462)
elements["PNT_463"] = default_button("5",                                     				devices.UFCP, device_commands.UFCP_5,          		463)
elements["PNT_464"] = default_button("6",                                     				devices.UFCP, device_commands.UFCP_6,          		464)
elements["PNT_465"] = default_button("7",                                     				devices.UFCP, device_commands.UFCP_7,          		465)
elements["PNT_466"] = default_button("8",                                     				devices.UFCP, device_commands.UFCP_8,          		466)
elements["PNT_467"] = default_button("9",                                     				devices.UFCP, device_commands.UFCP_9,          		467)
elements["PNT_468"] = default_button("0",                                     				devices.UFCP, device_commands.UFCP_0,          		468)
elements["PNT_469"] = default_button("Clear",                                           	devices.UFCP, device_commands.UFCP_CLR,          	469)
elements["PNT_470"] = default_button("Enter",                                           	devices.UFCP, device_commands.UFCP_ENTR,          	470)
elements["PNT_471"] = default_button("CZ",                                           		devices.UFCP, device_commands.UFCP_CZ,          	471)
elements["PNT_472"] = default_button("Airspeed",                                           	devices.UFCP, device_commands.UFCP_AIRSPD,          472)
elements["PNT_473"] = default_button("Warning Reset",                                       devices.UFCP, device_commands.UFCP_WARNRST,         473)
elements["PNT_474"] = default_button("Up",                                           		devices.UFCP, device_commands.UFCP_UP,          	474)
elements["PNT_475"] = default_button("Down",                                           		devices.UFCP, device_commands.UFCP_DOWN,          	475)

elements["PNT_476"] = default_3_position_tumb("Day/Night/Auto",                        		devices.UFCP, device_commands.UFCP_DAY_NIGHT,     	476, false, true, TOGGLECLICK_MID_FWD)
elements["PNT_477"] = default_2_position_tumb("Radar Altimeter Transmit / Off",       		devices.UFCP, device_commands.UFCP_RALT,          	477, TOGGLECLICK_MID_FWD)
elements["PNT_478"] = default_3_position_tumb("DVR Rec/Standby/Off",                		devices.UFCP, device_commands.UFCP_DVR,          	478, false, true, TOGGLECLICK_MID_FWD)
elements["PNT_479"] = multiposition_switch_limited("EGI Nav/Align/Storage Heading/Off/Test",devices.UFCP, device_commands.UFCP_EGI,          	479,5,0.25, false, nil, KNOBCLICK_MID_FWD)
elements["PNT_480"] = default_axis_limited("UFC BRT/OFF",									devices.UFCP , device_commands.UFCP_UFC,          	480, 0, 0.15)
elements["PNT_481"] = default_2_position_tumb("HUD Test",									devices.UFCP, device_commands.UFCP_HUD_TEST,      	481, TOGGLECLICK_MID_FWD)
elements["PNT_482"] = default_2_position_tumb("SBS On",										devices.UFCP, device_commands.UFCP_SBS_ON,      	482, TOGGLECLICK_MID_FWD)
elements["PNT_483"] = default_axis_limited("HUD Britghness",								devices.HUD, device_commands.UFCP_HUD_BRIGHT,     	483, 1, -0.15)
elements["PNT_484"] = default_axis_limited("SBS Adjust",	   								devices.UFCP, device_commands.UFCP_SBS_ADJUST,   	484, 1, -0.15)

elements["PNT_485"] = default_button("Right",												devices.UFCP, device_commands.UFCP_JOY_RIGHT,   	485, nil, nil, TOGGLECLICK_MID_FWD)
elements["PNT_486"] = default_button("Left",												devices.UFCP, device_commands.UFCP_JOY_LEFT,  	 	486, nil, nil, TOGGLECLICK_MID_FWD)
elements["PNT_487"] = default_button("Up",													devices.UFCP, device_commands.UFCP_JOY_UP,   		487, nil, nil, TOGGLECLICK_MID_FWD)
elements["PNT_488"] = default_button("Down",												devices.UFCP, device_commands.UFCP_JOY_DOWN,  	 	488, nil, nil, TOGGLECLICK_MID_FWD)

elements["PNT_441"] = default_button("Warning",												devices.ALARM, device_commands.WARNING_PRESS,  		441, nil, nil, TOGGLECLICK_MID_FWD)
elements["PNT_442"] = default_button("Caution",												devices.ALARM, device_commands.CAUTION_PRESS,  	 	442, nil, nil, TOGGLECLICK_MID_FWD)

elements["PNT_431"] = default_button("AP Roll/Pitch",										devices.AUTOPILOT, device_commands.AP_RP,  				431)
-- elements["PNT_432"] = default_button("AP Heading",											devices.AUTOPILOT, device_commands.AP_HDG,  	 		432)
elements["PNT_433"] = default_button("AP Altitude",											devices.AUTOPILOT, device_commands.AP_ALT,  	 		433)
-- elements["PNT_434"] = default_button("AP Test",												devices.AUTOPILOT, device_commands.AP_TEST,  	 		434)
-- elements["PNT_435"] = default_button("AP Nav",												devices.AUTOPILOT, device_commands.AP_NAV,  	 		435)
-- elements["PNT_436"] = default_button("AP Approach",											devices.AUTOPILOT, device_commands.AP_APR,  	 		436)
-- elements["PNT_437"] = default_button("AP GS",												devices.AUTOPILOT, device_commands.AP_GS,  	 			437)
elements["PNT_438"] = default_button("AP",													devices.AUTOPILOT, device_commands.AP_ON,  		 		438)




-- --[[  Remove tail hook level from clickables, until we can solve the tail hook problem in DCS replays. For now it moves to a gauge in mainpanel_init.lua
-- elements["PNT_10"] = default_2_position_tumb("Tail Hook Handle", devices.GEAR, device_commands.Hook, 10)
-- elements["PNT_10"].animated        = {true, true}
-- elements["PNT_10"].animation_speed = {2, 2} -- multiply these numbers by the base 1.0 second animation speed to get final speed.  2 means animates in 0.5 seconds.
-- --]]
-- elements["PNT_83"] = multiposition_switch_limited("Master Lighting ON/OFF/Momentary", devices.EXT_LIGHTS, device_commands.extlight_master, 83, 3, 1, false, -1.0, TOGGLECLICK_LEFT_MID)

-- --Spoilers
-- elements["PNT_84"] = default_2_position_tumb("Spoiler Arm Switch",devices.SPOILERS, device_commands.spoiler_arm,84,TOGGLECLICK_LEFT_MID)
-- elements["PNT_133"] = default_2_position_tumb("JATO ARM-OFF Switch",devices.AVIONICS, device_commands.JATO_arm,133,TOGGLECLICK_LEFT_MID)
-- elements["PNT_134"] = default_2_position_tumb("JATO JETTISON-SAFE Switch",devices.AVIONICS, device_commands.JATO_jettison,134,TOGGLECLICK_LEFT_MID)
-- --Speedbrake
-- elements["PNT_85"] = default_2_position_tumb("Speedbrake switch",devices.AIRBRAKES, device_commands.speedbrake,85,TOGGLECLICK_LEFT_MID)
-- elements["PNT_128"] = default_3_position_tumb("Speedbrake emergency",devices.AIRBRAKES, device_commands.speedbrake_emer,128)

-- -- canopy lever
-- elements["PNT_129"] = default_2_position_tumb("Canopy", devices.CANOPY, Keys.Canopy, 0)

-- elements["PNT_132"] = multiposition_switch_limited("Flaps Lever", devices.FLAPS, device_commands.flaps, 132, 3, 1, false, -1.0)

-- -- THROTTLE PANEL
-- elements["PNT_80"] 	= default_3_position_tumb("Throttle", devices.ENGINE, device_commands.throttle_click,0, false, true)
-- elements["PNT_82"] 	= default_axis_limited("Rudder trim", devices.TRIM, device_commands.rudder_trim, 82, 0.0, 0.3, false, false, {-1,1})

-- --ENGINE CONTROL PANEL
-- elements["PNT_100"] = default_2_position_tumb("Starter switch",devices.ENGINE, device_commands.push_starter_switch,100)
-- elements["PNT_100"].sound = {{PUSHPRESS,PUSHRELEASE}}
-- elements["PNT_101"] = default_3_position_tumb("Drop Tanks Pressurization and Flight Refuel switch", devices.ENGINE, device_commands.ENGINE_drop_tanks_sw, 101, false, true, TOGGLECLICK_LEFT_MID) -- NO COMMAND
-- elements["PNT_103"] = default_3_position_tumb("Emer Transfer and Wing Fuel Dump switch", devices.ENGINE, device_commands.ENGINE_wing_fuel_sw, 103, false, true, TOGGLECLICK_LEFT_MID) -- NO COMMAND
-- elements["PNT_104"] = default_2_position_tumb("Fuel control switch",devices.ENGINE, device_commands.ENGINE_fuel_control_sw,104, TOGGLECLICK_LEFT_MID)
-- elements["PNT_130"] = default_2_position_tumb("Manual Fuel Shutoff Lever",devices.ENGINE, device_commands.ENGINE_manual_fuel_shutoff, 130, nil, 3)
-- -- elements["PNT_130"].updatable = false
-- -- elements["PNT_130"].use_OBB = false
-- elements["PNT_131"] = default_2_position_tumb("Manual Fuel Shutoff Catch",devices.ENGINE, device_commands.ENGINE_manual_fuel_shutoff_catch, 131, nil, 2) -- NO COMMAND
-- --elements["PNT_201"] = default_3_position_tumb("Throttle cutoff",devices.ENGINE, device_commands.throttle,201,false)

-- -- OXYGEN and ANTI-G PANEL
-- elements["PNT_125"] = default_2_position_tumb("Oxygen Switch",devices.AVIONICS, device_commands.oxygen_switch, 125, TOGGLECLICK_LEFT_MID)

-- -- RADAR CONTROL PANEL #6
-- elements["PNT_120"] = multiposition_switch_limited( "Radar Mode", devices.RADAR, device_commands.radar_mode, 120, 5, 0.10, nil, nil, KNOBCLICK_LEFT_MID )
-- elements["PNT_120"].animated        = {true, true}
-- elements["PNT_120"].animation_speed = {4, 4}  -- multiply these numbers by the base 1.0 second animation speed to get final speed.  4 means animates in 0.25 seconds.
-- elements["PNT_121"] = default_2_position_tumb( "Radar AoA Compensation", devices.RADAR, device_commands.radar_aoacomp, 121, TOGGLECLICK_LEFT_MID)
-- elements["PNT_122"] = default_axis_limited( "Radar Antenna Elevation", devices.RADAR, device_commands.radar_angle, 122, 0.4, 0.1, false, false, {0,1} )
-- elements["PNT_123"] = default_axis_limited( "Radar Warning Volume", devices.RADAR, device_commands.radar_volume, 123, 0.0, 0.3, false, false, {-1,1} )

-- -- APPROACH POWER COMPENSATOR PANEL #17A
-- elements["PNT_135"] = multiposition_switch_limited("APC Enable/Stby/Off", devices.AFCS, device_commands.apc_engagestbyoff, 135, 3, 1.0, false, -1.0, TOGGLECLICK_LEFT_FWD)
-- elements["PNT_136"] = multiposition_switch_limited("APC Cold/Std/Hot", devices.AFCS, device_commands.apc_hotstdcold, 136, 3, 1.0, false, -1.0, TOGGLECLICK_LEFT_FWD)

-- elements["PNT_139"] = default_button("Reset Accelerometer", devices.AVIONICS, device_commands.accel_reset, 139, nil, nil, TOGGLECLICK_MID_FWD)

-- elements["PNT_146"] = default_button("Stopwatch", devices.CLOCK, device_commands.clock_stopwatch, 146)

-- -- ANGLE OF ANGLE INDEXER
-- elements["PNT_853"] = default_axis_limited( "AOA Indexer Dimming Wheel", devices.AVIONICS, device_commands.AOA_dimming_wheel_AXIS, 853, 1.0, 0.2, false, false, {-1,1} )

-- -- AFCS PANEL #8  (Aircraft Flight Control System)
-- elements["PNT_160"] = default_2_position_tumb("AFCS standby",devices.AFCS, device_commands.afcs_standby,160, TOGGLECLICK_LEFT_AFT)
-- elements["PNT_161"] = default_2_position_tumb("AFCS engage",devices.AFCS, device_commands.afcs_engage,161, TOGGLECLICK_LEFT_AFT)
-- elements["PNT_162"] = default_2_position_tumb("AFCS preselect heading",devices.AFCS, device_commands.afcs_hdg_sel,162, TOGGLECLICK_LEFT_AFT)
-- elements["PNT_163"] = default_2_position_tumb("AFCS altitude hold",devices.AFCS, device_commands.afcs_alt,163, TOGGLECLICK_LEFT_AFT)
-- elements["PNT_164"] = default_axis_limited( "AFCS heading selector", devices.AFCS, device_commands.afcs_hdg_set, 164, 0.0, 0.3, false, true, {0,1} )
-- elements["PNT_165"] = default_2_position_tumb("AFCS stability aug (unimplemented)",devices.AFCS, device_commands.afcs_stab_aug,165, TOGGLECLICK_LEFT_AFT)
-- elements["PNT_166"] = default_2_position_tumb("AFCS aileron trim (unimplemented)",devices.AFCS, device_commands.afcs_ail_trim,166, TOGGLECLICK_LEFT_AFT)

-- -- RADAR SCOPE #20
-- elements["PNT_400"] = default_axis_limited("Radar Storage", devices.RADAR, device_commands.radar_storage, 400, 0.0, 0.3, false, false, {-1,1})
-- elements["PNT_401"] = default_axis_limited("Radar Brilliance", devices.RADAR, device_commands.radar_brilliance, 401, 0.0, 0.3, false, false, {-1,1})
-- elements["PNT_402"] = default_axis_limited("Radar Detail", devices.RADAR, device_commands.radar_detail, 402, 0.0, 0.3, false, false, {-1,1})
-- elements["PNT_403"] = default_axis_limited("Radar Gain", devices.RADAR, device_commands.radar_gain, 403, 0.0, 0.3, false, false, {-1,1})
-- elements["PNT_404"] = default_axis_limited("Radar Reticle", devices.RADAR, device_commands.radar_reticle, 404, 0.0, 0.3, false, false, {-1,1})
-- elements["PNT_405"] = default_2_position_tumb("Radar Filter Plate", devices.RADAR, device_commands.radar_filter, 405)
-- elements["PNT_405"].animated        = {true, true}
-- elements["PNT_405"].animation_speed = {4, 4}  -- animation duration = 1/value.  4 means animates in .25 seconds.

-- elements["PNT_390"] = multiposition_switch_limited("GunPods: Charge/Off/Clear", devices.WEAPON_SYSTEM, device_commands.gunpod_chargeclear, 390, 3, 1, false, -1, TOGGLECLICK_LEFT_FWD)
-- elements["PNT_391"] = default_2_position_tumb("GunPods: Left Enable", devices.WEAPON_SYSTEM, device_commands.gunpod_l, 391, TOGGLECLICK_LEFT_FWD)
-- elements["PNT_392"] = default_2_position_tumb("GunPods: Center Enable", devices.WEAPON_SYSTEM, device_commands.gunpod_c, 392, TOGGLECLICK_LEFT_FWD)
-- elements["PNT_393"] = default_2_position_tumb("GunPods: Right Enable", devices.WEAPON_SYSTEM, device_commands.gunpod_r, 393, TOGGLECLICK_LEFT_FWD)


-- elements["PNT_522"] = multiposition_switch_limited("Countermeasures: Bank Select", devices.COUNTERMEASURES, device_commands.cm_bank, 522, 3, 1, true, -1, TOGGLECLICK_LEFT_FWD)
-- elements["PNT_523"] = default_button("Countermeasures: Auto Pushbutton", devices.COUNTERMEASURES, device_commands.cm_auto, 523, 1, nil, TOGGLECLICK_LEFT_FWD)
-- elements["PNT_524"] = default_axis("Countermeasures: Bank 1 Adjust", devices.COUNTERMEASURES, device_commands.cm_adj1, 524, 0.0, 1, false, true)
-- elements["PNT_525"] = default_axis("Countermeasures: Bank 2 Adjust", devices.COUNTERMEASURES, device_commands.cm_adj2, 525, 0.0, 1, false, true)
-- elements["PNT_530"] = default_2_position_tumb("Countermeasures: Power Toggle", devices.COUNTERMEASURES, device_commands.cm_pwr, 530, TOGGLECLICK_LEFT_FWD)

-- -- RADAR ALTIMETER #30
-- -- combined 2 position switch and rotatable knob. The switch turns the radar altimeter
-- -- on and off, and the knob sets the indexer
-- -- NOTE: There is supposed to be a 'push-to-test' function too, but currently
-- -- unknown how to implement this together with the 2position toggle switch.. if the first member of class is BTN,
-- -- then you get a push button, but not a 2pos switch anymore.. and if you amke the first entry in arg_lim {-1,1} then
-- -- you get a 3position switch, which is also undesirable
-- -- The master press-to-test switch on the misc switches panel also tests the radar altimeter, so perhaps good
-- -- enough for this switch/knob here to only represent on/off and not test mode
-- elements["PNT_602"] = default_button_axis("Radar altitude warning",devices.RADARWARN, device_commands.radar_alt_switch, device_commands.radar_alt_indexer,603,602)
-- elements["PNT_602"].class = {class_type.TUMB, class_type.LEV}
-- elements["PNT_602"].relative = {false,true}
-- elements["PNT_602"].arg_lim = {{-1, 0}, {0, 1}}
-- elements["PNT_602"].stop_action = nil

-- -- STANDBY ATTITUDE INDICATOR #33
-- elements["PNT_662"] = default_button_axis("Standby attitude horizon",devices.AVIONICS, device_commands.stby_att_index_button, device_commands.stby_att_index_knob,663,662)
-- elements["PNT_662"].relative = {false,true}
-- elements["PNT_662"].updatable = nil
-- elements["PNT_662"].animated = nil
-- elements["PNT_662"].animation_speed = nil
-- elements["PNT_662"].arg_lim = {{0, 1}, {0, 1}}

-- --ARMAMENT PANEL #35
-- --elements["PNT_700"] = default_3_position_tumb("Emergency selector switch",devices.WEAPON_SYSTEM, device_commands.arm_emer_sel,700)
-- elements["PNT_700"] = multiposition_switch_limited("Emergency release selector",devices.WEAPON_SYSTEM, device_commands.arm_emer_sel,700,7,0.1,false,nil,KNOBCLICK_MID_FWD)
-- --elements["PNT_700"].animated        = {true, true}
-- --elements["PNT_700"].animation_speed = {2, 2}
-- elements["PNT_701"] = default_2_position_tumb("Guns switch",devices.WEAPON_SYSTEM, device_commands.arm_gun,701,TOGGLECLICK_MID_FWD)
-- elements["PNT_702"] = default_3_position_tumb("Bomb arm switch",devices.WEAPON_SYSTEM, device_commands.arm_bomb,702,nil,true,TOGGLECLICK_MID_FWD)
-- elements["PNT_703"] = default_2_position_tumb("Station 1 select",devices.WEAPON_SYSTEM, device_commands.arm_station1,703,TOGGLECLICK_MID_FWD)
-- elements["PNT_704"] = default_2_position_tumb("Station 2 select",devices.WEAPON_SYSTEM, device_commands.arm_station2,704,TOGGLECLICK_MID_FWD)
-- elements["PNT_705"] = default_2_position_tumb("Station 3 select",devices.WEAPON_SYSTEM, device_commands.arm_station3,705,TOGGLECLICK_MID_FWD)
-- elements["PNT_706"] = default_2_position_tumb("Station 4 select",devices.WEAPON_SYSTEM, device_commands.arm_station4,706,TOGGLECLICK_MID_FWD)
-- elements["PNT_707"] = default_2_position_tumb("Station 5 select",devices.WEAPON_SYSTEM, device_commands.arm_station5,707,TOGGLECLICK_MID_FWD)
-- elements["PNT_708"] = multiposition_switch_limited("Function selector",devices.WEAPON_SYSTEM, device_commands.arm_func_selector,708,6,0.1,false,nil,KNOBCLICK_MID_FWD, 2)

-- --elements["PNT_708"].animated        = {true, true}
-- --elements["PNT_708"].animation_speed = {2, 2}
-- elements["PNT_709"] = default_2_position_tumb("Master armament",devices.ELECTRIC_SYSTEM, device_commands.arm_master,709,TOGGLECLICK_MID_FWD)
-- elements["PNT_721"] = default_2_position_tumb("Radar Plan/Profile",devices.RADAR, device_commands.radar_planprofile,721,TOGGLECLICK_MID_FWD)
-- elements["PNT_722"] = default_2_position_tumb("Radar Long/Short Range",devices.RADAR, device_commands.radar_range,722,TOGGLECLICK_MID_FWD)
-- elements["PNT_724"] = multiposition_switch_limited("BDHI mode",devices.NAV,device_commands.bdhi_mode,724,3,1.0,false,-1.0,TOGGLECLICK_MID_FWD)    -- values = -1,0,1

-- -- AIRCRAFT WEAPONS RELEASE SYSTEM PANEL #37
-- elements["PNT_740"] = multiposition_switch_limited("AWRS quantity selector",devices.WEAPON_SYSTEM, device_commands.AWRS_quantity,740,12,0.05,false,nil,KNOBCLICK_MID_FWD, 1)
-- elements["PNT_742"] = default_axis_limited("AWRS drop interval",devices.WEAPON_SYSTEM, device_commands.AWRS_drop_interval,742,0,0.05,false,false, {0, 0.9})
-- -- elements["PNT_742"].arg_lim = {0,0.9}

-- elements["PNT_743"] = default_2_position_tumb("AWRS multiplier",devices.WEAPON_SYSTEM, device_commands.AWRS_multiplier,743,TOGGLECLICK_MID_FWD)
-- elements["PNT_744"] = multiposition_switch_limited("AWRS mode",devices.WEAPON_SYSTEM, device_commands.AWRS_stepripple,744,6,0.1,false,nil,KNOBCLICK_MID_FWD, 2)
-- --elements["PNT_744"].animated        = {true, true}
-- --elements["PNT_744"].animation_speed = {4, 4}  -- multiply these numbers by the base 1.0 second animation speed to get final speed.  4 means animates in 0.25 seconds.

-- -- MISC SWITCHES PANEL #36
-- elements["PNT_720"] = default_button("Show EXT Fuel", devices.AVIONICS, device_commands.FuelGaugeExtButton, 720)
-- elements["PNT_723"] = default_button("Master test", devices.AVIONICS, device_commands.master_test, 723)
-- elements["PNT_725"] = multiposition_switch_limited( "Shrike Selector Knob", devices.WEAPON_SYSTEM, device_commands.shrike_selector, 725, 5, 0.1, false, nil, KNOBCLICK_MID_FWD, 2)
-- elements["PNT_726"] = default_axis_limited( "Sidewinder Volume Knob", devices.WEAPON_SYSTEM, device_commands.shrike_sidewinder_volume, 726, 0, 0.1, false, false, {-1.0,1.0} )


-- -- ALTIMETER PANEL #41
-- elements["PNT_827"] = default_axis("Altimeter Setting", devices.AVIONICS, device_commands.AltPressureKnob, 827, 0, 0.05, false, true)

-- -- IAS Gauge
-- elements["PNT_884"] = default_button_axis("IAS Index",devices.AVIONICS, device_commands.ias_index_button, device_commands.ias_index_knob,885,884)
-- elements["PNT_884"].relative = {false,true}
-- elements["PNT_884"].gain = {1.0, 0.2}

-- -- GUNSIGHT
-- elements["PNT_895"] = default_axis("Gunsight Light Control",devices.GUNSIGHT, device_commands.GunsightBrightness,895,0,0.05,false,false)
-- elements["PNT_891"] = default_2_position_tumb("Gunsight Day/Night Switch",devices.GUNSIGHT, device_commands.GunsightDayNight,891,TOGGLECLICK_MID_FWD)
-- elements["PNT_892"] = default_movable_axis("Gunsight Elevation Control", devices.GUNSIGHT, device_commands.GunsightKnob, 892, 1.0, 0.05, false, false)

-- -- ARN-52V TACAN
-- elements["PNT_900"] = multiposition_switch_limited("TACAN Mode", devices.NAV, device_commands.tacan_mode, 900, 4, 0.1, false, nil, KNOBCLICK_RIGHT_MID)
-- elements["PNT_900"].animated        = {true, true}
-- elements["PNT_900"].animation_speed = {4, 4}  -- multiply these numbers by the base 1.0 second animation speed to get final speed.  4 means animates in 0.25 seconds.
-- elements["PNT_901"] = multiposition_switch_limited("TACAN Channel Major", devices.NAV, device_commands.tacan_ch_major, 901, 13, 0.05, false, nil, KNOBCLICK_RIGHT_MID)
-- elements["PNT_902"] = multiposition_switch_limited("TACAN Channel Minor", devices.NAV, device_commands.tacan_ch_minor, 902, 10, 0.1, false,nil, KNOBCLICK_RIGHT_MID)
-- --elements["PNT_902"] = default_button_tumb("TACAN Channel Minor", devices.NAV, device_commands.tacan_ch_minor_dec, device_commands.tacan_ch_minor_inc, 902)
-- elements["PNT_903"] = default_axis_limited("TACAN Volume", devices.NAV, device_commands.tacan_volume, 903, 0.0, 0.3, false, false, {-1,1} )

-- -- DOPPLER NAVIGATION COMPUTER #50 (ASN-41 / APN-153)
-- elements["PNT_170"] = multiposition_switch_limited("APN-153 Doppler Radar Mode",devices.NAV, device_commands.doppler_select,170,5,0.1,false,nil, KNOBCLICK_RIGHT_FWD)
-- elements["PNT_170"].animated        = {true, true}
-- elements["PNT_170"].animation_speed = {4, 4}  -- multiply these numbers by the base 1.0 second animation speed to get final speed.  4 means animates in 0.25 seconds.
-- elements["PNT_247"] = default_button("APN-153 Memory Light Test", devices.NAV, device_commands.doppler_memory_test, 247)

-- elements["PNT_176"] = multiposition_switch_limited("ASN-41 Function Selector Switch",devices.NAV, device_commands.nav_select,176,5,0.1,false,nil, KNOBCLICK_RIGHT_FWD)
-- elements["PNT_176"].animated        = {true, true}
-- elements["PNT_176"].animation_speed = {4, 4}  -- multiply these numbers by the base 1.0 second animation speed to get final speed.  4 means animates in 0.25 seconds.
-- elements["PNT_177"] = default_button_axis("ASN-41 Present Position - Latitude Knob", devices.NAV, device_commands.ppos_lat_push, device_commands.ppos_lat, 236, 177, 1, 1)
-- elements["PNT_177"].relative[2] = true
-- elements["PNT_177"].arg_value[2] = 1
-- elements["PNT_177"].animated = {true, false}
-- elements["PNT_177"].animation_speed = {16.0, 0}
-- elements["PNT_177"].sound = {{KNOBCLICK_RIGHT_FWD}, {KNOBCLICK_RIGHT_MID}}
-- elements["PNT_183"] = default_button_axis("ASN-41 Present Position - Longitude Knob", devices.NAV, device_commands.ppos_lon_push, device_commands.ppos_lon, 237, 183, 1, 1)
-- elements["PNT_183"].relative[2] = true
-- elements["PNT_183"].arg_value[2] = 1
-- elements["PNT_183"].animated = {true, false}
-- elements["PNT_183"].animation_speed = {16.0, 0}
-- elements["PNT_183"].sound = {{KNOBCLICK_RIGHT_FWD}, {KNOBCLICK_RIGHT_MID}}
-- elements["PNT_190"] = default_button_axis("ASN-41 Destination - Latitude Knob", devices.NAV, device_commands.dest_lat_push, device_commands.dest_lat, 238, 190, 1, 1)
-- elements["PNT_190"].relative[2] = true
-- elements["PNT_190"].arg_value[2] = 1
-- elements["PNT_190"].animated = {true, false}
-- elements["PNT_190"].animation_speed = {16.0, 0}
-- elements["PNT_190"].sound = {{KNOBCLICK_RIGHT_FWD}, {KNOBCLICK_RIGHT_MID}}
-- elements["PNT_196"] = default_button_axis("ASN-41 Destination - Longitude Knob", devices.NAV, device_commands.dest_lon_push, device_commands.dest_lon, 239, 196, 1, 1)
-- elements["PNT_196"].relative[2] = true
-- elements["PNT_196"].arg_value[2] = 1
-- elements["PNT_196"].animated = {true, false}
-- elements["PNT_196"].animation_speed = {16.0, 0}
-- elements["PNT_196"].sound = {{KNOBCLICK_RIGHT_FWD}, {KNOBCLICK_RIGHT_MID}}

-- elements["PNT_203"] = default_button_axis("ASN-41 Magnetic Variation Knob", devices.NAV, device_commands.asn41_magvar_push, device_commands.asn41_magvar, 240, 203, 1, 1)
-- elements["PNT_203"].relative[2] = true
-- elements["PNT_203"].arg_value[2] = 1
-- elements["PNT_203"].animated = {true, false}
-- elements["PNT_203"].animation_speed = {16.0, 0}
-- elements["PNT_203"].sound = {{KNOBCLICK_RIGHT_FWD}, {KNOBCLICK_RIGHT_MID}}
-- elements["PNT_209"] = default_button_axis("ASN-41 Wind Speed Knob", devices.NAV, device_commands.asn41_windspeed_push, device_commands.asn41_windspeed, 241, 209, 1, 1)
-- elements["PNT_209"].relative[2] = true
-- elements["PNT_209"].arg_value[2] = 1
-- elements["PNT_209"].animated = {true, false}
-- elements["PNT_209"].animation_speed = {16.0, 0}
-- elements["PNT_209"].sound = {{KNOBCLICK_RIGHT_FWD}, {KNOBCLICK_RIGHT_MID}}
-- elements["PNT_213"] = default_button_axis("ASN-41 Wind Direction Knob", devices.NAV, device_commands.asn41_winddir_push, device_commands.asn41_winddir, 242, 213, 1, 1)
-- elements["PNT_213"].relative[2] = true
-- elements["PNT_213"].arg_value[2] = 1
-- elements["PNT_213"].animated = {true, false}
-- elements["PNT_213"].animation_speed = {16.0, 0}
-- elements["PNT_213"].sound = {{KNOBCLICK_RIGHT_FWD}, {KNOBCLICK_RIGHT_MID}}

-- -- LIGHTS SWITCHES PANEL #47
-- -- see also PNT_83 on the throttle, for master external lighting switch
-- elements["PNT_217"] = multiposition_switch_limited("Probe Light", devices.EXT_LIGHTS, device_commands.extlight_probe, 217, 3, 1, true, -1.0, TOGGLECLICK_RIGHT_MID)
-- elements["PNT_218"] = default_2_position_tumb("Taxi Light", devices.EXT_LIGHTS, device_commands.extlight_taxi, 218, TOGGLECLICK_RIGHT_MID)
-- elements["PNT_219"] = default_2_position_tumb("Anti-Collision Lights", devices.EXT_LIGHTS, device_commands.extlight_anticoll, 219, TOGGLECLICK_RIGHT_MID)
-- elements["PNT_220"] = multiposition_switch_limited("Fuselage Lights", devices.EXT_LIGHTS, device_commands.extlight_fuselage, 220, 3, 1, true, -1.0, TOGGLECLICK_RIGHT_MID)
-- elements["PNT_221"] = default_2_position_tumb("Lighting Flash/Steady mode", devices.EXT_LIGHTS, device_commands.extlight_flashsteady, 221, TOGGLECLICK_RIGHT_MID)
-- elements["PNT_222"] = multiposition_switch_limited("Navigation Lights", devices.EXT_LIGHTS, device_commands.extlight_nav, 222, 3, 1, true, -1.0, TOGGLECLICK_RIGHT_MID)
-- elements["PNT_223"] = multiposition_switch_limited("Tail Light", devices.EXT_LIGHTS, device_commands.extlight_tail, 223, 3, 1, true, -1.0, TOGGLECLICK_RIGHT_MID)

-- -- MISC SWITCHES PANEL #53
-- elements["PNT_1061"] = default_2_position_tumb("Emergency generator bypass",devices.ELECTRIC_SYSTEM, device_commands.emer_gen_bypass,1061, TOGGLECLICK_RIGHT_AFT)

-- -- INTERIOR LIGHTING PANEL #54
-- elements["PNT_106"] = default_axis_limited( "Instrument Lighting", devices.AVIONICS, device_commands.intlight_instruments, 106, 0.0, 0.3, false, false, {0,1} )
-- elements["PNT_107"] = default_axis_limited( "Console Lighting", devices.AVIONICS, device_commands.intlight_console, 107, 0.0, 0.3, false, false, {0,1} )
-- elements["PNT_108"] = multiposition_switch_limited("Console Light Intensity", devices.AVIONICS, device_commands.intlight_brightness, 108, 3, 1, true, -1.0, TOGGLECLICK_RIGHT_AFT)
-- elements["PNT_110"] = default_axis_limited( "White Floodlight Control", devices.AVIONICS, device_commands.intlight_whiteflood, 110, 0.0, 0.3, false, false, {0,1} )

-- -- AN/ARC-51 UHF RADIO #67
-- elements["PNT_361"] = multiposition_switch_limited("ARC-51 UHF Preset Channel", devices.RADIO, device_commands.arc51_freq_preset, 361, 20, 0.05, false, 0.00, KNOBCLICK_RIGHT_MID)
-- elements["PNT_365"] = default_axis_limited("ARC-51 UHF Volume", devices.RADIO, device_commands.arc51_volume, 365, 0.5, 0.3, false, false, {0,1})
-- elements["PNT_366"] = multiposition_switch_limited("ARC-51 UHF Frequency Mode", devices.RADIO, device_commands.arc51_xmitmode, 366, 3, 1, true, -1, KNOBCLICK_RIGHT_MID)
-- elements["PNT_367"] = multiposition_switch_limited("ARC-51 UHF Manual Frequency 10 MHz", devices.RADIO, device_commands.arc51_freq_XXxxx, 367, 18, 0.05, false, 0, KNOBCLICK_RIGHT_MID)
-- elements["PNT_368"] = multiposition_switch_limited("ARC-51 UHF Manual Frequency 1 MHz", devices.RADIO, device_commands.arc51_freq_xxXxx, 368, 10, 0.1, false, 0, KNOBCLICK_RIGHT_MID)
-- elements["PNT_369"] = multiposition_switch_limited("ARC-51 UHF Manual Frequency 50 kHz", devices.RADIO, device_commands.arc51_freq_xxxXX, 369, 20, 0.05, false, 0, KNOBCLICK_RIGHT_MID)
-- elements["PNT_370"] = default_2_position_tumb("ARC-51 UHF Squelch Disable", devices.RADIO, device_commands.arc51_squelch, 370, TOGGLECLICK_RIGHT_MID)
-- elements["PNT_372"] = multiposition_switch_limited("ARC-51 UHF Mode", devices.RADIO, device_commands.arc51_mode, 372, 4, 0.1, false, 0, KNOBCLICK_RIGHT_MID)

-- -- COMPASS CONTROLLER
-- elements["PNT_509"] = default_axis_limited("Compass latitude knob", devices.COMPASS, device_commands.COMPASS_latitude, 509, 0, 0.3, false, false, {-1,1})
-- elements["PNT_511"] = springloaded_3_pos_tumb("Compass heading set knob", devices.COMPASS, device_commands.COMPASS_set_heading, 511, true, KNOBCLICK_RIGHT_MID)
-- elements["PNT_512"] = default_2_position_tumb("Compass Free/Slaved Mode Switch", devices.COMPASS, device_commands.COMPASS_free_slaved_switch, 512, TOGGLECLICK_RIGHT_MID) -- NO COMMAND
-- elements["PNT_513"] = default_button("Compass Push to Sync", devices.COMPASS, device_commands.COMPASS_push_to_sync, 513) -- NO COMMAND


-- -- T handles
-- elements["PNT_1240"] = default_2_position_tumb("Emergency gear release",devices.GEAR, device_commands.emer_gear_release,1240)
-- elements["PNT_1240"].animated        = {true, true}
-- elements["PNT_1240"].animation_speed = {15, 15}
-- elements["PNT_1241"] = default_2_position_tumb("Emergency bomb release",devices.WEAPON_SYSTEM, device_commands.emer_bomb_release,1241)
-- elements["PNT_1241"].animated        = {true, true}
-- elements["PNT_1241"].animation_speed = {15, 15}
-- elements["PNT_1242"] = default_2_position_tumb("Manual Flight Control",devices.HYDRAULIC_SYSTEM, device_commands.man_flt_control_override,1242)
-- elements["PNT_1242"].animated        = {true, true}
-- elements["PNT_1242"].animation_speed = {15, 15}
-- elements["PNT_1243"] = default_2_position_tumb("Emergency generator deploy",devices.ELECTRIC_SYSTEM, device_commands.emer_gen_deploy,1243)
-- elements["PNT_1243"].animated        = {true, true}
-- elements["PNT_1243"].animation_speed = {15, 15}

-- -- ECM panel
-- elements["PNT_503"] = default_2_position_tumb("Audio APR/25 - APR/27",devices.RWR,device_commands.ecm_apr25_audio,	503,TOGGLECLICK_LEFT_MID)
-- elements["PNT_504"] = default_2_position_tumb("APR/25 on/off",	devices.RWR, device_commands.ecm_apr25_off,		504,TOGGLECLICK_LEFT_MID)
-- elements["PNT_501"] = default_2_position_tumb("APR/27 on/off",	devices.RWR, device_commands.ecm_apr27_off,		501,TOGGLECLICK_LEFT_MID)

-- elements["PNT_507"] = default_button("APR/27 test", devices.RWR, device_commands.ecm_systest_upper, 507)--,TOGGLECLICK_LEFT_MID)
-- elements["PNT_510"] = default_button("APR/27 light", devices.RWR, device_commands.ecm_systest_lower, 510)--,TOGGLECLICK_LEFT_MID)

-- elements["PNT_506"] = default_axis_limited( "PRF volume (inner knob)", devices.RWR, device_commands.ecm_msl_alert_axis_inner, 506, 0.0, 0.3, false, false, {-0.8,0.8} )
-- elements["PNT_505"] = default_axis_limited( "MSL volume (outer knob)", devices.RWR, device_commands.ecm_msl_alert_axis_outer, 505, 0.0, 0.3, false, false, {-0.8,0.8} )

-- elements["PNT_502"] = multiposition_switch_limited("ECM selector knob",devices.RWR, device_commands.ecm_selector_knob,502,4,0.33,false,0.0,KNOBCLICK_MID_FWD, 5)

-- -- AIR CONDITIONING PANEL
-- elements["PNT_1251"] = default_2_position_tumb("Cabin Pressure Switch", devices.ELECTRIC_SYSTEM, device_commands.cabin_pressure , 224, TOGGLECLICK_LEFT_MID)
-- elements["PNT_225"] = default_3_position_tumb("Windshield Defrost", devices.ELECTRIC_SYSTEM, device_commands.windshield_defrost , 225, nil, nil, TOGGLECLICK_MID_FWD)
-- elements["PNT_226"] = default_axis_limited("Cabin Temp Knob", devices.ELECTRIC_SYSTEM, device_commands.cabin_temp , 226, 0.0, 0.3, false, false, {0,1} )

-- -- EJECTION SEAT
-- elements["PNT_24"] = default_2_position_tumb("Shoulder Harness Inertia Reel Control", devices.AVIONICS ,device_commands.CPT_shoulder_harness, 24, nil)
-- elements["PNT_24"].animated        = {true, true}
-- elements["PNT_24"].animation_speed = {7, 7}
-- elements["PNT_25"] = default_2_position_tumb("Secondary Ejection Handle", devices.AVIONICS ,device_commands.CPT_secondary_ejection_handle, 25, nil)
-- elements["PNT_25"].animated        = {true, true}
-- elements["PNT_25"].animation_speed = {7, 7}

-- Commented out because it doesn't seem to be required anymore [HECLAK]
-- Can be removed if someone figures out what the original requirement was
-- for i,o in pairs(elements) do
-- 	if  o.class[1] == class_type.TUMB or 
-- 	   (o.class[2]  and o.class[2] == class_type.TUMB) or
-- 	   (o.class[3]  and o.class[3] == class_type.TUMB)  then
-- 	   o.updatable = true
-- 	   o.use_OBB   = true
-- 	end
-- end