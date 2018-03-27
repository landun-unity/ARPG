--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

-- 新手引导全屏点击引导

local UIBase = require("Game/UI/UIBase");
local UIGuideAllScreenClick = class("UIGuideAllScreenClick", UIBase);

require("Game/Table/model/DataGuide");

-- 构造函数
function UIGuideAllScreenClick:ctor()
    UIGuideAllScreenClick.super.ctor(self);
    self.clickBtn = nil;
    self.desText = nil;
    self.jumpBtn = nil;
    self._effectAnim = nil;
end

-- 控件查找
function UIGuideAllScreenClick:DoDataExchange(args)
    self.clickBtn = self:RegisterController(UnityEngine.UI.Button, "clickPanel");
    self.desText = self:RegisterController(UnityEngine.UI.Text, "desPanel/Text");
    self.jumpBtn = self:RegisterController(UnityEngine.UI.Button, "jumpButton");
    self._effectAnim = self:RegisterController(UnityEngine.Transform, "animImage");
end

-- 控件事件添加
function UIGuideAllScreenClick:DoEventAdd()
    self:AddOnClick(self.clickBtn, self.OnClickAllScreen);
    self:AddOnClick(self.jumpBtn, self.OnClickJump);
end

-- 当界面显示的时候调用
function UIGuideAllScreenClick:OnShow(param)
    local curStep = GuideServcice:Instance():GetCurrentStep();
    local curData = DataGuide[curStep];
    if curData == nil then
        return;
    end

    self.desText.text = curData.Describe;

    if curData.IsHaveEffect1 == 1 then
        self._effectAnim.localPosition = Vector3.New(curData.Effect1X, curData.Effect1Y, 0);
        self._effectAnim.sizeDelta = Vector2.New(curData.Effect1Width, curData.Effect1Height);
        if self._effectAnim.gameObject.activeSelf == false then
            self._effectAnim.gameObject:SetActive(true);
        end
        LeanTween.alpha(self._effectAnim, 0, 1):setEase(LeanTweenType.linear):setLoopType(LeanTweenType.pingPong);
    else
        if self._effectAnim.gameObject.activeSelf == true then
            self._effectAnim.gameObject:SetActive(false);
        end
    end
end

-- 当界面隐藏的时候调用
function UIGuideAllScreenClick:OnHide(param)
    LeanTween.cancel(self._effectAnim.gameObject);
end

function UIGuideAllScreenClick:OnClickAllScreen()
    GuideServcice:Instance():GoToNextStep();
end

function UIGuideAllScreenClick:OnClickJump()
    GuideServcice:Instance():JumpGuide();
end

return UIGuideAllScreenClick;

--endregion
