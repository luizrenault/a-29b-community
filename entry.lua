local self_ID  = "A-29B" 
declare_plugin(self_ID,
{
dirName 		= current_mod_path,
displayName     = _("A-29B Super Tucano"),
shortName		= "A-29B",
-- fileMenuName	= _("A-29B Super Tucano"),
-- update_id	= "A-29B",
state		 = "installed",
developerName   = "Fight's On BR",
info		 = _("A-29B Super Tucano is a turboprop light attack aircraft designed for counter-insurgency (COIN) operations, close air support, and aerial reconnaissance missions in low-threat environments. It is developed by the Brazilian aerospace company Embraer and has been widely used by various air forces around the world."),
version		 = "0.6.0b",
developerLink   = "https://github.com/luizrenault/a-29b-community",

binaries 	 = 
{
	'avSimplest'
},

Skins	=
{
	{
		name	= "A-29B",
		dir		= "Skins/1"
	},
},
Missions =
{
	{
		name		= _("A-29B"),
		dir			= "Missions",
		CLSID		= "{A-29B missions}",
	},
},
LogBook =
{
	{
		name		= _("A-29B"),
		type		= "A-29B",
	},
},		
Options =
{
	{
		name		= _("A-29B"),
		nameId		= "A-29B",
		dir			= "Options",
		CLSID		= "{A-29B Options}"
	},
},
InputProfiles =
{
    ["A-29B"] = current_mod_path .. '/Input/A-29B',
},

})

mount_vfs_texture_path  (current_mod_path ..  "/Textures/A-29B")
mount_vfs_model_path    (current_mod_path ..  "/Shapes")
mount_vfs_liveries_path (current_mod_path ..  "/Liveries")
mount_vfs_texture_path	(current_mod_path ..  "/Skins/1/ME")--for simulator loading window

local cfg_path = current_mod_path.."/FM/config.lua"
dofile(cfg_path)






--local support_cockpit = current_mod_path..'/Cockpit/Scripts/'
dofile(current_mod_path..'/loadout.lua')
dofile(current_mod_path..'/weapons.lua')

dofile(current_mod_path..'/A-29B.lua')
mount_vfs_sound_path (current_mod_path.."/Sounds/")

A29B[1] = self_ID
A29B[2] = 'avSimplest'
A29B.config_path = cfg_path
A29B.user_options = 'A-29B'

dofile(current_mod_path.."/Views.lua")
make_view_settings('A-29B', ViewSettings, SnapViews)

make_flyable("A-29B", current_mod_path..'/Cockpit/Scripts/' , A29B , current_mod_path..'/comm.lua')
plugin_done()
