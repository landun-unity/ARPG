-- 建筑物消息处理
local IOHandler = require("FrameWork/Game/IOHandler")
local BuildingHandler = class("BuildingHandler", IOHandler)
local LoadResourcesPrefab = require("Game/Util/LoadResourcesPrefab")
local MapLoad = require("Game/Map/MapLoad")
local ArmySlotType = require("Game/Army/ArmySlotType")
local List = require("common/List");

-- 构造函数
function BuildingHandler:ctor()
    -- body
    BuildingHandler.super.ctor(self);
    self._requestTimer = nil;
    self._drawLoadResourcesPrefab = LoadResourcesPrefab.new()
    self._UISignObject = nil;
    self._requestTimerTable = { };

end

-- 注册所有消息
function BuildingHandler:RegisterAllMessage()
    self:RegisterMessage(L2C_Player.SyncOwnerBuilding, self.HandleSyncOwnerBuilding, require("MessageCommon/Msg/L2C/Player/SyncOwnerBuilding"));
    self:RegisterMessage(L2C_Player.SyncRegionBuildingInfo, self.HandleSyncRegionBuildingInfo, require("MessageCommon/Msg/L2C/Player/SyncRegionBuildingInfo"));
    self:RegisterMessage(L2C_Player.SyncBuildingInfo, self.HandleSyncBuildingInfo, require("MessageCommon/Msg/L2C/Player/SyncBuildingInfo"));
    self:RegisterMessage(L2C_Building.SyncBuildQueueList, self.HandleSyncBuildingQueueList, require("MessageCommon/Msg/L2C/Building/SyncBuildQueueList"));
    -- self:RegisterMessage(L2C_Facility.CityExpandRespond, self.HandleSyncOwnerBuildingInfo, require("MessageCommon/Msg/L2C/Facility/CityExpandRespond"));
    self:RegisterMessage(L2C_Building.MoveMainCity, self.HandleMoveMainCity, require("MessageCommon/Msg/L2C/Building/MoveMainCity"));
 --   self:RegisterMessage(L2C_Building.SyncCreatePlayerBuilding, self.HandleSyncCreatePlayerBuilding, require("MessageCommon/Msg/L2C/Building/SyncCreatePlayerBuilding"));
 --   self:RegisterMessage(L2C_Building.SyncCreatePlayerBuildingTime, self.HandleSyncCreatePlayerBuildingTime, require("MessageCommon/Msg/L2C/Building/SyncCreatePlayerBuildingTime"));
 --   self:RegisterMessage(L2C_Building.SyncPlayerFort, self.HandleSyncPlayerFort, require("MessageCommon/Msg/L2C/Building/SyncPlayerFort"));
    self:RegisterMessage(L2C_Building.SyncUpdatePlayerFort, self.HandleSyncUpdatePlayerFort, require("MessageCommon/Msg/L2C/Building/SyncUpdatePlayerFort"));
   -- self:RegisterMessage(L2C_Building.DeleteFort, self.HandleDeleteFort, require("MessageCommon/Msg/L2C/Building/DeleteFort"));
   -- self:RegisterMessage(L2C_Building.PlayerFortTime, self.HandlePlayerFortEndTime, require("MessageCommon/Msg/L2C/Building/PlayerFortTime"));
    self:RegisterMessage(L2C_Building.CreateSubCityTime, self.HandleCreateSubCityTime, require("MessageCommon/Msg/L2C/Building/CreateSubCityTime"));
    self:RegisterMessage(L2C_Building.SyncCreatePlayerSubCity, self.HandleSyncCreatePlayerSubCity, require("MessageCommon/Msg/L2C/Building/SyncCreatePlayerSubCity"));
    self:RegisterMessage(L2C_Building.ReplyDeleteFortTimer, self.HandleReplyDeleteFortTimer, require("MessageCommon/Msg/L2C/Building/ReplyDeleteFortTimer"));
    self:RegisterMessage(L2C_Building.ReplyUpdateFort, self.HandleReplyUpdateFort, require("MessageCommon/Msg/L2C/Building/ReplyUpdateFort"));
    self:RegisterMessage(L2C_Building.UpdateFortTime, self.HandleUpdateFortTime, require("MessageCommon/Msg/L2C/Building/UpdateFortTime"));
    -- self:RegisterMessage(L2C_Building.DeleteFortTime, self.HandleDeleteFortTime, require("MessageCommon/Msg/L2C/Building/DeleteFortTime"));
    self:RegisterMessage(L2C_Building.RemoveBuilding, self.HandleRemoveBuildingOver, require("MessageCommon/Msg/L2C/Building/RemoveBuilding"));
    self:RegisterMessage(L2C_Building.DeleteClickFort, self.HandleDeleteClickFort, require("MessageCommon/Msg/L2C/Building/DeleteClickFort"));
    self:RegisterMessage(L2C_Building.SyncOccupyWildCity, self.HandleSyncOccupyWildCity, require("MessageCommon/Msg/L2C/Building/SyncOccupyWildCity"));
    self:RegisterMessage(L2C_Building.TiledByBuildingMarker, self.HandleTiledByBuildingMarker, require("MessageCommon/Msg/L2C/Building/TiledByBuildingMarker"));

end

-- 处理拆除分城完成逻辑
function BuildingHandler:HandleRemoveBuildingOver(msg)
    -- --print("处理拆除分城完成逻辑+++++++++++++++++++")
    if msg.buildingType == BuildingType.PlayerFort then
        local tiledIndex = msg.coord;
        local buildingId = msg.id;
        local building = BuildingService:Instance():GetBuildingByTiledId(tiledIndex)
        if building ~= nil then
            MapService:Instance():RefreshFortHideTiled(building)
            BuildingService:Instance():DeleteBuilding(buildingId)
            BuildingService:Instance():DeleteBuildingTiled(tiledIndex)
            PlayerService:Instance():DeleteFort(tiledIndex)
            PlayerService:Instance():DeletePlayerFort(building)
            local tiled = MapService:Instance():GetTiledByIndex(tiledIndex)
            if tiled ~= nil then
                tiled._building = nil;
            end
            local UISignObject = PlayerService:Instance():GetFortMap(tiledIndex);
            self._logicManage:HideBuildForImage(buildingId)
            self._logicManage:ClickQuitTimeBox(tiledIndex)
            PlayerService:Instance():RemoveFortMap(tiledIndex)
        end
    elseif msg.buildingType == BuildingType.SubCity then
        local building = BuildingService:Instance():GetBuilding(msg.id);
        PlayerService:Instance():RemoveSubCity(building);
        MapService:Instance():_RefreshSubCityCountDown(building);
        MapService:Instance():HidePlayerBuilding(building);
        BuildingService:Instance():DeletePlayerBuilding(building);

    elseif msg.buildingType == BuildingType.WildFort or msg.buildingType == BuildingType.WildGarrisonBuilding then
        local buildingId = msg.id;
        local tiledIndex = msg.coord;
        local wildFort = BuildingService:Instance():GetBuilding(msg.id);
        PlayerService:Instance():RemoveOccuptWildFortCount(wildFort)
        wildFort._owner = 0;
        self:HandleRemoveBuildingWithArmy(wildFort);


        -- BuildingService:Instance():DeleteBuilding(buildingId)
        -- BuildingService:Instance():DeleteBuildingTiled(tiledIndex)
    end
end


function BuildingHandler:HandleRemoveBuildingWithArmy(wildFort)
    -- body

    local armyCount = wildFort:GetWildFortArmyInfoCounts();
    local newTable = List.new();
    for i = 1, armyCount do
        local armyInfo = wildFort:GetWildFortArmyInfos(i);
        if armyInfo ~= nil then
            newTable:Push(armyInfo);
        end
    end
    local newSize = newTable:Count();
    for i = 1, newSize do
        local armyInfo = newTable:Get(i);
        if armyInfo ~= nil then
            wildFort:RemoveWildFortArmyInfo(armyInfo);
        end
    end

end

-- 处理自己的同步建筑物
function BuildingHandler:HandleSyncOwnerBuildingInfo(msg)
    -- 清空所有的建筑物
    -- ------------print("BuildingHandler:HandleSyncOwnerBuildingInfo");
    -- local building = BuildingService:Instance():GetBuilding(msg.buildingId);
    -- building._canExpandTimes = msg.canExpandTime;
    -- -- ------------print(msg.list:Count());
    -- local count = msg.list:Count();
    -- for i = 1, count do
    --     local syncBuilding = msg.list:Get(i);
    --     local cityTiled = require("Game/Build/Building/CityTiled").new();
    --     if building ~= nil then
    --         cityTiled._index = syncBuilding.index;
    --         cityTiled._tableId = syncBuilding.tableid;
    --         cityTiled._level = syncBuilding.level;
    --         -- ------------print(syncBuilding.index..syncBuilding.tableid..syncBuilding.level..syncBuilding.folkType)
    --         cityTiled._ResidenceType = syncBuilding.folkType;
    --         building:SetCityTitleValue(syncBuilding.index, cityTiled);

    --     end
    -- end
end

-- 设置同步建筑物的建造队列
function BuildingHandler:HandleSyncBuildingQueueList(msg)
    -- body
    ------print("BuildingHandler:HandleSyncBuildingQueueList=====================================");
    local count = msg.list:Count();
    for i = 1, count do
        local syncBuilding = msg.list:Get(i);
        local building = self._logicManage:_GetBuilding(syncBuilding.buildingId);
        if building then
            ------print(syncBuilding.baseQueueCount);
            ------print(syncBuilding.tempQueueCount);
            if building._dataInfo.Type == BuildingType.MainCity or building._dataInfo.Type == BuildingType.SubCity then
                building:SetConstructionQueueMaxValue(syncBuilding.baseQueueCount, syncBuilding.tempQueueCount);
            end
        end
    end
end

-- 处理自己的同步建筑物
function BuildingHandler:HandleSyncOwnerBuilding(msg)
    -- 清空所有的建筑物
    
    local count = msg.allBuilding:Count();
    for i = 1, count do
        local syncBuilding = msg.allBuilding:Get(i);

        --   ----print(syncBuilding.tiledId)
        local building = self._logicManage:_GetBuilding(syncBuilding.id);
        if syncBuilding.buildingType == BuildingType.PlayerFort then
            -- 建造中
            local building = self._logicManage:_GetBuilding(syncBuilding.id);
            if syncBuilding.buildSuccessTime ~= 0 then
                PlayerService:Instance():SetFortNum(syncBuilding.nameNum);
                if building == nil then
                    building = self._logicManage:CreatePlayerFortBuilding(syncBuilding.id, syncBuilding.ownerId, syncBuilding.tiledId, syncBuilding.tableId, syncBuilding.name, 0);
                    building:SetLeagueName(syncBuilding.leagueName)
                    building:SetLeagueId(syncBuilding.leagueId)
                    building._name = syncBuilding.name;
                    building._buildSuccessTime = syncBuilding.buildSuccessTime
                    building.createTime = syncBuilding.createTime;
                    if building._owner == PlayerService:Instance():GetPlayerId() then
                        PlayerService:Instance():SetPlayerFort(building._tiledId, building)
                        PlayerService:Instance():SetFort(building)
                    end
                end
                MapService:Instance():RefreshBuilding(building)
                self._logicManage:BuildFort(syncBuilding.tiledId, syncBuilding.buildSuccessTime, syncBuilding.name, syncBuilding.id)
                if UIService:Instance():GetOpenedUI(UIType.UIConfirmfortressBuild) == true then
                    UIService:Instance():HideUI(UIType.UIConfirmfortressBuild)
                end
            else
                local building = self._logicManage:_GetBuilding(syncBuilding.id);
                if building == nil then
                    building = self._logicManage:CreatePlayerFortBuilding(syncBuilding.id, syncBuilding.ownerId, syncBuilding.tiledId, syncBuilding.tableId, syncBuilding.name, syncBuilding.buildingLev);
                    building._buildSuccessTime = syncBuilding.buildSuccessTime
                    building._buildDeleteTime = syncBuilding.removeBuildTime
                    if building._owner == PlayerService:Instance():GetPlayerId() then
                        PlayerService:Instance():SetPlayerFort(building._tiledId, building)
                        PlayerService:Instance():SetFort(building)
                    end
                    PlayerService:Instance():SetFortNum(syncBuilding.nameNum);
                    building:SetFortGrade(syncBuilding.buildingLev);
                    MapService:Instance():RefreshFortBuilding(building);
                end
                building:SetLeagueId(syncBuilding.leagueId)
                building:SetLeagueName(syncBuilding.leagueName)
                building._upgradeFortTime = syncBuilding.upgradeFortTime
                building:SetFortRed(syncBuilding.fortArmyCount)
                building.removeTime = syncBuilding.removeTime;
                if syncBuilding.removeBuildTime - PlayerService:Instance():GetLocalTime() > 0 then
                    self._logicManage:ShowCreateFortCountdown(syncBuilding.tiledId, syncBuilding.removeBuildTime, syncBuilding.id, 2)
                else
                    self._logicManage:ClickQuitTimeBox(syncBuilding.tiledId)
                end

                if syncBuilding.fortArmyCount ~= 0 then
                    self._logicManage:IsArmy(syncBuilding.id, syncBuilding.tiledId, syncBuilding.fortArmyCount);
                else
                    self._logicManage:HideFortArmyCount(syncBuilding.tiledId)
                end
            end
        elseif syncBuilding.buildingType == BuildingType.MainCity or syncBuilding.buildingType == BuildingType.SubCity then

            local building = BuildingService:Instance():CreatePlayerBuilding(syncBuilding.id, syncBuilding.ownerId, syncBuilding.tiledId, syncBuilding.tableId, syncBuilding.name, syncBuilding.buildSuccessTime, syncBuilding.removeBuildTime);
            if building ~= nil then
                building._durabilityCost = syncBuilding.durabilityCost;
                building._durabilityRecoveryTime = syncBuilding.durabilityRecoveryTime;
                building:SetBuildingRedif(syncBuilding.redifNum);
                building:AddRedifCount();
                building:SetLeagueName(syncBuilding.leagueName)
                building:SetLeagueId(syncBuilding.leagueId)
                building:SetCityLevel(syncBuilding.buildingLev)
                MapService:Instance():_RefreshSubCityCountDown(building);
                ----print("BuildingHandler:HandleSyncOwnerBuilding");
                PlayerService:Instance():AddSubCityToPlayerCityInfoList(building);
            end
        elseif syncBuilding.buildingType == BuildingType.WildFort or syncBuilding.buildingType == BuildingType.WildGarrisonBuilding then
            -- local building = self._logicManage:_GetBuilding(syncBuilding.id);

            local building = self._logicManage:_GetBuilding(syncBuilding.id);
            ------print(building);
            if building ~= nil then
                building._dataInfo = DataBuilding[syncBuilding.tableId]
                building:SetId(syncBuilding.id)
                building._tableId = syncBuilding.tableId
                building._owner = syncBuilding.ownerId
                building._name = syncBuilding.name
                building._tiledId = syncBuilding.tiledId
                if syncBuilding.buildingType == BuildingType.WildGarrisonBuilding then
                    building:SetBuildingRedif(syncBuilding.redifNum);
                    building:AddRedifCount();
                end
            end
            if building == nil then
                building = self._logicManage:CreateWildBuilding(syncBuilding.tiledId, syncBuilding.tableId)
                building._owner = syncBuilding.ownerId
            end
            -- MapService:Instance():RefreshBuilding(building);
            PlayerService:Instance():AddCreateOccupyWildFort(building);
            building = BuildingService:Instance():GetBuilding(syncBuilding.id)
            building:SetFortRed(syncBuilding.fortArmyCount)
            if syncBuilding.fortArmyCount ~= 0  then
                self._logicManage:IsArmy(syncBuilding.id, syncBuilding.tiledId, syncBuilding.fortArmyCount);
            else
                self._logicManage:HideFortArmyCount(syncBuilding.tiledId)
            end

        end
    end
    LoginService:Instance():EnterState(LoginStateType.RequestCardInfo);
end

-- 处理地图格子建筑物
function BuildingHandler:HandleSyncRegionBuildingInfo(msg)
    -- 清空所有的建筑物
    local count = msg.allBuilding:Count();
    for i = 1, count do
        local syncBuilding = msg.allBuilding:Get(i);
        if syncBuilding.buildingType == BuildingType.PlayerFort then
            -- 建造中
            local building = self._logicManage:_GetBuilding(syncBuilding.id);
            if syncBuilding.buildSuccessTime ~= 0 then
                local endTime = syncBuilding.buildSuccessTime
                local index = syncBuilding.tiledId
                local name = syncBuilding.name
                if building == nil then
                    building = self._logicManage:CreatePlayerFortBuilding(syncBuilding.id, syncBuilding.ownerId, syncBuilding.tiledId, syncBuilding.tableId, syncBuilding.name, 0);
                    building:SetLeagueName(syncBuilding.leagueName)
                    building:SetLeagueId(syncBuilding.leagueId)
                    building._name = name;
                    building._buildSuccessTime = syncBuilding.buildSuccessTime
                    building.createTime = syncBuilding.createTime;
                    if building._owner == PlayerService:Instance():GetPlayerId() then
                        PlayerService:Instance():SetPlayerFort(building._tiledId, building)
                        PlayerService:Instance():SetFort(building)
                    end
                end
                MapService:Instance():RefreshBuilding(building)
                self._logicManage:BuildFort(syncBuilding.tiledId, syncBuilding.buildSuccessTime, syncBuilding.name, syncBuilding.id)
                if UIService:Instance():GetOpenedUI(UIType.UIConfirmfortressBuild) == true then
                    UIService:Instance():HideUI(UIType.UIConfirmfortressBuild)
                end
            else
                local building = self._logicManage:_GetBuilding(syncBuilding.id);
                if building == nil then
                    building = self._logicManage:CreatePlayerFortBuilding(syncBuilding.id, syncBuilding.ownerId, syncBuilding.tiledId, syncBuilding.tableId, syncBuilding.name, syncBuilding.buildingLev);
                    if building._owner == PlayerService:Instance():GetPlayerId() then
                        PlayerService:Instance():SetPlayerFort(building._tiledId, building)
                        PlayerService:Instance():SetFort(building)
                    end
                    building._upgradeFortTime = syncBuilding.upgradeFortTime
                end
                building.removeTime = syncBuilding.removeTime;
                
                if syncBuilding.fortArmyCount ~= 0 then
                    self._logicManage:IsArmy(syncBuilding.id, syncBuilding.tiledId, syncBuilding.fortArmyCount);
                else
                    self._logicManage:HideFortArmyCount(syncBuilding.tiledId)
                end
                building:SetFortRed(syncBuilding.fortArmyCount)
                if syncBuilding.removeBuildTime ~= 0 then
                    self._logicManage:ShowCreateFortCountdown(syncBuilding.tiledId, syncBuilding.removeBuildTime, syncBuilding.id, 2)
                else
                    self._logicManage:ClickQuitTimeBox(syncBuilding.tiledId)
                end
                building:SetFortGrade(syncBuilding.buildingLev);
                MapService:Instance():RefreshFortBuilding(building);
                building:SetLeagueId(syncBuilding.leagueId)
                building:SetLeagueName(syncBuilding.leagueName)
            end
        elseif syncBuilding.buildingType == BuildingType.MainCity or syncBuilding.buildingType == BuildingType.SubCity then
            local building = self._logicManage:_GetBuilding(syncBuilding.id);
            -- ------------print(syncBuilding.ownerId.." , "..syncBuilding.tiledId)
            if building == nil then
                building = BuildingService:Instance():CreatePlayerBuilding(syncBuilding.id, syncBuilding.ownerId, syncBuilding.tiledId, syncBuilding.tableId, syncBuilding.name, syncBuilding.buildSuccessTime, syncBuilding.removeBuildTime);
            else
                building._subCitySuccessTime = syncBuilding.buildSuccessTime;
                building._subCityDeleteTime = syncBuilding.removeBuildTime;
            end
            if building ~= nil then
                --self._logicManage:_CreatePlayerTown(building);
                building._durabilityCost = syncBuilding.durabilityCost;
                building._durabilityRecoveryTime = syncBuilding.durabilityRecoveryTime;
                building:SetBuildingRedif(syncBuilding.redifNum)
                building:AddRedifCount();
                -- building._canExpandTimes = syncBuilding.canExpandTime;
                building:SetLeagueName(syncBuilding.leagueName)
                building:SetLeagueId(syncBuilding.leagueId)
                if building._cityTitleList ~= nil then
                    building._cityTitleList:Clear();
                end
                building:SetCityLevel(syncBuilding.buildingLev);
                -- local facdeCount = syncBuilding.titleList:Count();
                -- for j = 1, facdeCount do
                --     local cityTitle = syncBuilding.titleList:Get(j);
                --     -- ------------print(cityTitle.index..","..cityTitle.level..","..cityTitle.tableid..","..cityTitle.folkType);
                --     if cityTitle ~= nil then
                --         local mCityTitle = require("Game/Build/Building/CityTiled").new();
                --         mCityTitle:Init(cityTitle.index, cityTitle.level, cityTitle.tableid, cityTitle.folkType);
                --         building:SetCityTitleValue(cityTitle.index, mCityTitle);
                --     end
                -- end
            end
            MapService:Instance():RefreshBuilding(building);
            MapService:Instance():RefreshTown(building);
            MapService:Instance():_RefreshSubCityCountDown(building);
            ----print("BuildingHandler:HandleSyncRegionBuildingInfo");
            PlayerService:Instance():AddSubCityToPlayerCityInfoList(building);
        elseif syncBuilding.buildingType == BuildingType.WildFort or syncBuilding.buildingType == BuildingType.WildGarrisonBuilding then
            local building = self._logicManage:_GetBuilding(syncBuilding.id);
            local building = self._logicManage:_GetBuilding(syncBuilding.id);
            if building ~= nil then
                building._dataInfo = DataBuilding[syncBuilding.tableId]
                building:SetId(syncBuilding.id)
                building._tableId = syncBuilding.tableId
                building._owner = syncBuilding.ownerId
                building._name = syncBuilding.name
                building._tiledId = syncBuilding.tiledId
                PlayerService:Instance():AddCreateOccupyWildFort(building);
                building:SetFortRed(syncBuilding.fortArmyCount)
                if syncBuilding.buildingType == BuildingType.WildGarrisonBuilding then
                    building:SetBuildingRedif(syncBuilding.redifNum);
                    building:AddRedifCount();
                end
                if syncBuilding.fortArmyCount ~= 0  then
                    self._logicManage:IsArmy(syncBuilding.id, syncBuilding.tiledId, syncBuilding.fortArmyCount);
                else
                    self._logicManage:HideFortArmyCount(syncBuilding.tiledId)
                end
            end
        end
    end
end

-- 处理地图建筑物
function BuildingHandler:HandleSyncBuildingInfo(msg)
    -- 清空所有的建筑物
    --print("HandleSyncBuildingInfo+++++++++++++++++++++++++++++")
    local count = msg.allBuilding:Count();
    for i = 1, count do
        local syncBuilding = msg.allBuilding:Get(i);
        if syncBuilding.buildingType == BuildingType.PlayerFort then
            local building = self._logicManage:_GetBuilding(syncBuilding.id);
            if syncBuilding.buildSuccessTime ~= 0 then
                PlayerService:Instance():SetFortNum(syncBuilding.nameNum);
                local endTime = syncBuilding._buildSuccessTime
                local index = syncBuilding.tiledId
                local name = syncBuilding.name
                if building == nil then
                    building = self._logicManage:CreatePlayerFortBuilding(syncBuilding.id, syncBuilding.ownerId, syncBuilding.tiledId, syncBuilding.tableId, syncBuilding.name, 0);
                    building:SetLeagueName(syncBuilding.leagueName)
                    building:SetLeagueId(syncBuilding.leagueId)
                    building._name = name;
                    building._buildSuccessTime = syncBuilding.buildSuccessTime
                    building.createTime = syncBuilding.createTime;
                    if building._owner == PlayerService:Instance():GetPlayerId() then
                        PlayerService:Instance():SetPlayerFort(building._tiledId, building)
                        PlayerService:Instance():SetFort(building)
                    end
                end
                MapService:Instance():RefreshBuilding(building)
                
                self._logicManage:BuildFort(syncBuilding.tiledId, syncBuilding.buildSuccessTime, syncBuilding.name, syncBuilding.id)
                if UIService:Instance():GetOpenedUI(UIType.UIConfirmfortressBuild) == true then
                    UIService:Instance():HideUI(UIType.UIConfirmfortressBuild)
                end
                if UIService:Instance():GetOpenedUI(UIType.UIFort) == true then
                    UIService:Instance():HideUI(UIType.UIFort)
                end
            else
                local building = self._logicManage:_GetBuilding(syncBuilding.id);
                if building == nil then
                    building = self._logicManage:CreatePlayerFortBuilding(syncBuilding.id, syncBuilding.ownerId, syncBuilding.tiledId, syncBuilding.tableId, syncBuilding.name, syncBuilding.buildingLev);
                    if building._owner == PlayerService:Instance():GetPlayerId() then
                        PlayerService:Instance():SetPlayerFort(building._tiledId, building)
                        PlayerService:Instance():SetFort(building)
                    end
                end
                building:SetLeagueId(syncBuilding.leagueId)
                building:SetLeagueName(syncBuilding.leagueName)
                building._buildSuccessTime = syncBuilding.buildSuccessTime
                building._buildDeleteTime = syncBuilding.removeBuildTime
                building._upgradeFortTime = syncBuilding.upgradeFortTime
                building:SetFortGrade(syncBuilding.buildingLev);
                MapService:Instance():RefreshFortBuilding(building);
                building:SetFortRed(syncBuilding.fortArmyCount)
                building.removeTime = syncBuilding.removeTime;
                if syncBuilding.fortArmyCount ~= 0 then
                    self._logicManage:IsArmy(syncBuilding.id, syncBuilding.tiledId, syncBuilding.fortArmyCount);
                else
                    self._logicManage:HideFortArmyCount(syncBuilding.tiledId)
                end
                if syncBuilding.removeBuildTime ~= 0 then
                    self._logicManage:ShowCreateFortCountdown(syncBuilding.tiledId, syncBuilding.removeBuildTime, syncBuilding.id, 2)
                else
                    self._logicManage:ClickQuitTimeBox(syncBuilding.tiledId)
                end
            end

        elseif syncBuilding.buildingType == BuildingType.MainCity or syncBuilding.buildingType == BuildingType.SubCity then
            local building = self._logicManage:_GetBuilding(syncBuilding.id);
            -- ------------print(syncBuilding.ownerId.." , "..syncBuilding.tiledId)
            if building == nil then
                building = BuildingService:Instance():CreatePlayerBuilding(syncBuilding.id, syncBuilding.ownerId, syncBuilding.tiledId, syncBuilding.tableId, syncBuilding.name, syncBuilding.buildSuccessTime, syncBuilding.removeBuildTime);
            else
                building._subCitySuccessTime = syncBuilding.buildSuccessTime;
                building._subCityDeleteTime = syncBuilding.removeBuildTime;
            end

            if building ~= nil then
                --self._logicManage:_CreatePlayerTown(building)

                building._durabilityCost = syncBuilding.durabilityCost;
                building._durabilityRecoveryTime = syncBuilding.durabilityRecoveryTime;
                building:SetBuildingRedif(syncBuilding.redifNum)
                building:AddRedifCount();
                building:SetLeagueName(syncBuilding.leagueName)
                building:SetLeagueId(syncBuilding.leagueId)
                building:SetCityLevel(syncBuilding.buildingLev);

                -- building._canExpandTimes = syncBuilding.canExpandTime;
                -- if building._cityTitleList ~= nil then
                --     building._cityTitleList:Clear();
                -- end
                -- local facdeCount = syncBuilding.titleList:Count();
                -- ------------print(facdeCount)
                -- for j = 1, facdeCount do
                --     local cityTitle = syncBuilding.titleList:Get(j);
                --     -- ------------print(cityTitle.index..","..cityTitle.level..","..cityTitle.tableid..","..cityTitle.folkType);
                --     if cityTitle ~= nil then
                --         local mCityTitle = require("Game/Build/Building/CityTiled").new();
                --         mCityTitle:Init(cityTitle.index, cityTitle.level, cityTitle.tableid, cityTitle.folkType);
                --         building:SetCityTitleValue(cityTitle.index, mCityTitle);
                --     end
                -- end
            end
            MapService:Instance():RefreshBuilding(building);
            MapService:Instance():RefreshTown(building);
            MapService:Instance():_RefreshSubCityCountDown(building);
            ----print("HandleSyncBuildingInfo");
            PlayerService:Instance():AddSubCityToPlayerCityInfoList(building);
        elseif syncBuilding.buildingType == BuildingType.WildFort or syncBuilding.buildingType == BuildingType.WildGarrisonBuilding then
            local building = self._logicManage:_GetBuilding(syncBuilding.id);
            if building ~= nil then
                building._dataInfo = DataBuilding[syncBuilding.tableId]
                building:SetId(syncBuilding.id)
                building._tableId = syncBuilding.tableId
                building._owner = syncBuilding.ownerId
                building._name = syncBuilding.name
                building._tiledId = syncBuilding.tiledId
                if syncBuilding.buildingType == BuildingType.WildGarrisonBuilding then
                    building:SetBuildingRedif(syncBuilding.redifNum);
                    building:AddRedifCount();
                end
                -- if building == nil then
                --     self._logicManage:CreatePlayerOccupyWildFort(syncBuilding.id, syncBuilding.ownerId, syncBuilding.tiledId, syncBuilding.tableId, syncBuilding.name)
                -- end
                -- MapService:Instance():RefreshBuilding(building);
                PlayerService:Instance():AddCreateOccupyWildFort(building);
                building:SetFortRed(syncBuilding.fortArmyCount)
                if syncBuilding.fortArmyCount ~= 0  then
                    self._logicManage:IsArmy(syncBuilding.id, syncBuilding.tiledId, syncBuilding.fortArmyCount);
                else
                    self._logicManage:HideFortArmyCount(syncBuilding.tiledId)
                end
            end
        end
    end
end

-- 处理地图建筑物
function BuildingHandler:HandleMoveMainCity(msg)
    local building = self._logicManage:_GetBuilding(msg.buildingId);
    if building == nil then
        return;
    end
    self._logicManage:MoveMainCity(building, msg.index);
end

-- 取消放弃要塞
function BuildingHandler:HandleReplyDeleteFortTimer(msg)
    local tiledIndex = msg.tiledIndex
    local baseClass = UIService:Instance():GetUIClass(UIType.UIUpgradeBuilding);
    if baseClass ~= nil then
        baseClass:SetFortResources();
    end
    UIService:Instance():HideUI(UIType.UIDeleteFort);
    UIService:Instance():ShowUI(UIType.UIUpgradeBuilding, tiledIndex);
    self._logicManage:ClickQuitTimeBox(tiledIndex)
end

-- 取消升级要塞
function BuildingHandler:HandleReplyUpdateFort(msg)
    local baseClass = UIService:Instance():GetUIClass(UIType.UIUpgradeBuilding);
    local isopen = UIService:Instance():GetOpenedUI(UIType.UIDeleteFortCancelMarchAffirm);
    if baseClass ~= nil and isopen == true then
        baseClass:Fortexplicit()
        UIService:Instance():HideUI(UIType.UIDeleteFortCancelMarchAffirm)
    end
end

function BuildingHandler:HandleDeleteClickFort(msg)
    ------print("放弃要塞")
    local tiledIndex = msg.tiledIndex;
    local tiled = MapService:Instance():GetTiledByIndex(tiledIndex)
    if tiled ~= nil then
        if tiled._building ~= nil then
            tiled._building._buildDeleteTime = 0;
            self._logicManage:ClickQuitTimeBox(tiled._index)
        end
    end
end

-- 升级要塞
function BuildingHandler:HandleSyncUpdatePlayerFort(msg)
    local level = msg.level;
    local tiled = msg.tiledIndex;
    local building = PlayerService:Instance():GetPlayerFort(tiled);
    if building == nil then
        return
    end
    building:SetFortGrade(level);
    local baseClass = UIService:Instance():GetUIClass(UIType.UIMainCity);
    local isopen = UIService:Instance():GetOpenedUI(UIType.UIMainCity);
    if baseClass ~= nil and isopen == true then
        baseClass:RefreshBuildQueues();
    end
    
end

function BuildingHandler:DeleteFortTime(msg)
    local endTime = msg.endTime;
    local index = msg.index;
    local tiled = MapService:Instance():GetTiledByIndex(tiledIndex);
    if tiled ~= nil then
        local building = tiled:GetBuilding()
        building:SetDeleteFortTime(endTime)
    end
    local downTime = endTime;
    local curTimer = self._requestTimerTable[index];
    if curTimer == nil then
        self._requestTimerTable[index] = CommonService:Instance():TimeDown(nil,downTime, curTimer, function() self:BuildEnd(index) end);
    end
end
function BuildingHandler:BuildEnd(index)
    UIService:Instance():HideUI(UIType.UIDeleteFort);
    UIService:Instance():ShowUI(UIType.UIUpgradeBuilding, index);
end

-- -- 拆除
-- function BuildingHandler:HandleDeleteFort(msg)
--     local tiledIndex = msg.index;
--     local buildingId = msg.building;
--     local building = BuildingService:Instance():GetBuildingByTiledId(tiledIndex)
--     for i = 1, 5 do
--         local armyinfo = building:GetArmyInfos(i);
--         if armyinfo ~= nil then
--             if armyinfo:IsArmyInConscription() == true then
--                 for k, v in pairs(ArmySlotType) do
--                     if armyinfo:IsConscription(v) == true then
--                         -- 取消征兵消息
--                         local msg = require("MessageCommon/Msg/C2L/Army/CancelArmyConscription").new();
--                         msg:SetMessageId(C2L_Army.CancelArmyConscription);
--                         msg.buliding = armyinfo.spawnBuildng;
--                         msg.armyIndex = armyinfo.spawnSlotIndex - 1;
--                         msg.slotType = v;
--                         NetService:Instance():SendMessage(msg)
--                     end
--                 end
--             end
--         else
--         end
--     end
--     MapService:Instance():RefreshFortHideTiled(building)
--     BuildingService:Instance():DeleteBuilding(buildingId)
--     --------print("55555555555555"..buildingId)
--     BuildingService:Instance():DeleteBuildingTiled(tiledIndex)
--     PlayerService:Instance():DeleteFort(tiledIndex)
--     PlayerService:Instance():DeletePlayerFort(building)

--     local tiled = MapService:Instance():GetTiledByIndex(tiledIndex);
--     tiled:DeleteFort();
--     local UISignObject = PlayerService:Instance():GetFortMap(tiledIndex);
--     self._drawLoadResourcesPrefab:Recovery(UISignObject);
--     PlayerService:Instance():RemoveFortMap(tiledIndex)
-- end

-- 创建分城时间
function BuildingHandler:HandleCreateSubCityTime(msg)
    local endTime = msg.endTime
    local index = msg.index
    local baseClass = UIService:Instance():GetUIClass(UIType.UIConfirmBuild);
    local isopen = UIService:Instance():GetOpenedUI(UIType.UIConfirmBuild);
    if baseClass ~= nil and isopen == true then
        baseClass:BuildingSubCity(index, endTime);
        UIService:Instance():HideUI(UIType.UIConfirmBuild)
    end
end

-- 创建分城
function BuildingHandler:HandleSyncCreatePlayerSubCity(msg)
    local buildingId = msg.buildingId;
    local index = msg.index;
    local tableId = msg.tableId;
    local ownerId = msg.ownerId;
    local cityName = msg.cityName;
    self._logicManage:CreatePlayerBuilding(buildingId, ownerId, index, tableId, cityName);
    local building = BuildingService:Instance():GetBuilding(buildingId);
    MapService:Instance():RefreshFortBuilding(building);
    local x, y = MapService:Instance():GetTiledCoordinate(index)
    MapService:Instance():HandleCreateTiled(x, y)
end


function BuildingHandler:HandleSyncOccupyWildCity(msg)
    self._logicManage:SetBeOwnedWildCityList(msg.list)
    local baseClass = UIService:Instance():GetUIClass(UIType.UIPmap)
    if baseClass then
        local stateID = baseClass:GetStateType()
        baseClass:SetPmapCityScroll(stateID)
    end
    PlayerService:Instance():SetPlayerIsLogined();
end

-- 标记信息发生变化
function BuildingHandler:HandleTiledByBuildingMarker(msg)
    local name = msg.name
    local tiledId = msg.index
    local marker = PlayerService:Instance():GetMarkerMap(tiledId)
    if marker ~= nil then
        marker.name = name
    end
end


return BuildingHandler