ViewSettings = {
	Cockpit = {
	[1] = {-- player slot 1
		CockpitLocalPoint      = {0.1000,0.294,0.000000},--Cockpit  = front,height 4.705000,1.336000,0.000000
		CameraViewAngleLimits  = {20.000000,160.000000},
		CameraAngleRestriction = {false,90.000000,0.400000},
		CameraAngleLimits      = {190.000000,-75.000000,115.000000},--Kopf drehen = links rechts,runter,hoch
		EyePoint               = {0.050000,0.500000,0.000000},--front/back,up/down,left/right}<-'neck dimension'in meters 
		limits_6DOF            = {x = {0.030000,0.400000},y ={-0.300000,0.100000},z = {-0.300000,0.300000},roll = 90.000000},--Move = back front, top bottom, left right
		ShoulderSize		   = 0.25,-- moves body when azimuth value is more than 90 degrees
		Allow360rotation	   = false,
	},	
	[2] = {-- player slot 2
		CockpitLocalPoint      = {-1.3200,0.794,0.000000},--Cockpit  = front,height 4.705000,1.336000,0.000000
		CameraViewAngleLimits  = {20.000000,160.000000},
		CameraAngleRestriction = {false,90.000000,0.400000},
		CameraAngleLimits      = {190.000000,-75.000000,115.000000},--Kopf drehen = links rechts,runter,hoch
		EyePoint               = {0.050000,0.500000,0.000000},--front/back,up/down,left/right}<-'neck dimension'in meters 
		limits_6DOF            = {x = {0.030000,0.400000},y ={-0.300000,0.100000},z = {-0.300000,0.300000},roll = 90.000000},--Move = back front, top bottom, left right
		ShoulderSize		   = 0.25,-- moves body when azimuth value is more than 90 degrees
		Allow360rotation	   = false,
	},	
	}, -- Cockpit 
	Chase = {
		LocalPoint      = {-10.0,1.0,3.0},
		AnglesDefault   = {0.000000, 0.000000},
	}, -- Chase
	Arcade = {
		LocalPoint      = {-21.500000,6.618000,0.000000},
		AnglesDefault   = {0.000000,-8.000000},
	}, -- Arcade
}

SnapViews = {
[1] = {-- player slot 1
	[1] = {--LWin + Num0 : Snap View 0
		viewAngle = 60.000000,--FOV
		hAngle	 = 0.000000,
		vAngle	 = 0.000000,
		x_trans	 = 0.000000,
		y_trans	 = 0.000000,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,
	},
	[2] = {--LWin + Num1 : Snap View 1
		viewAngle = 60.000000,--FOV
		hAngle	 = 0.000000,
		vAngle	 = 0.000000,
		x_trans	 = 0.000000,
		y_trans	 = 0.000000,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,
	},
	[3] = {--LWin + Num2 : Snap View 2
		viewAngle = 60.000000,--FOV
		hAngle	 = 0.000000,
		vAngle	 = 0.000000,
		x_trans	 = 0.000000,
		y_trans	 = 0.000000,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,
	},
	[4] = {--LWin + Num3 : Snap View 3
		viewAngle = 60.000000,--FOV
		hAngle	 = 0.000000,
		vAngle	 = 0.000000,
		x_trans	 = 0.000000,
		y_trans	 = 0.000000,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,
	},
	[5] = {--LWin + Num4 : Snap View 4
		viewAngle = 60.000000,--FOV
		hAngle	 = 0.000000,
		vAngle	 = 0.000000,
		x_trans	 = 0.000000,
		y_trans	 = 0.000000,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,
	},
	[6] = {--LWin + Num5 : Snap View 5
		viewAngle = 60.000000,--FOV
		hAngle	 = 0.000000,
		vAngle	 = 0.000000,
		x_trans	 = 0.000000,
		y_trans	 = 0.000000,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,
	},
	[7] = {--LWin + Num6 : Snap View 6
		viewAngle = 60.000000,--FOV
		hAngle	 = 0.000000,
		vAngle	 = 0.000000,
		x_trans	 = 0.000000,
		y_trans	 = 0.000000,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,
	},
	[8] = {--LWin + Num7 : Snap View 7
		viewAngle = 60.000000,--FOV
		hAngle	 = 0.000000,
		vAngle	 = 0.000000,
		x_trans	 = 0.000000,
		y_trans	 = 0.000000,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,
	},
	[9] = {--LWin + Num8 : Snap View 8
		viewAngle = 60.000000,--FOV
		hAngle	 = 0.000000,
		vAngle	 = 0.000000,
		x_trans	 = 0.000000,
		y_trans	 = 0.000000,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,
	},
	[10] = {--LWin + Num9 : Snap View 9
		viewAngle = 60.000000,--FOV
		hAngle	 = 0.000000,
		vAngle	 = 0.000000,
		x_trans	 = 0.000000,
		y_trans	 = 0.000000,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,
	},
	[11] = {--look at left  mirror
		viewAngle = 60.000000,--FOV
		hAngle	 = 0.000000,
		vAngle	 = 0.000000,
		x_trans	 = 0.000000,
		y_trans	 = 0.000000,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,
	},
	[12] = {--look at right mirror
		viewAngle = 60.000000,--FOV
		hAngle	 = 0.000000,
		vAngle	 = 0.000000,
		x_trans	 = 0.000000,
		y_trans	 = 0.000000,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,
	},
	[13] = {--default view
		viewAngle = 87.468338,--FOV
		hAngle	 = 0.000000,
		vAngle	 = -9.500000,
		x_trans	 = 0.0,
		y_trans	 = 0.025,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,
	},
},
[2] = {-- player slot 2
	[1] = {--LWin + Num0 : Snap View 0
		viewAngle = 60.000000,--FOV
		hAngle	 = 0.000000,
		vAngle	 = 0.000000,
		x_trans	 = 0.000000,
		y_trans	 = 0.000000,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,
	},
	[2] = {--LWin + Num1 : Snap View 1
		viewAngle = 60.000000,--FOV
		hAngle	 = 0.000000,
		vAngle	 = 0.000000,
		x_trans	 = 0.000000,
		y_trans	 = 0.000000,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,
	},
	[3] = {--LWin + Num2 : Snap View 2
		viewAngle = 60.000000,--FOV
		hAngle	 = 0.000000,
		vAngle	 = 0.000000,
		x_trans	 = 0.000000,
		y_trans	 = 0.000000,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,
	},
	[4] = {--LWin + Num3 : Snap View 3
		viewAngle = 60.000000,--FOV
		hAngle	 = 0.000000,
		vAngle	 = 0.000000,
		x_trans	 = 0.000000,
		y_trans	 = 0.000000,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,
	},
	[5] = {--LWin + Num4 : Snap View 4
		viewAngle = 60.000000,--FOV
		hAngle	 = 0.000000,
		vAngle	 = 0.000000,
		x_trans	 = 0.000000,
		y_trans	 = 0.000000,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,
	},
	[6] = {--LWin + Num5 : Snap View 5
		viewAngle = 60.000000,--FOV
		hAngle	 = 0.000000,
		vAngle	 = 0.000000,
		x_trans	 = 0.000000,
		y_trans	 = 0.000000,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,
	},
	[7] = {--LWin + Num6 : Snap View 6
		viewAngle = 60.000000,--FOV
		hAngle	 = 0.000000,
		vAngle	 = 0.000000,
		x_trans	 = 0.000000,
		y_trans	 = 0.000000,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,
	},
	[8] = {--LWin + Num7 : Snap View 7
		viewAngle = 60.000000,--FOV
		hAngle	 = 0.000000,
		vAngle	 = 0.000000,
		x_trans	 = 0.000000,
		y_trans	 = 0.000000,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,
	},
	[9] = {--LWin + Num8 : Snap View 8
		viewAngle = 60.000000,--FOV
		hAngle	 = 0.000000,
		vAngle	 = 0.000000,
		x_trans	 = 0.000000,
		y_trans	 = 0.000000,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,
	},
	[10] = {--LWin + Num9 : Snap View 9
		viewAngle = 60.000000,--FOV
		hAngle	 = 0.000000,
		vAngle	 = 0.000000,
		x_trans	 = 0.000000,
		y_trans	 = 0.000000,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,
	},
	[11] = {--look at left  mirror
		viewAngle = 60.000000,--FOV
		hAngle	 = 0.000000,
		vAngle	 = 0.000000,
		x_trans	 = 0.000000,
		y_trans	 = 0.000000,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,
	},
	[12] = {--look at right mirror
		viewAngle = 60.000000,--FOV
		hAngle	 = 0.000000,
		vAngle	 = 0.000000,
		x_trans	 = 0.000000,
		y_trans	 = 0.000000,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,
	},
	[13] = {--default view
		viewAngle = 87.468338,--FOV
		hAngle	 = 0.000000,
		vAngle	 = -9.500000,
		x_trans	 = 0.113927,
		y_trans	 = -0.004946,
		z_trans	 = 0.000000,
		rollAngle = 0.000000,
	},
},
}

-- 2021-04-16 19:54:21.288 ERROR   COCKPITBASE: Cockpit: Clickable - Wrong connector name PNT_851
-- 2021-04-16 19:54:21.315 ERROR   WRADIO: CommandDialogsPanel: RadioCommandDialogsPanel.initialize error [string "Scripts/UI/RadioCommandDialogPanel/Config/LockOnAirplane.lua"]:405: Group doesn't exist
-- stack traceback:
-- 	[C]: ?
-- 	[C]: in function 'getUnit'
-- 	[string "Scripts/UI/RadioCommandDialogPanel/Config/LockOnAirplane.lua"]:405: in function <[string "Scripts/UI/RadioCommandDialogPanel/Config/LockOnAirplane.lua"]:402>
-- 	(tail call): ?
-- 	[string "./Scripts/UI/RadioCommandDialogPanel/CommandMenu.lua"]:442: in function 'buildMenu_'
-- 	[string "./Scripts/UI/RadioCommandDialogPanel/CommandMenu.lua"]:459: in function 'enterMenu_'
-- 	[string "./Scripts/UI/RadioCommandDialogPanel/CommandMenu.lua"]:240: in function 'outputSymbol'
-- 	[string "./Scripts/UI/RadioCommandDialogPanel/CommandMenu.lua"]:646: in function 'handler'
-- 	[string "./Scripts/Common/fsm.lua"]:101: in function 'onSymbol'
-- 	[string "./Scripts/UI/RadioCommandDialogPanel/CommandMenu.lua"]:482: in function 'setMainMenu'
-- 	[string "./Scripts/UI/RadioCommandDialogPanel/CommandDialogsPanel.lua"]:85: in function 'openDialog_'
-- 	[string "./Scripts/UI/RadioCommandDialogPanel/CommandDialogsPanel.lua"]:279: in function 'toggle'
-- 	[string "Scripts/UI/RadioCommandDialogPanel/RadioCommandDialogsPanel.lua"]:1484: in function <[string "Scripts/UI/RadioCommandDialogPanel/RadioCommandDialogsPanel.lua"]:1379>
-- 2021-04-16 19:54:21.315 INFO    COCKPITBASE: lua state still active ELECTRIC_SYSTEM, 1
-- 2021-04-16 19:54:21.315 INFO    COCKPITBASE: lua state still active ENGINE, 2
-- 2021-04-16 19:54:21.315 INFO    COCKPITBASE: lua state still active FUEL, 3
-- 2021-04-16 19:54:21.315 INFO    COCKPITBASE: lua state still active EXTLIGHTS, 4
-- 2021-04-16 19:54:21.315 INFO    COCKPITBASE: lua state still active INTLIGHTS, 5
-- 2021-04-16 19:54:21.316 INFO    COCKPITBASE: lua state still active ICEPROT, 6
-- 2021-04-16 19:54:21.316 INFO    COCKPITBASE: lua state still active ENVIRON, 7
-- 2021-04-16 19:54:21.316 INFO    COCKPITBASE: lua state still active GEAR, 8
-- 2021-04-16 19:54:21.316 INFO    COCKPITBASE: lua state still active BRAKES, 9
-- 2021-04-16 19:54:21.316 INFO    COCKPITBASE: lua state still active CMFD, 10
-- 2021-04-16 19:54:21.316 INFO    COCKPITBASE: lua state still active HUD, 11
-- 2021-04-16 19:54:21.316 INFO    COCKPITBASE: lua state still active AVIONICS, 12
-- 2021-04-16 19:54:21.316 INFO    COCKPITBASE: avBaseRadio::ext_set_modulation not implemented, used direct set
-- 2021-04-16 19:54:21.316 INFO    \DCS\Mods/aircraft/A-29B/Cockpit/Scripts/Systems/uhf_radio.lua: is_on = false
-- 2021-04-16 19:54:21.316 INFO    \DCS\Mods/aircraft/A-29B/Cockpit/Scripts/Systems/uhf_radio.lua: get_frequency = 256000288
-- 2021-04-16 19:54:21.316 INFO    \DCS\Mods/aircraft/A-29B/Cockpit/Scripts/Systems/uhf_radio.lua: get_modulation = 0
-- 2021-04-16 19:54:21.316 INFO    COCKPITBASE: lua state still active UHF_RADIO, 13
-- 2021-04-16 19:54:21.316 INFO    COCKPITBASE: lua state still active RADIO, 14
-- 2021-04-16 19:54:21.316 INFO    COCKPITBASE: lua state still active AIRBRAKE, 15
-- 2021-04-16 19:54:21.316 INFO    COCKPITBASE: lua state still active CANOPY, 16
-- 2021-04-16 19:54:21.316 INFO    COCKPITBASE: lua state still active FLAPS, 17
-- 2021-04-16 19:54:21.316 INFO    COCKPITBASE: lua state still active EXTANIM, 18
-- 2021-04-16 19:54:21.316 INFO    COCKPITBASE: lua state still active WEAPON_SYSTEM, 19
-- 2021-04-16 19:54:21.316 INFO    COCKPITBASE: lua state still active INTERCOM, 20
-- 2021-04-16 19:54:21.316 INFO    COCKPITBASE: lua state still active UFCP, 21
-- 2021-04-16 19:54:21.316 INFO    COCKPITBASE: lua state still active ALARM, 23
-- 2021-04-16 19:54:21.316 INFO    COCKPITBASE: lua state still active AUTOPILOT, 25
-- 2021-04-16 19:54:21.347 INFO    WORLDGENERAL: loaded from mission Scripts/World/birds.lua
