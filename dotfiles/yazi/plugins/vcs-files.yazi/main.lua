--- @since 25.4.8

local root = ya.sync(function() return cx.active.current.cwd end)

local function fail(content) return ya.notify { title = "VCS Files", content = content, timeout = 5, level = "error" } end

local function entry()
	local root = root()
	local output, err = Command("git"):cwd(tostring(root)):arg({ "diff", "--name-only", "HEAD" }):output()
	if err then
		return fail("Failed to run `git diff`, error: " .. err)
	elseif not output.status.success then
		return fail("Failed to run `git diff`, stderr: " .. output.stderr)
	end

	local id = ya.id("ft")
	local cwd = root:into_search("Git changes")
	ya.mgr_emit("cd", { Url(cwd) })
	ya.mgr_emit("update_files", { op = fs.op("part", { id = id, url = Url(cwd), files = {} }) })

	local files = {}
	for line in output.stdout:gmatch("[^\r\n]+") do
		local url = cwd:join(line)
		local cha = fs.cha(url, true)
		if cha then
			files[#files + 1] = File { url = url, cha = cha }
		end
	end
	ya.mgr_emit("update_files", { op = fs.op("part", { id = id, url = Url(cwd), files = files }) })
	ya.mgr_emit("update_files", { op = fs.op("done", { id = id, url = cwd, cha = Cha { kind = 16 } }) })
end

return { entry = entry }
