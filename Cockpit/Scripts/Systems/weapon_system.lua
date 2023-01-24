--[[
This is the Lua file for LR::avSimplestWeaponSystem.
Example:
creators[devices.WEAPON_SYSTEM]   = {"LR::avSimplestWeaponSystem"  ,LockOn_Options.script_path.."Systems/weapon_system.lua", {devices.CMFD}}

Parameters:
WPN_MASTER_MODE             -> 0: None, 1: Normal, 2: Air-Air, 3: Air-Ground.
WPN_AG_MODE                 -> 0: Manual, 1: CCIP, 2: CCRP, 3: DTOS, 4: Internal Gun Manual, 5: Internal Gun CCIP.
WPN_ALT_MODE                -> 0: Waypoint altitude used by CCIP mode, 1: Radar Altimeter altitude used by CCIP mode.
WPN_AA_MODE                 -> Not implemented.

WPN_SELECTED_QTY            -> Selected weapon quantity across all pylons.
WPN_SELECTED_TYPE           -> Selected weapon type. 0: None, 1: Missile, 2: Bomb, 3: Rocket, 4: Gun.
WPN_SELECTED_NAME           -> Selected weapon short name.
WPN_POS_N_SEL               -> Selection State of Pylon N, N=1 to Pylon Count. 0: Not selected, 1: Selected. 2: Selected but Master Arm is Off.
WPN_POS_N_TEXT              -> Weapon short name for Pylon N, N=1 to Pylon Count.
WPN_POS_N_CONTAINER_TEXT    -> Weapon container short name for Pylon N, N=1 to Pylon Count. Currently not implemented and repeats WPN_POS_N_TEXT.
WPN_GUNS_N                  -> Number of rounds in internal Gun N, N=1 to GUN_COUNT.
WPN_GUNS_N_SEL              -> Selection State of internal Gun N, N=1 to GUN_COUNT. 0: Not selected, 1: Selected. 2: Selected but Master Arm is Off.

WPN_CCIP_AZ                 -> Piper azimuth relative to the plane position. In radians, limited by az_min, az_max
WPN_CCIP_EL                 -> Piper elevation relative to the plane position. In radians, limited by el_min, el_max.
WPN_CCIP_STATE              -> -1: Off, 0: Normal, 1: Off-limits (az_min, az_max, el_max), 2: Delay - Off-limit (el_min), 3: Delayed (mode was 2 and WRB is held down)

WPN_TIME_TO_IMPACT          -> 
WPN_TIME_MAX_RANGE          -> 

Functions:
local dev = GetSelf()
dev:register_wpn_name(GUID, short_name) -> weapon short name that will be published on WPN_POS_N_TEXT and WPN_SELECTED_NAME.
dev:set_ccip_limits(az_min, az_max, el_min, el_max) -> In radians. Default: (-1000, 1000, -1000, 1000). See WPN_CCIP_*.
dev:get_master_mode()        -> See WPN_MASTER_MODE.
dev:set_master_mode(MasterMode) -> See WPN_MASTER_MODE.
dev:get_ag_mode()           -> See WPN_AG_MODE.
dev:set_ag_mode(AGMode)     -> See WPN_AG_MODE.
dev:get_alt_mode()          -> See WPN_ALT_MODE.
dev:set_alt_mode(AltMode)   -> See WPN_ALT_MODE.

dev:set_ccrp_target(x, y, z) -> 
dev:set_laser_code(code)    -> Sets laser code that will be used when releasing LGB. Default: 1688.
dev:select_station(N)       -> Selects weapon on pylon N.
dev:launch_station(N, S)    -> Launchs weapon on pylon N, subposition S, taking care of smart weapons configurarion like laser code. Not needed if iCommandPlanePickleOn is used.
and others defined by avSimpleWeaponSystem.

Keys: 
iCommandPlanePickleOn       -> 
iCommandPlanePickleOff      ->
iCommandPlaneFire           -> Fires internal gun.
iCommandPlaneFireOff        -> Stops firing internal gun.
iCommandSwitchMasterArm     -> Switches Master Arm on (value > 0) and off (value = 0).
iCommandPlaneChangeWeapon   -> Selects next weapon for selected Master Mode.
iCommandPlaneIncreaseBase_Distance ->
iCommandPlaneDecreaseBase_Distance ->
iCommandPlaneStopBase_Distance ->
and others defined by avSimpleWeaponSystem.

--]]

dofile(LockOn_Options.common_script_path.."devices_defs.lua")
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")
dofile(LockOn_Options.script_path.."utils.lua")

dofile(LockOn_Options.script_path.."Systems/avionics_api.lua")

startup_print("weapon: load")

show_param_handles_list()

local dev = GetSelf()

dofile(LockOn_Options.script_path.."dump.lua")

local update_time_step = 0.02 --update will be called 50 times per second
make_default_activity(update_time_step)

local sensor_data = get_base_data()

local wpn_search_sequence = {
    {1, 5, 2, 4, 3},
    {5, 2, 4, 3, 1},
    {4, 3, 1, 5, 2},
    {1, 5, 2, 4, 3},
    {3, 1, 5, 2, 4},
    {2, 4, 3, 1, 5},
}

WPN_MASS = get_param_handle("WPN_MASS")
WPN_LATEARM = get_param_handle("WPN_LATEARM")

dev:register_wpn_name("{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}", "AIM9L")
dev:register_wpn_name("{A-29B TANK}", "TANK")
dev:register_wpn_name("{DB769D48-67D7-42ED-A2BE-108D566C8B1E}", "GBU12")
dev:register_wpn_name("{00F5DAC4-0466-4122-998F-B1A298E34113}", "M117")
dev:register_wpn_name("{FD90A1DC-9147-49FA-BF56-CB83EF0BD32B}", "LAU61")
dev:register_wpn_name("{A021F29D-18AB-4d3e-985C-FC9C60E35E9E}", "LAU68")
dev:register_wpn_name("{4F977A2A-CD25-44df-90EF-164BFA2AE72F}", "LAU68")
dev:register_wpn_name("{0D33DDAE-524F-4A4E-B5B8-621754FE3ADE}", "GBU16")
dev:register_wpn_name("{GBU_49}", "GBU49")
dev:register_wpn_name("{CBU_105}", "CBU105")
dev:register_wpn_name("AGM114x2_OH_58", "AGM114")
dev:register_wpn_name("{BCE4E030-38E9-423E-98ED-24BE3DA87C32}", "MK82")
dev:register_wpn_name("{5335D97A-35A5-4643-9D9B-026C75961E52}", "CBU97")
dev:register_wpn_name("{Mk82SNAKEYE}", "MK82SE")
dev:register_wpn_name("{LAU_61R}", "LAU61R")
dev:register_wpn_name("{90321C8E-7ED1-47D4-A160-E074D5ABD902}", "MK81")
dev:register_wpn_name("{ADD3FAE1-EBF6-4EF9-8EFC-B36B5DDF1E6B}", "MK20RE")

dev:set_ccip_limits(math.rad(-7.6), math.rad(7.6), math.rad(-7.8), math.rad(9.2)) -- (az_min, az_max, el_min, el_max) in radians

dev:set_pylon_order({1, 5, 2, 4, 3})

local master_arm = true

function update()
    local master_mode = get_avionics_master_mode()

    if master_mode == AVIONICS_MASTER_MODE_ID.A_G then
        local ag_mode = dev:get_ag_mode()
        if ag_mode == 1 then
            set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.CCIP)
        elseif ag_mode == 2 then
            set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.CCRP)
        elseif ag_mode == 3 then
            set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.DTOS)
        else
            set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.MAN)
        end
    end

    local alt_mode = dev:get_alt_mode()
    if master_mode == AVIONICS_MASTER_MODE_ID.CCIP and alt_mode == 1 then
        set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.CCIP_R)
    elseif master_mode == AVIONICS_MASTER_MODE_ID.CCIP_R and alt_mode == 0 then
        set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.CCIP)
    elseif master_mode == AVIONICS_MASTER_MODE_ID.CCRP and alt_mode == 1 then
        set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.CCRP_R)
    elseif master_mode == AVIONICS_MASTER_MODE_ID.CCRP_R and alt_mode == 0 then
        set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.CCRP)
    elseif master_mode == AVIONICS_MASTER_MODE_ID.DTOS and alt_mode == 1 then
        set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.DTOS_R)
    elseif master_mode == AVIONICS_MASTER_MODE_ID.DTOS_R and alt_mode == 0 then
        set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.DTOS)
    end

    local master_arm_new = WPN_MASS:get(value) == 1 and WPN_LATEARM:get() == 1 and (get_avionics_master_mode_aa(master_mode) or get_avionics_master_mode_ag(master_mode))
    if master_arm_new ~= master_arm then
        master_arm = master_arm_new
        dev:SetCommand(Keys.iCommandSwitchMasterArm, master_arm and 1 or 0)
    end

end


function post_initialize()
    startup_print("weapon: postinit start")
    local birth = LockOn_Options.init_conditions.birth_place
    if birth=="GROUND_HOT" then
    elseif birth=="AIR_HOT" then
    elseif birth=="GROUND_COLD" then
    end

    dev:performClickableAction(device_commands.Mass, 0, true)
    dev:performClickableAction(device_commands.LateArm, -1, true)

    sndhost = create_sound_host("COCKPIT_ARMS","HEADPHONES",0,0,0)
    aim9seek = sndhost:create_sound("Aircrafts/Cockpits/AIM9")
    aim9lock = sndhost:create_sound("Aircrafts/Cockpits/SidewinderLow")
    startup_print("weapon: postinit end")

end

local iCommandPlaneDropFlareOnce = 357
local iCommandPlaneDropChaffOnce = 358
local iCommandPlaneChangeWeapon = 101

dev:listen_command(iCommandPlaneDropFlareOnce)
dev:listen_command(iCommandPlaneDropChaffOnce)

dev:listen_command(Keys.iCommandPlanePickleOn)
dev:listen_command(Keys.iCommandPlanePickleOff)

dev:listen_command(device_commands.Mass)
dev:listen_command(device_commands.LateArm)
dev:listen_command(device_commands.Salvo)
dev:listen_command(device_commands.WPN_SELECT_STO)
dev:listen_command(device_commands.WPN_AG_LAUNCH_OP_STEP)
dev:listen_command(Keys.StickStep)
dev:listen_command(Keys.GunSelDist)
dev:listen_command(Keys.GunRearm)
dev:listen_command(Keys.Cage)
dev:listen_command(Keys.TDCX)
dev:listen_command(Keys.TDCY)
dev:listen_command(Keys.JettisonWeapons)

function SetCommand(command,value)
    debug_message_to_user("weapon: command "..tostring(command).." = "..tostring(value))
    if command == device_commands.WPN_AA_STEP or command == device_commands.WPN_AG_STEP then
        dev:SetCommand(iCommandPlaneChangeWeapon,1)
    elseif command == device_commands.WPN_AG_LAUNCH_OP_STEP then
    elseif command == device_commands.WPN_SELECT_STO then
    elseif command == device_commands.WPN_AA_SIGHT_STEP then 
    elseif command == device_commands.WPN_AA_RR_SRC_STEP then 
    elseif command == device_commands.WPN_AA_SLV_SRC_STEP then 
    elseif command == device_commands.WPN_AA_COOL_STEP then 
    elseif command == device_commands.WPN_AA_SCAN_STEP then 
    elseif command == device_commands.WPN_AA_LIMIT_STEP then 
    elseif command == device_commands.Mass then
        WPN_MASS:set(value)
    elseif command == device_commands.LateArm then
        WPN_LATEARM:set(value)
    elseif command == Keys.JettisonWeapons then
        dev:performClickableAction(device_commands.Salvo, value, true)
    elseif command == device_commands.Salvo then
    elseif command == Keys.StickStep then
    elseif command == Keys.GunSelDist and value == 1 then
    elseif command == iCommandPlaneDropFlareOnce then
    elseif command == iCommandPlaneDropChaffOnce then
    end
end

dev:listen_event("WeaponRearmComplete")
function CockpitEvent(command, val)
    if command == "WeaponRearmComplete" then
    end
end

function on_launch(var)
    print_message_to_user("on_launch: " .. tostring(var) ..".")
end

startup_print("weapon: load end")
need_to_be_closed = false -- close lua state after initialization

