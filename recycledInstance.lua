local recycledInstance = {}
recycledInstance.offset = Vector3.new(10000, 0, 0)
recycledInstance.__index = recycledInstance

local function setPositionIfApplicable(instance: Instance | Model | BasePart, position: Vector3)
	if instance:IsA("Model") then
		instance:MoveTo(position)
	elseif instance:IsA("BasePart") then
		instance.CFrame = CFrame.new(position)
	end
end

function recycledInstance.new(prefab: Instance)
	local self = setmetatable({}, recycledInstance)
	self.prefab = prefab
	self.cache = {}
	self.rate = 0
	return self
end

function recycledInstance.clone(self: recycledInstance): Instance
	local availableInstances = self.cache
	local availableInstance = availableInstances[1]
	self.rate += 1
	if availableInstance then
		table.remove(availableInstances, 1)
		return availableInstance
	else
		return self.prefab:Clone()
	end
end

function recycledInstance.optimize(self: recycledInstance, permittedExcess: number)
	local cache = self.cache
	local lenCache = #cache
	local rate = self.rate
	if lenCache > rate + permittedExcess then
		for i = lenCache, lenCache - rate, -1 do
			if cache[i] then
				cache[i]:Destroy()
				table.remove(cache, i)
			end
		end
	end
end

function recycledInstance.destroy(self: recycledInstance, instance: Instance, parent: Instance?)
	self.rate -= 1
	setPositionIfApplicable(instance, self.offset)
	if parent then
		instance.Parent = parent
	end
	table.insert(self.cache, instance)
end


type recycledInstance = typeof(recycledInstance.new(Instance.new("Part")))
export type Type = recycledInstance

return recycledInstance
