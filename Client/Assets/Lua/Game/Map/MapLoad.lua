-- 地图块
MapLoad = class("MapLoad")
-- local SceneConfig = require("Game/Map/SceneConfig")
local LayerType = require("Game/Map/LayerType")

-- 构造函数
function MapLoad:ctor()
end

-- 初始化地图
function MapLoad:InitMap(loadComplete)
    self.byteArray = ByteArray.New();
    self.width = 0;
    self.height = 0;
    self.regionEdge = 0;
    self.regionSize = 0;
    self.allLayerTileList = require("common/List").new();
    self.allBuildingList = require("common/List").new();
    self.allLayerDataMap = {};
    self.centerX = -1;
    self.centerY = -1;
    self.allStateMap = {};

    self:LoadMap(loadComplete);

    self._imageWidth = 400;
    self._imageHeight = 400;

    self.dataMap = {};
    --上限
    self.dataSize = 0;
end

-- 关闭地图
function MapLoad:CloseMap()
    -- SceneConfig = nil;
end

-- 宽
function MapLoad:GetWidth()
    return self.width;
end

-- 高
function MapLoad:GetHeight()
    return self.width;
end

-- 宽
function MapLoad:GetTiledWidth()
    return self.tiledWidth;
end

-- 高
function MapLoad:GetTiledHeight()
    return self.tiledHight;
end

-- 加载地表
function MapLoad:GetTerrain( layerType, index )
    if LayerType.State == layerType then
        return self.allStateMap[index + 1];
    end

    local layerData = self:FindLayerData(layerType);
    if layerData == nil then
        return 0;
    end
    

    -- readPos += sizeof(short);
    -- self.byteArray:ReadInt16ByIndex()
    -- print(layerData[index + 1]);
    return layerData[index + 1];
end

-- 加载地表
function MapLoad:GetBuilding(index)
    return self.allBuildingList:Get(index);
end

-- 获取建筑物的数量
function MapLoad:GetBuildingCount()
    return self.allBuildingList:Count();
end

-- 获取格子的种类数量
function MapLoad:GetTileCount()
    return self.allLayerTileList:Count();
end

-- 获取格子的名称
function MapLoad:GetTileName(index)
    if index < 0 or index > self:GetTileCount() then
        return "";
    end

    local name = string.lower( self.allLayerTileList:Get(index).name);
    return name;
end

-- 获取格子的名称
function MapLoad:GetTileFirstGId(index)
    if index < 0 or index > self:GetTileCount() then
        return 0;
    end

    return self.allLayerTileList:Get(index).firstgid;
end

-- 获取格子的名称
function MapLoad:GetTileNumbers(index)
    if index < 0 or index > self:GetTileCount() then
        return 0;
    end

    return self.allLayerTileList:Get(index).tileCount;
end

-- 获取格子的宽
function MapLoad:GetTileWidth(index)
    return 400;
end

-- 获取格子的高
function MapLoad:GetTileHeight(index)
    return 400;
end

-- 加载地图文件
function MapLoad:LoadMap(loadComplete)
    GameResFactory.Instance():ReadFile("data/map.data", function( mapData )
        self.byteArray:Reset();
        self.byteArray:InitBytes(mapData);
        self:ReadTop();
        self:ReadAllLayer();
        self:ReadAllBuilding();
        -- print("Width: " .. self.width .. "; Height: " .. self.height);
        self:LoadState(loadComplete);
    end);
end

-- 读取州文件
function MapLoad:LoadState(loadComplete)
    GameResFactory.Instance():ReadFile("data/state.data", function( stateData )
        for i= 0, self.width - 1, 1 do
            self.byteArray:Reset();
            self.byteArray:InitBytes(stateData, i * self.width * 2, self.width * 2);
            for j = 0, self.height - 1 , 1 do
                self.allStateMap[i * self.width + j + 1] = self.byteArray:ReadInt16();
            end
        end
        -- self:LoadState(loadComplete);
        loadComplete();
    end);
end

-- 读取头部
function MapLoad:ReadTop()
    local size = self.byteArray:ReadInt32();
    self.width = self.byteArray:ReadInt32();
    self.height = self.byteArray:ReadInt32();
    self.tiledWidth = self.byteArray:ReadInt32();
    self.tiledHight = self.byteArray:ReadInt32();
    self.regionEdge = self.byteArray:ReadInt32();
    self.regionSize = self.byteArray:ReadInt32();
end

-- 加载所有的层
function MapLoad:ReadAllLayer()
    local count = self.byteArray:ReadInt32();
    --print(count)
    for i=1, count, 1 do
        local layer = {};
        layer.name = self.byteArray:ReadString();
        layer.firstgid = self.byteArray:ReadInt32();
        layer.tileCount = self.byteArray:ReadInt32();
        self:InsertLayerTile(layer);
    end
end

-- 加载层
function MapLoad:InsertLayerTile(layerTile)
    self.allLayerTileList:Push(layerTile);
end

-- 读取所有的建筑物
function MapLoad:ReadAllBuilding()
    local count = self.byteArray:ReadInt32();
    for i=1, count, 1 do
        local building = {};
        building.id = self.byteArray:ReadInt32();
        building.tableId = self.byteArray:ReadInt32();
        building.x = self.byteArray:ReadInt32();
        building.y = self.byteArray:ReadInt32();
        self.allBuildingList:Push(building);
    end
end

-- 区域格子索引
function MapLoad:SplitSize(value)
    local calc = value / self.regionSize;
    if math.ceil(calc) ~= calc then
        calc = math.ceil(calc) - 1;
    end

    return calc;
end

-- 修改中心点
function MapLoad:ModifyScreenCenter(tileX, tileY, loadComplete)
    local calcCenterX = self:SplitSize(tileX);
    local calcCenterY = self:SplitSize(tileY);
    if calcCenterX ~= self.centerX or calcCenterY ~= self.centerY then
        self:ReadRegion(calcCenterX, calcCenterY, loadComplete);
    else
        loadComplete();
    end
end

-- 清空数据
function MapLoad:ClearRegion()
    local count = 0;
    for k,v in pairs(self.dataMap) do
        count = count + 1;
        if count == self.dataSize then
            self.allLayerDataMap = {};
            self.dataMap = {};
        end
    end
end

-- 加载区块文件
function MapLoad:ReadRegion(x, y, loadComplete)
    --UnityEngine.Profiler.BeginSample("ReadRegion");
    local path = string.format( "data/layer%03d-%03d.data", x, y );
    
    local index = MapService:Instance():GetTiledIndex(x, y);
    --self:ClearDataMap(x, y);
    if self.dataMap[index] == nil then
        self.dataMap[index] = path;
    else
        loadComplete();
        return;
    end
    GameResFactory.Instance():ReadFile(path, function (layerData)
        self:ReadRegionData(x, y, layerData, loadComplete);
    end);
    --UnityEngine.Profiler.EndSample();
end

-- 读取区域
function MapLoad:ReadRegionData(x, y, layerData, loadComplete)
    --UnityEngine.Profiler.BeginSample("ReadRegionData1");
    self:ClearRegion();
    self.centerX = x;
    self.centerY = y;

    self.byteArray:Reset();
    self.byteArray:InitBytes(layerData);

    local widthIndex = self.byteArray:ReadInt32();
    local heightIndex = self.byteArray:ReadInt32();

    if widthIndex ~= x or heightIndex ~= y then
        return;
    end
   --UnityEngine.Profiler.EndSample();
    local startWidth = math.max(0, widthIndex * self.regionSize - self.regionEdge);
    local endWidth = math.min((widthIndex + 1) * self.regionSize + self.regionEdge, self.width) - 1;

    local startHeight = math.max(0, heightIndex * self.regionSize - self.regionEdge);
    local endHeight = math.min((heightIndex + 1) * self.regionSize + self.regionEdge, self.height) - 1;
    --UnityEngine.Profiler.BeginSample("ReadRegionData2");
    for width = startWidth, endWidth, 1 do
        for height = startHeight, endHeight, 1 do
            local index = width * self.width + height;
            --self:InsertLayerData(LayerType.State, index, self.byteArray:ReadInt16());
            --UnityEngine.Profiler.BeginSample("Land");
            self:InsertLayerData(LayerType.Land, index, self.byteArray:ReadInt16());
           --UnityEngine.Profiler.EndSample();
            --UnityEngine.Profiler.BeginSample("Road");
            self:InsertLayerData(LayerType.Road, index, self.byteArray:ReadInt16());
           --UnityEngine.Profiler.EndSample();
            --UnityEngine.Profiler.BeginSample("ResourceFront");
            self:InsertLayerData(LayerType.ResourceFront, index, self.byteArray:ReadInt16());
           --UnityEngine.Profiler.EndSample();
            --self:InsertLayerData(LayerType.ResourceBehind, index, self.byteArray:ReadInt16());
            --UnityEngine.Profiler.BeginSample("Moutain");
            self:InsertLayerData(LayerType.Moutain, index, self.byteArray:ReadInt16());
           --UnityEngine.Profiler.EndSample();
            --UnityEngine.Profiler.BeginSample("WildFort");
            self:InsertLayerData(LayerType.WildFort, index, self.byteArray:ReadInt16());
           --UnityEngine.Profiler.EndSample();
        end
    end
   --UnityEngine.Profiler.EndSample();
    --UnityEngine.Profiler.BeginSample("loadComplete");
    loadComplete();
    --UnityEngine.Profiler.EndSample();
end

-- 插入一层数据
function MapLoad:InsertLayerData(layerType, index, value)
  
    local layerData = self:FindLayerData(layerType);
    if layerData == nil then
        layerData = self:CreateLayerData(layerType);
    end

    layerData[index + 1] = value;
end

-- 查找层
function MapLoad:FindLayerData(layerType)
    
    if layerType == LayerType.ResourceBehind then
        layerType = LayerType.ResourceFront;
    end
    
    return self.allLayerDataMap[layerType];
end

-- 创建层
function MapLoad:CreateLayerData(layerType)

    local layerData = {};
    self.allLayerDataMap[layerType] = layerData;

    return layerData;
end

return MapLoad;