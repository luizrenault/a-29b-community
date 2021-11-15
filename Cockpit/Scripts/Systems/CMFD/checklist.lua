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

-- Variables

local level = 0
local submenu = 0

CHECKLIST_LEVEL:set(level)
CHECKLIST_SUBMENU:set(submenu)

function update_checklist()
    if level == 0 then
        -- Main page
    elseif level == 1 or level == 2 then
        -- Submenu 1
    else
        -- Page
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