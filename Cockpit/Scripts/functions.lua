

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
