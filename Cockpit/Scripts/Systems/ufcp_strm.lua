-- Constants

local UFCP_STORM_MODE_IDS = {
    AUTO = 0,
    ON = 1,
    OFF = 2,
}

-- Inits
ufcp_storm = UFCP_STORM_MODE_IDS.AUTO
ufcp_storm_sound = true

-- Methods

local AVIONICS_MASTER_MODE = get_param_handle("AVIONICS_MASTER_MODE")
local ufcp_storm_sel = 0
local max_ufcp_storm_sel = 2

function update_strm()
    local text = ""
    text = text .. "STORMSCOPE\n\n"
    text = text .. "STRM  "

    if ufcp_storm_sel == 0 then text = text .. "*" else text = text .. " " end
    if ufcp_storm == UFCP_STORM_MODE_IDS.AUTO then
        text = text .. "AUTO"
    elseif ufcp_storm == UFCP_STORM_MODE_IDS.ON then
        text = text .. "ON  "
    elseif ufcp_storm == UFCP_STORM_MODE_IDS.OFF then
        text = text .. "OFF "
    end
    if ufcp_storm_sel == 0 then text = text .. "*" else text = text .. " " end

    text = text .. "      \n\n"

    text = text .. "AURAL "
    if ufcp_storm_sel == 1 then text = text .. "*" else text = text .. " " end
    if ufcp_storm_sound then text = text .. "ON " else text = text .. "OFF" end
    if ufcp_storm_sel == 1 then text = text .. "*" else text = text .. " " end

    text = text .. "       "

    UFCP_TEXT:set(text)
end

function SetCommandStrm(command,value)
    if command == device_commands.UFCP_JOY_DOWN and value == 1 then
        ufcp_storm_sel = (ufcp_storm_sel + 1) % max_ufcp_storm_sel
    elseif command == device_commands.UFCP_JOY_UP and value == 1 then
        ufcp_storm_sel = (ufcp_storm_sel - 1) % max_ufcp_storm_sel
    elseif command == device_commands.UFCP_JOY_RIGHT and value == 1 then
        if ufcp_storm_sel == 0 then
            ufcp_storm = (ufcp_storm + 1) % 3
        elseif ufcp_storm_sel == 1 then
            ufcp_storm_sound = not ufcp_storm_sound
        end
    end
end