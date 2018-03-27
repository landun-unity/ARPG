local CityTiled = class("CityTiled")

-- 构造函数
function CityTiled:ctor()
    -- 索引
    self._index = 0;
    self._tableId = 0;
    self._level =0;
    self._ResidenceType = 0;
end

function CityTiled:Init(index, level, tableId, residenceType)
	self._index = index;
	self._level = level;
	self._tableId = tableId;
	self._ResidenceType = residenceType;
end

-- function CityTiled:GetFacilityType()
-- 	return self._facilityType;
-- end

-- function CityTiled:SetFacilityType(facilityType)
-- 	self._facilityType = facilityType;
-- end

function CityTiled:GetIndex()
	return self._index;
end

function CityTiled:SetIndex(index)
	self._index = index;
end

function CityTiled:GetLevel()
	return self._level;
end 

function CityTiled:SetLevel(level)
	self._level = level;
end 

function CityTiled:GetResidenceType()
	return self._ResidenceType;
end 

function CityTiled:SetResidenceType(ResidenceType)
	self._ResidenceType = ResidenceType;
end 

return CityTiled