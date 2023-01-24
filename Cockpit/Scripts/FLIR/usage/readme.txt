Usage:


1) Copy avSimplest.dll to the mod's bin folder (Saved Games\MODNAME\bin) and 
add 'avSimplest' to the mod's binaries list in entry.lua
Example:
declare_plugin(self_ID,
{
    ...
    binaries 	 = {'avSimplest'},
    ...
})

It isn't a EFM dll so use your own or keep it nil. 
make_flyable('MODNAME', current_mod_path..'/Cockpit/Scripts/' , nil , current_mod_path..'/comm.lua')

2) Copy FLIR folder to (Saved Games\MODNAME\Cockpit\Scripts).

3) Add the contents of FLIR\command_defs.lua to the mod's command_defs.lua

4) Add the contents of FLIR\device_init.lua to the mod's device_init.lua

5) Add the contents of input_keyboard_default.lua to your keyboard and joystick default.lua 
as desired.

6) Create a ceTexPoly with material = "render_target_1" on your screen indicator, 
similar to FLIR\page.lua contents, but with is_visible = true

7) Configure FLIR commands and start the mod.

8) For onscreen telemetry from FLIR, CMFD_FLIR.lua and flir_device.lua can be used as a reference.

LR::avSimplestWeaponSystem commands:

dev:select_station(station)
dev:set_laser_code(code)                    -- selects the laser code to be used by launch_station
dev:launch_station(station)                 -- will set GBU laser code uppon launch
dev:set_ccrp_target(lat_m, alt_m, lon_m)    -- selects the ccrp target coordinates
dev:update_ccrp_sight()                     -- calculate seconds left until ccrp launch

