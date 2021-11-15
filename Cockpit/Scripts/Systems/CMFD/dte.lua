dofile(LockOn_Options.script_path.."CMFD/CMFD_DTE_ID_defs.lua")

local DTE_TEXT = get_param_handle("CMFD_DTE_TEXT")

local DTE_FORMAT = get_param_handle("CMFD_DTE_FORMAT")
local DTE_DVR_STATE = get_param_handle("CMFD_DTE_DVR_STATE")
local DTE_MPD_STATE = get_param_handle("CMFD_DTE_MPD_STATE")
local DTE_DB_STATE = get_param_handle("CMFD_DTE_DB_STATE")
local DTE_PROG_STATE = get_param_handle("CMFD_DTE_PROG_STATE")
local DTE_INV_STATE = get_param_handle("CMFD_DTE_INV_STATE")
local DTE_HSD_STATE = get_param_handle("CMFD_DTE_HSD_STATE")
local DTE_SIM_INV_STATE = get_param_handle("CMFD_DTE_SIM_INV_STATE")
local DTE_MSMD_STATE = get_param_handle("CMFD_DTE_MSMD_STATE")

local DTE_MPD_BLINK = get_param_handle("CMFD_DTE_MPD_BLINK")
local DTE_DB_BLINK = get_param_handle("CMFD_DTE_DB_BLINK")
local DTE_PROG_BLINK = get_param_handle("CMFD_DTE_PROG_BLINK")
local DTE_INV_BLINK = get_param_handle("CMFD_DTE_INV_BLINK")
local DTE_HSD_BLINK = get_param_handle("CMFD_DTE_HSD_BLINK")
local DTE_SIM_INV_BLINK = get_param_handle("CMFD_DTE_SIM_INV_BLINK")
local DTE_MSMD_BLINK = get_param_handle("CMFD_DTE_MSMD_BLINK")

local UFCP_LMT_MAX_G = get_param_handle("UFCP_LMT_MAX_G")
local UFCP_LMT_MIN_VEL = get_param_handle("UFCP_LMT_MIN_VEL")
local UFCP_LMT_MAX_VEL = get_param_handle("UFCP_LMT_MAX_VEL")
local UFCP_LMT_MAX_AOA = get_param_handle("UFCP_LMT_MAX_AOA")
local UFCP_LMT_MAX_AOA_FLAPS = get_param_handle("UFCP_LMT_MAX_AOA_FLAPS")
local UFCP_LMT_MAX_MACH = get_param_handle("UFCP_LMT_MAX_MACH")

local UFCP_DAH_BARO = get_param_handle("UFCP_DAH_BARO")
local UFCP_DAH_RALT = get_param_handle("UFCP_DAH_RALT")

local UFCP_WS = get_param_handle("UFCP_WS")

local EICAS_FUEL_JOKER = get_param_handle("EICAS_FUEL_JOKER")

-- TODO get bingo and hmpt from UFCP FUEL
local UFCP_FUEL_BINGO = get_param_handle("UFCP_FUEL_BINGO")
local UFCP_FUEL_HMPT = get_param_handle("UFCP_FUEL_HMPT")

local mission = ""
local pilot = ""
local copilot = ""
local dtcid = ""

local format = CMFD_DTE_FORMAT_IDS.DTE

local dvr_state = CMFD_DTE_DVR_STATE_IDS.DTE
local mpd_state = CMFD_DTE_STATE_IDS.UNLOADED
local db_state = CMFD_DTE_STATE_IDS.UNLOADED
local prog_state = CMFD_DTE_STATE_IDS.UNLOADED
local inv_state = CMFD_DTE_STATE_IDS.UNLOADED
local hsd_state = CMFD_DTE_STATE_IDS.UNLOADED
local sim_inv_state = CMFD_DTE_STATE_IDS.UNLOADED
local msmd_state = CMFD_DTE_STATE_IDS.UNLOADED

local mission_dir

-- TESTING
--local terrainVersion          = get_terrain_related_data("edterrainVersion") or 3.0
local theatre
local terrainAirdromes = get_terrain_related_data("Airdromes") or {};
--local terrain_path = get_terrain_related_data("KNEEBOARD") or "none"
--local user_path    = lfs.writedir().."Mission"
--local unit_name    = get_aircraft_type()

-- INV: Selected or loading
-- BOXED: Loaded
-- BLINKING: Failed
-- NORMAL: Ready to load
-- BLANK: DVR OFF OR BIT RUNNING

local function read_ADD_RINV()
    dofile(mission_dir .. "ADD_RINV.lua")

    -- TODO read data
    error()
end

local function read_ADD_SINV()
    dofile(mission_dir .. "ADD_SINV.lua")

    -- TODO read data
    error()
end

local function read_ADF()
    dofile(mission_dir .. "ADF.lua")

    -- TODO read data
    error()
end

local function read_AIRFIELD()
    dofile(mission_dir .. "AIRFIELD.lua")

    -- TODO read data
    error()
end

local function read_ALN_SLOT()
    dofile(mission_dir .. "ALN_SLOT.lua")

    -- TODO read data
    error()
end

local function read_AVD_AREA()
    dofile(mission_dir .. "AVD_AREA.lua")

    -- TODO read data
    error()
end

local function read_CNT_LINE()
    dofile(mission_dir .. "CNT_LINE.lua")

    -- TODO read data
    error()
end

local function read_COMM1()
    dofile(mission_dir .. "COMM1.lua")

    -- TODO read data
    error()
end

local function read_DL_PTEXT()
    dofile(mission_dir .. "DL_PTEXT.lua")

    -- TODO read data
    error()
end

local function read_DL_SETUP()
    dofile(mission_dir .. "DL_SETUP.lua")

    -- TODO read data
    error()
end

local function read_FLT_AREA()
    dofile(mission_dir .. "FLT_AREA.lua")

    -- TODO read data
    error()
end

local function read_GENERAL()
    dtcid = ""
    pilot = ""
    copilot = ""
    mission = ""
    
    dofile(mission_dir .. "GENERAL.lua")

    dtcid = string.sub(GENERAL.General.DTC_Name:upper(),1,12)
    pilot = string.sub(GENERAL.General.Pilot_1_Name:upper(),1,12)
    copilot = string.sub(GENERAL.General.Pilot_2_Name:upper(),1,12)
    mission = string.sub(GENERAL.General.Mission_Name:upper(),1,12)
end

local function read_IFF()
    dofile(mission_dir .. "IFF.lua")

    -- TODO read data
    error()
end

local function read_MSMD()
    dofile(mission_dir .. "MSMD.lua")

    -- TODO read data
    error()
end

local function read_NAV_SYS()
    dofile(mission_dir .. "NAV_SYS.lua")

    -- TODO read data
    error()
end

local function read_PROG()
    dofile(mission_dir .. "PROG.lua")

    -- TODO read data
    error()
end

local function read_REAL_INV()
    dofile(mission_dir .. "REAL_INV.lua")

    -- TODO read data
    error()
end

local function read_SIM_INV()
    dofile(mission_dir .. "SIM_INV.lua")

    -- TODO read data
    error()
end

local function read_SMS_MISC()
    dofile(mission_dir .. "SMS_MISC.lua")

    -- TODO read data
    error()
end

local function read_VOR()
    dofile(mission_dir .. "VOR.lua")

    -- TODO read data
    error()
end

local function read_WARNING()
    dofile(mission_dir .. "WARNING.lua")

    -- TODO read data
    error()
end

local function read_WAYPOINT()
    dofile(mission_dir .. "WAYPOINT.lua")

    -- TODO read data
    error()
end

function update_dte()
    local text = ""

    -- Load DTC files.
    pcall(read_GENERAL)

    if format == CMFD_DTE_FORMAT_IDS.DTE then
        text = text .. "MISSION : " .. string.format("%-12s", mission) .. "\n\n"
        text = text .. "  PILOT : " .. string.format("%-12s", pilot) .. "\n\n"
        text = text .. "COPILOT : " .. string.format("%-12s", copilot) .. "\n\n"
        text = text .. " DTC ID : " .. string.format("%-12s", dtcid)
    elseif format == CMFD_DTE_FORMAT_IDS.QCHK then
        text = text .. "MAG G        " .. string.format("%4s", string.format("%3.1f", UFCP_LMT_MAX_G:get())) .. "\n\n"
        text = text .. "MAX AOA F UP " .. string.format("%4s", string.format("%4.1f", UFCP_LMT_MAX_AOA:get())) .. "\n\n"
        text = text .. "MAX AOA F DN " .. string.format("%4s", string.format("%4.1f", UFCP_LMT_MAX_AOA_FLAPS:get())) .. "\n\n"
        text = text .. "MAX VEL      " .. string.format("%4s", UFCP_LMT_MAX_VEL:get()) .. "\n\n"
        text = text .. "MAX MACH     " .. string.format("%4s", string.format("%4.2f", UFCP_LMT_MAX_MACH:get())) .. "\n\n"
        text = text .. "MIN VEL      " .. string.format("%4s", UFCP_LMT_MIN_VEL:get()) .. "\n\n"

        text = text .. "\n\n"

        text = text .. "DA\\H BARO    " .. string.format("%4s", UFCP_DAH_BARO:get()) .. "\n\n"
        text = text .. "DA\\H RALT    " .. string.format("%4s", UFCP_DAH_RALT:get()) .. "\n\n"

        text = text .. "\n\n"

        text = text .. "WING SPAN    " .. string.format("%4s", string.format("%4.1f", UFCP_WS:get())) .. "\n\n"

        text = text .. "\n\n"

        text = text .. "JOKER        " .. string.format("%4s", EICAS_FUEL_JOKER:get()) .. "\n\n"
        text = text .. "BINGO        " .. string.format("%4s", UFCP_FUEL_BINGO:get()) .. "\n\n"
        text = text .. "HMPT         " .. string.format("%4s", UFCP_FUEL_HMPT:get()) .. "\n\n"
    end

    DTE_FORMAT:set(format)
    DTE_DVR_STATE:set(dvr_state)
    DTE_MPD_STATE:set(mpd_state)
    DTE_DB_STATE:set(db_state)
    DTE_PROG_STATE:set(prog_state)
    DTE_INV_STATE:set(inv_state)
    DTE_HSD_STATE:set(hsd_state)
    DTE_SIM_INV_STATE:set(sim_inv_state)
    DTE_MSMD_STATE:set(msmd_state)

    -- Make OSS text blink if failed
    local interval = math.floor(2 * get_absolute_model_time() % 2)

    DTE_MPD_BLINK:set(mpd_state == CMFD_DTE_STATE_IDS.FAILED and interval == 0 and 1 or 0)
    DTE_DB_BLINK:set(db_state == CMFD_DTE_STATE_IDS.FAILED and interval == 0 and 1 or 0)
    DTE_PROG_BLINK:set(prog_state == CMFD_DTE_STATE_IDS.FAILED and interval == 0 and 1 or 0)
    DTE_INV_BLINK:set(inv_state == CMFD_DTE_STATE_IDS.FAILED and interval == 0 and 1 or 0)
    DTE_HSD_BLINK:set(hsd_state == CMFD_DTE_STATE_IDS.FAILED and interval == 0 and 1 or 0)
    DTE_SIM_INV_BLINK:set(sim_inv_state == CMFD_DTE_STATE_IDS.FAILED and interval == 0 and 1 or 0)
    DTE_MSMD_BLINK:set(msmd_state == CMFD_DTE_STATE_IDS.FAILED and interval == 0 and 1 or 0)

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
    if pcall(read_WAYPOINT) and
        pcall(read_WARNING) and 
        pcall(read_NAV_SYS) and 
        pcall(read_ALN_SLOT) and 
        pcall(read_AIRFIELD)
    then
        mpd_state = CMFD_DTE_STATE_IDS.LOADED
    else
        mpd_state = CMFD_DTE_STATE_IDS.FAILED
    end
end

local function load_db()
    -- COM1
    -- DL config
    -- TDMA ID
    -- Formation names
    -- DL messages

    if pcall(read_COMM1) and
        pcall(read_DL_PTEXT) and 
        pcall(read_DL_SETUP)
    then
        db_state = CMFD_DTE_STATE_IDS.LOADED
    else
        db_state = CMFD_DTE_STATE_IDS.FAILED
    end
end

local function load_prog()
    -- 5 Profiles (mode, weapon, sgl/pair/salvo, N/T/N+T, rp, ripple)
    -- Rebatimento
    -- DX, DY, MBAL
    -- Wingspan
    -- Range rate
    -- A/A GUN mode

    if pcall(read_PROG) and
        pcall(read_SMS_MISC)
    then
        prog_state = CMFD_DTE_STATE_IDS.LOADED
    else
        prog_state = CMFD_DTE_STATE_IDS.FAILED
    end
end

local function load_inv()
    -- 5 stations (type and amount of weapons)
    -- Rack ID
    -- Machinegun amount
    -- Strafe limit
    -- Flir installation state

    if pcall(read_ADD_RINV) and
        pcall(read_REAL_INV)
    then
        inv_state = CMFD_DTE_STATE_IDS.LOADED
    else
        inv_state = CMFD_DTE_STATE_IDS.FAILED
    end
end

local function load_hsd()
    -- Contact line (5 points)
    -- Avoid areas (30)

    if pcall(read_FLT_AREA) and
        pcall(read_CNT_LINE) and
        pcall(read_AVD_AREA) 
    then
        hsd_state = CMFD_DTE_STATE_IDS.LOADED
    else
        hsd_state = CMFD_DTE_STATE_IDS.FAILED
    end
end

local function load_sim_inv()
    -- 5 stations (type and amount of weapons)
    -- Rack ID
    -- Machinegun amount

    if pcall(read_ADD_SINV) and
        pcall(read_SIM_INV)
    then
        sim_inv_state = CMFD_DTE_STATE_IDS.LOADED
    else
        sim_inv_state = CMFD_DTE_STATE_IDS.FAILED
    end
end

local function load_msmd()
    -- Load all mastermodes and select current mastermode

    if pcall(read_MSMD)
    then
        msmd_state = CMFD_DTE_STATE_IDS.LOADED
    else
        msmd_state = CMFD_DTE_STATE_IDS.FAILED
    end
end

local function load_all()
    load_mpd()
    load_db()
    load_prog()
    load_inv()
    load_hsd()
    load_sim_inv()
end

local function clear_all()
    if mpd_state < CMFD_DTE_STATE_IDS.LOADED then mpd_state = CMFD_DTE_STATE_IDS.UNLOADED end
    if db_state < CMFD_DTE_STATE_IDS.LOADED then db_state = CMFD_DTE_STATE_IDS.UNLOADED end
    if prog_state < CMFD_DTE_STATE_IDS.LOADED then prog_state = CMFD_DTE_STATE_IDS.UNLOADED end
    if inv_state < CMFD_DTE_STATE_IDS.LOADED then inv_state = CMFD_DTE_STATE_IDS.UNLOADED end
    if hsd_state < CMFD_DTE_STATE_IDS.LOADED then hsd_state = CMFD_DTE_STATE_IDS.UNLOADED end
    if sim_inv_state < CMFD_DTE_STATE_IDS.LOADED then sim_inv_state = CMFD_DTE_STATE_IDS.UNLOADED end
    if msmd_state < CMFD_DTE_STATE_IDS.LOADED then msmd_state = CMFD_DTE_STATE_IDS.UNLOADED end
end

function SetCommandDte(command,value, CMFD)
    if value == 1 then
        if (command==device_commands.CMFD1OSS3 or command==device_commands.CMFD2OSS3) then
            clear_all()
        elseif (command==device_commands.CMFD1OSS4 or command==device_commands.CMFD2OSS4) then
            format = 1 - format
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
    theatre = get_terrain_related_data("name")

    -- I can't get the terrain name or kneeboard from Syria. Syria has an airport called OS57, so I'll use it as reference.
    if theatre == nil and terrainAirdromes then
        for i,airdrome in pairs(terrainAirdromes) do
            local code = airdrome.code or string.sub(airdrome.id,1,4)
            if code == "OS57" then
                theatre = "Syria"
                break
            end
        end
    end
    if theatre == nil then
        theatre = "none"
    end

    -- Set mission dir. It will look for the theatre dir inside mission, otherwise will load the files inside mission. 
    -- Is this the ideal way? Or should it be in the user dir? People should have their own mission files, although
    -- I doubt anyone is gonna make them.

    if theatre ~= "none" then
        mission_dir = LockOn_Options.script_path.."../../Mission/" .. theatre .. "/"
    else
        mission_dir = LockOn_Options.script_path.."../../Mission/"
    end
end