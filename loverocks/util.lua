local lfs = require 'lfs'
local util = {}

local function slurp_file(fname)
	local file = io.open(fname, 'r')
	local s = file:read('*a')
	file:close()
	return s
end

local function slurp_dir(dir)
	local t = {}
	for f in lfs.dir(dir) do
		if f ~= "." and f  ~= ".." then
			t[f] = util.slurp(dir .. "/" .. f)
		end
	end
	return t
end

function util.slurp(path)
	local ftype = lfs.attributes(path, 'mode')
	if ftype == 'directory' then
		return slurp_dir(path)
	else
		return slurp_file(path)
	end
end

local function spit_file(str, dest)
	print('spit ' .. dest)
	local file = io.open(dest, "w")
	file:write(str)
	file:close()
end

local function spit_dir(tbl, dest)
	print('mkdir ' .. dest)
	lfs.mkdir(dest)
	for f, s in pairs(tbl) do
		if f ~= "." and f  ~= ".." then
			util.spit(s, dest .. "/" .. f)
		end
	end
end

function util.spit(o, dest)
	if type(o) == 'table' then
		spit_dir(o, dest)
	else
		spit_file(o, dest)
	end
end

function util.luarocks(...)
	local argstr = table.concat({...}, " ")
	return os.execute("luarocks --tree='rocks' " .. argstr)
end

return util