function get_elec_avionics_ok()
    return elec_avionics_ok:get()==1 and true or false
end

function get_elec_avionics_emergency_ok()
    return elec_avionics_emergency_ok:get()==1 and true or false
end

function get_elec_main_bar_ok()
    return elec_main_bar_ok:get()==1 and true or false
end

function get_elec_emergency_ok()
    return elec_emergency_ok:get()==1 and true or false
end

function get_elec_emergency_reserve_ok()
    return elec_emergency_reserve_ok:get()==1 and true or false
end

----- api cockpit
function get_batt_on()
    return get_cockpit_draw_argument_value(961) == 0
end

function get_generator_on()
    return get_cockpit_draw_argument_value(962) == 1
end

function get_avionics_on()
    return get_cockpit_draw_argument_value(843) == 1
end

function get_acft_intc_on()
    return get_cockpit_draw_argument_value(966) == 1
end

function get_ext_pwr_on()
    return get_cockpit_draw_argument_value(963) == 1
end

function get_mdp1_on()
    return get_cockpit_draw_argument_value(841) == 1
end

function get_mdp2_on()
    return get_cockpit_draw_argument_value(842) == 1
end

function get_emer_ovrd()
    return get_cockpit_draw_argument_value(965) == 1
end

function get_vuhf_guard_on()
    return get_cockpit_draw_argument_value(845) == 1
end




elec_avionics_ok=get_param_handle("ELEC_AVIONICS_OK") -- 1 or 0
elec_avionics_emergency_ok=get_param_handle("ELEC_AVIONICS_EMEGENCY_OK") -- 1 or 0
elec_main_bar_ok=get_param_handle("ELEC_MAIN_BAR_OK") -- 1 or 0
elec_emergency_ok=get_param_handle("ELEC_EMERGENCY_OK") -- 1 or 0
elec_emergency_reserve_ok=get_param_handle("ELEC_EMERGENCY_RESERVE_OK") -- 1 or 0
elec_avionics_master_mdp=get_param_handle("ELEC_AVIONICS_MASTER_MDP") -- 0, 1 or 2

-- elec_aft_mon_ac_ok=get_param_handle("ELEC_AFT_MON_AC_OK") -- 1 or 0
-- elec_fwd_mon_ac_ok=get_param_handle("ELEC_FWD_MON_AC_OK") -- 1 or 0
-- elec_mon_primary_ac_ok=get_param_handle("ELEC_MON_PRIMARY_AC_OK") -- 1 or 0
-- elec_mon_dc_ok=get_param_handle("ELEC_MON_DC_OK") -- 1 or 0
-- elec_mon_arms_dc_ok=get_param_handle("ELEC_MON_ARMS_DC_OK") -- 1 or 0
-- elec_emergency_gen_active=get_param_handle("ELEC_EMERGENCY_GEN_ACTIVE") -- 1 or 0
-- elec_external_power=get_param_handle("ELEC_EXTERNAL_POWER") -- 1 or 0
-- elec_ground_mode=get_param_handle("ELEC_GROUND_MODE") -- 1 or 0

