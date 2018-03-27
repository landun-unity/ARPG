
--[[
	名称
--]]

local GamePart = require("FrameWork/Game/GamePart")
local DataBuild = require("Game/Table/model/DataBuilding")
local UIMapNameManage = class("UIMapNameManage", GamePart)
local ChangeRotation = UnityEngine.Vector3(0, 0, 0) -- 修正

function UIMapNameManage:ctor()
	UIMapNameManage.super.ctor(self);
	--缓存
	self._chcheItem = {};
    --Map
	self._allItemMap = {};
	--parent
	self._parent = nil;
    --回收上移偏量
	self._recoveryY = 200000;
	--ui偏移量
	self._offest = 50;
end

function UIMapNameManage:_ReleaseItem(type, cacheItem)
	
	if cacheItem == nil then
		return;
	end

	if self._chcheItem[type] == nil then
		return nil;
	end
	
	self._chcheItem[type]:Push(cacheItem);
	
	cacheItem.transform.localPosition = Vector3.New(cacheItem.transform.localPosition.x, cacheItem.transform.localPosition.y + self._recoveryY, 0);
end

function UIMapNameManage:_AllocItem(type)
    if self._chcheItem[type] == nil then
    	self._chcheItem[type] = Queue.new();
    end

	if self._chcheItem[type]:Count() == 0 then
        return nil;
    end
    return self._chcheItem[type]:Pop();
end

function UIMapNameManage:_ShoWildUILayer(tiled)
	local building = tiled:GetBuilding();

    if building == nil then
        return;
    end
 
    if self:_FindItem(building._id) ~= nil then
        return;
    end
    
    if building._dataInfo.Type == BuildingType.MainCity or building._dataInfo.Type == BuildingType.SubCity then
    	return;
    end

    self:_ShowName(building, tiled);
end

function UIMapNameManage:_ShowPlayerUILayer(tiled)
	local building = tiled:GetBuilding();
    
    if building == nil then
        return;
    end

    if self:_FindItem(building._id) ~= nil then
        return;
    end

    self:_ShowName(building, tiled);
end

function UIMapNameManage:_ShowName(building, tiled)
	local item = nil;
    
    if building._dataInfo.Type == BuildingType.MainCity or building._dataInfo.Type == BuildingType.SubCity or building._dataInfo.Type == BuildingType.PlayerFort then
    	item = self:_AllocItem(1);
    	if item == nil then
		    item = require("Game/MapMenu/UICityName").new();
		    GameResFactory.Instance():GetUIPrefab("UIPrefab/CityName", self._parent, item, function (Object)
		    	item:Init();
		    	item.transform.eulerAngles = ChangeRotation;
		    	self:_CreatItem(building._id, item, tiled);
		    end);
		    return;
        end
    elseif building._dataInfo.Type == BuildingType.Boat or building._dataInfo.Type == BuildingType.LevelBoat then
		item = self:_AllocItem(2);
		if item == nil then
		    item = require("Game/MapMenu/UICityImage").new();
		    GameResFactory.Instance():GetUIPrefab("UIPrefab/CityImage", self._parent, item, function (Object)
		    	item:Init();
		    	item.transform.eulerAngles = ChangeRotation;
		    	self:_CreatItem(building._id, item, tiled);
		    end);
		    return;
	    end
    else
    	item = self:_AllocItem(2);
    	if item == nil then
		    item = require("Game/MapMenu/UICityImage").new();
		    GameResFactory.Instance():GetUIPrefab("UIPrefab/CityImage", self._parent, item, function (Object)
		    	item:Init();
		    	item.transform.eulerAngles = ChangeRotation;
		    	self:_CreatItem(building._id, item, tiled);
		    end);
		    return;
        end
    end
    
    self:_CreatItem(building._id, item, tiled);
end

function UIMapNameManage:_CreatItem(buildingId, item, tiled)
	if self:_FindItem(buildingId) == nil then
       self:_InsertItem(buildingId, item);
    end
	self:_ShowNamePre(item, tiled);
end

function UIMapNameManage:_ShowNamePre(item, tiled)
	local Vector = MapService:Instance():GetTiledPosition(tiled:GetX(), tiled:GetY());
    item.transform.localPosition = Vector3.New(Vector.x, Vector.y + self._offest, 0);
    item:OnShow(tiled);
end

function UIMapNameManage:_SetAllCacheUIParent(parent)
	self._parent = parent;
end

function UIMapNameManage:_HideTiledUILayer(tiled)
	local building = tiled:GetBuilding();
	if building == nil or tiled:GetTown() ~= nil then
        return;
    end
    
    local item = self:_FindItem(building._id);
    
    if item == nil then
        return;
	end
    
    if item.transform.localPosition == nil then
    	return;
    end
    
    if building._dataInfo.Type == 1 or building._dataInfo.Type == 2 or building._dataInfo.Type == 4 then
        self:_ReleaseItem(1, item);
    else
    	self:_ReleaseItem(2, item);
    end
    self:_RomveItem(building._id);
end

--
function UIMapNameManage:_RomveItem(id)
	if id == nil then
		return;
	end
	------print("删除啦！！！！建筑id ==============="..id)
	self._allItemMap[id] = nil;
end

--查找
function UIMapNameManage:_FindItem(id)
	if self._allItemMap[id] == nil then
       -- print("没有建筑 ！！！！！！！！！！！"..id)
        return nil;
    end
    --print("_FindItem ！！！！！！！！！！！"..id)
	return self._allItemMap[id];
end

--添加
function UIMapNameManage:_InsertItem(id, item)
	if id == nil then
		return;
	end
	--print("建筑id ==============="..id)
	self._allItemMap[id] = item;
end

return UIMapNameManage