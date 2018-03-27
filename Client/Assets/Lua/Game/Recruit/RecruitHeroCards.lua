--[[��Ϸ������ --��ȡ1-10�ſ���]]

local UIBase= require("Game/UI/UIBase");
local UIType=require("Game/UI/UIType");
local UIConfigTable=require("Game/Table/model/DataUIConfig");
local GetRecruit=require("MessageCommon/Msg/C2L/GetRecruit");
local HeroCard=require("Game/Hero/HeroCardPart/UIHeroCard");
local RecruitCards = require("MessageCommon/Msg/C2L/Recruit/RecruitCards");
require("Game/Recruit/RecruitService");
require("Game/Hero/HeroService");
local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");
local List = require("common/List");
local RecruitHeroCards=class("RecruitHeroCards",UIBase);
local RemainderOperation = require("Game/Util/RemainderOperation");

local DataCardSet = require("Game/Table/model/DataCardSet");

local tempvc3 = UnityEngine.Vector3(0, 0, 0);
local GridPosition = UnityEngine.Vector3(0, 0, 0);
local GridToPosition = UnityEngine.Vector3(520, -346, 0);
local ColorRed = UnityEngine.Color(1, 0, 0, 1)
local ColorNormal = UnityEngine.Color(0.75, 0.5,0.25, 1)
local OriginalPosition = nil;

-- function RecruitHeroCards:OnInit()
--     -- body
--     self:InitAllcards(false);
    
-- end

function RecruitHeroCards:ctor()
    RecruitHeroCards.super.ctor(self)
    self._perfabPath=UIConfigTable[UIType.UIHeroCard].ResourcePath;
    self.HeroCardList = List.new()
    self.RecruitTableId = 0;
    self.RecruitPackageId = 0;
    self.MoreCount = 1;
    self.RecruitCount = 0;
    self.SendMsgWhenOver = false;
    self.CloseUIWhenOver = false;
    self.Line = nil;
    self.CostType = 0;
    self.HaveMoney = 0;
    self.HaveJade = 0;
    self.OneCost = 0;
    self.Go = nil;
    self.Parentui = nil;
    self.callback = nil;
    self.StarNum = 0;
    self.PowerHud = nil;
    self.EffectPos = nil;
    self.AfterSortShowCardList = {};
    -- self.PowerHudOver = nil;
end

function RecruitHeroCards:DoDataExchange()
    self.Grid = self:RegisterController(UnityEngine.Transform,"ScrollView/Grid");
    self.AllBtns = self:RegisterController(UnityEngine.Transform,"bg/AllBtns");
    self.RecruitBtn = self:RegisterController(UnityEngine.UI.Button,"bg/AllBtns/RecruitBtn")
    self.Discount = self:RegisterController(UnityEngine.Transform,"bg/AllBtns/RecruitBtn/Discount")
    self.CloseBtn = self:RegisterController(UnityEngine.UI.Button,"bg/Close")
    self.RecruitMoreBtn = self:RegisterController(UnityEngine.UI.Button,"bg/AllBtns/RecruitMoreBtn")
    self.RecruitBatchBtn = self:RegisterController(UnityEngine.UI.Button,"bg/AllBtns/RecruitBatchBtn")
    self.RecruitMoreBtnLabel = self:RegisterController(UnityEngine.UI.Text,"bg/AllBtns/RecruitMoreBtn/Text")
    self.RecruitBtnCoinIcon = self:RegisterController(UnityEngine.UI.Image,"bg/AllBtns/RecruitBtn/CoinObj/CoinIcon") --���һ�����ʯͼƬ
    self.RecruitMoreBtnCoinIcon = self:RegisterController(UnityEngine.UI.Image,"bg/AllBtns/RecruitMoreBtn/CoinObj/CoinIcon") --���һ�����ʯͼƬ
    self.RecruitBtnCost = self:RegisterController(UnityEngine.UI.Text,"bg/AllBtns/RecruitBtn/CoinObj/Cost") 
    self.RecruitBtnCostType = self:RegisterController(UnityEngine.UI.Text,"bg/AllBtns/RecruitBtn/CoinObj/CostTypeText") 
    self.RecruitMoreBtnCost = self:RegisterController(UnityEngine.UI.Text,"bg/AllBtns/RecruitMoreBtn/CoinObj/Cost")
    self.RecruitMoreBtnCostType = self:RegisterController(UnityEngine.UI.Text,"bg/AllBtns/RecruitMoreBtn/CoinObj/CostTypeText") --���һ�����ʯͼƬ
    self.PowerHud = self:RegisterController(UnityEngine.UI.Text,"bg/PowerHud");
    self.TransExpGrid = self:RegisterController(UnityEngine.Transform,"ScrollView/TransExpGrid");
    -- self.PowerHudParent = self:RegisterController(UnityEngine.RectTransform,"bg/PowerHudParent");
    -- self.PowerHudOver = self:RegisterController(UnityEngine.Transform,"bg/PowerHudOver");
    OriginalPosition = self.PowerHud.gameObject.transform.position;
    OverPosition = UnityEngine.Vector3.New(self.PowerHud.gameObject.transform.localPosition.x,self.PowerHud.gameObject.transform.localPosition.y+50,self.PowerHud.gameObject.transform.localPosition.z);
end

--ע���ؼ������¼�
function RecruitHeroCards:DoEventAdd()
    self:AddListener(self.CloseBtn, self.CloseUI)
    self:AddListener(self.RecruitBtn, self.OnClickRecruitBtn)
    self:AddListener(self.RecruitMoreBtn, self.OnClickRecruitMoreBtn)
    self:AddListener(self.RecruitBatchBtn, self.OnClickRecruitBatchBtn)
end


function RecruitHeroCards:RegisterAllNotice()
    self:RegisterNotice(L2C_Player.SyncGold, self.UpdateMoney);
    self:RegisterNotice(L2C_Player.SyncJade, self.UpdateJade);
    self:RegisterNotice(L2C_Player.RefreshCurrencyInfo, self.UpdateRescouce);
    self:RegisterNotice(L2C_Recruit.SyncRecruitPackage, self.Refresh); 
    self:RegisterNotice(L2C_Recruit.PackageClose,self.ShowCloseInfo);
end

function RecruitHeroCards:Refresh()
    -- if(self.RecruitTableId == RecruitService:Instance():GetLastUpdateID()) then
    --     local info = RecruitService:Instance():GetPackageByID(self.RecruitTableId)
    --     self:InitAllcards(false)   
        -- self:InitRecruitBtnss();
        self.AllBtns.gameObject:SetActive(false);
    -- end
end

function RecruitHeroCards:UpdateRescouce()
    self:UpdateMoney();
    self:UpdateJade();
end

function RecruitHeroCards:UpdateMoney()
    self.HaveMoney = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Money):GetValue();
    if(self.CostType == 4) then --ͭ钱
        if(self.HaveMoney < self.Line.PriceForOnce) then self.RecruitBtnCost.color = ColorRed
        else self.RecruitBtnCost.color = ColorNormal end
        if(self.HaveMoney < self.Line.PriceForMore) then self.RecruitMoreBtnCost.color = ColorRed
        else self.RecruitMoreBtnCost.color = ColorNormal end
    end
end

function RecruitHeroCards:UpdateJade()
    self.HaveJade = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Jade):GetValue();
    if(self.CostType == 5) then --ͭ钱
        if(self.HaveJade < self.Line.PriceForOnce) then self.RecruitBtnCost.color = ColorRed
        else self.RecruitBtnCost.color = ColorNormal end
        if(self.HaveJade < self.Line.PriceForMore) then self.RecruitMoreBtnCost.color = ColorRed
        else self.RecruitMoreBtnCost.color = ColorNormal end
    end
end

---������ļ
function RecruitHeroCards:OnClickRecruitBtn()
     self.RecruitCount = 1;
     self:JudgeSendMsg();
     
end

function RecruitHeroCards:CloseUI()
     self.CloseUIWhenOver = true;
     self:TakeCardsInPackage();
end

--多次招募
function RecruitHeroCards:OnClickRecruitMoreBtn()
    self.RecruitCount = self.MoreCount;
    self:JudgeSendMsg();
end

function RecruitHeroCards:JudgeSendMsg()
    if((self.RecruitCount + HeroService:Instance():GetOwnHeroCount()) > RecruitService:Instance():GetMaxHeroCardsCount()) then
        CommonService:Instance():ShowOkOrCancle(self,self.GotoUITactisTransExp,nil,"空间不足","武将存储空间不足，不能继续招募","战法经验转换");
    else
        local cost = 0;
        if(self.RecruitCount == 1) then 
            cost = self.OneCost
        else
            cost = self.Line.PriceForMore
        end
        if(self.CostType == 4) then --ͭ钱
        if(self.HaveMoney < cost) then
            UIService:Instance():ShowUI(UIType.UICueMessageBox,1);
            return;
        end
        end
        if(self.CostType == 5) then --玉石
            if(self.HaveJade < cost) then
                UIService:Instance():ShowUI(UIType.UICueMessageBox,4);
                return;
            end
        end
        self.SendMsgWhenOver = true;
        self:TakeCardsInPackage();

    end
end

function RecruitHeroCards:GotoUITactisTransExp()
    UIService:Instance():HideUI(UIType.UIRecruitUI);
    UIService:Instance():ShowUI(UIType.UITactisTransExp);
end

function RecruitHeroCards:OnClickRecruitBatchBtn()
    UIService:Instance():ShowUI(UIType.UIRecruitBath,self.RecruitPackageId)
end

function RecruitHeroCards:SendMessage()
    
    local msg = RecruitCards.new(); 					
    msg:SetMessageId(C2L_Recruit.RecruitCards);				
    msg.cardPackageID = self.RecruitPackageId;	
    msg.cardCount = self.RecruitCount;
    msg.transToExp = RecruitService:Instance():GetIsTransToExp();
    msg.transUnderStarNum = RecruitService:Instance():GetTransUnderStarNum();
    msg.transWay = RecruitService:Instance():GetTransWay();
    NetService:Instance():SendMessage(msg);
end

function RecruitHeroCards:SetGo(go)
    self.Go = go;
end

--回调用来显示招募卡包
function RecruitHeroCards:SetCallBack(Parentui,callback)
    self.Parentui = Parentui;
    self.callback = callback;
end

function RecruitHeroCards:InitAllcards(play)
    self.AfterSortShowCardList = {}
    self.RecruitTableId = RecruitService:Instance():GetPackageTableId();
    self.RecruitPackageId = RecruitService:Instance():GetPackageID();
    self.Discount.gameObject:SetActive(false)
    for index = 1,self.HeroCardList:Count() do
        self.HeroCardList:Get(index).gameObject:SetActive(false);
    end
    self:SortCardList();
    local count = RecruitService:Instance():GetShowCardListCount();
    for index = 1,count do
         local afterSortShowCardListIndex = self:CardIndexTransToPos(index,count)
         table.insert(self.AfterSortShowCardList,RecruitService:Instance():GetShowCardByIndex(afterSortShowCardListIndex))
     end
      if RecruitService:Instance():GetNeedEffectShowCardListCount() > 0 then 
        UIService:Instance():ShowUI(UIType.FourStarHeroEffect);
    end
         for index = 1 ,count do
         local info = self.AfterSortShowCardList[index];
         local ui = self.HeroCardList:Get(index)
         if(ui==nil) then
            self:AddChild(info._cardId,info._cardTableId,info._cardLevel);
         else
            ui.gameObject:SetActive(true);
            ui:SetRecruitHeroCard(info._cardId,info._cardTableId,info._cardLevel,index);
            ui:SetHeroCardBtnTrue();
            EffectsService:Instance():AddEffect(ui.EffectPos.gameObject,EffectsType.SymbolEffect,1);
         end        
    end
    
    -- print(RecruitService:Instance():GetNeedEffectShowCardListCount())
   

    -- self:InitRecruitBtnss();
    if(play == true) then
        self:ShowEffect();
    end        
end

function RecruitHeroCards:SortCardList()
    -- body
    RecruitService:Instance():ClearShowCardList();
    local count = RecruitService:Instance():GetCardListCount();
    for i = 5 , 1 , -1 do
        for index = 1,count do
             local info = RecruitService:Instance():GetCardInfoByIndex(index)
             local mmHerocard = DataHero[info._cardTableId];
             if (mmHerocard.Star == i) then
                 RecruitService:Instance():AddShowCard(info);
                 if RecruitService:Instance():GetIsBatchRecruit() == 0 and i == 5 then
                    RecruitService:Instance():AddNeedEffectShowCard(info);
                 end
                 if RecruitService:Instance():GetIsBatchRecruit() == 0 and i == 4 then
                    RecruitService:Instance():AddNeedEffectShowCard(info);
                 end
             end                   
        end
    end
end



function RecruitHeroCards:CardIndexTransToPos(index,cardCount)
    -- body
    if cardCount == 1 then 
        return 1;
    end
    if cardCount == 2 then 
        return index;
    end
    local temp = 0;
    if cardCount > 5 then
         if index <= 5 then
            temp = (index - 3) * 4;                     
            return Mathf.Abs(temp + 1);
        else
            temp = (index - 8) * 4 ;
            if temp >= 0 then
                return temp + 2;
            else 
                return Mathf.Abs(temp);
            end   
        end
    else
        temp = index;
        if temp - 3 >= 0 then
              return (temp - 3) * 2 + 1;
         else
              return (3 - temp) * 2
         end
    end  
end


---初始化招募按钮
function RecruitHeroCards:InitRecruitBtnss()
    self.RecruitTableId = RecruitService:Instance():GetPackageTableId();
    self.RecruitPackageId = RecruitService:Instance():GetPackageID();
    self.Discount.gameObject:SetActive(false)
    self.Line = DataCardSet[self.RecruitTableId];
    local info = RecruitService:Instance():GetPackageByID(self.RecruitPackageId);
    if(info._curRecruitTimes>=self.Line.DrawEveryDay and self.Line.DrawEveryDay == 5) then
        self.AllBtns.gameObject:SetActive(false);
        self.RecruitBtn.gameObject:SetActive(false);
        self.RecruitMoreBtn.gameObject:SetActive(false);
        self.RecruitBatchBtn.gameObject:SetActive(false);
        return;     
    end   
    if(self.RecruitTableId == 24) then
        self.AllBtns.gameObject:SetActive(false);
        self.RecruitBtn.gameObject:SetActive(false);
        self.RecruitMoreBtn.gameObject:SetActive(false);
        self.RecruitBatchBtn.gameObject:SetActive(false);
        return;     
    end

    -- if(info._curRecruitTimes>self.Line.CloseConditionPram2 and self.Line.CloseCondition == 3 and self.Line) then
    --     self.AllBtns.gameObject:SetActive(false);
    --     self.RecruitBtn.gameObject:SetActive(false);
    --     self.RecruitMoreBtn.gameObject:SetActive(false);
    --     self.RecruitBatchBtn.gameObject:SetActive(false);
    --     return; 
    -- end
    if(info._curRecruitTimes>=self.Line.CloseConditionPram2 and self.Line.CloseCondition == 4) then
        self.AllBtns.gameObject:SetActive(false);
        self.RecruitBtn.gameObject:SetActive(false);
        self.RecruitMoreBtn.gameObject:SetActive(false);
        self.RecruitBatchBtn.gameObject:SetActive(false);
        return; 
    end
    self.RecruitBtn.gameObject:SetActive(true);
    self.CostType = self.Line.CostType;
    if(self.CostType == 4) then
        self.RecruitBtnCoinIcon.sprite = GameResFactory.Instance():GetResSprite("Copper"); --��������ͼƬ
        self.RecruitMoreBtnCoinIcon.sprite = self.RecruitBtnCoinIcon.sprite;
        self.RecruitBtnCostType.text = "铜钱";
        self.RecruitMoreBtnCostType.text = "铜钱";
    end
    if(self.CostType == 5) then 
        self.RecruitBtnCoinIcon.sprite = GameResFactory.Instance():GetResSprite("Diamond"); --��������ͼƬ
        self.RecruitMoreBtnCoinIcon.sprite = self.RecruitBtnCoinIcon.sprite;
        self.RecruitBtnCostType.text = "宝石";
        self.RecruitMoreBtnCostType.text = "宝石";
    end

    self.OneCost = self.Line.PriceForOnce;
    self.RecruitBtnCoinIcon.gameObject:SetActive(true)
    
    if(self.RecruitTableId == 9 and info._openBatch) then
        self.RecruitBatchBtn.gameObject:SetActive(true);
    else
        self.RecruitBatchBtn.gameObject:SetActive(false);
    end
    
    if(info._curRecruitTimes<0 and self.Line.CloseCondition == 2) then
        self.RecruitMoreBtn.gameObject:SetActive(false)
    else
        self.RecruitMoreBtn.gameObject:SetActive(true)
    end    

    if(info._isFree) then --免费
        self.RecruitBtnCoinIcon.gameObject:SetActive(false)
        self.OneCost = 0;
        self.RecruitBtnCost.text = "免费";
    elseif(info._isDiscount) then --半价
        self.OneCost = self.OneCost/2;
        self.RecruitBtnCost.text = tostring(self.OneCost);
        self.Discount.gameObject:SetActive(true)
    else
        self.RecruitBtnCost.text = tostring(self.OneCost);
    end
    self.RecruitMoreBtnCost.text = self.Line.PriceForMore;
    if(self.Line.MoreTimes~=1 and self.Line.MoreTimes~="") then
        self.MoreCount = self.Line.MoreTimes;
        self.RecruitMoreBtn.gameObject:SetActive(true);
        self.RecruitMoreBtnLabel.text = "招募"..self.Line.MoreTimes.."次"
    else
        self.RecruitMoreBtn.gameObject:SetActive(false);
    end
    
    
end

function RecruitHeroCards:AddChild(id,tableid,lv)
    local mHeroCard=HeroCard.new();
    GameResFactory.Instance():GetUIPrefab(self._perfabPath,self.Grid,mHeroCard,function (go)
        mHeroCard:Init();
        mHeroCard:SetRecruitHeroCard(id,tableid,lv,RecruitService:Instance():GetTransWay());   
        mHeroCard:SetHeroCardBtnTrue();     
        self.HeroCardList:Push(mHeroCard)
    end);
    mHeroCard:JudgeTransExp(self.StarNum);
    EffectsService:Instance():AddEffect(mHeroCard.EffectPos.gameObject,EffectsType.SymbolEffect,1);
end


function RecruitHeroCards:ShowEffect()
    self:UpdateRescouce();
    self.Grid.localScale = Vector3.zero;
    self.Grid.localPosition = GridPosition;
    --self.RecruitBtn.transform.localScale = tempvc3;
    --self.RecruitMoreBtn.transform.localScale = tempvc3;
    --self.RecruitBatchBtn.transform.localScale = tempvc3;
    -- local ScaleVector =Vector3.New(1.2,1.2,0)
    local time = 0.5;
    local ltDescr = self.Grid:DOScale(Vector3.one, time)
    ltDescr:SetEase(self,EaseType.InOutBack)
    ltDescr:OnComplete(self,function () self:ShowEffectOver() end)
    self.Grid.gameObject:SetActive(true);
    
end

function RecruitHeroCards:ShowEffectOver()
    -- local ScaleVector =Vector3.New(1.2,1.2,0)
    -- local time = 0.2;
    -- local ltDescr1 = self.Grid:DOScale(ScaleVector, time)

    -- ltDescr1:OnComplete(self,
    --     function ()
        -- body
            -- local ltDescr = self.Grid:DOScale(Vector3.one, time)
            -- ltDescr:OnComplete(self,function ()
                -- body
                self:InitRecruitBtnss();
                self:ShowTransExpEffect(RecruitService:Instance():GetTransExpValue())
                self.AllBtns.gameObject:SetActive(true);
            -- end)
        -- end
    -- );
end

function RecruitHeroCards:TakeCardsInPackage()
    self.AllBtns.gameObject:SetActive(false);
     self.Grid.localPosition = GridPosition;     
         local time = 0.3;
     local ltDescr =self.Grid:DOLocalMove(GridToPosition, time)
     self.Grid:DOScale( Vector3.zero, time)
     ltDescr:OnComplete(self,function () self:TakeCardsInPackageOver() end)
end

function RecruitHeroCards:TakeCardsInPackageOver()
     self.Grid.localPosition = GridPosition;
     -------------------use fo test----------------------
     self:ShowEffect();
     
     -------------------use fo test----------------------
     if(self.SendMsgWhenOver) then
        self:SendMessage();
        self.SendMsgWhenOver = false;
     end
     if(self.CloseUIWhenOver) then
        self.CloseUIWhenOver = false;
        self.Go:SetActive(false)
        self.callback(self.Parentui);
     end
     self.Grid.gameObject:SetActive(false); 
end

function RecruitHeroCards:SetTransExpStar(value )
    -- body
    self.StarNum = value;
end

function RecruitHeroCards:ShowCloseInfo()
    -- body
    self:CloseUI();
    UIService:Instance():ShowUI(UIType.UICueMessageBox,UICueMessageType.PackageCloseInfo);
end

function RecruitHeroCards:ShowTransExpEffect(TacticsTransToExpValue)
    if (TacticsTransToExpValue == 0) then
        return;
    end
    
    self.PowerHud.text ="+"..TacticsTransToExpValue;
    self.PowerHud.transform.position = OriginalPosition;
    -- local Timer = Timer.New(function ()
        self.PowerHud.gameObject:SetActive(true);
        local ltDescr = self.PowerHud.transform:DOLocalMove(OverPosition, 1)
        ltDescr:OnComplete(self,function() 
        self:ToChangeProgressOver(self.PowerHud) 
        self.PowerHud.transform.position = OriginalPosition;
        end)
    -- Timer:Stop();
    -- end,0.4,1,false
    
    -- )Timer:Start();
end


-- function UITactisTransExp:ToChangeProgress(addprogress)
--     if (addprogress == 0) then
--         return;
--     end
--     self._AddExp.gameObject:SetActive(true);
--     if (addprogress > 0) then
--         self._AddExp.text = "<color=#00FF00>+" .. addprogress .. "</color>";
--     else
--         self._AddExp.text = "<color=#FF0000>" .. addprogress .. "</color>";
--     end
--     ChangeObj = self._AddExp.gameObject;
--     self._AddExp.transform.localPosition = OriginalPosition;
--     self.cardCountText.text = self._CardInfoList:Count() .. "/" .. HeroService:Instance():GetCardMaxLimit()

--     ltDescr:setOnComplete(System.Action(self.ToChangeProgressOver));
-- end

-- 动画显示完
function RecruitHeroCards:ToChangeProgressOver(PowerHud)
    if (PowerHud) then
        PowerHud.gameObject:SetActive(false);
        PowerHud.gameObject.transform.Position = OriginalPosition;
    end
end


return RecruitHeroCards;

