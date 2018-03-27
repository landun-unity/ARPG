--[[游戏主界面]]

local UIBase= require("Game/UI/UIBase");
local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");
local List = require("common/List");
local UIBatchRecruit=class("UIBatchRecruit",UIBase);
local UIBatchRecruitItem = require("Game/Recruit/UIBatchRecruitItem");
local UIConfigTable=require("Game/Table/model/DataUIConfig");
local DataCardSet = require("Game/Table/model/DataCardSet");
local CurrencyEnum = require("Game/Player/CurrencyEnum");
local DataGameConfig = require("Game/Table/model/DataGameConfig");

function UIBatchRecruit:ctor()
    UIBatchRecruit.super.ctor(self)   
    self.ItemList = List.new();
    self.Index = 1;
    self.ItemPrefab = UIConfigTable[UIType.BatchRecruitItem].ResourcePath;
    self.RecruitKindId = 9;
end

--注册控件
function UIBatchRecruit:DoDataExchange()
    self.backBtn = self:RegisterController(UnityEngine.UI.Button,"BackBtn")
    self.CloseBtn = self:RegisterController(UnityEngine.UI.Button,"Image/TitleAll/CloseBtn")
    self.OKBtn = self:RegisterController(UnityEngine.UI.Button,"Image/OkBtn/OkBtn")
    self.Parent = self:RegisterController(UnityEngine.Transform,"Image/Parent")
end

--注册控件点击事件
function UIBatchRecruit:DoEventAdd()
    self:AddListener(self.backBtn,self.OnClickbackBtnBtn)
    self:AddListener(self.CloseBtn,self.OnClickbackBtnBtn)
    self:AddListener(self.OKBtn,self.OnClickbackBtnBtn)
end

--点击关闭按钮逻辑
function UIBatchRecruit:OnClickbackBtnBtn()
    UIService:Instance():HideUI(UIType.UIBatchRecruit)
end

--所有设为隐藏
function UIBatchRecruit:SetAllFalse()
    local count = self.ItemList:Count();
    for index = 1,count do
        local ui = self.ItemList:Get(index);
        ui:ResetItem();
        ui.gameObject:SetActive(false)
    end
end

function UIBatchRecruit:OnShow()
    self.Index = 1;
    local line = DataCardSet[self.RecruitKindId];
    local info = RecruitService:Instance():GetBatchRecruitInfo();
    self:SetAllFalse();
    local AllCardsCount = info._oneStarCardsCount + info._twoStarCardsCount + info._threeStarCardsCount + info._fourStarCardsCount;
    self:GetUI("已招募",tostring(AllCardsCount));
    self:GetUI("招募消耗",tostring(AllCardsCount/line.MoreTimes*line.PriceForMore),nil,"Copper");
    if(info._transExp>0) then
        
        local transway = RecruitService:Instance():GetTransWay();
        local UnderSar = RecruitService:Instance():GetTransUnderStarNum();
        local cost = 0;
        local onecost = 0;
        local icon = ""
        if(transway == CurrencyEnum.Money) then
            onecost = DataGameConfig[204].OfficialData;
            icon = DataItem[CurrencyEnum.Money + 1].Icon1
        end
        if(transway == CurrencyEnum.Jade) then
            onecost = DataGameConfig[205].OfficialData;
            icon = DataItem[CurrencyEnum.Jade + 1].Icon1
        end
        if(UnderSar == 1) then
            cost = onecost * info._oneStarCardsCount
        elseif(UnderSar == 2) then
            cost = onecost * (info._oneStarCardsCount + info._twoStarCardsCount)
        else
            cost = onecost * (info._oneStarCardsCount + info._twoStarCardsCount + info._threeStarCardsCount)
        end
        self:GetUI("转换战法经验消耗",tostring(cost),nil,icon)
        self:GetUI("获得战法经验",tostring(info._transExp),UnderSar.."星以下武将已转化为战法经验",nil,nil,true);
    end
    if(info._oneStarCardsCount>0)then
        self:GetUI("获得1星卡牌",tostring(info._oneStarCardsCount),nil)
    end
    if(info._twoStarCardsCount>0)then
        self:GetUI("获得2星卡牌",tostring(info._twoStarCardsCount),nil)
    end
    if(info._threeStarCardsCount>0)then
        self:GetUI("获得3星卡牌",tostring(info._threeStarCardsCount),nil)
    end
    if(info._fourStarCardsCount>0)then
        self:GetUI("获得4星卡牌",tostring(info._fourStarCardsCount),nil)
    end
end
    
--显示批量招募的每一条
function UIBatchRecruit:GetUI(text1,text2,text3,coin,power)
    local ui = self.ItemList:Get(self.Index);
    self.Index = self.Index + 1;
    if(ui~=nil) then
        ui:ResetItem()
        ui:InitItem(text1,text2,text3,coin,power)
        ui.gameObject:SetActive(true);
    else
        local mUIBatchRecruitItem = UIBatchRecruitItem.new();
        GameResFactory.Instance():GetUIPrefab(self.ItemPrefab,self.Parent,mUIBatchRecruitItem,function (go)
            mUIBatchRecruitItem:Init();
            mUIBatchRecruitItem:ResetItem();
            self.ItemList:Push(mUIBatchRecruitItem);
            mUIBatchRecruitItem:InitItem(text1,text2,text3,coin,power)
            mUIBatchRecruitItem.gameObject:SetActive(true);
        end);
    end
end

return UIBatchRecruit;
--endregion