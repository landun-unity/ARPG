-- region *.lua
-- Date
-- 弹出地图管理类

-- 登录管理
local GamePart = require("FrameWork/Game/GamePart")
local PmapManage = class("PmapManage", GamePart)
local List = require("common/list");
local MapLoad = require("Game/Map/MapLoad");
require("Game/Table/model/DataRegion")
require("Game/Table/model/DataTileCut")
require("Game/Map/LayerType")
require("Game/Table/model/DataBuilding")
require("Game/Build/BuildingType")

-- 构造函数
function PmapManage:ctor()
    PmapManage.super.ctor(self);
    self.infoList = List.new()
    self.LeagueMarkList = List.new()
    -- 初始化小地图建筑物
    self.ownerCityList = List:new()
    self.NPCityList = List.new()
    self.isFirstMap = true;
    -- 储存上次跳转的位置
    self.lastPos = 0
end

-- 初始化
function PmapManage:_OnInit()

end


function PmapManage:SetIsFirstMap(args)
    self.isFirstMap = args
end

function PmapManage:GetIsFirstMap(args)
    return self.isFirstMap
end

-- 存储上次跳转的位置
function PmapManage:SetLastMapPos(pos)
    self.lastPos = pos;
end
function PmapManage:GetLastMapPos()
   return  self.lastPos;
end


function PmapManage:SetMateInfo(msg)

    self.infoList = msg.infoList;
    self.LeagueMarkList = msg.LeagueMarkList;

end

function PmapManage:GetInfoList()
    return self.infoList;
end

function PmapManage:GetLeagueMarkList()
    return LeagueService:Instance():GetLeagueMarkList()
end

function PmapManage:GetStateIdByIndex(index)
    if index == nil then
        return nil;
    end
    if MapLoad:GetTerrain(LayerType.State, index) == nil then
        return nil;
    end
    local layer = MapLoad:GetTerrain(LayerType.State, index)
    if DataTileCut[layer] == nil or DataTileCut[layer].TileID == nil then
        return nil;
    end
    local dataTile = DataTileCut[layer].TileID

    if DataRegion[dataTile] == nil or DataRegion[dataTile].StateID == nil then

    end
    local StateID = DataRegion[dataTile].StateID;
    if StateID == nil then
        return nil;
    end
    return StateID
end

-- 注册所有的事件
function PmapManage:Move(rectTransform, x, y)
    if rectTransform == nil then
        return;
    end
    local UIPosX, UIPosY;
    UIPosX =(y - x) * rectTransform.rect.width / MapLoad:GetWidth() / 2
    UIPosY = -(y + 1 + x) * rectTransform.rect.height / MapLoad:GetHeight() / 2 + rectTransform.rect.height / 2
    rectTransform.transform.localPosition = Vector3.New(- UIPosX, - UIPosY, 0)
end

-- 获取NPC野城、关卡、马头
function PmapManage:GetNPCBuildingList()
    return self.NPCityList
end

function PmapManage:SetNPCBuildingList()
    self.NPCityList:Clear();
    for k, v in pairs(DataBuilding) do
        if v.Type == 3 or v.Type == 7 or v.Type == 8 or v.Type == 9 then
            self.NPCityList:Push(v)
        end
    end
end

-- NPC城池数量
function PmapManage:GetNPCBuildingListCount()
    return self.NPCityList:Count()
end

return PmapManage
-- endregion
