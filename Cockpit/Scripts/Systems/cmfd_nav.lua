dofile(LockOn_Options.script_path.."CMFD/CMFD_NAV_ID_defs.lua")


local CMFD_NAV_FYT_VALID = get_param_handle("CMFD_NAV_FYT_VALID")
local CMFD_NAV_FORMAT = get_param_handle("CMFD_NAV_FORMAT")
local CMFD_NAV_FYT = get_param_handle("CMFD_NAV_FYT")
local CMFD_NAV_FYT_ELV = get_param_handle("CMFD_NAV_FYT_ELV")
local CMFD_NAV_FYT_HOURS = get_param_handle("CMFD_NAV_FYT_HOURS")
local CMFD_NAV_FYT_MINS = get_param_handle("CMFD_NAV_FYT_MINS")
local CMFD_NAV_FYT_SECS = get_param_handle("CMFD_NAV_FYT_SECS")
local CMFD_NAV_FYT_LAT_DEG = get_param_handle("CMFD_NAV_FYT_LAT_DEG")
local CMFD_NAV_FYT_LAT_MIN = get_param_handle("CMFD_NAV_FYT_LAT_MIN")
local CMFD_NAV_FYT_LON_DEG = get_param_handle("CMFD_NAV_FYT_LON_DEG")
local CMFD_NAV_FYT_LON_MIN = get_param_handle("CMFD_NAV_FYT_LON_MIN")
local CMFD_NAV_FYT_OAP_BRG = get_param_handle("CMFD_NAV_FYT_OAP_BRG")
local CMFD_NAV_FYT_OAP_BRG_TEXT = get_param_handle("CMFD_NAV_FYT_OAP_BRG_TEXT")
local CMFD_NAV_FYT_OAP_DIST = get_param_handle("CMFD_NAV_FYT_OAP_DIST")
local CMFD_NAV_FYT_OAP_ELV = get_param_handle("CMFD_NAV_FYT_OAP_ELV")
local CMFD_NAV_FYT_OAP_MINS = get_param_handle("CMFD_NAV_FYT_OAP_MINS")
local CMFD_NAV_FYT_OAP_SECS = get_param_handle("CMFD_NAV_FYT_OAP_SECS")
local CMFD_NAV_FYT_OAP_AZIMUTH = get_param_handle("CMFD_NAV_FYT_OAP_AZIMUTH")
local CMFD_NAV_FYT_OAP_ELEVATION = get_param_handle("CMFD_NAV_FYT_OAP_ELEVATION")
local CMFD_NAV_ROUT_TEXT = get_param_handle("CMFD_NAV_ROUT_TEXT")

local nav_format = CMFD_NAV_FORMAT_IDS.FYT
local nav_fyt = 1
local route
local nav_fyt_list = {}

Terrain = require('terrain')

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
    return hdg
end

local count = 0
local freq = 10/ update_time_step
local vel_history = {}
local vel = 0
function update_nav()
    count = count + 1
    CMFD_NAV_FORMAT:set(nav_format)
    CMFD_NAV_FYT:set(nav_fyt+1)
    
    if nav_fyt < #nav_fyt_list then
        local x, y, z = sensor_data:getSelfCoordinates()
        x = x - nav_fyt_list[nav_fyt+1].lat
        y = y - nav_fyt_list[nav_fyt+1].altitude / 3.28084
        z = z - nav_fyt_list[nav_fyt+1].lon
        local distance = math.sqrt(x*x + z*z) * 0.000539957
        local elev = y * 3.28084

        local hdg
        if x ~= 0 then 
            hdg= math.deg(math.atan(z/x))
        else 
            if z > 0  then hdg = 90 else hdg = -90 end
        end
        if x > 0 then hdg = hdg + 180 end
        hdg = hdg % 360

        local lat, lon = Terrain.convertMetersToLatLon(nav_fyt_list[nav_fyt+1].lat, nav_fyt_list[nav_fyt+1].lon)
        local velx, vely, velz = sensor_data.getSelfVelocity()

        if count == 1 or count % freq == 0 then
            local vel_index = math.floor((count / freq) % 6)
            vel = math.sqrt(velx * velx + vely * vely + velz * velz)
            vel_history[vel_index + 1] = vel
            vel = 0
            for i=1, #vel_history do
                vel = vel + vel_history[i]
            end
            vel = vel / #vel_history
        end
    
        local time = 100*60
        if vel > 0 then 
            time = math.sqrt(x*x + y*y + z*z) / vel
        end

        local time_secs = math.floor(time % 60)
        local time_mins = math.floor((time - time_secs) / 60)
        if time_mins >= 100 then 
            time_mins = 99
            time_secs = 59
        end
        
        local plane_hdg = math.deg(-sensor_data.getHeading())
        if plane_hdg < 0 then plane_hdg = 360 + plane_hdg end
        plane_hdg = plane_hdg % 360
        
        local azimuth 
        azimuth = math.rad(hdg - plane_hdg)
        local elevation = -math.atan( y /  math.sqrt(x*x + z*z) )
        local roll = sensor_data.getRoll()
        local pitch = sensor_data.getPitch()
        local s = math.sin(roll)
        local c = math.cos(roll)

        local new_azimuth = azimuth * c - elevation * s
        local new_elevation = azimuth * s + elevation * c
        azimuth = new_azimuth + pitch * s
        elevation = new_elevation - pitch * c

        CMFD_NAV_FYT_HOURS:set(nav_fyt_list[nav_fyt+1].time_hours)
        CMFD_NAV_FYT_MINS:set(nav_fyt_list[nav_fyt+1].time_mins)
        CMFD_NAV_FYT_SECS:set(nav_fyt_list[nav_fyt+1].time_secs)

        CMFD_NAV_FYT_OAP_MINS:set(time_mins)
        CMFD_NAV_FYT_OAP_SECS:set(time_secs)

        CMFD_NAV_FYT_LAT_DEG:set(math.floor(lat))
        CMFD_NAV_FYT_LAT_MIN:set((lat - math.floor(lat))*60)

        CMFD_NAV_FYT_LON_DEG:set(math.floor(lon))
        CMFD_NAV_FYT_LON_MIN:set((lon - math.floor(lon))*60)

        CMFD_NAV_FYT_ELV:set(nav_fyt_list[nav_fyt+1].altitude)

        CMFD_NAV_FYT_OAP_BRG:set(hdg )
        CMFD_NAV_FYT_OAP_BRG_TEXT:set(math.floor(hdg + 0.5) % 360)
        CMFD_NAV_FYT_OAP_DIST:set(distance)
        CMFD_NAV_FYT_OAP_ELV:set(elev)
        CMFD_NAV_FYT_OAP_AZIMUTH:set(azimuth)
        CMFD_NAV_FYT_OAP_ELEVATION:set(elevation)

        CMFD_NAV_FYT_VALID:set(1)
    else
        CMFD_NAV_FYT_HOURS:set(0)
        CMFD_NAV_FYT_MINS:set(0)
        CMFD_NAV_FYT_SECS:set(0)

        CMFD_NAV_FYT_OAP_MINS:set(0)
        CMFD_NAV_FYT_OAP_SECS:set(0)

        CMFD_NAV_FYT_LAT_DEG:set(0)
        CMFD_NAV_FYT_LAT_MIN:set(0)

        CMFD_NAV_FYT_LON_DEG:set(0)
        CMFD_NAV_FYT_LON_MIN:set(0)

        CMFD_NAV_FYT_ELV:set(0)

        CMFD_NAV_FYT_OAP_BRG:set(0)
        CMFD_NAV_FYT_OAP_BRG_TEXT:set(0)
        CMFD_NAV_FYT_OAP_DIST:set(0)
        CMFD_NAV_FYT_OAP_ELV:set(0)
        CMFD_NAV_FYT_OAP_AZIMUTH:set(0)
        CMFD_NAV_FYT_OAP_ELEVATION:set(0)

        CMFD_NAV_FYT_VALID:set(0)
    end

    local text =    "WP       HDG       DIS       ELV         TOFT  \n"
    for i=1,30 do
        local index = i
        text = text ..  "\n"
        local line = ""

        if index < #nav_fyt_list then 
            line = line .. string.format("%2.0f       %03.0f       %3.0f     %5.0f       %02.0f:%02.0f:%02.0f", index, nav_fyt_list[index].hdg, nav_fyt_list[index].dis, nav_fyt_list[index].altitude, nav_fyt_list[index].time_hours, nav_fyt_list[index].time_mins, nav_fyt_list[index].time_secs)
        elseif index == #nav_fyt_list then 
            line = line .. string.format("%2.0f                         %5.0f       %02.0f:%02.0f:%02.0f", index, nav_fyt_list[index].altitude, nav_fyt_list[index].time_hours, nav_fyt_list[index].time_mins, nav_fyt_list[index].time_secs)
        else
            break
        end
        text = text .. line
    end

    CMFD_NAV_ROUT_TEXT:set(text)


end

function SetCommandNav(command,value, CMFD)
    if value == 1 then
        if command==device_commands.CMFD1OSS1 or command==device_commands.CMFD2OSS1 then 
            nav_format = CMFD_NAV_FORMAT_IDS.ROUT
        elseif command==device_commands.CMFD1OSS4 or command==device_commands.CMFD2OSS4 then 
            nav_format = CMFD_NAV_FORMAT_IDS.FYT
        elseif command==device_commands.CMFD1OSS5 or command==device_commands.CMFD2OSS5 then 
            nav_format = CMFD_NAV_FORMAT_IDS.MARK
        elseif command==device_commands.CMFD1OSS7 or command==device_commands.CMFD2OSS7 then 
            nav_format = CMFD_NAV_FORMAT_IDS.AC
        elseif (command==device_commands.CMFD1OSS27 or command==device_commands.CMFD2OSS27) and nav_format == CMFD_NAV_FORMAT_IDS.FYT then
            nav_fyt = (nav_fyt + 1) % #nav_fyt_list
        elseif (command==device_commands.CMFD1OSS26 or command==device_commands.CMFD2OSS26) and nav_format == CMFD_NAV_FORMAT_IDS.FYT then
            nav_fyt = (nav_fyt - 1) % #nav_fyt_list
        elseif command==device_commands.CMFD1OSS28 or command==device_commands.CMFD2OSS28 then 
            nav_format = CMFD_NAV_FORMAT_IDS.AFLD
        end
    end
end

function post_initialize_nav()
    route = get_mission_route()
    if route then
        for i=1,#route do
            nav_fyt_list[i] = {}
            if route[i].alt_type == "BARO" then
                nav_fyt_list[i].altitude = route[i].alt * 3.28084
            else
                nav_fyt_list[i].altitude = (Terrain.GetHeight(route[i].x, route[i].y) + route[i].alt) * 3.28084
            end
            nav_fyt_list[i].lat = route[i].x
            nav_fyt_list[i].lon = route[i].y
            nav_fyt_list[i].speed = route[i].speed
            nav_fyt_list[i].time = 0

            if i>1 then
                nav_fyt_list[i-1].hdg = get_heading(nav_fyt_list[i].lat, nav_fyt_list[i].lon, nav_fyt_list[i-1].lat, nav_fyt_list[i-1].lon)
                nav_fyt_list[i-1].dis = get_distance(nav_fyt_list[i].lat, nav_fyt_list[i].lon, nav_fyt_list[i-1].lat, nav_fyt_list[i-1].lon) * 0.000539957
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
