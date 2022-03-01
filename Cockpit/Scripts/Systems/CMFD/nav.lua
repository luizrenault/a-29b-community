dofile(LockOn_Options.script_path.."CMFD/CMFD_NAV_ID_defs.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_api.lua")


local CMFD_NAV_FORMAT = get_param_handle("CMFD_NAV_FORMAT")

local CMFD = {
    NAV_FYT = get_param_handle("CMFD_NAV_FYT"),
    NAV_FYT_LAT_M = get_param_handle("CMFD_NAV_FYT_LAT_M"),
    NAV_FYT_LON_M = get_param_handle("CMFD_NAV_FYT_LON_M"),
    NAV_FYT_ALT_M = get_param_handle("CMFD_NAV_FYT_ALT_M"),
    NAV_FYT_VALID = get_param_handle("CMFD_NAV_FYT_VALID"),
    NAV_FYT_ELV = get_param_handle("CMFD_NAV_FYT_ELV"),
    NAV_FYT_HOURS = get_param_handle("CMFD_NAV_FYT_HOURS"),
    NAV_FYT_MINS = get_param_handle("CMFD_NAV_FYT_MINS"),
    NAV_FYT_SECS = get_param_handle("CMFD_NAV_FYT_SECS"),
    NAV_FYT_LAT_HEMIS = get_param_handle("CMFD_NAV_FYT_LAT_HEMIS"),
    NAV_FYT_LAT_DEG = get_param_handle("CMFD_NAV_FYT_LAT_DEG"),
    NAV_FYT_LAT_MIN = get_param_handle("CMFD_NAV_FYT_LAT_MIN"),
    NAV_FYT_LON_HEMIS = get_param_handle("CMFD_NAV_FYT_LON_HEMIS"),
    NAV_FYT_LON_DEG = get_param_handle("CMFD_NAV_FYT_LON_DEG"),
    NAV_FYT_LON_MIN = get_param_handle("CMFD_NAV_FYT_LON_MIN"),
    NAV_FYT_DTK_BRG = get_param_handle("CMFD_NAV_FYT_DTK_BRG"),
    NAV_FYT_DTK_BRG_TEXT = get_param_handle("CMFD_NAV_FYT_DTK_BRG_TEXT"),
    NAV_FYT_DTK_DIST = get_param_handle("CMFD_NAV_FYT_DTK_DIST"),
    NAV_FYT_DTK_ELV = get_param_handle("CMFD_NAV_FYT_DTK_ELV"),
    NAV_FYT_DTK_MINS = get_param_handle("CMFD_NAV_FYT_DTK_MINS"),
    NAV_FYT_DTK_SECS = get_param_handle("CMFD_NAV_FYT_DTK_SECS"),
    NAV_FYT_DTK_AZIMUTH = get_param_handle("CMFD_NAV_FYT_DTK_AZIMUTH"),
    NAV_FYT_DTK_ELEVATION = get_param_handle("CMFD_NAV_FYT_DTK_ELEVATION"),
    NAV_FYT_DTK_STT = get_param_handle("CMFD_NAV_FYT_DTK_STT"),
    NAV_FYT_DTK_TTD = get_param_handle("CMFD_NAV_FYT_DTK_TTD"),
    NAV_FYT_DTK_DT = get_param_handle("CMFD_NAV_FYT_DTK_DT"),
    NAV_FYT_OAP_BRG = get_param_handle("CMFD_NAV_FYT_OAP_BRG"),
    NAV_FYT_OAP_DIST = get_param_handle("CMFD_NAV_FYT_OAP_DIST"),
    NAV_FYT_OAP_ELV = get_param_handle("CMFD_NAV_FYT_OAP_ELV"),
    NAV_FYT_SET = get_param_handle("CMFD_NAV_FYT_SET"),
    NAV_OAP_AZIMUTH = get_param_handle("CMFD_NAV_OAP_AZIMUTH"),
    NAV_OAP_ELEVATION = get_param_handle("CMFD_NAV_OAP_ELEVATION"),
    NAV_OAP_LAT_M = get_param_handle("CMFD_NAV_OAP_LAT_M"),
    NAV_OAP_LON_M = get_param_handle("CMFD_NAV_OAP_LON_M"),
    NAV_OAP_ALT_M = get_param_handle("CMFD_NAV_OAP_ALT_M"),
}
local CMFD_NAV_ROUT_TEXT = get_param_handle("CMFD_NAV_ROUT_TEXT")
local CMFD_NAV_ROUT_TEXT1 = get_param_handle("CMFD_NAV_ROUT_TEXT1")
local CMFD_NAV_ROUT_TEXT2 = get_param_handle("CMFD_NAV_ROUT_TEXT2")
local CMFD_NAV_PG_NEXT = get_param_handle("CMFD_NAV_PG_NEXT")
local CMFD_NAV_PG_PREV = get_param_handle("CMFD_NAV_PG_PREV")
local CMFD_NAV_AC_TEXT = get_param_handle("CMFD_NAV_AC_TEXT")
local CMFD_NAV_AFLD_TEXT = get_param_handle("CMFD_NAV_AFLD_TEXT")
local CMFD_NAV_MARK_TEXT = get_param_handle("CMFD_NAV_MARK_TEXT")

local UFCP_TIP_DIR = get_param_handle("UFCP_TIP_DIR") -- -1Left 0Disabled 1Right

local UFCP_OAP_ENABLED = get_param_handle("UFCP_OAP") -- 0disabled 1enabled

local ADHSI_DTK_HDG = get_param_handle("ADHSI_DTK_HDG")
local ADHSI_DTK_DIST = get_param_handle("ADHSI_DTK_DIST")
local ADHSI_DTK = get_param_handle("ADHSI_DTK")

local nav_format = CMFD_NAV_FORMAT_IDS.AC
local nav_fyt_last = -1
local route

local Terrain = require('terrain')
local terrainAirdromes = get_terrain_related_data("Airdromes") or {};
local Airdromes = {}

-- FYT query
-- Check if query is free by asserting that CMFD_NAV_GET_RDY == -1 and CMFD_NAV_GET_RDY == 0
-- Set CMFD_NAV_GET_INDEX to desired FYT index
-- Read LAT, LON, ELV and TIME when  CMFD_NAV_GET_RDY == 1
-- Set CMFD_NAV_GET_RDY = -1 and CMFD_NAV_GET_RDY = 0 to release query

local CMFD_NAV_GET_INDEX = get_param_handle("CMFD_NAV_GET_INDEX")
local CMFD_NAV_GET_LAT = get_param_handle("CMFD_NAV_GET_LAT")
local CMFD_NAV_GET_LON = get_param_handle("CMFD_NAV_GET_LON")
local CMFD_NAV_GET_ELV = get_param_handle("CMFD_NAV_GET_ELV")
local CMFD_NAV_GET_TIME = get_param_handle("CMFD_NAV_GET_TIME")
local CMFD_NAV_GET_RDY = get_param_handle("CMFD_NAV_GET_RDY")
local CMFD_NAV_SET_INDEX = get_param_handle("CMFD_NAV_SET_INDEX")
local CMFD_NAV_SET_LAT = get_param_handle("CMFD_NAV_SET_LAT")
local CMFD_NAV_SET_LON = get_param_handle("CMFD_NAV_SET_LON")
local CMFD_NAV_SET_ELV = get_param_handle("CMFD_NAV_SET_ELV")
local CMFD_NAV_SET_TIME = get_param_handle("CMFD_NAV_SET_TIME")
local CMFD_NAV_SET_OAP_BRG = get_param_handle("CMFD_NAV_SET_OAP_BRG")
local CMFD_NAV_SET_OAP_RNG = get_param_handle("CMFD_NAV_SET_OAP_RNG")
local CMFD_NAV_SET_OAP_ELEV = get_param_handle("CMFD_NAV_SET_OAP_ELEV")
local CMFD_NAV_SET_OAP_INDEX = get_param_handle("CMFD_NAV_SET_OAP_INDEX")
local CMFD_NAV_GET_OAP_BRG = get_param_handle("CMFD_NAV_GET_OAP_BRG")
local CMFD_NAV_GET_OAP_RNG = get_param_handle("CMFD_NAV_GET_OAP_RNG")
local CMFD_NAV_GET_OAP_ELEV = get_param_handle("CMFD_NAV_GET_OAP_ELEV")
local CMFD_NAV_GET_OAP_INDEX = get_param_handle("CMFD_NAV_GET_OAP_INDEX")
local CMFD_NAV_GET_OAP_RDY = get_param_handle("CMFD_NAV_GET_OAP_RDY")

CMFD_NAV_SET_OAP_INDEX:set(-1)
CMFD_NAV_GET_OAP_INDEX:set(-1)
CMFD_NAV_GET_OAP_RDY:set(0)


CMFD_NAV_SET_INDEX:set(-1)
CMFD_NAV_GET_INDEX:set(-1)
CMFD_NAV_GET_RDY:set(0)

CMFD.NAV_FYT_SET:set(-1) -- Whenever this value is set, it will try to switch the fyt to the set value. If it fails, it will maintain the current fit and ignore this

local function get_distance(x1, y1, x2, y2)
    local x = x2 - x1
    local y = y2 - y1
    return math.sqrt(x * x + y * y)
end

local function get_heading(x1, y1, x2, y2)
    local x = x2 - x1
    local y = y2 - y1
    local hdg
    if x ~= 0 then
        hdg= math.deg(math.atan(y/x))
    else 
        if y > 0  then hdg = 90 else hdg = -90 end
    end
    if x > 0 then hdg = hdg + 180 end
    hdg = hdg % 360
    
    if x == 0 and y == 0 then return get_avionics_hdg() end
    return hdg
end
local function cmfd_nav_sel_next_wpt()
    local nav_fyt_next = (nav_fyt + 1) % 100
    local limit = 0
    while nav_fyt_list[nav_fyt_next+1]==nil do
        nav_fyt_next = (nav_fyt_next + 1) % 100
        limit = limit + 1
        if limit > 100 then 
            nav_fyt_next = 0
            break 
        end
    end

    UFCP_TIP_DIR:set(0) -- Disable TIP when changing waypoints
    return nav_fyt_next
end

local function cmfd_nav_sel_prev_wpt()
    local nav_fyt_prev = (nav_fyt - 1) % 100
    local limit = 0
    while nav_fyt_list[nav_fyt_prev+1]==nil do
        nav_fyt_prev = (nav_fyt_prev - 1) % 100
        limit = limit + 1
        if limit > 100 then 
            nav_fyt_prev = 0
            break 
        end
    end

    UFCP_TIP_DIR:set(0) -- Disable TIP when changing waypoints
    return nav_fyt_prev
end

local function update_wpt_list(wpt_list)
    if wpt_list == nil then return wpt_list end
    for i=1,#wpt_list do
        wpt_list[i].lat_m, wpt_list[i].lon_m = Terrain.convertLatLonToMeters(wpt_list[i].lat, wpt_list[i].lon)
        -- wpt_list[i].speed = route[i].speed

        if i>1 then
            wpt_list[i-1].hdg = get_heading(wpt_list[i].lat_m, wpt_list[i].lon_m, wpt_list[i-1].lat_m, wpt_list[i-1].lon_m)
            wpt_list[i-1].dis = get_distance(wpt_list[i].lat_m, wpt_list[i].lon_m, wpt_list[i-1].lat_m, wpt_list[i-1].lon_m) * 0.000539957
        end
        
        wpt_list[i].time_secs = math.floor(wpt_list[i].time % 60)
        wpt_list[i].time_mins = math.floor((wpt_list[i].time / 60) % 60)
        wpt_list[i].time_hours =  math.floor(wpt_list[i].time / 3600)

        if wpt_list[i].time_hours >= 100 then
            wpt_list[i].time_secs = 59
            wpt_list[i].time_mins = 59
            wpt_list[i].time_hours =  99
        end
    end
    return wpt_list
end

local count = 0
local freq = 10/ update_time_step
local speed_history = {}
local average_speed = 0

local cmfd_nav_page = 0

local function get_valid_wpt_list()
    local wpt_index = {}
    for k=1,100 do
        -- TODO (0,0) is a valid waypoint.
        if nav_fyt_list[k] and nav_fyt_list[k].lat ~= 0 and nav_fyt_list[k].lon ~= 0 then
            wpt_index[#wpt_index + 1] = k
        end
    end
    return wpt_index
end

wpt_index = get_valid_wpt_list()

local distance_last = -1



local function update_nav_get_oap()
    local get_index = CMFD_NAV_GET_OAP_INDEX:get()
    local get_rdy = CMFD_NAV_GET_OAP_RDY:get()

    if get_index >= 0 and get_rdy == 0 then
        if nav_fyt_list[get_index+1] then
            CMFD_NAV_GET_OAP_BRG:set(nav_fyt_list[get_index+1].oap_brg or 0)
            CMFD_NAV_GET_OAP_RNG:set(nav_fyt_list[get_index+1].oap_rng or 0)
            CMFD_NAV_GET_OAP_ELEV:set(nav_fyt_list[get_index+1].oap_elev or 0)
            CMFD_NAV_GET_OAP_RDY:set(1)
        else 
            CMFD_NAV_GET_OAP_BRG:set(0)
            CMFD_NAV_GET_OAP_RNG:set(0)
            CMFD_NAV_GET_OAP_ELEV:set(0)
            CMFD_NAV_GET_OAP_RDY:set(1)
        end
    end
end

local function update_nav_set_oap()
    local wpt_set_index = CMFD_NAV_SET_OAP_INDEX:get()+1
    if wpt_set_index > 0 then
        local brg = CMFD_NAV_SET_OAP_BRG:get()
        local rng = CMFD_NAV_SET_OAP_RNG:get()
        local elev = CMFD_NAV_SET_OAP_ELEV:get()
        CMFD_NAV_SET_OAP_INDEX:set(-1)

        if(nav_fyt_list[wpt_set_index]) then 
            nav_fyt_list[wpt_set_index].oap_brg = brg
            nav_fyt_list[wpt_set_index].oap_rng = rng
            nav_fyt_list[wpt_set_index].oap_elev = elev
        end
    end
end

local function update_nav_get()
    local get_index = CMFD_NAV_GET_INDEX:get()
    local get_rdy = CMFD_NAV_GET_RDY:get()

    if get_index >= 0 and get_rdy == 0 then
        if nav_fyt_list[get_index+1] then
            CMFD_NAV_GET_LAT:set(nav_fyt_list[get_index+1].lat or 0)
            CMFD_NAV_GET_LON:set(nav_fyt_list[get_index+1].lon or 0)
            CMFD_NAV_GET_ELV:set(nav_fyt_list[get_index+1].altitude or 0)
            CMFD_NAV_GET_TIME:set(nav_fyt_list[get_index+1].time or 0)
            CMFD_NAV_GET_RDY:set(1)
        else 
            CMFD_NAV_GET_LAT:set(-100) -- Impossible values, so the system considers them invalid
            CMFD_NAV_GET_LON:set(-200) -- Impossible values, so the system considers them invalid
            CMFD_NAV_GET_ELV:set(-2000) -- Impossible values, so the system considers them invalid
            CMFD_NAV_GET_TIME:set(0)
            CMFD_NAV_GET_RDY:set(1)
        end
    end
end

local function update_nav_set()
    local wpt_set_index = CMFD_NAV_SET_INDEX:get()+1
    if wpt_set_index > 0 then
        local lat = CMFD_NAV_SET_LAT:get()
        local lon = CMFD_NAV_SET_LON:get()
        local elv = CMFD_NAV_SET_ELV:get()
        local time = CMFD_NAV_SET_TIME:get()
        CMFD_NAV_SET_INDEX:set(-1)

        nav_fyt_list[wpt_set_index] = {}
        nav_fyt_list[wpt_set_index].lat = lat
        nav_fyt_list[wpt_set_index].lon = lon
        local lat_m, lon_m = Terrain.convertLatLonToMeters(lat, lon)
        nav_fyt_list[wpt_set_index].lat_m = lat_m
        nav_fyt_list[wpt_set_index].lon_m = lon_m
        nav_fyt_list[wpt_set_index].altitude = elv
        nav_fyt_list[wpt_set_index].time = time

        if wpt_set_index>1 and nav_fyt_list[wpt_set_index-1] then
            nav_fyt_list[wpt_set_index-1].hdg = get_heading(nav_fyt_list[wpt_set_index].lat_m, nav_fyt_list[wpt_set_index].lon_m, nav_fyt_list[wpt_set_index-1].lat_m, nav_fyt_list[wpt_set_index-1].lon_m)
            nav_fyt_list[wpt_set_index-1].dis = get_distance(nav_fyt_list[wpt_set_index].lat_m, nav_fyt_list[wpt_set_index].lon_m, nav_fyt_list[wpt_set_index-1].lat_m, nav_fyt_list[wpt_set_index-1].lon_m) * 0.000539957
            if nav_fyt_list[wpt_set_index-1].hdg == nil then nav_fyt_list[wpt_set_index-1].hdg = 0 end
            if nav_fyt_list[wpt_set_index-1].dis == nil then nav_fyt_list[wpt_set_index-1].dis = 0 end
        end
        if wpt_set_index<#nav_fyt_list and nav_fyt_list[wpt_set_index+1] then
            nav_fyt_list[wpt_set_index].hdg = get_heading(nav_fyt_list[wpt_set_index+1].lat_m, nav_fyt_list[wpt_set_index+1].lon_m, nav_fyt_list[wpt_set_index].lat_m, nav_fyt_list[wpt_set_index].lon_m)
            nav_fyt_list[wpt_set_index].dis = get_distance(nav_fyt_list[wpt_set_index+1].lat_m, nav_fyt_list[wpt_set_index+1].lon_m, nav_fyt_list[wpt_set_index].lat_m, nav_fyt_list[wpt_set_index].lon_m) * 0.000539957
            if nav_fyt_list[wpt_set_index].hdg == nil then nav_fyt_list[wpt_set_index].hdg = 0 end
            if nav_fyt_list[wpt_set_index].dis == nil then nav_fyt_list[wpt_set_index].dis = 0 end
        end

        nav_fyt_list[wpt_set_index].time_secs = math.floor(nav_fyt_list[wpt_set_index].time % 60)
        nav_fyt_list[wpt_set_index].time_mins = math.floor((nav_fyt_list[wpt_set_index].time / 60) % 60)
        nav_fyt_list[wpt_set_index].time_hours =  math.floor(nav_fyt_list[wpt_set_index].time / 3600)

        if nav_fyt_list[wpt_set_index].time_hours >= 100 then
            nav_fyt_list[wpt_set_index].time_secs = 59
            nav_fyt_list[wpt_set_index].time_mins = 59
            nav_fyt_list[wpt_set_index].time_hours =  99
        end
        wpt_index = get_valid_wpt_list()
    end
end

local function calc_brg_dist_elev(dest_lat_m, dest_lon_m, dest_alt_m, orig_lat_m, orig_lon_m, orig_alt_m)
    local o_lat_m, o_alt_m, o_lon_m = sensor_data.getSelfCoordinates()
    orig_lat_m = orig_lat_m or o_lat_m
    orig_lon_m = orig_lon_m or o_lon_m
    orig_alt_m = orig_alt_m or o_alt_m

    local brg, dist, elev

    local lat = dest_lat_m - orig_lat_m
    local lon = dest_lon_m - orig_lon_m
    elev = dest_alt_m - orig_alt_m

    brg = math.atan2(lon, lat)
    dist = math.sqrt(lat * lat + lon * lon)
    return brg, dist, elev
end

local function calc_brg_dist_elev_time(dest_lat_m, dest_lon_m, dest_alt_m, orig_lat_m, orig_lon_m, orig_alt_m, orig_speed_m_s)
    local o_lat_m, o_alt_m, o_lon_m = sensor_data.getSelfCoordinates()
    orig_lat_m = orig_lat_m or o_lat_m
    orig_lon_m = orig_lon_m or o_lon_m
    orig_alt_m = orig_alt_m or o_alt_m
    orig_speed_m_s = orig_speed_m_s or average_speed
    if orig_speed_m_s == 0 then orig_speed_m_s = 0.0001 end

    local brg, dist, elev, time

    local lat = dest_lat_m - orig_lat_m
    local lon = dest_lon_m - orig_lon_m
    elev = dest_alt_m - orig_alt_m

    brg = math.atan2(lon, lat)
    dist = math.sqrt(lat * lat + lon * lon)
    time = dist / orig_speed_m_s

    return brg, dist, elev, time
end

count = count + 1
local function calc_average_speed()
    local speedx, speedy, speedz = sensor_data.getSelfVelocity()
    if count == 1 or count % freq == 0 then
        local average_speed_index = math.floor((count / freq) % 6)
        average_speed = math.sqrt(speedx * speedx + speedy * speedy + speedz * speedz)
        speed_history[average_speed_index + 1] = average_speed
        average_speed = 0
        for i=1, #speed_history do
            average_speed = average_speed + speed_history[i]
        end
        average_speed = average_speed / #speed_history
    end
    return average_speed
end

local function coord_project(orig_lat_m, orig_lon_m, brg, dist)
    orig_lat_m = orig_lat_m + dist * math.cos(math.rad(brg))
    orig_lon_m = orig_lon_m + dist * math.sin(math.rad(brg))
    return orig_lat_m, orig_lon_m
end

-- Check if the fyt update request is valid. If it is, switch the fyt to the new value
function update_fyt()
    -- Check if a new fyt was set
    if CMFD.NAV_FYT_SET:get() >= 0 then

        -- Get the value set
        local nav_fyt_next = CMFD.NAV_FYT_SET:get()

        -- Check if the fyt is valid
        if nav_fyt_list[nav_fyt_next+1]~=nil then

            -- Update the fyt
            nav_fyt = CMFD.NAV_FYT_SET:get()
        end

        -- Clear the request
        CMFD.NAV_FYT_SET:set(-1)
    end
end

function calc_az_el_from_brg_dist_elev (brg, distance, elev)
    local plane_hdg = math.deg(-sensor_data.getHeading())
    if plane_hdg < 0 then plane_hdg = 360 + plane_hdg end
    plane_hdg = plane_hdg % 360
    
    local azimuth = brg - plane_hdg
    if azimuth <= -180 then azimuth = azimuth + 360 end
    if azimuth >   180 then azimuth = azimuth - 360 end
    azimuth = math.rad(azimuth)
    local elevation = math.atan2(elev,  distance)
    local roll = sensor_data.getRoll()
    local pitch = sensor_data.getPitch()
    local s = math.sin(roll)
    local c = math.cos(roll)

    local new_azimuth = azimuth * c - elevation * s
    local new_elevation = azimuth * s + elevation * c
    azimuth = new_azimuth + pitch * s
    elevation = new_elevation - pitch * c
    return azimuth, elevation
end

function update_nav()
    update_fyt()

    if nav_fyt_last ~= nav_fyt then
        UFCP_OAP_ENABLED:set(0)
    end
    CMFD_NAV_FORMAT:set(nav_format)
    CMFD.NAV_FYT:set(nav_fyt)
    calc_average_speed()
    
    update_nav_get_oap()
    update_nav_set_oap()
    update_nav_get()
    update_nav_set()

    if nav_fyt_list[nav_fyt+1] then
        -- local x, y, z = sensor_data:getSelfCoordinates()

        local dest_lat_m = nav_fyt_list[nav_fyt+1].lat_m
        local dest_lon_m = nav_fyt_list[nav_fyt+1].lon_m
        local dest_alt_m = nav_fyt_list[nav_fyt+1].altitude / 3.28084

        if UFCP_OAP_ENABLED:get() == 1 then 
            local oap_lat_m, oap_lon_m = coord_project(dest_lat_m, dest_lon_m, nav_fyt_list[nav_fyt+1].oap_brg, nav_fyt_list[nav_fyt+1].oap_rng/3.28084)
            local oap_alt_m = nav_fyt_list[nav_fyt+1].oap_elev / 3.28084
            local oap_brg, oap_dist, oap_elev = calc_brg_dist_elev(oap_lat_m, oap_lon_m, oap_alt_m)
            oap_brg = math.deg(oap_brg) % 360
            local oap_az, oap_el = calc_az_el_from_brg_dist_elev(oap_brg, oap_dist, oap_elev)
            CMFD.NAV_OAP_AZIMUTH:set(oap_az)
            CMFD.NAV_OAP_ELEVATION:set(oap_el)
            CMFD.NAV_OAP_LAT_M:set(oap_lat_m)
            CMFD.NAV_OAP_LON_M:set(oap_lon_m)
            CMFD.NAV_OAP_ALT_M:set(oap_alt_m)
        end 

        if ADHSI_DTK:get() == 1 then 
            dest_lat_m, dest_lon_m = coord_project(dest_lat_m, dest_lon_m, ADHSI_DTK_HDG:get()+180, ADHSI_DTK_DIST:get()/0.000539957)
            -- NAV AUTO MODE
        end

        local hdg, distance, elev, time = calc_brg_dist_elev_time(dest_lat_m, dest_lon_m, dest_alt_m)
        hdg = math.deg(hdg) % 360
        if time > 100*60 then time = 100*60 end

        if distance < (2 / 0.000539957) and distance > distance_last and nav_fyt_last == nav_fyt and UFCP_NAV_MODE:get() == UFCP_NAV_MODE_IDS.AUTO then
            distance_last = distance
            nav_fyt_last = nav_fyt
            if ADHSI_DTK:get() == 0 then
                local nav_fyt_next = cmfd_nav_sel_next_wpt()
                if nav_fyt_next > nav_fyt  and nav_fyt_next < 79 then nav_fyt = nav_fyt_next end
            else
                ADHSI_DTK:set(0)
                nav_fyt_last = -1
            end
        else
            distance_last = distance
            nav_fyt_last = nav_fyt
        end

        local time_secs = math.floor(time % 60)
        local time_mins = math.floor((time - time_secs) / 60)
        if time_mins >= 100 then 
            time_mins = 99
            time_secs = 59
        end

        local speed_to_target = 0
        local tot =  nav_fyt_list[nav_fyt+1].time or 0
        local diff_tot = tot - get_absolute_model_time()

        if diff_tot > 0 then 
            speed_to_target = distance / diff_tot * 3600
            if speed_to_target > 999 then speed_to_target = 999 end
        else 
            speed_to_target = -1
        end
        local dt = diff_tot - time
        
        local plane_hdg = math.deg(-sensor_data.getHeading())
        if plane_hdg < 0 then plane_hdg = 360 + plane_hdg end
        plane_hdg = plane_hdg % 360
        
        local azimuth = hdg - plane_hdg
        if azimuth <= -180 then azimuth = azimuth + 360 end
        if azimuth >   180 then azimuth = azimuth - 360 end
        azimuth = math.rad(azimuth)
        local elevation = math.atan2(elev,  distance)
        local roll = sensor_data.getRoll()
        local pitch = sensor_data.getPitch()
        local s = math.sin(roll)
        local c = math.cos(roll)

        local new_azimuth = azimuth * c - elevation * s
        local new_elevation = azimuth * s + elevation * c
        azimuth = new_azimuth + pitch * s
        elevation = new_elevation - pitch * c

        CMFD.NAV_FYT_HOURS:set(nav_fyt_list[nav_fyt+1].time_hours)
        CMFD.NAV_FYT_MINS:set(nav_fyt_list[nav_fyt+1].time_mins)
        CMFD.NAV_FYT_SECS:set(nav_fyt_list[nav_fyt+1].time_secs)

        CMFD.NAV_FYT_DTK_MINS:set(time_mins)
        CMFD.NAV_FYT_DTK_SECS:set(time_secs)
        CMFD.NAV_FYT_DTK_STT:set(speed_to_target)
        CMFD.NAV_FYT_DTK_TTD:set(time)
        CMFD.NAV_FYT_DTK_DT:set(dt)

        if nav_fyt_list[nav_fyt+1].lat >= 0 then CMFD.NAV_FYT_LAT_HEMIS:set("N") else CMFD.NAV_FYT_LAT_HEMIS:set("S") end
        CMFD.NAV_FYT_LAT_DEG:set(math.floor(math.abs(nav_fyt_list[nav_fyt+1].lat)))
        CMFD.NAV_FYT_LAT_MIN:set((math.abs(nav_fyt_list[nav_fyt+1].lat) - math.floor(math.abs(nav_fyt_list[nav_fyt+1].lat)))*60)

        if nav_fyt_list[nav_fyt+1].lon >= 0 then CMFD.NAV_FYT_LON_HEMIS:set("E") else CMFD.NAV_FYT_LON_HEMIS:set("W") end
        CMFD.NAV_FYT_LON_DEG:set(math.floor(math.abs(nav_fyt_list[nav_fyt+1].lon)))
        CMFD.NAV_FYT_LON_MIN:set((math.abs(nav_fyt_list[nav_fyt+1].lon) - math.floor(math.abs(nav_fyt_list[nav_fyt+1].lon)))*60)

        CMFD.NAV_FYT_ELV:set(nav_fyt_list[nav_fyt+1].altitude)

        CMFD.NAV_FYT_DTK_BRG:set(hdg )
        CMFD.NAV_FYT_DTK_BRG_TEXT:set(math.floor(hdg + 0.5) % 360)
        CMFD.NAV_FYT_DTK_DIST:set(distance * 0.000539957)
        CMFD.NAV_FYT_DTK_ELV:set(elev * 3.28084)
        CMFD.NAV_FYT_DTK_AZIMUTH:set(azimuth)
        CMFD.NAV_FYT_DTK_ELEVATION:set(elevation)

        CMFD.NAV_FYT_LAT_M:set(nav_fyt_list[nav_fyt+1].lat_m)
        CMFD.NAV_FYT_LON_M:set(nav_fyt_list[nav_fyt+1].lon_m)
        CMFD.NAV_FYT_ALT_M:set(nav_fyt_list[nav_fyt+1].altitude/3.28084)

        CMFD.NAV_FYT_OAP_BRG:set(nav_fyt_list[nav_fyt+1].oap_brg)
        CMFD.NAV_FYT_OAP_DIST:set(nav_fyt_list[nav_fyt+1].oap_rng)
        CMFD.NAV_FYT_OAP_ELV:set(nav_fyt_list[nav_fyt+1].oap_rng)

        CMFD.NAV_FYT_VALID:set(1)
    else
        CMFD.NAV_FYT_HOURS:set(0)
        CMFD.NAV_FYT_MINS:set(0)
        CMFD.NAV_FYT_SECS:set(0)

        CMFD.NAV_FYT_DTK_MINS:set(0)
        CMFD.NAV_FYT_DTK_SECS:set(0)

        CMFD.NAV_FYT_LAT_DEG:set(0)
        CMFD.NAV_FYT_LAT_MIN:set(0)

        CMFD.NAV_FYT_LON_DEG:set(0)
        CMFD.NAV_FYT_LON_MIN:set(0)

        CMFD.NAV_FYT_ELV:set(0)

        CMFD.NAV_FYT_DTK_BRG:set(0)
        CMFD.NAV_FYT_DTK_BRG_TEXT:set(0)
        CMFD.NAV_FYT_DTK_DIST:set(0)
        CMFD.NAV_FYT_DTK_ELV:set(0)
        CMFD.NAV_FYT_DTK_AZIMUTH:set(0)
        CMFD.NAV_FYT_DTK_ELEVATION:set(0)

        CMFD.NAV_FYT_LAT_M:set(0)
        CMFD.NAV_FYT_LON_M:set(0)
        CMFD.NAV_FYT_ALT_M:set(0)

        CMFD.NAV_FYT_OAP_BRG:set(0)
        CMFD.NAV_FYT_OAP_DIST:set(0)
        CMFD.NAV_FYT_OAP_ELV:set(0)

        CMFD.NAV_FYT_VALID:set(0)
    end

    if CMFD_NAV_FORMAT:get() == CMFD_NAV_FORMAT_IDS.ROUT then 
        local text =    "WP       HDG       DIS       ELV         TOFT  \n"
        for i = 1,30 do
            local index_i = 30*cmfd_nav_page + i
            local index = wpt_index[index_i]
           
            if index > 80 then break end
            
            text = text ..  "\n"
            if index_i < #wpt_index then 
                text = text .. string.format("%2.0f       %03.0f     %5.0f     %5.0f       %02.0f:%02.0f:%02.0f", index-1, nav_fyt_list[index].hdg or 0, nav_fyt_list[index].dis or 0, nav_fyt_list[index].altitude or 0, nav_fyt_list[index].time_hours or 0, nav_fyt_list[index].time_mins or 0, nav_fyt_list[index].time_secs or 0)
            elseif index_i == #wpt_index then 
                text = text .. string.format("%2.0f                         %5.0f       %02.0f:%02.0f:%02.0f", index-1, nav_fyt_list[index].altitude or 0, nav_fyt_list[index].time_hours or 0, nav_fyt_list[index].time_mins or 0, nav_fyt_list[index].time_secs or 0)
            end
        end

        CMFD_NAV_ROUT_TEXT:set(text:sub(1,500))
        if text:len() > 500 then 
            CMFD_NAV_ROUT_TEXT1:set(text:sub(501,1000))
        else
            CMFD_NAV_ROUT_TEXT1:set("")
        end
        if text:len() > 1000 then 
            CMFD_NAV_ROUT_TEXT2:set(text:sub(1001))
        else
            CMFD_NAV_ROUT_TEXT2:set("")
        end
        if cmfd_nav_page > #wpt_index / 30 then cmfd_nav_page = math.floor(#wpt_index / 30) end
        if cmfd_nav_page < 0 then cmfd_nav_page = 0 end
        if cmfd_nav_page > 0 then CMFD_NAV_PG_PREV:set(1) else CMFD_NAV_PG_PREV:set(0) end
        if cmfd_nav_page < math.floor(#wpt_index / 30) then CMFD_NAV_PG_NEXT:set(1) else CMFD_NAV_PG_NEXT:set(0) end
    elseif CMFD_NAV_FORMAT:get() == CMFD_NAV_FORMAT_IDS.AC then
        local text =    ""
        local lat_m, alt_m, lon_m = sensor_data.getSelfCoordinates()
        local lat, lon = Terrain.convertMetersToLatLon(lat_m, lon_m)
        local velx, vely, velz = sensor_data.getSelfVelocity()
        local vel = math.sqrt(velx*velx + velz*velz) * 1.94384
        local vel_air_x, vel_air_y, vel_air_z = sensor_data.getSelfAirspeed()
        local windvel = get_distance(vel_air_x, vel_air_y, velx, vely) * 1.94384
        local winddir = get_heading(velx, vely, vel_air_x, vel_air_y)
        if windvel == 0 then winddir = 0 end

        text = text .. "   LAT      "
        if lat >= 0 then text = text .. "N " else text = text .. "S " end
        text = text .. string.format("%02.0f`%05.2f'\n\n", math.floor(math.abs(lat)), (math.abs(lat)-math.floor(math.abs(lat)))*60)
        text = text .. "   LON      "
        if lon >= 0 then text = text .. "E" else text = text .. "W " end
        text = text .. string.format("%03.0f`%05.2f'\n\n", math.floor(math.abs(lon)), (math.abs(lon)-math.floor(math.abs(lon)))*60)
        text = text .. "    GS      "
        text = text .. string.format("%03.0f KT     \n\n", vel)
        text = text .. "   TAS      "
        text = text .. string.format("%03.0f KT     \n\n", sensor_data.getTrueAirSpeed() * 1.94384)
        text = text .. "  MHDG      "
        text = text .. string.format("%03.0f`       \n\n", math.floor(get_avionics_hdg()))
        text = text .. "   TRK      "
        text = text .. string.format("%03.0f`       \n\n", math.floor(get_heading(velx, velz, 0, 0)))
        text = text .. "  WIND      "
        text = text .. string.format("%03.0f`/%03.0f KT\n\n\n\n\n\n\n\n", winddir, windvel)
        
        CMFD_NAV_AC_TEXT:set(text)

        CMFD_NAV_PG_PREV:set(0)
        CMFD_NAV_PG_NEXT:set(0)

    elseif CMFD_NAV_FORMAT:get() == CMFD_NAV_FORMAT_IDS.AFLD then
        local text = "WP  AFLD        LAT          LON        ELV\n\n"
        local line = ""
        for i=91, 100 do
            if nav_fyt_list[i] and nav_fyt_list[i].lat ~= 0 and nav_fyt_list[i].lon ~= 0 then
                line = string.format("%02.0f  %s    ",i-1, nav_fyt_list[i].code or "    ")
                if nav_fyt_list[i].lat >= 0 then line = line .. "N " else line = line .. "S " end
                line = line .. string.format("%02.0f`%05.2f'  ", math.floor(math.abs(nav_fyt_list[i].lat)), (math.abs(nav_fyt_list[i].lat)-math.floor(math.abs(nav_fyt_list[i].lat)))*60)
                if nav_fyt_list[i].lon >= 0 then line = line .. "E" else line = line .. "W" end
                line = line .. string.format("%03.0f`%05.2f'  ", math.floor(math.abs(nav_fyt_list[i].lon)), (math.abs(nav_fyt_list[i].lon)-math.floor(math.abs(nav_fyt_list[i].lon)))*60)
                line = line .. string.format("%5.0f", nav_fyt_list[i].altitude)
                text = text .. line .. "\n"
            end
        end
        CMFD_NAV_AFLD_TEXT:set(text)

    elseif CMFD_NAV_FORMAT:get() == CMFD_NAV_FORMAT_IDS.MARK then
        local text = "MP     LAT          LON        ELV    TIME  \n\n"
        local line = ""
        for k=1, 10 do
            local i = 91-k
            if nav_fyt_list[i] and nav_fyt_list[i].lat ~= 0 and nav_fyt_list[i].lon ~= 0 then
                line = string.format("%02.0f  ",i-1)
                if nav_fyt_list[i].lat >= 0 then line = line .. "N" else line = line .. "S" end
                line = line .. string.format("%02.0f`%05.2f'  ", math.floor(math.abs(nav_fyt_list[i].lat)), (math.abs(nav_fyt_list[i].lat)-math.floor(math.abs(nav_fyt_list[i].lat)))*60)
                if nav_fyt_list[i].lon >= 0 then line = line .. "E" else line = line .. "W" end
                line = line .. string.format("%03.0f`%05.2f'  ", math.floor(math.abs(nav_fyt_list[i].lon)), (math.abs(nav_fyt_list[i].lon)-math.floor(math.abs(nav_fyt_list[i].lon)))*60)
                line = line .. string.format("%5.0f  ", nav_fyt_list[i].altitude)
                line = line .. string.format("%02.0f:%02.0f:%02.0f", nav_fyt_list[i].time_hours or 0, nav_fyt_list[i].time_mins or 0, nav_fyt_list[i].time_secs or 0)
                text = text .. line .. "\n"
                if k == 5 then text = text ..  "\n" end
            end
        end
        CMFD_NAV_MARK_TEXT:set(text)

    else
        CMFD_NAV_PG_PREV:set(0)
        CMFD_NAV_PG_NEXT:set(0)
    end

end

dev:listen_command(device_commands.NAV_INC_FYT)
dev:listen_command(device_commands.NAV_DEC_FYT)
dev:listen_command(device_commands.NAV_SET_FYT)


function SetCommandNav(command,value, CMFD)
    if (command==device_commands.CMFD1OSS1 or command==device_commands.CMFD2OSS1) and value == 1 then 
            nav_format = CMFD_NAV_FORMAT_IDS.ROUT
    elseif (command==device_commands.CMFD1OSS2 or command==device_commands.CMFD2OSS2) and value == 1 then
        if CMFD_NAV_FORMAT:get() == CMFD_NAV_FORMAT_IDS.ROUT and CMFD_NAV_PG_NEXT:get() == 1 then  cmfd_nav_page = cmfd_nav_page + 1 end
    elseif (command==device_commands.CMFD1OSS3 or command==device_commands.CMFD2OSS3) and value == 1 then 
        if CMFD_NAV_FORMAT:get() == CMFD_NAV_FORMAT_IDS.ROUT and CMFD_NAV_PG_PREV:get() == 1 then  cmfd_nav_page = cmfd_nav_page - 1 end
    elseif (command==device_commands.CMFD1OSS4 or command==device_commands.CMFD2OSS4) and value == 1 then
        nav_format = CMFD_NAV_FORMAT_IDS.FYT
    elseif (command==device_commands.CMFD1OSS5 or command==device_commands.CMFD2OSS5) and value == 1 then
        nav_format = CMFD_NAV_FORMAT_IDS.MARK
    elseif (command==device_commands.CMFD1OSS7 or command==device_commands.CMFD2OSS7) and value == 1 then
        nav_format = CMFD_NAV_FORMAT_IDS.AC
    elseif (command==device_commands.CMFD1OSS27 or command==device_commands.CMFD2OSS27) and nav_format == CMFD_NAV_FORMAT_IDS.FYT and value == 1 then
        nav_fyt = cmfd_nav_sel_next_wpt()
    elseif (command==device_commands.CMFD1OSS26 or command==device_commands.CMFD2OSS26) and nav_format == CMFD_NAV_FORMAT_IDS.FYT and value == 1 then
        nav_fyt = cmfd_nav_sel_prev_wpt()
    elseif (command==device_commands.CMFD1OSS28 or command==device_commands.CMFD2OSS28) and value == 1 then 
        nav_format = CMFD_NAV_FORMAT_IDS.AFLD
    elseif command==device_commands.NAV_INC_FYT and value == 1 then 
        nav_fyt = cmfd_nav_sel_next_wpt()
    elseif command==device_commands.NAV_DEC_FYT and value == 1 then
        nav_fyt = cmfd_nav_sel_prev_wpt()
    elseif command==device_commands.NAV_SET_FYT then
        nav_fyt = value + 1
        nav_fyt = cmfd_nav_sel_prev_wpt()
    end
end

function post_initialize_nav()
    if terrainAirdromes then
        local posx, posy, posz = sensor_data.getSelfCoordinates()
        for i,airdrome in pairs(terrainAirdromes) do
            Airdromes[i] = {}
            Airdromes[i].code = airdrome.code or string.sub(airdrome.id,1,4) or "XXXX"
            Airdromes[i].x = airdrome.reference_point.x or 0
            Airdromes[i].y = airdrome.reference_point.y or 0
            Airdromes[i].lat, Airdromes[i].lon = Terrain.convertMetersToLatLon(Airdromes[i].x, Airdromes[i].y)
            Airdromes[i].elv = Terrain.GetHeight(Airdromes[i].x, Airdromes[i].y) * 3.28084
            Airdromes[i].dist = get_distance(Airdromes[i].x, Airdromes[i].y, posx, posz)
        end
        local i = 91
        for k,airdrome in spairs(Airdromes, function(t,a,b) return t[b].dist > t[a].dist end) do
            nav_fyt_list[i] = {}
            nav_fyt_list[i].lat = Airdromes[k].lat
            nav_fyt_list[i].lon = Airdromes[k].lon
            nav_fyt_list[i].lat_m = Airdromes[k].x
            nav_fyt_list[i].lon_m = Airdromes[k].y
            nav_fyt_list[i].altitude = Airdromes[k].elv
            nav_fyt_list[i].code = Airdromes[k].code
            nav_fyt_list[i].hdg = 0
            nav_fyt_list[i].dis = 0
            nav_fyt_list[i].oap_brg = 0
            nav_fyt_list[i].oap_rng = 0
            nav_fyt_list[i].oap_elev = Airdromes[k].elv

            i = i + 1
            if i >= 101 then break end
        end
    end

    route = get_mission_route()
    if route then
        for i=1,#route do
            nav_fyt_list[i] = {}
            if route[i].alt_type == "BARO" then
                nav_fyt_list[i].altitude = route[i].alt * 3.28084
            else
                nav_fyt_list[i].altitude = (Terrain.GetHeight(route[i].x, route[i].y) + route[i].alt) * 3.28084
            end
            nav_fyt_list[i].lat, nav_fyt_list[i].lon = Terrain.convertMetersToLatLon(route[i].x, route[i].y)
            nav_fyt_list[i].lat_m = route[i].x
            nav_fyt_list[i].lon_m = route[i].y
            nav_fyt_list[i].speed = route[i].speed
            nav_fyt_list[i].time = 0
            nav_fyt_list[i].oap_brg = 0
            nav_fyt_list[i].oap_rng = 0
            nav_fyt_list[i].oap_elev = nav_fyt_list[i].altitude

            if i>1 then
                nav_fyt_list[i-1].hdg = get_heading(nav_fyt_list[i].lat_m, nav_fyt_list[i].lon_m, nav_fyt_list[i-1].lat_m, nav_fyt_list[i-1].lon_m)
                nav_fyt_list[i-1].dis = get_distance(nav_fyt_list[i].lat_m, nav_fyt_list[i].lon_m, nav_fyt_list[i-1].lat_m, nav_fyt_list[i-1].lon_m) * 0.000539957
            end
            
            if i == 1 then 
                nav_fyt_list[i].time = nav_fyt_list[i].time + get_absolute_model_time()
            elseif route[i].ETA_locked == true then 
                nav_fyt_list[i].time = route[i].ETA + get_absolute_model_time()
            elseif nav_fyt_list[i-1].speed > 0 then
                nav_fyt_list[i].time = nav_fyt_list[i-1].time + nav_fyt_list[i-1].dis / nav_fyt_list[i-1].speed / 0.000539957
            else
                nav_fyt_list[i].time = nav_fyt_list[i-1].time
            end

            nav_fyt_list[i].time_secs = math.floor(nav_fyt_list[i].time % 60)
            nav_fyt_list[i].time_mins = math.floor((nav_fyt_list[i].time / 60) % 60)
            nav_fyt_list[i].time_hours =  math.floor(nav_fyt_list[i].time / 3600)
    
            if nav_fyt_list[i].time_hours >= 100 then
                nav_fyt_list[i].time_secs = 59
                nav_fyt_list[i].time_mins = 59
                nav_fyt_list[i].time_hours =  99
            end
        end
    end
    if nav_fyt_list[2] == nil then
            nav_fyt = 0
    end
    wpt_index = get_valid_wpt_list()

end

-- get_mission_route = {}
-- get_mission_route[1] = {}
-- get_mission_route[1]["speed_locked"] = true
-- get_mission_route[1]["airdromeId"] = 27
-- get_mission_route[1]["action"] = "Fly Over Point"
-- get_mission_route[1]["alt_type"] = "BARO"
-- get_mission_route[1]["ETA"] = 0
-- get_mission_route[1]["alt"] = 2000
-- get_mission_route[1]["y"] = 760569.71987102
-- get_mission_route[1]["x"] = -124824.02621349
-- get_mission_route[1]["name"] = "DictKey_WptName_18"
-- get_mission_route[1]["ETA_locked"] = true
-- get_mission_route[1]["speed"] = 75
-- get_mission_route[1]["formation_template"] = ""
-- get_mission_route[1]["task"] = {}
-- get_mission_route[1]["task"]["id"] = "ComboTask"
-- get_mission_route[1]["task"]["params"] = {}
-- get_mission_route[1]["task"]["params"]["tasks"] = {}
-- get_mission_route[1]["type"] = "Turning Point"
-- get_mission_route[2] = {}
-- get_mission_route[2]["speed_locked"] = true
-- get_mission_route[2]["type"] = "TakeOff"
-- get_mission_route[2]["action"] = "From Runway"
-- get_mission_route[2]["alt_type"] = "BARO"
-- get_mission_route[2]["ETA"] = 0
-- get_mission_route[2]["y"] = 789260.82061283
-- get_mission_route[2]["x"] = -122670.06493381
-- get_mission_route[2]["name"] = "DictKey_WptName_19"
-- get_mission_route[2]["formation_template"] = ""
-- get_mission_route[2]["speed"] = 138.88888888889
-- get_mission_route[2]["ETA_locked"] = false
-- get_mission_route[2]["task"] = {}
-- get_mission_route[2]["task"]["id"] = "ComboTask"
-- get_mission_route[2]["task"]["params"] = {}
-- get_mission_route[2]["task"]["params"]["tasks"] = {}
-- get_mission_route[2]["alt"] = 267
-- 


-- Terrain = {}
-- Terrain["GetSurfaceType"] = function: 000001493F0A1FB0
-- Terrain["GetTerrainConfig"] = function: 000001493F0A1D70
-- Terrain["findPathOnRoads"] = function: 000001493F0A2EE0
-- Terrain["getObjectsAtMapPoint"] = function: 000001493F0A33F0
-- Terrain["getStandList"] = function: 000001493F0A2250
-- Terrain["getTechSkinByDate"] = function: 000001493F0A2DF0
-- Terrain["GetSurfaceHeightWithSeabed"] = function: 000001493F0A2160
-- Terrain["getBeacons"] = function: 000001493F0A24C0
-- Terrain["InitLight"] = function: 000001493F0A1B60
-- Terrain["getCrossParam"] = function: 000001493F0A2340
-- Terrain["convertMGRStoMeters"] = function: 000001493F0A2280
-- Terrain["getRunwayList"] = function: 000001493F0A2400
-- Terrain["getClosestPointOnRoads"] = function: 000001493F0A3390
-- Terrain["getTempratureRangeByDate"] = function: 000001493F0A30C0
-- Terrain["isVisible"] = function: 000001493F0A1F20
-- Terrain["getRadio"] = function: 000001493F0A2FD0
-- Terrain["Init"] = function: 000001493F0A1170
-- Terrain["getClosestValidPoint"] = function: 000001493F0A2B50
-- Terrain["getObjectPosition"] = function: 000001493F0A2700
-- Terrain["Create"] = function: 000001493F0A2730
-- Terrain["getRunwayHeading"] = function: 000001493F0A2460
-- Terrain["FindNearestPoint"] = function: 000001493F0A1D10
-- Terrain["GetHeight"] = function: 000001493F0A21C0
-- Terrain["convertLatLonToMeters"] = function: 000001493F0A2310
-- Terrain["GetSeasons"] = function: 000001493F0A11A0
-- Terrain["Release"] = function: 000001493F0A1A40
-- Terrain["FindOptimalPath"] = function: 000001493F0A22B0
-- Terrain["convertMetersToLatLon"] = function: 000001493F0A2070
-- Terrain["GetMGRScoordinates"] = function: 000001493F0A2040


-- get_terrain_related_data("Airdromes")
-- airdrome = {}
-- airdrome["reference_point"] = {}
-- airdrome["reference_point"]["y"] = 243128.820313
-- airdrome["reference_point"]["x"] = -5412.409668
-- airdrome["fueldepots"] = {}
-- airdrome["fueldepots"][1] = "externalId:220001"
-- airdrome["fueldepots"][2] = "externalId:220002"
-- airdrome["fueldepots"][3] = "externalId:220003"
-- airdrome["fueldepots"][4] = "externalId:220004"
-- airdrome["fueldepots"][5] = "externalId:220005"
-- airdrome["fueldepots"][6] = "externalId:220006"
-- airdrome["fueldepots"][7] = "externalId:220007"
-- airdrome["fueldepots"][8] = "externalId:220008"
-- airdrome["fueldepots"][9] = "externalId:220009"
-- airdrome["fueldepots"][10] = "externalId:220010"
-- airdrome["fueldepots"][11] = "externalId:220011"
-- airdrome["fueldepots"][12] = "externalId:220012"
-- airdrome["fueldepots"][13] = "externalId:220013"
-- airdrome["fueldepots"][14] = "externalId:220014"
-- airdrome["fueldepots"][15] = "externalId:220015"
-- airdrome["fueldepots"][16] = "externalId:220016"
-- airdrome["fueldepots"][17] = "externalId:220017"
-- airdrome["code"] = "URKA"
-- airdrome["runways"] = {}
-- airdrome["runways"][0] = {}
-- airdrome["runways"][0]["start"] = "22"
-- airdrome["runways"][0]["id"] = 1
-- airdrome["runways"][0]["name"] = "22-04"
-- airdrome["runways"][0]["end"] = "04"
-- airdrome["projectors"] = {}
-- airdrome["projectors"][1] = {}
-- airdrome["projectors"][1]["sceneObjects"] = {}
-- airdrome["projectors"][1]["sceneObjects"][1] = "externalId:220130"
-- airdrome["projectors"][1]["sceneObjects"][2] = "externalId:220131"
-- airdrome["projectors"][1]["runwayId"] = 1
-- airdrome["projectors"][1]["runwaySide"] = "22"
-- airdrome["projectors"][0] = {}
-- airdrome["projectors"][0]["sceneObjects"] = {}
-- airdrome["projectors"][0]["sceneObjects"][1] = "externalId:220128"
-- airdrome["projectors"][0]["sceneObjects"][2] = "externalId:220129"
-- airdrome["projectors"][0]["runwayId"] = 1
-- airdrome["projectors"][0]["runwaySide"] = "04"
-- airdrome["names"] = {}
-- airdrome["names"]["en"] = "Anapa-Vityazevo"
-- airdrome["default_camera_position"] = {}
-- airdrome["default_camera_position"]["bearing"] = 164.60256
-- airdrome["default_camera_position"]["pnt"] = {}
-- airdrome["default_camera_position"]["pnt"][1] = -4737.000488
-- airdrome["default_camera_position"]["pnt"][2] = 145
-- airdrome["default_camera_position"]["pnt"][3] = 242694.875
-- airdrome["display_name"] = "Anapa-Vityazevo"
-- airdrome["radio"] = {}
-- airdrome["radio"][1] = "airfield12_0"
-- airdrome["civilian"] = true
-- airdrome["runwayName"] = {}
-- airdrome["runwayName"][1] = "04"
-- airdrome["runwayName"][0] = "22"
-- airdrome["towers"] = {}
-- airdrome["towers"][1] = "externalId:220000"
-- airdrome["roadnet5"] = "./Mods/terrains/Caucasus/AirfieldsTaxiways/Anapa.rn5"
-- airdrome["abandoned"] = false
-- airdrome["roadnet"] = "./Mods/terrains/Caucasus/AirfieldsTaxiways/Anapa.rn4"
-- airdrome["shelters"] = {}
-- airdrome["shelters"][1] = "externalId:220018"
-- airdrome["shelters"][2] = "externalId:220019"
-- airdrome["shelters"][3] = "externalId:220020"
-- airdrome["shelters"][4] = "externalId:220021"
-- airdrome["shelters"][5] = "externalId:220022"
-- airdrome["shelters"][6] = "externalId:220023"
-- airdrome["shelters"][7] = "externalId:220024"
-- airdrome["shelters"][8] = "externalId:220025"
-- airdrome["shelters"][9] = "externalId:220026"
-- airdrome["shelters"][10] = "externalId:220027"
-- airdrome["shelters"][11] = "externalId:220028"
-- airdrome["shelters"][12] = "externalId:220029"
-- airdrome["shelters"][13] = "externalId:220030"
-- airdrome["shelters"][14] = "externalId:220031"
-- airdrome["shelters"][15] = "externalId:220032"
-- airdrome["shelters"][16] = "externalId:220033"
-- airdrome["shelters"][17] = "externalId:220034"
-- airdrome["shelters"][18] = "externalId:220035"
-- airdrome["shelters"][19] = "externalId:220036"
-- airdrome["shelters"][20] = "externalId:220037"
-- airdrome["shelters"][21] = "externalId:220038"
-- airdrome["shelters"][22] = "externalId:220039"
-- airdrome["shelters"][23] = "externalId:220040"
-- airdrome["shelters"][24] = "externalId:220041"
-- airdrome["shelters"][25] = "externalId:220042"
-- airdrome["shelters"][26] = "externalId:220043"
-- airdrome["shelters"][27] = "externalId:220044"
-- airdrome["shelters"][28] = "externalId:220045"
-- airdrome["shelters"][29] = "externalId:220046"
-- airdrome["shelters"][30] = "externalId:220047"
-- airdrome["shelters"][31] = "externalId:220048"
-- airdrome["shelters"][32] = "externalId:220049"
-- airdrome["shelters"][33] = "externalId:220050"
-- airdrome["shelters"][34] = "externalId:220051"
-- airdrome["shelters"][35] = "externalId:220052"
-- airdrome["shelters"][36] = "externalId:220053"
-- airdrome["shelters"][37] = "externalId:220054"
-- airdrome["shelters"][38] = "externalId:220055"
-- airdrome["shelters"][39] = "externalId:220056"
-- airdrome["shelters"][40] = "externalId:220057"
-- airdrome["shelters"][41] = "externalId:220058"
-- airdrome["shelters"][42] = "externalId:220059"
-- airdrome["shelters"][43] = "externalId:220060"
-- airdrome["shelters"][44] = "externalId:220061"
-- airdrome["shelters"][45] = "externalId:220062"
-- airdrome["shelters"][46] = "externalId:220063"
-- airdrome["shelters"][47] = "externalId:220064"
-- airdrome["shelters"][48] = "externalId:220065"
-- airdrome["shelters"][49] = "externalId:220066"
-- airdrome["shelters"][50] = "externalId:220067"
-- airdrome["shelters"][51] = "externalId:220068"
-- airdrome["shelters"][52] = "externalId:220069"
-- airdrome["warehouses"] = {}
-- airdrome["warehouses"][1] = "externalId:220070"
-- airdrome["warehouses"][2] = "externalId:220071"
-- airdrome["warehouses"][3] = "externalId:220072"
-- airdrome["warehouses"][4] = "externalId:220073"
-- airdrome["warehouses"][5] = "externalId:220074"
-- airdrome["warehouses"][6] = "externalId:220075"
-- airdrome["warehouses"][7] = "externalId:220076"
-- airdrome["warehouses"][8] = "externalId:220077"
-- airdrome["warehouses"][9] = "externalId:220078"
-- airdrome["warehouses"][10] = "externalId:220079"
-- airdrome["warehouses"][11] = "externalId:220080"
-- airdrome["warehouses"][12] = "externalId:220081"
-- airdrome["warehouses"][13] = "externalId:220082"
-- airdrome["warehouses"][14] = "externalId:220083"
-- airdrome["warehouses"][15] = "externalId:220084"
-- airdrome["warehouses"][16] = "externalId:220085"
-- airdrome["warehouses"][17] = "externalId:220086"
-- airdrome["warehouses"][18] = "externalId:220087"
-- airdrome["warehouses"][19] = "externalId:220088"
-- airdrome["warehouses"][20] = "externalId:220089"
-- airdrome["warehouses"][21] = "externalId:220090"
-- airdrome["warehouses"][22] = "externalId:220091"
-- airdrome["warehouses"][23] = "externalId:220092"
-- airdrome["warehouses"][24] = "externalId:220093"
-- airdrome["warehouses"][25] = "externalId:220094"
-- airdrome["warehouses"][26] = "externalId:220095"
-- airdrome["warehouses"][27] = "externalId:220096"
-- airdrome["warehouses"][28] = "externalId:220097"
-- airdrome["warehouses"][29] = "externalId:220098"
-- airdrome["warehouses"][30] = "externalId:220099"
-- airdrome["warehouses"][31] = "externalId:220100"
-- airdrome["warehouses"][32] = "externalId:220101"
-- airdrome["warehouses"][33] = "externalId:220102"
-- airdrome["warehouses"][34] = "externalId:220103"
-- airdrome["warehouses"][35] = "externalId:220104"
-- airdrome["warehouses"][36] = "externalId:220105"
-- airdrome["warehouses"][37] = "externalId:220106"
-- airdrome["warehouses"][38] = "externalId:220107"
-- airdrome["warehouses"][39] = "externalId:220108"
-- airdrome["warehouses"][40] = "externalId:220109"
-- airdrome["warehouses"][41] = "externalId:220110"
-- airdrome["warehouses"][42] = "externalId:220111"
-- airdrome["warehouses"][43] = "externalId:220112"
-- airdrome["warehouses"][44] = "externalId:220113"
-- airdrome["warehouses"][45] = "externalId:220114"
-- airdrome["warehouses"][46] = "externalId:220115"
-- airdrome["warehouses"][47] = "externalId:220116"
-- airdrome["warehouses"][48] = "externalId:220117"
-- airdrome["warehouses"][49] = "externalId:220118"
-- airdrome["warehouses"][50] = "externalId:220119"
-- airdrome["warehouses"][51] = "externalId:220120"
-- airdrome["warehouses"][52] = "externalId:220121"
-- airdrome["warehouses"][53] = "externalId:220122"
-- airdrome["warehouses"][54] = "externalId:220123"
-- airdrome["warehouses"][55] = "externalId:220124"
-- airdrome["warehouses"][56] = "externalId:220125"
-- airdrome["warehouses"][57] = "externalId:220126"
-- airdrome["warehouses"][58] = "externalId:220127"
-- airdrome["id"] = "Anapa"
-- airdrome["beacons"] = {}
-- airdrome["beacons"][1] = {}
-- airdrome["beacons"][1]["runwayName"] = "04-22"
-- airdrome["beacons"][1]["runwayId"] = 1
-- airdrome["beacons"][1]["runwaySide"] = "22"
-- airdrome["beacons"][1]["beaconId"] = "airfield12_1"
-- airdrome["beacons"][2] = {}
-- airdrome["beacons"][2]["runwayName"] = "04-22"
-- airdrome["beacons"][2]["runwayId"] = 1
-- airdrome["beacons"][2]["runwaySide"] = "04"
-- airdrome["beacons"][2]["beaconId"] = "airfield12_2"
-- airdrome["beacons"][3] = {}
-- airdrome["beacons"][3]["runwayName"] = "04-22"
-- airdrome["beacons"][3]["runwayId"] = 1
-- airdrome["beacons"][3]["runwaySide"] = "04"
-- airdrome["beacons"][3]["beaconId"] = "airfield12_3"
-- airdrome["beacons"][0] = {}
-- airdrome["beacons"][0]["runwayName"] = "04-22"
-- airdrome["beacons"][0]["runwayId"] = 1
-- airdrome["beacons"][0]["runwaySide"] = "22"
-- airdrome["beacons"][0]["beaconId"] = "airfield12_0"
-- airdrome["class"] = "1"