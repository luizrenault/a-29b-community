
local STHD_time = 30
local ALGN_time = 240
local ALGN_COURSE_time = 90
local OFF_time = 0
local ELAPSED_time = 0

local EGI_state = UFCP_EGI_STATE_IDS.OFF
local EGI_switch = UFCP_EGI_STATE_IDS.OFF

local ALNG_step = 0

local UFCP_EGI_STATE_TEXT = {
    [UFCP_EGI_STATE_IDS.OFF]                = "OFF  ",
    [UFCP_EGI_STATE_IDS.INIT]               = "INIT ",
    [UFCP_EGI_STATE_IDS.STHD]               = "STHD ",
    [UFCP_EGI_STATE_IDS.ALIGN]              = "ALIGN",
    [UFCP_EGI_STATE_IDS.ALIGNING]           = "ALIGN",
    [UFCP_EGI_STATE_IDS.ALIGNED_COARSE]     = "ALIGN",
    [UFCP_EGI_STATE_IDS.ALIGNED]            = "ALIGN",
    [UFCP_EGI_STATE_IDS.NAV]                = "NAV  ",
    [UFCP_EGI_STATE_IDS.NAV_COARSE]         = "NAV  ",
    [UFCP_EGI_STATE_IDS.ATT]                = "ATT  ",
    [UFCP_EGI_STATE_IDS.TEST]               = "TEST ",
    [UFCP_EGI_STATE_IDS.FAIL]               = "FAIL ",
    [UFCP_EGI_STATE_IDS.TEND]               = "T-END",
}

local UFCP_EGI_SEL_IDS = {
    SLT = 1,
    LAT = 2,
    LON = 3,
    ELV = 4,
}

local time_elapsed = 0
local ufcp_egi_sel = 0


-- Methods
local function blinking(period, duty_cycle, offset)
    period = period or 0.5
    duty_cycle = duty_cycle or 0.5
    offset = offset or 0

    local period_elapsed = ((time_elapsed + offset) % period) / period
    if period_elapsed > duty_cycle then return false
    else return true end
end
function update_egi()
    time_elapsed = (time_elapsed + update_time_step) % 3600
    local text = ""
    if ufcp_sel_format == UFCP_FORMAT_IDS.EGI_INS then
        text = text .. "INS "
        local elapsed_min = math.floor(ELAPSED_time / 60)
        local elapsed_sec = math.floor(ELAPSED_time % 60)
        if elapsed_min >= 60 then 
            elapsed_min = 59
            elapsed_sec = 59
        end
        ALNG_step = math.floor(ELAPSED_time / ALGN_time * 23)
        if ALNG_step > 23 then ALNG_step = 23 end

        if EGI_state ~= UFCP_EGI_STATE_IDS.OFF then
            text = text .. string.format("%02.0f:%02.0f/%02.0f ", elapsed_min, elapsed_sec, ALNG_step)
        else
            text = text .. "XX:XX/XX "
        end
        text = text .. (UFCP_EGI_STATE_TEXT[EGI_state] or "     ")
        text = text .. "   "
        text = text .. ((EGI_state == UFCP_EGI_STATE_IDS.ALIGNED_COARSE or (EGI_state == UFCP_EGI_STATE_IDS.ALIGNED and blinking())) and  "RDY\n" or "   \n")

        local ufcp_egi_lat = 0
        local ufcp_egi_lon = 0
        local ufcp_egi_elv = 0
        local ufcp_egi_gs = 0
        local ufcp_egi_thdg = 0


        ufcp_egi_lat, ufcp_egi_elv, ufcp_egi_lon = sensor_data.getSelfCoordinates()
        ufcp_egi_lat, ufcp_egi_lon = Terrain.convertMetersToLatLon(ufcp_egi_lat, ufcp_egi_lon)
        ufcp_egi_elv = ufcp_egi_elv * 3.28084

        local sx, sy, sz = sensor_data.getSelfVelocity()
        ufcp_egi_gs = math.sqrt(sx * sx + sy * sy + sz * sz) * 1.94384
        ufcp_egi_thdg = math.deg(sensor_data.getHeading()) % 360
        
        -- Line 2
        text = text .. "SLT"
        if ufcp_egi_sel == UFCP_EGI_SEL_IDS.SLT then text = text .. "*" else text = text .. " " end
        text = text .. "00"
        if ufcp_egi_sel == UFCP_EGI_SEL_IDS.SLT then text = text .. "*" else text = text .. " " end
        text = text .. " LAT"
        if ufcp_egi_sel == UFCP_EGI_SEL_IDS.LAT then text = text .. "*" else text = text .. " " end
        if ufcp_egi_lat <0 then text = text .. "S" else text = text .. "N" end
        text = text .. string.format(" %02.0f$%05.2f'", math.floor(math.abs(ufcp_egi_lat)), (math.abs(ufcp_egi_lat) - math.floor(math.abs(ufcp_egi_lat)))*60)
        if ufcp_egi_sel == UFCP_EGI_SEL_IDS.LAT then text = text .. "*" else text = text .. " " end
        text = text .. "\n"

        -- Line 3
        text = text .. " GEO    LON"
        if ufcp_egi_sel == UFCP_EGI_SEL_IDS.LON then text = text .. "*" else text = text .. " " end
        if ufcp_egi_lon >=0 then text = text .. "E" else text = text .. "W" end
        text = text .. string.format("%03.0f$%05.2f'", math.floor(math.abs(ufcp_egi_lon)), (math.abs(ufcp_egi_lon) - math.floor(math.abs(ufcp_egi_lon)))*60)
        if ufcp_egi_sel == UFCP_EGI_SEL_IDS.LON then text = text .. "*" else text = text .. " " end
        text = text .. "\n"

        -- Line 4
        text = text .. "       ELEV  "
        if ufcp_egi_sel == UFCP_EGI_SEL_IDS.ELV then text = text .. "*" else text = text .. " " end
        text = text .. string.format("%5.0f", ufcp_egi_elv)
        if ufcp_egi_sel == UFCP_EGI_SEL_IDS.ELV then text = text .. "*" else text = text .. " " end
        text = text .. "FT  \n"

        --line 5
        text = text .. " THDG "
        text = text .. string.format("%05.1f$    GS %3.0f  ", ufcp_egi_thdg ,ufcp_egi_gs)

    elseif ufcp_sel_format == UFCP_FORMAT_IDS.EGI_GPS then
        text = text .. "EGI-GPS\n"
    end

    UFCP_TEXT:set(text)
end

function update_egir()
    -- local EGI_state_old = EGI_state

    if EGI_switch == UFCP_EGI_STATE_IDS.OFF and EGI_state ~= UFCP_EGI_STATE_IDS.OFF and EGI_state ~= UFCP_EGI_STATE_IDS.TEND then
        OFF_time = 15
        EGI_state = UFCP_EGI_STATE_IDS.TEND
    elseif EGI_state == UFCP_EGI_STATE_IDS.TEND then
        OFF_time = OFF_time - update_time_step
        if OFF_time < update_time_step then
            EGI_state = UFCP_EGI_STATE_IDS.OFF
        end
    elseif (EGI_switch == UFCP_EGI_STATE_IDS.STHD or
            EGI_switch == UFCP_EGI_STATE_IDS.ALIGN)
            and EGI_state == UFCP_EGI_STATE_IDS.OFF then
        EGI_state = UFCP_EGI_STATE_IDS.ALIGNING
        ELAPSED_time = 0
    elseif EGI_switch == UFCP_EGI_STATE_IDS.ALIGN and EGI_state==UFCP_EGI_STATE_IDS.NAV_COARSE then
        EGI_state=UFCP_EGI_STATE_IDS.ALIGNED_COARSE
    elseif EGI_switch == UFCP_EGI_STATE_IDS.NAV and EGI_state == UFCP_EGI_STATE_IDS.ALIGNED_COARSE then
        EGI_state = UFCP_EGI_STATE_IDS.NAV_COARSE
    elseif EGI_switch == UFCP_EGI_STATE_IDS.NAV and EGI_state == UFCP_EGI_STATE_IDS.ALIGNED then
        EGI_state = UFCP_EGI_STATE_IDS.NAV
    end

    if EGI_state == UFCP_EGI_STATE_IDS.ALIGNING or EGI_state == UFCP_EGI_STATE_IDS.ALIGNED_COARSE then
        if EGI_switch == UFCP_EGI_STATE_IDS.STHD or EGI_switch == UFCP_EGI_STATE_IDS.ALIGN then
            ELAPSED_time = ELAPSED_time + update_time_step
        end
        if EGI_switch == UFCP_EGI_STATE_IDS.ALIGN then
            if ELAPSED_time > ALGN_time then
                EGI_state = UFCP_EGI_STATE_IDS.ALIGNED
            elseif ELAPSED_time > ALGN_COURSE_time then
                EGI_state = UFCP_EGI_STATE_IDS.ALIGNED_COARSE
            end
        end
        if EGI_switch == UFCP_EGI_STATE_IDS.STHD then
            if ELAPSED_time > STHD_time then
                EGI_state = UFCP_EGI_STATE_IDS.ALIGNED
            end
        end
    end

    -- if EGI_state_old ~= EGI_state then
    --     for name, value in pairs(UFCP_EGI_STATE_IDS) do
    --         if value == EGI_state then 
    --             print_message_to_user(name)
    --             break;
    --         end
    --     end
    -- end
    UFCP_EGI.EGI_STATE:set(EGI_state)
end

function post_initialize_egi()
    local birth = LockOn_Options.init_conditions.birth_place
    if birth=="GROUND_HOT" or birth=="AIR_HOT" then
        dev:performClickableAction(device_commands.UFCP_EGI, 1, true)
        EGI_state = UFCP_EGI_STATE_IDS.NAV
        EGI_switch = UFCP_EGI_STATE_IDS.NAV
        ELAPSED_time = 250
    elseif birth=="GROUND_COLD" then
        dev:performClickableAction(device_commands.UFCP_EGI, 0.15, true)
        EGI_state = UFCP_EGI_STATE_IDS.OFF
        EGI_switch = UFCP_EGI_STATE_IDS.OFF
    end
end

function SetCommandEgi(command,value)
    debug_message_to_user("Command: ".. command .. " Value: " .. value)


    if command == device_commands.UFCP_EGI then
        if value == 0.25 then
            EGI_switch = UFCP_EGI_STATE_IDS.OFF
        elseif value == 0.5 then
            EGI_switch = UFCP_EGI_STATE_IDS.STHD
            ufcp_edit_clear()
            ufcp_sel_format = UFCP_FORMAT_IDS.EGI_INS
        elseif value == 0.75 then
            EGI_switch = UFCP_EGI_STATE_IDS.ALIGN
            ufcp_edit_clear()
            ufcp_sel_format = UFCP_FORMAT_IDS.EGI_INS
        elseif value == 1 then
            EGI_switch = UFCP_EGI_STATE_IDS.NAV
        end
    end

end