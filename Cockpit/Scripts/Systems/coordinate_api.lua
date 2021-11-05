coordinate = {
    equatorialRadius = 6378137,
    e = 0.081819190837554151,
    esq = 0.0066943799893121048,
    e0sq = 0.0067394967414360083,
    e1sq = 0.006739497,
    k0 = 0.9996,

    digraphArrayN = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'L', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' },
    digraphArrayE = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'L', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' },

    SET_ORIGIN_COLUMN_LETTERS = { 'A', 'J', 'S', 'A', 'J', 'S' },
    SET_ORIGIN_ROW_LETTERS = { 'A', 'F', 'A', 'F', 'A', 'F' },
     NUM_100K_SETS = 6,

    verifyLatLon = function (lat,lon)
        return lat >= -90.0 and lat <= 90.0 and lon >= -180.0 and lon <= 180.0
    end,

    convert = function (self, lat, lon)
        local latRad = lat * math.pi / 180.0
        local utmz = 1 + math.floor((lon + 180) / 6) -- utm zone
        local zcm = 3 + 6 * (utmz - 1) - 180 -- central meridian of a zone
        local latz = 0 -- zone A-B for below 80S

        -- convert latitude to latitude zone
        if lat > -80 and lat < 72 then
            latz = math.floor((lat + 80) / 8) + 2 -- zones C-W
        else
            if lat > 72 and lat < 84 then
                latz = 21 -- zone X
            else
                if lat > 84 then
                    latz = 23 -- zones Y-Z
                end
            end
        end

        local N = self.equatorialRadius / math.sqrt(1 - math.pow(self.e * math.sin(latRad), 2))
        local T = math.pow(math.tan(latRad), 2)
        local C = self.e0sq * math.pow(math.cos(latRad), 2)
        local A = (lon - zcm) * math.pi / 180.0 * math.cos(latRad)

        -- calculate M (USGS style)
        local M = latRad * (1.0 - self.esq * (1.0 / 4.0 + self.esq * (3.0 / 64.0 + 5.0 * self.esq / 256.0)))
        M = M - math.sin(2.0 * latRad) * (self.esq * (3.0 / 8.0 + self.esq * (3.0 / 32.0 + 45.0 * self.esq / 1024.0)))
        M = M + math.sin(4.0 * latRad) * (self.esq * self.esq * (15.0 / 256.0 + self.esq * 45.0 / 1024.0))
        M = M - math.sin(6.0 * latRad) * (self.esq * self.esq * self.esq * (35.0 / 3072.0))
        M = M * self.equatorialRadius --Arc length along standard meridian

        -- calculate easting
        local x = self.k0 * N * A * (1.0 + A * A * ((1.0 - T + C) / 6.0 + A * A * (5.0 - 18.0 * T + T * T + 72.0 * C - 58.0 * self.e0sq) / 120.0)) --Easting relative to CM
        x = x + 500000 -- standard easting

        -- calculate northing
        local y = self.k0 * (M + N * math.tan(latRad) * (A * A * (1.0 / 2.0 + A * A * ((5.0 - T + 9.0 * C + 4.0 * C * C) / 24.0 + A * A * (61.0 - 58.0 * T + T * T + 600.0 * C - 330.0 * self.e0sq) / 720.0)))) -- from the equator

        if y < 0 then
            y = 10000000 + y -- add in false northing if south of the equator
        end

        return { longitudeZoneValue = utmz, latitudeZoneValue = latz, eastingValue = x, northingValue = y }
    end,

    calcDigraph = function(self,longitudeZoneValue, eastingValue, northingValue)
        local letter = math.floor((longitudeZoneValue - 1) * 8 + eastingValue / 100000.0)
        local letterIdx = (letter % 24 + 23) % 24
        
        local digraph = self.digraphArrayE[letterIdx + 1]

        letter = math.floor(northingValue / 100000.0)
        if longitudeZoneValue / 2.0 == math.floor(longitudeZoneValue / 2.0) then
            letter = letter + 5
        end

        letterIdx = letter - (20 * math.floor(letter / 20.0))

        return digraph .. self.digraphArrayN[letterIdx + 1]
    end,

    formatIngValue = function (value)
        return string.format("%05d",  math.floor(value - 100000 * math.floor(value / 100000)))
    end,

    get100kSetForZone = function(self,i)
        local set = i % self.NUM_100K_SETS
        if set == 0 then
            set = self.NUM_100K_SETS
        end
        return set
    end,

    getEastingFromChar = function(self,e,set)
        local baseCol = self.SET_ORIGIN_COLUMN_LETTERS
        local curCol = string.byte(baseCol[set])
        local eastingValue = 100000.0
        local rewindMarker = false

        while curCol ~= string.byte(e) do
            curCol = curCol + 1
            if curCol == string.byte("I") then
                curCol = curCol + 1
            end

            if curCol == string.byte("O") then
                curCol = curCol + 1
            end

            if curCol > string.byte("Z") then
                if rewindMarker then
                    --return 0 -- System.Diagnostics.Debugger.Break()
                end

                curCol = string.byte("A")
                rewindMarker = true
            end

            eastingValue = eastingValue + 100000.0
        end

        return eastingValue
    end,

    getNorthingFromChar = function(self,n,set)
        if string.byte(n) > string.byte("V") then
            -- System.Diagnostics.Debugger.Break()
            return 0
        end

        local baseRow = self.SET_ORIGIN_ROW_LETTERS
        -- rowOrigin is the letter at the origin of the set for the column
        local curRow = string.byte(baseRow[set])
        local northingValue = 0.0
        local rewindMarker = false

        while curRow ~= string.byte(n) do
            curRow = curRow + 1

            if curRow == string.byte("I") then
                curRow = curRow + 1
            end

            if curRow == string.byte("O") then
                curRow = curRow + 1
            end

            -- fixing a bug making whole application hang in this loop
            -- when 'n' is a wrong character
            if curRow > string.byte("V") then
                if rewindMarker then
                    -- making sure that this loop ends
                    --System.Diagnostics.Debugger.Break()
                end

                curRow = string.byte("A")
                rewindMarker = true
            end
            northingValue = northingValue + 100000.0
        end

        return northingValue
    end,

    getMinNorthing = function(self,zoneLetter)
        local northing = 0

        if zoneLetter == "C" then
            northing = 1100000.0
        elseif zoneLetter == "D" then
            northing = 2000000.0
        elseif zoneLetter == "E" then
            northing = 2800000.0
        elseif zoneLetter == "F" then
            northing = 3700000.0
        elseif zoneLetter == "G" then
            northing = 4600000.0
        elseif zoneLetter == "H" then
            northing = 5500000.0
        elseif zoneLetter == "J" then
            northing = 6400000.0
        elseif zoneLetter == "K" then
            northing = 7300000.0
        elseif zoneLetter == "L" then
            northing = 8200000.0
        elseif zoneLetter == "M" then
            northing = 9100000.0
        elseif zoneLetter == "N" then
            northing = 0.0
        elseif zoneLetter == "P" then
            northing = 800000.0
        elseif zoneLetter == "Q" then
            northing = 1700000.0
        elseif zoneLetter == "R" then
            northing = 2600000.0
        elseif zoneLetter == "S" then
            northing = 3500000.0
        elseif zoneLetter == "T" then
            northing = 4400000.0
        elseif zoneLetter == "U" then
            northing = 5300000.0
        elseif zoneLetter == "V" then
            northing = 6200000.0
        elseif zoneLetter == "W" then
            northing = 7000000.0
        elseif zoneLetter == "X" then
            northing = 7900000.0
        else
            northing = -1.0
        end

        if northing >= 0.0 then
            return northing
        else
            --System.Diagnostics.Debugger.Break()
            return 0
        end
    end,
    
    LLtoMGRS = function (self,lat,lon)
        if not self.verifyLatLon(lat,lon) then
            return { gridzone = "XXX", digraph = "XX", easting = -1, northing = -1 }
        end
    
        local result = self:convert(lat,lon)
    
        return { 
            gridzone = string.format("%02d", result.longitudeZoneValue) .. self.digraphArrayN[result.latitudeZoneValue + 1], 
            digraph = self:calcDigraph(result.longitudeZoneValue, result.eastingValue, result.northingValue),
            easting = self.formatIngValue(result.eastingValue),
            northing = self.formatIngValue(result.northingValue)
        }
    end,

    getHemisphere = function(latzone)
        if string.find("ACDEFGHJKLM", latzone) then
            return "S"
        else
            return "N"
        end
    end,

    setVariables = function(self, easting, northing)
        local arc = northing / self.k0

        local mu = arc / (self.equatorialRadius * (1 - math.pow(self.e, 2) / 4.0 - 3 * math.pow(self.e, 4) / 64.0 - 5 * math.pow(self.e, 6) / 256.0))

        local ei = (1 - math.pow(1 - self.e * self.e, 1 / 2.0)) / (1 + math.pow(1 - self.e * self.e, 1 / 2.0))

        local ca = 3 * ei / 2 - 27 * math.pow(ei, 3) / 32.0

        local cb = 21 * math.pow(ei, 2) / 16 - 55 * math.pow(ei, 4) / 32
        local cc = 151 * math.pow(ei, 3) / 96
        local cd = 1097 * math.pow(ei, 4) / 512
        local phi1 = mu + ca * math.sin(2 * mu) + cb * math.sin(4 * mu) + cc * math.sin(6 * mu) + cd * math.sin(8 * mu)

        local n0 = self.equatorialRadius / math.pow(1 - math.pow(self.e * math.sin(phi1), 2), 1 / 2.0)

        local r0 = self.equatorialRadius * (1 - self.e * self.e) / math.pow(1 - math.pow(self.e * math.sin(phi1), 2), 3 / 2.0)
        local fact1 = n0 * math.tan(phi1) / r0

        local _a1 = 500000 - easting
        local dd0 = _a1 / (n0 * self.k0)
        local fact2 = dd0 * dd0 / 2

        local t0 = math.pow(math.tan(phi1), 2)
        local Q0 = self.e1sq * math.pow(math.cos(phi1), 2)
        local fact3 = (5 + 3 * t0 + 10 * Q0 - 4 * Q0 * Q0 - 9 * self.e1sq) * math.pow(dd0, 4) / 24

        local fact4 = (61 + 90 * t0 + 298 * Q0 + 45 * t0 * t0 - 252 * self.e1sq - 3 * Q0 * Q0) * math.pow(dd0, 6) / 720

        
        local lof1 = _a1 / (n0 * self.k0)
        local lof2 = (1 + 2 * t0 + Q0) * math.pow(dd0, 3) / 6.0
        local lof3 = (5 - 2 * Q0 + 28 * t0 - 3 * math.pow(Q0, 2) + 8 * self.e1sq + 24 * math.pow(t0, 2)) * math.pow(dd0, 5) / 120
        local _a2 = (lof1 - lof2 + lof3) / math.cos(phi1)
        local _a3 = _a2 * 180 / math.pi

        return {
            phi1 = phi1,
            fact1 = fact1,
            fact2 = fact2,
            fact3 = fact3,
            fact4 = fact4,
            _a3 = _a3
        }
    end,

    UTMtoLL = function(self, gridzone, easting, northing)
        local longzone = string.sub(gridzone, 1, 2)
        local latzone = string.sub(gridzone, 3, 3)

        local hemisphere = self.getHemisphere(latzone)

        if hemisphere == "S" then
            northing = 10000000 - northing
        end

        local variable = self:setVariables(easting, northing)

        local latitude = 180 * (variable.phi1 - variable.fact1 * (variable.fact2 + variable.fact3 + variable.fact4)) / math.pi

        local zone = tonumber(longzone)

        local zoneCM
        if zone > 0 then
            zoneCM = 6 * zone - 183.0
        else
            zoneCM = 3.0
        end

        local longitude = zoneCM - variable._a3
        if hemisphere == "S" then
            latitude = -latitude
        end

        return {
            latitude = latitude,
            longitude = longitude
        }
    end,

    MGRStoUTM = function(self, gridzone, digraph, easting, northing)
        local longzone = string.sub(gridzone, 1, 2)
        local latzone = string.sub(gridzone, 3, 3)

        local set = self:get100kSetForZone(tonumber(longzone))

        local east100k = self:getEastingFromChar(string.sub(digraph, 1, 1), set)
        local north100k = self:getNorthingFromChar(string.sub(digraph, 2, 2), set)

        -- We have a bug where the northing may be 2000000 too low.
        -- How do we know when to roll over?
        while north100k < self:getMinNorthing(latzone) do
            north100k = north100k + 2000000
        end

        local accuracyBonus = 100000.0 / math.pow(10, string.len(easting))

        local sepEasting = tonumber(easting) * accuracyBonus
        local sepNorthing = tonumber(northing) * accuracyBonus

        return {
            gridzone = gridzone,
            easting = sepEasting + east100k,
            northing = sepNorthing + north100k
        }
    end,

    MGRStoLL = function(self, gridzone, digraph, easting, northing)
        utm = self:MGRStoUTM(gridzone, digraph, easting, northing)
        return self:UTMtoLL(utm.gridzone, utm.easting, utm.northing)
    end,

    -- DD°MM.MM'
    LLtoDMMString = function(lat, lon)
        -- Fix for when math.floor rounds 0.996 to 0
        if (math.abs(lon) - math.floor(math.abs(lon)))*60 > 59.995 then lon = lon + 0.005 * (lon >= 0 and 1 or -1) / 60 end
        if (math.abs(lat) - math.floor(math.abs(lat)))*60 > 59.995 then lat = lat + 0.005 * (lat >= 0 and 1 or -1) / 60 end

        local latStr = "X XX$XX.XX'"
        local lonStr = "XXXX$XX.XX'"

        if lat >= -90 and lat <= 90 then
            local latH = (lat >=0 and "N " or "S ")
            local latDD = math.floor(math.abs(lat))
            local latMM = (math.abs(lat) - math.floor(math.abs(lat)))*60

            latStr = latH .. string.format("%02d$%05.2f'", latDD, latMM)
        end

        if lon >= -180 and lon <= 180 then
            local lonH = (lon >=0 and "E" or "W")
            local lonDD = math.floor(math.abs(lon))
            local lonMM = (math.abs(lon) - math.floor(math.abs(lon)))*60

            lonStr = lonH .. string.format("%03d$%05.2f'", lonDD, lonMM)
        end

        return {
            latitude = latStr,
            longitude = lonStr
        }
    end
}

-- Usage example

--local lat = 0
--local lon = 0

--local mgrs = coordinate:LLtoMGRS(lat, lon)
--local utm = coordinate:MGRStoUTM(mgrs.gridzone, mgrs.digraph, mgrs.easting, mgrs.northing)
--local dd = coordinate:MGRStoLL(mgrs.gridzone, mgrs.digraph, mgrs.easting, mgrs.northing)
--local ll = coordinate.LLtoDMMString(0,0)

--io.write(mgrs.gridzone .. " " .. mgrs.digraph .. " " .. mgrs.easting .. " " .. mgrs.northing .. "\n")
--io.write(utm.gridzone .. " " .. utm.easting .. " " .. utm.northing .. "\n")
--io.write(dd.latitude .. " " .. dd.longitude .. "\n")
--io.write(ll.latitude .. " " .. ll.longitude .. "\n")