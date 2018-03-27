--玩家主城管理类

require("Game/Environment/MapMoveType");
local DataGameConfig = require("Game/Table/model/DataGameConfig");
local TiledSprite = require("Game/Map/TiledSprite")
local Queue = require("common/Queue");
local MapLoad = require("Game/Map/MapLoad")
local DataConstruction = require("Game/Table/model/DataConstruction")
local DataBuilding = require("Game/Table/model/DataBuilding")
local MainCityManage = class("MainCityManage")

function MainCityManage:ctor()
	--所有的城市精灵
	self._allSpriteList = {};
  --城墙精灵
  self._allWallSpriteList = {};
	--建筑物父亲
	self._buildingParent = nil;
	--缓存
	self._cacheTiledQueue = Queue.new();
  --父物体的缓存
  --self._cacheParentQueue = Queue.new();
  --父物体的缓存
  self._cacheBuildingParentQueue = Queue.new();
    --加载过的类
  self._allBuildingMap = {};

  self._recovery = 200000;

  MainCityManage._instance = self;


end

function MainCityManage:Instance()
  return MainCityManage._instance;
end

--单个精灵
function MainCityManage:_CreateSprite(id, image)
	self._allSpriteList[id] = TiledSprite.new();
	local finalImage = string.format("%s_%d", image, id);

	self._allSpriteList[id]:Init(id, finalImage, MapLoad._imageWidth * 3, MapLoad._imageHeight * 3);
end

-- 获取精灵
function MainCityManage:GetSprite(id)
    if id == nil then
        return nil;
    end
    local tiledSprite = self._allSpriteList[id];
    if tiledSprite == nil then
        return nil;
    end
    
    return tiledSprite:GetSprite();
end

--查找
function MainCityManage:_FindBuilding(BuildingId)
	return self._allBuildingMap[BuildingId];
end

--添加
function MainCityManage:_InsertBuilding(id,BuildingView)
	if id == nil then
		return;
	end
	self._allBuildingMap[id] = BuildingView;
end

--删除
function MainCityManage:_RomveBuilding(BuildingId)
	self._allBuildingMap[BuildingId] = nil;
end

--缓存父物体
function MainCityManage:_SetAllCacheTiledParent(CacheTiledParent, buildingParent)
	--self._cacheTiledParent = CacheTiledParent;
  self._buildingParent = buildingParent;
end

--释放
function MainCityManage:_ReleaseBuildingParent(cacheTiled)
  if cacheTiled == nil then
    return;
  end
  self._cacheBuildingParentQueue:Push(cacheTiled);
  cacheTiled.transform.localPosition = Vector3.New(cacheTiled.transform.localPosition.x, cacheTiled.transform.localPosition.y + self._recovery, 0);
  --cacheTiled:SetParent(self._cacheTiledParent);
end

--回收
function MainCityManage:_AllocBuildingParent()
   if self._cacheBuildingParentQueue:Count() == 0 then
        return nil;
   end
   return self._cacheBuildingParentQueue:Pop();
end

--释放
function MainCityManage:_ReleaseTiled(cacheTiled)
	if cacheTiled == nil then
		return;
	end
	self._cacheTiledQueue:Push(cacheTiled);
  cacheTiled.transform.localPosition = Vector3.New(cacheTiled.transform.localPosition.x, cacheTiled.transform.localPosition.y + self._recovery, 0);
	--cacheTiled:SetParent(self._cacheTiledParent);
end

--回收
function MainCityManage:_AllocTiled()
   if self._cacheTiledQueue:Count() == 0 then
   	    return nil;
   end
   return self._cacheTiledQueue:Pop();
end

--显示
function MainCityManage:_ShowTiledLayer(tiled)
  local town = tiled:GetTown();
  if town ~= nil then
     return;
  end
  
	local id = tiled:GetId();
	if id == nil then
		return;
	end

  local building = tiled:GetBuilding();
  ------print(building._dataInfo.Type)
  if building._dataInfo.Type ~= BuildingType.MainCity and building._dataInfo.Type ~= BuildingType.SubCity then
      return;
  end
  ------print(building:GetCityLevel() == 0)
  if building._subCitySuccessTime ~= 0 or building:GetCityLevel() == 0 then
      return;
  end

	local MainCityView = self:_FindBuilding(id);
	if MainCityView == nil then
        MainCityView = self:_CreatMainCityView(tiled, id);
        self:_OnShowBuildingLayer(tiled, MainCityView);
        return;
	end
end

--隐藏
function MainCityManage:_HideTiled(tiled)
  local town = tiled:GetTown();
  if town ~= nil then
     return;
  end
	local id = tiled:GetId();
	if id == nil then
		return;
	end
	local MainCityView = self:_FindBuilding(id);
	if MainCityView == nil then
      return;
	end

  local parent = MainCityView:GetBuildingTransform();
  ------print(parent.name)
  local childCount = parent.childCount;
  if childCount == 0 then
     return;
  end

  for n = 1 ,childCount do
      local cacheTiled = parent:GetChild(0);
      self:_ReleaseTiled(cacheTiled);
  end

   self:_ReleaseBuildingParent(parent);

   MainCityView:Clear();

	self:_RomveBuilding(id);
end

--MainCityView
function MainCityManage:_CreatMainCityView(tiled, id)
  	local MainCityView = require("Game/Build/Building/MainCityView").new();
    local Building = tiled:GetBuilding();
    MainCityView:LoadBuilding(Building);
    --local x = 1
    self:_InsertBuilding(id ,MainCityView)
    --self:_AllSprite();
    return MainCityView;
end

--显示主城
function MainCityManage:_OnShowBuildingLayer(tiled, MainCityView)
     local buildingGameobject = MainCityView:GetBuildingTransform();
     if buildingGameobject == nil then
          buildingGameobject = self:_AllocBuildingParent();
     end
     if buildingGameobject == nil then
          buildingGameobject = UGameObject.New();
     end
    MainCityView:SetBuildingTransform(buildingGameobject.transform);
    buildingGameobject.name = string.format("%d", tiled:GetIndex());
    MapService:Instance():BuildingSort(buildingGameobject.transform, self._buildingParent);
	  --buildingGameobject.transform.parent = self._buildingParent;
	  buildingGameobject.transform.localPosition = self:GetTiledPosition(tiled:GetX(),tiled:GetY());
	  buildingGameobject.transform.localScale = Vector3.one;
    buildingGameobject.transform.localRotation = Vector3.zero;
    self:LoadTiled(buildingGameobject.transform, MainCityView, tiled);
end

function MainCityManage:LoadTiled(parent, MainCityView, tiled)
  local tileTransform =  MainCityView:GetImageSprite();
  if tileTransform == nil then
      tileTransform = self:_AllocTiled();
  end
  if tileTransform == nil then
    ------print(buildingView:ConvertIndex(x, y))
  GameResFactory.Instance():GetResourcesPrefab("Map/TileImage", parent, function (BuildingObject) self:_OnShowFieldBuildingLayer(BuildingObject.transform, MainCityView, parent, tiled);
            end);
  return;
  end
  self:_OnShowFieldBuildingLayer(tileTransform.transform, MainCityView, parent, tiled)
end

-- 根据格子位置，求坐标
function MainCityManage:GetTiledPosition(x, y)
    local endX = (y * MapLoad:GetTiledWidth() / 2) - x * MapLoad:GetTiledWidth() / 2;
    local endY = (- x * MapLoad:GetTiledHeight() / 2 - ((y + 1) * MapLoad:GetTiledHeight() / 2));
    ------print(endX .. "    " .. endY);
    return Vector3.New(endX, endY - DataGameConfig[MapMoveType.PlayerBuilding].OfficialData, 0);
end--+ DataGameConfig[MapMoveType.PlayerBuilding].OfficialData--

-- 显示城市格子
function MainCityManage:_OnShowFieldBuildingLayer(tileTransform, MainCityView, parent, tiled)
    local imageId = MainCityView:GetImageId();
    if self:GetSprite(imageId) == nil then
        local mainHome = DataBuilding[tiled._building._tableId].UpgradeToBuilding;
        local cityLevel = tiled._building:GetCityLevel();
        for i,v in ipairs(DataConstruction[mainHome].ConstructionLv) do
            if cityLevel <= v then
                ImageId = DataConstruction[mainHome].Camp[1]..DataConstruction[mainHome].ExtensionPicture[i];
                break;
            end
        end
        self:_CreateSprite(ImageId, "maincity");
    end

    tileTransform:SetParent(parent);
    MainCityView:SetTiledImage(tileTransform.gameObject);
    MainCityView:SetSprite(self:GetSprite(imageId));
    --tileTransform:SetAsFirstSibling();
    tileTransform.name = string.format("city %01d X %01d", tiled:GetX(), tiled:GetY());
    tileTransform.localPosition = Vector3.zero;
    tileTransform.localScale = Vector3.one;
end

return MainCityManage;