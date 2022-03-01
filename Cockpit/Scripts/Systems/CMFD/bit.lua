local BIT_TEXT = get_param_handle("CMFD_BIT_TEXT")
BIT_TEXT:set("")

function update_bit()
    local text = "TEST\n\n"

    BIT_TEXT:set(text)
end

function SetCommandBit(command,value, CMFD)
   
end

function post_initialize_bit()

end
