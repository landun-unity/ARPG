--region *.lua
--Date
local UIBase = require("Game/UI/UIBase");
local RechargeGetMonthCardUI = class("RechargeGetMonthCardUI",UIBase)

function RechargeGetMonthCardUI:ctor()
    
    RechargeGetMonthCardUI.super.ctor(self)

    self.exitBtn = nil;
    self.leftTimeText = nil;
    self.GetJadeBtn = nil;
    self.GetBtnText = nil;
    self.background = nil;
end


function RechargeGetMonthCardUI:DoDataExchange()
    self.exitBtn = self:RegisterController(UnityEngine.UI.Button,"Content/HeadlineObj/ExitButton");
    self.leftTimeText = self:RegisterController(UnityEngine.UI.Text,"Content/LeftTimeImage/LeftTimeText");
    self.GetJadeBtn = self:RegisterController(UnityEngine.UI.Button,"Content/GetButton");
    self.GetBtnText = self:RegisterController(UnityEngine.UI.Text,"Content/GetButton/Text");
    self.background = self:RegisterController(UnityEngine.UI.Image,"BackgroundBg");
end

function RechargeGetMonthCardUI:DoEventAdd()
    self:AddListener(self.exitBtn,self.OnClickExitBtn);
    self:AddListener(self.GetJadeBtn,self.OnClickGetJadeBtn);
    self:AddOnClick(self.background,self.OnClickExitBtn);
end

function RechargeGetMonthCardUI:OnShow()

    local couldGet = RechargeService:Instance():CheckCouldGetMonthCard();
    if couldGet == true then  
        self.GetBtnText.text = "领取";
    else
        self.GetBtnText.text = "已领取";
    end
    local leftTime =  RechargeService:Instance():GetMonthCardleftTime(true);
    if leftTime > 3 then
        local timeShow  = math.floor(leftTime);
        self.leftTimeText.text = "有效期剩余<color=#FFFF00>"..timeShow.."</color>天"; 
    else
        local timeShow = math.floor(RechargeService:Instance():GetMonthCardleftTime(false));
        self.leftTimeText.text = "有效期剩余<color=#FFFF00>"..timeShow.."</color>小时"; 
    end
end

function RechargeGetMonthCardUI:OnClickExitBtn()

    UIService:Instance():HideUI(UIType.RechargeGetMonthCardUI);
end

function RechargeGetMonthCardUI:OnClickGetJadeBtn()
    local couldGet = RechargeService:Instance():CheckCouldGetMonthCard();
    if couldGet == true then     
        local msg = require("MessageCommon/Msg/C2L/Recharge/GetMonthCard").new();
        msg:SetMessageId(C2L_Recharge.GetMonthCard);
        NetService:Instance():SendMessage(msg)
        --print("发送领取月卡消息");
    else
        UIService:Instance():ShowUI(UIType.UICueMessageBox,108);
    end
end

return RechargeGetMonthCardUI
