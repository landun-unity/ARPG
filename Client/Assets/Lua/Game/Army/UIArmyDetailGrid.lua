--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local UIBase = require("Game/UI/UIBase");
local UIArmyDetailGrid = class("UIArmyDetailGrid", UIBase);
local UIType = require("Game/UI/UIType");
local UIService = require("Game/UI/UIService");

function UIArmyDetailGrid:ctor()
    UIArmyDetailGrid.super.ctor(self);

    self._grid = nil;
    -- 点击的格子
    self._tiled = nil;
    -- 所有战平部队
    self._allZPArmy = {};
    -- 所有驻守部队
    self._allZSArmy = {};
    -- 所有屯田部队
    self._allTTArmy = {};
    -- 所有练兵部队
    self._allLBArmy = {};
    -- 所有要塞内的（待命）部队（我自己的要塞）
    self._allFortArmy = {};
    -- 所有野外要塞(待命)部队（我自己的要塞）
    self._allWildFortArmy = {};
    -- 所有要塞内的（待命）部队数量（非我自己的要塞）
    self._allEnemyFortArmyCount = 0;
    -- 所有野外要塞(待命)部队数量（非我自己的要塞）
    self._allEnemyWildFortArmyCount = 0;
    -- 所有部队ui预设脚本
    self._allArmyDetailUI = {};
    -- 是否初始化ui
    self._isInit = false;
end

function UIArmyDetailGrid:DoDataExchange()
    self._grid = self:RegisterController(UnityEngine.Transform, "armyList/Viewport/Content");
end

-- 注册所有的通知
function UIArmyDetailGrid:RegisterAllNotice()
    self:RegisterNotice(L2C_Map.SyncRegionTiled, self.UpdateArmyUIList);
    self:RegisterNotice(L2C_Map.SyncTiled, self.UpdateArmyUIList);
    self:RegisterNotice(L2C_Army.ArmyBaseInfo, self.UpdateArmyUIList);
end

function UIArmyDetailGrid:OnShow(tiledIndex)
    self._tiled = MapService:Instance():GetTiledByIndex(tiledIndex);
    if self._tiled == nil then
        UIService:Instance():HideUI(UIType.UIArmyDetailGrid);
        return;
    end

    if self._isInit == false then
        self:RefreshAllMaps();
        self._isInit = true;
    end

    if #self._allFortArmy + #self._allZPArmy + #self._allZSArmy + #self._allTTArmy + #self._allLBArmy + #self._allWildFortArmy + self._allEnemyFortArmyCount + self._allEnemyWildFortArmyCount <= 0 then
        UIService:Instance():HideUI(UIType.UIArmyDetailGrid);
        return;
    end

    MapService:Instance():MoveToTargetAndCallBack(tiledIndex, function()
        self:InitAllArmyDetailList();
        local parentX = self._grid.localPosition.x;
        self._grid.localPosition = Vector3.New(parentX, 0, 0);
    end);
end

function UIArmyDetailGrid:OnHide(param)
	for i = 1, #self._allArmyDetailUI do
        if self._allArmyDetailUI[i].gameObject.activeSelf == true then
            self._allArmyDetailUI[i].gameObject:SetActive(false);
        end
    end
end

function UIArmyDetailGrid:UpdateArmyUIList()
    if self then
        if self.gameObject.activeSelf == false then
            return;
        end

        if self._tiled == nil then
            UIService:Instance():HideUI(UIType.UIArmyDetailGrid);
            return;
        end

        self:RefreshAllMaps();

        if #self._allFortArmy + #self._allZPArmy + #self._allZSArmy + #self._allTTArmy + #self._allLBArmy + #self._allWildFortArmy + self._allEnemyFortArmyCount + self._allEnemyWildFortArmyCount <= 0 then
            UIService:Instance():HideUI(UIType.UIArmyDetailGrid);
            return;
        end

        self:InitAllArmyDetailList();
        local parentX = self._grid.localPosition.x;
        self._grid.localPosition = Vector3.New(parentX, 0, 0);
    end
end

function UIArmyDetailGrid:RefreshAllMaps()
    self:GetAllZPArmy();
    self:GetAllZSArmy();
    self:GetAllTTArmy();
    self:GetAllLBArmy();
    self:GetAllFortArmy();
    self:GetAllEnemyFortArmy();
    self:GetAllWildFortArmy();
    self:GetAllEnemyWildFortArmy();
end

function UIArmyDetailGrid:CheckTiledArmys(tiledIndex)
    self._tiled = MapService:Instance():GetTiledByIndex(tiledIndex);
    if self._tiled == nil then
        return false;
    end

    self:RefreshAllMaps();

    if #self._allFortArmy + #self._allZPArmy + #self._allZSArmy + #self._allTTArmy + #self._allLBArmy + #self._allWildFortArmy + self._allEnemyFortArmyCount + self._allEnemyWildFortArmyCount <= 0 then
        return false;
    end

    return true;
end

-- 获取所有战平部队
function UIArmyDetailGrid:GetAllZPArmy()
    self._allZPArmy = {};
    if self._tiled.tiledInfo == nil or self._tiled.tiledInfo.allDrawArmyInfoList:Count()  <= 0 then
        return;
    end

    for i = 1, self._tiled.tiledInfo.allDrawArmyInfoList:Count() do
        local armyInfoModel = self._tiled.tiledInfo.allDrawArmyInfoList:Get(i);
        table.insert(self._allZPArmy, armyInfoModel);
    end
end

-- 获取所有驻守部队
function UIArmyDetailGrid:GetAllZSArmy()
    self._allZSArmy = {};
    if self._tiled.tiledInfo == nil or self._tiled.tiledInfo.allGarrisonArmyInfoList:Count()  <= 0 then
        return;
    end

    for i = 1, self._tiled.tiledInfo.allGarrisonArmyInfoList:Count() do
        local armyInfoModel = self._tiled.tiledInfo.allGarrisonArmyInfoList:Get(i);
        if armyInfoModel.tiledId == self._tiled._index then
            table.insert(self._allZSArmy, armyInfoModel);
        end
    end
end

-- 获取所有屯田部队
function UIArmyDetailGrid:GetAllTTArmy()
    self._allTTArmy = {};
    if self._tiled.tiledInfo == nil or self._tiled.tiledInfo.allMitaingArmyInfoList:Count()  <= 0 then
        return;
    end

    for i = 1, self._tiled.tiledInfo.allMitaingArmyInfoList:Count() do
        local armyInfoModel = self._tiled.tiledInfo.allMitaingArmyInfoList:Get(i);
        if armyInfoModel.tiledId == self._tiled._index then
            table.insert(self._allTTArmy, armyInfoModel);
        end
    end
end

-- 获取所有练兵部队
function UIArmyDetailGrid:GetAllLBArmy()
    self._allLBArmy = {};
    if self._tiled.tiledInfo == nil or self._tiled.tiledInfo.allTrainingArmyInfoList:Count()  <= 0 then
        return;
    end

    for i = 1, self._tiled.tiledInfo.allTrainingArmyInfoList:Count() do
        local armyInfoModel = self._tiled.tiledInfo.allTrainingArmyInfoList:Get(i);
        table.insert(self._allLBArmy, armyInfoModel);
    end
end

-- 获取所有我自己要塞内的（待命）部队（只显示调动到达状态的部队）
function UIArmyDetailGrid:GetAllFortArmy()
    self._allFortArmy = {};
    local building = BuildingService:Instance():GetBuildingByTiledId(self._tiled._index);
    if building == nil or building._dataInfo.Type ~= BuildingType.PlayerFort then
        return;
    end

    if building._owner ~= PlayerService:Instance():GetPlayerId() then
        return;
    end

    local count = building:GetArmyInfoCounts();
    for i = 1, count do
        local armyInfo = building:GetArmyInfos(i);
        if armyInfo.armyState == ArmyState.TransformArrive then
            table.insert(self._allFortArmy, armyInfo);
        end
    end
end

-- 获取所有非我自己要塞内的（待命）部队（根据红点数量）
function UIArmyDetailGrid:GetAllEnemyFortArmy()
    self._allEnemyFortArmyCount = 0;
    local building = BuildingService:Instance():GetBuildingByTiledId(self._tiled._index);
    if building == nil or building._dataInfo.Type ~= BuildingType.PlayerFort then
        return;
    end

    if building._owner == PlayerService:Instance():GetPlayerId() then
        return;
    end

    local redCount = building:GetFortRed();
    if redCount <= 0 then
        return;
    end

    self._allEnemyFortArmyCount = redCount;
end

-- 获取所有我自己野外要塞内的（待命）部队（只显示调动到达状态的部队）
function UIArmyDetailGrid:GetAllWildFortArmy()
    self._allWildFortArmy = {}
    local building = BuildingService:Instance():GetBuildingByTiledId(self._tiled._index);
    if building == nil or building._dataInfo.Type ~= BuildingType.WildFort and building._dataInfo.Type ~= BuildingType.WildGarrisonBuilding then
        return;
    end
    
    if building._owner ~= PlayerService:Instance():GetPlayerId() then
        return;
    end

    local count = building:GetWildFortArmyInfoCounts()
    for i=1,count do
         local armyInfo = building:GetWildFortArmyInfos(i)
         if armyInfo.armyState == ArmyState.TransformArrive then
            table.insert(self._allWildFortArmy, armyInfo)
         end
    end

end

-- 获取所有非我自己野外要塞内的（待命）部队（根据红点数量）
function UIArmyDetailGrid:GetAllEnemyWildFortArmy()
    self._allEnemyWildFortArmyCount = 0;
    local building = BuildingService:Instance():GetBuildingByTiledId(self._tiled._index);
    if building == nil or building._dataInfo.Type ~= BuildingType.WildFort and building._dataInfo.Type ~= BuildingType.WildGarrisonBuilding then
        return;
    end

    if building._owner == PlayerService:Instance():GetPlayerId() then
        return;
    end

    local redCount = building:GetFortRed();
    if redCount <= 0 then
        return;
    end

    self._allEnemyWildFortArmyCount = redCount;
end

-- 初始化所有部队ui列表
function UIArmyDetailGrid:InitAllArmyDetailList()
    local count = 0;

    if #self._allZPArmy > 0 then
        for i = 1, #self._allZPArmy do
            count = count + 1;
            local armyInfoModel = self._allZPArmy[i];
            self:CreateOneArmyDetail(count, armyInfoModel.playerID, armyInfoModel.buildingID, armyInfoModel.slotIndex + 1, ArmyState.BattleIng, armyInfoModel.name);
        end
    end

    if #self._allZSArmy > 0 then
        for i = 1, #self._allZSArmy do
            count = count + 1;
            local armyInfoModel = self._allZSArmy[i];
            self:CreateOneArmyDetail(count, armyInfoModel.playerID, armyInfoModel.buildingID, armyInfoModel.slotIndex + 1, ArmyState.GarrisonIng, armyInfoModel.name);
        end
    end

    if #self._allTTArmy > 0 then
        for i = 1, #self._allTTArmy do
            count = count + 1;
            local armyInfoModel = self._allTTArmy[i];
            self:CreateOneArmyDetail(count, armyInfoModel.playerID, armyInfoModel.buildingID, armyInfoModel.slotIndex + 1, ArmyState.MitaIng, armyInfoModel.name);
        end
    end

    if #self._allLBArmy > 0 then
        for i = 1, #self._allLBArmy do
            count = count + 1;
            local armyInfoModel = self._allLBArmy[i];
            self:CreateOneArmyDetail(count, armyInfoModel.playerID, armyInfoModel.buildingID, armyInfoModel.slotIndex + 1, ArmyState.Training, armyInfoModel.name);
        end
    end

    if #self._allFortArmy > 0 and self._tiled.tiledInfo ~= nil then
        for i = 1, #self._allFortArmy do
            count = count + 1;
            local armyInfo = self._allFortArmy[i];
            self:CreateOneArmyDetail(count, self._tiled.tiledInfo.ownerId, armyInfo.spawnBuildng, armyInfo.spawnSlotIndex, ArmyState.TransformArrive, self._tiled.tiledInfo.ownerName);
        end
    end

    if self._allEnemyFortArmyCount > 0 and self._tiled.tiledInfo ~= nil then
        for i = 1, self._allEnemyFortArmyCount do
            count = count + 1;
            self:CreateOneArmyDetail(count, self._tiled.tiledInfo.ownerId, 0, 0, ArmyState.TransformArrive, self._tiled.tiledInfo.ownerName);
        end
    end

    if #self._allWildFortArmy > 0 and self._tiled.tiledInfo ~= nil then
        for i=1, #self._allWildFortArmy do
            count = count + 1;
            local armyInfo = self._allWildFortArmy[i]
            self:CreateOneArmyDetail(count, self._tiled.tiledInfo.ownerId, armyInfo.spawnBuildng, armyInfo.spawnSlotIndex, ArmyState.TransformArrive, self._tiled.tiledInfo.ownerName);
        end
    end

    if self._allEnemyWildFortArmyCount > 0 and self._tiled.tiledInfo ~= nil then
        for i = 1, self._allEnemyWildFortArmyCount do
            count = count + 1;
            self:CreateOneArmyDetail(count, self._tiled.tiledInfo.ownerId, 0, 0, ArmyState.TransformArrive, self._tiled.tiledInfo.ownerName);
        end
    end

    -- 隐藏多余的
    if count < #self._allArmyDetailUI then
        for i = count + 1, #self._allArmyDetailUI do
            if self._allArmyDetailUI[i].gameObject.activeSelf == true then
                self._allArmyDetailUI[i].gameObject:SetActive(false);
            end
        end
    end
end

-- 创建一个部队
function UIArmyDetailGrid:CreateOneArmyDetail(index, playerId, armySpawnBuild, armySpawnSlot, armyState, name)
    if self._allArmyDetailUI[index] == nil then
        local uiArmyDetail = require("Game/Army/UIArmyDetail").new();
        GameResFactory.Instance():GetUIPrefabByIdentification("UIPrefab/UIArmyDetail", self._grid, uiArmyDetail, function (go)
                uiArmyDetail:Init();
                uiArmyDetail:InitInfo(self._tiled, playerId, armySpawnBuild, armySpawnSlot, armyState, name);
                self._allArmyDetailUI[index] = uiArmyDetail;
        end, "UIArmyDetail"..armySpawnBuild..armySpawnSlot);
    else
        if self._allArmyDetailUI[index].gameObject.activeSelf == false then
            self._allArmyDetailUI[index].gameObject:SetActive(true);
        end
        self._allArmyDetailUI[index]:InitInfo(self._tiled, playerId, armySpawnBuild, armySpawnSlot, armyState, name);
    end
end

return UIArmyDetailGrid;

--endregion
