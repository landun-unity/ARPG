--[[
    筑城界面
--]]

local UIBase = require("Game/UI/UIBase");
local UIBreathingFrame = class("UIBreathingFrame",UIBase);

--构造函数
function UIBreathingFrame:ctor()
    UIBreathingFrame.super.ctor(self);

    --self._tiledImage = nil;

    self.marchTimer = nil;
    self._valueMax = 1;
    self._valueMin = 0.25;
    self._change = 0.02;
    self._curvalue = 1;
    self._isShow = false;
end

--注册控件
function UIBreathingFrame:DoDataExchange()
    --self._tiledImage = self:RegisterController(UnityEngine.UI.Image, "TileImage")
   --self.CitySubImage = self:RegisterController(UnityEngine.UI.Image,"Fortification/fortificationPartCityButton/CitySubImage")
end

--注册点击事件
function UIBreathingFrame:DoEventAdd()
    --self:AddListener(self.fortBtn,self.OnClickFortBtn);
end

function UIBreathingFrame:_OnHeartBeat()
    if self._isShow then
        self:Breathing()
    end
end

function UIBreathingFrame:OnShow(tiled)
    if tiled ~= nil then
        if MapService:Instance():IsBlueBreathingBox(tiled) then
            self.transform:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("power_01");
        else
            self.transform:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("power_08");
        end
    end
    self._isShow = true
end

-- 呼吸
function UIBreathingFrame:Breathing()
    if self._curvalue >= self._valueMax then
        self._change = - self._change
    elseif self._curvalue <= self._valueMin then
        self._change = - self._change
    end
    self._curvalue = self._curvalue + self._change
    if UIService:Instance():GetUIClass(UIType.UIGameMainView) ~= nil then
        self.transform:GetComponent(typeof(UnityEngine.UI.Image)).color = Color.New(1, 1, 1, self._curvalue + self._change);
    end
end


function UIBreathingFrame:HideTiledImage()
    self._isShow = false
end




return UIBreathingFrame;