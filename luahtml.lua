local lines = {}
local sbox = setmetatable({}, { __index = _G })

local function printLine(...)
    local ret = {}
    for i = 1, select("#", ...) do
        local arg = tostring(select(i, ...))
        table.insert(ret, arg)
    end
    return table.concat(ret, "\t")
end

sbox.PrintTable = function(t)
    table.insert(lines, table.ToPlain(t))
end

sbox.print = function(...)
    table.insert(lines, printLine(...))
end

function EvalLuaHTML(luahtml)
    local error = false

    local output = string.gsub(luahtml, "<lua>(.-)</lua>", function(code)
        lines = {}

        local fn, syntaxError = load(code, "<lua>...</lua>", "t", sbox)
        if not fn then
            error = (error and error .."\n" or "") .. syntaxError
            return ""
        end

        local success, runtimeError = pcall(fn)
        if not success then
            error = (error and error .."\n" or "") .. runtimeError
            return ""
        end

        return table.concat(lines, "\n")
    end)

    return error or output
end

--[[
print(
    EvalLuaHTML("<h1><lua> print('Test') </lua></h1>")
)
]]--

function EvalLuaHTMLFile(path)
    local f = io.open(path, "r")
    if not f then return false, "" end
    local luahtml = f:read("*a")
    io.close(f)

    return true, EvalLuaHTML(luahtml)
end

--[[
print(
    EvalLuaHTMLFile("var/www/site.com/pages/index.lua.html")
)
]]--

return EvalLuaHTML, EvalLuaHTMLFile
