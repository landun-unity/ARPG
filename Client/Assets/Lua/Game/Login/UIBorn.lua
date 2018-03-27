--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local MapLoad = require("Game/Map/MapLoad")
local LayerType = require("Game/Map/LayerType")
local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");
local Canvas = nil;
local UIBase = require("Game/UI/UIBase");
local UIBorn = class("UIBorn", UIBase);
require("Game/Table/model/DataRegion")
require("Game/Table/model/DataTileCut")
require("Game/Table/model/DataState")

function UIBorn:ctor()
    UIBorn.super.ctor(self);
    self.BackBtn = nil;
    self.NextBtn = nil;
    self.MapClickPanel = nil;
    self._tiledMap = nil;
    self.ChooseState = 0;
    Canvas = UGameObject.Find("Canvas");
    self._width = MapLoad:GetWidth();
    self._height = MapLoad:GetHeight();
    self._tiledWidth = MapLoad:GetTiledWidth();
    self._tiledHight = MapLoad:GetTiledHeight();
end

function UIBorn:DoDataExchange(args)
    self.BackBtn = self:RegisterController(UnityEngine.UI.Button, "Back");
    self.NextBtn = self:RegisterController(UnityEngine.UI.Button, "Next");
    self.MapClickPanel = self:RegisterController(UnityEngine.UI.Image, "MapClickPanel");
    self._tiledMap = self:RegisterController(UnityEngine.RectTransform, "MapScroll/Viewport/Content/Map");
end

function UIBorn:DoEventAdd()
    self:AddListener(self.BackBtn, self.OnClickBackBtn);
    self:AddListener(self.NextBtn, self.OnClickNextBtn);
    self.lua_behaviour:AddOnClick(self.MapClickPanel.gameObject, function(...)
        return self.OnMapClick(self, ...)
    end );
end

function UIBorn:OnClickBackBtn()
    UIService:Instance():HideUI(UIType.UIRegisterAccount);
    UIService:Instance():HideUI(UIType.UIBorn);
    UIService:Instance():ShowUI(UIType.UIStartGame);
end

function UIBorn:OnClickNextBtn()
    if self.ChooseState == 0 then
        return;
    end
    LoginService:Instance():SetBornStateId(self.ChooseState);
    -- UIService:Instance():HideUI(UIType.UIBorn);
    UIService:Instance():ShowUI(UIType.UIFoundPlayer);
end

function UIBorn:OnMapClick(obj, eventData)
    local position = self:_ScreenPointToUGUIPosition(eventData.position);
    local x, y = self:UI2MapPos(- position.x, - position.y);
    local stateID = self:GetStateId(x, y);
    if stateID == nil then
        return;
    end
    print(stateID);
    if DataState[stateID] == nil or DataState[stateID].Type ~= 1 then
        return;
    end

    self:ShowChooseState(stateID);
    self.ChooseState = stateID;
end

function UIBorn:_ScreenPointToUGUIPosition(position)
    -- 转化为本地坐标
    self._canvas = Canvas:GetComponent(typeof(UnityEngine.Canvas));
    local isInRect, convertPosition = UnityEngine.RectTransformUtility.ScreenPointToLocalPointInRectangle(self._tiledMap.transform, position, self._canvas.worldCamera);
    return Vector3.New(convertPosition.x, convertPosition.y, 0);
end

function UIBorn:UI2MapPos(x, y)
    local UIPosX = - x;
    local UIPosY = - y - self._tiledMap.rect.height / 2;

    local WorldX = UIPosX * self:GetWidth() * self:GetTiledWidth() / self._tiledMap.rect.width;
    local WorldY = UIPosY * self:GetHeight() * self:GetTiledHeight() / self._tiledMap.rect.height;
    local Tx, Ty = self:UIToTiledPosition(WorldX, WorldY)
    return Tx, Ty
end

-- 根据坐标求格子位置
function UIBorn:UIToTiledPosition(positionX, positionY)
    local x = self:_GetIntPart(- positionX / self:GetTiledWidth() - positionY / self:GetTiledHeight() -0.5);
    local y = self:_GetIntPart(positionX / self:GetTiledWidth() - positionY / self:GetTiledHeight() -0.5);
    return x, y;
end

-- 获取整数部分
function UIBorn:_GetIntPart(value)
    if value < 0 then
        value = math.ceil(value);
    end
    if math.ceil(value) ~= value then
        value = math.ceil(value) -1;
    end

    return value;
end

-- 获取所在州
function UIBorn:GetStateId(x, y)
    if x < 0 or y < 0 or x >= self:GetWidth() or y >= self:GetHeight() then
        return nil;
    end
    local tiledIndex = x * self:GetWidth() + y;
    local stateId = self:GetStateIdByIndex(tiledIndex)
    return stateId
end

function UIBorn:ShowChooseState(stateId)
    if stateId == nil then
        return nil;
    end
    for i = 1, self._tiledMap.transform.childCount do
        if i == stateId then
            self._tiledMap.transform:GetChild(i - 1).transform:Find("child").gameObject:SetActive(true)
        else
            self._tiledMap.transform:GetChild(i - 1).transform:Find("child").gameObject:SetActive(false)
        end
    end
end

function UIBorn:GetStateIdByIndex(index)
    if index == nil then
        return nil;
    end
    if self:GetTerrain(LayerType.State, index) == nil then
        return nil;
    end
    local layer = self:GetTerrain(LayerType.State, index)
    if DataTileCut[layer] == nil or DataTileCut[layer].TileID == nil then
        return nil;
    end
    local dataTile = DataTileCut[layer].TileID

    if DataRegion[dataTile] == nil or DataRegion[dataTile].StateID == nil then
        return nil;
    end
    local StateID = DataRegion[dataTile].StateID;
    if StateID == nil then
        return nil;
    end
    return StateID
end

function UIBorn:GetTerrain( layerType, index )
    return MapLoad:GetTerrain(layerType, index);
end

function UIBorn:GetWidth()
    return MapLoad:GetWidth();
end

-- 高
function UIBorn:GetHeight()
    return MapLoad:GetHeight();
end

-- 宽
function UIBorn:GetTiledWidth()
    return MapLoad:GetTiledWidth();
end

-- 高
function UIBorn:GetTiledHeight()
    return MapLoad:GetTiledHeight();
end

return UIBorn;
--endregion
