-- region *.lua
-- Date
local UIBase = require("Game/UI/UIBase");
local UIMinMap = class("UIMinMap", UIBase)
local MapLoad = require("Game/Map/MapLoad")
local UIPic = require("Game/Popupmap/UIPic");
local List = require("common/list");
local minMapWidth = 2250
local minMapHeight = 1200
local GameMainView = nil;
function UIMinMap:ctor()

    UIMinMap.super.ctor(self)
    self.MapPic = nil;
    self.ownerCityList = nil;
    self.NPCityList = nil;
    self._PicperfabPath = DataUIConfig[UIType.UIPic].ResourcePath;
    self._allPic = { }
    self._allWildPic = { }
    self.NPC = PmapService:Instance():GetNPCBuildingList()
end


function UIMinMap:DoDataExchange()
    self.MapPic = self:RegisterController(UnityEngine.RectTransform, "SmallMap/MinMap")
end

function UIMinMap:DoEventAdd()

end


-- 初始化小地图位置
function UIMinMap:OnShow()
    local x, y = MapService:Instance():GetCurrentPos();
    if x == 0 and y == 0 then
        x, y = MapService:Instance():GetTiledCoordinate(PlayerService:Instance():GetMainCityTiledId())
    end
    local UGUIPos = self:GetUGUIPos(x, y);
    self.MapPic.transform.localPosition = UGUIPos
    self:ReShow()
    self:RefreashWildCity()
end

function UIMinMap:ScanMinMap(Index)
    local x, y = MapService:Instance():GetTiledCoordinate(Index)
    local UGUIPos = self:GetUGUIPos(x, y);
    self.MapPic.transform.localPosition = UGUIPos
    self:ReShow()
    self:RefreashWildCity()
end 


function UIMinMap:ReShow()
    local tiledList = List.new();
    local tiledlistCount = PlayerService:Instance():GetTiledIdListCount()
    for i = 1, tiledlistCount do
        tiledList:Push(PlayerService:Instance():GetTiledIdByIndex(i));
    end
    -- 初始化小地图城池
    local PointPicList = tiledList
    for k, v in pairs(self._allPic) do
        if (v.gameObject.activeSelf == true) then
            v.gameObject.localPosition = Vector3.zero
        end
    end
    local PointListSize = PointPicList:Count()
    local GetFormUnVisable = true;
    for index = 1, PointListSize do
        local pic = PointPicList:Get(index)
        local mPic = self._allPic[index]
        if mPic == nil then
            GetFormUnVisable = false
            mPic = UIPic.new()
            GameResFactory.Instance():GetUIPrefab(self._PicperfabPath, self.MapPic, mPic, function(go)
                mPic:Init();
                mPic:SetPicMinMessage(pic, self.MapPic)
                self._allPic[index] = mPic;
            end )
        else
            mPic:SetPicMinMessage(pic, self.MapPic)
        end
    end
end

function UIMinMap:RefreashWildCity()
    local roundWildCity = self:CanShowCity(self.NPC)
    for k, v in pairs(self._allWildPic) do
        if (v.gameObject.activeSelf == true) then
            v.gameObject.localPosition = Vector3.zero
        end
    end
    local PointListSize = roundWildCity:Count()
    local GetFormUnVisable = true;
    for index = 1, PointListSize do
        local pic = roundWildCity:Get(index)
        local mPic = self._allWildPic[index]
        if mPic == nil then
            GetFormUnVisable = false
            mPic = UIPic.new()
            GameResFactory.Instance():GetUIPrefab(self._PicperfabPath, self.MapPic, mPic, function(go)
                mPic:Init();
                mPic:SetMinWildPicMessage(pic, self.MapPic)
                self._allWildPic[index] = mPic;
            end )
        else
            mPic:SetMinWildPicMessage(pic, self.MapPic)
        end
    end

end

function UIMinMap:CanShowCity(list)
    local x, y = MapService:Instance():GetCurrentPos()
    if x == 0 and y == 0 then
        x, y = MapService:Instance():GetTiledCoordinate(PlayerService:Instance():GetMainCityTiledId())
    end
    local list1 = List.new();
    for k, v in pairs(list._list) do
        if math.abs(v.Coordinatex - x) < 200 and math.abs(v.Coordinatey - y) < 200 then
            list1:Push(v)
        end
    end
    return list1
end

-- 小地图UGUI坐标
function UIMinMap:GetUGUIPos(x, y)
    local UIPosX, UIPosY;
    UIPosX =(y - x) * minMapWidth / MapLoad:GetWidth() / 2
    UIPosY = -(y + 1 + x) * minMapHeight / MapLoad:GetHeight() / 2 + minMapHeight / 2
    return Vector3.New(- UIPosX, - UIPosY, 0)
end


return UIMinMap