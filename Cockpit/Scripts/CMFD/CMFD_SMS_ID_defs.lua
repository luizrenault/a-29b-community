
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
    OTHER       = counter(),
    CD          = counter(),
    RP          = counter(),
    IS          = counter(),
    SD          = counter(),
    REL         = counter(),

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
SMS_FUSE_SEL_IDS = {
    NT         = counter(),
    N      = counter(),
    T      = counter(),
    SAFE      = counter(),
}

count = -1
SMS_LAUNCH_MODE_IDS = {
    CCIP         = counter(),
    MAN      = counter(),
    CCRP      = counter(),
    DTOS      = counter(),
}

count = -1
SMS_FUSE_TYPE_IDS = {
    IMPC         = counter(),
    PROX     = counter(),
    ONETIME      = counter(),
}

count = -1
SMS_TIME_ALT_SEL_IDS = {
    AD         = counter(),
    ADBA    = counter(),
    FDBA      = counter(),
}

count = -1
SMS_IS_UNIT_IDS = {
    M = counter (),
    MS = counter (),
}

count = -1
SMS_BR_RR_SEL_IDS = {
    BR         = counter(),
    RR    = counter(),
}



count = -1
SMS_PROF_SEL_IDS = {
    PROF1         = counter(),
    PROF2         = counter(),
    PROF3         = counter(),
    PROF4         = counter(),
    PROF5         = counter(),
}

