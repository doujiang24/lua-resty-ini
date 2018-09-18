-- Copyright (C) Dejiang Zhu(doujiang24)


local io_open = io.open
local tonumber = tonumber
local re_match = ngx.re.match
local re_find = ngx.re.find
local substr = string.sub
local str_byte = string.byte


local _M = { _VERSION = "0.01" }

local section_pattern = [=[ \A \[ ([^\[\]]+) \] \z ]=]
local keyvalue_pattern = [[ \A \s* ( [\w_]+ ) \s* = \s* ( .+? ) (?: \s* )? \z ]]
-- space line or comment line
local comment_parttern = [[ \A (?: (?: \s* ) | (?: [;#] .* ) ) \z ]]


local function parse_value (value)
    if value == "true" then
        return true
    end

    if value == "false" then
        return false
    end

    local val = tonumber(value)
    if val then
        return val
    end

    local m = re_match(value, [[\A (['"]) (.+) \1 \z]], "jox")
    if m then
        return m[2]
    end

    local from = re_find(value, [=[ ['"] ]=], "jox")
    if not from then
        return value
    end

    return nil, "unsupportted value format: " .. value
end


function _M.parse_file(filename)
    local fp, err = io_open(filename)
    if not fp then
        return nil, "failed to open file: " .. (err or "")
    end

    local data = {}
    local section = "default"

    for line in fp:lines() do
        local m = re_match(line, section_pattern, "jox")
        if m then
            section = m[1]

        else
            local m = re_match(line, keyvalue_pattern, "jox")
            if m then
                if not data[section] then
                    data[section] = {}
                end

                local key = m[1]
                local value, err = parse_value(m[2])
                if err then
                    fp:close()

                    return nil, err
                end

                data[section][key] = value

            elseif not re_find(line, comment_parttern, "jox") then
                fp:close()

                return nil, "unsupportted key value pair format: " .. line
            end
        end
    end

    fp:close()

    return data
end


return _M
