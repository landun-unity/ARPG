-- 城区
local ChildBoat = class("ChildBoat")

-- 构造函数
function ChildBoat:ctor()
	--索引
	self._index = 0

	-- 建筑物
	self._building  = nil
end

-- 初始化城区
function ChildBoat:Init(building, index)

	self._index = index

	self._building = building
end

-- 获取索引
function ChildBoat:GetIndex()
	return self._index
end

-- 获取建筑物
function ChildBoat:GetBuilding()
	return self._building
end

return ChildBoat