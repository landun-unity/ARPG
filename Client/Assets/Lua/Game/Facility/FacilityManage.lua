--[[
	城管理
--]]
local GamePart = require("FrameWork/Game/GamePart")
local List = require("common/List");
local BuildingService = require("Game/Build/BuildingService");
-- local CurrencyEnum = require("Game/Player/CurrencyEnum")
-- local City = require("Game/Build/Subject/City")
local FacilityManage = class("FacilityManage", GamePart)

function FacilityManage:ctor()
    FacilityManage.super.ctor(self);
    --id对应设施
    --self._BuildingAllFacility = {};
    --设施
    self._allFacility = List.new();
end

function FacilityManage:_OnInit()
    --self._allFacility:Clear();
end

-- --接收所有设施list
-- function FacilityManage:RequestAllFacility(Facility)
--     self._allFacility:Push(Facility);
-- end

function FacilityManage:GetBuildingById(buildingId)
    --print(buildingId)
    return BuildingService:Instance():GetBuilding(buildingId);
end

--通过id找设施
function FacilityManage:GetFacilityById(buildingId, id)
    local count = self:GetBuildingById(buildingId):GetAllFacilityCount();
    for i=1,count do
        local Facility = self:GetBuildingById(buildingId):GetFacilityByIndex(i);
        if id == Facility:GetId() then
            return Facility;
        end
    end
end

--通过id找设施
function FacilityManage:GetFacility(buildingId, index)
    --print(self._allFacility:Get(index))
    return self:GetBuildingById(buildingId):GetFacilityByIndex(index);
end

--通过Tableid找设施
function FacilityManage:GetFacilityByTableId(buildingId, tableId)
    --print(buildingId)
    --print(self:GetBuildingById(buildingId))
    local count = self:GetBuildingById(buildingId):GetAllFacilityCount();
    for i=1,count do
        local Facility = self:GetBuildingById(buildingId):GetFacilityByIndex(i);
        if tableId == Facility:GetTableId() then
            return Facility;
        end
    end
end

function FacilityManage:GetAllFacilityCount(buildingId)
    --print(buildingId)
    return self:GetBuildingById(buildingId):GetAllFacilityCount();
end

-- 改变设施 level 时间 属性
function FacilityManage:RequestUpgradeFacility(buildingId, id, level, time)
    --print(id123
    if id == nil then
        return;
    end
    local building = self:GetBuildingById(buildingId);
    local Facility = self:GetFacilityById(buildingId, id);
    if Facility == nil then
         return;
    else
        local currencyLevel = Facility:GetLevel();
        if time == 0 then
            building:ChangeFacilityProperty(currencyLevel, level, Facility);
            building:AddRedifCount();
            Facility:SetLevel(level);
            -- if self:GetFacility(buildingId, FacilityType.MainHouse)._id == id then
            --     MapService:Instance():RefreshBuilding(building);
            -- end
        end
        Facility:SetBuildingTime(time);
    end
end

--通过id找设施属性
function FacilityManage:GetCityPropertyByFacilityProperty(buildingId, type)
    if buildingId == nil then
        return;
    end
    local building = self:GetBuildingById(buildingId);
    if building == nil then
        return;
    end
    return building:GetCityPropertyByFacilityProperty(type);
end

--通过id找设施等级
function FacilityManage:GetFacilitylevelByIndex(buildingId, type)
    if buildingId == nil then
        return;
    end
    local building = self:GetBuildingById(buildingId);
    if building == nil then
        return;
    end
    return building:GetFacilitylevelByIndex(type);
end

--通过Tableid找设施
function FacilityManage:GetCityMaxLevelFacilityProperty(buildingId, MaxLevelFacilityProperty)
    if buildingId == nil or MaxLevelFacilityProperty == nil then
        return;
    end

    return self:GetBuildingById(buildingId):GetCityMaxLevelFacilityProperty(MaxLevelFacilityProperty);
end

return FacilityManage;