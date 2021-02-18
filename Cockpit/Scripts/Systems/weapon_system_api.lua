dofile(LockOn_Options.common_script_path.."../../../Database/wsTypes.lua")

local count = -1
local function counter()
	count = count + 1
	return count
end

WPN_MASS_IDS = {
    SIM          = -1,
    SAFE         = 0,
    LIVE         = 1,
}

WPN_LATEARM_IDS = {
    GUARD        = -1,
    SAFE         = 0,
    ON           = 1,
}

WPN_MASS = get_param_handle("WPN_MASS")
WPN_LATEARM = get_param_handle("WPN_LATEARM")

WPN_STO_1_JET = get_param_handle("WPN_STO_1_JET")
WPN_STO_2_JET = get_param_handle("WPN_STO_2_JET")
WPN_STO_3_JET = get_param_handle("WPN_STO_3_JET")
WPN_STO_4_JET = get_param_handle("WPN_STO_4_JET")
WPN_STO_5_JET = get_param_handle("WPN_STO_5_JET")


function get_wpn_sto_jet(index)
    if index == 1 then return WPN_STO_1_JET:get()
    elseif index == 2 then return WPN_STO_2_JET:get()
    elseif index == 3 then return WPN_STO_3_JET:get()
    elseif index == 4 then return WPN_STO_4_JET:get()
    elseif index == 5 then return WPN_STO_5_JET:get()
    end
end

function set_wpn_sto_jet(index, value)
    if index == 1 then return WPN_STO_1_JET:set(value)
    elseif index == 2 then return WPN_STO_2_JET:set(value)
    elseif index == 3 then return WPN_STO_3_JET:set(value)
    elseif index == 4 then return WPN_STO_4_JET:set(value)
    elseif index == 5 then return WPN_STO_5_JET:set(value)
    end
end

function get_wpn_mass()
    return WPN_MASS:get()
end

function get_wpn_latearm()
    return WPN_LATEARM:get()
end