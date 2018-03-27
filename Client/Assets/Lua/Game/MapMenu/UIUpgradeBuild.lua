--[[
    要塞升级
--]]

local UIBase= require("Game/UI/UIBase");
local UIUpgradeBuild=class("UIUpgradeBuild",UIBase);        
local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");
require("Game/Table/InitTable");

--构造函数
function UIUpgradeBuild:ctor()
    UIUpgradeBuild.super.ctor(self);
end

--初始化
function UIUpgradeBuild:DoDataExchange()  

    -- self._landGradeText = self:RegisterController(UnityEngine.UI.Text,"backImg/LandName/landGrade/Text");
    -- self._roomText = self:RegisterController(UnityEngine.UI.Text,"backImg/LandName/place/roomText");
    -- self._Coord = self:RegisterController(UnityEngine.UI.Text,"backImg/LandName/place/Coord");
    -- self.grideNum = self:RegisterController(UnityEngine.UI.Text,"LandName/landGrade/Num");
    -- self._NameText1 = self:RegisterController(UnityEngine.UI,Text,"backImg/Personal/PersonageImage/NameText")
    -- self._NameText2 = self:RegisterController(UnityEngine.UI.Text,"backImg/Personal/HangFlagsImage/NameText");
    -- self.fortress = self:RegisterController(UnityEngine.UI.Button,"FortressObj/fortress")
    -- self.campaigner = self:RegisterController(UnityEngine.UI.Button,"FortressObj/campaigner")
    -- self.garrison = self:RegisterController(UnityEngine.UI.Button,"FortressObj/garrison");
    -- self.signImage = self:RegisterController(UnityEngine.UI.Button,"signImage")
    -- self.abandon = self:RegisterController(UnityEngine.UI.Button,"abandon")
end

--注册按钮点击事件
function UIUpgradeBuild:DoEventAdd()
    -- self:AddListener(self.fortress,self.OnClickFortress);
    -- self:AddListener(self.campaigner,self.OnClickCampaigner);
    -- self:AddListener(self.garrison,self.OnClickGarrison);
    -- self:AddListener(self.signImage,self.OnClickSignImage);
    -- self:AddListener(self.abandon,self.OnClickAbandon)
end





return UIUpgradeBuild