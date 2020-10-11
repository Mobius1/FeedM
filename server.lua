local sorted = {}
-- populate the table that holds the keys
for k in pairs(Config.Pictures) do table.insert(sorted, k) end
-- sort the keys
table.sort(sorted)



local max = 0
for k, v in pairs(sorted) do
    local len = string.len(v)

    if len > max then
        max = len
    end
end

local str = "{\n"

for k, v in pairs(sorted) do
    local len = string.len(v)
    local spaces = (max + 1) - len

    str = str .. string.rep(" ", 4) .. v .. string.rep(" ", spaces) .. "= \"" .. Config.Pictures[v] .. "\",\n"
end

str = str .. "}"


file = io.open("resources/[bcb]/FeedM2/log.txt", "w+")

if file then
    file:write(str)
end

file:close()