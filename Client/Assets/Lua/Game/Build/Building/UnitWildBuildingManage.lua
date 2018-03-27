--码头显示管理类

local TiledSprite = require("Game/Map/TiledSprite")
local BoatOrientationType = require("Game/Build/Building/BoatOrientationType")
local Queue = require("common/Queue");
local MapLoad = require("Game/Map/MapLoad")
local UnitWildBuildingManage = class("UnitWildBuildingManage")

--构造函数
function UnitWildBuildingManage:ctor()
	--所有的码头精灵
	self._allMotherBoatSpriteList = {};
    self._allSonBoatSpriteList = {};
    --所有的关卡精灵
    self._allWildFortSpriteList = {};
    --所有的玩家要塞精灵
    self._allPlayerFortSpriteList = {};
	--建筑物父亲
	self._buildingParent = nil;

	self._BoatParent = nil;
	--缓存
	self._cacheTiledQueue = Queue.new();
    --缓存
    self._cacheBuildingQueue = Queue.new();
    --加载过的类
    self._allBuildingMap = {};
end
--不同势力加for
--码头图片
function UnitWildBuildingManage:_AllSprite()
 	local name = "";
	local width = 400;
	local height = 400;
    for i=1,4 do
        self:_CreateMotherBoatSprite(i, "MotherBoat", width, height);
        self:_CreateSonBoatSprite(i, "SonBoat", width, height);
    end

    name = "barrier";
    local width = 400;
    local height = 400;
    for i=1,2 do
        self:_CreateWildFortSprite(i, name, width, height);
    end

    name = "playerfort";
    local width = 400;
    local height = 400;
    for i=1,3 do
        self:_CreatePlayerFortSprite(i, name, width, height);
    end
end

function UnitWildBuildingManage:_CreateMotherBoatSprite(i, image, width, height)
	self._allMotherBoatSpriteList[i] = TiledSprite.new();
	local finalImage = string.format("%s_%02d", image, i);
	self._allMotherBoatSpriteList[i]:Init(i, finalImage, width, height);
end

function UnitWildBuildingManage:_CreateSonBoatSprite(i, image, width, height)
    self._allSonBoatSpriteList[i] = TiledSprite.new();
    local finalImage = string.format("%s_%02d", image, i);
    self._allSonBoatSpriteList[i]:Init(i, finalImage, width, height);
end

function UnitWildBuildingManage:_CreateWildFortSprite(i, image, width, height)
    self._allWildFortSpriteList[i] = TiledSprite.new();
    local finalImage = string.format("%s_%d", image, i);
    --print(finalImage)
    self._allWildFortSpriteList[i]:Init(i, finalImage, width, height);
end

function UnitWildBuildingManage:_CreatePlayerFortSprite(i, image, width, height)
    self._allPlayerFortSpriteList[i] = TiledSprite.new();
    local finalImage = string.format("%s_%d", image, "1"..i);
    --print(finalImage)
    self._allPlayerFortSpriteList[i]:Init(i, finalImage, width, height);
end

-- 获取精灵
function UnitWildBuildingManage:_GetSprite(id, name)
    if id == nil then
        return nil;
    end
    local tiledSprite = nil;
    if name == "barrier" then
        tiledSprite = self._allWildFortSpriteList[id];
    elseif name == "PlayerFort" then
        tiledSprite = self._allPlayerFortSpriteList[id];
    elseif name == "MotherBoat" then
        tiledSprite = self._allMotherBoatSpriteList[id];
    elseif name == "SonBoat" then
        tiledSprite = self._allSonBoatSpriteList[id];
    end
    if tiledSprite == nil then
        return nil;
    end

    return tiledSprite:GetSprite();
end

-- 释放格子
function UnitWildBuildingManage:_ReleaseTiled(cacheTiled)
    if cacheTiled == nil then
        return;
    end
    self._cacheTiledQueue:Push(cacheTiled);
    cacheTiled:SetParent(self._cacheTiledParent);
end

-- 回收格子
function UnitWildBuildingManage:_AllocTiled()
    if self._cacheTiledQueue:Count() == 0 then
        return nil;
    end

    return self._cacheTiledQueue:Pop();
end

-- 释放格子
function UnitWildBuildingManage:_ReleaseBuidling(cacheTiled)
    if cacheTiled == nil then
        return;
    end
    self._cacheBuildingQueue:Push(cacheTiled);
    cacheTiled:SetParent(self._cacheTiledParent);
end

-- 回收格子
function UnitWildBuildingManage:_AllocBUilding()
    if self._cacheTiledQueue:Count() == 0 then
        return nil;
    end

    return self._cacheBuildingQueue:Pop();
end

function UnitWildBuildingManage:_FindBuilding(id)
	return self._allBuildingMap[id];
end

function UnitWildBuildingManage:_InsertBuilding(id, boatview)
	self._allBuildingMap[id] = boatview;
end

--删除
function UnitWildBuildingManage:_RomveBuilding(id)
	self._allBuildingMap[id] = nil;
end

function UnitWildBuildingManage:_SetAllCacheTiledParent(cacheTiledParent, buildingParent)
    self._buildingParent = buildingParent;
    self._cacheTiledParent = cacheTiledParent;
    --print(self._cacheTiledParent);
end

function UnitWildBuildingManage:GetTiledPosition(x, y)
    local endX = (y * MapLoad:GetTiledWidth() / 2) - x * MapLoad:GetTiledWidth() / 2;
    local endY = - x * MapLoad:GetTiledHeight() / 2 - ((y + 1) * MapLoad:GetTiledHeight() / 2);

    --print(endX .. "    " .. endY);
    return Vector3.New(endX, endY, 0);
end

function UnitWildBuildingManage:_ShowTiledLayer(tiled)
    
    local id = tiled:GetId();
    if id == nil then
      return;
    end
    local building = tiled:GetBuilding();
    if building == nil or (building._dataInfo.Type ~= BuildingType.PlayerFort 
    and building._dataInfo.Type ~= BuildingType.Boat 
    and building._dataInfo.Type ~= BuildingType.LevelBoat 
    and building._dataInfo.Type ~= BuildingType.LevelShiYi) then
      return;
    end
    if building:JudgePlayerFortIsOnBuilding() then
        return;
    end
    -- print(building:GetFortGrade())
    local boatView = self:_FindBuilding(id);
    if boatView == nil then
        boatView = self:_CreateBuildingView(id, building, building._dataInfo.Type);
        --print(boatView);
        self:_OnShowBoat(tiled, boatView, building._dataInfo.Type);
        return;
    end
     
   -- self:_OnShowBoat(tiled, boatView, building._dataInfo.Type);
end

function UnitWildBuildingManage:_HideTiled(tiled)
    local id = tiled:GetId();
    if id == nil then
      return;
    end
    local BuildingView = self:_FindBuilding(id);
    if BuildingView == nil then
        return;
    end
    
    local parent = BuildingView:GetBoatTransform();
    if parent.childCount == 0 then
        return;
    end

    for v= 1 ,parent.childCount do
        local cacheTiled = parent:GetChild(0);
        self:_ReleaseTiled(cacheTiled);
    end

    self:_ReleaseBuidling(parent);
 
    self:_RomveBuilding(id);
end

function UnitWildBuildingManage:_CreateBuildingView(id, building, buildingtype)
	local boatView = require("Game/Build/Building/UnitWildBuildingView").new();
    if buildingtype == BuildingType.LevelShiYi then
        boatView:LoadWildFort(building);
    elseif buildingtype == BuildingType.PlayerFort then
        boatView:LoadPlayerFort(building);
    else
        boatView:LoadBoat(building);
    end
	self:_InsertBuilding(id, boatView);
    --self:_AllSprite();
    return boatView;
end

function UnitWildBuildingManage:_OnShowBoat(tiled, boatView, buildingtype)
    local name = "";
    if buildingtype == BuildingType.LevelShiYi then
        name = "barrier";
    elseif buildingtype == BuildingType.PlayerFort then
        name = "PlayerFort";
    else
        name = "MotherBoat";
    end
    local buildingGameobject = boatView:GetBoatTransform();
    if buildingGameobject == nil then
       buildingGameobject = self:_AllocBUilding();
    end
    if buildingGameobject == nil then
	    buildingGameobject = UGameObject.New();
        boatView:SetBoatTransform(buildingGameobject.transform);
    end
    buildingGameobject.name = string.format("%d", tiled:GetIndex());
    MapService:Instance():BuildingSort(buildingGameobject.transform, self._buildingParent);
    --buildingGameobject.transform.parent = self._buildingParent;
    buildingGameobject.transform.localPosition = self:GetTiledPosition(tiled:GetX(),tiled:GetY());
    buildingGameobject.transform.localScale = Vector3.one;
    buildingGameobject.transform.localRotation = Vector3.zero;
    --print(boatView);
    boatView:SetBoatTransform(buildingGameobject.transform);
    self:_LoadBuildingTile(tiled:GetX(), tiled:GetY(), buildingGameobject.transform, boatView, name);
end

function UnitWildBuildingManage:_LoadBuildingTile(x, y, parent, boatView, name)
	local boatTransform = boatView:GetImageSprite();
	if boatTransform == nil then
    boatTransform = self:_AllocTiled();
	end
	if boatTransform == nil then
	GameResFactory.Instance():GetResourcesPrefab("Map/TileImage", parent, function (BuildingObject) self:_OnShowBoatBuilding(BuildingObject.transform, x, y, boatView, parent, name);
	        end);
	return;
    end
    self:_OnShowBoatBuilding(boatTransform.transform, x, y, boatView, parent, name)
end

function UnitWildBuildingManage:_OnShowBoatBuilding(tileTransform, x, y, boatView, parent, name)
    local imageId = boatView:GetImageId();
    tileTransform:SetParent(parent);
    boatView:SetImageSprite(tileTransform.gameObject);
    boatView:SetSprite(self:_GetSprite(imageId, name));
    tileTransform.name = string.format(name .. " %01d X %01d", x, y);
    tileTransform.localPosition = Vector3.zero;
    tileTransform.localScale = Vector3.one;
    if name == "MotherBoat" then
        local boatTransform = self:_AllocTiled();
        if boatTransform == nil then
            GameResFactory.Instance():GetResourcesPrefab("Map/TileImage", parent, function (BuildingObject) self:_OnShowSonBoatBuilding(BuildingObject.transform, x, y, boatView, parent);
                    end);
            return;
        end
        self:_OnShowSonBoatBuilding(boatTransform.transform, x, y, boatView, parent)
    end
end

function UnitWildBuildingManage:_OnShowSonBoatBuilding(tileTransform, x, y, boatView, parent)
    local imageId = boatView:GetImageId();
    tileTransform:SetParent(parent);
    tileTransform.gameObject:GetComponent(typeof(UnityEngine.RectTransform)).sizeDelta = Vector2.New(400, 400);
    tileTransform.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = self:_GetSprite(imageId, "SonBoat");
    --boatView:SetImageSprite(tileTransform.gameObject);
    --boatView:SetSprite(self:_GetSprite(imageId, name));
    tileTransform.name = string.format("SonBoat" .. " %01d X %01d", x, y);
    tileTransform.localPosition = self:_BoatOrientation(imageId, x, y);
    tileTransform.localScale = Vector3.one;
end

function UnitWildBuildingManage:_BoatOrientation(id, x, y)
    if id == BoatOrientationType.Up then
        return Vector3.New(200, 100,0);
    elseif id == BoatOrientationType.Down then
        return Vector3.New(-200, -100,0);
    elseif id == BoatOrientationType.Left then
        return Vector3.New(100, 200,0);
    elseif id == BoatOrientationType.Right then
        return Vector3.New(-100, -200,0);
    end
end

return UnitWildBuildingManage;