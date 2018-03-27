--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local GameService = require("FrameWork/Game/GameService")
local GuideManage = require("Game/Guide/GuideManage")
local GuideHandler = require("Game/Guide/GuideHandler")

GuideServcice = class("GuideServcice", GameService)

function GuideServcice:ctor()
    GuideServcice._instance = self;
    GuideServcice.super.ctor(self, GuideManage.new(), GuideHandler.new());
end

function GuideServcice:Instance()
    return GuideServcice._instance;
end

--清空数据
function GuideServcice:Clear()
    self._logic:ctor()
end

function GuideServcice:SetTotalStep(step)
    self._logic:SetTotalStep(step);
end

function GuideServcice:GetCurrentStep()
    return self._logic:GetCurrentStep();
end

function GuideServcice:SetCurrentStep(curStep)
    self._logic:SetCurrentStep(curStep);
end

function GuideServcice:GetIsFinishGuide()
    return self._logic:GetIsFinishGuide();
end

function GuideServcice:GoToNextStep(go)
    self._logic:GoToNextStep(go);
end

function GuideServcice:JumpGuide()
    self._logic:JumpGuide();
end

return GuideServcice;

--endregion
