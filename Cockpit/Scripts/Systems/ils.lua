dofile(LockOn_Options.common_script_path.."devices_defs.lua")
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")

package.cpath 			= package.cpath..";".. LockOn_Options.script_path.. "..\\..\\bin\\?.dll"
require('avSimplestWeaponSystem')

local dev 	    = GetSelf()

local update_time_step = 0.05 

if make_default_activity then
    make_default_activity(update_time_step)
end

local NAV_ILS_GS_VALID = get_param_handle("NAV_ILS_GS_VALID")
local NAV_ILS_GS_DEV = get_param_handle("NAV_ILS_GS_DEV")
local NAV_ILS_LOC_VALID = get_param_handle("NAV_ILS_LOC_VALID")
local NAV_ILS_LOC_DEV = get_param_handle("NAV_ILS_LOC_DEV")
local ADHSI_ILS_FREQ = get_param_handle("ADHSI_ILS_FREQ")

local ils_freq = 0;

function update()
    local glideslopeValid = avSimplestILS.isGlideslopeValid()
    local localizerValid = avSimplestILS.isLocalizerValid()
    local glideslopeDeviation = avSimplestILS.getGlideslopeDeviation()
    local localizerDeviation = avSimplestILS.getLocalizerDeviation()
    local ilsOn = avSimplestILS.getElecPower()
    NAV_ILS_GS_VALID:set(glideslopeValid and 1 or 0)
    NAV_ILS_GS_DEV:set(glideslopeDeviation)
    NAV_ILS_LOC_VALID:set(localizerValid and 1 or 0)
    NAV_ILS_LOC_DEV:set(localizerDeviation)
    local ils_freq_new = ADHSI_ILS_FREQ:get()
    if ils_freq ~= ils_freq_new then
        ils_freq = ils_freq_new
        avSimplestILS.setFrequencyMHz(math.floor(ils_freq))
        avSimplestILS.setFrequencyKHz(math.floor((ils_freq%1)*1000))
    end

    -- print_message_to_user("avILS On: ".. tostring(ilsOn) .." GV: " .. tostring(glideslopeValid) .. " LV: " .. tostring(localizerValid))
    -- print_message_to_user("avILS GD: " .. glideslopeDeviation .. " LD: " .. localizerDeviation)
    -- print_message_to_user("avILS GF: " .. avSimplestILS.getGlideslopeFrequency() .. " LF: " .. avSimplestILS.getLocalizerFrequency())
end

function post_initialize()
    avSimplestILS.Setup(devices.ILS, devices.ELECTRIC_SYSTEM)
    avSimplestILS.setElecPower(true)
end

function SetCommand(command,value)
    print_message_to_user("SetCommand in avILS: "..tostring(command).."="..tostring(value))
end


need_to_be_closed = false

