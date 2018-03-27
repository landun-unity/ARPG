--region *.lua
--Date

local TimeDownInfo = class("TimeDownInfo")

function TimeDownInfo:ctor()
    self.parentUiType = nil;
    self.endTime = 0;   
    self.showText = nil;
    self.timerObj = nil;
    self.endFunction = nil;
    self.showSlider = nil;
    self.needTime = 0;
    self.image = nil;
end

function TimeDownInfo:InitData(parentUiType,endTime,showText,endFunction,showSlider,needTime,image)
    self.parentUiType = parentUiType;
    self.endTime = endTime;
    self.showText = showText;
    self.timerObj = showText.transform.gameObject;
    self.endFunction = endFunction;
    self.showSlider = showSlider;
    if needTime ~= nil then
        self.needTime = needTime;
    end
    self.image = image;
end

function TimeDownInfo:ResetData()
    self.parentUiType = nil;
    self.endTime = 0;   
    self.showText = nil;
    self.timerObj = nil;
--    if self.endFunction ~= nil then
--        self.endFunction();
--        self.endFunction = nil;
--    end
    self.showSlider = nil;
    self.needTime = 0;
    self.image = nil;
end

--计时显示
function TimeDownInfo:ShowTime()
    if  nil ~= self.timerObj then
        local cdTime = math.floor((self.endTime - PlayerService:Instance():GetLocalTime())/ 1000);
        local allNeedTime = math.floor(self.needTime / 1000);
        if self.showText ~= nil then
            self.showText.text = CommonService:Instance():GetDateString(cdTime);
        end
        if self.showSlider ~= nil then
            self.showSlider.gameObject:SetActive(true);
            self.showSlider.value =(allNeedTime - cdTime) / allNeedTime;
        end
        if self.image ~= nil then
            self.image.fillAmount = cdTime / allNeedTime;
        end
        if cdTime <= 0 then        
            CommonService:Instance():RemoveTimeDownInfo(self.timerObj);
            if self.endFunction ~= nil then
                self.endFunction();
            end
        end
    end
end

return TimeDownInfo