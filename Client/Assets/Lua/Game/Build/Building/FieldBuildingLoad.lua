-- 野城地图块
local FieldBuildingLoad = class("FieldBuildingLoad")

--构造函数
function FieldBuildingLoad:ctor()
end

--初始化建筑
function FieldBuildingLoad:InitBuilding(config)
    self._BuildingConfig = require(config);

	self._width = self._BuildingConfig.width;
    self._height = self._BuildingConfig.height;
    
    self._tiledWidth = self._BuildingConfig.tilewidth;
    self._tiledHight = self._BuildingConfig.tileheight;

    self._imageWidth = 200;
    self._imageHeight = 200;

    self._allLayerBuilding = {};
    --self._allBuildingList = {};

    self:_LoadAllLayer(self._BuildingConfig);
end

function FieldBuildingLoad:CloseBuilding()
	self._BuildingConfig = nil;
end

--宽
function FieldBuildingLoad:GetWidth()
	return self._width;
end

--高
function FieldBuildingLoad:GetHeight()
	return self._height;
end

--宽
function FieldBuildingLoad:GetTiledWidth()
	return self._tiledWidth;
end

--高
function FieldBuildingLoad:GetTiledHeight()
	return self._tiledHight;
end

-- 加载所有的层
function FieldBuildingLoad:_LoadAllLayer(BuildingConfig)
	for i,v in ipairs(BuildingConfig.layers) do
	    if v ~= nil then
	        self:_LoadLayer(v);
	    end
     end
end

-- 加载层
function FieldBuildingLoad:_LoadLayer(layer)
    local name = string.lower(layer.name);
    -- 州
    if name == "peoplecity" then
        self._allLayerBuilding[LayerType.FieldBuilding] = layer.data;
    end
end

--加载建筑
function FieldBuildingLoad:GetBuilding(index)
    local layer = self._allLayerBuilding[LayerType.FieldBuilding];
    return layer [index+1];
end

--获取格子名称
function FieldBuildingLoad:GetTileName()
    local name = string.lower(self._BuildingConfig.tilesets[1].name);
    return name;
end

--获取格子名称
function FieldBuildingLoad:GetTileFirstGId()
    return self._BuildingConfig.tilesets[1].firstgid;
end

--获取格子名称
function FieldBuildingLoad:GetTileNumbers()
    return self._BuildingConfig.tilesets[1].tilecount;
end

--获取格子的宽
function FieldBuildingLoad:GetTileWidth()
    return self._BuildingConfig.tilesets[1].tilewidth;
end

--获取格子的宽
function FieldBuildingLoad:GetTileHeight()
    return self._BuildingConfig.tilesets[1].tileheight;
end

function FieldBuildingLoad:ConvertIndex(x, y)
    return x * self:GetWidth() + y;
end

function FieldBuildingLoad:WallConvertIndex(x, y)
    return (x * self:GetWidth() + y) * 9;
end

function FieldBuildingLoad:ConvertCoordinate( index )
   -- print(index)
    local convert ={math.floor(index / self:GetWidth()),index % self:GetWidth()};
    --print(math.ceil(index/self:GetWidth()),index%self:GetWidth())
    return convert;
end 

return FieldBuildingLoad;