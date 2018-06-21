-- Copyright (C) Dejiang Zhu(doujiang24)


local io_open = io.open
local tonumber = tonumber
local re_match = ngx.re.match
local substr = string.sub
local str_byte = string.byte


local _M = { _VERSION = "0.01" }

local section_pattern = [[ \A \[ ([^ \[ \] ]+) \] \z ]]
local keyvalue_pattern =
    [[ \A \s* ( [\w_]+ ) \s* = \s* ( ' [^']* ' | " [^"]* " | \S+ ) (?:\s*)? \z ]]


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

                local key, value = m[1], m[2]

                local val = tonumber(value)
                if val then
                    value = val

                elseif value == "true" then
                    value = true

                elseif value == "false" then
                    value = false

                else
                    local fst = str_byte(value, 1)
                    if fst == 34 or fst == 39 then  -- ' or "
                        value = substr(value, 2, -2)
                    end
                end

                data[section][key] = value
            end
        end
    end

    fp:close()

    return data
end


return _M
