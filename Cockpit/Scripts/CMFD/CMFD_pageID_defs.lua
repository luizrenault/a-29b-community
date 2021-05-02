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
    DTE          = counter(),
    FLIR         = counter(),
    DVR          = counter(),
    CHECKLIST    = counter(),
    PFL          = counter(),
    BIT          = counter(),
    NAV          = counter(),
    HSD          = counter(),
    HUD          = counter(),
    SMS          = counter(),
    EW           = counter(),
    ADHSI        = counter(),
    UFCP         = counter(),
    EICAS        = counter(),
    BLANK        = counter(), -- not implemented from here
    NOAUX        = counter(), -- no signal from device
    OFF          = counter(), -- no power
    END          = counter(),
}

SUB_PAGE_NAME = {}
SUB_PAGE_NAME[SUB_PAGE_ID.BLANK]    = ""
SUB_PAGE_NAME[SUB_PAGE_ID.NOAUX]    = "NOAUX"

SUB_PAGE_NAME[SUB_PAGE_ID.DTE]      = "DTE"
SUB_PAGE_NAME[SUB_PAGE_ID.FLIR]     = "FLIR"
SUB_PAGE_NAME[SUB_PAGE_ID.DVR]      = "DVR"
SUB_PAGE_NAME[SUB_PAGE_ID.CHECKLIST]= "CHECK\nLIST"
SUB_PAGE_NAME[SUB_PAGE_ID.PFL]      = "PFL"
SUB_PAGE_NAME[SUB_PAGE_ID.BIT]      = "BIT"
SUB_PAGE_NAME[SUB_PAGE_ID.NAV]      = "NAV"

SUB_PAGE_NAME[SUB_PAGE_ID.HSD]      = "HSD"
SUB_PAGE_NAME[SUB_PAGE_ID.HUD]      = "HUD"
SUB_PAGE_NAME[SUB_PAGE_ID.SMS]      = "SMS"
SUB_PAGE_NAME[SUB_PAGE_ID.EW]       = "EW"
SUB_PAGE_NAME[SUB_PAGE_ID.ADHSI]    = "ADHSI"
SUB_PAGE_NAME[SUB_PAGE_ID.UFCP]     = "UFCP"
SUB_PAGE_NAME[SUB_PAGE_ID.EICAS]    = "EICAS"

count = 0

PAGE_ID = 1
