creators[devices.FLIR]		      = {"LR::avSimplestFLIR"    ,LockOn_Options.script_path.."FLIR/device.lua"}
creators[devices.WEAPON_SYSTEM]   = {"LR::avSimplestWeaponSystem"  ,LockOn_Options.script_path.."Systems/weapon_system.lua"}

indicators[#indicators + 1] = {"LR::ccCamera", LockOn_Options.script_path.."FLIR/indicator.lua", devices.FLIR,	{{}}}
indicators[#indicators + 1] = {"LR::ccSimplestIndicator", LockOn_Options.script_path.."CMFD/CMFD_Left_init.lua" , devices.CMFD,{{"CENTER_HDD001_PNT","DOWN_HDD001_PNT","RIGHT_HDD001_PNT"}, {},1},1}
