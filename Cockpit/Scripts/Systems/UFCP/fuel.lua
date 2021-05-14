local UFCP_FUEL_BINGO = get_param_handle("UFCP_FUEL_BINGO")
local UFCP_FUEL_HMPT = get_param_handle("UFCP_FUEL_HMPT")

UFCP_FUEL_BINGO:set(120)
UFCP_FUEL_HMPT:set(0)

-- Methods

function update_fuel()
    local text = ""
    text = text .. "FUEL\n"
    UFCP_TEXT:set(text)
end

function SetCommandFuel(command,value)

end