local count = 0
local function counter()
    count = count + 1
    return count
end

count = 0

SUB_PAGE_ID = {
    BASE         = 0,
    MAIN        = counter(),
    OFF          = counter(), -- no power
}

PAGE_ID = 1
