function basic_dump (o)
    if type(o) == "number" then
      return tostring(o)
    elseif type(o) == "string" then
      return string.format("%q", o)
    else -- nil, boolean, function, userdata, thread; assume it can be converted to a string
      return tostring(o)
    end
  end
  
  
  function dump (name, value, saved, result)
    seen = seen or {}       -- initial value
    result = result or ""
    result=result..name.." = "
    if type(value) ~= "table" then
      result=result..basic_dump(value).."\n"
      log.info(result)
      result = ""
    elseif type(value) == "table" then
      if seen[value] then    -- value already saved?
        result=result.."->"..seen[value].."\n"  -- use its previous name
        log.info(result)
        result = ""
        else
        seen[value] = name   -- save name for next time
        result=result.."{}\n"     -- create a new table
        log.info(result)
        result = ""
          for k,v in pairs(value) do      -- save its fields
          local fieldname = string.format("%s[%s]", name,
                                          basic_dump(k))
          if fieldname~="_G[\"seen\"]" then
            result=dump(fieldname, v, seen, result)
          end
        end
      end
    end
    return result
  end
  
  function dump_params(tbl)
    if not indent then indent = 0 end
    for k, v in pairs(tbl) do
      formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
          log.info(formatting)
          dump_params(v, indent+1)
        elseif type(v) == 'boolean' then
          log.info(formatting .. tostring(v))
        else
          log.info(formatting .. v)
        end
      end
  end