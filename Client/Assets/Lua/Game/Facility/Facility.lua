Facility = class("Facility")

-- 构造函数
function Facility:ctor()
    self._id = 0;

    self._tableId = 0;

	self._level = 0;

	self._nextUpgradeTime = 0;
    
   -- self._Property = {};
end

function Facility:Init(id, FacilityId, level, nextUpgradeTime)
    self._id = id;

    self._FacilityId = FacilityId;

	self._level = level;

	self._nextUpgradeTime = nextUpgradeTime;
end

function Facility:SetLevel(level)
	self._level = level;
end

function Facility:GetLevel()
	return self._level;
end

-- function Facility:GetDataInfo()
-- 	return self._dataInfo;
-- end

-- function Facility:GetProperty()
-- 	return self._Property;
-- end

-- function Facility:SetBuildingTime(time)
-- 	self._nextUpgradeTime = time;
-- end

function Facility:SetBuildingTime(time)
	self._nextUpgradeTime = time;
end

function Facility:GetBuildingTime()
	return self._nextUpgradeTime;
end

function Facility:GetTableId()
	return self._tableId;
end

function Facility:SetId(id)
	self._id = id;
end

function Facility:GetId()
	return self._id;
end

return Facility;