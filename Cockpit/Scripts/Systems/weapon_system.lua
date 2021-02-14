dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")

startup_print("weapon: load")

local dev = GetSelf()

local update_time_step = 0.02 --update will be called 50 times per second
make_default_activity(update_time_step)

local sensor_data = get_base_data()

function update()
end

function post_initialize()
    startup_print("weapon: postinit start")
    local birth = LockOn_Options.init_conditions.birth_place

    if birth=="GROUND_HOT" then
    elseif birth=="AIR_HOT" then
    elseif birth=="GROUND_COLD" then
    end
    dev:performClickableAction(device_commands.LateArmMass, 0, true)
    dev:performClickableAction(device_commands.LateArm, -1, true)
    startup_print("weapon: postinit end")
end


PlaneModeNAV                    = 105
PlaneModeBVR                    = 106
PlaneModeVS                     = 107
PlaneModeBore                   = 108
PlaneModeGround                 = 111

local iCommandPlaneWingtipSmokeOnOff = 78
local iCommandPlaneJettisonWeapons = 82
local iCommandPlaneFire = 84
local iCommandPlaneFireOff = 85
local iCommandPlaneChangeWeapon = 101
local iCommandActiveJamming = 136
local iCommandPlaneJettisonFuelTanks = 178
local iCommandPlanePickleOn = 350
local iCommandPlanePickleOff = 351
local iCommandPlaneDropFlareOnce = 357
local iCommandPlaneDropChaffOnce = 358
local iCommandPlaneChangeTarget = 102


dev:listen_command(PlaneModeNAV)
dev:listen_command(PlaneModeBVR)
dev:listen_command(PlaneModeVS)
dev:listen_command(PlaneModeBore)
dev:listen_command(PlaneModeGround)

dev:listen_command(iCommandPlaneChangeTarget)
dev:listen_command(iCommandPlaneWingtipSmokeOnOff)
dev:listen_command(iCommandPlaneJettisonWeapons)
dev:listen_command(iCommandPlaneFire)
dev:listen_command(iCommandPlaneFireOff)
dev:listen_command(iCommandPlaneChangeWeapon)
dev:listen_command(iCommandActiveJamming)
dev:listen_command(iCommandPlaneJettisonFuelTanks)
dev:listen_command(iCommandPlanePickleOn)
dev:listen_command(iCommandPlanePickleOff)
dev:listen_command(iCommandPlaneDropFlareOnce)
dev:listen_command(iCommandPlaneDropChaffOnce)

function SetCommand(command,value)
    print_message_to_user("weapon: command "..tostring(command).." = "..tostring(value))
    if command==device_commands.EngineStart then
    elseif command == iCommandEnginesStart then
    elseif command == iCommandEnginesStop then
        -- dev:performClickableAction(device_commands.EngineStart, 0, true)
    end
end


startup_print("weapon: load end")
need_to_be_closed = false -- close lua state after initialization


