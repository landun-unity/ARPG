--[[ÓÎÏ·Ö÷½çÃæ]]

local UIBase= require("Game/UI/UIBase");
local UIRecruitBath=class("UIRecruitBath",UIBase);

local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");
local DataCardSet = require("Game/Table/model/DataCardSet");
local RecruitCards = require("MessageCommon/Msg/C2L/Recruit/RecruitCards");

function UIRecruitBath:ctor()
    UIRecruitBath.super.ctor(self)   
    self.ChooseCount = true;
    self.ChooseUntil = false;
    self.RecruitCount = 0;
    self.OnceCost = 0;
    self.RecruitKindId = 0;
    self.MoreTimes = 0;
    self.money = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Money):GetValue();
end

--×¢²á¿Ø¼þ
function UIRecruitBath:DoDataExchange()
    self.BackBtn = self:RegisterController(UnityEngine.UI.Button,"BackBtn")
    self.OkBtn = self:RegisterController(UnityEngine.UI.Button,"RimImage/OkBtn")
    self.OkBtnImage = self:RegisterController(UnityEngine.UI.Image,"RimImage/OkBtn");
    self.CloseBtn = self:RegisterController(UnityEngine.UI.Button,"RimImage/CloseBtn")
    self.CountBtn = self:RegisterController(UnityEngine.UI.Button,"RimImage/TopBg/ToggleCount")
    self.CountMark = self:RegisterController(UnityEngine.Transform,"RimImage/TopBg/ToggleCount/Background/Checkmark")
    self.UntilBtn = self:RegisterController(UnityEngine.UI.Button,"RimImage/BottomBg/Image/ToggleUntilBtn")
    self.UntilMark = self:RegisterController(UnityEngine.Transform,"RimImage/BottomBg/Image/ToggleUntilBtn/Background/Checkmark")
    self.Slider = self:RegisterController(UnityEngine.UI.Slider,"RimImage/TopBg/Slider")
    self.CountLabel = self:RegisterController(UnityEngine.UI.Text,"RimImage/TopBg/Count")
    self.CostMoneyLabel = self:RegisterController(UnityEngine.UI.Text,"RimImage/TopBg/CostMoneyLabel")
end

--×¢²á¿Ø¼þµã»÷ÊÂ¼þ
function UIRecruitBath:DoEventAdd()
    self:AddListener(self.BackBtn,self.OnClickbackBtnBtn)
    self:AddListener(self.OkBtn,self.OnClickOkBtn)
    self:AddListener(self.CloseBtn,self.OnClickbackBtnBtn)
    self:AddListener(self.CountBtn,self.OnClickCountBtn)
    self:AddListener(self.UntilBtn,self.OnClickUntilBtn)
    self:AddSliderOnValueChanged(self.Slider, self.SliderChange);
end

function UIRecruitBath:OnClickbackBtnBtn()
    UIService:Instance():HideUI(UIType.UIRecruitBath);
end

--µã»÷ÕÐÄ¼°´Å¥
function UIRecruitBath:OnClickOkBtn()
    if self.RecruitCount < 1 and self.ChooseCount == true  then
        UIService:Instance():ShowUI(UIType.UICueMessageBox,UICueMessageType.SlideFirst)
        return;
    elseif self.ChooseUntil == false and self.ChooseCount == false then
        UIService:Instance():ShowUI(UIType.UICueMessageBox,UICueMessageType.ChooseMothed)
        return;
    end
    if((10 + HeroService:Instance():GetOwnHeroCount()) > RecruitService:Instance():GetMaxHeroCardsCount()) then
        CommonService:Instance():ShowOkOrCancle(self,self.GotoUITactisTransExp,nil,"空间不足","武将存储空间不足，不能继续招募","战法经验转换");
    else
        local msg = RecruitCards.new(); 					
        msg:SetMessageId(C2L_Recruit.RecruitCards);				
        msg.cardPackageID = self.RecruitKindId;	
        msg.cardCount = self.RecruitCount * self.MoreTimes;
        msg.transToExp = RecruitService:Instance():GetIsTransToExp();
        msg.transUnderStarNum = RecruitService:Instance():GetTransUnderStarNum();
        msg.transWay = RecruitService:Instance():GetTransWay();
        msg.isUntilForeStar = self.ChooseUntil;
        msg.isBatchRecruit = true;
        NetService:Instance():SendMessage(msg);
        self:OnClickbackBtnBtn()
    end
end

function UIRecruitBath:GotoUITactisTransExp()
    UIService:Instance():HideUI(UIType.UIRecruitUI);
    UIService:Instance():HideUI(UIType.UIRecruitBath);
    UIService:Instance():ShowUI(UIType.UITactisTransExp);
end

--µã»÷×Ô¶¨Òå´ÎÊý
function UIRecruitBath:OnClickCountBtn()
    if (self.money < self.OnceCost) then 
        UIService:Instance():ShowUI(UIType.UICueMessageBox,UICueMessageType.NoMoney);
        return;
    end
    if(self.ChooseCount) then
        self.ChooseCount = false;
        self.Slider.value = 0;
    else
        self.ChooseCount = true;
    end
    if self.ChooseCount == true and self.RecruitCount < 1 then
        -- self.OkBtn.enabled = false;
        GameResFactory.Instance():LoadMaterial(self.OkBtnImage,"Shader/HeroCardGray");
    elseif self.ChooseCount == false and self.ChooseUntil == false then
        -- self.OkBtn.enabled = false;
        GameResFactory.Instance():LoadMaterial(self.OkBtnImage,"Shader/HeroCardGray");
    else
        self.OkBtn.enabled = true;
        self.OkBtnImage.material = nil;
    end

    self.CountMark.gameObject:SetActive(self.ChooseCount);
end

--µã»÷Ö±µ½4ÐÇÎªÖ¹
function UIRecruitBath:OnClickUntilBtn()
    if (self.money < self.OnceCost) then 
        UIService:Instance():ShowUI(UIType.UICueMessageBox,UICueMessageType.NoMoney);
        return;
    end
    if(self.ChooseUntil) then
        self.ChooseUntil = false;
    else
        self.ChooseUntil = true;
    end
    if self.ChooseCount == true and self.RecruitCount < 1 then
        -- self.OkBtn.enabled = false;
        GameResFactory.Instance():LoadMaterial(self.OkBtnImage,"Shader/HeroCardGray");
    elseif self.ChooseCount == false and self.ChooseUntil == false then
        -- self.OkBtn.enabled = false;
        GameResFactory.Instance():LoadMaterial(self.OkBtnImage,"Shader/HeroCardGray");
    else
        self.OkBtnImage.material = nil;
    end
    self.UntilMark.gameObject:SetActive(self.ChooseUntil);
end

--ÍÏ¶¯½ø¶ÈÌõ»Øµ÷
function UIRecruitBath:SliderChange()
    if(self.ChooseCount == false and self.Slider.value~=0) then
        self.Slider.value = 0;
        -- self.OkBtn.enabled = false
        GameResFactory.Instance():LoadMaterial(self.OkBtnImage,"Shader/HeroCardGray");
        UIService:Instance():ShowUI(UIType.UICueMessageBox,UICueMessageType.ChooseFirst)
        return;
    end
    self.money = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Money):GetValue();
    local choosemoney = self.Slider.value * self.money;
    if(self.OnceCost == 0) then 
        -- print(RecruitService:Instance():GetPackageByID(self.RecruitKindId)._tableId);
        local line = DataCardSet[RecruitService:Instance():GetPackageByID(self.RecruitKindId)._tableId];
        if(line) then
            self.OnceCost = line.PriceForMore;
            self.MoreTimes = line.MoreTimes
        end
    end

    if(self.OnceCost ~= 0) then 
        if self.money < self.OnceCost*100 then
            local count = math.floor(self.money/self.OnceCost);
            self.RecruitCount = math.floor(self.Slider.value * count);
        else
            self.RecruitCount = math.floor(self.Slider.value * 100) ;
        end
            local count = self.RecruitCount * self.MoreTimes;
            if(count ==0) then 
                GameResFactory.Instance():LoadMaterial(self.OkBtnImage,"Shader/HeroCardGray");
                -- self.OkBtn.enabled = false
             else
                self.OkBtn.enabled = true
                self.OkBtnImage.material = nil;
             end
            self.CountLabel.text = tostring(count)
            self.CostMoneyLabel.text = self.RecruitCount*self.OnceCost.."/"..self.money
    else
        self.RecruitCount = 0;
        self.CountLabel.text = tostring(self.RecruitCount)
        self.CostMoneyLabel.text = "0/"..self.money
        -- self.OkBtn.enabled = false
        GameResFactory.Instance():LoadMaterial(self.OkBtnImage,"Shader/HeroCardGray");
    end
end



function UIRecruitBath:RegisterAllNotice()
    self:RegisterNotice(L2C_Recruit.ReturnCardList, self.ShowGetCards);
end

function UIRecruitBath:OnShow(RecruitKindId)
    self.RecruitKindId = RecruitKindId
    self.money = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Money):GetValue();
    if(self.OnceCost == 0) then 
        -- print(RecruitService:Instance():GetPackageByID(self.RecruitKindId)._tableId);
        local line = DataCardSet[RecruitService:Instance():GetPackageByID(self.RecruitKindId)._tableId];
        if(line) then
            self.OnceCost = line.PriceForMore;
            self.MoreTimes = line.MoreTimes
        end
    end
    -- print(self.OnceCost);
    if (self.money < self.OnceCost) then 
            self.ChooseCount = false;
            self.ChooseUntil = false;
    else
            self.ChooseCount = true;
            self.ChooseUntil = false;
    end    
    self.CountMark.gameObject:SetActive(self.ChooseCount);
    self.UntilMark.gameObject:SetActive(self.ChooseUntil);
    self.Slider.value = 0;
    self.RecruitCount = 0;
    self.CountLabel.text = tostring(self.RecruitCount)
    self.CostMoneyLabel.text = "0/"..self.money
    -- self.OkBtn.enabled = false
    GameResFactory.Instance():LoadMaterial(self.OkBtnImage,"Shader/HeroCardGray");
end

return UIRecruitBath;