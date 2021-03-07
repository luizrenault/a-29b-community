local self_ID  = "A-29B" 

declare_plugin(self_ID,
{
installed 	 = true, -- if false that will be place holder , or advertising
displayName     = _("A-29B"),
developerName   =   "Fight's On BR",
version		 = "0.1.6b",
state		 = "installed",
info		 = _("A-29B"),

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
----------------------------------------------------------------------------------------
--make_flyable('A-29B', 'Mods/aircraft/Flaming Cliffs/Cockpit/KneeboardRight/',{nil, old = 17}, current_mod_path..'/comm.lua')
make_flyable('A-29B', current_mod_path..'/Cockpit/Scripts/' , nil , current_mod_path..'/comm.lua')
----------------------------------------------------------------------------------------
plugin_done()
