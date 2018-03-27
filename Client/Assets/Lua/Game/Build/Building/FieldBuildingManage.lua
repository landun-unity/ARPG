--野城管理
local FieldBuildingManage = class("FieldBuildingManage")
local Tiled = require("Game/Map/Tiled")
local TiledSprite = require("Game/Map/TiledSprite")
local Queue = require("common/Queue")
local LayerType = require("Game/Map/LayerType")
local MapLoad = require("Game/Map/MapLoad")
require("Game/Environment/MapMoveType");
local DataGameConfig = require("Game/Table/model/DataGameConfig");
-- 构造函数
function FieldBuildingManage:ctor( )
  
   --所有的城市精灵
   self._allSpriteList={};
   --城墙精灵
   self._allWallSpriteList = {};
   --建筑物父亲
   self._buildingParent = nil;
   --格子缓存
   self._cacheTiledQueue = Queue.new();
   --父物体缓存
   self._cacheBuildingQueue = Queue.new();

   self._cacheBuildingParentQueue = Queue.new();
   --层
   self._allBuildingMap = {};

   self.FieldBuildingConfig = {};
end

-- 创建精灵
function FieldBuildingManage:_AllSprite(FieldBuildingConfig)

    local times = FieldBuildingConfig:GetTileNumbers();
    local firstgid = FieldBuildingConfig:GetTileFirstGId();
    local name = FieldBuildingConfig:GetTileName();
    local width = FieldBuildingConfig:GetTileWidth();
    local height = FieldBuildingConfig:GetTileHeight();

    for id=firstgid,(times + firstgid - 1) do
        self:_CreateSprite(id, firstgid, name, width, height);
    end

    local wallname = "wall";
    for id=1,15 do
      ------print(id)
        self:_CreateWallSprite(id, 1, wallname, width, height);
    end
end

-- 创建精灵
function FieldBuildingManage:_CreateSprite(id, firstId, image, width, height)
    self._allSpriteList[id] = TiledSprite.new();
    ------print(id..firstId..image..width..height)
    -- 从1开始
    local finalImage = string.format( "%s_%d", image, firstId..(id - firstId + 1));
    ------print(finalImage)
    self._allSpriteList[id]:Init(id, finalImage, width, height);
end

-- 创建精灵
function FieldBuildingManage:_CreateWallSprite(id, firstId, image, width, height)
    self._allWallSpriteList[id] = TiledSprite.new();
    ------print(id..firstId..image..width..height)
    -- 从1开始
    local finalImage = string.format( "%s_%02d", image, id);
    ------print(finalImage)
    self._allWallSpriteList[id]:Init(id, finalImage, width, height);
end

-- 查找建筑物
function FieldBuildingManage:_FindBuilding(buildingId)
    return self._allBuildingMap[buildingId];
end

-- 插入一个建筑物
function FieldBuildingManage:_InsertBuilding(id, buildingView)
    if id == nil then
        return;
    end
    self._allBuildingMap[id] = buildingView;
end

-- 插入一个建筑物
function FieldBuildingManage:_RomoveBuilding(id)
    self._allBuildingMap[id] = nil;
end

-- 获取精灵
function FieldBuildingManage:GetSprite(id)
    if id == nil then
        return nil;
    end
    local tiledSprite = self._allSpriteList[id];
    if tiledSprite == nil then
        return nil;
    end

    return tiledSprite:GetSprite();
end

-- 获取城墙精灵
function FieldBuildingManage:GetWallSprite(id)
    if id == nil then
        return nil;
    end
    local tiledSprite = self._allWallSpriteList[id];
    if tiledSprite == nil then
        return nil;
    end

    return tiledSprite:GetSprite();
end

-- 加载野城父物体所有的缓存
function FieldBuildingManage:_SetAllCacheTiledParent(cacheTiledParent, buildingParent)
    self._cacheTiledParent = cacheTiledParent;
    self._buildingParent = buildingParent;
    ------print(self._cacheTiledParent);
end

-- 释放格子
function FieldBuildingManage:_ReleaseTiled(cacheTiled)
    if cacheTiled == nil then
        return;
    end
    self._cacheTiledQueue:Push(cacheTiled);
    cacheTiled:SetParent(self._cacheTiledParent);
end

-- 回收格子
function FieldBuildingManage:_AllocTiled()
    if self._cacheTiledQueue:Count() == 0 then
        return nil;
    end

    return self._cacheTiledQueue:Pop();
end

-- 释放格子
function FieldBuildingManage:_ReleaseBuildingTiled(cacheTiled)
    if cacheTiled == nil then
        return;
    end
    self._cacheBuildingQueue:Push(cacheTiled);
    cacheTiled:SetParent(self._cacheTiledParent);
end

-- 回收格子
function FieldBuildingManage:_AllocBuildingTiled()
    if self._cacheBuildingQueue:Count() == 0 then
        return nil;
    end

    return self._cacheBuildingQueue:Pop();
end

-- 释放格子
function FieldBuildingManage:_ReleaseBuildingParent(cacheTiled)
    if cacheTiled == nil then
        return;
    end
    self._cacheBuildingParentQueue:Push(cacheTiled);
    cacheTiled:SetParent(self._cacheTiledParent);
end

-- 回收格子
function FieldBuildingManage:_AllocBuildingParent()
    if self._cacheBuildingParentQueue:Count() == 0 then
        return nil;
    end

    return self._cacheBuildingParentQueue:Pop();
end

--显示建筑层
function FieldBuildingManage:_ShowTiledLayer(tiled)
    local town = tiled:GetTown();
    ------print(id)
    if town ~= nil then
      return;
    end

    local id = tiled:GetId();
 
    if id == nil then
      return;
    end
  
    local building = tiled:GetBuilding();
    
    if building._dataInfo.Type ~= 3 then
      return;
    end
    local buildingView = self:_FindBuilding(id);
    if buildingView == nil then
        buildingView = self:_CreateBuildingView("Game/Table/model/WildBuilding/"..building._dataInfo.CityShow, id);
        self:_OnShowBuildingLayer(tiled, buildingView, building);
        return;
    end
    -- buildingView:LoadBuilding("Game/Table/model/WildBuilding/"..building._dataInfo.CityShow);
    -- self:_OnShowBuildingLayer(tiled, buildingView, building);
end

function FieldBuildingManage:_HideTiled(tiled)
    local town = tiled:GetTown();
    ------print(id)
    if town ~= nil then
      return;
    end
    local id = tiled:GetId();
    if id == nil then
      return;
    end
    local buildingView = self:_FindBuilding(id);
    if buildingView == nil then
        return;
    end
    
    local count = buildingView:GetTiledTransformCount();
    for i= 1,count do
        local parent = buildingView:GetTiledTransform(i - 1);
        local childCount = parent.childCount;
        for v= 1 ,childCount do
            local cacheTiled = parent:GetChild(0);
            self:_ReleaseTiled(cacheTiled);
        end
    end
    
    for k,v in pairs(buildingView:GetTiledTransformTable()) do
        self:_ReleaseBuildingTiled(v);
    end

    local ParentBuilding = buildingView:GetBuildingTransform();
    self:_ReleaseBuildingParent(ParentBuilding);
    
    buildingView:Clear();

    self:_RomoveBuilding(id);
end

function FieldBuildingManage:_CreateBuildingView(config, id)
    local buildingView = require("Game/Build/Building/BuildingView").new();
    self.FieldBuildingConfig = buildingView:LoadBuilding(config);
    self:_InsertBuilding(id, buildingView);
    self:_AllSprite(self.FieldBuildingConfig);
    return buildingView;
end

-- 显示FieldBuilding物体
function FieldBuildingManage:_OnShowBuildingLayer(tiled ,buildingView, building)
     local buildingGameobject = buildingView:GetBuildingTransform();
     if buildingGameobject == nil then
          buildingGameobject = self:_AllocBuildingParent();
     end
     if buildingGameobject == nil then
          buildingGameobject = UGameObject.New();
     end
      buildingView:SetBuildingTransform(buildingGameobject.transform);
      buildingGameobject.name = string.format("%d", tiled:GetIndex());
      buildingGameobject.transform.parent = self._buildingParent;
      MapService:Instance():BuildingSort(buildingGameobject.transform, self._buildingParent);
      --buildingGameobject.transform.parent = self._buildingParent;
      buildingGameobject.transform.localPosition = self:GetTiledPosition(tiled:GetX(),tiled:GetY());
      buildingGameobject.transform.localScale = Vector3.one;
      buildingGameobject.transform.localRotation = Vector3.zero;
     
    local count = buildingView:GetImageCount();
    local widthCount = math.sqrt(count)-1;
    local core = math.ceil( math.sqrt(count) / 2) - 1;
    for i=1,count do
      local WildbuildingGameobject = buildingView:GetTiledTransform(i - 1);
      if WildbuildingGameobject == nil then
          WildbuildingGameobject = self:_AllocBuildingTiled();
      end
      if WildbuildingGameobject == nil then
          WildbuildingGameobject = UGameObject.New();
      end
      buildingView:SetTiledTransform(i - 1, WildbuildingGameobject.transform);
      WildbuildingGameobject.transform:SetParent(buildingView:GetBuildingTransform());
      local xy= buildingView:ConvertCoordinate(i - 1);
      if building._dataInfo.level == 3 or building._dataInfo.level == 4 or building._dataInfo.level == 7 or building._dataInfo.level == 8 then
          WildbuildingGameobject.transform.localPosition = buildingView:GetErrorPosition(xy[1], xy[2], building._dataInfo.State);
      else
          WildbuildingGameobject.transform.localPosition = buildingView:GetTiledPosition(xy[1], xy[2], building._dataInfo.State);
      end
      WildbuildingGameobject.transform.localScale = Vector3.one;
      WildbuildingGameobject.transform.localRotation = Vector3.zero;
      WildbuildingGameobject.name = string.format("city %01d X %01d", xy[1], xy[2]);
      self:_LoadBuildingTile(xy[1], xy[2], core, widthCount, WildbuildingGameobject.transform, buildingView);
    end

    --self:_HideResources(tiled, widthCount, TiledManage);
end

--隐藏资源
function FieldBuildingManage:_HideResources(tiled, widthCount, TiledManage)
    local width = 1;
    if math.floor((widthCount + 1) / 2) > 2 then
          width = 2;
    end

    for x = tiled:GetX() - width,tiled:GetX() + width do
      for y = tiled:GetY() - width,tiled:GetY() + width do
          ------print(x, y)
          TiledManage:_HideResources(x, y);
      end
    end
end

-- 根据周围加载每个格子
function FieldBuildingManage:_LoadBuildingTile(x, y, core, widthCount, parent, buildingView)
       local imageId = buildingView:GetImageId(buildingView:ConvertIndex(x, y));
       if imageId == nil then
          return;
       end
       ------print(parent.name)
       self:LoadTiled(x, y, core, buildingView, parent);
       local up = buildingView:GetImageId(buildingView:ConvertIndex(x, y-1));
       local down = buildingView:GetImageId(buildingView:ConvertIndex(x, y+1));
       local left = buildingView:GetImageId(buildingView:ConvertIndex(x+1, y));
       local right = buildingView:GetImageId(buildingView:ConvertIndex(x-1, y));

       local upLeft =  buildingView:GetImageId(buildingView:ConvertIndex(x+1, y-1));
       local upRight =  buildingView:GetImageId(buildingView:ConvertIndex(x-1, y-1));
       local downLeft =  buildingView:GetImageId(buildingView:ConvertIndex(x+1, y+1));
       local downRight =  buildingView:GetImageId(buildingView:ConvertIndex(x-1, y+1));

       local index = 0;

       --对角庄
      if downRight == nil and down == nil and right == nil then
         index = 3;
         self:LoadWall(x, y, index, core, buildingView, parent);
      end
      if upLeft == nil and up == nil and left == nil then
         index = 7;
         self:LoadWall(x, y, index, core, buildingView, parent);
      end
      --后墙
      if up == nil then
          if upRight ~= nil then
            index = 10;
            self:LoadWall(x, y, index, core, buildingView, parent);
          elseif upRight ~= nil then
            index = 11;
            self:LoadWall(x, y, index, core, buildingView, parent);
          else
            index = 4;
            self:LoadWall(x, y, index, core, buildingView, parent);
         end
      end
      if right == nil then
          if upRight ~= nil then
            index = 12;
            self:LoadWall(x, y, index, core, buildingView, parent);
          elseif downRight ~= nil then
            index = 13;
            self:LoadWall(x, y, index, core, buildingView, parent);
          else
            index = 2;
            self:LoadWall(x, y, index, core, buildingView, parent);
          end
      end
      if upRight == nil and up == nil and right == nil then
         index = 1;
         self:LoadWall(x, y, index, core, buildingView, parent);
      end
      --前墙
      if down == nil then
          if downLeft ~= nil then
            index = 14;
            self:LoadWall(x, y, index, core, buildingView, parent);
          elseif downRight ~= nil then
            index = 15;
            self:LoadWall(x, y, index, core, buildingView, parent);
          else
            index = 6;
            self:LoadWall(x, y, index, core, buildingView, parent);
          end
      end
      if left == nil then
          if upLeft ~= nil then
            index = 16;
            self:LoadWall(x, y, index, core, buildingView, parent);
          elseif downLeft ~= nil then
            index = 17;
            self:LoadWall(x, y, index, core, buildingView, parent);
          else
            index = 8;
            self:LoadWall(x, y, index, core, buildingView, parent);
          end
      end
      if downLeft == nil and down == nil and left == nil then
         index = 9;
         self:LoadWall(x, y, index, core, buildingView, parent);
      end
end

function FieldBuildingManage:LoadTiled(x, y, core, buildingView, parent)
  local tileTransform = buildingView:GetImageSprite(buildingView:ConvertIndex(x, y));
  if tileTransform == nil then
    tileTransform = self:_AllocTiled();
  end
  if tileTransform == nil then
  GameResFactory.Instance():GetResourcesPrefab("Map/TileImage", parent, function (BuildingObject) self:_OnShowFieldBuildingLayer(BuildingObject.transform, buildingView:ConvertIndex(x, y), buildingView, parent);
            end);
     return;
  end
  self:_OnShowFieldBuildingLayer(tileTransform.transform, buildingView:ConvertIndex(x, y), buildingView, parent)
end

function FieldBuildingManage:LoadWall(x, y, index, core, buildingView, parent)
  local tileTransform = buildingView:GetWallImageSprite(index + buildingView:WallConvertIndex(x, y));
  if tileTransform == nil then
    tileTransform = self:_AllocTiled();
  end
  if tileTransform == nil then
    GameResFactory.Instance():GetResourcesPrefab("Map/TileImage", parent, function (BuildingObject) self:_OnShowWallLayer(BuildingObject.transform, x, y, core, buildingView, index, parent);
           end);
  return;
  end
  self:_OnShowWallLayer(tileTransform.transform, x, y, core, buildingView, index, parent)
end

-- 根据格子位置，求坐标
function FieldBuildingManage:GetTiledPosition(x, y)
    local endX = (y * MapLoad:GetTiledWidth() / 2) - x * MapLoad:GetTiledWidth() / 2;
    local endY = (- x * MapLoad:GetTiledHeight() / 2 - ((y + 1) * MapLoad:GetTiledHeight() / 2));
    ------print(endX .. "    " .. endY);
    return Vector3.New(endX, endY, 0); 
end

-- 显示城市格子
function FieldBuildingManage:_OnShowFieldBuildingLayer(tileTransform, index, buildingView, parent)
    ------print(parent)
    local xy= buildingView:ConvertCoordinate(index);
    local imageId = buildingView:GetImageId(index);
    tileTransform:SetParent(parent);
    buildingView:SetTiledImage(index, tileTransform.gameObject);
    buildingView:SetSprite(index, self:GetSprite(imageId));
    tileTransform:SetAsFirstSibling();
    tileTransform.name = string.format("city %01d X %01d", xy[1],xy[2]);
    --临时处理
    tileTransform.localPosition = Vector3.New(0, 0 + DataGameConfig[MapMoveType.WildBuilding].OfficialData, 0);
    tileTransform.localScale = Vector3.one;
end

--加载城墙
function FieldBuildingManage:_OnShowWallLayer(wallTransform, x, y, core, buildingView, index, parent)
    local imageIndex = index + buildingView:WallConvertIndex(x, y);
    buildingView:SetWallImage(imageIndex, wallTransform.gameObject);
    if x == core and (index == 4 or index == 6) then
        if index == 4 then
        buildingView:SetWallSprite(imageIndex, self:GetWallSprite(12));
        end
        if index == 6 then
        buildingView:SetWallSprite(imageIndex, self:GetWallSprite(1));
        end
    elseif y == core  and (index == 2 or index == 8) then
        if index == 2 then
        buildingView:SetWallSprite(imageIndex, self:GetWallSprite(13));
        end
        if index == 8 then
        buildingView:SetWallSprite(imageIndex, self:GetWallSprite(2));
        end
    else
        if index == 3 or index == 7 or index == 9 or index == 1 then
          buildingView:SetWallSprite(imageIndex, self:GetWallSprite(3));
        elseif index == 4 or index == 6 then
          buildingView:SetWallSprite(imageIndex, self:GetWallSprite(4));
        elseif index == 2 or index == 8 then
          buildingView:SetWallSprite(imageIndex, self:GetWallSprite(5));
        elseif index == 10 then
          buildingView:SetWallSprite(imageIndex, self:GetWallSprite(7));
        elseif index == 11 then
          buildingView:SetWallSprite(imageIndex, self:GetWallSprite(9));
        elseif index == 12 then
          buildingView:SetWallSprite(imageIndex, self:GetWallSprite(6));
        elseif index == 13 then
          buildingView:SetWallSprite(imageIndex, self:GetWallSprite(8));
        elseif index == 15 then
          buildingView:SetWallSprite(imageIndex, self:GetWallSprite(10));
        elseif index == 16 then
          buildingView:SetWallSprite(imageIndex, self:GetWallSprite(11));
        elseif index == 14 then
          buildingView:SetWallSprite(imageIndex, self:GetWallSprite(14));
        elseif index == 17 then
          buildingView:SetWallSprite(imageIndex, self:GetWallSprite(15));
        end
    end
    wallTransform:SetParent(parent);
    if index == 3 then
       wallTransform.name = string.format("wall down right");
       wallTransform:SetAsFirstSibling();
    elseif
       index == 7 then
       wallTransform.name = string.format("wall up left");
       wallTransform:SetAsFirstSibling();
    elseif
   --后墙
       index == 4 or index == 10 or index == 11 then
       wallTransform.name = string.format("wall up");
       wallTransform:SetAsFirstSibling();
    elseif
       index == 2 or index == 12 or index == 13 then
        wallTransform.name = string.format("wall right");
       wallTransform:SetAsFirstSibling();
    elseif
       index == 1 then
        wallTransform.name = string.format("wall up right");
       wallTransform:SetAsFirstSibling();
    elseif
   --前墙
       index == 6 or index == 14 or index == 15 then
        wallTransform.name = string.format("wall down");
       wallTransform:SetAsLastSibling();
    elseif
       index == 8 or index == 16 or index == 17 then
        wallTransform.name = string.format("wall left");
       wallTransform:SetAsLastSibling();
    elseif
       index == 9 then
        wallTransform.name = string.format("wall down left");
       wallTransform:SetAsLastSibling();
    end
    wallTransform.localPosition = buildingView:GetWallPosition(self:_GetWallIndex(index));
    wallTransform.localScale = Vector3.one;
end

function FieldBuildingManage:_GetWallIndex(index)
  if index == 10 or index == 11 then
     index = 4;
  elseif index == 12 or index == 13 then
     index = 2;
  elseif index == 14 or index == 15 then
     index = 6;
  elseif index == 16 or index == 17 then
     index = 8;
  end
  return index - 1;
end

return FieldBuildingManage;