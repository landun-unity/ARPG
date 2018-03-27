
local GameService = require("FrameWork/Game/GameService")

local FacilityHandler = require("Game/Facility/FacilityHandler")
local FacilityManage = require("Game/Facility/FacilityManage");
FacilityService = class("FacilityService", GameService)

local DataConstruction = require("Game/Table/model/DataConstruction");

-- 构造函数
function FacilityService:ctor()
    FacilityService._instance = self;
    FacilityService.super.ctor(self, FacilityManage.new(), FacilityHandler.new());
end

-- 单例
function FacilityService:Instance()
    return FacilityService._instance;
end

--清空数据
function FacilityService:Clear()
    self._logic:ctor()
end

-- function FacilityService:GetPlayId()
-- 	return self._logic:GetPlayId();
-- end

--buildingId设施数量
function FacilityService:GetAllFacilityCount(buildingId)
	return self._logic:GetAllFacilityCount(buildingId);
end

--buildingId id 设施
function FacilityService:GetFacilityById(buildingId, id)
	return self._logic:GetFacilityById(buildingId, id);
end

--buildingId tableId 设施
function FacilityService:GetFacilityByTableId(buildingId, tableId)
	return self._logic:GetFacilityByTableId(buildingId, tableId);
end

function FacilityService:GetFacilityNameByID(id)
    local templine = DataConstruction[id];
    if(templine~=nil) then
        return templine.Name;
    end
    return "";
end

--buildingId FacilityType 设施
function FacilityService:GetFacility(buildingId, facilityType)
	return self._logic:GetFacility(buildingId, facilityType);
end

--buildingId FacilityProperty 城市属性
function FacilityService:GetCityPropertyByFacilityProperty(buildingId, FacilityProperty)
	return self._logic:GetCityPropertyByFacilityProperty(buildingId, FacilityProperty);
end

--buildingId FacilityType 设施等级
function FacilityService:GetFacilitylevelByIndex(buildingId, FacilityType)
	return self._logic:GetFacilitylevelByIndex(buildingId, FacilityType);
end

--buildingId MaxLevelFacilityProperty 满级设施效果
function FacilityService:GetCityMaxLevelFacilityProperty(buildingId, MaxLevelFacilityProperty)
    return self._logic:GetCityMaxLevelFacilityProperty(buildingId, MaxLevelFacilityProperty);
end


return FacilityService;