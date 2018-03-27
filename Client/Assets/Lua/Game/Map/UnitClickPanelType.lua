--[[
	通用ClickPanelType解析
--]]
local DataClickPanelType = require("Game/Table/model/DataClickPanelType")
local UnitClickPanelType = class("UnitClickPanelType")


-- 构造函数
function UnitClickPanelType:ctor()
    self._clickPanelMap = {}
    self:Init()
end

-- 初始化点击面板类型
function UnitClickPanelType:Init()
    local count = #DataClickPanelType
    for index = 1, count do
        local record = DataClickPanelType[index]
        self:InsertRowRecord(record)
    end
end

-- 获得同盟状态
function UnitClickPanelType:FindLeagueState(leagueStateType)
    if leagueStateType == nil then
        return nil;
    end
    return self._clickPanelMap[leagueStateType];
end

-- 创建同盟状态
function UnitClickPanelType:CreateLeagueState(leagueStateType)
    local state = {};
    self._clickPanelMap[leagueStateType] = state;
    return state;
end

-- 添加一行记录
function UnitClickPanelType:InsertRowRecord(record)
    if record == nil then
        return;
    end
    local leagueState = self:FindLeagueState(record.AlliesState);
    if leagueState == nil then
        leagueState = self:CreateLeagueState(record.AlliesState);
    end

    self:InsertOccupyState(leagueState, record);
end

-- 插入沦陷状态
function UnitClickPanelType:InsertOccupyState( leagueState, record )
    if leagueState == nil or record == nil then
        return;
    end

    local occupyState = self:FindOccupyState(leagueState, record.OccupyState);
    if occupyState == nil then
        occupyState = self:CreateOccupyState(leagueState, record.OccupyState);
    end
    self:InsertTiledOwnerType(occupyState, record)
end

-- 查找沦陷状态
function UnitClickPanelType:FindOccupyState( leagueState, occupyStateType )
    if leagueState == nil or occupyStateType == nil then
        return;
    end
    return leagueState[occupyStateType];
end

-- 创建沦陷状态
function UnitClickPanelType:CreateOccupyState( leagueState, occupyStateType )
    local state = {};
    leagueState[occupyStateType] = state;
    return state;
end

-- 查找土地所有者类型
function UnitClickPanelType:FindTiledOwnerType(occupyState, ownerType)
    if occupyState == nil or ownerType == nil then
        return;
    end
    return occupyState[ownerType];
end

-- 创建土地所有者类型map
function UnitClickPanelType:CreateTiledOwnerType(occupyState, ownerType)
    local state = {};
    occupyState[ownerType] = state;
    return state;
end

-- 插入沦陷状态
function UnitClickPanelType:InsertTiledOwnerType( occupyState, record )
    if occupyState == nil or record == nil then
        return;
    end
    local ownerTypeTable = self:FindTiledOwnerType(occupyState, record.OwnType);
    if ownerTypeTable == nil then
        ownerTypeTable = self:CreateTiledOwnerType(occupyState, record.OwnType);
    end
    self:InsertTiledLeagueState(ownerTypeTable, record)
end

-- 查找地块同盟状态
function UnitClickPanelType:FindTiledLeagueState(ownerTypeTable, tiledLeagueStateType)
    if ownerTypeTable == nil or tiledLeagueStateType == nil then
        return;
    end
    return ownerTypeTable[tiledLeagueStateType]
end

-- 创建地块同盟状态
function UnitClickPanelType:CreateTiledLeagueState(ownerTypeTable, tiledLeagueStateType)
    local state = {};
    ownerTypeTable[tiledLeagueStateType] = state;
    return state;
end

-- 插入地块同盟状态
function UnitClickPanelType:InsertTiledLeagueState(ownerTypeTable, record)
    if ownerTypeTable == nil or record == nil then
        return;
    end
    local tiledLeagueState = self:FindTiledLeagueState(ownerTypeTable, record.OtherAlliesState);
    if tiledLeagueState == nil then
        tiledLeagueState = self:CreateTiledLeagueState(ownerTypeTable, record.OtherAlliesState);
    end
    self:InsertTiledSuperLeagueState(tiledLeagueState, record)
end

-- 查找地块上级盟状态
function UnitClickPanelType:FindTiledSuperLeagueState(tiledLeagueState, tiledSuperLeagueStateType)
    if tiledLeagueState == nil or tiledSuperLeagueStateType == nil then
        return;
    end
    return tiledLeagueState[tiledSuperLeagueStateType]
end

-- 创建地块上级盟状态
function UnitClickPanelType:CreateTiledSuperLeagueState(tiledLeagueState, tiledSuperLeagueStateType)
    local state = {};
    tiledLeagueState[tiledSuperLeagueStateType] = state;
    return state;
end

-- 插入地块上级盟状态
function UnitClickPanelType:InsertTiledSuperLeagueState(tiledLeagueState, record)
    if tiledLeagueState == nil or record == nil then
        return;
    end
    local tiledSuperLeagueState = self:FindTiledSuperLeagueState(tiledLeagueState, record.TargetOwnType);
    if tiledSuperLeagueState == nil then
        tiledSuperLeagueState = self:CreateTiledSuperLeagueState(tiledLeagueState, record.TargetOwnType);
    end
    self:InsertTiledType(tiledSuperLeagueState, record)
end

-- 查找地块类型
function UnitClickPanelType:FindTiledType(tiledSuperLeagueState, tiledType)
    if tiledSuperLeagueState == nil or tiled == nil then
        return nil
    end
    return tiledSuperLeagueState[tiledType]
end

-- 创建地块类型
function UnitClickPanelType:CreateTiledType(tiledSuperLeagueState, tiledType)
    local state = {};
    tiledSuperLeagueState[tiledType] = state;
    return state;
end


-- 插入地块类型
function UnitClickPanelType:InsertTiledType(tiledSuperLeagueState, record)
    if tiledSuperLeagueState == nil or record == nil then
        return;
    end
    local tiledTypeTable = self:FindTiledType(tiledSuperLeagueState, record.Type)
    if tiledTypeTable == nil then
        tiledTypeTable = self:CreateTiledType(tiledSuperLeagueState, record.Type)
    end
    self:InsertButtonList(tiledTypeTable, record)
end

-- 插入地块颜色
function UnitClickPanelType:InsertButtonList(tiledTypeTable, record)
    if tiledTypeTable == nil or record == nil then
        return;
    end
    local map = {}
    map.button = record.Button
    map.color = record.Color
    table.insert(tiledTypeTable, map)
end


-- 获取玩家同盟状态
function UnitClickPanelType:GetPlayerAlliesStateType(myLeagueId)
    if myLeagueId ~= 0 then
        return PlayerAlliesStateType.In
    else
        return PlayerAlliesStateType.Out
    end
end

-- 获取玩家沦陷状态
function UnitClickPanelType:GetPlayerOccupyStateType(mySuperiorLeagueId)
    if mySuperiorLeagueId ~= 0 then
        return PlayerOccupyStateType.Occupy
    else
        return PlayerOccupyStateType.NoOccupy
    end
end

-- 获取地块所属玩家类型
function UnitClickPanelType:GetTiledOwnerType(myId, tiledOwnerId)
    if tiledOwnerId == 0 then
        return TiledOwnerType.NoOwner
    elseif myId == tiledOwnerId then
        return TiledOwnerType.My
    elseif tiledOwnerId ~= 0 and  tiledOwnerId ~= myId then
        return TiledOwnerType.Other
    else
        return TiledOwnerType.None
    end
end

-- 获取地块同盟类型
function UnitClickPanelType:GetTiledAlliesType(myId, tiledOwnerId, myLeagueId, mySuperiorLeagueId, tiledLeagueId)
    if tiledLeagueId == 0 then
        return TiledAlliesType.NoLeague
    elseif myId ~= tiledOwnerId and myLeagueId == tiledLeagueId then
        return TiledAlliesType.MyLeague
    elseif tiledLeagueId ~= -1 and myLeagueId ~= tiledLeagueId and mySuperiorLeagueId ~= tiledLeagueId and PlayerService:Instance():GetLeagueRelation(tiledLeagueId) ~= 1 and PlayerService:Instance():GetLeagueRelation(tiledLeagueId) ~= 2 then
        return TiledAlliesType.OtherLeague
    elseif mySuperiorLeagueId == tiledLeagueId then
        return TiledAlliesType.SuperLeague
    elseif myLeagueId ~= tiledLeagueId and PlayerService:Instance():GetLeagueRelation(tiledLeagueId) == 1 then
        return TiledAlliesType.FriendLeague
    elseif myLeagueId ~= tiledLeagueId and PlayerService:Instance():GetLeagueRelation(tiledLeagueId) == 2 then
        return TiledAlliesType.ArmyLeague
    else
        return TiledAlliesType.NoLeague
    end
end

-- 获取地块上级盟类型
function UnitClickPanelType:GetTiledSuperAlliesType(myLeagueId, tiledSuperLeagueId)
    if tiledSuperLeagueId == 0 then
        return TiledSuperAlliesType.NoSuperLeague
    elseif tiledSuperLeagueId == myLeagueId then
        return TiledSuperAlliesType.MyLeague
    elseif tiledSuperLeagueId ~= myLeagueId then
        return TiledSuperAlliesType.OtherLeague
    else
        return TiledSuperAlliesType.None
    end
end

-- 获取地块类型
function UnitClickPanelType:TiledType(tiled)
    if tiled:GetBuilding() == nil and tiled:GetTown() == nil and tiled:GetFortStete() == false and tiled._childBoat == nil then
        return TiledType.Resource
    elseif tiled:GetBuilding() ~= nil and tiled:GetBuilding()._dataInfo.Type == BuildingType.PlayerFort and tiled:GetBuilding()._buildSuccessTime < PlayerService:Instance():GetLocalTime() then
        return TiledType.FortAndCamp
    elseif tiled:GetTown() ~= nil and tiled:GetTown()._building._dataInfo.Type == BuildingType.WildBuilding then
        return TiledType.LowerWharf
    elseif tiled:GetBuilding() ~= nil and tiled:GetBuilding()._dataInfo.Type == BuildingType.Boat then
        return TiledType.LowerWharf
    elseif tiled:GetBuilding() ~= nil and tiled:GetBuilding()._dataInfo.Type == BuildingType.LevelBoat then
        return TiledType.WildCityCenterAndPass
    elseif tiled._childBoat ~= nil and tiled._childBoat._building ~= nil and tiled._childBoat._building._dataInfo.Type == BuildingType.LevelBoat then
        -- print("这里是关卡码头的子码头")
        return TiledType.WildCityCenterAndPass
    elseif tiled:GetBuilding() ~= nil and tiled:GetBuilding()._dataInfo.Type == BuildingType.WildGarrisonBuilding then
        return TiledType.FortAndCamp
    elseif tiled._childBoat ~= nil and tiled._childBoat._building ~= nil and tiled._childBoat._building._dataInfo.Type == BuildingType.Boat then
        return TiledType.LowerWharf
    elseif tiled:GetBuilding() ~= nil and tiled:GetBuilding()._buildSuccessTime > PlayerService:Instance():GetLocalTime() then
        return TiledType.LowerWharf
    elseif tiled:GetBuilding() ~= nil and tiled:GetBuilding()._dataInfo.Type == BuildingType.WildBuilding then
        return TiledType.WildCityCenterAndPass
    elseif tiled:GetBuilding() ~= nil and tiled:GetBuilding()._dataInfo.Type == BuildingType.LevelShiYi then
        return TiledType.WildCityCenterAndPass
    elseif tiled:GetBuilding() ~= nil and tiled:GetBuilding()._dataInfo.Type == BuildingType.WildFort then
        return TiledType.FortAndCamp
    elseif tiled:GetBuilding() ~= nil and tiled:GetBuilding()._dataInfo.Type == BuildingType.MainCity then
        return TiledType.MainCityCenter
    elseif tiled:GetBuilding() ~= nil and tiled:GetBuilding()._dataInfo.Type == BuildingType.SubCity then
        return TiledType.SubCityCenter
    elseif tiled:GetTown() ~= nil and tiled:GetTown()._building._dataInfo.Type == BuildingType.MainCity then
        return TiledType.PlayerCityTown
    elseif tiled:GetTown() ~= nil and tiled:GetTown()._building._dataInfo.Type == BuildingType.SubCity then
        return TiledType.PlayerCityTown
    elseif tiled:GetFortStete() == true then
        return TiledType.LowerWharf
    end
end

-- 获取按钮列表
function UnitClickPanelType:GetButtonList(playerAlliesStateType, playerOccupyStateType, tiledOwnerType, tiledAlliesType, tiledSuperAlliesType, tiledType)
    local map = self._clickPanelMap[playerAlliesStateType][playerOccupyStateType][tiledOwnerType][tiledAlliesType][tiledSuperAlliesType][tiledType][1]
    local buttons = map.button
    return buttons
end

-- 获取地块颜色
function UnitClickPanelType:GetTiledType(playerAlliesStateType, playerOccupyStateType, tiledOwnerType, tiledAlliesType, tiledSuperAlliesType, tiledType)
    local map = self._clickPanelMap[playerAlliesStateType][playerOccupyStateType][tiledOwnerType][tiledAlliesType][tiledSuperAlliesType][tiledType][1]
    local color = map.color
    return color
end

return UnitClickPanelType