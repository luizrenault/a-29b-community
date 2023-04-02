local self_ID  = "A-29B" 

declare_plugin(self_ID,
{
installed 	 = true, -- if false that will be place holder , or advertising
displayName     = _("A-29B"),
developerName   =   "Fight's On BR",
developerLink   = "https://github.com/luizrenault/a-29b-community",
version		 = "0.5.3b",
state		 = "installed",
info		 = _("A-29B"),
binaries 	 = {'avSimplest'},
InputProfiles =
{
    ["A-29B"] = current_mod_path .. '/Input/A-29B',
},


Skins	=
	{
		{
			name	= _("A-29B"),
			dir		= "Skins/1"
		},
	},
	
Missions =
	{
		{
			name		= _("A-29B"),
			dir			= "Missions",
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
			CLSID		= "{A-29B Super Tucano Options}"
		},
	},

})

mount_vfs_texture_path  (current_mod_path ..  "/Theme/ME")--for simulator loading window
mount_vfs_texture_path  (current_mod_path ..  "/Textures/A-29B")
mount_vfs_model_path    (current_mod_path ..  "/Shapes")


--local support_cockpit = current_mod_path..'/Cockpit/Scripts/'
dofile(current_mod_path..'/loadout.lua')
dofile(current_mod_path..'/weapons.lua')

dofile(current_mod_path..'/A-29B.lua')
dofile(current_mod_path.."/Views.lua")
make_view_settings('A-29B', ViewSettings, SnapViews)
mount_vfs_sound_path (current_mod_path.."/Sounds/")

local cfg_path = current_mod_path.."/ConfigFM.lua"
dofile(cfg_path)  


local FM = 
{
	[1] = self_ID,
	[2] = 'avSimplest',
	config_path	= cfg_path,
	center_of_mass		=	{ empty_cg_position , spinner_tip_position[2] , 0.0},		-- center of mass position relative to object 3d model center for empty aircraft
	moment_of_inertia  	= 	{14056.0, 40927.0, 30700.0},   	-- moment of inertia of empty aircraft
	disable_built_in_oxygen_system	= true,
}

----------------------------------------------------------------------------------------
make_flyable('A-29B', current_mod_path..'/Cockpit/Scripts/' , FM , current_mod_path..'/comm.lua')
----------------------------------------------------------------------------------------
plugin_done()
