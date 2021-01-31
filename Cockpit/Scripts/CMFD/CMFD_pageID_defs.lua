------ CMFD ID
CMFD = {
    LCMFD = 1,
    RCMFD = 2
}

local count = 0
local function counter()
    count = count + 1
    return count
end

count = 0

SUB_PAGE_ID = {
    BASE         = 0,
    MENU1        = counter(),
    MENU2        = counter(),
    EICAS        = counter(),
    BLANK        = counter(), -- not implemented from here
    NOAUX        = counter(), -- no signal from device
    HSD        = counter(),
    SMS        = counter(),
    UFCP        = counter(),
    DVR        = counter(),
    EW        = counter(),
    ADHSI        = counter(),
    FLIR        = counter(),
    EMERG        = counter(),
    PFL        = counter(),
    BIT          = counter(),
    HUD        = counter(),
    DTE        = counter(),
    NAV        = counter(),
    OFF          = counter(), -- no power
    END          = counter(),
}

SUB_PAGE_NAME = {}
SUB_PAGE_NAME[SUB_PAGE_ID.BLANK]    = ""
SUB_PAGE_NAME[SUB_PAGE_ID.EICAS]    = "EICAS"
SUB_PAGE_NAME[SUB_PAGE_ID.NOAUX]    = "NOAUX"

SUB_PAGE_NAME[SUB_PAGE_ID.HSD]      = "HSD"
SUB_PAGE_NAME[SUB_PAGE_ID.SMS]      = "SMS"
SUB_PAGE_NAME[SUB_PAGE_ID.UFCP]     = "UFCP"
SUB_PAGE_NAME[SUB_PAGE_ID.DVR]      = "DVR"
SUB_PAGE_NAME[SUB_PAGE_ID.EW]       = "EW"
SUB_PAGE_NAME[SUB_PAGE_ID.ADHSI]    = "ADHSI"
SUB_PAGE_NAME[SUB_PAGE_ID.FLIR]     = "FLIR"
SUB_PAGE_NAME[SUB_PAGE_ID.EMERG]    = "EMERG"
SUB_PAGE_NAME[SUB_PAGE_ID.PFL]      = "PFL"
SUB_PAGE_NAME[SUB_PAGE_ID.BIT]      = "BIT"
SUB_PAGE_NAME[SUB_PAGE_ID.HUD]      = "HUD"
SUB_PAGE_NAME[SUB_PAGE_ID.DTE]      = "DTE"
SUB_PAGE_NAME[SUB_PAGE_ID.NAV]      = "NAV"


count = 0

PAGE_ID = 1
