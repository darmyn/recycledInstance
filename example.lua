local cache = Instance.new("Folder")
cache.Name = "cache"
cache.Parent = workspace

local prefab = Instance.new("Part")
prefab.Name = "prefab"
prefab.Position = Vector3.new(0, 5, 0)
prefab.Anchored = true

local myRecycledInstance = recycledInstance.new(prefab)
print("test")
local generatedPerSecond = .03

task.spawn(function()
	while true do
		generatedPerSecond = .03
		print("rate updated: ", generatedPerSecond)
		task.wait(3)
		generatedPerSecond = .05
		print("rate updated: ", generatedPerSecond)
		task.wait(3)
		generatedPerSecond = .1
		print("rate updated: ", generatedPerSecond)
		task.wait(3)
		generatedPerSecond = .03
		print("rate updated: ", generatedPerSecond)
		task.wait(3)
		generatedPerSecond = .25
		print("rate updated: ", generatedPerSecond)
	end
end)
while true do
	local newInstance = myRecycledInstance:clone()
	newInstance.Position = prefab.Position + Vector3.new(math.random(1, 5), math.random(1, 5), math.random(1, 5))
	newInstance.Parent = workspace
	task.spawn(function()
		task.wait(.5)
		myRecycledInstance:destroy(newInstance, cache)
	end)
	myRecycledInstance:optimize()
	task.wait(math.random(0.03, .25) * .01)
end
