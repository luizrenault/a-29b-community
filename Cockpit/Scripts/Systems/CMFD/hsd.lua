dofile(LockOn_Options.script_path.."Systems/ufcp_api.lua")
dofile(LockOn_Options.script_path.."CMFD/CMFD_HSD_ID_defs.lua")

local hsd_rad_sel = 20

local HSD_FORMAT = get_param_handle("CMFD_HSD_FORMAT")

local HSD_RAD_SEL = get_param_handle("HSD_RAD_SEL")

local ADHSI_DTK_HDG = get_param_handle("ADHSI_DTK_HDG")
local ADHSI_DTK_DIST = get_param_handle("ADHSI_DTK_DIST")
local ADHSI_DTK = get_param_handle("ADHSI_DTK")
local CMFD_NAV_FYT = get_param_handle("CMFD_NAV_FYT")
local HSD_DL_MODE = get_param_handle("CMFD_HSD_DL_MODE")

local HSD_DEP_CHECKED = get_param_handle("CMFD_HSD_DEP_CHECKED")
local HSD_SYM_CHECKED = get_param_handle("CMFD_HSD_SYM_CHECKED")
local HSD_ANM_CHECKED = get_param_handle("CMFD_HSD_ANM_CHECKED")
local HSD_ROUT_CHECKED = get_param_handle("CMFD_HSD_ROUT_CHECKED")
local HSD_BFI_CHECKED = get_param_handle("CMFD_HSD_BFI_CHECKED")
local HSD_DEL_CHECKED = get_param_handle("CMFD_HSD_DEL_CHECKED")
local HSD_ALL_CHECKED = get_param_handle("CMFD_HSD_ALL_CHECKED")
local HSD_AREA_CHECKED = get_param_handle("CMFD_HSD_AREA_CHECKED")
local HSD_WP_CHECKED = get_param_handle("CMFD_HSD_WP_CHECKED")
local HSD_INT_CHECKED = get_param_handle("CMFD_HSD_INT_CHECKED")
local HSD_STRM120_CHECKED = get_param_handle("CMFD_HSD_STRM120_CHECKED")
local HSD_SMTH_CHECKED = get_param_handle("CMFD_HSD_SMTH_CHECKED")
local HSD_MSG_CHECKED = get_param_handle("CMFD_HSD_MSG_CHECKED")

HSD_DEP_CHECKED:set(1)
HSD_SYM_CHECKED:set(0)
HSD_ANM_CHECKED:set(0)
HSD_ROUT_CHECKED:set(0)
HSD_BFI_CHECKED:set(0)
HSD_ALL_CHECKED:set(1)
HSD_DEL_CHECKED:set(0)
HSD_AREA_CHECKED:set(0)
HSD_WP_CHECKED:set(0)
HSD_INT_CHECKED:set(0)
HSD_STRM120_CHECKED:set(0)
HSD_SMTH_CHECKED:set(1)
HSD_MSG_CHECKED:set(1)
HSD_DL_MODE:set(CMFD_HSD_DL_IDS.ALL)

local format = CMFD_HSD_FORMAT_IDS.HSD

local function calc_brg_dist_elev_time(dest_lat_m, dest_lon_m, dest_alt_m, orig_lat_m, orig_lon_m, orig_alt_m)
    local o_lat_m, o_alt_m, o_lon_m = sensor_data.getSelfCoordinates()
    orig_lat_m = orig_lat_m or o_lat_m
    orig_lon_m = orig_lon_m or o_lon_m
    orig_alt_m = orig_alt_m or o_alt_m

    local brg, dist

    local lat = dest_lat_m - orig_lat_m
    local lon = dest_lon_m - orig_lon_m

    brg = math.atan2(lon, lat)
    dist = math.sqrt(lat * lat + lon * lon)

    return brg, dist
end

local function coord_project(orig_lat_m, orig_lon_m, brg, dist)
    orig_lat_m = orig_lat_m + dist * math.cos(math.rad(brg))
    orig_lon_m = orig_lon_m + dist * math.sin(math.rad(brg))
    return orig_lat_m, orig_lon_m
end

local function update_waypoints()
    for k=1,100 do
        if nav_fyt_list[k] and nav_fyt_list[k].lat >= -90 and nav_fyt_list[k].lat <= 90 and nav_fyt_list[k].lon >= -180 and nav_fyt_list[k].lon <= 180 then

            local dest_lat_m = nav_fyt_list[k].lat_m
            local dest_lon_m = nav_fyt_list[k].lon_m
            local dest_alt_m = nav_fyt_list[k].altitude / 3.28084

            local hdg, distance = calc_brg_dist_elev_time(dest_lat_m, dest_lon_m, dest_alt_m)
            hdg = math.deg(hdg) % 360

            get_param_handle("CMFD_HSD_WP" .. k .. "_ID"):set(string.format("%02d", k-1))
            get_param_handle("CMFD_HSD_WP" .. k .. "_BRG"):set(hdg)
            get_param_handle("CMFD_HSD_WP" .. k .. "_DIST"):set(distance * 0.000539957 / hsd_rad_sel)

            get_param_handle("CMFD_HSD_DTK" .. k .. "_BRG"):set(get_param_handle("CMFD_HSD_WP" .. k .. "_BRG"):get())
            get_param_handle("CMFD_HSD_DTK" .. k .. "_DIST"):set(get_param_handle("CMFD_HSD_WP" .. k .. "_DIST"):get())
            get_param_handle("CMFD_HSD_DTK" .. k):set((ADHSI_DTK:get() == 1 and CMFD_NAV_FYT:get() == k-1) and 1 or 0)

            if ADHSI_DTK:get() == 1 and CMFD_NAV_FYT:get() == k-1 then 
                dest_lat_m, dest_lon_m = coord_project(dest_lat_m, dest_lon_m, ADHSI_DTK_HDG:get()+180, ADHSI_DTK_DIST:get()/0.000539957)
                
                hdg, distance = calc_brg_dist_elev_time(dest_lat_m, dest_lon_m, dest_alt_m)
                hdg = math.deg(hdg) % 360

                get_param_handle("CMFD_HSD_WP" .. k .. "_BRG"):set(hdg)
                get_param_handle("CMFD_HSD_WP" .. k .. "_DIST"):set(distance * 0.000539957 / hsd_rad_sel)
            end


        else
            get_param_handle("CMFD_HSD_WP" .. k .. "_ID"):set(string.format("%02d", k-1))
            get_param_handle("CMFD_HSD_WP" .. k .. "_BRG"):set(0)
            get_param_handle("CMFD_HSD_WP" .. k .. "_DIST"):set(0)
        end
    end
end

local function update_contact_line()
    for k=101,105 do
        if nav_fyt_list[k] and nav_fyt_list[k].lat >= -90 and nav_fyt_list[k].lat <= 90 and nav_fyt_list[k].lon >= -180 and nav_fyt_list[k].lon <= 180 then
            local origin_lat_m = nav_fyt_list[k].lat_m
            local origin_lon_m = nav_fyt_list[k].lon_m
            local hdg, distance = calc_brg_dist_elev_time(origin_lat_m, origin_lon_m, 0)

            hdg = math.deg(hdg) % 360            

            get_param_handle("CMFD_HSD_CNTLINE" .. k .. "_ID"):set(string.format("%02d", k-100))
            get_param_handle("CMFD_HSD_CNTLINE" .. k .. "_BRG"):set(hdg) -- Rotation relative to the HSI center
            get_param_handle("CMFD_HSD_CNTLINE" .. k .. "_DIST"):set(distance * 0.000539957 / hsd_rad_sel) -- Distance relative to the HSI center

            if nav_fyt_list[k+1] and nav_fyt_list[k+1].lat >= -90 and nav_fyt_list[k+1].lat <= 90 and nav_fyt_list[k+1].lon >= -180 and nav_fyt_list[k+1].lon <= 180 then
                local dest_lat_m = nav_fyt_list[k+1].lat_m
                local dest_lon_m = nav_fyt_list[k+1].lon_m
                local hdg2, distance2 = calc_brg_dist_elev_time(dest_lat_m, dest_lon_m, 0, origin_lat_m, origin_lon_m, 0)
                hdg2 = math.deg(hdg2) % 360

                get_param_handle("CMFD_HSD_CNTLINE" .. k .. "_BRG2"):set(hdg2) -- Angle to next point
                get_param_handle("CMFD_HSD_CNTLINE" .. k .. "_X"):set(0)
                get_param_handle("CMFD_HSD_CNTLINE" .. k .. "_Y"):set(distance2 * 0.000539957 / hsd_rad_sel)
            else
                get_param_handle("CMFD_HSD_CNTLINE" .. k .. "_BRG2"):set(0)
                get_param_handle("CMFD_HSD_CNTLINE" .. k .. "_X"):set(0)
                get_param_handle("CMFD_HSD_CNTLINE" .. k .. "_Y"):set(0)
            end
            
        else
            get_param_handle("CMFD_HSD_CNTLINE" .. k .. "_ID"):set(string.format("%02d", k-100))
            get_param_handle("CMFD_HSD_CNTLINE" .. k .. "_BRG"):set(0)
            get_param_handle("CMFD_HSD_CNTLINE" .. k .. "_DIST"):set(0)
            get_param_handle("CMFD_HSD_CNTLINE" .. k .. "_BRG2"):set(0)
            get_param_handle("CMFD_HSD_CNTLINE" .. k .. "_X"):set(0)
            get_param_handle("CMFD_HSD_CNTLINE" .. k .. "_Y"):set(0)
        end
    end
end

local function update_flight_areas()
    for area=1,25 do
        local lat_sum = 0
        local lon_sum = 0
        local code = ""
        local count = 0
        local color = CMFD_HSD_FLTAREA_COLORS.GREEN

        for point=1,6 do
            local k = 200 + (area - 1) * 6 + (point - 1) + 1

            if nav_fyt_list[k] and nav_fyt_list[k].lat >= -90 and nav_fyt_list[k].lat <= 90 and nav_fyt_list[k].lon >= -180 and nav_fyt_list[k].lon <= 180 then
                local origin_lat_m = nav_fyt_list[k].lat_m
                local origin_lon_m = nav_fyt_list[k].lon_m
                local hdg, distance = calc_brg_dist_elev_time(origin_lat_m, origin_lon_m, 0)

                code = nav_fyt_list[k].code

                if point <= nav_fyt_list[k].points then
                    lat_sum = lat_sum + origin_lat_m
                    lon_sum = lon_sum + origin_lon_m
                    count = count + 1
                end

                hdg = math.deg(hdg) % 360 

                if nav_fyt_list[k].type == CMFD_HSD_FLTAREA_TYPES.A or nav_fyt_list[k].type == CMFD_HSD_FLTAREA_TYPES.D or nav_fyt_list[k].type == CMFD_HSD_FLTAREA_TYPES.G then
                    color = CMFD_HSD_FLTAREA_COLORS.YELLOW
                elseif nav_fyt_list[k].type == CMFD_HSD_FLTAREA_TYPES.B or nav_fyt_list[k].type == CMFD_HSD_FLTAREA_TYPES.E then
                    color = CMFD_HSD_FLTAREA_COLORS.GREEN
                else
                    color = CMFD_HSD_FLTAREA_COLORS.PURPLE
                end

                get_param_handle("CMFD_HSD_FLTAREA" .. k .. ""):set(1)
                get_param_handle("CMFD_HSD_FLTAREA" .. k .. "_ID"):set(nav_fyt_list[k].code)
                get_param_handle("CMFD_HSD_FLTAREA" .. k .. "_TYPE"):set(nav_fyt_list[k].type)
                get_param_handle("CMFD_HSD_FLTAREA" .. k .. "_COLOR"):set(color)
                get_param_handle("CMFD_HSD_FLTAREA" .. k .. "_BRG"):set(hdg) -- Rotation relative to the HSI center
                get_param_handle("CMFD_HSD_FLTAREA" .. k .. "_DIST"):set(distance * 0.000539957 / hsd_rad_sel) -- Distance relative to the HSI center

                get_param_handle("CMFD_HSD_FLTAREA" .. k .. "_LABEL_BRG"):set(hdg) -- Rotation relative to the HSI center
                get_param_handle("CMFD_HSD_FLTAREA" .. k .. "_LABEL_DIST"):set(distance * 0.000539957 / hsd_rad_sel) -- Distance relative to the HSI center

                local l = k + 1
                if point == 6 then
                    l = 200 + (area - 1) * 6 + 1
                end

                if nav_fyt_list[l] and nav_fyt_list[l].lat >= -90 and nav_fyt_list[l].lat <= 90 and nav_fyt_list[l].lon >= -180 and nav_fyt_list[l].lon <= 180 then
                    local dest_lat_m = nav_fyt_list[l].lat_m
                    local dest_lon_m = nav_fyt_list[l].lon_m
                    local hdg2, distance2 = calc_brg_dist_elev_time(dest_lat_m, dest_lon_m, 0, origin_lat_m, origin_lon_m, 0)
                    hdg2 = math.deg(hdg2) % 360

                    get_param_handle("CMFD_HSD_FLTAREA" .. k .. "_BRG2"):set(hdg2) -- Angle to next point
                    get_param_handle("CMFD_HSD_FLTAREA" .. k .. "_X"):set(0)
                    get_param_handle("CMFD_HSD_FLTAREA" .. k .. "_Y"):set(distance2 * 0.000539957 / hsd_rad_sel)
                else
                    get_param_handle("CMFD_HSD_FLTAREAE" .. k .. "_BRG2"):set(0)
                    get_param_handle("CMFD_HSD_FLTAREA" .. k .. "_X"):set(0)
                    get_param_handle("CMFD_HSD_FLTAREA" .. k .. "_Y"):set(0)
                end

            else
                get_param_handle("CMFD_HSD_FLTAREA" .. k .. ""):set(0)
                get_param_handle("CMFD_HSD_FLTAREA" .. k .. "_ID"):set("")
                get_param_handle("CMFD_HSD_FLTAREA" .. k .. "_BRG"):set(0)
                get_param_handle("CMFD_HSD_FLTAREA" .. k .. "_DIST"):set(0)
                get_param_handle("CMFD_HSD_FLTAREA" .. k .. "_BRG2"):set(0)
                get_param_handle("CMFD_HSD_FLTAREA" .. k .. "_X"):set(0)
                get_param_handle("CMFD_HSD_FLTAREA" .. k .. "_Y"):set(0)
            end
        end

        if count > 0 then
            local label_lat = lat_sum / count
            local label_lon = lon_sum / count

            local hdg, distance = calc_brg_dist_elev_time(label_lat, label_lon, 0)
            hdg = math.deg(hdg) % 360  

            get_param_handle("CMFD_HSD_FLTAREA_LABEL" .. area .. ""):set(1)
            get_param_handle("CMFD_HSD_FLTAREA_LABEL" .. area .. "_ID"):set(code)
            get_param_handle("CMFD_HSD_FLTAREA_LABEL" .. area .. "_BRG"):set(hdg) -- Rotation relative to the HSI center
            get_param_handle("CMFD_HSD_FLTAREA_LABEL" .. area .. "_DIST"):set(distance * 0.000539957 / hsd_rad_sel) -- Rotation relative to the HSI center
            get_param_handle("CMFD_HSD_FLTAREA_LABEL" .. area .. "_COLOR"):set(color)
        else
            get_param_handle("CMFD_HSD_FLTAREA_LABEL" .. area .. ""):set(0)
            get_param_handle("CMFD_HSD_FLTAREA_LABEL" .. area .. "_ID"):set("")
            get_param_handle("CMFD_HSD_FLTAREA_LABEL" .. area .. "_BRG"):set(0) -- Rotation relative to the HSI center
            get_param_handle("CMFD_HSD_FLTAREA_LABEL" .. area .. "_DIST"):set(0) -- Rotation relative to the HSI center
            get_param_handle("CMFD_HSD_FLTAREA_LABEL" .. area .. "_COLOR"):set(0)
        end
    end
end

local function update_avoid_areas()
    local vertex_count = 32
    for k=110,130 do
        if nav_fyt_list[k] and nav_fyt_list[k].lat >= -90 and nav_fyt_list[k].lat <= 90 and nav_fyt_list[k].lon >= -180 and nav_fyt_list[k].lon <= 180 then

            local dest_lat_m = nav_fyt_list[k].lat_m
            local dest_lon_m = nav_fyt_list[k].lon_m
            local dest_alt_m = nav_fyt_list[k].altitude / 3.28084
            local radius = nav_fyt_list[k].radius

            local hdg, distance = calc_brg_dist_elev_time(dest_lat_m, dest_lon_m, dest_alt_m)
            hdg = math.deg(hdg) % 360

            get_param_handle("CMFD_HSD_AVDAREA" .. k .. ""):set(1)
            get_param_handle("CMFD_HSD_AVDAREA" .. k .. "_ID"):set(string.format("%2d", k-110))
            get_param_handle("CMFD_HSD_AVDAREA" .. k .. "_BRG"):set(hdg)
            get_param_handle("CMFD_HSD_AVDAREA" .. k .. "_DIST"):set(distance * 0.000539957 / hsd_rad_sel)

            for point=1,vertex_count do
                local point_bearing = point * 360 / vertex_count
                local point_origin_lat_m, point_origin_lon_m = coord_project(dest_lat_m, dest_lon_m, point_bearing, radius/0.000539957)
                
                hdg, distance = calc_brg_dist_elev_time(point_origin_lat_m, point_origin_lon_m, 0)
                hdg = math.deg(hdg) % 360

                get_param_handle("CMFD_HSD_AVDAREA" .. k .. "_POINT" .. point.. "_BRG"):set(hdg)
                get_param_handle("CMFD_HSD_AVDAREA" .. k .. "_POINT" .. point.. "_DIST"):set(distance * 0.000539957 / hsd_rad_sel)

                local next_point = point + 1
                if point == vertex_count then
                    next_point = 1
                end
                point_bearing = next_point * 360 / vertex_count

                local point_dest_lat_m, point_dest_lon_m = coord_project(dest_lat_m, dest_lon_m, point_bearing, radius/0.000539957)
                hdg, distance = calc_brg_dist_elev_time(point_dest_lat_m, point_dest_lon_m, 0, point_origin_lat_m, point_origin_lon_m, 0)
                hdg = math.deg(hdg) % 360

                get_param_handle("CMFD_HSD_AVDAREA" .. k .. "_POINT" .. point.. "_BRG2"):set(hdg) -- Angle to next point
                get_param_handle("CMFD_HSD_AVDAREA" .. k .. "_POINT" .. point.. "_X"):set(0)
                get_param_handle("CMFD_HSD_AVDAREA" .. k .. "_POINT" .. point.. "_Y"):set(distance * 0.000539957 / hsd_rad_sel)
            end
        else
            get_param_handle("CMFD_HSD_AVDAREA" .. k .. ""):set(0)
            get_param_handle("CMFD_HSD_AVDAREA" .. k .. "_ID"):set(string.format("%2d", k-110))
            get_param_handle("CMFD_HSD_AVDAREA" .. k .. "_BRG"):set(0)
            get_param_handle("CMFD_HSD_AVDAREA" .. k .. "_DIST"):set(0)

            for point=1,16 do
                get_param_handle("CMFD_HSD_AVDAREA" .. k .. "_POINT_" .. point.. "_BRG"):set(0)
                get_param_handle("CMFD_HSD_AVDAREA" .. k .. "_POINT_" .. point.. "_BRG2"):set(0)
                get_param_handle("CMFD_HSD_AVDAREA" .. k .. "_POINT_" .. point.. "_DIST"):set(0)
                get_param_handle("CMFD_HSD_AVDAREA" .. k .. "_POINT_" .. point.. "_X"):set(0)
                get_param_handle("CMFD_HSD_AVDAREA" .. k .. "_POINT_" .. point.. "_Y"):set(0)
            end
        end
    end
end

function update_hsd()
    update_waypoints()
    update_contact_line()
    update_flight_areas()
    update_avoid_areas()

    HSD_RAD_SEL:set(hsd_rad_sel)

    HSD_FORMAT:set(format)
end

function SetCommandHsd(command,value, CMFD)
    if value == 1 then 
        local selected=-1

        -- HSD format
        if format == CMFD_HSD_FORMAT_IDS.HSD then
            -- Change zoom
            if command==device_commands.CMFD1OSS27 or command==device_commands.CMFD2OSS27 then 
                hsd_rad_sel = math.max(20, hsd_rad_sel / 2) -- increase zoom
            elseif command==device_commands.CMFD1OSS28 or command==device_commands.CMFD2OSS28 then 
                hsd_rad_sel = math.min(1280, hsd_rad_sel * 2) -- decrease zoom
            -- Select ADHSI format
            elseif command==device_commands.CMFD1OSS26 or command==device_commands.CMFD2OSS26 then 
                selected=SUB_PAGE_ID.ADHSI
            -- Toggle DL subformat
            elseif (command==device_commands.CMFD1OSS3 or command==device_commands.CMFD2OSS3) then
                format = CMFD_HSD_FORMAT_IDS.DL
            -- Open ROUTE subformat
            elseif (command==device_commands.CMFD1OSS5 or command==device_commands.CMFD2OSS5) then
                format = CMFD_HSD_FORMAT_IDS.ROUTE
            elseif (command==device_commands.CMFD1OSS7 or command==device_commands.CMFD2OSS7) then
                -- Toggle between DEP and CTR
                HSD_DEP_CHECKED:set(1 - HSD_DEP_CHECKED:get())

                if HSD_DEP_CHECKED:get() == 1 then
                    HSD_HSI_ORIGIN:set(-0.33)
                else
                    HSD_HSI_ORIGIN:set(0)
                end
            -- Toggle SYM
            elseif (command==device_commands.CMFD1OSS9 or command==device_commands.CMFD2OSS9) then
                HSD_SYM_CHECKED:set(1 - HSD_SYM_CHECKED:get())
            -- Toggle ANM
            elseif (command==device_commands.CMFD1OSS10 or command==device_commands.CMFD2OSS10) then
                HSD_ANM_CHECKED:set(1 - HSD_ANM_CHECKED:get())
            -- Toggle ROUT
            elseif (command==device_commands.CMFD1OSS11 or command==device_commands.CMFD2OSS11) then
                HSD_ROUT_CHECKED:set(1 - HSD_ROUT_CHECKED:get())
            -- Toggle BFI
            elseif (command==device_commands.CMFD1OSS14 or command==device_commands.CMFD2OSS14) then
                HSD_BFI_CHECKED:set(1 - HSD_BFI_CHECKED:get())
            -- Toggle between ALL and OFF
            elseif (command==device_commands.CMFD1OSS24 or command==device_commands.CMFD2OSS24) then
                HSD_ALL_CHECKED:set(1 - HSD_ALL_CHECKED:get())
            -- Toggle DCTL subformat
            elseif (command==device_commands.CMFD1OSS25 or command==device_commands.CMFD2OSS25) then
                HSD_DEL_CHECKED:set(1)
                format = CMFD_HSD_FORMAT_IDS.DCTL
            end

        -- DL format
        elseif format == CMFD_HSD_FORMAT_IDS.DL then
            if (command==device_commands.CMFD1OSS3 or command==device_commands.CMFD2OSS3) then
                format = CMFD_HSD_FORMAT_IDS.HSD
            -- Toggle MSG
            elseif (command==device_commands.CMFD1OSS28 or command==device_commands.CMFD2OSS28) then
                HSD_MSG_CHECKED:set(1 - HSD_MSG_CHECKED:get())
            elseif (command==device_commands.CMFD1OSS27 or command==device_commands.CMFD2OSS27) then
                local mode = HSD_DL_MODE:get()
                if mode == CMFD_HSD_DL_IDS.ALL then
                    mode = CMFD_HSD_DL_IDS.FORM
                elseif mode == CMFD_HSD_DL_IDS.FORM then
                    mode = CMFD_HSD_DL_IDS.TGT
                elseif mode == CMFD_HSD_DL_IDS.TGT then
                    mode = CMFD_HSD_DL_IDS.NONE
                elseif mode == CMFD_HSD_DL_IDS.NONE then
                    mode = CMFD_HSD_DL_IDS.ALL
                end

                HSD_DL_MODE:set(mode)
            -- Toggle SMTH
            elseif (command==device_commands.CMFD1OSS26 or command==device_commands.CMFD2OSS26) then
                HSD_SMTH_CHECKED:set(1 - HSD_SMTH_CHECKED:get())
            end

        -- DCTL format
        elseif format == CMFD_HSD_FORMAT_IDS.DCTL then
            if (command==device_commands.CMFD1OSS25 or command==device_commands.CMFD2OSS25) then
                format = CMFD_HSD_FORMAT_IDS.HSD
            -- Toggle AREA
            elseif (command==device_commands.CMFD1OSS7 or command==device_commands.CMFD2OSS7) then
                HSD_AREA_CHECKED:set(1 - HSD_AREA_CHECKED:get())
            -- Toggle WPT
            elseif (command==device_commands.CMFD1OSS8 or command==device_commands.CMFD2OSS8) then
                HSD_WP_CHECKED:set(1 - HSD_WP_CHECKED:get())
            -- Toggle INT
            elseif (command==device_commands.CMFD1OSS9 or command==device_commands.CMFD2OSS9) then
                HSD_INT_CHECKED:set(1 - HSD_INT_CHECKED:get())
            -- Toggle STRM 120
            elseif (command==device_commands.CMFD1OSS10 or command==device_commands.CMFD2OSS10) then
                HSD_STRM120_CHECKED:set(1 - HSD_STRM120_CHECKED:get())
            end
        elseif format == CMFD_HSD_FORMAT_IDS.ROUTE then
            if (command==device_commands.CMFD1OSS1 or command==device_commands.CMFD2OSS1) then
                format = CMFD_HSD_FORMAT_IDS.HSD
            end
        end

        if selected > 0 then
            CMFD["Format"]:set(selected)
            CMFD["Sel"]:set(selected)
            if CMFD["Primary"]:get()==1 then
                CMFD["SelRight"]:set(selected)
                CMFD["SelRightName"]:set(SUB_PAGE_NAME[selected])
            else 
                CMFD["SelLeft"]:set(selected)
                CMFD["SelLeftName"]:set(SUB_PAGE_NAME[selected])
            end
        end
    end
end

function post_initialize_hsd()

end