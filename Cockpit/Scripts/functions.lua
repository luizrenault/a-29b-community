

function startup_print(msg)
--    print_message_to_user(msg)
end

function debug_message_to_user(msg)
--    print_message_to_user(msg)
end

function round_to(value, roundto)
    value = value + roundto/2
    return value - value % roundto
end

function spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end