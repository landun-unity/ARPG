--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

-- 新手引导固定位置点击引导

local UIBase = require("Game/UI/UIBase");
local UIGuideOneAreaClick = class("UIGuideOneAreaClick", UIBase);

require("Game/Table/model/DataGuide");
local canvas = UGameObject.Find("Canvas");
local landCanvas = UGameObject.Find("LandCanvas");
local canvasMask = UGameObject.Find("Canvas/guideMask");
local landCanvasMask = UGameObject.Find("Canvas/guideLandMask");

-- 构造函数
function UIGuideOneAreaClick:ctor()
    UIGuideOneAreaClick.super.ctor(self);
    self.finger = nil;
    self.fingerAnimParent = nil;
    self.fingerAnimMap = {};
    -- 多少帧换一张图片
    self.animframeCount = 3;
    self._showFingerAnim = false;
    self.frameOffset = 0;
    self.frameOffset2 = 0;
    self.desText = nil;
    self._effectBig1 = nil;
    self._effectBig2 = nil;
    self._effectSmall = nil;
    -- 特效的父物体是否是本界面ui
    self._isAnimParentInGuide = true;
end

-- 控件查找
function UIGuideOneAreaClick:DoDataExchange(args)
    self.finger = self:RegisterController(UnityEngine.Transform, "finger");
    self.fingerAnimParent = self:RegisterController(UnityEngine.Transform, "finger/fingerAnim");
    self.desText = self:RegisterController(UnityEngine.UI.Text, "des");
    for i = 1, 5 do
        self.fingerAnimMap[i] = self:RegisterController(UnityEngine.Transform, "finger/fingerAnim/anim" .. i);
    end
    self._effectBig1 = self:RegisterController(UnityEngine.Transform, "effectBig1");
    self._effectBig2 = self:RegisterController(UnityEngine.Transform, "effectBig2");
    self._effectSmall = self:RegisterController(UnityEngine.Transform, "effectSmall");
end

-- 控件事件添加
function UIGuideOneAreaClick:DoEventAdd()
    
end

-- 当界面显示的时候调用
function UIGuideOneAreaClick:OnShow(param)
    local curStep = GuideServcice:Instance():GetCurrentStep();
    local currentData = DataGuide[curStep];
    if currentData == nil then
        return;
    end

    self.lua_behaviour:SetGuideMaskEnableTrue(canvas, function(go)
        GuideServcice:Instance():GoToNextStep(go);
    end, currentData.ClickToNext == 1);
    self.lua_behaviour:SetGuideMaskEnableTrue(landCanvas, function(go)
        GuideServcice:Instance():GoToNextStep(go);
    end, currentData.ClickToNext == 1);

    if currentData.ClickCanvas == 1 then -- ui界面
        canvasMask.transform.localPosition = Vector3.New(currentData.CoordinateX, currentData.CoordinateY, 0);
        canvasMask.transform.sizeDelta = Vector2.New(currentData.Wide, currentData.Height);
        landCanvasMask.transform.sizeDelta = Vector2.New(0, 0);
    elseif currentData.ClickCanvas == 2 then -- 地图界面
        canvasMask.transform.sizeDelta = Vector2.New(0, 0);
        landCanvasMask.transform.localPosition = Vector3.New(currentData.CoordinateX, currentData.CoordinateY, 0);
        landCanvasMask.transform.sizeDelta = Vector2.New(currentData.Wide, currentData.Height);
    end
    
    self.finger.localPosition = Vector3.New(currentData.FingerCoordinateX, currentData.FingerCoordinateY, 0);
    if currentData.IsFingerMove == 1 then
        if self.fingerAnimParent.gameObject.activeSelf == true then
            self.fingerAnimParent.gameObject:SetActive(false);
        end
        self._showFingerAnim = false;
        LeanTween.move(self.finger, Vector3.New(currentData.FingerEndX, currentData.FingerEndY, 0), 1):setEase(LeanTweenType.linear):setLoopType(LeanTweenType.clamp);
    else
        if self.fingerAnimParent.gameObject.activeSelf == false then
            self.fingerAnimParent.gameObject:SetActive(true);
        end
        self._showFingerAnim = true;
    end

    self.desText.text = currentData.Describe;
    self.desText.transform.localPosition = Vector3.New(currentData.DescribeCoordinateX - 640, currentData.DescribeCoordinateY + 360, 0);

    if currentData.IsHaveEffect1 == 1 then
        self._effectBig1.localPosition = Vector3.New(currentData.Effect1X, currentData.Effect1Y, 0);
        self._effectBig1.sizeDelta = Vector2.New(currentData.Effect1Width, currentData.Effect1Height);
        if self._effectBig1.gameObject.activeSelf == false then
            self._effectBig1.gameObject:SetActive(true);
        end
        self._effectBig1:GetComponent(typeof(UnityEngine.UI.Image)).color = Color.New(1,1,1,1);
        LeanTween.alpha(self._effectBig1, 0, 1):setEase(LeanTweenType.linear):setLoopType(LeanTweenType.pingPong);
    else
        if self._effectBig1.gameObject.activeSelf == true then
            self._effectBig1.gameObject:SetActive(false);
        end
    end
    if currentData.IsHaveEffect2 == 1 then
        self._effectBig2.localPosition = Vector3.New(currentData.Effect2X, currentData.Effect2Y, 0);
        self._effectBig2.sizeDelta = Vector2.New(currentData.Effect2Width, currentData.Effect2Height);
        if self._effectBig2.gameObject.activeSelf == false then
            self._effectBig2.gameObject:SetActive(true);
        end
        self._effectBig2:GetComponent(typeof(UnityEngine.UI.Image)).color = Color.New(1,1,1,1);
        LeanTween.alpha(self._effectBig2, 0, 1):setEase(LeanTweenType.linear):setLoopType(LeanTweenType.pingPong);
    else
        if self._effectBig2.gameObject.activeSelf == true then
            self._effectBig2.gameObject:SetActive(false);
        end
    end
    if currentData.IsHaveEffect3 == 1 then
        self._effectSmall.localPosition = Vector3.New(currentData.Effect3X, currentData.Effect3Y, 0);
        self._effectSmall.sizeDelta = Vector2.New(currentData.Effect3Width, currentData.Effect3Height);
        if self._effectSmall.gameObject.activeSelf == false then
            self._effectSmall.gameObject:SetActive(true);
        end
        self._effectSmall:GetComponent(typeof(UnityEngine.UI.Image)).color = Color.New(1,1,1,1);
        LeanTween.alpha(self._effectSmall, 0, 1):setEase(LeanTweenType.linear):setLoopType(LeanTweenType.pingPong);
    else
        if self._effectSmall.gameObject.activeSelf == true then
            self._effectSmall.gameObject:SetActive(false);
        end
    end
end

function UIGuideOneAreaClick:_OnHeartBeat()
    if self._showFingerAnim == false then
        return;
    end

    if Time.frameCount - self.frameOffset >= self.animframeCount then
        self.frameOffset = Time.frameCount;
        self.frameOffset2 = self.frameOffset2 + 1;
        for i = 1, 5 do            
            if i == self.frameOffset2 then
                if self.fingerAnimMap[i].gameObject.activeSelf == false then
                    self.fingerAnimMap[i].gameObject:SetActive(true);
                end
            else
                if self.fingerAnimMap[i].gameObject.activeSelf == true then
                    self.fingerAnimMap[i].gameObject:SetActive(false);
                end
            end
        end
        if self.frameOffset2 >= 5 then
            self.frameOffset2 = 0;
        end
    end
end

-- 当界面隐藏的时候调用
function UIGuideOneAreaClick:OnHide(param)
	self.lua_behaviour:SetGuideMaskEnableFalse(canvas);
    self.lua_behaviour:SetGuideMaskEnableFalse(landCanvas);
    LeanTween.cancel(self.finger.gameObject);
    self._showFingerAnim = false;
    self.frameOffset = 0;
    self.frameOffset2 = 0;
    LeanTween.cancel(self._effectBig1.gameObject);
    LeanTween.cancel(self._effectBig2.gameObject);
    LeanTween.cancel(self._effectSmall.gameObject);
end

function UIGuideOneAreaClick:ChangeAnimParent(newParent)
    if self._isAnimParentInGuide == false then
        return;
    end

    self._effectBig1.parent = newParent;
    self._effectBig2.parent = newParent;
    self._isAnimParentInGuide = false;
end

function UIGuideOneAreaClick:RevertAnimParent()
    if self._isAnimParentInGuide == true then
        return;
    end

    self._effectBig1.parent = self.transform;
    self._effectBig2.parent = self.transform;
    self._effectBig2:SetAsFirstSibling();
    self._effectBig1:SetAsFirstSibling();
    self._isAnimParentInGuide = true;
end

return UIGuideOneAreaClick;

--endregion
