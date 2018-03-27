-- 城区
local Town = class("Town")

-- 构造函数
function Town:ctor()
	--建筑物Id
	self._buildingId = 0

	--索引
	self._index = 0

	--图片Id
	--self._imageId = 0

	--所有者Id
	self._ownerId = 0

	--耐久消耗
	self._durabilityCost = 0

	--耐久恢复时间
	self._durabilityRecoveryTime = 0

	-- 建筑物
	self._building  = nil;
end

-- 初始化城区
function Town:Init(buildingId, index, ownerId)
	--建筑物Id
	self._buildingId = buildingId

	--索引
	self._index = index

	--图片Id
	--self._imageId = 0

	--所有者Id
	self._ownerId = ownerId

	--耐久消耗
	self._durabilityCost = 0

	--耐久恢复时间
	self._durabilityRecoveryTime = 0
end

--获取索引
function Town:GetIndex()
	return self._index;
end


return Town