--[[
	通用DataTileStateShow解析
--]]
local DataTileStateShow = require("Game/Table/model/DataTileStateShow")
local TileStateType = class("TileStateType")


-- 构造函数
function TileStateType:ctor()
    self._stateMap = {}
    self:Init()
end

-- 初始化
function TileStateType:Init()
    local count = #DataTileStateShow
    for index = 1, count do
        local record = DataTileStateShow[index]
        self:InsertRecord(record)
    end
end

-- 插入一行记录
function TileStateType:InsertRecord(record)
    if record == nil then
        return
    end
    local avoidWarMap = self._stateMap[record.AvoidWar]
    if avoidWarMap == nil then
        avoidWarMap = self:CreateAvoidWarMap(record.AvoidWar)
    end
    self:InsertGarrisonCenterType(record, avoidWarMap)
end

-- 创建免战状态
function TileStateType:CreateAvoidWarMap(avoidWarType)
    local map = {}
    self._stateMap[avoidWarType] = map
    return map
end

-- 插入是否驻守中心
function TileStateType:InsertGarrisonCenterType(record, avoidWarMap)
    if record == nil or avoidWarMap == nil then
        return
    end
    local garrisonCenterMap = avoidWarMap[record.GarrisonCentre]
    if garrisonCenterMap == nil then
        garrisonCenterMap = self:CreateGarrisonCenterMap(record.GarrisonCentre, avoidWarMap)
    end
    self:InsertGarrisonType(record, garrisonCenterMap)
end

-- 创建驻守中心状态
function TileStateType:CreateGarrisonCenterMap(garrisonCenterType, avoidWarMap)
    local map = {}
    avoidWarMap[garrisonCenterType] = map
    return map
end

-- 插入驻守中心
function TileStateType:InsertGarrisonType(record, garrisonCenterMap)
    if record == nil or garrisonCenterMap == nil then
        return
    end
    local garrisonMap = garrisonCenterMap[record.Garrison]
    if garrisonMap == nil then
        garrisonMap = self:CreateGarrisonMap(record.Garrison, garrisonCenterMap)
    end
    self:InsertMitaCenterType(record, garrisonMap)
end

-- 创建驻守周边状态
function TileStateType:CreateGarrisonMap(garrisonType, garrisonCenterMap)
    local map = {}
    garrisonCenterMap[garrisonType] = map
    return map
end

-- 插入屯田中心
function TileStateType:InsertMitaCenterType(record, garrisonMap)
    if record == nil or garrisonMap == nil then
        return
    end
    local mitaCenterMap = garrisonMap[record.GrowfoodCentre]
    if mitaCenterMap == nil then
        mitaCenterMap = self:CreateMitaCenterMap(record.GrowfoodCentre, garrisonMap)
    end
    self:InsertMitaType(record, mitaCenterMap)
end

-- 创建屯田中心状态
function TileStateType:CreateMitaCenterMap(mitaCenterType, garrisonMap)
    local map = {}
    garrisonMap[mitaCenterType] = map
    return map
end

-- 插入屯田类型
function TileStateType:InsertMitaType(record, mitaCenterMap)
    if record == nil or mitaCenterMap == nil then
        return
    end
    local mitaMap = mitaCenterMap[record.Growfood]
    if mitaMap == nil then
        mitaMap = self:CreateMitaMap(record.Growfood, mitaCenterMap)
    end
    self:InsertTrainingType(record, mitaMap)
end

-- 创建屯田状态
function TileStateType:CreateMitaMap(mitaType, mitaCenterMap)
    local map = {}
    mitaCenterMap[mitaType] = map
    return map
end

-- 插入练兵类型
function TileStateType:InsertTrainingType(record, mitaMap)
    if record == nil or mitaMap == nil then
        return
    end
    local trainingMap = mitaMap[record.Training]
    if trainingMap == nil then
        trainingMap = self:CreateTrainingMap(record.Training, mitaMap)
    end
    self:InsertBuildingType(record, trainingMap)
end

-- 创建练兵状态
function TileStateType:CreateTrainingMap(trainingType, mitaMap)
    local map = {}
    mitaMap[trainingType] = map
    return map
end

-- 插入建筑物类型
function TileStateType:InsertBuildingType(record, trainingMap)
    if record == nil or trainingMap == nil then
        return
    end
    local buildingMap = trainingMap[record.Buliding]
    if buildingMap == nil then
        buildingMap = self:CreateBuildingMap(record.Buliding, trainingMap)
    end
    self:InsertFortType(record, buildingMap)
end

-- 创建建筑物状态
function TileStateType:CreateBuildingMap(buildingType, trainingMap)
    local map = {}
    trainingMap[buildingType] = map
    return map
end

-- 插入要塞类型
function TileStateType:InsertFortType(record, buildingMap)
    if record == nil or buildingMap == nil then
        return
    end
    local fortMap = buildingMap[record.fort]
    if fortMap == nil then
        fortMap = self:CreateFortMap(record.fort, buildingMap)
    end
    self:InsertShowType(record, fortMap)
end

-- 创建要塞类型状态
function TileStateType:CreateFortMap(fortType, buildingMap)
    local map = {}
    buildingMap[fortType] = map
    return map
end

-- 插入显示类型
function TileStateType:InsertShowType(record, fortMap)
    if record == nil or fortMap == nil then
        return
    end
    local map = {}
    map.haveView = record.Showtype
    map.haveNoView = record.NoVisionShowtype
    table.insert(fortMap, map)
end

-- 获取地块免战状态
function TileStateType:GetAvoidWarState(tiled)
    if tiled == nil or tiled.tiledInfo == nil then
        return 2
    end
    if tiled.tiledInfo.avoidWarTime >= PlayerService:Instance():GetLocalTime() then
        return 1
    end
    return 2
end

-- 获取驻守中心状态
function TileStateType:GetGarrisonCenterState(tiled)
    if tiled == nil or tiled.tiledInfo == nil then
        return 2
    end
    local count = tiled.tiledInfo.allGarrisonArmyInfoList:Count()
    for i = 1, count do
        local army = tiled.tiledInfo.allGarrisonArmyInfoList:Get(i)
        if army == nil then
            return 2
        end
        if army.tiledId == tiled._index then
            return 1
        end
    end
    return 2
end

-- 获取驻守周边状态
function TileStateType:GetGarrisonOuterState(tiled)
    if tiled == nil or tiled.tiledInfo == nil then
        return 2
    end
    local count = tiled.tiledInfo.allGarrisonArmyInfoList:Count()
    for i = 1, count do
        local army = tiled.tiledInfo.allGarrisonArmyInfoList:Get(i)
        if army == nil then
            return 2
        end
        if army.tiledId ~= tiled._index then
            return 1
        end
    end
    return 2
end

-- 获取屯田中心状态
function TileStateType:GetMitaCenterState(tiled)
    if tiled == nil or tiled.tiledInfo == nil then
        return 2
    end
    local count = tiled.tiledInfo.allMitaingArmyInfoList:Count()
    for i = 1, count do
        local army = tiled.tiledInfo.allMitaingArmyInfoList:Get(i)
        if army == nil then
            return 2
        end
        if army.tiledId == tiled._index then
            return 1
        end
    end
    return 2
end

-- 获取屯田周边状态
function TileStateType:GetMitaOuterState(tiled)
    if tiled == nil or tiled.tiledInfo == nil then
        return 2
    end
    local count = tiled.tiledInfo.allMitaingArmyInfoList:Count()
    for i = 1, count do
        local army = tiled.tiledInfo.allMitaingArmyInfoList:Get(i)
        if army == nil then
            return 2
        end
        if army.tiledId ~= tiled._index then
            return 1
        end
    end
    return 2
end

-- 获取练兵状态
function TileStateType:GetTrainingState(tiled)
    if tiled == nil or tiled.tiledInfo == nil then
        return 2
    end
    if tiled.tiledInfo.allTrainingArmyInfoList:Count() > 0 then
        return 1
    end
    return 2
end

-- 获取建筑
function TileStateType:GetBuildingState(tiled)
    if tiled == nil then
        return 2
    end
    if tiled._building ~= nil or tiled._town ~= nil or tiled._childBoat ~= nil then
        return 1
    end
    return 2
end

-- 获取要塞类型
function TileStateType:GetFortState(tiled)
    if tiled == nil then
        return 2
    end
    if tiled._building == nil or tiled._building._dataInfo == nil then
        return 2
    end
    if tiled._building._dataInfo.Type == BuildingType.PlayerFort then
        return 1
    end
    if tiled._building._dataInfo.Type == BuildingType.WildFort then
        return 1
    end
    return 2
end

-- 获取地块类型字符串
function TileStateType:GetTileTypeString(avoid, garrisonCenter, garrisonOuter, mitaCenter, mitaOuter, training, building, fort)
    -- print(avoid .. "==" .. garrisonCenter .. "==" .. garrisonOuter .. "==" .. mitaCenter .. "==" .. mitaOuter .. "==" .. training .. "==" .. building .. "==" .. fort)
    local tiledTypeString = self._stateMap[avoid][garrisonCenter][garrisonOuter][mitaCenter][mitaOuter][training][building][fort][1]
    return tiledTypeString
end

return TileStateType