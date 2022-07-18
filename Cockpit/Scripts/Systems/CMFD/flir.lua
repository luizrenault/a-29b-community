-- local FLIR_TIME = get_param_handle("FLIR_TIME")

-- FLIR_TIME:set(" ")

function update_flir()

    -- local time = get_absolute_model_time()
    -- local hour = math.floor(time/3600)
    -- local minute = math.floor((time/60) % 60)
    -- local second = math.floor(time%60)
    -- FLIR_TIME:set(string.format("%02.0f-%02.0f-%02.0f %02.0f:%02.0f:%02.0fL",LockOn_Options.date.day,LockOn_Options.date.month, LockOn_Options.date.year%100,  hour,minute,second))

end

dev:listen_command(Keys.Cage)
dev:listen_command(Keys.TDCX)
dev:listen_command(Keys.TDCY)

function SetCommandFlir(command,value, CMFD)
    local flir = GetDevice(devices.FLIR)
    if command == Keys.TDCX then
        if value >= 0 then
            flir:SetCommand(flir_commands.SlewRight, value)
        else
            flir:SetCommand(flir_commands.SlewLeft, math.abs(value))
        end
    elseif command == Keys.TDCY then
        if value >= 0 then
            flir:SetCommand(flir_commands.SlewUp, value)
        else
            flir:SetCommand(flir_commands.SlewDown, math.abs(value))
        end
    elseif command == Keys.Cage then
        flir:SetCommand(flir_commands.Cage, value)
    elseif command == Keys.TDC_Depress then
        flir:SetCommand(flir_commands.TrackBrk, value)
    end
end

local flir_status_time = 0
local flir_status_old = 0

function post_initialize_flir()
    flir_status_time = get_absolute_model_time()
    flir_status_old = FLIR.STATUS:get()
end

local Terrain = require('terrain')

FLIR = {
    STATUS = get_param_handle("FLIR_STATUS"),
    POLARITY = get_param_handle("FLIR_POL"),
    MODE = get_param_handle("FLIR_MODE"),
    TRACKING = get_param_handle("FLIR_TRK"),
    CAGED = get_param_handle("FLIR_CAGED"),
    ZOOM = get_param_handle("FLIR_ZOOM"),
    TGT_LAT = get_param_handle("FLIR_TGT_LAT"),
    TGT_LON = get_param_handle("FLIR_TGT_LON"),
    TGT_ALT = get_param_handle("FLIR_TGT_ALT"),
    TGT_AVALILABLE = get_param_handle("FLIR_TGT_AVAILABLE"),
}


function text_from_lua_function_flir (number)
    if number == CMFD_TEXT.FLIR_COORDS then
        local lat_m, alt_m, lon_m = sensor_data.getSelfCoordinates()
        local lat, lon = Terrain.convertMetersToLatLon(lat_m, lon_m)
        local text = "LAT " ..  (lat>=0 and "N" or "S") .. string.format(" %02.0f`%04.2f\' ", math.floor(lat), (lat % 1) * 60)
        text = text .. "LON " ..  (lon>=0 and "E" or "W") .. string.format(" %03.0f`%04.2f\' ", math.floor(lon), (lon % 1) * 60)
        return text
    elseif number == CMFD_TEXT.FLIR_FILTER_STATUS then
        return "HI/HI/EN"
    elseif number == CMFD_TEXT.FLIR_SYMBOLOGY then
        return "DAY"
    elseif number == CMFD_TEXT.FLIR_GAIN then
        return "AGN"
    elseif number == CMFD_TEXT.FLIR_SCENE then
        return "MOD"
    elseif number == CMFD_TEXT.FLIR_TRACKER then
        local mode = FLIR.MODE:get();
        if mode == 3 then return "TRK/T"
        elseif mode == 4 then return "TRK/C"
        elseif mode == 5 then return "TRK"
        else return ""
        end
    elseif number == CMFD_TEXT.FLIR_CURRENT_MODE then
        local tracking = FLIR.TRACKING:get()
        local status = FLIR.STATUS:get()
        local caged = FLIR.CAGED:get();
        local mode = FLIR.MODE:get();

        if status > 1 and status < 4 then return "INIT"
        elseif caged == 1 then return "CAGED"
        elseif mode == 5 then return "TRK"
        elseif mode == 6 then return "HDHLD"
        elseif mode == 2 then return "INRPT"
        elseif tracking == 1 then return "AREA"
        elseif tracking == 2 then return "POINT"
        end
        return ""
    elseif number == CMFD_TEXT.FLIR_FOV then
        local zoom = FLIR.ZOOM:get()
        if zoom < 1/5 then return "WIDE"
        elseif zoom < 2/5 then return "2XWIDE"
        elseif zoom < 3/5 then return "MED"
        elseif zoom < 4/5 then return "2XMED"
        elseif zoom < 5/5 then return "NRW"
        else return "2XNRW" end
    elseif number == CMFD_TEXT.FLIR_FREEZE then
        return ""
    elseif number == CMFD_TEXT.FLIR_POLARITY then
        local pol = FLIR.POLARITY:get()
        if pol == 0 then return ""
        elseif pol == 1 then return "BLK"
        else return "WHT" end
    elseif number == CMFD_TEXT.FLIR_STATUS then
        local status = FLIR.STATUS:get()
        if flir_status_old ~= stats and status == 5 then
            flir_status_time = get_absolute_model_time()
        end
        if status < 5 then
            return "BIT"
        elseif status == 5 and (get_absolute_model_time()-flir_status_time) < 5 then
            return "RDY"
        else
            return ""
        end
    elseif number == CMFD_TEXT.FLIR_TARGET then
        if FLIR.TGT_AVALILABLE:get() ~= 0 then
            local lat = FLIR.TGT_LAT:get()
            local lon = FLIR.TGT_LON:get()
            local alt = FLIR.TGT_ALT:get()
            lat, lon = Terrain.convertMetersToLatLon(lat, lon)
            alt = alt * 3.28084
            return string.format("TARGET\n%s  %02.0f`%05.2f'\n%s %03.0f`%05.2f'\n%-5.0f FT",
                lat >= 0 and "N" or "S",
                math.floor(lat),
                (lat % 1) * 60,
                lon >= 0 and "E" or "W",
                math.floor(lon),
                (lon % 1) * 60,
                alt
            )
        else
            return "TARGET\nX  XX`XX.XX'\nX XXX`XX.XX'\n 000 FT"
        end
    end

    return nil
end