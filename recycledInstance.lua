local recycledInstance = {}
recycledInstance.expiration = 20 -- seconds of innactivity
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
	self.cache = {} :: {[number]: {instance: Instance, timestamp: number}}
	self.rate = 0
	return self
end

function recycledInstance.prepare(self: recycledInstance, cacheSize: number)
	for _ = 1, cacheSize do
		table.insert(self.cache, {
			instance = self.prefab:Clone(),
			timestamp = os.clock()
		})
	end
end

function recycledInstance.clone(self: recycledInstance): Instance
	local availableInstances = self.cache
	local availableInstance = availableInstances[#availableInstances]
	self.rate += 1
	if availableInstance then
		table.remove(availableInstances)
		return availableInstance.instance
	else
		return self.prefab:Clone()
	end
end

--[[ OLD optimize
function recycledInstance.optimize(self: recycledInstance, permittedExcess: number)
	local cache = self.cache
	local lenCache = #cache
	local rate = self.rate + permittedExcess
	if lenCache > rate then
		for i = lenCache, lenCache + rate do
			if cache[i] then
				cache[i]:Destroy()
				table.remove(cache, i)
			end
		end
	end
end
]]

function recycledInstance.optimize(self: recycledInstance)
	local cache = self.cache
	for i = 1, #cache do
		local selectedInstance = cache[i]
		if os.clock() - selectedInstance.timestamp >= self.expiration then
			table.remove(cache, i)
		end
	end
end

function recycledInstance.destroy(self: recycledInstance, instance: Instance, parent: Instance?)
	self.rate -= 1
	setPositionIfApplicable(instance, self.offset)
	if parent then
		instance.Parent = parent
	end
	table.insert(self.cache, {
		instance = instance,
		timestamp = os.clock()
	})
end


type recycledInstance = typeof(recycledInstance.new(Instance.new("Part")))
export type Type = recycledInstance

return recycledInstance
