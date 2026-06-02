local CHECKLIST_TEXT = get_param_handle("CMFD_CHECKLIST_TEXT")
local CHECKLIST_LEVEL = get_param_handle("CMFD_CHECKLIST_LEVEL") -- 0: Main, 1: Submenu1, 2: Submenu2, 3: Page
local CHECKLIST_SUBMENU = get_param_handle("CMFD_CHECKLIST_SUBMENU")

-- Constants

local CMFD_CHECKLIST_SUBMENU_IDS = {
    MAIN = 0,
    NORM_PROC = 1,
    GND_WARN = 2,
    GND_CAUT = 3,
    GND_GNRL = 4,
    TKOFF_WARN = 5,
    TKOFF_CAUT = 6,
    TKOFF_GNRL = 7,
    FLT_WARN = 8,
    FLT_CAUT = 9,
    FLT_GNRL = 10,
    LAND_WARN = 11,
    LAND_CAUT = 12,
    LAND_GNRL = 13,
}

local CHECKLIST_CONTENT = {
    [CMFD_CHECKLIST_SUBMENU_IDS.NORM_PROC] = [[COLD START
1. BATT ........... ON
2. THROTTLE ...... CUT OFF
3. STARTER ....... ON
4. THROTTLE ...... ST (gate)
5. RPM > 55% ..... NAV
6. THROTTLE ...... IDLE
7. GEN ........... ON
8. AVIONICS ...... ON
9. EGI ........... ALIGN
10. EGI ......... NAV
11. CMFD 1/2 .... ON]],
    [CMFD_CHECKLIST_SUBMENU_IDS.GND_WARN] = [[GROUND WARNINGS
1. PARKING BRAKE . SET
2. CANOPY ....... CLOSE
3. CAUTION ...... CLEAR
4. FUEL QTY ..... ADEQUATE
5. ENGINE TEMP .. GREEN]],
    [CMFD_CHECKLIST_SUBMENU_IDS.GND_CAUT] = [[GROUND CAUTIONS
1. TRIM ........ NEUTRAL
2. FLAPS ....... CHECK UP
3. STICK ....... FREE
4. SPEED BRAKE . RETRACT
5. WEAPONS .... SAFE]],
    [CMFD_CHECKLIST_SUBMENU_IDS.GND_GNRL] = [[GROUND GENERAL
1. DTC ......... LOADED
2. WAYPOINT 1 . SELECTED
3. CMFD 1 ..... ADHSI
4. CMFD 2 ..... SMS
5. UFCP ....... EGI-INS NAV]],
    [CMFD_CHECKLIST_SUBMENU_IDS.TKOFF_WARN] = [[TAKEOFF WARNINGS
1. FLAPS ....... TAKEOFF
2. TRIM ........ TAKEOFF
3. BRAKES ..... RELEASED
4. CAUTION .... CLEAR
5. RPM ........ STABLE]],
    [CMFD_CHECKLIST_SUBMENU_IDS.TKOFF_CAUT] = [[TAKEOFF CAUTIONS
1. DOORS ...... CLOSE
2. HARNESS ... TIGHT
3. ALTITUDE .. 0 FT
4. AIRSPEED .. GREEN
5. OIL PRESS . GREEN]],
    [CMFD_CHECKLIST_SUBMENU_IDS.TKOFF_GNRL] = [[TAKEOFF GENERAL
1. HUD ....... BRIGHT
2. INSTRUMENT GREEN
3. THROTTLE . SMOOTH
4. CONTROLS . RESPONSIVE
5. PITOT .... ON]],
    [CMFD_CHECKLIST_SUBMENU_IDS.FLT_WARN] = [[FLIGHT WARNINGS
1. ALTITUDE .. INCREASING
2. AIRSPEED . > 100 KIAS
3. EGI ...... NAV
4. STALL .... NONE
5. MASTER ... CORRECT]],
    [CMFD_CHECKLIST_SUBMENU_IDS.FLT_CAUT] = [[FLIGHT CAUTIONS
1. FUEL ...... MONITOR
2. HYDRAULIC  GREEN
3. ENGINE .... NORMAL
4. AIRSPEED . LIMIT
5. SYSTEMS .. MONITOR]],
    [CMFD_CHECKLIST_SUBMENU_IDS.FLT_GNRL] = [[FLIGHT GENERAL
1. ROUTE .... CHECK HSD
2. WAYPOINT . SEQUENCE
3. CMFD .... FORMAT
4. WEAPONS .. CONFIG
5. SMS ..... MODE]],
    [CMFD_CHECKLIST_SUBMENU_IDS.LAND_WARN] = [[LANDING WARNINGS
1. DESCENT ... PLANNED
2. SPOT ...... VISIBLE
3. AIRSPEED . 100-120
4. ALTITUDE . DESCENDING
5. CAUTION .. NONE]],
    [CMFD_CHECKLIST_SUBMENU_IDS.LAND_CAUT] = [[LANDING CAUTIONS
1. GEAR ...... DOWN
2. FLAPS .... FULL
3. TRIM ..... LANDING
4. SPEED BRK  AS NEEDED
5. FUEL ..... CHECK]],
    [CMFD_CHECKLIST_SUBMENU_IDS.LAND_GNRL] = [[LANDING GENERAL
1. FINAL .... 95-100 KIAS
2. DESCENT .. 300 FPM
3. THRESHOLD 50 FT
4. TOUCHDOWN MAIN GEAR
5. BRAKES .. AS NEEDED]],
}

-- Variables

local level = 0
local submenu = 0

CHECKLIST_LEVEL:set(level)
CHECKLIST_SUBMENU:set(submenu)

function update_checklist()
    if level == 0 then
        CHECKLIST_TEXT:set("CHECKLIST\n\nNORM PROC\nGND WARN\nGND CAUT\nGND GNRL\nTKOFF WARN\nTKOFF CAUT\nTKOFF GNRL\nFLT WARN\nFLT CAUT\nFLT GNRL\nLAND WARN\nLAND CAUT\nLAND GNRL")
    elseif level >= 1 then
        local content = CHECKLIST_CONTENT[submenu] or "NO DATA"
        CHECKLIST_TEXT:set(content)
    end
end

function SelectSubmenu(menu)
    level = 1
    submenu = menu
    CHECKLIST_LEVEL:set(level)
    CHECKLIST_SUBMENU:set(submenu)
end

function SelectNextLevel()
    level = 3 - level
    CHECKLIST_LEVEL:set(level)
end

function SelectMenu()
    level = 0
    submenu = 0
    CHECKLIST_LEVEL:set(level)
    CHECKLIST_SUBMENU:set(submenu)
end

function SetCommandChecklist(command,value, CMFD)
    if value == 1 then
        if level == 0 then
            -- Main page
            if (command==device_commands.CMFD1OSS3 or command==device_commands.CMFD2OSS3) then
                SelectSubmenu(CMFD_CHECKLIST_SUBMENU_IDS.NORM_PROC)
            elseif (command==device_commands.CMFD1OSS8 or command==device_commands.CMFD2OSS8) then
                SelectSubmenu(CMFD_CHECKLIST_SUBMENU_IDS.FLT_WARN)
            elseif (command==device_commands.CMFD1OSS9 or command==device_commands.CMFD2OSS9) then
                SelectSubmenu(CMFD_CHECKLIST_SUBMENU_IDS.FLT_CAUT)
            elseif (command==device_commands.CMFD1OSS10 or command==device_commands.CMFD2OSS10) then
                SelectSubmenu(CMFD_CHECKLIST_SUBMENU_IDS.FLT_GNRL)
            elseif (command==device_commands.CMFD1OSS11 or command==device_commands.CMFD2OSS11) then
                SelectSubmenu(CMFD_CHECKLIST_SUBMENU_IDS.LAND_WARN)
            elseif (command==device_commands.CMFD1OSS12 or command==device_commands.CMFD2OSS12) then
                SelectSubmenu(CMFD_CHECKLIST_SUBMENU_IDS.LAND_CAUT)
            elseif (command==device_commands.CMFD1OSS13 or command==device_commands.CMFD2OSS13) then
                SelectSubmenu(CMFD_CHECKLIST_SUBMENU_IDS.LAND_GNRL)
            elseif (command==device_commands.CMFD1OSS22 or command==device_commands.CMFD2OSS22) then
                SelectSubmenu(CMFD_CHECKLIST_SUBMENU_IDS.TKOFF_GNRL)
            elseif (command==device_commands.CMFD1OSS23 or command==device_commands.CMFD2OSS23) then
                SelectSubmenu(CMFD_CHECKLIST_SUBMENU_IDS.TKOFF_CAUT)
            elseif (command==device_commands.CMFD1OSS24 or command==device_commands.CMFD2OSS24) then
                SelectSubmenu(CMFD_CHECKLIST_SUBMENU_IDS.TKOFF_WARN)
            elseif (command==device_commands.CMFD1OSS25 or command==device_commands.CMFD2OSS25) then
                SelectSubmenu(CMFD_CHECKLIST_SUBMENU_IDS.GND_GNRL)
            elseif (command==device_commands.CMFD1OSS26 or command==device_commands.CMFD2OSS26) then
                SelectSubmenu(CMFD_CHECKLIST_SUBMENU_IDS.GND_CAUT)
            elseif (command==device_commands.CMFD1OSS27 or command==device_commands.CMFD2OSS27) then
                SelectSubmenu(CMFD_CHECKLIST_SUBMENU_IDS.GND_WARN)
            end
        elseif level == 1 or level == 2 then
            if (command==device_commands.CMFD1OSS5 or command==device_commands.CMFD2OSS5) then
                SelectMenu()
            elseif (command==device_commands.CMFD1OSS6 or command==device_commands.CMFD2OSS6) then
                SelectNextLevel()
            end
        end
    end
end

function post_initialize_checklist()

end