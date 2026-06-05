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
elements["PNT_791"] = default_3_position_tumb("Emergency/Parking Brakes",                       devices.BRAKES, device_commands.EmerParkBrake,	791, false, true, TOGGLECLICK_MID_FWD)

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
elements["PNT_762"] = default_movable_axis("COM 1 Audio",      		           					devices.VUHF1_RADIO, device_commands.AUDIO_COM1_VOL,     762)
elements["PNT_763"] = default_movable_axis("COM 2 Audio",      		           					devices.VUHF2_RADIO, device_commands.AUDIO_COM2_VOL,     763)
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

