--[[招募主界面]]

local UIBase= require("Game/UI/UIBase");
local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");
local UIConfigTable=require("Game/Table/model/DataUIConfig");
local KindItem=require("Game/Recruit/UIRecruitKindItem");
local RecruitHeroCards = require("Game/Recruit/RecruitHeroCards");
require("Game/Recruit/RecruitService");

local CurrencyEnum = require("Game/Player/CurrencyEnum");
local UIRecruit=class("UIRecruit",UIBase);
local List = require("common/List");

function UIRecruit:ctor()
    UIRecruit.super.ctor(self)
    --要加载的预设
    self.KindPrefab = UIConfigTable[UIType.UIRecruitKindItem].ResourcePath;
    HeroCardsPrefab = UIConfigTable[UIType.RecruitHeroCards].ResourcePath;
    self.ParentObj=nil;
    self.SV = nil;
    self.GetHeroCards = nil;--获取卡牌的界面类
    self._allKindItemList=List.new();
    self._allKindItemTab = {};
    self.backBtn = nil;
    self.addBtn = nil;
    self.OwnCountBtn = nil;
    self.OwnHeroLabel = nil;
    self.CardsParent = nil;
    self.HeroCardsPrefab = nil;
    self.ScrolObj = nil;
    self.GetHeroCardsObj = nil;--标记是否打卡获取卡片界面
    self.ChooseBtn = nil;
    self.ChooseBtnLabel = nil;
    self.ChooseBtnImage = nil;
    self.AllChooser = nil;
    self.chooser1 = nil;
    self.chooser2 = nil;
    self.chooser3 = nil;
    self.chooser4 = nil;
    self.chooser5 = nil;
    self.chooser6 = nil;
    self.ChooserLabel1 = nil;
    self.ChooserLabel2 = nil;
    self.ChooserLabel3 = nil;
    self.ChooserLabel4 = nil;
    self.ChooserLabel5 = nil;
    self.ChooserLabel6 = nil;
    self.coinspr = nil;
    self.jadespr = nil;
    self.NewCardsEffect = nil;
    self.Toggle = nil;
    self.Checkmark = nil;
    self.IsTransToExp = false;
    self.IsShowCards = false;
    self.IsUseJade = false;
    self.RecruitKindItemLock = false;
end

--注册控件
function UIRecruit:DoDataExchange()
    self.backBtn = self:RegisterController(UnityEngine.UI.Button,"backBtn")
    self.addBtn = self:RegisterController(UnityEngine.UI.Button,"BgOuter/AddBtn")
    self.OwnCountBtn = self:RegisterController(UnityEngine.UI.Button,"BgOuter/OwnCountBtn")
    self.OwnHeroLabel = self:RegisterController(UnityEngine.UI.Text,"BgOuter/OwnCountBtn/OwnCount")
    self.powerLabel = self:RegisterController(UnityEngine.UI.Text,"BgOuter/PowerImage/PowerCount")
    self.powerImage = self:RegisterController(UnityEngine.Transform,"BgOuter/PowerImage")
    self.coinLabel = self:RegisterController(UnityEngine.UI.Text,"BgOuter/CoinImage/CoinCount")
    self.jadeLabel = self:RegisterController(UnityEngine.UI.Text,"BgOuter/JadeImage/JadeCount")
    self.Scrollbar = self:RegisterController(UnityEngine.UI.Scrollbar,"ScrolObj/Scrollbar");
    self.SV = self:RegisterController(UnityEngine.RectTransform,"ScrolObj/ScrollView");
    self.ParentObj = self:RegisterController(UnityEngine.Transform,"ScrolObj/ScrollView/Layout");
    self.ScrolObj = self:RegisterController(UnityEngine.Transform,"ScrolObj");
    self.CardsParent = self:RegisterController(UnityEngine.Transform,"CardsParent");
    self.ChooseBtn = self:RegisterController(UnityEngine.UI.Button,"ChooseBtn");
    self.Toggle = self:RegisterController(UnityEngine.UI.Button,"Toggle");
    self.Checkmark = self:RegisterController(UnityEngine.Transform,"Toggle/Background/Checkmark");
    self.ChooseBtnLabel=  self:RegisterController(UnityEngine.UI.Text,"ChooseBtn/ChooseBtnLabel");
    self.ChooseBtnImage=  self:RegisterController(UnityEngine.UI.Image,"ChooseBtn/ChooseBtnImage");
    self.AllChooser=  self:RegisterController(UnityEngine.Transform,"ChooseBtn/AllChooser");
    self.chooser1=  self:RegisterController(UnityEngine.UI.Button,"ChooseBtn/AllChooser/chooser1");
    self.chooser2=  self:RegisterController(UnityEngine.UI.Button,"ChooseBtn/AllChooser/chooser2");
    self.chooser3=  self:RegisterController(UnityEngine.UI.Button,"ChooseBtn/AllChooser/chooser3");
    self.chooser4=  self:RegisterController(UnityEngine.UI.Button,"ChooseBtn/AllChooser/chooser4");
    self.chooser5=  self:RegisterController(UnityEngine.UI.Button,"ChooseBtn/AllChooser/chooser5");
    self.chooser6=  self:RegisterController(UnityEngine.UI.Button,"ChooseBtn/AllChooser/chooser6");
    self.ChooserLabel1=  self:RegisterController(UnityEngine.UI.Text,"ChooseBtn/AllChooser/chooser1/ChooserLabel");
    self.ChooserLabel2=  self:RegisterController(UnityEngine.UI.Text,"ChooseBtn/AllChooser/chooser2/ChooserLabel");
    self.ChooserLabel3=  self:RegisterController(UnityEngine.UI.Text,"ChooseBtn/AllChooser/chooser3/ChooserLabel");
    self.ChooserLabel4=  self:RegisterController(UnityEngine.UI.Text,"ChooseBtn/AllChooser/chooser4/ChooserLabel");
    self.ChooserLabel5=  self:RegisterController(UnityEngine.UI.Text,"ChooseBtn/AllChooser/chooser5/ChooserLabel");
    self.ChooserLabel6=  self:RegisterController(UnityEngine.UI.Text,"ChooseBtn/AllChooser/chooser6/ChooserLabel");
    self.coinspr = self:RegisterController(UnityEngine.UI.Image,"ChooseBtn/AllChooser/chooser1/CoinImage");
    self.jadespr = self:RegisterController(UnityEngine.UI.Image,"ChooseBtn/AllChooser/chooser4/CoinImage");
    self.NewCardsEffect = self:RegisterController(UnityEngine.UI.Button,"NewCardsEffect");
    self.BgInner = self:RegisterController(UnityEngine.UI.Image,"BgInner");
    --print(",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,",self.Scrollbar)
end

--注册控件点击事件
function UIRecruit:DoEventAdd()
    self:AddListener(self.backBtn,self.OnClickbackBtnBtn)
    self:AddListener(self.addBtn,self.OnClickAddBtnBtn)
    self:AddListener(self.OwnCountBtn,self.OnClickShowAllHeroBtn)
    self:AddListener(self.ChooseBtn,self.OnClickChooseBtn)
    self:AddListener(self.chooser1,self.OnClickchooser1)
    self:AddListener(self.chooser2,self.OnClickchooser2)
    self:AddListener(self.chooser3,self.OnClickchooser3)
    self:AddListener(self.chooser4,self.OnClickchooser4)
    self:AddListener(self.chooser5,self.OnClickchooser5)
    self:AddListener(self.chooser6,self.OnClickchooser6)
    --self:AddListener(self.NewCardsEffect,self.ClickNewCardsEffect)
    self:AddListener(self.Toggle,self.ClickToggle)
    self:AddOnDrag(self.SV, self.OnSVUp);
end

function UIRecruit:OnBeforeDestroy()
    --print("这还不走吗？？？？？？");

    if self then
        self.super:OnBeforeDestroy();
        CommonService:Instance():RemoveAllTimeDownInfoInUI(UIType.UIRecruitUI);
    end
end

function UIRecruit:RegisterAllNotice()
    self:RegisterNotice(L2C_Recruit.ReturnCardList, self.ShowGetCards);
    self:RegisterNotice(L2C_Recruit.BatchRecruitModel, self.BatchRecruit);
    self:RegisterNotice(L2C_Player.SynchronizeWarfare, self.UpdateWarFare);
    self:RegisterNotice(L2C_Player.SyncGold, self.UpdateMoney);
    self:RegisterNotice(L2C_Player.SyncJade, self.UpdateJade);
    self:RegisterNotice(L2C_Player.RefreshCurrencyInfo, self.UpdateRescouce);
    self:RegisterNotice(L2C_Recruit.SyncRecruitPackage, self.Refresh); 
    -- self:RegisterNotice(L2C_Recruit.SyncRecruitList,self.InitUIRecruit);
    self:RegisterNotice(L2C_Card.AddCardsRespond, self.SetCardCount); 
end

--更新资源
function UIRecruit:UpdateRescouce()
    self:UpdateMoney();
    self:UpdateJade();
end

--当拖动的时候关闭展开
function UIRecruit:OnSVUp(obj,eventData)
    if GuideServcice:Instance():GetIsFinishGuide() == true then
        self:HideAllDrawBtns();
    end
end

--点击关闭按钮逻辑
function UIRecruit:OnClickbackBtnBtn()
    if(self.IsShowCards) then
        self.GetHeroCards:CloseUI();
        self.IsShowCards = false;
        return;
    end
    for k,v in pairs(self._allKindItemTab) do
        EffectsService:Instance():RemoveEffect(v.effectObj);
        v.effectObj = nil;
    end
    -- for k,v in pairs(self._allKindItemTab) do
    --     CommonService:Instance():RemoveTimeDownInfo(v.TipsDown);
    -- end
    UIService:Instance():ShowUI(UIType.UIGameMainView)
    UIService:Instance():HideUI(UIType.UIRecruitUI)
end

--显示出获得了多少张卡牌 收到获得卡牌的接口
function UIRecruit:ShowGetCards()
    self.IsShowCards = true;
    if(self.GetHeroCards==nil or self.GetHeroCardsObj==nil) then
        self.GetHeroCards = RecruitHeroCards.new();
        GameResFactory.Instance():GetUIPrefab(HeroCardsPrefab,self.CardsParent,self.GetHeroCards,function (go)
            self.GetHeroCardsObj = go;
            self.GetHeroCards:SetGo(go)
            self.GetHeroCards:Init();
            if self.IsTransToExp then
                self.GetHeroCards:SetTransExpStar(RecruitService:Instance():GetTransUnderStarNum());
            end
            self.GetHeroCards:InitAllcards(true);
            self.GetHeroCards:SetCallBack(self,self.ShowScrolObj);

        end);
    else
        self.GetHeroCardsObj.gameObject:SetActive(true)
        if self.IsTransToExp then
            self.GetHeroCards:SetTransExpStar(RecruitService:Instance():GetTransUnderStarNum());
        end
        self.GetHeroCards:InitAllcards(true);
        self.GetHeroCards:SetCallBack(self,self.ShowScrolObj);
    end
    self.ScrolObj.gameObject:SetActive(false);
    self.BgInner.gameObject:SetActive(false);
end

function UIRecruit:ShowScrolObj()
    self.ScrolObj.gameObject:SetActive(true);
    self.BgInner.gameObject:SetActive(true);
    self:Refresh();
end

--批量招募返回
function UIRecruit:BatchRecruit()
    UIService:Instance():ShowUI(UIType.UIBatchRecruit);
end

--点击增加玉石按钮购买玉石的逻辑
function UIRecruit:OnClickAddBtnBtn()
   UIService:Instance():ShowUI(UIType.RechargeUI);
end

function UIRecruit:SetCardCount()
    self.OwnHeroLabel.text = "("..HeroService:Instance():GetOwnHeroCount().."/"..RecruitService:Instance():GetMaxHeroCardsCount()..")";
end

--点击某个种类的回调函数
function UIRecruit:OnClickItem(item)
    if(item == nil) then
        return;
    end
    -- for i =1,self._allKindItemList:Count() do
    --     local ui = self._allKindItemList:Get(i);
    --     if(ui~=item) then
    --         ui:CloseRecruitBtn();
    --     end
    -- end
    for k,v in pairs(self._allKindItemTab) do
        if(v~=item) then
            v:CloseRecruitBtn();
        end
    end

end

--点击是否转换为战法经验
function UIRecruit:ClickToggle()
    if self.IsTransToExp == true then
        self.IsTransToExp = false;
    else
        self.IsTransToExp = true;
    end
    RecruitService:Instance():SetIsTransToExp(self.IsTransToExp)
    self:SetToggle();
end

--点击是否转换为战法经验2
function UIRecruit:SetToggle()
    self.Checkmark.gameObject:SetActive(self.IsTransToExp)
end

--筛选
function UIRecruit:OnClickChooseBtn()
    if(self.AllChooser.gameObject.activeSelf == true) then
        self.AllChooser.gameObject:SetActive(false);
    else
        self.AllChooser.gameObject:SetActive(true);
    end
end

--筛选
function UIRecruit:OnClickchooser1()
    self.ChooseBtnLabel.text = self.ChooserLabel1.text;
    self.ChooseBtnImage.sprite = self.coinspr.sprite;
    self.AllChooser.gameObject:SetActive(false);
    RecruitService:Instance():SetTransUnderStarNum(1)
    RecruitService:Instance():SetTransWay(CurrencyEnum.Money)
    self.IsUseJade = false;
end

--筛选
function UIRecruit:OnClickchooser2()
    self.ChooseBtnLabel.text = self.ChooserLabel2.text;
    self.ChooseBtnImage.sprite = self.coinspr.sprite;
    self.AllChooser.gameObject:SetActive(false);
    RecruitService:Instance():SetTransUnderStarNum(2)
    RecruitService:Instance():SetTransWay(CurrencyEnum.Money)
    self.IsUseJade = false;
end

--筛选
function UIRecruit:OnClickchooser3()
    self.ChooseBtnLabel.text = self.ChooserLabel3.text;
    self.ChooseBtnImage.sprite = self.coinspr.sprite;
    self.AllChooser.gameObject:SetActive(false);
    RecruitService:Instance():SetTransUnderStarNum(3)
    RecruitService:Instance():SetTransWay(CurrencyEnum.Money)
    self.IsUseJade = false;
end

--筛选
function UIRecruit:OnClickchooser4()
    self.ChooseBtnLabel.text = self.ChooserLabel4.text;
    self.ChooseBtnImage.sprite = self.jadespr.sprite;
    self.AllChooser.gameObject:SetActive(false);
    RecruitService:Instance():SetTransUnderStarNum(1)
    RecruitService:Instance():SetTransWay(CurrencyEnum.Jade)
end

--筛选
function UIRecruit:OnClickchooser5()
    self.ChooseBtnLabel.text = self.ChooserLabel5.text;
    self.ChooseBtnImage.sprite = self.jadespr.sprite;
    self.AllChooser.gameObject:SetActive(false);
    RecruitService:Instance():SetTransUnderStarNum(2)
    RecruitService:Instance():SetTransWay(CurrencyEnum.Jade)
end

--筛选
function UIRecruit:OnClickchooser6()
    self.ChooseBtnLabel.text = self.ChooserLabel6.text;
    self.ChooseBtnImage.sprite = self.jadespr.sprite;
    self.AllChooser.gameObject:SetActive(false);
    RecruitService:Instance():SetTransUnderStarNum(3)
    RecruitService:Instance():SetTransWay(CurrencyEnum.Jade)
end

--拖动的回调函数 关闭所有打开的种类
function UIRecruit:HideAllDrawBtns()
    -- for i =1,self._allKindItemList:Count() do
    --     self._allKindItemList:Get(i):CloseRecruitBtnFastly();
    -- end
    for k,v in pairs(self._allKindItemTab) do
        v:CloseRecruitBtnFastly();
    end
end


--点击显示所有的英雄按钮
function UIRecruit.OnClickShowAllHeroBtn(self)
    UIService:Instance():HideUI(UIType.UIRecruitUI);
    UIService:Instance():ShowUI(UIType.UIHeroCardPackage);
    --HeroService:Instance():ShowAllHeroCards();
end

--更新战法经验
function UIRecruit:UpdateWarFare()
        self.powerLabel.text = tostring (PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Warfare):GetValue());

end

--更新金币
function UIRecruit:UpdateMoney()
    local haveGold = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Money):GetValue();
    self.coinLabel.text = CommonService:Instance():GetResourceCount(haveGold);
end

--更新玉石
function UIRecruit:UpdateJade()
    self.jadeLabel.text = tostring (PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Jade):GetValue());
end

--刷新
function UIRecruit:Refresh()
    self:FreshUIRecruit();
end

function UIRecruit:OnShow()
    local UIBase = UIService:Instance():GetUIClass(UIType.UIMainCity);
    if UIService:Instance():GetOpenedUI(UIType.UIMainCity) then
        UIBase:OnClickReturnBtn();
    end
    -- local ArmyFunction = UIService:Instance():GetUIClass(UIType.ArmyFunctionUI)
    -- if UIService:Instance():GetOpenedUI(UIType.ArmyFunctionUI) then
    --     UIService:Instance():HideUI(UIType.ArmyFunctionUI)
    -- end
    if(self.GetHeroCards~=nil)then
        self.GetHeroCards.gameObject:SetActive(false);
    end      
    self.ScrolObj.gameObject:SetActive(true);  
    self.BgInner.gameObject:SetActive(true);  
    -- RecruitService:Instance():ClearNewRecruitList();P
    -- print(RecruitService:Instance():GetNewRecruitListCount())
    -- self:InitUIRecruit();
    self:FreshUIRecruit();
    for i = RecruitService:Instance():GetNewRecruitListCount() ,1,-1 do
        local info = RecruitService:Instance():GetNewRecruitListByIndex(i);
        -- print(info);
        if info ~= nil then
            if info._isFree ~= true then
                RecruitService:Instance():RemoveInfoFromNewRecruitList(info);
                i = i-1;
            end
            if info._curRecruitTimes > 1 and DataCardSet[info._tableId].PriceForOnce ~= 0 then
                RecruitService:Instance():RemoveInfoFromNewRecruitList(info);
                i = i-1;
            end
        end        
    end

    if GuideServcice:Instance():GetIsFinishGuide() == true then
        self.SV:GetComponent(typeof(UnityEngine.UI.ScrollRect)).horizontal = true;
    else
        self.SV:GetComponent(typeof(UnityEngine.UI.ScrollRect)).horizontal = false;
    end
end

--初始化方法
function UIRecruit:InitUIRecruit()

    local size = RecruitService:Instance():GetRecruitKindCount();
    
    for index = 1,size do
        local info = RecruitService:Instance():GetRecruitPackageByIndex(index);
        local itemui = self._allKindItemTab[info._recruitPackageId];  
        local isLast = false;
        if(index == size) then
            isLast = true;
        end
        if itemui == nil then
            itemui = self:AddChild(index,info,isLast) 
        else
        end
    end
end

function UIRecruit:FreshUIRecruit()

    self:HideAllDrawBtns();
    if(self.Scrollbar) then
        self.Scrollbar.value = 0;
    end
    self:SetToggle();
    self.AllChooser.gameObject:SetActive(false);
    IsShowGetCards = false;
    self:SetCardCount();
    self:UpdateWarFare()
    self:UpdateMoney()
    self:UpdateJade()
    local size = RecruitService:Instance():GetRecruitKindCount();
    -- for i =1,self._allKindItemList:Count() do        
    --     self._allKindItemList:Get(i).gameObject:SetActive(false)
         
    --      -- self._allKindItemList:Clear();
    -- end
    for k,v in pairs(self._allKindItemTab) do
        v.gameObject:SetActive(false);
    end
    for index = 1,size do
        local info = RecruitService:Instance():GetRecruitPackageByIndex(index);
        -- if RecruitId ~= nil then
        local itemui = self._allKindItemTab[info._recruitPackageId];
        -- end
        -- local itemui = self._allKindItemTab[info._recruitPackageId]; 
        -- itemui.gameObject.transform.localScale = Vector3.New(1, 1, 1);       
        local isLast = false;
        if(index == size) then
            isLast = true;
        end
        if itemui == nil then
            itemui = self:AddChild(index,info,isLast) 
        else
            itemui.gameObject:SetActive(true);
            itemui.gameObject.transform.localScale = Vector3.New(1, 1, 1);  
            itemui:SetRecruitKind(info,isLast,self.Scrollbar,self.ParentObj);            
            itemui.gameObject.transform:SetParent(nil);
            itemui.gameObject.transform:SetParent(self.ParentObj);
        end
        -- self._allKindItemList:Push(itemui);
        
    end
        
    -- for i=1,self._allKindItemList:Count() do
    --     self._allKindItemList:Get(i).gameObject:SetActive(true);
    -- end
    

    -- local count = RecruitService:Instance():GetNewRecruitListCount();
    -- if(count>0) then
    --     local NewCardList = List.new();
    --     for index = 1,count do

    --         local newinfo = RecruitService:Instance():GetNewRecruitListByIndex(index)
    --         NewCardList:Push(newinfo)
    --     end
    --     --self:ShowNewCardsEffect(NewCardList);
    -- else
    --     self.NewCardsEffect.gameObject:SetActive(false);
    -- end
end


function UIRecruit:OnInit()
    -- body

    self:InitUIRecruit();
    -- local UIRecruitShowCard = UIService:Instance():GetUIClass()
    -- if UIRecruitShowCard ~= nil then
    --     UIRecruitShowCard:Init();
    -- end
    -- for i=1,9 do
    --     local mRecruitKind = KindItem.new();
    --     GameResFactory.Instance():GetUIPrefab(self.KindPrefab,self.ParentObj,mRecruitKind,function (go)
    --         mRecruitKind:SetCallBack(self, self.OnClickItem,self.GetLimitWidth,go,i);
    --         mRecruitKind:Init();
    --         self._allKindItemList:Push(mRecruitKind);
    --     end);
    -- end
    
end
  
--添加卡包
function UIRecruit:AddChild(index,info,isLast)
    -- if index <= 9 then
    --     local mRecruitKind = self._allKindItemList:Get(index);
    --     mRecruitKind:SetRecruitKind(info,isLast,self.Scrollbar,self.ParentObj);
    -- else
        local mRecruitKind = KindItem.new();
        GameResFactory.Instance():GetUIPrefab(self.KindPrefab,self.ParentObj,mRecruitKind,function (go)
            mRecruitKind:SetCallBack(self, self.OnClickItem,self.GetLimitWidth,go,index);
            mRecruitKind:Init();
            mRecruitKind:SetRecruitKind(info,isLast,self.Scrollbar,self.ParentObj);
            self._allKindItemTab[info._recruitPackageId] = mRecruitKind;
            mRecruitKind.gameObject.transform:SetParent(nil);
            mRecruitKind.gameObject.transform:SetParent(self.ParentObj);
        end);
    -- end
    return mRecruitKind;
end

--新卡包特效
function UIRecruit:ShowNewCardsEffect(NewCardList)
    self.NewCardsEffect.gameObject:SetActive(true);
end

--点击新卡包特效
function UIRecruit:ClickNewCardsEffect()
    self.NewCardsEffect.gameObject:SetActive(false);    
    local itemui = self._allKindItemList:Get(2)  --临时用第一个测试
    if(itemui) then
        itemui:PlayNewCardEffect();
    end
end

function UIRecruit:GetLimitWidth()
    -- body
    local parentObjX = self.ParentObj.transform.localPosition.x;
    RecruitService:Instance():SetLayoutObjWidth(parentObjX);
end

function UIRecruit:MoveLayout(moveValue)
    -- body    
    local pos = Vector3.New(self.ParentObj.transform.localPosition.x + moveValue,self.ParentObj.transform.localPosition.y,self.ParentObj.transform.localPosition.z);
    print(pos.x,"      ",pos.y)
    self.ParentObj:DOLocalMove(pos,0.6)
end

function UIRecruit:SetRecruitKindItemLock(value)
    -- body
    self.RecruitKindItemLock = value;
end

function UIRecruit:GetRecruitKindItemLock()
    -- body
    return self.RecruitKindItemLock;
end

function UIRecruit:FindHadOpendItem(item)
    -- for i =1,self._allKindItemList:Count() do
    --     local ui = self._allKindItemList:Get(i);
    --     if(ui~=item) then
    --         if ui.LayoutElement.minWidth > 223 then
    --             return true;
    --         end
    --     end
    -- end
    -- return false;

    for k,v in pairs(self._allKindItemTab) do
        if(v ~= item)then
            if v.LayoutElement.minWidth > 250 then
                return true;
            end
        end
    end
    return false;
end


function UIRecruit:OnHide()
    -- body
    
    
end

function UIRecruit:OnDestroy()
    -- body
    -- if self == nil then
    --     return;
    -- end
end


return UIRecruit;
--endregion