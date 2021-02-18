WEAPONS_NAMES = {}
WEAPONS_NAMES["{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}"] = "AIM9L"
WEAPONS_NAMES["{A-29B TANK}"]                           = "TANK"
WEAPONS_NAMES["{DB769D48-67D7-42ED-A2BE-108D566C8B1E}"] = "GBU12"

local count = -1
local function counter()
	count = count + 1
	return count
end

SMS_MODE_IDS = {
    SAFE        = counter(),
    AG          = counter(),
    AA          = counter(),
    SJ          = counter(),
    EJ          = counter(),
}

count = -1
SMS_CARGO_TYPE_IDS = {
    WPN         = counter(),
    RACK        = counter(),
}

count = -1
SMS_SUBFORM_IDS = {
    NORMAL      = counter(),
    INV         = counter(),
}


count = -1
SMS_AA_SIGHT_IDS = {
    SNAP      = counter(),
    LCOS         = counter(),
    SSLC         = counter(),
}

count = -1
SMS_AA_RR_SRC_IDS = {
    DL      = counter(),
    MAN         = counter(),
}

count = -1
SMS_AA_SLV_SRC_IDS = {
    BST         = counter(),
    DL      = counter(),
}

count = -1
SMS_AA_COOL_IDS = {
    COOL         = counter(),
    WARM      = counter(),
}

count = -1
SMS_AA_SCAN_IDS = {
    SCAN         = counter(),
    SPOT      = counter(),
}

count = -1
SMS_AA_LIMIT_IDS = {
    TD         = counter(),
    BP      = counter(),
}
