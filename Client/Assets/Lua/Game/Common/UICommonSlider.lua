--region *.lua
--通用Slider进度条

local UIBase = require("Game/UI/UIBase");
local UICommonSlider = class("UICommonSlider",UIBase)

function UICommonSlider:ctor()
    
    UICommonSlider.super.ctor(self)
    self.slider = nil;
    self.timeText = nil;
    self.training = nil;
    self.mita = nil;
    self.mitaAround = nil;
    self.imagesParent = nil;
end

function UICommonSlider:DoDataExchange()
    self.timeText = self:RegisterController(UnityEngine.UI.Text, "TimeObjs/TimeText");
    self.slider = self:RegisterController(UnityEngine.UI.Slider, "TimeObjs/Slider");
    self.imagesParent = self:RegisterController(UnityEngine.Transform, "TimeObjs/ImagesParent");
end

function UICommonSlider:DoEventAdd()

end

function UICommonSlider:OnShow()
   
end

--设置进度条前面显示的图片
function UICommonSlider:SetSliderType(sliderType)
    for i =1 ,self.imagesParent.childCount do
        local item = self.imagesParent:GetChild(i-1);
        if i == sliderType then 
            item.gameObject:SetActive(true);
        else
            item.gameObject:SetActive(false); 
        end
    end
end

-- isCurMita 练兵屯田专用（是否是正在屯田中心的格子）
function UICommonSlider:ShowTimes(sliderType,startTime,endTime,endFunction,isCurMita)
    self.gameObject.transform.localScale = Vector3.New(1.52, 1.52, 1.52);
    self:SetSliderType(sliderType);
    self.gameObject:SetActive(true);
    local needTime = endTime - startTime;
    local curTimeStamp = PlayerService:Instance():GetLocalTime();
    --print("  startTime:"..startTime.."  endTime:"..endTime.." curTimeStamp:"..curTimeStamp);
    local valueTime = math.floor(endTime - curTimeStamp);
    if valueTime <= 0 then
        valueTime = 0;
    end
    local cdTime = math.floor(valueTime / 1000);
    self.timeText.text = CommonService:Instance():GetDateString(cdTime);
    self.slider.value = (needTime - valueTime)/needTime;
    CommonService:Instance():TimeDown(nil, endTime,self.timeText,endFunction,self.slider,needTime);
end

return UICommonSlider
