mount_vfs_texture_archives("Bazar/Textures/AvionicsCommon")
-- mount_vfs_texture_archives(LockOn_Options.script_path.."../Resources/Model/Textures/WunderluftTextures")

dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.common_script_path.."tools.lua")
dofile(LockOn_Options.script_path.."materials.lua")

layoutGeometry = {}

MainPanel = {"ccMainPanel",LockOn_Options.script_path.."mainpanel_init.lua",
{
    --{"INTERCOM", devices.INTERCOM},
    --{"UHF_Radio", devices.UHF_RADIO},
    --{"OxygenSystem", devices.TEMP3},
    --{"avSimpleElectricSystem", devices.ELECTRIC_SYSTEM}, -- DCS.log: ERROR   COCKPITBASE: devices_keeper::link_all: unable to find link target 'avSimpleElectricSystem' for device 'MAIN_PANEL'
    --{"LightSystem", devices.TEMP1},
--[[
    {
    devices.INTERCOM, -- DCS.log: ERROR   COCKPITBASE: devices_keeper::link_all: unable to find link target '28' for device 'MAIN_PANEL'
    devices.UHF_RADIO,
    devices.ELECTRIC_SYSTEM,
    },
--]]
},
}

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
creators[devices.ENGINE]          = {"avLuaDevice"           ,LockOn_Options.script_path.."Systems/engine.lua"}
creators[devices.FUEL]            = {"avLuaDevice"           ,LockOn_Options.script_path.."Systems/fuel.lua"}
creators[devices.EXTLIGHTS]       = {"avLuaDevice"           ,LockOn_Options.script_path.."Systems/extlights.lua"}
creators[devices.INTLIGHTS]       = {"avLuaDevice"           ,LockOn_Options.script_path.."Systems/intlights.lua"}
creators[devices.ICEPROT]         = {"avLuaDevice"           ,LockOn_Options.script_path.."Systems/iceprot.lua"}
creators[devices.ENVIRON]         = {"avLuaDevice"           ,LockOn_Options.script_path.."Systems/environ.lua"}
creators[devices.GEAR]            = {"avLuaDevice"           ,LockOn_Options.script_path.."Systems/gear_old.lua"}
creators[devices.BRAKES]          = {"avLuaDevice"           ,LockOn_Options.script_path.."Systems/brakes.lua"}
creators[devices.CMFD1]           = {"avLuaDevice"           ,LockOn_Options.script_path.."Systems/cmfd_left.lua"}
creators[devices.CMFD2]           = {"avLuaDevice"           ,LockOn_Options.script_path.."Systems/cmfd_right.lua"}



creators[devices.CANOPY]          = {"avLuaDevice"           ,LockOn_Options.script_path.."Systems/canopy.lua"}
creators[devices.FLAPS]           = {"avLuaDevice"           ,LockOn_Options.script_path.."Systems/flaps.lua"}
creators[devices.EXTANIM]         = {"avLuaDevice"           ,LockOn_Options.script_path.."Systems/externalanimations.lua"}

--creators[devices.EFM_DATA_BUS]		= {"avLuaDevice", LockOn_Options.script_path.."EFM_Data_Bus.lua"}


tv_map_render_id ={1, 2, 3, 4};

indicators                  = {}
indicators[#indicators + 1] = {"ccIndicator", LockOn_Options.script_path.."CMFD/CMFD_Left_init.lua" , devices.CMFD1,{{"CENTER_HDD001_PNT","DOWN_HDD001_PNT","RIGHT_HDD001_PNT"}, {}}, tv_map_render_id[1]}
indicators[#indicators + 1] = {"ccIndicator", LockOn_Options.script_path.."CMFD/CMFD_Right_init.lua" , devices.CMFD2,{{"CENTER_HDD002_PNT","DOWN_HDD002_PNT","RIGHT_HDD002_PNT"}, {}}, tv_map_render_id[2]}
indicators[#indicators + 1] = {"ccIndicator", LockOn_Options.script_path.."BFI/init.lua" , nil,{{"CENTER_BFI_PNT","DOWN_BFI_PNT","RIGHT_BFI_PNT"}, {}}}


--attributes = {
--	"support_for_cws",
--}
---------------------------------------------
dofile(LockOn_Options.common_script_path.."KNEEBOARD/declare_kneeboard_device.lua")
---------------------------------------------
