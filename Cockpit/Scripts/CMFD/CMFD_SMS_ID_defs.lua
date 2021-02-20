
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


