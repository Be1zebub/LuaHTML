-- Usage example
-- a simple binding to luvit http/https webserver

local pages = {
	[""] = "/var/www/mysite/index.lua.html",
	["shop"] = "/var/www/mysite/shop.lua.html"
}

local domain = "incredible-gmod.ru"
local http_port, https_port = 80, 443 

local EvalLuaHTML, EvalLuaHTMLFile = require("luahtml")
local http, https, fs = require("http"), require("https"), require("fs")

local path_patterns = {
	"/index.html",
	"/index.lua",
	"/"
}

for url, path in pairs(pages) do
	for i, pp in ipairs(path_patterns) do
		pages[url .. pp] = path
	end

	pages["/".. url] = path
end

local function onRequest(req, res)
	local function response(body, code)
		res:setHeader("Content-Type", "text/plain")
		res:setHeader("Content-Length", #body)
		res.statusCode = code or 200
		res:finish(body)
	end

	if pages[req.url] then
		local succ, body = EvalLuaHTMLFile(pages[req.url])
		return response(succ and body or "FILE NOT FOUND", succ and 200 or 404)
	end

	response("404 Page not found", 404)
end

http.createServer(onRequest):listen(http_port)

https.createServer({
  key = fs.readFileSync("/etc/letsencrypt/live/".. domain .."/privkey.pem"),
  cert = fs.readFileSync("/etc/letsencrypt/live/".. domain .."/cert.pem"),
}, onRequest):listen(https_port)
