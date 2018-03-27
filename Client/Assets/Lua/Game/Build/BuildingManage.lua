-- 建筑物的管理类
local GamePart = require("FrameWork/Game/GamePart")

local DataBuilding = require("Game/Table/model/DataBuilding")

local BuildingType = require("Game/Build/BuildingType")

local Town = require("Game/Build/Subject/Town")

-- local MapService = require("Game/Map/MapService")

local WildBuilding = require("Game/Build/Subject/WildBuilding")

local MainCity = require("Game/Build/Subject/MainCity")

local SubCity = require("Game/Build/Subject/SubCity")

local Boat = require("Game/Build/Subject/Boat")

local ChildBoat = require("Game/Build/Subject/ChildBoat")

local LevelBoat = require("Game/Build/Subject/LevelBoat")

local LevelShiYi = require("Game/Build/Subject/LevelShiYi")

local WildGarrisonBuilding = require("Game/Build/Subject/WildGarrisonBuilding")

local WildFort = require("Game/Build/Subject/WildFort")

local PlayerFort = require("Game/Build/Subject/PlayerFort")

local Town = require("Game/Build/Subject/Town")

local BoatOrientationEnum = require("Game/Build/Subject/BoatOrientationEnum")

local BuildingManage = class("BuildingManage", GamePart)

local VariationCalc = require("Game/Util/VariationCalc")

local BuildCurrency = require("Game/Build/Subject/BuildCurrency")

local LoadResourcesPrefab = require("Game/Util/LoadResourcesPrefab")

-- 构造函数
function BuildingManage:ctor()
    BuildingManage.super.ctor(self);
    -- 所有的建筑物
    self._allBuildingMap = { };
    -- 用建筑物格子上
    self._allBuildingInTiledMap = { };
    -- 用建筑物格子上
    self._allTownInTiledMap = { };

    -- 所有子码头
    self._allChildBoatMap = {}

    -- 所有的建筑物对象
    self._buildingClassMap = { };

    self._allCurrencyMap = { };
    -- -- 所有的要塞
    -- self._playerfortMap = {}
    self._allFortMap = { }

    self.count = nil;
    -- 要塞图片加载
    self._fortLoadResourcesPrefab = LoadResourcesPrefab.new()

    self._requestTimerTable = { }

    -- 在建中要塞对象
    self._onBuildingFortObjectMap = { }

    -- self.UIFortRedStartObject = nil;
    -- 要塞红点
    self._fortRedpointObjectMap = { }

    self._fortRedPointLoadResourcesPrefab = LoadResourcesPrefab.new()

    -- 被占领的野城
    self._beOwnedWildCityList = nil;

    self._createFortTimeLoadResourcesPrefab = LoadResourcesPrefab.new()

    self._createFortTimeObjMap = { }
    self._requestCreateTimerTable = { }

    -- 要塞特效
    self._fortEffectMap = {}

end
-- 被占领的野城
function BuildingManage:SetBeOwnedWildCityList(list)
    self._beOwnedWildCityList = list
end
function BuildingManage:GetBeOwnedWildCityList()
    return self._beOwnedWildCityList
end


-- 初始化
function BuildingManage:_OnInit()
    self:RegisterAllBuildingClassMap()
    for k, v in pairs(BuildCurrency) do
        self:AddCurrency(v, VariationCalc.new())
    end
end

function BuildingManage:AddCurrency(currencyEnum, varCalc)
    if currencyEnum == BuildCurrency.None then
        return;
    end
    self._allCurrencyMap[currencyEnum] = varCalc
end

-- 获取varCalc
function BuildingManage:GetCurrencyVarCalcByKey(currencyEnum)
    return self._allCurrencyMap[currencyEnum]
end

-- 注册所有的类
function BuildingManage:RegisterAllBuildingClassMap()
    self:_RegisterBuildingClassMap(BuildingType.MainCity, MainCity);
    self:_RegisterBuildingClassMap(BuildingType.SubCity, SubCity)
    self:_RegisterBuildingClassMap(BuildingType.Boat, Boat);
    self:_RegisterBuildingClassMap(BuildingType.LevelBoat, LevelBoat);
    self:_RegisterBuildingClassMap(BuildingType.LevelShiYi, LevelShiYi);
    self:_RegisterBuildingClassMap(BuildingType.WildGarrisonBuilding, WildGarrisonBuilding);
    self:_RegisterBuildingClassMap(BuildingType.WildFort, WildFort);
    self:_RegisterBuildingClassMap(BuildingType.PlayerFort, PlayerFort);
    self:_RegisterBuildingClassMap(BuildingType.WildBuilding, WildBuilding);

end

-- 注册建筑物
function BuildingManage:_RegisterBuildingClassMap(buildingType, buildingClass)
    for k, v in pairs(self._buildingClassMap) do
        if v == buildingType then
            return
        end
    end
    self._buildingClassMap[buildingType] = buildingClass;
end

-- 清空所有的建筑物
function BuildingManage:ClearAllBuilding()
    self._allBuildingMap = { };
    self._allBuildingInTiledMap = { };
end

-- 根据类型创建建筑物
function BuildingManage:_CreateBuildingByType(buildingType)
    if self._buildingClassMap[buildingType] == nil then
        return nil;
    end

    local building = self._buildingClassMap[buildingType].new();
    if building == nil then
        return nil
    end
    return building
end

-- 彻底删除一个building
function BuildingManage:DeletePlayerBuilding(building)
    if building == nil then
        return;
    end
    building:RemoveRedifTimer();
    self:DeleteBuildingTown(building);
    self:_DeleteBuilding(building._id);
    self:_DeleteBuildingTiled(building._tiledId);
    building = nil;
end

-- 删除一个building
function BuildingManage:_DeleteBuilding(id)
    self._allBuildingMap[id] = nil
end

function BuildingManage:_DeleteBuildingTiled(tiledId)
    self._allBuildingInTiledMap[tiledId + 1] = nil;
end

-- 获取建筑物
function BuildingManage:_GetBuilding(id)
    -- ----------print(#self._allBuildingMap)
    return self._allBuildingMap[id]
end

function BuildingManage:_GetBuildingCount()
    return #self._allBuildingMap
end

function BuildingManage:DeleteBuildingTown(building)
    if building == nil then
        return;
    end
    local townCount = building:GetTownCount()
    for i = 1, townCount do
        local town = building:GetTown(i)
        if town ~= nil then
            self._allTownInTiledMap[town._index] = nil;
        end
    end
end

-- 获取
function BuildingManage:_GetTown(index)
    return self._allTownInTiledMap[index];
end

-- 获取子码头
function BuildingManage:_GetChildBoat(index)
    return self._allChildBoatMap[index]
end

-- 根据格子的索引获取建筑物
function BuildingManage:GetBuildingByTiledId(tiledId)
    if tiledId == nil then
        return nil;
    end
    if tiledId == 2177626 then
    end
    return self._allBuildingInTiledMap[tiledId + 1];
end

-- 创建一个建筑物
function BuildingManage:_CreateBuilding(id, index, owner, tableId)
    local data = DataBuilding.tableId
    if data == nil then
        return nil
    end
    local building = self:_CreateBuildingByType(data.Type)
    if building == nil then
        return nil
    end
    building._dataInfo = data
    -- building._id = id
    building:SetId(id);
    building._tableId = tableId
    -- --------print(building._tableId .. "+++++++++++++++++++++++++++++++++++")
    building._dataInfo = DataBuilding[tableId];
    building._owner = owner
    building._tiledId = index
    building._state = data.State
    self:_InsertBuilding(building)

    return building
end

-- 设置建筑物耐久
function BuildingManage:SetBuildingDurabilityCost(id, owner, durabilityCost, durabilityCostTime)
    self:_SetBuildingDurabilityCost(self:_GetBuilding(id), owner, durabilityCost, durabilityCostTime)
end

-- 设置建筑物耐久
function BuildingManage:_SetBuildingDurabilityCost(building, owner, durabilityCost, durabilityCostTime)
    if building == nil then
        return
    end
    building._owner = owner
    building._durabilityCost = durabilityCost
    building._durabilityRecoveryTime = durabilityCostTime
end

-- 创建野城
function BuildingManage:CreateWildBuilding(index, tableId)
    local data = DataBuilding[tableId]
    if data == nil then
        return nil
    end
    local building = self:_CreateBuildingByType(data.Type)
    if building == nil then
        return nil
    end
    building._dataInfo = data
    building:SetId(index)
    building._tableId = tableId
    building._owner = 0
    building._tiledId = index
    building._state = data.State
    self:_InsertBuilding(building)
    -- print("创建建筑物")
    if data.Type == BuildingType.Boat or data.Type == BuildingType.LevelBoat then
        -- print("创建子码头")
        self:_CreateChildBoat(building)
    else
        self:_CreateTown(building)
    end
    return building
end

-- 创建子码头
function BuildingManage:_CreateChildBoat(building)
    -- print("有没有建子码头")
    if building == nil or building._dataInfo == nil then
        return
    end
    local data = building._dataInfo
    local orientation = data.Orientation
    local childBoatIndex = self:_GetChildBoatIndex(building._tiledId, orientation)
    if childBoatIndex == 0 then
        -- print("子码头索引为0")
        return
    end
    local childBoat = ChildBoat.new()
    childBoat:Init(building, childBoatIndex)
    building._childBoat = childBoat
    self._allChildBoatMap[childBoatIndex] = childBoat
end

-- 获取子码头索引
function BuildingManage:_GetChildBoatIndex(index, orientation)
    -- print("码头朝向 == " .. orientation)
    local centerX, centerY = MapService:Instance():GetTiledCoordinate(index)
    if orientation == BoatOrientationEnum.XPlus1 then
        centerX = centerX + 1
    elseif orientation == BoatOrientationEnum.XSub1 then
        centerX = centerX - 1
    elseif orientation == BoatOrientationEnum.YPlus1 then
        centerY = centerY + 1
    elseif orientation == BoatOrientationEnum.YSub1 then
        centerY = centerY - 1
    else
        return 0
    end
    -- print("子码头坐标 X == " .. centerX .. "--------------Y == " .. centerY)
    local childBoatIndex = MapService:Instance():GetTiledIndex(centerX, centerY)
    return childBoatIndex
end

-- 创建城区
function BuildingManage:_CreateTown(building)
    if building == nil or building._dataInfo == nil then
        return
    end
    local centerX, centerY = MapService:Instance():GetTiledCoordinate(building._tiledId)
    local circleCount = building._dataInfo.State
    local startX = centerX - circleCount
    local startY = centerY - circleCount
    local endX = centerX + circleCount
    local endY = centerY + circleCount
    for i = startX, endX do
        for j = startY, endY do
            while true do
                if i == centerX and j == centerY then
                    break
                end
                self:_SetTown(building, i, j)
                break
            end
        end
    end
end

-- 创建城区
function BuildingManage:_SetTown(building, x, y)
    local town = Town.new();
    town._buildingId = building._id;
    town._building = building;
    town._ownerId = building._owner;
    town._index = MapService:Instance():GetTiledIndex(x, y);
    building:AddTown(town);
    self._allTownInTiledMap[town._index] = town;
end

-- 插入建筑物
function BuildingManage:_InsertBuilding(building)
    if building == nil then
        return
    end

    for k, v in pairs(self._allBuildingMap) do
        if k == building._id then
            return
        end
    end

    -- table.insert(self._allBuildingMap, building._id, building)
    self._allBuildingMap[building._id] = building

    self._allBuildingInTiledMap[building._tiledId + 1] = building;
    ------------print(building._tiledId + 1)
    ------------print(self._allBuildingInTiledMap[2177627])
end


function BuildingManage:_LookBuildingMap(buildigId)
    -- body
    for k, v in pairs(self._allBuildingMap) do
        if k == buildigId then
            --------print(v)
        end
    end
end

-- 创建玩家建筑物
function BuildingManage:CreatePlayerBuilding(id, owner, index, tableId, name, successTime, deleteTime)
    local data = DataBuilding[tableId]
    if data == nil then
    end
    if data == nil then
        return nil
    end
    local building = self:_CreateBuildingByType(data.Type)
    if building == nil then
        return nil;
    end
    building._dataInfo = data
    building:SetId(id);
    building._tableId = tableId
    building._owner = owner
    building._name = name
    building._tiledId = index
    building._state = data.State
    building._subCitySuccessTime = successTime;
    building._subCityDeleteTime = deleteTime;
    self:_InsertBuilding(building);
    self:_CreateTown(building);
    return building
end

-- 创建玩家要塞建筑物
function BuildingManage:CreatePlayerFortBuilding(id, owner, index, tableId, name, fortLevel)
    ------------print(tableId)
    local data = DataBuilding[tableId]
    ------------print(data)
    if data == nil then
        return nil
    end
    local building = self:_CreateBuildingByType(data.Type)
    if building == nil then
        return nil
    end
    building._dataInfo = data
    -- building._id = id
    building:SetId(id);
    building._tableId = tableId
    building._owner = owner
    building._name = name
    building._tiledId = index
    building._fortGrade = fortLevel
    building._state = data.State
    self:_InsertBuilding(building)

    return building
end

-- 迁城
function BuildingManage:MoveMainCity(building, index)
    self._allBuildingInTiledMap[building._tiledId + 1] = nil;
    PlayerService:Instance():SetMainCityTiledId(index);
    building._tiledId = index;
    self._allBuildingInTiledMap[index + 1] = building;
    MapService:Instance():ScanTiled(index);
end

-- 创建地图要塞
function BuildingManage:_BuildFort(index, completeTime, name, building)
    local parent = MapService:Instance():GetLayerParent(LayerType.Building);
    local buildingId = building._id
    local uiFortObject = self._onBuildingFortObjectMap[buildingId]
    if uiFortObject ~= nil then
        return
    else
        self._fortLoadResourcesPrefab:SetResPath("Map/Fortress")
        self._fortLoadResourcesPrefab:Load(parent, function(UIFortObject)
            self._onBuildingFortObjectMap[buildingId] = UIFortObject
            PlayerService:Instance():InsertFortMap(index, UIFortObject)
            self:_OnShowFort(UIFortObject, parent, index, completeTime, name, buildingId)
        end, "building"..tostring(buildingId))
        self:FortEffects(parent,index,buildingId)
    end
end

function BuildingManage:HideBuildForImage(buildingId)
    self._fortLoadResourcesPrefab:Recovery(self._onBuildingFortObjectMap[buildingId]);
    self._onBuildingFortObjectMap[buildingId] = nil;
    if buildingId ~= nil then
        self:DeleteFortEffects(buildingId);
    end
end

function BuildingManage:BuildFort(index, completeTime, name, buildingId)
    local building = BuildingService:Instance():GetBuilding(buildingId)
    if building ~= nil then
        self:_BuildFort(index, completeTime, name, building)
    end
end
-- 增加要塞特效
function BuildingManage:FortEffects(parent,index,buildingId)
    if self._fortEffectMap[buildingId] == nil then
        local x, y = MapService:Instance():GetTiledCoordinate(index);
        local position = MapService:Instance():GetTiledPosition(x, y);
        local effect = EffectsService:Instance():AddEffect(parent, EffectsType.BuiltEffect, 2, nil, position)
        self._fortEffectMap[buildingId] = effect
    end
end
-- print("移除要塞特效")
function BuildingManage:DeleteFortEffects(buildingId)
    if self._fortEffectMap[buildingId] ~= nil then
        EffectsService:Instance():RemoveEffect(self._fortEffectMap[buildingId])
        self._fortEffectMap[buildingId] = nil
    end
end

-- 显示要塞图片
function BuildingManage:_OnShowFort(UIFortObject, parent, index, endTime, name, buildingId)
    local x, y = MapService:Instance():GetTiledCoordinate(index);
    UIFortObject.name = string.format("%d", index);
    MapService:Instance():BuildingSort(UIFortObject.transform, parent.transform);
    UIFortObject.transform.localPosition = MapService:Instance():GetTiledPosition(x, y);
    UIFortObject.transform.localScale = Vector3.one;
    local ownerId = 0
    local building = BuildingService:Instance():GetBuilding(buildingId)
    if building ~= nil then
        ownerId = building._owner
    end
    self:_OnShowFortView(UIFortObject, parent, index, endTime, ownerId, name, buildingId)
end

-- 显示建造中要塞界面
function BuildingManage:_OnShowFortView(UIFortObject, parent, index, endTime, ownerId, name, buildingId)
    UIFortObject.gameObject:SetActive(true);
    local myId = PlayerService:Instance():GetPlayerId();
    self:ShowCreateFortCountdown(index, endTime, buildingId,1);
end

-- 创建要塞时间Box
function BuildingManage:ShowCreateFortCountdown(index, createTime, buildingId,text)
    local parent = MapService:Instance():GetLayerParent(LayerType.UI);
    if self._createFortTimeObjMap[index] ~= nil then
        return
    else
        self._createFortTimeLoadResourcesPrefab:SetResPath("Map/TimeObjs")
        self._createFortTimeLoadResourcesPrefab:Load(parent, function(UICreateFortTimeObject)
            PlayerService:Instance():InsertFortMap(index, UICreateFortTimeObject)
            self._createFortTimeObjMap[index] = UICreateFortTimeObject
            self:_OnShowCreateTime(UICreateFortTimeObject, index, createTime, buildingId,text)
        end,"time"..tostring(createTime))
    end
end

function BuildingManage:_OnShowCreateTime(UICreateFortTimeObject, index, createTime, buildingId, text)
    local time = 0; -- 创建或放弃所需时间
    local x, y = MapService:Instance():GetTiledCoordinate(index)
    local position = MapService:Instance():GetTiledPosition(x,y);
    UICreateFortTimeObject.transform.localPosition = Vector3.New(position.x,position.y-80,0);
    UICreateFortTimeObject.transform.localScale = Vector3.one;
    self.TimeText = UICreateFortTimeObject.transform:FindChild("TimeText").gameObject:GetComponent(typeof(UnityEngine.UI.Text));
    self.slider = UICreateFortTimeObject.transform:FindChild("Slider").gameObject:GetComponent(typeof(UnityEngine.UI.Slider));
    self.Text = UICreateFortTimeObject.transform:FindChild("ImageBg/Text").gameObject:GetComponent(typeof(UnityEngine.UI.Text));

    local building = BuildingService:Instance():GetBuilding(buildingId)
    if building == nil then
        return
    end
    if text == 1 then
        self.Text.text = "建"
        time = building.createTime
    else
        self.Text.text = "拆"
        time = building.removeTime
    end
    local myId = PlayerService:Instance():GetPlayerId();
    local owner = building._owner;
    if myId == owner then
        UICreateFortTimeObject.gameObject:SetActive(true)
        self.TimeText.gameObject:SetActive(true)
    else
        UICreateFortTimeObject.gameObject:SetActive(false)  
        self.TimeText.gameObject:SetActive(false);
    end
    local curServerTime = PlayerService:Instance():GetLocalTime();
    local needTime = createTime - curServerTime;
    self.slider.value =(needTime - curServerTime) / time;
    CommonService:Instance():TimeDown(nil,createTime,self.TimeText, function() self:recoveryTimeBox(UICreateFortTimeObject, index) end, self.slider, time);
end

function BuildingManage:recoveryTimeBox(UICreateFortTimeObject, index)
    UICreateFortTimeObject.gameObject:SetActive(false);
    self._createFortTimeLoadResourcesPrefab:Recovery(self._createFortTimeObjMap[index]);
    self._createFortTimeObjMap[index] = nil;
end

function BuildingManage:ClickQuitTimeBox(index)
    if self._createFortTimeObjMap[index] ~= nil then
        self._createFortTimeLoadResourcesPrefab:Recovery(self._createFortTimeObjMap[index]);
        self._createFortTimeObjMap[index] = nil;
    end
end

function BuildingManage:showFortArmyCount(index, buildingid, fortArmyCount)
    -- local tiled = MapService:Instance():GetTiledByIndex(index);
    local parent = MapService:Instance():GetLayerParent(LayerType.UI);
    self._fortRedPointLoadResourcesPrefab:SetResPath("Map/FortRedStart")
    self._fortRedPointLoadResourcesPrefab:Load(parent, function(UIFortRedStartObject)
        PlayerService:Instance():InsertFortMap(index, UIFortRedStartObject)
        -- self.UIFortRedStartObject = UIFortRedStartObject
        self._fortRedpointObjectMap[index] = UIFortRedStartObject
        self:_OnShowFortRed(UIFortRedStartObject, index, buildingid, fortArmyCount)
    end,"red"..tostring(buildingId))
end

-- 隐藏部队红点
function BuildingManage:HideFortArmyCount(index)
    self._fortRedPointLoadResourcesPrefab:Recovery(self._fortRedpointObjectMap[index]);
    self._fortRedpointObjectMap[index] = nil;
end

-- 显示要塞红点图片
function BuildingManage:_OnShowFortRed(UIFortRedStartObject, index, buildingId, fortArmyCount)
    -- if tiled == nil then
    -- 	return
    -- end
    -- tiled:SetTiledImage(LayerType.Building, UIFortRedStartObject.transform);
    local x, y = MapService:Instance():GetTiledCoordinate(index)
    local position = MapService:Instance():GetTiledPosition(x,y);
    local building = BuildingService:Instance():GetBuilding(buildingId)
    if building == nil then
        return
    end
    if building._dataInfo.Type == BuildingType.PlayerFort then
        UIFortRedStartObject.transform.localPosition = MapService:Instance():GetTiledPositionFortRedStart(x, y);
    elseif building._dataInfo.Type == BuildingType.WildFort  then
        UIFortRedStartObject.transform.localPosition = MapService:Instance():GetTiledPositionWildFortRedStart(x, y);
    elseif building._dataInfo.Type == BuildingType.WildGarrisonBuilding then
        UIFortRedStartObject.transform.localPosition = Vector3.New(position.x - 60,position.y + 85,0);
    end
    UIFortRedStartObject.transform.localScale = Vector3.New(1.52,1.52,1.52);
    UIFortRedStartObject.transform:SetAsLastSibling()
    self.count = UIFortRedStartObject.transform:FindChild("CountText").gameObject:GetComponent(typeof(UnityEngine.UI.Text));
    local myId = PlayerService:Instance():GetPlayerId();
    local owner = building._owner;

    if myId == owner then
        self.count.text = fortArmyCount;
        self.count.gameObject:SetActive(true);
        UIFortRedStartObject.transform.sizeDelta = Vector2.New(42,42);
    else
        self.count.gameObject:SetActive(false);
        UIFortRedStartObject.transform.sizeDelta = Vector2.New(24,24);
    end
end

function BuildingManage:IsArmy(buildingId, tiledIndex, fortArmyCount)
    self.count = nil;
    if fortArmyCount ~= 0 then
        local UIFortRedStartObject = self._fortRedpointObjectMap[tiledIndex]
        --------print(UIFortRedStartObject)
        if UIFortRedStartObject ~= nil then
            self:_OnShowFortRed(UIFortRedStartObject, tiledIndex, buildingId, fortArmyCount)
        else
            self:showFortArmyCount(tiledIndex, buildingId, fortArmyCount)
        end
    end
end

function BuildingManage:deleteFortTimer(index, deleteTime)
    local UIFortObject = PlayerService:Instance():GetFortMap(index);
    if UIFortObject ~= nil then
        local deleteFortTime = UIFortObject.transform:FindChild("fortressName/deleteTime").gameObject:GetComponent(typeof(UnityEngine.UI.Text));
        local downTime = deleteTime - os.time() * 1000;
        CommonService:Instance():TimeDown(nil,deleteTime, deleteFortTime, curTimer, function() self:HidedeleteBox(deleteFortTime) end);
    end
end

-- 请求被占领的野城的信息
function BuildingManage:SendGetOccWildBuildingMessage()
    local msg = require("MessageCommon/Msg/C2L/Building/RequestOccupyWildCity").new();
    msg:SetMessageId(C2L_Building.RequestOccupyWildCity)
    NetService:Instance():SendMessage(msg)
end

return BuildingManage


