local GameService = require("FrameWork/Game/GameService")

local BuildingHandler = require("Game/Build/BuildingHandler")
local BuildingManage = require("Game/Build/BuildingManage");
BuildingService = class("BuildingService", GameService)

-- 构造函数
function BuildingService:ctor()
    BuildingService._instance = self;
    BuildingService.super.ctor(self, BuildingManage.new(), BuildingHandler.new());
end

-- 单例
function BuildingService:Instance()
    return BuildingService._instance;
end


-- 清空数据
function BuildingService:Clear()
    self._logic:ctor()
end

function BuildingService:RegisterAllBuildingClassMap()
    self._logic:RegisterAllBuildingClassMap()
end


-- 获取建筑物
function BuildingService:GetBuilding(id)
    return self._logic:_GetBuilding(id)
end

function BuildingService:GetTown(id)
    return self._logic:_GetTown(id)
end

-- 获取子码头
function BuildingService:GetChildBoat(index)
    return self._logic:_GetChildBoat(index)
end

-- 根据格子的索引获取建筑物
function BuildingService:GetBuildingByTiledId(tiledId)
    return self._logic:GetBuildingByTiledId(tiledId)
end

-- 创建野城
function BuildingService:CreateWildBuilding(index, tableId)
    return self._logic:CreateWildBuilding(index, tableId)
end

-- 创建玩家建筑物
function BuildingService:CreatePlayerBuilding(id, owner, index, tableId, name, successTime, deleteTime)
    return self._logic:CreatePlayerBuilding(id, owner, index, tableId, name, successTime, deleteTime)
end

function BuildingService:CreatePlayerFortBuilding(id, owner, index, tableId, name, fortLevel)
    return self._logic:CreatePlayerFortBuilding(id, owner, index, tableId, name, fortLevel)
end

-- 创建玩家建筑物
function BuildingService:ClearAllBuilding()
    return self._logic:ClearAllBuilding()
end

function BuildingService:_GetBuildingCount()
    return self._logic:_GetBuildingCount();
end

function BuildingService:DeletePlayerBuilding(building)
    self._logic:DeletePlayerBuilding(building)
end

function BuildingService:DeleteBuilding(id)
    return self._logic:_DeleteBuilding(id);
end

function BuildingService:DeleteBuildingTiled(tiledId)
    return self._logic:_DeleteBuildingTiled(tiledId)
end

function BuildingService:DeleteBuildingTown(building)
    self._logic:DeleteBuildingTown(building)
end


function BuildingService:BuildFort(index, completeTime, name)
    self._logic:BuildFort(index, completeTime, name)
end

function BuildingService:IsArmy(buildingId, tiledIndex, fortArmyCount)
    self._logic:IsArmy(buildingId, tiledIndex, fortArmyCount)
end

function BuildingService:deleteFortTimer(index, deleteTime)
    self._logic:deleteFortTimer(index, deleteTime)
end

-- 请求被占领的野城的信息
function BuildingService:SendGetOccWildBuildingMessage()
    self._logic:SendGetOccWildBuildingMessage()
end

function BuildingService:GetBeOwnedWildCityList()
    return self._logic:GetBeOwnedWildCityList()
end

function BuildingService:ShowCreateFortCountdown(index, createTime, buildingId)
    self._logic:ShowCreateFortCountdown(index, createTime, buildingId)
end

function BuildingService:ClickQuitTimeBox(index)
    self._logic:ClickQuitTimeBox(index)
end
return BuildingService;