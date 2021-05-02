local DTE_TEXT = get_param_handle("CMFD_DTE_TEXT")
local DTE_DVR_STATE = get_param_handle("CMFD_DTE_DVR_STATE")

local CMFD_DTE_DVR_STATE_IDS = {
    OFF = 0,
    DTE = 1,
    BIT = 2
}

CMFD_DTE_DVR_STATE_IDS.OFF = "OFF"
CMFD_DTE_DVR_STATE_IDS.DTE = "DTE"
CMFD_DTE_DVR_STATE_IDS.BIT = "BIT"

local mission = ""
local pilot = ""
local copilot = ""
local dtcid = ""

local cmfd_dte_dvr_state = CMFD_DTE_DVR_STATE_IDS.DTE
DTE_DVR_STATE:set(cmfd_dte_dvr_state)

-- INV: Selected or loading
-- BOXED: Loaded
-- BLINKING: Failed
-- NORMAL: Ready to load
-- BLANK: DVR OFF OR BIT RUNNING
function update_dte()
    local text = ""

    -- Load DTC files.
    dofile(LockOn_Options.script_path.."../../Mission/GENERAL.lua")

    dtcid = string.sub(GENERAL.General.DTC_Name:upper(),1,12)
    pilot = string.sub(GENERAL.General.Pilot_1_Name:upper(),1,12)
    copilot = string.sub(GENERAL.General.Pilot_2_Name:upper(),1,12)
    mission = string.sub(GENERAL.General.Mission_Name:upper(),1,12)

    text = text .. "MISSION : " .. string.format("%-12s", mission) .. "\n\n"
    text = text .. "  PILOT : " .. string.format("%-12s", pilot) .. "\n\n"
    text = text .. "COPILOT : " .. string.format("%-12s", copilot) .. "\n\n"
    text = text .. " DTC ID : " .. string.format("%-12s", dtcid)

    DTE_TEXT:set(text)
end

local function load_mpd()
    -- Waypoints (100) (lat, lng, elev, time, oap) (except 0)
    -- GPS delta zone
    -- DA
    -- DH
    -- BINGO, JOKER, HOMEPLATE
    -- G MAX
    -- MIN SPEED, MAX SPEED, MAX MACH
    -- AOA
    -- SLOT (lat, lng, elev, hdg)
    -- DTK
    -- TIP
    -- TOD
    -- MAG DEC
    -- Weight
end

local function load_db()
    -- COM1
    -- DL config
    -- TDMA ID
    -- Formation names
    -- DL messages
end

local function load_prog()
    -- 5 Profiles (mode, weapon, sgl/pair/salvo, N/T/N+T, rp, ripple)
    -- Rebatimento
    -- DX, DY, MBAL
    -- Wingspan
    -- Range rate
    -- A/A GUN mode
end

local function load_inv()
    -- 5 stations (type and amount of weapons)
    -- Rack ID
    -- Machinegun amount
    -- Strafe limit
    -- Flir installation state
end

local function load_hsd()
    -- Contact line (5 points)
    -- Avoid areas (30)

end

local function load_sim_inv()
    -- 5 stations (type and amount of weapons)
    -- Rack ID
    -- Machinegun amount
end

local function load_msmd()
    -- Load all mastermodes and select current mastermode
end

local function load_all()
    load_mpd()
    load_db()
    load_prog()
    load_inv()
    load_hsd()
    load_sim_inv()
end

function SetCommandDte(command,value, CMFD)
    if value == 1 then
        if (command==device_commands.CMFD1OSS3 or command==device_commands.CMFD2OSS3) then
            -- TODO Stop data transfer
        elseif (command==device_commands.CMFD1OSS4 or command==device_commands.CMFD2OSS4) then
            -- TODO QCHK format
        elseif (command==device_commands.CMFD1OSS5 or command==device_commands.CMFD2OSS5) then
            load_all()
        elseif (command==device_commands.CMFD1OSS7 or command==device_commands.CMFD2OSS7) then
            load_sim_inv()
        elseif (command==device_commands.CMFD1OSS11 or command==device_commands.CMFD2OSS11) then
            load_msmd()
        elseif (command==device_commands.CMFD1OSS24 or command==device_commands.CMFD2OSS24) then
            load_hsd()
        elseif (command==device_commands.CMFD1OSS25 or command==device_commands.CMFD2OSS25) then
            load_inv()
        elseif (command==device_commands.CMFD1OSS26 or command==device_commands.CMFD2OSS26) then
            load_prog()
        elseif (command==device_commands.CMFD1OSS27 or command==device_commands.CMFD2OSS27) then
            load_db()
        elseif (command==device_commands.CMFD1OSS28 or command==device_commands.CMFD2OSS28) then
            load_mpd()
        end
    end
end

function post_initialize_dte()

end