
local GameObjectFadeInfo = class("GameObjectFadeInfo")

--缩放、渐变动画 信息
function GameObjectFadeInfo:ctor()
    self.fadeObj = nil;
    self.canvasGroup = nil;
    self.isOpen = false;
    self.startAlpha = 0;
    self.endAlpha = 0;
    self.endTime = 0;
    self.fadeTime = 0;
    self.isTweenScal= false;
    self.startScal = 0; 
    self.endScal = 0;
    self.endScalTime = 0;
    self.scalFadeTime = 0;
    self.endFunction = nil; 
end

function GameObjectFadeInfo:ResetData(isImmediately)
    if self.fadeObj ~= nil then
        if isImmediately ~= nil and isImmediately == true then
            self.fadeObj:SetActive(false);
        else
            self.fadeObj:SetActive(self.isOpen);
        end
        self.fadeObj = nil;
    end
    self.canvasGroup = nil;
    self.isOpen = false;
    self.startAlpha = 0;
    self.endAlpha = 0;
    self.endTime = 0;
    self.fadeTime = 0;
    self.isTweenScal= false;
    self.startScal = 0;
    self.endScal = 0;
    self.endScalTime = 0;
    self.scalFadeTime = 0;
    self.endFunction = nil; 
end

function GameObjectFadeInfo:InitData(fadeObj,group,isOpen,startAlpha,endAlpha,endTime,fadeTime,endFunction,isTweenScal,startScal,endScal,endScalTime,scalFadeTime)
    self.fadeObj = fadeObj;
    self.canvasGroup = group;
    self.isOpen = isOpen;
    self.startAlpha = startAlpha;
    self.endAlpha = endAlpha;
    self.endTime = endTime;
    self.fadeTime = fadeTime;
    self.isTweenScal = isTweenScal; 
    self.startScal = startScal;
    self.endScal = endScal;
    self.endScalTime = endScalTime;
    self.scalFadeTime = scalFadeTime;
    self.endFunction = endFunction;
end

function GameObjectFadeInfo:ShowAlpha()
    if self.fadeObj ~= nil then
        local cdTime = (self.endTime - PlayerService:Instance():GetLocalTime());
        if  self.canvasGroup ~= nil then
            if self.fadeTime ~= 0 then
                local  alphaValue = 0;
                if  self.isOpen == true then
                    alphaValue = self.startAlpha + (self.endAlpha - self.startAlpha)*(Time.frameCount - self.endTime)*1000/(self.fadeTime*30);
                    if alphaValue >= self.endAlpha and (self.isTweenScal == nil or (self.isTweenScal ~= nil and self.isTweenScal == false) or 
                        (self.isTweenScal ~= nil and self.isTweenScal == true and self.fadeTime > self.scalFadeTime)) then
                        self.canvasGroup.alpha = self.endAlpha;
                        self:AlphaEnd();
                        return;
                    end
                    self.canvasGroup.alpha = alphaValue;
                else
                     alphaValue = self.startAlpha - (self.startAlpha - self.endAlpha)*(Time.frameCount - self.endTime)*1000/(self.fadeTime*30)
                    if alphaValue <= self.endAlpha and (self.isTweenScal == nil or (self.isTweenScal ~= nil and self.isTweenScal == false) or 
                        (self.isTweenScal ~= nil and self.isTweenScal == true and self.fadeTime > self.scalFadeTime)) then
                        self.canvasGroup.alpha = self.endAlpha;
                        self:AlphaEnd();
                        return;
                    end
                    self.canvasGroup.alpha = alphaValue;
                end
           end
        end
        if self.isTweenScal == true and self.scalFadeTime ~= 0 then
            local scaleValue = 0;
            if  self.isOpen == true then
                scaleValue = self.startScal + (self.endScal - self.startScal)*(Time.frameCount - self.endScalTime)*1000/(self.scalFadeTime*30);
                if scaleValue >= self.endScal and self.scalFadeTime >= self.fadeTime then
                    self.fadeObj.transform.localScale = Vector3.New(self.endScal,self.endScal,self.endScal);
                    self:ScalEnd();
                    return;
                end
                self.fadeObj.transform.localScale = Vector3.New(scaleValue,scaleValue,scaleValue);
            else
                scaleValue = self.startScal - (self.startScal - self.endScal)*(Time.frameCount - self.endScalTime)*1000/(self.scalFadeTime*30)
                if scaleValue <= self.endScal and self.scalFadeTime >= self.fadeTime then
                    self.fadeObj.transform.localScale = Vector3.New(self.endScal,self.endScal,self.endScal);
                    self:ScalEnd();
                    return;
                end
                self.fadeObj.transform.localScale = Vector3.New(scaleValue,scaleValue,scaleValue);
            end
        end
    end
end

function GameObjectFadeInfo:AlphaEnd()
    --print("AlphaEnd:  "..self.fadeObj.name)
    if self.fadeObj ~= nil then
        if self.isOpen == false then
            UnityEngine.GameObject.Destroy(self.canvasGroup);
        end
        if self.endFunction ~= nil then
            self.endFunction();
        end
        CommonService:Instance():RemoveObjFadeInfo(self.fadeObj);
    end
end

function GameObjectFadeInfo:ScalEnd()
    --print("ScalEnd:   "..self.fadeObj.name)
    if self.fadeObj ~= nil then
        self.fadeObj.transform.localScale = Vector3.New(self.endScal,self.endScal,self.endScal);
        if self.endFunction ~= nil then
            self.endFunction();
        end
        CommonService:Instance():RemoveObjFadeInfo(self.fadeObj);
    end
end

return GameObjectFadeInfo
