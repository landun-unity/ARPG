-- 格子管理
TiledManage = class("TiledManage")
local Tiled = require("Game/Map/Tiled")
local TiledDuration  = require("Game/Map/TiledDuration")
local TiledSprite = require("Game/Map/TiledSprite")
local Queue = require("common/Queue")
local MapLoad = require("Game/Map/MapLoad")
local LayerType = require("Game/Map/LayerType")
local FieldBuildingManage = require("Game/Build/Building/FieldBuildingManage")
local BuildingService = require("Game/Build/BuildingService")
local DataBuild = require("Game/Table/model/DataBuilding")
require("Game/Table/InitTable")
local City = require("Game/Build/Subject/City")
local MainCityManage = require("Game/Build/Building/MainCityManage")
local UnitWildBuildingManage = require("Game/Build/Building/UnitWildBuildingManage")
local MoutainManage = require("Game/Environment/MoutainManage")
--local RoadManage = require("Game/Environment/RoadManage")
--local UIMapNameService:Instance() = require("Game/MapMenu/UIMapNameService:Instance()")
require("Game/Map/PowerType")
local LoadResourcesPrefab = require("Game/Util/LoadResourcesPrefab")
local LoadResourcesPrefabWithCallBack = require("Game/Util/LoadResourcesPrefabWithCallBack")
local UnitClickPanelType = require("Game/Map/UnitClickPanelType")
local CurrencyEnum = require("Game/Player/CurrencyEnum")
local MaxLevelFacilityProperty = require("Game/Facility/MaxLevelFacilityProperty")
local DataGameConfig = require("Game/Table/model/DataGameConfig");
local DataShadow = require("Game/Table/model/DataShadow");
local CommonSliderType = require("Game/Common/CommonSliderType")
local EffectsType = require("Game/Effects/EffectsType")
local TileStateType = require("Game/Map/TileState/TileStateType")

-- 构造函数
function TiledManage:ctor( )
    -- 所有的格子
    self._allTiledList = {};
    -- 所有的精灵
    self._allSpriteList = {};
    -- 格子的父亲
    self._tiledParent = nil;
    -- 格子缓存
    self._cacheTiledQueue = Queue.new();
    -- 野城缓存
    --self._cacheBuildingQueue = Queue.new();
    -- 层
    self._allLayerMap = {};
    -- 所有层的缓存
    self.allLayerCacheMap = {};
    --野城管理
    self._wildBuildingManage = FieldBuildingManage.new();
    --玩家主城管理
    self._mainCityManage = MainCityManage.new();
    --玩家单格建筑
    self._unitWildBuildingManage = UnitWildBuildingManage.new();
    --山体
    self._moutainManage = MoutainManage.new();
    --山体
    --self._roadManage = RoadManage.new();

    --UIMapNameService:Instance() = UIMapNameService:Instance().new();
    -- 所有的建筑物
    self._allWildBuildingMap = {};

    self._drawLoadResourcesPrefab = LoadResourcesPrefab.new()

    self._DrawLoadResourcesPrefab = LoadResourcesPrefab.new()

    self._GarrisonRedLoadResourcesPrefab = LoadResourcesPrefab.new()

    self._gassionObjectMap = {}

    self._DrawObjectMap = {}

    self._subCityCreatingResourcesPrefab = LoadResourcesPrefab.new()
    self._subCityCreatingObjectMap = {}

    self._subCityCountDownResourcesPrefab = LoadResourcesPrefab.new()
    self._subCityCountDownObjectMap = {}

    self._subCityDeleteCountDownResourcesPrefab = LoadResourcesPrefab.new()
    self._subCityDeleteCountDownObjectMap = {}
    -- 地表下沉
    self._landOffset = 32;
    --边缘控制
    self._mapLimit = 1;

    --cityname
    self._cityNameMap = {}; 
    --资源个数
    self._resourcetimes = 0;
    -- 倒计时框
    self._timeBoxLoadResourcesPrefab = LoadResourcesPrefab.new()

    -- 倒计时框队列
    self._timeBoxObjectMap = {}

    -- 计时器
    self._timerMap = {}

   
    --放弃要塞倒计时框
    self._FortTimerBox = {}

    self._deleteFortTimeBox = LoadResourcesPrefab.new()

    self.downTimer = nil;

    self.curCommonSlider = {};              --倒计时slider(UICommonSlider) ,显示屯田、练兵、战平
    self.curArmyBehaviourTwoObj = {};       --格子上屯田、练兵图片（预制:ArmyBehaviourTwo）

    -- 部队战平特效map
    self._drawEffectMap = {}

    -- 创建分城特效
    self._CreateSubCityEffectMap = {}

    -- 驻守红点
    self.garrisonRed = {}

    -- 通用地块类型显示
    self._unitTileStateType = TileStateType.new()

    -- 格子显示状态map
    self._tiledStateMap = {}
    -- 格子状态显示加载
    self._tiledStatePrefab = LoadResourcesPrefab.new()

    -- 所有我拥有的格子耐久类列表
    self._allMyTiledDuraMap = {};
end

-- 初始化地图
function TiledManage:InitMap()
    --MapLoad:InitMap();
    ------------print("TiledManage:InitMap");
    self:_CreateAllSprite();
    self:_LoadAllWildBuilding();
    self._unitWildBuildingManage:_AllSprite();
    --self._mainCityManage:_AllSprite();
    --self:_creatAllWildBuilding();
    --self._CreatMainCity();
    --MapLoad:CloseMap();
end

function TiledManage:InitDurableVar(tiledInfo)
    local tiled = self:GetTiledByIndex(tiledInfo.tiledId)
    if tiled ~= nil then
        tiled:SetDurableVar(tiledInfo.curDurableVal, tiledInfo.maxDurableVal, 60000)
    end
end

-- 读取所有的building类
function TiledManage:_LoadAllWildBuilding()
    local count = MapLoad:GetBuildingCount();
    ------------print(count)
    for i= 1, count, 1 do
        local building = MapLoad:GetBuilding(i);

        local x = building.x;
        local y = building.y;
        local buildingId = building.tableId;
        if DataBuild[buildingId] ~= nil then
            local dataBuild = DataBuild[buildingId].State;
            local buildingIndex = self:GetBuildingIndex(y, x, dataBuild);
            BuildingService:Instance():CreateWildBuilding(buildingIndex, buildingId);
        end
    end
end

--Buidling坐标转化
function TiledManage:GetBuildingIndex(x, y, dataBuild)
    if dataBuild == 0 then
    end
    
    local realX = x * 2 / MapLoad._imageWidth - (dataBuild + 1);
    local realY = y * 2 / MapLoad._imageHeight - (dataBuild + 1);
    return self:GetTiledIndex(realX, realY);
end

function TiledManage:_CreatWildBuilding(tiled)
    if tiled:GetImageId(LayerType.WildFort) == 0 or tiled == nil then
        return;
    end
    print(tiled:GetImageId(LayerType.WildFort))
    local tileId = DataTileCut[tiled:GetImageId(LayerType.WildFort)].TileID;
    local buildingId = DataTile[tileId].BuildingID;
    local building = BuildingService:Instance():CreateWildBuilding(self:GetTiledIndex(tiled:GetX(), tiled:GetY()), buildingId);
    tiled:SetBuilding(building);
end


-- 根据索引获取格子
function TiledManage:GetTiledByIndex(index)
    -- if index < 0 or index >= MapLoad:GetWidth() * MapLoad:GetHeight() then
    --     return nil;
    -- end
    -- if index == 0 then ----------print(self._allTiledList[index + 2]) end
    return self._allTiledList[index + 1];
end

-- 获取格子
function TiledManage:GetTiled(x, y)
    if x < 0 or y < 0 or x >= MapLoad:GetWidth() or y >= MapLoad:GetHeight() then
        return nil;
    end

    return self:GetTiledByIndex(x * MapLoad:GetWidth() + y);
end

-- 根据X、Y获取格子的索引，从0开始
function TiledManage:GetTiledIndex(x, y)
    return x * MapLoad:GetWidth() + y;
end

-- 根据索引获取格子坐标，索引从0开始
function TiledManage:GetTiledCoordinate(index)
    local x = math.modf(index / MapLoad:GetWidth());
    local y = math.modf(index  - x * MapLoad:GetWidth());
    return x, y;
end

-- 根据格子位置，求坐标
function TiledManage:GetTiledPosition(x, y)
    local endX = (y * MapLoad:GetTiledWidth() / 2) - x * MapLoad:GetTiledWidth() / 2;
    local endY = - x * MapLoad:GetTiledHeight() / 2 - ((y + 1) * MapLoad:GetTiledHeight() / 2);
    return Vector3.New(endX, endY, 0);
end

function TiledManage:GetTiledPositionMinusHecto(x, y)
    local endX = (y * MapLoad:GetTiledWidth() / 2) - x * MapLoad:GetTiledWidth() / 2;
    local endY = - x * MapLoad:GetTiledHeight() / 2 - ((y + 1) * MapLoad:GetTiledHeight() / 2) - 100;
    return Vector3.New(endX,endY,0)
end

function TiledManage:GetTiledPositionSign(x,y)
    local endX = (y * MapLoad:GetTiledWidth() / 2) - x * MapLoad:GetTiledWidth() / 2 + 150;
    local endY = - x * MapLoad:GetTiledHeight() / 2 - ((y + 1) * MapLoad:GetTiledHeight() / 2) - 60;
    return Vector3.New(endX,endY,0)
end

function TiledManage:GetTiledPositionFortRedStart(x,y)
    local endX = (y * MapLoad:GetTiledWidth() / 2) - x * MapLoad:GetTiledWidth() / 2 - 80;
    local endY = - x * MapLoad:GetTiledHeight() / 2 - ((y + 1) * MapLoad:GetTiledHeight() / 2) + 80;
    return Vector3.New(endX,endY,0)
end

function TiledManage:GetTiledPositionWildFortRedStart(x,y)
    local endX = (y * MapLoad:GetTiledWidth() / 2) - x * MapLoad:GetTiledWidth() / 2 - 70;
    local endY = - x * MapLoad:GetTiledHeight() / 2 - ((y + 1) * MapLoad:GetTiledHeight() / 2) + 55;
    return Vector3.New(endX,endY,0)
end

function TiledManage:GetCreateFortTime(x, y)
    local endX = (y * MapLoad:GetTiledWidth() / 2) - x * MapLoad:GetTiledWidth() / 2;
    local endY = - x * MapLoad:GetTiledHeight() / 2 - ((y + 1) * MapLoad:GetTiledHeight() / 2) - 50;
    return Vector3.New(endX,endY,0)
end


-- 根据格子索引，求坐标
function TiledManage:GetTiledPositionByIndex(index)
    local x, y = self:GetTiledCoordinate(index);
    return self:GetTiledPosition(x, y);
end

-- 获取整数部分
function TiledManage:_GetIntPart(value)
    if value < 0 then
        value = math.ceil(value);
    end
    if math.ceil(value) ~= value then
        value = math.ceil(value) - 1;
    end

    return value;
end

-- 根据坐标求格子位置
function TiledManage:UIToTiledPosition(positionX, positionY)
    local x = self:_GetIntPart(-positionX / MapLoad:GetTiledWidth() - (positionY - self._landOffset) / MapLoad:GetTiledHeight() - 0.5);
    local y = self:_GetIntPart(positionX / MapLoad:GetTiledWidth() - (positionY - self._landOffset) / MapLoad:GetTiledHeight() - 0.5);

    return x, y;
end

function TiledManage:UIToTiledFloatPosition(positionX, positionY)
    local x = -positionX / MapLoad:GetTiledWidth() - (positionY - self._landOffset) / MapLoad:GetTiledHeight() - 0.5;
    local y = positionX / MapLoad:GetTiledWidth() - (positionY - self._landOffset) / MapLoad:GetTiledHeight() - 0.5;

    return x, y;
end

function TiledManage:UIToLimitTiledPosition(positionX, positionY)
    local x = self:_GetLimit(-positionX / MapLoad:GetTiledWidth() - (positionY - self._landOffset) / MapLoad:GetTiledHeight() - 0.5);
    local y = self:_GetLimit(positionX / MapLoad:GetTiledWidth() - (positionY - self._landOffset) / MapLoad:GetTiledHeight() - 0.5);

    return x, y;
end
--地块坐标转UI
function TiledManage:TiledPositionToUIPosition(x, y)
    --[[local UIPosX = MapLoad:GetTiledWidth() / 2 - MapLoad:GetTiledWidth() * MapLoad:GetWidth() / x
    local UIPosY = MapLoad:GetTiledHeight() / 2 - MapLoad:GetTiledHeight() * MapLoad:GetHeight() / y
    return Vector3.New(UIPosX, UIPosY, 0)]]
    local UIX = (y-x)*MapLoad:GetTiledWidth()/2;
    local UIY = ((-x-y)*MapLoad:GetTiledWidth())/4 - self._landOffset;
    --local Position = UnityEngine.Camera.worldToScreenPoint(Vector3.New(UIX,UIY,0));
    return Vector3.New(UIX,UIY,0);
end

function TiledManage:_GetLimit(value)
    if value < self._mapLimit then
        value = self._mapLimit;
    end

    if value > MapLoad:GetWidth() - self._mapLimit then
        value = MapLoad:GetWidth() - self._mapLimit;
    end
    
    if math.ceil(value) ~= value then
        value = math.max(math.ceil(value) - 1, value);
    end

    return value;
end

function TiledManage:GetLimitMin()
    return self._mapLimit;
end

function TiledManage:GetLimitMax()
    return MapLoad:GetWidth() - self._mapLimit;
end
-- -- 创建所有的格子
-- function TiledManage:_CreateAllTiled()
--     for x=0,MapLoad:GetWidth() - 1 do
--         for y=0,MapLoad:GetHeight() - 1 do
--             self:_CreateTiled(x, y);
--         end
--     end
-- end

-- 创建格子
function TiledManage:_CreateTiled(x, y)
    if x < 0 or y < 0 or x >= MapLoad:GetWidth() or y >= MapLoad:GetHeight() then
        return nil;
    end

    local index = self:GetTiledIndex(x, y) + 1;
    
    local tiled = Tiled.new();
    tiled:Init(x, y, index - 1);
    -- if index == 1 then 
    --     ----------print("aaaaddddddddddd")
    -- end
    self._allTiledList[index] = tiled;
    self:_InitTiled(tiled, index - 1);
    self:_LoadAllTiledInfo(tiled);
    return tiled;
end

-- 创建所有精灵
function TiledManage:_CreateAllSprite()
    local count = MapLoad:GetTileCount();
    for i=1, count, 1 do
        local times = MapLoad:GetTileNumbers(i);
        local firstgid = MapLoad:GetTileFirstGId(i);
        local name = MapLoad:GetTileName(i);
        local width = MapLoad:GetTileWidth(i);
        local height = MapLoad:GetTileHeight(i);

        if name == "resource" then
            local endid = times + firstgid;
            name = "resourcefront";
            for id = firstgid, times + firstgid - 1 do
                self:_CreateSprite(id, firstgid, name, width, height);
            end

            name = "resourcebehind";
            self._resourcetimes = times;
            for id = endid, (times + endid - 1) do
                self:_CreateSprite(id, endid, name, width, height);
            end
        elseif name == "land" then
            for id = firstgid, (times + firstgid - 1) do
                self:_CreateSprite(id, firstgid, name, width, height);
            end
            --添加地表数据的临时添加
            for id = 1098, 1129 do
                self:_CreateSprite(id, firstgid, name, width, height);
            end
        else
            for id = firstgid, (times + firstgid - 1) do
                self:_CreateSprite(id, firstgid, name, width, height);
            end
        end
    end
end

-- 创建精灵
function TiledManage:_CreateSprite(id, firstId, image, width, height)

    if image == "moutain" then
        return;
    end

    self._allSpriteList[id] = TiledSprite.new();
    -- 从1开始
    local finalImage = string.format( "%s_%04d", image, (id - firstId + 1) );

    -- if image == "road" then
    --     ----------print(id.."     "..finalImage);
    -- end
    
    self._allSpriteList[id]:Init(id, finalImage, width, height);
end

-- 获取精灵
function TiledManage:GetSprite(id)
    if id == nil then
        return nil;
    end
    local tiledSprite = self._allSpriteList[id];
    if tiledSprite == nil then
        return nil;
    end

    return tiledSprite:GetSprite();
end

--处理所有的层
function TiledManage:InitAllLayer(tiledParent, cacheTiledParent, cacheBuildingParent)
    self._tiledParent = tiledParent;
    self:_LoadAllLayer();
    self:_LoadAllCacheTiled(cacheTiledParent);
    self._buildingParent = UGameObject.Find("Building").transform;
    self._moutainParent = UGameObject.Find("Moutain").transform;
    self._roadParent = UGameObject.Find("Road").transform;
    self._UIParent = UGameObject.Find("UI").transform;
    self._wildBuildingManage:_SetAllCacheTiledParent(cacheBuildingParent, self._buildingParent);
    self._mainCityManage:_SetAllCacheTiledParent(cacheBuildingParent, self._buildingParent);
    self._unitWildBuildingManage:_SetAllCacheTiledParent(cacheBuildingParent, self._buildingParent);
    self._moutainManage:_SetAllCacheMoutainParent(cacheTiledParent, self._moutainParent)
    --self._roadManage:_SetAllCacheRoadParent(cacheTiledParent, self._roadParent);
    UIMapNameService:Instance():_SetAllCacheUIParent(self._UIParent);
end

-- 加载所有的层
function TiledManage:_LoadAllLayer()
    self:_InsertLayer(LayerType.Land, self._tiledParent:Find("Land"));
    self:_InsertLayer(LayerType.Road, self._tiledParent:Find("Road"));
    --self:_InsertLayer(LayerType.Moutain, self._tiledParent:Find("Moutain"));
    self:_InsertLayer(LayerType.Building, self._tiledParent:Find("Building"));
    self:_InsertLayer(LayerType.ResourceFront, self._tiledParent:Find("ResourceFront"));
    self:_InsertLayer(LayerType.ResourceBehind, self._tiledParent:Find("ResourceBehind"));
    self:_InsertLayer(LayerType.Army, self._tiledParent:Find("Army"));
    self:_InsertLayer(LayerType.Power, self._tiledParent:Find("Power"));
    self:_InsertLayer(LayerType.Line, self._tiledParent:Find("Line"));
    self:_InsertLayer(LayerType.Flag, self._tiledParent:Find("Flag"));
    self:_InsertLayer(LayerType.ArmyWalkSlider, self._tiledParent:Find("ArmyWalkSlider"));
    self:_InsertLayer(LayerType.ImaginaryLine, self._tiledParent:Find("ImaginaryLine"));
    self:_InsertLayer(LayerType.State, self._tiledParent:Find("State"));
    self:_InsertLayer(LayerType.View, self._tiledParent:Find("View"));
    self._allLayerMap[LayerType.UI] = self._tiledParent:Find("UI");
    --下面一行找到资源地事件的父对象
    self._allLayerMap[LayerType.SourceEvent] = self._tiledParent:Find("SourceEvent");
    self:_InsertLayer(LayerType.WildFort, self._tiledParent:Find("Building"));
    self:_InsertLayer(LayerType.Sign, self._tiledParent:Find("Sign"));
    self:_InsertLayer(LayerType.ArmyBehaviourTwo, self._tiledParent:Find("ArmyBehaviourTwo"));
    
    --self:_InsertLayer(LayerType.UI, self._tiledParent:Find("UI"));
end

function TiledManage:GetSourceEventParent()
    return self._allLayerMap[LayerType.SourceEvent];
end

-- 插入层级
function TiledManage:_InsertLayer(layerType, layer)
    if layerType == nil or layer == nil then
        return;
    end
    
    self._allLayerMap[layerType] = layer;
    self.allLayerCacheMap[layerType] = LoadResourcesPrefab.new();
    self.allLayerCacheMap[layerType]:SetResPath("Map/TileImage");
end

-- 加载所有的缓存
function TiledManage:_LoadAllCacheTiled(cacheTiledParent)
    self._cacheTiledParent = cacheTiledParent;
    local childCount = self._cacheTiledParent.childCount;
    for i=1,childCount do
        local cacheTiled = self._cacheTiledParent:GetChild(i - 1);
        --self:_ReleaseTiled(cacheTiled);
    end
end

-- 释放格子
function TiledManage:_ReleaseTiled(cacheTiled, layerType)
    if cacheTiled == nil then
        return;
    end
    local layerCache = self:GetLayerCache(layerType);
    if layerCache ~= nil then
        layerCache:Recovery(cacheTiled);
    end
end

-- 回收格子
function TiledManage:_AllocTiled()
    if self._cacheTiledQueue:Count() == 0 then
        return nil;
    end

    return self._cacheTiledQueue:Pop();
end

-- 初始化格子
function TiledManage:_InitTiled( tiled, index )
    self:_InitTiledLayer(tiled, index, LayerType.State);
    self:_InitTiledLayer(tiled, index, LayerType.Land);
    self:_InitTiledLayer(tiled, index, LayerType.Road);
    self:_InitTiledLayer(tiled, index, LayerType.Moutain);
    self:_InitTiledLayer(tiled, index, LayerType.ResourceBehind);
    self:_InitTiledLayer(tiled, index, LayerType.ResourceFront);
    self:_InitTiledLayer(tiled, index, LayerType.Army);
    --self:_InitTiledLayer(tiled, index, LayerType.Building);
    self:_InitTiledLayer(tiled, index, LayerType.WildFort);
end

-- 加载所有格子信息
function TiledManage:_LoadAllTiledInfo(tiled)
    self:_LoadTiledResource(tiled)
    self:_LoadTiledState(tiled);
end

-- 加载格子资源州郡信息
function TiledManage:_LoadTiledResource(tiled)
    if tiled == nil then
        return
    end
    local tiledCutId = tiled:GetImageId(LayerType.ResourceFront)
    local tiledCut = DataTileCut[tiledCutId]
    if tiledCut == nil then
        return
    end
    local tiledId = tiledCut.TileID
    ------------print(tiledId)
    local dataTiled = DataTile[tiledId]

    local dataRegion = DataRegion[tiledId]
    ----------print(dataTiled) 
    tiled:SetResource(dataTiled)
    tiled:SetRegion(dataRegion)
end

-- 州资源
function TiledManage:_LoadTiledState(tiled)
    if tiled == nil then
        return
    end
    local tiledCutId = tiled:GetImageId(LayerType.State)
    local tiledCut = DataTileCut[tiledCutId]
    ------------print("_LoadTiledState"..tiledCutId.."     ");
    if tiledCut == nil then
        ------------print(tiledCutId);
        return
    end
    local tiledId = tiledCut.TileID
  -- ----------print(tiledId)
    local dataRegion = DataRegion[tiledId]
    if dataRegion == nil then
        ------------print(tiledCutId .. "  " ..tiledId);
    end
    ------------print(tiledCutId .. "  " ..tiledId);
    tiled:SetRegion(dataRegion)
end

-- 初始化地表层
function TiledManage:_InitTiledLayer(tiled, index, layerType)
    if tiled == nil or index == nil or layerType == nil then
        return;
    end

    local terrain = MapLoad:GetTerrain(layerType, index);
    if layerType == LayerType.ResourceFront then
      end
    if layerType == LayerType.ResourceBehind then
        if terrain ~= 0 then
            terrain = terrain + self._resourcetimes;
        end
    end

    -- if layerType == LayerType.Land then
    --     --------print(terrain)
    -- end
    tiled:SetImageId(layerType, terrain);
end

-- 显示格子
function TiledManage:ShowTiled(x, y, order)
    ----------print("ShowTiled: " .. x .. "   " .. y);
    -- UnityEngine.Profiler.BeginSample("GetTiled");
    local tiled = self:GetTiled(x, y);
    -- UnityEngine.Profiler.EndSample();
    --UnityEngine.Profiler.BeginSample("_HandleCreateTiled");
    if tiled == nil then
        tiled = self:_HandleCreateTiled(x, y);
    end
    --UnityEngine.Profiler.EndSample();
    if tiled == nil then
        return;
    end
    --UnityEngine.Profiler.BeginSample("ShowTiled");
    tiled:SetVisible(true);
    LineService:Instance():OnShowTiled(tiled);
    -- self:_ShowTiledLayer(tiled, LayerType.State);
    --UnityEngine.Profiler.BeginSample("Land");
    self:_ShowTiledLayer(tiled, LayerType.Land, order);
    --UnityEngine.Profiler.EndSample();
    self:_ShowTiledLayer(tiled, LayerType.Road, order);
    --UnityEngine.Profiler.BeginSample("_roadManage");
    --self._roadManage:ShowTiledLayer(tiled);
    --UnityEngine.Profiler.EndSample();
    --self:_ShowTiledLayer(tiled, LayerType.Moutain, order);
    --UnityEngine.Profiler.BeginSample("_moutainManage");
    self._moutainManage:ShowTiledLayer(tiled);
    --UnityEngine.Profiler.EndSample();
    --UnityEngine.Profiler.BeginSample("ShowBuilding");
    if tiled:GetTown() == nil and (tiled:GetBuilding() == nil or tiled:GetBuilding()._dataInfo.Type == BuildingType.PlayerFort) then
            self:_ShowTiledLayer(tiled, LayerType.ResourceFront, order);
            self:_ShowTiledLayer(tiled, LayerType.ResourceBehind, order);
    end
    --UnityEngine.Profiler.EndSample();
    --UnityEngine.Profiler.BeginSample("_wildBuildingManage");
    self._wildBuildingManage:_ShowTiledLayer(tiled);
    --UnityEngine.Profiler.EndSample();
    --UnityEngine.Profiler.BeginSample("_mainCityManage");
    self._mainCityManage:_ShowTiledLayer(tiled);
    --UnityEngine.Profiler.EndSample();
    --UnityEngine.Profiler.BeginSample("_unitWildBuildingManage");
    self._unitWildBuildingManage:_ShowTiledLayer(tiled);
    self:_ShowTiledLayer(tiled, LayerType.WildFort, order);
    --UnityEngine.Profiler.EndSample();
    --UnityEngine.Profiler.BeginSample("_ShowTiledViewLayer");
    self:_InitTiledViewLayer(tiled);
    --UnityEngine.Profiler.EndSample();
    --UnityEngine.Profiler.EndSample();
    UIMapNameService:Instance():_ShoWildUILayer(tiled);
end

-- 处理格子显示
function TiledManage:_HandleCreateTiled(x, y)
    ------------print(x, y)
    local tiled = self:_CreateTiled(x, y);
    -- 这里写野城
    local index = self:GetTiledIndex(x, y);
    local building = BuildingService:Instance():GetBuildingByTiledId(index);
    local town =  BuildingService:Instance():GetTown(index);
    local childBoat = BuildingService:Instance():GetChildBoat(index);
    if tiled ~= nil then
        if building ~= nil then
            tiled:SetBuilding(building);
        else
            self:_CreatWildBuilding(tiled);
        end
        if town ~= nil then
            tiled:SetTown(town);
        --tiled:SetBuilding(town._building);
        end
        if childBoat ~= nil then
            -- print("有没有存进去子码头")
            tiled._childBoat = childBoat;
        end
    end
    return tiled;
end

-- function TiledManage:_ShowTiledUILayer(tiled)
--     local building = tiled:GetBuilding();
--     if building == nil or tiled:GetTown() ~= nil then
--         return;
--     end
    
--     if building._dataInfo[Type] == 1 or building._dataInfo[Type] == 2 then
--         UICityName = require("Game/MapMenu/UICityName").new();
--         GameResFactory.Instance():GetUIPrefab("UIPrefab/CityName", self._allLayerMap[layerType.UI], UICityName, function (Object)
--             UICityName:
--         end)
--     else
--         UICityImage = require("Game/MapMenu/UICityImage").new();
--         GameResFactory.Instance():GetUIPrefab("UIPrefab/CityImage", self._allLayerMap[layerType.UI], UICityImage, function (Object)
--             UICityImage:
--         end)
--     end
-- end



-- 刷新城区
function TiledManage:_RefreshTown(building)
    local townCount = building:GetTownCount()
    for i = 1, townCount do
        local town = building:GetTown(i)
        if town ~= nil then
            local tiled = self:GetTiledByIndex(town._index)
            if tiled ~= nil then
                tiled:SetTown(town)
            end
        end
    end
end

-- 删除城
function TiledManage:RemoveBuildingByIndex(building)
    local buildingTiled = self:GetTiledByIndex(building._tiledId)
    
    if buildingTiled ~= nil then
        buildingTiled:RemoveBuilding();
    end

    local townCount = building:GetTownCount()
    for i = 1, townCount do
        local town = building:GetTown(i)
        if town ~= nil then
            local tiled = self:GetTiledByIndex(town._index)
            if tiled ~= nil then
                tiled:RemoveTown()
            end
        end
    end

    local childBoat = building._childBoat
    if childBoat ~= nil then
        local tiled = self:GetTiledByIndex(childBoat._index)
        if tiled ~= nil then
            tiled:RemoveChildBoat()
        end
    end
end

-- 刷新分城建设倒计时
function TiledManage:_RefreshCreateSubCityCountDown(building)
    if building == nil then
        return;
    end
    local tableData = building._dataInfo;
    if tableData == nil then
        return;
    end
    
    if tableData.Type ~= BuildingType.SubCity then
        return;
    end

    if building._subCitySuccessTime == 0 then
        if self._subCityCreatingObjectMap[building._id] ~= nil then
            self._subCityCreatingResourcesPrefab:Recovery(self._subCityCreatingObjectMap[building._id]);
            self._subCityCreatingObjectMap[building._id] = nil;
        end
        if self._subCityCountDownObjectMap[building._id] ~= nil then
            self._subCityCountDownResourcesPrefab:Recovery(self._subCityCountDownObjectMap[building._id])
            self._subCityCountDownObjectMap[building._id] = nil;
        end
        self:DeleteSubCityEffect(building._id)
        return;
    end

    local currentTime = PlayerService:Instance():GetLocalTime();
    if currentTime < building._subCitySuccessTime then
        if self._subCityCreatingObjectMap[building._id] ~= nil or self._subCityCountDownObjectMap[building._id] ~= nil then
            return
        end

        local buildParent = MapService:Instance():GetLayerParent(LayerType.Building);
        self._subCityCreatingResourcesPrefab:SetResPath("Map/SubCityImage");
        self._subCityCreatingResourcesPrefab:Load(buildParent, function (subCityObject)
            self._subCityCreatingObjectMap[building._id] = subCityObject;
            local x, y = self:GetTiledCoordinate(building._tiledId);
            subCityObject.transform.localPosition = self:GetTiledPositionMinusHecto(x, y);
            subCityObject.transform.localScale = Vector3.one;
            subCityObject.transform.name = string.format("%d", building._tiledId);
            MapService:Instance():BuildingSort(subCityObject.transform, buildParent);
        end, "SubCityCreateImage"..building._id)

        local myPlayerId = PlayerService:Instance():GetPlayerId();
        if building._owner == myPlayerId then
            local uiParent = MapService:Instance():GetLayerParent(LayerType.UI);
            self._subCityCountDownResourcesPrefab:SetResPath("Map/SubCityCreateImage");
            self._subCityCountDownResourcesPrefab:Load(uiParent, function (countDownObject)
                self._subCityCountDownObjectMap[building._id] = countDownObject;
                self:_OnShowCreateSubCity(countDownObject, building);
            end, "SubCityCreateTimeImage"..building._id)
        end

        if self._CreateSubCityEffectMap[building._id] == nil then
            local parent = MapService:Instance():GetLayerParent(LayerType.Building);
            local x, y = self:GetTiledCoordinate(building._tiledId);
            local position = MapService:Instance():GetTiledPosition(x, y);
            local effect = EffectsService:Instance():AddEffect(parent, EffectsType.BuiltEffect, 2, nil, position)
            self._CreateSubCityEffectMap[building._id] = effect
        end
    else
        if self._subCityCreatingObjectMap[building._id] ~= nil then
            self._subCityCreatingResourcesPrefab:Recovery(self._subCityCreatingObjectMap[building._id]);
            self._subCityCreatingObjectMap[building._id] = nil;
        end
        if self._subCityCountDownObjectMap[building._id] ~= nil then
            self._subCityCountDownResourcesPrefab:Recovery(self._subCityCountDownObjectMap[building._id])
            self._subCityCountDownObjectMap[building._id] = nil;
        end
        self:DeleteSubCityEffect(building._id)
    end
end

-- 显示分城建设倒计时
function TiledManage:_OnShowCreateSubCity(CountDownObject, building)
    local x, y = self:GetTiledCoordinate(building._tiledId);
    CountDownObject.transform.localPosition = self:GetCreateFortTime(x, y);
    CountDownObject.transform.localScale = Vector3.one;
    local timeText = CountDownObject.transform:Find("Time/Text").gameObject:GetComponent(typeof(UnityEngine.UI.Text));
    local currentTime = PlayerService:Instance():GetLocalTime();
    local cdTime = math.floor((building._subCitySuccessTime - currentTime)/1000);
    timeText.text = CommonService:Instance():GetDateString(cdTime);
    local totalTime = DataBuild[20001].UpgradeCostTime;
    local slider = CountDownObject.transform:Find("Slider").gameObject:GetComponent(typeof(UnityEngine.UI.Slider));
    slider.value = 1 - (building._subCitySuccessTime - currentTime) / totalTime;
    CommonService:Instance():TimeDown(nil,building._subCitySuccessTime,timeText,function() timeText.text = "00:00:00" , self:DeleteSubCityEffect(building._id) end , slider, totalTime);
end

function TiledManage:DeleteSubCityEffect(buildingId)
    if self._CreateSubCityEffectMap[buildingId] ~= nil then
        EffectsService:Instance():RemoveEffect(self._CreateSubCityEffectMap[buildingId])
        self._CreateSubCityEffectMap[buildingId] = nil
    end
end

-- 刷新拆除分城倒计时
function TiledManage:_RefreshDeleteSubCityCountDown(building)
    if building == nil then
        return;
    end
    local tableData = building._dataInfo;
    if tableData == nil then
        return;
    end

    local myPlayerId = PlayerService:Instance():GetPlayerId();
    if tableData.Type ~= BuildingType.SubCity or building._owner ~= myPlayerId then
        return;
    end

    if building._subCityDeleteTime == 0 then
        if self._subCityDeleteCountDownObjectMap[building._id] ~= nil then
            self._subCityDeleteCountDownResourcesPrefab:Recovery(self._subCityDeleteCountDownObjectMap[building._id])
            self._subCityDeleteCountDownObjectMap[building._id] = nil;
        end
        return;
    end

    local currentTime = PlayerService:Instance():GetLocalTime();
    if currentTime < building._subCityDeleteTime then
        if self._subCityDeleteCountDownObjectMap[building._id] ~= nil then
            return
        end
        local parent = MapService:Instance():GetLayerParent(LayerType.UI);
        self._subCityDeleteCountDownResourcesPrefab:SetResPath("Map/SubCityDeleteImage")
        self._subCityDeleteCountDownResourcesPrefab:Load(parent, function (countDownObject)
            self._subCityDeleteCountDownObjectMap[building._id] = countDownObject;
            self:_OnShowDeleteSubCity(countDownObject, building);
        end, "SubCityDeleteTimeImage"..building._id)
    else
        if self._subCityDeleteCountDownObjectMap[building._id] ~= nil then
            self._subCityDeleteCountDownResourcesPrefab:Recovery(self._subCityDeleteCountDownObjectMap[building._id])
            self._subCityDeleteCountDownObjectMap[building._id] = nil;
        end
    end
end

-- 显示分城拆除倒计时
function TiledManage:_OnShowDeleteSubCity(CountDownObject, building)
    local x, y = self:GetTiledCoordinate(building._tiledId);
    CountDownObject.transform.localPosition = self:GetTiledPositionMinusHecto(x, y);
    CountDownObject.transform.localScale = Vector3.one;
    local timeText = CountDownObject.transform:Find("Time/Text").gameObject:GetComponent(typeof(UnityEngine.UI.Text));
    local currentTime = PlayerService:Instance():GetLocalTime();
    local cdTime = math.floor((building._subCityDeleteTime - currentTime)/1000);
    timeText.text = CommonService:Instance():GetDateString(cdTime);
    local totalTime = DataBuild[20001].DemolishTime;
    local slider = CountDownObject.transform:Find("Slider").gameObject:GetComponent(typeof(UnityEngine.UI.Slider));
    slider.value = 1 - (building._subCityDeleteTime - currentTime) / totalTime;
    CommonService:Instance():TimeDown(nil,building._subCityDeleteTime,timeText,function ()timeText.text = "00:00:00"; end, slider, totalTime);
end

-- 获取显示层的父亲
function TiledManage:_GetLayerParent(layerType)
    if layerType == nil then
        return nil;
    end
    
    return self._allLayerMap[layerType];
end

-- 获取显示层的父亲
function TiledManage:GetLayerCache(layerType)
    if layerType == nil then
        return nil;
    end
    
    return self.allLayerCacheMap[layerType];
end

-- 显示格子的层
function TiledManage:_ShowTiledLayer(tiled, layerType, order)
    if tiled == nil or layerType == nil then
        return;
    end

    local imageId = tiled:GetImageId(layerType);
    --临时
    if layerType == LayerType.Land then
        if imageId == 2 or imageId == 3 or imageId == 4 or imageId == 5 then
            return;
        end
    end
    if (layerType == LayerType.ResourceFront or layerType == LayerType.ResourceBehind) then
        if tiled._resource == nil or tiled._resource.TileLv == 1 then
            return;
        end
    end

    if imageId == nil or imageId <= 0 then
        return;
    end

    local parent = self:_GetLayerParent(layerType);
    if parent == nil then
        return;
    end
    
    local tileTransform = tiled:GetImageTransform(layerType);

    -- 每一层的缓存
    local layerCache = self:GetLayerCache(layerType);

    -- if layerType == LayerType.WildFort then
    --     parent = self:_GetLayerParent(LayerType.ResourceFront);
    -- end

    if tileTransform == nil then
        layerCache:Load(parent, function ( tileImageObject )
            self:_OnShowLayer(tileImageObject.transform, parent, layerType, tiled, order)
        end);
        return;
    end
    
    self:_OnShowLayer(tileTransform, parent, layerType, tiled, order);
end

function TiledManage:HideMapUI()
    if self:_GetLayerParent(LayerType.UI).gameObject.activeSelf == true then
        self:_GetLayerParent(LayerType.UI).gameObject:SetActive(false);
    end
end

function TiledManage:ShowMapUI()
    if self:_GetLayerParent(LayerType.UI).gameObject.activeSelf == false then
        self:_GetLayerParent(LayerType.UI).gameObject:SetActive(true);
    end
end

function TiledManage:BuildingSort(buildingtransform, parent)
    if buildingtransform == nil or parent == nil then
        return;
    end
    
    if buildingtransform.parent ~= parent then
       buildingtransform:SetParent(parent);
    end

    local count = parent.childCount;
    
    if count == 0 then
        return;
    end
    -- --------print(tonumber(buildingtransform.name))
    -- --------print(count)
    for i=1,count do
        -- --------print(tonumber(buildingtransform.name))
        -- --------print(tonumber(parent:GetChild(i - 1).name))
        --等待亚雷和李汉的修改临时处理
        if tonumber(parent:GetChild(i - 1).name) == nil then
            
        else
            if tonumber(buildingtransform.name) <= tonumber(parent:GetChild(i - 1).name) then
                if i - 1 == 0 then
                    buildingtransform:SetAsFirstSibling();
                    return;
                end

                if i == count then
                    buildingtransform:SetAsLastSibling();
                    return;
                end 
                buildingtransform:SetSiblingIndex(parent:GetChild(i - 1):GetSiblingIndex());
                return;
            end

        end
    end
end

-- 显示格子
function TiledManage:_OnShowLayer(tileTransform, parent, layerType, tiled, order)
    if tileTransform == nil or tiled == nil then
        return;
    end
    
    tiled:SetTiledImage(layerType, tileTransform.gameObject);
    tiled:SetSprite(layerType, self:GetSprite(tiled:GetImageId(layerType)));
    tileTransform.localPosition = self:GetTiledPosition(tiled:GetX(), tiled:GetY()) - Vector3.New(0, DataGameConfig[MapMoveType.Environment].OfficialData,0);
    --为了排序
    if layerType == LayerType.WildFort then
        tileTransform.name = string.format("%d", tiled:GetIndex());
        self:BuildingSort(tileTransform, self:_GetLayerParent(LayerType.WildFort))
        --tileTransform:SetAsFirstSibling();
        --tileTransform.parent = self:_GetLayerParent(LayerType.WildFort);
    else
        tileTransform.name = string.format("TileImage %04d X %04d", tiled:GetX(), tiled:GetY());
        ------------print("name: " ..tileTransform:GetType():__tostring());
        -- tileTransform:SetParent(parent);
        if order == nil or order == true then
            tileTransform:SetAsLastSibling();
        else
            tileTransform:SetAsFirstSibling();
        end
    end
end

-- 隐藏格子
function TiledManage:HideTiled(x, y)
    local tiled = self:GetTiled(x, y);
    if tiled == nil then
        return;
    end

    tiled:SetVisible(false);

    LineService:Instance():RemoveTiled(tiled);

    --UnityEngine.Profiler.BeginSample("HideTiled");

    self:_ReleaseTiled(tiled:GetImageTransform(LayerType.Land), LayerType.Land);
    self:_ReleaseTiled(tiled:GetImageTransform(LayerType.WildFort), LayerType.WildFort);
    self:_ReleaseTiled(tiled:GetImageTransform(LayerType.Road), LayerType.Road);
    --self._roadManage:HideTiled(tiled);
    --self:_ReleaseTiled(tiled:GetImageTransform(LayerType.Moutain));
    self._moutainManage:HideTiled(tiled);
    self:_ReleaseTiled(tiled:GetImageTransform(LayerType.ResourceFront), LayerType.ResourceFront);
    self:_ReleaseTiled(tiled:GetImageTransform(LayerType.ResourceBehind), LayerType.ResourceBehind);
    self:_ReleaseTiled(tiled:GetImageTransform(LayerType.Power), LayerType.Power);
    --self:_ReleaseTiled(tiled:GetImageTransform(LayerType.State), LayerType.State);
    --self:_ReleaseBuilding(tiled:GetImageTransform(LayerType.Building));
    self._wildBuildingManage:_HideTiled(tiled);
    self._mainCityManage:_HideTiled(tiled);
    if tiled:GetLeagueMark() ~= nil then
        self._drawLoadResourcesPrefab:Recovery(LeagueService:Instance():GetFlag(tiled:GetLeagueMark().id))
    end

    --UnityEngine.Profiler.EndSample();
    
    self:_ReleaseTiled(tiled:GetImageTransform(LayerType.View), LayerType.View);
    self._unitWildBuildingManage:_HideTiled(tiled);
    UIMapNameService:Instance():_HideTiledUILayer(tiled);
    tiled:ClearTiledObject();
    
    if tiled:GetBuilding() ~= nil then
        self:_RemoveBuilding(tiled:GetBuilding());
    end

    self:_RemoveTiled(tiled);
end

function TiledManage:_HandleBuildingResources(buildingIndex, circleCount)
    ----------print("_HideBuildingResources"..buildingIndex.."   "..circleCount)
    local centerX, centerY = self:GetTiledCoordinate(buildingIndex)
    local startX = centerX - circleCount;
    local startY = centerY - circleCount;
    local endX = centerX + circleCount;
    local endY = centerY + circleCount;
    for i = startX, endX do
        for j = startY, endY do
            while true do
                self:_HideResources(i, j);
                self:_ShowResources(i, j);
                break
            end
        end
    end
end

function TiledManage:_ShowBuildingResources(buildingIndex, circleCount)
    ----------print("_ShowBuildingResources"..buildingIndex.."   "..circleCount)
    local centerX, centerY = self:GetTiledCoordinate(buildingIndex)
    local startX = centerX - circleCount;
    local startY = centerY - circleCount;
    local endX = centerX + circleCount;
    local endY = centerY + circleCount;
    for i = startX, endX do
        for j = startY, endY do
            while true do
                --self:_HideResources(i, j);
                self:_ShowResources(i, j);
                break
            end
        end
    end
end

function TiledManage:_HideResources(x, y)
    local tiled = self:GetTiled(x, y);
    if tiled == nil then
        return;
    end
    self:_ReleaseTiled(tiled:GetImageTransform(LayerType.ResourceFront), LayerType.ResourceFront);
    self:_ReleaseTiled(tiled:GetImageTransform(LayerType.ResourceBehind), LayerType.ResourceBehind);
    tiled:ClearTiledImage(LayerType.ResourceFront);
    tiled:ClearTiledImage(LayerType.ResourceBehind);
end

function TiledManage:_ShowResources(x, y)
    local tiled = self:GetTiled(x, y);
    if tiled == nil then
        return;
    end
    
    if tiled:GetTown() == nil and (tiled:GetBuilding() == nil or tiled:GetBuilding()._dataInfo.Type == BuildingType.PlayerFort) then
        self:_ShowTiledLayer(tiled, LayerType.ResourceFront, order);
        self:_ShowTiledLayer(tiled, LayerType.ResourceBehind, order);
    end
end

-- 移除格子
function TiledManage:_RemoveBuilding(building)
    if building._owner ~= 0 and building._owner ~= PlayerService:Instance():GetPlayerId() then
        BuildingService:Instance():DeleteBuilding(building._id);
        BuildingService:Instance():DeleteBuildingTiled(building._tiledId);
    end
end

-- 移除格子
function TiledManage:_RemoveTiled(tiled)
    self._allTiledList[tiled:GetIndex() + 1] = nil;
end

-- 遍历周围更新视野边缘数值
function TiledManage:UpdateViewEdgeValue(tiled, value)
    local index = 0;
    for x = -1, 1 do
        for y = -1, 1 do
            if x == 0 and y == 0 then
                
            else
                index = index + 1;
                local newTiledId = self:GetTiledIndex(tiled._x + x, tiled._y + y);
                local newTiled = self:GetTiledByIndex(newTiledId);
                if newTiled ~= nil and newTiled.tiledInfo ~= nil and newTiled.tiledInfo.isHaveView == true then
                    tiled:SetViewEdgeValue(index, 2);
                else
                    tiled:SetViewEdgeValue(index, 1);
                end
                if newTiled ~= nil then
                    newTiled:SetViewEdgeValue(9 - index, value);
                end
            end
        end
    end
end

-- 地块新显示的时候直接加迷雾
function TiledManage:_InitTiledViewLayer(tiled)
    self:UpdateViewEdgeImage(tiled);
end

-- 服务器返回地块视野信息之后更新相关地块视野
function TiledManage:_ShowTiledViewLayer(tiled)
    if tiled == nil then
        return;
    end
    
    local isHaveView = false;
    if tiled.tiledInfo ~= nil and tiled.tiledInfo.isHaveView == true then
        isHaveView = true;
    end

    if isHaveView == true then
        self:UpdateViewEdgeValue(tiled, 2);
    else
        self:UpdateViewEdgeValue(tiled, 1);
    end

    for x = -1, 1 do
        for y = -1, 1 do
            local newTiledId = self:GetTiledIndex(tiled._x + x, tiled._y + y);
            local newTiled = self:GetTiledByIndex(newTiledId);
            if newTiled ~= nil then
                self:UpdateViewEdgeImage(newTiled);
            end
        end
    end
end

-- 更新格子视野图片
function TiledManage:UpdateViewEdgeImage(tiled)
    if tiled == nil then
        return;
    end
    
    if tiled.tiledInfo ~= nil and tiled.tiledInfo.isHaveView == true then
        self:_ReleaseTiled(tiled:GetImageTransform(LayerType.View), LayerType.View);
        tiled:ClearTransform(LayerType.View);
        tiled:SetOldViewImageName("");
        return;
    end

    local parent = self:_GetLayerParent(LayerType.View);
    if parent == nil then
        return;
    end

    local layerCache = self:GetLayerCache(LayerType.View);
    local tileTransform = tiled:GetImageTransform(LayerType.View);
    if tileTransform == nil then
        layerCache:Load(parent, function ( tileImageObject )
            -- UnityEngine.Profiler.BeginSample("self:_OnShowViewLayer");
            self:_OnShowViewLayer(tileImageObject.transform, parent, tiled)
            -- UnityEngine.Profiler.EndSample();
        end, "view"..tostring(tiled:GetIndex()));
    else
        local data = DataShadow[tiled:GetViewEdgeValue()];
        if data == nil then
             LogManager:Instance():Log("相关id的迷雾shadow表没有配 找小哲哲：".. tiled:GetViewEdgeValue());
            return;
        end
        local newImageName = data.ShadowPic;
        if newImageName ~= tiled:GetOldViewImageName() then
            tiled:SetOldViewImageName(newImageName);
            local sprite = GameResFactory.Instance():GetResSprite(newImageName);
            tiled:SetSprite(LayerType.View, sprite);
        end
    end
end

function TiledManage:_OnShowViewLayer(tileTransform, parent, tiled)
    if tileTransform == nil or tiled == nil then
        return;
    end
    
    -- tileTransform.gameObject:SetActive(true);
    --UnityEngine.Profiler.BeginSample("self:_OnShowViewLayerName  kkkkkkkk");
    tileTransform.name = string.format("View %04d X %04d", tiled:GetX(), tiled:GetY());
    --UnityEngine.Profiler.EndSample();
    -- tileTransform:SetParent(parent);
    --UnityEngine.Profiler.BeginSample("self:_OnShowViewLayerName  SetTiledImage");
    tiled:SetTiledImage(LayerType.View, tileTransform.gameObject);
    --tiled:SetViewImageSprite();
    --UnityEngine.Profiler.EndSample();
    local data = DataShadow[tiled:GetViewEdgeValue()];
    if data == nil then
         LogManager:Instance():Log("相关id的迷雾shadow表没有配 找小哲哲："..tiled:GetViewEdgeValue())
         return;
    end
    local newImageName = data.ShadowPic;
    tiled:SetOldViewImageName(newImageName);
    --UnityEngine.Profiler.BeginSample("self:_OnShowViewLayer  GetResSprite");
    local sprite = GameResFactory.Instance():GetResSprite(newImageName);

    --UnityEngine.Profiler.EndSample();
    --UnityEngine.Profiler.BeginSample("self:_OnShowViewLayerName  SetSprite");
    tiled:SetSprite(LayerType.View, sprite);
    --UnityEngine.Profiler.EndSample();
    --UnityEngine.Profiler.BeginSample("self:_OnShowViewLayer0000000000000000000000");
    tileTransform.localPosition = self:GetTiledPosition(tiled:GetX(), tiled:GetY());
    --UnityEngine.Profiler.BeginSample("self:_OnShowViewLayerffffffffffffffffffffffffff");
    tileTransform.localScale = Vector3.one;
    --UnityEngine.Profiler.EndSample();
    --UnityEngine.Profiler.EndSample();
end

-- 根据我的Id和同盟Id计算所属势力
-- 目前没有考虑沦陷
function TiledManage:CalcPower(ownerId, leagueId, superiorLeagueId, tiled)
    if tiled == nil then
        return PowerType.Empty;
    end
    -- if ownerId == 0 then
    --     return PowerType.Empty;
    -- end
    local myId = PlayerService:Instance():GetPlayerId();
    local myLeagueId = PlayerService:Instance():GetLeagueId();
    local mySuperiorLeagueId = PlayerService:Instance():GetsuperiorLeagueId();

    local tempUnitClickPanelType = UnitClickPanelType.new()

    --tempUnitClickPanelType:InitDataClickPanelType()
    local playerAlliesStateType = tempUnitClickPanelType:GetPlayerAlliesStateType(myLeagueId)
    if playerAlliesStateType == nil then
       -- ------print("playerAlliesStateType is Empty");
        return PowerType.Empty
    end
    local playerOccupyStateType = tempUnitClickPanelType:GetPlayerOccupyStateType(mySuperiorLeagueId)
    if playerOccupyStateType == nil then
       -- ------print("playerOccupyStateType is Empty");
        return PowerType.Empty
    end
    local tiledOwnerType = tempUnitClickPanelType:GetTiledOwnerType(myId, ownerId)
    if tiledOwnerType == nil then
       -- ------print("tiledOwnerType is Empty");
        return PowerType.Empty
    end
    local tiledAlliesType = tempUnitClickPanelType:GetTiledAlliesType(myId, ownerId, myLeagueId, mySuperiorLeagueId, leagueId)
    if tiledAlliesType == nil then
       -- ------print("tiledAlliesType is Empty");
        return PowerType.Empty
    end
    local tiledSuperAlliesType = tempUnitClickPanelType:GetTiledSuperAlliesType(myLeagueId, superiorLeagueId)
    if tiledSuperAlliesType == nil then
       --  ------print("tiledSuperAlliesType is Empty");
        return PowerType.Empty
    end
    local tiledType = tempUnitClickPanelType:TiledType(tiled)

    if tiledType == nil then
       -- ------print("tiledType is Empty");
        return PowerType.Empty
    end
    
    return tempUnitClickPanelType:GetTiledType(playerAlliesStateType, playerOccupyStateType, tiledOwnerType, tiledAlliesType, tiledSuperAlliesType, tiledType)
end

-- 刷新格子
function TiledManage:RefreshTiled(tiled)
    if tiled == nil then
        return;
    end
    if tiled.tiledInfo == nil then
        return;
    end
    if tiled._building ~= nil  then
        tiled._building._leagueId = tiled.tiledInfo.leagueId
    end
    local power = self:CalcPower(tiled.tiledInfo.ownerId, tiled.tiledInfo.leagueId, tiled.tiledInfo.superiorLeagueId, tiled);
    
    if power == nil then
        return;
    end
    -- 空
    if PowerType.Empty == power or power == PowerType.Null then
        self:_ReleaseTiled(tiled:GetImageTransform(LayerType.Power), LayerType.Power);
        tiled:ClearTransform(LayerType.Power)
        return;
    end
    local parent = self:_GetLayerParent(LayerType.Power);
    if parent == nil then
        return;
    end
    
    local tileTransform = tiled:GetImageTransform(LayerType.Power);

    if tileTransform == nil then
        local layerCache = self:GetLayerCache(LayerType.Power);
        layerCache:Load(parent, function ( tileImageObject )
            self:_OnShowPowerLayer(tileImageObject.transform, parent, tiled, power)
        end, "power"..tostring(tiled:GetIndex()));
        return;
    end
    
    self:_OnShowPowerLayer(tileTransform, parent, tiled, power);
end

-- 显示格子
function TiledManage:_OnShowPowerLayer(tileTransform, parent, tiled, power)
    if tileTransform == nil or tiled == nil then
        return;
    end
    
    -- ----------print(tileTransform.name)
    tileTransform.gameObject:SetActive(true);
    tileTransform.name = string.format("Power %04d X %04d", tiled:GetX(), tiled:GetY());
    -- tileTransform:SetParent(parent);
    tiled:SetTiledImage(LayerType.Power, tileTransform.gameObject);
    local finalImage = string.format( "power_%02d", power );
    local sprite = GameResFactory.Instance():GetResSprite(finalImage);
    tiled:SetSprite(LayerType.Power, sprite);
    tileTransform.localPosition = self:GetTiledPosition(tiled:GetX(), tiled:GetY());
    tileTransform.localScale = Vector3.one;
end

-- 刷新格子
function TiledManage:RefreshBuilding(tiled)
    self._mainCityManage:_HideTiled(tiled);
    self._mainCityManage:_ShowTiledLayer(tiled);
    self:_HandleBuildingResources(tiled:GetBuilding()._tiledId, 1)
    self:RefreshMapName(tiled);
end

-- 隐藏建筑
function TiledManage:HidePlayerBuilding(tiled)
    self._mainCityManage:_HideTiled(tiled);
    --self:_HandleBuildingResources(tiled:GetBuilding()._tiledId, 1)
    UIMapNameService:Instance():_HideTiledUILayer(tiled);
end

--升级
function TiledManage:RefreshFortBuilding(tiled)
    self._unitWildBuildingManage:_HideTiled(tiled)
    self._unitWildBuildingManage:_ShowTiledLayer(tiled)
    --self:_HandleBuildingResources(tiled:GetBuilding()._tiledId, 0)
    self:RefreshMapName(tiled);
end

function TiledManage:RefreshFortHideTiled(tiled)
    self._unitWildBuildingManage:_HideTiled(tiled)
    --self:_HandleBuildingResources(tiled:GetBuilding()._tiledId, 0)
    UIMapNameService:Instance():_HideTiledUILayer(tiled);
end

function TiledManage:RefreshMapName(tiled)
    UIMapNameService:Instance():_HideTiledUILayer(tiled);
    UIMapNameService:Instance():_ShowPlayerUILayer(tiled);
end

-- 刷新格子上部队状态提示
function TiledManage:RefreshArmyBehaviorState(tiled)
    if tiled == nil or tiled.tiledInfo == nil then
        if self._DrawObjectMap[tiled:GetIndex()] ~= nil then
            self._DrawLoadResourcesPrefab:Recovery(self._DrawObjectMap[tiled:GetIndex()])
            self._DrawObjectMap[tiled:GetIndex()] = nil;
        end
        return
    end
    local tiledId = tiled:GetIndex()
    local parent = self:_GetLayerParent(LayerType.Army);
    if parent == nil then
        return
    end
    local isHaveView = tiled.tiledInfo.isHaveView;
    -- 练兵、屯田（有本地块视野）
    if (tiled.tiledInfo.allTrainingArmyInfoList:Count() > 0 or tiled.tiledInfo.allMitaingArmyInfoList:Count() > 0 ) and isHaveView == true then
        if self.curCommonSlider[tiledId] == nil then
            local uiCommonSlider = require("Game/Common/UICommonSlider").new();
            GameResFactory.Instance():GetUIPrefab("UIPrefab/UICommonSlider", parent, uiCommonSlider,
                function (go) 
                    uiCommonSlider:Init();
                    if uiCommonSlider.gameObject then
                        self.curCommonSlider[tiledId] = uiCommonSlider;
                        uiCommonSlider.gameObject:SetActive(false);
                        self:_OnShowArmyLayer(uiCommonSlider.gameObject,tiled,false,false);
                    end 
                end 
            );
        else
            self:_OnShowArmyLayer(self.curCommonSlider[tiledId].gameObject,tiled,false,false);
        end
    else
        if self.curCommonSlider[tiledId] ~= nil then
            self.curCommonSlider[tiledId].gameObject:SetActive(false);
        end
    end

    -- 战平（有本地块视野或战平部队中包含友方部队）
    local isHaveDrawView = false;
    if tiled.tiledInfo.allDrawArmyInfoList:Count() > 0 then
        if isHaveView == true then
            isHaveDrawView = true;
        else
            for i = 1, tiled.tiledInfo.allDrawArmyInfoList:Count() do
                local armyInfoModel = tiled.tiledInfo.allDrawArmyInfoList:Get(i);
                if self:_JudgeArmyIsFriend(armyInfoModel) == true then
                    isHaveDrawView = true;
                end
            end
        end
    end
    if isHaveDrawView == true then
         if self.curCommonSlider[tiledId] == nil then
            local uiCommonSlider = require("Game/Common/UICommonSlider").new();
            GameResFactory.Instance():GetUIPrefab("UIPrefab/UICommonSlider", parent, uiCommonSlider,
                function (go) 
                    uiCommonSlider:Init();
                    self.curCommonSlider[tiledId] = uiCommonSlider;
                    self:_OnShowArmyLayer(uiCommonSlider.gameObject,tiled,true,false);                    
                end 
            );
        else
            self:_OnShowArmyLayer(self.curCommonSlider[tiledId].gameObject,tiled,true,false);
        end
    end
    -- 添加战平特效
    if isHaveDrawView == true then
        if self._drawEffectMap[tiledId] == nil then
            -- --print("添加战平特效")
            local position = self:GetTiledPosition(tiled:GetX(), tiled:GetY())
            local effect = EffectsService:Instance():AddEffect(parent, EffectsType.DrawEffect, 2, nil, position)
            self._drawEffectMap[tiledId] = effect
        end
    else
        if self._drawEffectMap[tiledId] ~= nil then
            -- --print("移除战平特效")
            EffectsService:Instance():RemoveEffect(self._drawEffectMap[tiledId])
            self._drawEffectMap[tiledId] = nil
        end
    end

    local parentBehaviour = self:_GetLayerParent(LayerType.Sign);
    if parentBehaviour == nil then
        return
    end
    -- 战平红点和战平标志
    if isHaveDrawView == true then
        if tiled.tiledInfo.allDrawArmyInfoList:Count() > 0 then
            if self._DrawObjectMap[tiledId] ~= nil then
                self:RefreshDrowTiled(self._DrawObjectMap[tiledId], tiled)
            else
                self._DrawLoadResourcesPrefab:SetResPath("Map/DrowLoad");
                self._DrawLoadResourcesPrefab:Load(parentBehaviour,function (DrawObj)
                    self._DrawObjectMap[tiledId] = DrawObj;
                    self:_OnShowDrowArmyLayer(DrawObj,tiled,false,true);
                    self:RefreshDrowTiled(self._DrawObjectMap[tiledId], tiled)
                end)
            end
        end
    else
        if self._DrawObjectMap[tiledId] ~= nil then
            self._DrawLoadResourcesPrefab:Recovery(self._DrawObjectMap[tiledId])
            self._DrawObjectMap[tiledId] = nil;
        end
    end

    --驻守红点 标记 
    if tiled.tiledInfo.allGarrisonArmyInfoList:Count() > 0 and isHaveView == true and self:_IsHaveGarrisoningCenter(tiled) == true then
        local parentBehaviour = self:_GetLayerParent(LayerType.UI);
        if self.garrisonRed[tiledId] ~= nil then
            self:RefreshGarrsionRedTiled(self.garrisonRed[tiledId], tiled)
        else
            self._GarrisonRedLoadResourcesPrefab:SetResPath("Map/GarrisoningRed")
            self._GarrisonRedLoadResourcesPrefab:Load(parentBehaviour, function (garrisonRed)
                self:RefreshGarrsionRedTiled(garrisonRed, tiled)
                self.garrisonRed[tiledId] = garrisonRed;
                self:_OnShowArmyLayer(garrisonRed,tiled,false,true)
            end)
        end
    else
        self._GarrisonRedLoadResourcesPrefab:Recovery(self.garrisonRed[tiledId])
        self.garrisonRed[tiledId] = nil
    end
end

-- 是否有练兵屯田部队
function TiledManage:IsHaveFarmmingOrTrainingArmy(tiled)
    if tiled == nil or tiled.tiledInfo == nil then
        return false
    end
    if tiled.tiledInfo.allTrainingArmyInfoList:Count() > 0 then
        return true
    end
    if tiled.tiledInfo.allMitaingArmyInfoList:Count() > 0 then
        return true
    end
    return false
end

-- 刷新战平部队图片
function TiledManage:RefreshDrowTiled(DrowObj,tiled)
    local count = self:_GetDrowCenterNum(tiled)
    local redPointObject = DrowObj.transform:Find("FortRedStart").gameObject
    local redPointObjectText = DrowObj.transform:Find("FortRedStart/CountText").gameObject
    local FightR = DrowObj.transform:Find("FightR").gameObject
    local FightG = DrowObj.transform:Find("FightG").gameObject
    local FightB = DrowObj.transform:Find("FightB").gameObject

    redPointObject:SetActive(true)
    redPointObjectText.text = count

    for i=1,count do
        local army = tiled.tiledInfo.allDrawArmyInfoList:Get(i)
        if self:IsHostility(army) == true then
            FightR:SetActive(false);
        else
            FightR:SetActive(true);
            redPointObject:SetActive(false)
        end
    end

    -- 除了敌方
    for i=1,count do
        local army = tiled.tiledInfo.allDrawArmyInfoList:Get(i)
        if self:IsOwnerFriend(army) == 1 then
            FightG:SetActive(true)
        elseif self:IsOwnerFriend(army) == 2 then
            FightB:SetActive(true);
        end
        if FightG.gameObject.activeSelf == true and FightB.gameObject.activeSelf == true then
            local position = DrowObj.transform.localPosition
            FightG.transform.localPosition = Vector3.New(position.x + 30 , position.y, 0)
        end
    end
end

-- 刷新驻守部队红点和标记图片
function TiledManage:RefreshGarrsionRedTiled(gassionObject, tiled)
    local count = self:_GetGarrsioningCenterNum(tiled)
    local RedPoint = gassionObject.transform:Find("RedPoint").gameObject
    local garrisonGImage = gassionObject.transform:Find("GarrisonGImage").gameObject
    local garrisonBImage = gassionObject.transform:Find("GarrisonBImage").gameObject
    local garrisonRImage = gassionObject.transform:Find("GarrisonRImage").gameObject

    if self:IsFriendTiled(tiled) then
        RedPoint:SetActive(true)
    else
        RedPoint:SetActive(false)
    end
    
    gassionObject.transform:Find("RedPoint/ArmyNum"):GetComponent(typeof(UnityEngine.UI.Text)).text = count
    
    -- 非友方部队 与 我方部队
    if self:IsFriendTiled(tiled) == false then
        garrisonRImage:SetActive(true);
    else
        garrisonRImage:SetActive(false);
    end

    -- 除了敌方
    for i=1,count do
        local army = tiled.tiledInfo.allGarrisonArmyInfoList:Get(i)
            if self:IsOwnerFriend(army) == 1 then
                garrisonGImage:SetActive(true)
            elseif self:IsOwnerFriend(army) == 2 then
                garrisonBImage:SetActive(true);
            end

            if garrisonGImage.gameObject.activeSelf == true and garrisonBImage.gameObject.activeSelf == true then
                local position = gassionObject.transform:Find("Center").transform.localPosition
                garrisonGImage.transform.localPosition = Vector3.New(position.x + 45 , position.y - 14, 0)
                -- garrisonBImage.transform.localPosition = Vector3.New(position.x, position.y, 0)
            end
    end
end

-- 刷新部队数量
function TiledManage:RefreshArmyNum(gassionObject, armyNum)
    gassionObject.transform:Find("Center/RedPoint/ArmyNum"):GetComponent(typeof(UnityEngine.UI.Text)).text = armyNum
end

-- 获取驻守在中心地块的部队数量
function TiledManage:_GetGarrsioningCenterNum(tiled)
    if tiled == nil or tiled.tiledInfo == nil then
        return 0
    end
    local armyNum = 0
    local count = tiled.tiledInfo.allGarrisonArmyInfoList:Count()
    for i = 1, count do
        local army = tiled.tiledInfo.allGarrisonArmyInfoList:Get(i)
        if army == nil then
            return false
        end
        if army.tiledId == tiled._index then
            armyNum = armyNum + 1
        end
    end
    return armyNum
end

-- 获得战平数量
function TiledManage:_GetDrowCenterNum(tiled)
    if tiled == nil or tiled.tiledInfo == nil then
        return 0;
    end
    local armyNum = 0;
    local count = tiled.tiledInfo.allDrawArmyInfoList:Count()
    for i=1,count do
        local army =  tiled.tiledInfo.allDrawArmyInfoList:Get(i)
        if army == nil then
            return false
        end
        if army.tiledId == tiled._index then
            armyNum = armyNum + 1
        end
    end
    return armyNum
end

-- 是否是驻守中心地块
function TiledManage:_IsHaveGarrisoningCenter(tiled)
    if tiled == nil or tiled.tiledInfo == nil then
        return false
    end
    local count = tiled.tiledInfo.allGarrisonArmyInfoList:Count()
    for i = 1, count do
        local army = tiled.tiledInfo.allGarrisonArmyInfoList:Get(i)
        if army == nil then
            return false
        end
        if army.tiledId == tiled._index then
            return true
        end
    end
    return false
end


-- 地块上是否有部队
function TiledManage:_IsHaveArmyOnTiled(tiled)
    if tiled == nil or tiled.tiledInfo == nil then
        return false
    end
    if tiled.tiledInfo.allGarrisonArmyInfoList:Count() > 0 then
        return true
    end
    if tiled.tiledInfo.allTrainingArmyInfoList:Count() > 0 then
        return true
    end
    if tiled.tiledInfo.allMitaingArmyInfoList:Count() > 0 then
        return true
    end
    if tiled.tiledInfo.allDrawArmyInfoList:Count() > 0 then
        return true
    end
    return false
end

-- 判断部队是否为友方部队
function TiledManage:_JudgeArmyIsFriend(armyInfoModel)
    local myPlayerId = PlayerService:Instance():GetPlayerId();
    if armyInfoModel.playerID == myPlayerId then
        return true;
    end

    local myLeagueId = PlayerService:Instance():GetLeagueId();
    if myLeagueId == 0 then
        return false;
    end

    if armyInfoModel.leagueID == myLeagueId and armyInfoModel.superiorLeagueID == 0 then
        return true;
    end

    if armyInfoModel.superiorLeagueID == myLeagueId then
        return true;
    end

    return false;
end

-- 驻守图标 
function TiledManage:IsOwnerFriend(armyInfoModel)
    local myPlayerId = PlayerService:Instance():GetPlayerId();
    local myLeagueId = PlayerService:Instance():GetLeagueId();
    if armyInfoModel.playerID == myPlayerId then
        return 1;
    end

    if armyInfoModel.playerID ~= myPlayerId and myLeagueId ~= 0 and myLeagueId == armyInfoModel.leagueID then
        return 2
    end

    if armyInfoModel.playerID ~= myPlayerId and armyInfoModel.superiorLeagueID ~= 0 and myLeagueId == armyInfoModel.leagueID then
        return 2
    end
    return 0;
end


function TiledManage:IsHostility(armyInfoModel)
    local myPlayerId = PlayerService:Instance():GetPlayerId();
    local myLeagueId = PlayerService:Instance():GetLeagueId();
    if armyInfoModel.playerID == myPlayerId then
        return true;
    end
    if armyInfoModel.playerID ~= myPlayerId and myLeagueId ~= 0 and myLeagueId == armyInfoModel.leagueID then
        return true
    end

    if armyInfoModel.playerID ~= myPlayerId and armyInfoModel.superiorLeagueID ~= 0 and myLeagueId == armyInfoModel.leagueID then
        return true
    end
    return false

end



function TiledManage:BuildingOrder()
    
end

-- 显示部队行为层(练兵、屯田)
-- isBattle : 是否战平
-- isDefend : 是否是驻守
function TiledManage:_OnShowArmyLayer(sliderObject,tiled,isBattleAverage,isDefend,isUnBattle)
    tiled:SetTiledImage(LayerType.Army, sliderObject.transform);
    sliderObject.transform.localPosition = self:GetTiledPosition(tiled:GetX(), tiled:GetY());
    sliderObject.transform.localScale = Vector3.New(1.52,1.52,1.52);
    if (isDefend ~= nil and isDefend == true) or (isUnBattle ~= nil and isUnBattle == true) then
        return;
    end
    self:CheckShowArmyTimes(tiled,isBattleAverage);
end

-- 战平
function TiledManage:_OnShowDrowArmyLayer(sliderObject,tiled,isBattleAverage,isDefend,isUnBattle)
    tiled:SetTiledImage(LayerType.Army, sliderObject.transform);
    local position = self:GetTiledPosition(tiled:GetX(), tiled:GetY())
    sliderObject.transform.localPosition = Vector3.New(position.x - 100 , position.y - 35, 0)
    sliderObject.transform.localScale = Vector3.New(1.52,1.52,1.52);
    if (isDefend ~= nil and isDefend == true) or (isUnBattle ~= nil and isUnBattle == true) then
        return;
    end
    self:CheckShowArmyTimes(tiled,isBattleAverage);
end



--检测显示格子上的倒计时(练兵、屯田,战平)
function TiledManage:CheckShowArmyTimes(tiled,isBattle)
    local showArmyInfo = self:GetShowTimeArmy(tiled,isBattle,false);
    local tiledId = tiled:GetIndex();
    if showArmyInfo == nil then
        if self.curCommonSlider[tiledId] ~= nil then
            self.curCommonSlider[tiledId].gameObject:SetActive(false);
        end
        if self.curArmyBehaviourTwoObj[tiledId] ~= nil then
            -- self.curArmyBehaviourTwoObj[tiledId]:SetActive(false);
        end
        return;
    end
    if self.curCommonSlider[tiledId] == nil then
        return;
    end
    local curTimeStamp = PlayerService:Instance():GetLocalTime();
    if tiled.tiledInfo.ownerId == PlayerService:Instance():GetPlayerId() then
        if isBattle == false then
            --LogManager:Instance():Log("显示屯田或者练兵， 获取显示的地块上的部队信息 屯田练兵时间： "..showArmyInfo.farmmingStartTime.." "..showArmyInfo.farmmingEndTime.." "..showArmyInfo.trainingStartTime.." "..showArmyInfo.trainingEndTime.." "..showArmyInfo.battleStartTime.." "..showArmyInfo.battleEndTime)
            if showArmyInfo:GetArmyState() == ArmyState.MitaIng then
                if showArmyInfo.tiledId == tiledId then
                    self.curCommonSlider[tiledId]:ShowTimes(CommonSliderType.ArmyFarming,showArmyInfo.farmmingStartTime,showArmyInfo.farmmingEndTime,function() self:CheckShowArmyTimes(tiled,isBattle) end,true);
                else
                    self.curCommonSlider[tiledId]:ShowTimes(CommonSliderType.ArmyFarming,showArmyInfo.farmmingStartTime,showArmyInfo.farmmingEndTime,function() self:CheckShowArmyTimes(tiled,isBattle) end,false);         
                end        
            elseif showArmyInfo:GetArmyState() == ArmyState.Training then
                self.curCommonSlider[tiledId]:ShowTimes(CommonSliderType.ArmyTraining,showArmyInfo.trainingStartTime,showArmyInfo.trainingEndTime,function() self:CheckShowArmyTimes(tiled,isBattle) end,true);
            end
        end
    else
            -- print("!!!!!!!!!!!!!!!!!!!!!!!"..showArmyInfo:GetArmyState().."   "..showArmyInfo.battleEndTime-showArmyInfo.battleStartTime)
        if showArmyInfo:GetArmyState() == ArmyState.BattleIng then
            self.curCommonSlider[tiledId]:ShowTimes(CommonSliderType.ArmyBattleing,showArmyInfo.battleStartTime,showArmyInfo.battleEndTime,function() self:CheckShowArmyTimes(tiled,isBattle) end,true);
        end
    end
end

-- 获取当前需要显示倒计时的部队（取练兵、屯田列表中开始时间最早的并且屯田的时候是中心地块的.战平是单独的直接取最早的）
function TiledManage:GetShowTimeArmy(tiled,isBattle,isArround)
    if isBattle == false then
        if tiled.tiledInfo.allMitaingArmyInfoList:Count() == 0 and  tiled.tiledInfo.allTrainingArmyInfoList:Count() == 0 then
            return nil;
        end
        if tiled.tiledInfo.allMitaingArmyInfoList:Count()>1 then
            table.sort(tiled.tiledInfo.allMitaingArmyInfoList, function(a, b) return self:GetInTiledArmyInfo(a).farmmingStartTime > self:GetInTiledArmyInfo(b).farmmingStartTime end);
        end
        if tiled.tiledInfo.allTrainingArmyInfoList:Count()>1 then
            table.sort(tiled.tiledInfo.allTrainingArmyInfoList, function(a, b) return self:GetInTiledArmyInfo(a).trainingStartTime > self:GetInTiledArmyInfo(b).trainingStartTime end);
        end
        local farmmingArmy = self:GetFirstInTiledArmyInfo(tiled,tiled.tiledInfo.allMitaingArmyInfoList,true,isArround);
        local trainingArmy = self:GetFirstInTiledArmyInfo(tiled,tiled.tiledInfo.allTrainingArmyInfoList,false,isArround);
        if farmmingArmy ~= nil and trainingArmy == nil then
            return farmmingArmy;
        elseif farmmingArmy == nil and trainingArmy ~= nil then
            return trainingArmy;
        elseif farmmingArmy ~= nil and trainingArmy ~= nil then
            local minTime = math.min(farmmingArmy.farmmingStartTime,trainingArmy.trainingStartTime);
            if farmmingArmy.farmmingStartTime == minTime then
                return farmmingArmy;
            else
                return trainingArmy;
            end
        end
    else
        if tiled.tiledInfo.allDrawArmyInfoList:Count()>1 then
            table.sort(tiled.tiledInfo.allDrawArmyInfoList, function(a, b) return self:GetInTiledArmyInfo(a).farmmingStartTime < self:GetInTiledArmyInfo(b).farmmingStartTime end)
        end
        return  self:GetInTiledArmyInfo(tiled.tiledInfo.allDrawArmyInfoList:Get(1));
    end
end

--armyModelInfo:  消息体 ArmyInfoModel
function TiledManage:GetInTiledArmyInfo(armyModelInfo)
    if armyModelInfo == nil then
        return nil;
    end
    local building = BuildingService:Instance():GetBuilding(armyModelInfo.buildingID);
    if building == nil then
        return nil;
    end
    local showArmyInfo = building:GetArmyInfo(armyModelInfo.slotIndex+1);
    if showArmyInfo ~= nil then
        return showArmyInfo;
    else
        return nil;
    end
end

--armyModelInfo:  消息体 ArmyInfoModel
--isFarming 是否是屯田
function TiledManage:GetFirstInTiledArmyInfo(tiled,armyModelInfoList,isFarming,isArround)
    if armyModelInfoList:Count() == 0 then 
        return nil;
    end
    for i=1,armyModelInfoList:Count() do
        local armyModelInfo = armyModelInfoList:Get(i);
        if armyModelInfo == nil then
            return nil;
        end
        local building = BuildingService:Instance():GetBuilding(armyModelInfo.buildingID);
        if building == nil then
            return nil;
        end
        local showArmyInfo = building:GetArmyInfo(armyModelInfo.slotIndex+1);
        if showArmyInfo ~= nil then
            if isFarming == false then
                return showArmyInfo;
            else
                if isArround == true then
                    return showArmyInfo;
                else
                    if showArmyInfo.tiledId == tiled:GetIndex() then
                        return showArmyInfo;
                    end
                end
            end
        end
    end
    return nil;
end

-- 获取城中心DataTile
function TiledManage:_GetBuildingDataTile(tiled)
    if tiled == nil then
        return nil
    end
    local building = tiled:GetBuilding()
    if building == nil then
        return nil
    end
    if building._dataInfo == nil then 
        return nil;
    end
    
    local tiledInfo = DataTile[building._dataInfo.CenterTileID]
    return tiledInfo
end

-- 获取城区DataTile
function TiledManage:_GetBuildingTownDataTile(tiled)
    if tiled == nil then
        return nil
    end
    local town = tiled._town--:GetTown()
    if town == nil then
        return nil
    end
    local building = town._building
    if building == nil then
        return nil
    end
    local tiledInfo = DataTile[building._dataInfo.OuterRingTileID]
    return tiledInfo
end

-- 获取表中格子耐久
function TiledManage:_GetTiledDurableVal(tiled)
    local durableVal = 0
    local tiledInfo = self:_GetDataTiled(tiled)

    if tiledInfo == nil then
        return 0
    end
    if tiled.tiledInfo == nil then
        return tiledInfo.Durability
    end
    if tiled.tiledInfo.ownerId ~= 0 then
        return tiledInfo.DurabilitySeized
    else
        return tiledInfo.Durability
    end
    return durableVal
end

--获取格子的dataTile
function TiledManage:_GetDataTiled(tiled)
    local tiledInfo = tiled:GetResource()
    ----------print(tiledInfo)
    local town = tiled:GetTown()
    if town ~= nil then
        local building = town._building
        if building ~= nil then
            return self:_GetBuildingTownDataTile(tiled)
        end
    end
    local building = tiled:GetBuilding()
    if building ~= nil and town == nil then
        return self:_GetBuildingDataTile(tiled)
    end
    return tiledInfo
end

function TiledManage:ChangeScreenCenter(x, y, loadComplete)
    MapLoad:ModifyScreenCenter(x, y, loadComplete);
end

-- 显示放弃土地时间
function TiledManage:ShowGiveUpTime( tiled )
    if tiled == nil or tiled.tiledInfo == nil then
        return
    end
    self:ShowTiledTimeBox( tiled.tiledInfo.giveUpLandTime, tiled, LayerType.Army )
end

-- 显示倒计时框
function TiledManage:ShowTiledTimeBox( time, tiled , layerType)
    if tiled == nil or tiled.tiledInfo == nil then
        return
    end
    local tiledId = tiled:GetIndex()
    local parent = self:_GetLayerParent(layerType);
    if parent == nil then
        return
    end
    local localTime = PlayerService:Instance():GetLocalTime()
    if localTime < time and self:IsHaveFarmmingOrTrainingArmy(tiled) == false and self:IsMyTiled(tiled) then
        if self._timeBoxObjectMap[tiledId] ~= nil then
            self._timeBoxObjectMap[tiledId]:SetActive(true)
            return
        else
            self._timeBoxLoadResourcesPrefab:SetResPath("UIPrefab/GiveUpLandTime")
            self._timeBoxLoadResourcesPrefab:Load(parent, function (timeBoxObject)
                timeBoxObject.gameObject:SetActive(true)
                local position = self:GetTiledPosition(tiled:GetX(), tiled:GetY())
                timeBoxObject.transform.localPosition = Vector3.New(position.x, position.y - 80, 0)
                timeBoxObject.transform.localScale = Vector3.one;
                self:ShowTime( time, localTime, timeBoxObject, tiledId )
                self._timeBoxObjectMap[tiledId] = timeBoxObject
            end)
        end
    else
        self._timeBoxLoadResourcesPrefab:Recovery(self._timeBoxObjectMap[tiledId])
        self._timeBoxObjectMap[tiledId] = nil

    end
end

-- 显示时间
function TiledManage:ShowTime( time, localTime, timeBoxObject, tiledId )
    --------print("放弃土地")
    local timeText = timeBoxObject.transform:Find("TimeBox").gameObject:GetComponent(typeof(UnityEngine.UI.Text))
    local needTime = time - localTime;
    self.slider = timeBoxObject.transform:Find("Slider").gameObject:GetComponent(typeof(UnityEngine.UI.Slider));
    self.slider.value =(needTime - localTime) / needTime;
    local cdTime = math.floor((time - localTime)/1000);
    timeText.text = CommonService:Instance():GetDateString(cdTime);
    CommonService:Instance():TimeDown(nil,time,timeText,function() self:GiveUpLandEnd(timeBoxObject, tiledId) end,self.slider,needTime);
end

-- 放弃土地结束
function TiledManage:GiveUpLandEnd(timeBoxObject, tiledId)
    --------print("放弃土地结束")
    timeBoxObject.gameObject:SetActive(false);
    local baseClass = UIService:Instance():GetUIClass(UIType.UIBuild);
    local isOpen =  UIService:Instance():GetOpenedUI(UIType.UIBuild);
    if baseClass ~= nil and isOpen == true then
        UIService:Instance():HideUI(UIType.UIBuild);
    end
    self._timeBoxLoadResourcesPrefab:Recovery(self._timeBoxObjectMap[tiledId])
    self._timeBoxObjectMap[tiledId] = nil

    --更新主界面所有的资源产量
    -- local mainBaseClass = UIService:Instance():GetUIClass(UIType.UIBuild);
    -- if mainBaseClass ~= nil then 
    --     mainBaseClass:SetResource();
    -- end 
end

-- 是否在放弃土地时间内
function TiledManage:IsGiveUpTiledInterval( tiled )
    if tiled == nil or tiled.tiledInfo == nil then
        return false
    end
    local localTime = PlayerService:Instance():GetLocalTime()
    local giveUpTime = tiled.tiledInfo.giveUpLandTime
    if localTime <= giveUpTime then
        return true
    end
    return false
end

-- 显示倒计时框
function TiledManage:ShowFortTimeBox( time, tiled , layerType)
    if tiled == nil or tiled.tiledInfo == nil then
        return
    end
    if tiled.tiledInfo.ownerId ~= PlayerService:Instance():GetPlayerId() then
        return
    end
    local tiledId = tiled:GetIndex()
    local parent = self:_GetLayerParent(layerType);
    if parent == nil then
        return
    end
    local localTime = PlayerService:Instance():GetLocalTime()
    if localTime < time then
        if self._FortTimerBox[tiledId] ~= nil then
            self._FortTimerBox[tiledId]:SetActive(true)
            return
        else
            self._deleteFortTimeBox:SetResPath("UIPrefab/GiveUpFortTime")
            self._deleteFortTimeBox:Load(parent, function (timeBoxObject)
                timeBoxObject.gameObject:SetActive(true)
                local position = self:GetTiledPosition(tiled:GetX(), tiled:GetY())
                timeBoxObject.transform.localPosition = Vector3.New(position.x, position.y - 80, 0)
                timeBoxObject.transform.localScale = Vector3.one;
                timeBoxObject.transform:SetAsLastSibling();
                self:ShowTimes( time, localTime, timeBoxObject, tiledId )
                self._FortTimerBox[tiledId] = timeBoxObject
            end)
        end
    else
        self._deleteFortTimeBox:Recovery(self._FortTimerBox[tiledId])
        self._FortTimerBox[tiledId] = nil
    end
end
-- 取消放弃回收预制
function TiledManage:HideFortTimeBox(tiledId)
    self._deleteFortTimeBox:Recovery(self._FortTimerBox[tiledId])
    self._FortTimerBox[tiledId] = nil
end

-- 显示时间
function TiledManage:ShowTimes( time, localTime, timeBoxObject, tiledId )
    local timeText = timeBoxObject.transform:Find("TimeBox").gameObject:GetComponent(typeof(UnityEngine.UI.Text))
    local cdTime = math.floor((time - localTime)/1000);
    timeText.text = CommonService:Instance():GetDateString(cdTime);
    CommonService:Instance():TimeDown(nil,time,timeText, function() self:HideBox(timeBoxObject, tiledId) end);

end
function TiledManage:HideBox(timeBoxObject, tiledId)
    --------print("隐藏了")
    timeBoxObject.gameObject:SetActive(false);
    self._deleteFortTimeBox:Recovery(self._FortTimerBox[tiledId])
    self._FortTimerBox[tiledId] = nil
end

-- 是否蓝色的呼吸框
function TiledManage:IsBlueBreathingBox( tiled )
    if tiled == nil or tiled.tiledInfo == nil then
        return false
    end
    local myId = PlayerService:Instance():GetPlayerId()
    local mySuperiorLeagueId = PlayerService:Instance():GetsuperiorLeagueId()

    local ownerId = tiled.tiledInfo.ownerId

    if mySuperiorLeagueId ~= 0 then 
        --  我被沦陷
        if ownerId ~= 0 then
            if ownerId == myId then
                return true
            end
        else
            if self:IsHaveMyTiledAround(tiled, myId) then
                return true
            end
        end

    else
        -- 我没有被沦陷
        if ownerId ~= 0 then
            if self:IsFriendTiled(tiled) then
                return true
            end
        else
            if self:IsHaveFriendTiledAround(tiled) then
                return true
            end
        end
    end
    return false
end

-- 检测周围是否有我的地
function TiledManage:IsHaveMyTiledAround( tiled, myId )
    if tiled == nil then
        return false
    end
    local x, y = self:GetTiledCoordinate(tiled._index)

    for i = x - 1, x + 1 do
        for j = y - 1, y + 1 do
            while true do
                local tempIndex = self:GetTiledIndex(i, j)
                local tempTiled = self:GetTiledByIndex(tempIndex)
                if tempTiled == nil or tempTiled.tiledInfo == nil then
                    break
                end
                if tempTiled.tiledInfo.ownerId == myId then
                    return true
                end
                break
            end
        end
    end
    return false
end

-- 周围是否有友方地块
function TiledManage:IsHaveFriendTiledAround( tiled )
    if tiled == nil then
        return false
    end
    local x, y = self:GetTiledCoordinate(tiled._index)

    for i = x - 1, x + 1 do
        for j = y - 1, y + 1 do
            local tempIndex = self:GetTiledIndex(i, j)
            local tempTiled = self:GetTiledByIndex(tempIndex)
            if self:IsFriendTiled(tempTiled) then
                return true
            end
        end
    end
    return false
end


-- 判断是否为友方的地块(地块是自己的、未被沦陷的盟友的、下属盟成员的)
function TiledManage:IsFriendTiled(tiled)
    if tiled == nil or tiled.tiledInfo == nil then
        return false
    end
    local tempOwnerId = tiled.tiledInfo.ownerId
    local tempSuperiorLeagueId = tiled.tiledInfo.superiorLeagueId
    local tempOwnerLeagueId = tiled.tiledInfo.leagueId

    local myId = PlayerService:Instance():GetPlayerId()
    local myLeagueId = PlayerService:Instance():GetLeagueId()
    local mySuperiorLeagueId = PlayerService:Instance():GetsuperiorLeagueId()

    if tempOwnerId == myId then
        return true
    end
    if tempOwnerId ~= myId and tempSuperiorLeagueId == 0 and tempOwnerLeagueId ~= 0 and tempOwnerLeagueId == myLeagueId then
        return true
    end
    if tempOwnerId ~= myId and tempSuperiorLeagueId ~= 0 and tempSuperiorLeagueId == myLeagueId then
        return true
    end
    return false
end

-- 是否是我的土地
function TiledManage:IsMyTiled(tiled)
    if tiled == nil or tiled.tiledInfo == nil then
        return false
    end
    local ownerId = tiled.tiledInfo.ownerId
    local myId = PlayerService:Instance():GetPlayerId()
    if ownerId == myId then
        return true
    end
    return false
end

-- 获取一块地屯田收益
function TiledManage:GetTiledFarmmingAccount(tiled, currencyEnum)
    if tiled == nil then
        return 0
    end
    if tiled.tiledInfo == nil then
        return 0
    end
    local farmmingAccount = 0
    for i = tiled._x - 1, tiled._x + 1 do
        for j = tiled._y - 1, tiled._y + 1 do
            while true do
                local index = MapService:Instance():GetTiledIndex(i, j)
                local tempTiled = MapService:Instance():GetTiledByIndex(index)
                if tempTiled == nil then
                    break
                end
                if tempTiled.tiledInfo == nil then
                    break
                end
                if PlayerService:Instance():GetPlayerId() ~= tempTiled.tiledInfo.ownerId or tempTiled._building ~= nil or tempTiled._town ~= nil then
                        break
                    end
                if i == tiled._x and j == tiled._y then
                    farmmingAccount = farmmingAccount + self:GetResourceProduction(tempTiled, currencyEnum)
                else
                    farmmingAccount = farmmingAccount + self:GetResourceProduction(tempTiled, currencyEnum) * 0.15
                end
                break
            end
        end
    end
    return math.floor(farmmingAccount)
end

-- 获取资源地资源产量
function TiledManage:GetResourceProduction(tiled, currencyEnum)
    if tiled == nil then
        return 0
    end
    if tiled._resource == nil then
        return 0
    end
    if currencyEnum == CurrencyEnum.Wood then
        local rate = self:GetFacilityLevAddition(CurrencyEnum.Wood)
        return math.floor((tiled._resource.Wood * tiled._resource.FarmingFactor * 12 / 10000) * (1 + rate / 10000))
    elseif currencyEnum == CurrencyEnum.Iron then
        local rate = self:GetFacilityLevAddition(CurrencyEnum.Iron)
        return math.floor((tiled._resource.Iron * tiled._resource.FarmingFactor * 12 / 10000) * (1 + rate / 10000))
    elseif currencyEnum == CurrencyEnum.Stone then
        local rate = self:GetFacilityLevAddition(CurrencyEnum.Stone)
        return math.floor((tiled._resource.Stone * tiled._resource.FarmingFactor * 12 / 10000) * (1 + rate / 10000))
    elseif currencyEnum == CurrencyEnum.Grain then
        local rate = self:GetFacilityLevAddition(CurrencyEnum.Grain)
        return math.floor((tiled._resource.Food * tiled._resource.FarmingFactor * 12 / 10000) * (1 + rate / 10000))
    end
    return 0
end

-- 获取设施等级加成
function TiledManage:GetFacilityLevAddition(currencyEnum)
    local buildingId = PlayerService:Instance():GetmainCityId()
    if currencyEnum == CurrencyEnum.Wood then
        return FacilityService:Instance():GetCityMaxLevelFacilityProperty(buildingId, MaxLevelFacilityProperty.HoardGetWood)
    elseif currencyEnum == CurrencyEnum.Iron then
        return FacilityService:Instance():GetCityMaxLevelFacilityProperty(buildingId, MaxLevelFacilityProperty.HoardGetIron)
    elseif currencyEnum == CurrencyEnum.Stone then
        return FacilityService:Instance():GetCityMaxLevelFacilityProperty(buildingId, MaxLevelFacilityProperty.HoardGetGarin)
    elseif currencyEnum == CurrencyEnum.Grain then
        return FacilityService:Instance():GetCityMaxLevelFacilityProperty(buildingId, MaxLevelFacilityProperty.DurableMax)
    end
    return 0
end

-- 显示地块状态
function TiledManage:ShowTiledState(tiled)
    local myPlayerId = PlayerService:Instance():GetPlayerId()
    if tiled.tiledInfo.guideAvoidWarOwnerId == myPlayerId then
        return  --用于新手引导的土地
    end
    local avoidState = self._unitTileStateType:GetAvoidWarState(tiled)
    local garrisonCenterState = self._unitTileStateType:GetGarrisonCenterState(tiled)
    local garrisonOuterState = self._unitTileStateType:GetGarrisonOuterState(tiled)
    local mitaCenterState = self._unitTileStateType:GetMitaCenterState(tiled)
    local mitaOuterState = self._unitTileStateType:GetMitaOuterState(tiled)
    local trainingState = self._unitTileStateType:GetTrainingState(tiled)
    local buildingState = self._unitTileStateType:GetBuildingState(tiled)
    local fortState = self._unitTileStateType:GetFortState(tiled)
    self:RecoveryTiledState(tiled)  -- 清空格子上的状态
    local tiledTypeMap = self._unitTileStateType:GetTileTypeString(avoidState, garrisonCenterState, garrisonOuterState, mitaCenterState, mitaOuterState, trainingState, buildingState, fortState)
    local isHaveView = tiled.tiledInfo.isHaveView
    local tiledTypeStr = ""
    if isHaveView then
        tiledTypeStr = tiledTypeMap.haveView
    else
        tiledTypeStr = tiledTypeMap.haveNoView
    end
    if tiledTypeStr == "" then
        return
    end
    local tiledTypeArr = self:Split(tiledTypeStr, "|")
    for i = 1, #tiledTypeArr do
        self:ShowTiledStateImg(tiled, tiledTypeArr[i])
    end
end

-- 回收格子上的状态显示
function TiledManage:RecoveryTiledState(tiled)
    local objectArr = self._tiledStateMap[tiled._index]
    if objectArr == nil then
        return
    end
    for i = 1, #objectArr do
        self._tiledStatePrefab:Recovery(objectArr[i].transform)
    end
    for j = #objectArr, 1, -1 do
        table.remove(objectArr, j)
    end
end

-- 显示格子图片
function TiledManage:ShowTiledStateImg(tiled, imgName)
    local parent = self:_GetLayerParent(LayerType.ArmyBehaviourTwo)
    self._tiledStatePrefab:SetResPath("Map/TileImage")
    self._tiledStatePrefab:Load(parent, function(go)
        self:SaveTiledStateObject(go, tiled._index)
        self:SetTiledStateObject(go, tiled, imgName)
    end)
end

-- 设置预制位置及图片
function TiledManage:SetTiledStateObject(object, tiled, imgName)
    object.transform.localPosition = self:GetTiledPosition(tiled:GetX(), tiled:GetY())
    object:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(imgName); 
    object:GetComponent(typeof(UnityEngine.UI.Image)):SetNativeSize();
end

-- 保存显示状态预制
function TiledManage:SaveTiledStateObject(object, tiledId)
    local objectArr = self._tiledStateMap[tiledId]
    if objectArr ~= nil then
        table.insert(objectArr, object)
    else
        local arr = {}
        table.insert(arr, object)
        self._tiledStateMap[tiledId] = arr
    end
end

-- 分割字符串
function TiledManage:Split(str, separator)
    local sIndex = 1
    local splitIndex = 1
    local splitArr = {}
    while true do
        local eIndex = string.find(str, separator, sIndex)
        if not eIndex then
            splitArr[splitIndex] = string.sub(str, sIndex, string.len(str))
            break
        end
        splitArr[splitIndex] = string.sub(str, sIndex, eIndex - 1)
        sIndex = eIndex + string.len(separator)
        splitIndex = splitIndex + 1
    end
    return splitArr
end

function TiledManage:UpdateMyTiledDura(tiledInfo)
    if tiledInfo == nil then
        return;
    end

    if tiledInfo.ownerId ~= nil and tiledInfo.ownerId ~= PlayerService:Instance():GetPlayerId() then
        return;
    end

    local tiledDura = self._allMyTiledDuraMap[tiledInfo.tiledId + 1];
    if tiledDura == nil then
        tiledDura = TiledDuration.new();
        self._allMyTiledDuraMap[tiledInfo.tiledId + 1] = tiledDura;
    end
    if tiledDura ~= nil then
        tiledDura:SetDurableVar(tiledInfo.curDurableVal, tiledInfo.maxDurableVal, 60000);
    end
end

function TiledManage:GetMyTiledDura(tiledIndex)
    local tiledDura = self._allMyTiledDuraMap[tiledIndex + 1];
    if tiledDura ~= nil then
        return tiledDura:GetDurable();
    end

    return 0;
end

function TiledManage:GetMyTiledMaxDura(tiledIndex)
    local tiledDura = self._allMyTiledDuraMap[tiledIndex + 1];
    if tiledDura ~= nil then
        return tiledDura:GetMaxDuration();
    end

    return 0;
end

return TiledManage
