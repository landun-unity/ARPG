-- region *.lua
-- Date16/10/19

local UIBase = require("Game/UI/UIBase")

local LoadingUI = class("LoadingUI", UIBase)

function LoadingUI:ctor()

    LoadingUI.super.ctor(self)
    self.LoadingImage = nil;
    self.LoadingPercent = nil;
    self.process = 0;
end

function LoadingUI:DoDataExchange()
    self.LoadingImage = self:RegisterController(UnityEngine.UI.Image, "Silder/Image1")
    self.LoadingPercent = self:RegisterController(UnityEngine.UI.Text, "Percent/Text")
end

function LoadingUI:_OnHeartBeat(args)
    self:OnBeat()
end

function LoadingUI:OnHide()
end

function LoadingUI:OnDestroy()
--    if self then
--        print("___________________________________________")
--        self.LoadingImage = nil;
--        self.LoadingPercent = nil;
--    end
end

function LoadingUI:OnBeat()
    self.process = self.process + 0.03
    if self.process >= 0.99 then
        self.process = 0.99
    end
    if self.LoadingImage ~= nil then
        self.LoadingImage.fillAmount = self.process;
    end
    if self.LoadingPercent ~= nil then
        self.LoadingPercent.text = self.process * 100 .. "%";
    end
end

return LoadingUI
-- endregion