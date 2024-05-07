#!/usr/bin/env lua

local sql = require "mysql"

local dbarg = {
	host = "127.0.0.1",
	port = 3306,
	user = "user"
}

db = assert(sql.newclient(dbarg))
assert(db:selectdb("test"))
assert(db:setcharset("utf8"))
assert(db:ping())

result = assert(db:execute("select * from test"))

fieldnamelist = assert(result:fieldnamelist())

for record in result:recordlist() do
	io.write("---\n")
	for k, v in pairs(record) do
		io.write("[", k, "] -> ", fieldnamelist[k], ": ", v, "\n")
	end
end

-- ---
-- [1] -> id: 1
-- [2] -> host: www.mozilla.org
-- [3] -> frequency: 1791
-- ---
-- [1] -> id: 2
-- [2] -> host: support.mozilla.org
-- [3] -> frequency: 740
-- ---
-- [1] -> id: 7
-- [2] -> host: drive.google.com
-- [3] -> frequency: 176911
-- ---
-- [1] -> id: 8
-- [2] -> host: kickassapp.com
-- [3] -> frequency: 120
-- ---
-- [1] -> id: 10
-- [2] -> host: www.geogebra.org
-- [3] -> frequency: 8319
-- ---
-- [1] -> id: 14
-- [2] -> host: www.netflix.com
-- [3] -> frequency: 289642
-- ---
-- [1] -> id: 15
-- [2] -> host: soundcloud.com
-- [3] -> frequency: 120
