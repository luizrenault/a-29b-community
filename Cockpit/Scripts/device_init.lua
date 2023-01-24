dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.common_script_path.."tools.lua")
dofile(LockOn_Options.script_path.."materials.lua")

-- package.cpath 			= package.cpath..";".. LockOn_Options.script_path.. "..\\..\\bin\\?.dll"
-- require('avSimplest')

layoutGeometry = {}

MainPanel = {"ccMainPanel",LockOn_Options.script_path.."mainpanel_init.lua", {},}

-- Avionics devices initialization example
--	items in <...> are optional
--
-- creators[DEVICE_ID] = {"NAME_OF_CONTROLLER_CLASS",
--						  <"CONTROLLER_SCRIPT_FILE",>
--						  <{devices.LINKED_DEVICE1, devices.LINKED_DEVICE2, ...},>
--						  <"INPUT_COMMANDS_SCRIPT_FILE",>
--						  <{{"NAME_OF_INDICATOR_CLASS", "INDICATOR_SCRIPT_FILE"}, ...}>
--						 }
creators                          = {}
creators[devices.ELECTRIC_SYSTEM] = {"avSimpleElectricSystem",LockOn_Options.script_path.."Systems/electric_system.lua"}

creators[devices.ELECTRIC_SYSTEM_] = {"A29B::ElectricSystem", LockOn_Options.script_path.."Systems/electric_system_.lua"}

creators[devices.ENGINE]          = {"avLuaDevice"           ,LockOn_Options.script_path.."Systems/engine.lua"}
creators[devices.FUEL]            = {"avLuaDevice"           ,LockOn_Options.script_path.."Systems/fuel.lua"}
creators[devices.EXTLIGHTS]       = {"avLuaDevice"           ,LockOn_Options.script_path.."Systems/extlights.lua"}
creators[devices.INTLIGHTS]       = {"avLuaDevice"           ,LockOn_Options.script_path.."Systems/intlights.lua"}
creators[devices.ICEPROT]         = {"avLuaDevice"           ,LockOn_Options.script_path.."Systems/iceprot.lua"}
creators[devices.ENVIRON]         = {"avLuaDevice"           ,LockOn_Options.script_path.."Systems/environ.lua"}
creators[devices.GEAR]            = {"avLuaDevice"           ,LockOn_Options.script_path.."Systems/gear_old.lua"}
creators[devices.BRAKES]          = {"avLuaDevice"           ,LockOn_Options.script_path.."Systems/brakes.lua"}
creators[devices.CMFD]            = {"LR::avSimplestSA"      ,LockOn_Options.script_path.."Systems/cmfds.lua"}
creators[devices.HUD]             = {"avLuaDevice"           ,LockOn_Options.script_path.."Systems/hud.lua"}
creators[devices.AVIONICS]        = {"avLuaDevice"           ,LockOn_Options.script_path.."Systems/avionics.lua"}
creators[devices.AIRBRAKE]        = {"avLuaDevice"           ,LockOn_Options.script_path.."Systems/airbrake.lua"}
creators[devices.CANOPY]          = {"avLuaDevice"           ,LockOn_Options.script_path.."Systems/canopy.lua"}
creators[devices.FLAPS]           = {"avLuaDevice"           ,LockOn_Options.script_path.."Systems/flaps.lua"}
creators[devices.EXTANIM]         = {"avLuaDevice"           ,LockOn_Options.script_path.."Systems/externalanimations.lua"}
creators[devices.WEAPON_SYSTEM]   = {"LR::avSimplestWeaponSystem"  ,LockOn_Options.script_path.."Systems/weapon_system.lua", {devices.CMFD}}
-- creators[devices.RADIO]           = {"avLuaDevice"           ,LockOn_Options.script_path.."Systems/radio.lua"}
creators[devices.VUHF1_RADIO]     = {"avSimplestRadio"     ,LockOn_Options.script_path.."Systems/uhf_radio.lua", {devices.ELECTRIC_SYSTEM}}
-- creators[devices.VUHF2_RADIO]     = {"avSimplestRadio"         ,LockOn_Options.script_path.."Systems/uhf_radio.lua", {devices.ELECTRIC_SYSTEM}}
-- creators[devices.HF3_RADIO]       = {"avSimplestRadio"         ,LockOn_Options.script_path.."Systems/uhf_radio.lua", {devices.ELECTRIC_SYSTEM}}
-- creators[devices.VUHF1_RADIO]     = {"avUHF_ARC_164"         ,LockOn_Options.script_path.."Systems/uhf_radio.lua", {devices.ELECTRIC_SYSTEM}}
-- creators[devices.VUHF2_RADIO]     = {"avUHF_ARC_164"         ,LockOn_Options.script_path.."Systems/uhf_radio.lua", {devices.ELECTRIC_SYSTEM}}
-- creators[devices.HF3_RADIO]       = {"avUHF_ARC_164"         ,LockOn_Options.script_path.."Systems/uhf_radio.lua", {devices.ELECTRIC_SYSTEM}}

creators[devices.INTERCOM]        = {"avIntercom"            ,LockOn_Options.script_path.."Systems/intercom.lua", {devices.VUHF1_RADIO, devices.ELECTRIC_SYSTEM}}

creators[devices.UFCP]            = {"avLuaDevice"           ,LockOn_Options.script_path.."Systems/ufcp.lua", {devices.ALARM}}
creators[devices.ALARM]           = {"avLuaDevice"           ,LockOn_Options.script_path.."Systems/alarm.lua"}--, {devices.CMFD}}
creators[devices.AUTOPILOT]		  = {"avLuaDevice"           ,LockOn_Options.script_path.."Systems/autopilot.lua"}
creators[devices.HELMET_DEVICE]	  = {"avNightVisionGoggles"}
creators[devices.ILS]		      = {"avILS"                 , nil,                                                 {devices.ELECTRIC_SYSTEM}}
creators[devices.ILS_DEVICE]	  = {"avLuaDevice"           ,LockOn_Options.script_path.."Systems/ils.lua"}

creators[devices.FLIR]		      = {"LR::avSimplestFLIR"    ,LockOn_Options.script_path.."FLIR/device.lua"}

-- creators[devices.MAP]		      = {"LR::avSimplestMap"    ,LockOn_Options.script_path.."Map/device.lua"}

-- creators[devices.TEST]		      = {"avLuaDevice"           ,LockOn_Options.script_path.."Systems/test_device.lua"}

indicators                  = {}
indicators[#indicators + 1] = {"LR::ccSimplestIndicator", LockOn_Options.script_path.."CMFD/CMFD_Left_init.lua" , devices.CMFD,{{"CENTER_HDD001_PNT","DOWN_HDD001_PNT","RIGHT_HDD001_PNT"}, {},1},1}
indicators[#indicators + 1] = {"LR::ccSimplestIndicator", LockOn_Options.script_path.."CMFD/CMFD_Right_init.lua" , devices.CMFD,{{"CENTER_HDD002_PNT","DOWN_HDD002_PNT","RIGHT_HDD002_PNT"}, {},1},2}
indicators[#indicators + 1] = {"ccIndicator", LockOn_Options.script_path.."BFI/init.lua" , nil,{{"CENTER_BFI_PNT","DOWN_BFI_PNT","RIGHT_BFI_PNT"}, {}}}
indicators[#indicators + 1] = {"ccIndicator", LockOn_Options.script_path.."HUD/Indicator/HUD_page_init.lua" , devices.HUD ,	{ {"PTR-HUD-CENTER", "PTR-HUD-DOWN", "PTR-HUD-RIGHT"},{},2},2}
indicators[#indicators + 1] = {"ccIndicator", LockOn_Options.script_path.."UFCP/UFCP_page_init.lua" , devices.UFCP ,	{ {"PTR-UFCP-CENTER", "PTR-UFCP-DOWN", "PTR-UFCP-RIGHT"},{},2},2}
indicators[#indicators + 1] = {"LR::ccCamera", LockOn_Options.script_path.."FLIR/indicator.lua", devices.FLIR,	{{}}}

-- indicators[#indicators + 1] = {"LR::ccSimplestMap", LockOn_Options.script_path.."Map/indicator.lua" , devices.MAP,	{ {"PTR-HUD-CENTER", "PTR-HUD-DOWN", "PTR-HUD-RIGHT"}, {sx_l = 0, sy_l = 0, sz_l = 0.15}}}

-- indicators[#indicators + 1] = {"ccIndicator", LockOn_Options.script_path.."avRadar/Indicator/init.lua" , nil,		{ {},{sz_l = 0.0,sx_l = -0.50, sy_l =  -0.07 },  1}}
-- indicators[#indicators + 1] = {"ccChart",     LockOn_Options.common_script_path.."dbg_chart.lua"  ,nil,{{"PTR-HUD-CENTER", "PTR-HUD-DOWN", "PTR-HUD-RIGHT"},{} }}

--attributes = {
--	"support_for_cws",
--}

--RADAROFF indicators[#indicators + 1] = {"ccIndicator",LockOn_Options.script_path.."RADAR/Indicator/init.lua",--init script
--RADAROFF   nil,--id of parent device
--RADAROFF   {
--RADAROFF 	{}, -- initial geometry anchor , triple of connector names
--RADAROFF 	{sx_l =  0,  -- center position correction in meters (forward , backward)
--RADAROFF 	 sy_l =  0,  -- center position correction in meters (up , down)
--RADAROFF 	 sz_l =  0.3,  -- center position correction in meters (left , right)
--RADAROFF 	 sh   =  0,  -- half height correction
--RADAROFF 	 sw   =  0,  -- half width correction
--RADAROFF 	 rz_l =  0,  -- rotation corrections
--RADAROFF 	 rx_l =  0,
--RADAROFF 	 ry_l =  0}
--RADAROFF   },
--RADAROFF   render_target_id
--RADAROFF } --RADAR

---------------------------------------------
dofile(LockOn_Options.common_script_path.."KNEEBOARD/declare_kneeboard_device.lua")
---------------------------------------------
