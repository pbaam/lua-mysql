#!/usr/bin/env lua

local mysql = require "luamysql"

local dbarg = {
	host = "127.0.0.1",
	port = 3306,
	user = "usuario"
}

client = assert(mysql.newclient(dbarg))
assert(client:selectdb("prueba"))
assert(client:setcharset("utf8"))
assert(client:ping())

result = assert(client:escape("'ouonline'"))
io.write("escape string -> ", result, "\n")

result = assert(client:execute("select * from categorias"))

fieldnamelist = assert(result:fieldnamelist())

for record in result:recordlist() do
	io.write("---\n")
	for k, v in pairs(record) do
		io.write("[", k, "] -> ", fieldnamelist[k], ": ", v, "\n")
	end
end
