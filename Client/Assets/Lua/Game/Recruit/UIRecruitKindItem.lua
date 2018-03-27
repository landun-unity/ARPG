--[[ ��ļ�����Ŀ������� ]]

local UIBase = require("Game/UI/UIBase")
local UIRecruitKindItem = class("UIRecruitKindItem", UIBase);
local DataCardSet = require("Game/Table/model/DataCardSet");
local DataCardLoot = require("Game/Table/model/DataCardLoot");
local UIService = require("Game/UI/UIService");
local UIType = require("Game/UI/UIType");
local GetRecruit = require("MessageCommon/Msg/C2L/GetRecruit");
local NetService = require("Game/Net/NetService");
require("Game/Table/model/DataHero")
local List = require("common/List");
local CardModel = require("Game/Hero/HeroCardPart/HeroCard");
local RecruitCards = require("MessageCommon/Msg/C2L/Recruit/RecruitCards");
local RemainderOperation = require("Game/Util/RemainderOperation");
local DataConstruction = require("Game/Table/model/DataConstruction");
local width = 223;
local unfoldWidth = 446;
local ColorRed = UnityEngine.Color(1, 0, 0, 1)
local ColorNormal = UnityEngine.Color(0.75, 0.5, 0.25, 1)
local LimitWidth = 0;
local HZ = 4;
-- override
function UIRecruitKindItem:ctor()
    UIRecruitKindItem.super.ctor(self);
    self.i = 0;
    self.ParentObj = nil;
    self.fun = nil;
    self.fun2 = nil;
    self.RecruitTableId = 0;
    self.RecruitPackageId = 0;
    self.index = 0;
    self.MoreCount = 0;
    self.RecruitHide = nil;
    self.LayoutElement = nil;
    self.go = nil;
    self.CloseCondition = nil;
    self.CostType = nil;
    self.isunlocked = false;
    self.Littletips = nil;
    self.HaveMoney = 0;
    self.HaveJade = 0;
    self.info = nil;
    self.OneCost = 0;
    self.marchTimer = nil;
    self.marchTimer1 = nil;
    self.marchTimer2 = nil;
    self.playTimer1 = nil;
    self.playTimer2 = nil;
    self.Layout = nil;
    self.templist = List.new();
    self.IsOpen = true;

    self.isLast = false;
    -- 设置是不是最后一个
    self.Scrollbar = nil;
    self.TimerTable = { };
    self.effectPos = nil;
    self.effectObj = nil;

end

function UIRecruitKindItem:DoDataExchange()
    self.RecruitKindAllBtn = self:RegisterController(UnityEngine.UI.Button, "All/RecruitKindAllBtn");
    self.Lock = self:RegisterController(UnityEngine.Transform, "All/RecruitKindAllBtn/Lock")
    -- ���ŵĿ���������
    self.RecruitBtn = self:RegisterController(UnityEngine.UI.Button, "All/RecruitHide/RecruitBtn")
    self.DiscountConner = self:RegisterController(UnityEngine.RectTransform, "All/RecruitHide/RecruitBtn/Discount")
    self.RecruitMoreBtn = self:RegisterController(UnityEngine.UI.Button, "All/RecruitHide/RecruitMoreBtn")
    self.RecruitBatchBtn = self:RegisterController(UnityEngine.UI.Button, "All/RecruitHide/RecruitBatchBtn")
    self.QuestionTipBtn = self:RegisterController(UnityEngine.UI.Button, "All/RecruitHide/QuestionTipBtn")
    self.TipLabel = self:RegisterController(UnityEngine.UI.Text, "All/RecruitHide/TipLabel")
    self.CardTableBtn = self:RegisterController(UnityEngine.UI.Button, "All/RecruitKindAllBtn/CardTableBtn")
    self.RecruitMoreBtnLabel = self:RegisterController(UnityEngine.UI.Text, "All/RecruitHide/RecruitMoreBtn/Text")
    self.RecruitType = self:RegisterController(UnityEngine.UI.Text, "All/RecruitKindAllBtn/Type")
    self.RecruitTypeStar = self:RegisterController(UnityEngine.UI.Text, "All/RecruitKindAllBtn/Image/TypeStar")
    self.RecruitHide = self:RegisterController(UnityEngine.Transform, "All/RecruitHide")
    self.KindIcon = self:RegisterController(UnityEngine.UI.Image, "All/RecruitKindAllBtn/Image")
    -- ��������ͼƬ
    self.CoinIcon = self:RegisterController(UnityEngine.UI.Image, "All/RecruitKindAllBtn/Bg/Tips/CoinObj/CoinIcon")
    -- ���һ�����ʯͼƬ
    self.RecruitBtnCoinIcon = self:RegisterController(UnityEngine.UI.Image, "All/RecruitHide/RecruitBtn/CoinObj/CoinIcon")
    self.RecruitBtnFree = self:RegisterController(UnityEngine.RectTransform,"All/RecruitHide/RecruitBtn/Free");
    -- ���һ�����ʯͼƬ
    self.RecruitMoreBtnCoinIcon = self:RegisterController(UnityEngine.UI.Image, "All/RecruitHide/RecruitMoreBtn/CoinObj/CoinIcon")
    -- ���һ�����ʯͼƬ
    self.RecruitBtnCost = self:RegisterController(UnityEngine.UI.Text, "All/RecruitHide/RecruitBtn/CoinObj/Cost")
    self.RecruitMoreBtnCost = self:RegisterController(UnityEngine.UI.Text, "All/RecruitHide/RecruitMoreBtn/CoinObj/Cost")
    self.Cost = self:RegisterController(UnityEngine.UI.Text, "All/RecruitKindAllBtn/Bg/Tips/CoinObj/Cost")
    -- ���ѽ�������
    self.CostObj = self:RegisterController(UnityEngine.Transform, "All/RecruitKindAllBtn/Bg/Tips/CoinObj")
    self.Discount = self:RegisterController(UnityEngine.UI.Image, "All/RecruitKindAllBtn/Bg/Tips/Image")
    -- �ϱߵ���ʾ
    self.DiscountText = self:RegisterController(UnityEngine.UI.Text, "All/RecruitKindAllBtn/Bg/Tips/Image/Discount");
    self.TipsUp = self:RegisterController(UnityEngine.UI.Text, "All/RecruitKindAllBtn/Bg/Tips/TipsUp")
    self.TipsDown = self:RegisterController(UnityEngine.UI.Text, "All/RecruitKindAllBtn/Bg/Tips/TipsDown")
    -- �±ߵ���ʾ
    self.Effect = self:RegisterController(UnityEngine.RectTransform, "All/Effect")
    self.Corner = self:RegisterController(UnityEngine.UI.Image, "All/RecruitKindAllBtn/corner");
    self.CornerText = self:RegisterController(UnityEngine.UI.Text, "All/RecruitKindAllBtn/corner/cornerText");
    self.All = self:RegisterController(UnityEngine.Transform, "All");
    self.TipsDownChild = self:RegisterController(UnityEngine.UI.Text,"All/RecruitKindAllBtn/Bg/Tips/TipsDown/text");
    self.RedPoint = self:RegisterController(UnityEngine.UI.Image,"All/RecruitKindAllBtn/Image/QuantityHint");

    self.LayoutElement = self.go:GetComponent(typeof(UnityEngine.UI.LayoutElement));
    self:CloseRecruitBtnFastly();
end

function UIRecruitKindItem:DoEventAdd()
    self:AddListener(self.RecruitKindAllBtn, self.OnClickAllBtn)
    self:AddListener(self.RecruitBtn, self.OnClickRecruitBtn)
    self:AddListener(self.RecruitMoreBtn, self.OnClickRecruitMoreBtn)
    self:AddListener(self.RecruitBatchBtn, self.OnClickRecruitBatchBtn)
    self:AddListener(self.QuestionTipBtn, self.OnClickQuestionTipBtn)
    self:AddListener(self.CardTableBtn, self.OnClickCardTableBtn)
end


function UIRecruitKindItem:RegisterAllNotice()
    self:RegisterNotice(L2C_Player.SyncGold, self.UpdateMoney);
    self:RegisterNotice(L2C_Player.SyncJade, self.UpdateJade);
    self:RegisterNotice(L2C_Player.RefreshCurrencyInfo, self.UpdateRescouce);
end

-- 更新金钱和玉石
function UIRecruitKindItem:UpdateRescouce()
    self:UpdateMoney();
    self:UpdateJade();
end

-- 更新金钱后更新按钮
function UIRecruitKindItem:UpdateMoney()
    self.HaveMoney = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Money):GetValue();
    if (self.CostType == 4) then
        -- ͭ钱
        if (self.info._isFree == false and self.HaveMoney < self.Line.PriceForOnce) then
            self.RecruitBtnCost.color = ColorRed
        else
            self.RecruitBtnCost.color = ColorNormal
        end
        if (self.HaveMoney < self.Line.PriceForMore) then
            self.RecruitMoreBtnCost.color = ColorRed
        else
            self.RecruitMoreBtnCost.color = ColorNormal
        end
    end
end

-- 更新玉石后更新按钮
function UIRecruitKindItem:UpdateJade()
    self.HaveJade = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Jade):GetValue();
    if (self.CostType == 5) then
        -- ͭ钱
        if (self.info._isFree == false and self.HaveJade < self.Line.PriceForOnce) then
            self.RecruitBtnCost.color = ColorRed
        else
            self.RecruitBtnCost.color = ColorNormal
        end
        if (self.HaveJade < self.Line.PriceForMore) then
            self.RecruitMoreBtnCost.color = ColorRed
        else
            self.RecruitMoreBtnCost.color = ColorNormal
        end
    end
end

-- 点击每个招募背包的方法
function UIRecruitKindItem:OnClickAllBtn()
    if (self.isunlocked == false) then
        return;
    end
    -- print(self.info._curRecruitTimes)
    -- print(self.Line.CloseCondition)
    if (self.info._curRecruitTimes >= 5 and self.Line.DrawEveryDay == 5) then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.RecruitNoCount)
        return;
    end
    self.fun(self.ParentObj, self);
    self.fun2(self.ParentObj);
    self:ShowRecruitBtn(self.isLast);
end

-- 招募单次
function UIRecruitKindItem:OnClickRecruitBtn()
    if (self.info._curRecruitTimes <= 0 and self.Line.CloseCondition == 2) then
        self:CloseRecruitBtn();
        return;
    end
    if (self.CostType == 4) then
        -- ͭ钱
        if (self.HaveMoney < self.OneCost) then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, 1);
            return;
        end
    end
    if (self.CostType == 5) then
        -- 玉石
        if (self.HaveJade < self.OneCost) then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, 4);
            return;
        end
    end
    if RecruitService:Instance():GetTransWay() == CurrencyEnum.Jade and RecruitService:Instance():GetIsTransToExp() == true then
        self:ShowCommonTips(1);
    else
        self:SendMessage(1);
    end

end

-- 招募多次
function UIRecruitKindItem:OnClickRecruitMoreBtn()
    if (self.CostType == 4) then
        -- ͭ钱
        if (self.HaveMoney < self.Line.PriceForMore) then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, 1);
            return;
        end
    end
    if (self.CostType == 5) then
        -- 玉石
        if (self.HaveJade < self.Line.PriceForMore) then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, 4);
            return;
        end
    end
    if RecruitService:Instance():GetTransWay() == CurrencyEnum.Jade and RecruitService:Instance():GetIsTransToExp() == true then
        self:ShowCommonTips(self.MoreCount);
    else
        self:SendMessage(self.MoreCount);
    end
end

-- 发送消息
function UIRecruitKindItem:SendMessage(count)
    if ((count + HeroService:Instance():GetOwnHeroCount()) > RecruitService:Instance():GetMaxHeroCardsCount()) then
        CommonService:Instance():ShowOkOrCancle(self, self.GotoUITactisTransExp, nil, "空间不足", "武将存储空间不足，不能继续招募", "战法经验转换");
    else
        local msg = RecruitCards.new();
        msg:SetMessageId(C2L_Recruit.RecruitCards);
        msg.cardPackageID = self.RecruitPackageId;
        msg.cardCount = count;
        msg.transToExp = RecruitService:Instance():GetIsTransToExp();
        msg.transUnderStarNum = RecruitService:Instance():GetTransUnderStarNum();
        msg.transWay = RecruitService:Instance():GetTransWay();
        NetService:Instance():SendMessage(msg);
    end
end

function UIRecruitKindItem:GotoUITactisTransExp()
    UIService:Instance():HideUI(UIType.UIRecruitUI);
    UIService:Instance():ShowUI(UIType.UITactisTransExp);
end

-- 批量招募
function UIRecruitKindItem:OnClickRecruitBatchBtn()
    UIService:Instance():ShowUI(UIType.UIRecruitBath, self.RecruitPackageId)
end

-- 弹出提示
function UIRecruitKindItem:OnClickQuestionTipBtn()
    if (self.RecruitTableId == 1) then
        -- 如果包id是1
        self.temp = { };
        self.temp[1] = "名将招募"
        self.temp[2] = "【名将招募说明】"
        self.temp[3] = "每次招募可获得10战法经验，并可获赠1张3-5星武将卡\n每招募5次必定获赠1张4-5星武将卡\n每12小时可免费招募一次，半价招募一次"
        self.temp[4] = "【武将卡用途说明】"
        self.temp[5] = "武将卡出了用于战斗外，也可用于提升武将实力：\n转化战法经验\n解锁武将第3个战法格\n拆解战法\n进阶武将\n解锁武将高级兵种"
        UIService:Instance():ShowUI(UIType.UICommonTip, self.temp)
    else
        self.temp = { };
        self.temp[1] = "����"
        self.temp[2] = self.Littletips;
        UIService:Instance():ShowUI(UIType.UICommonTipSmall, self.temp)
    end
end

-- 显示所有的卡包
function UIRecruitKindItem:OnClickCardTableBtn()
    -- print("点击显示所有的卡包")
    local data = {}
    self.templist:Clear();
    for j = 1, #self.Line.CardLootArray do
        local mDataCardLoot = DataCardLoot[self.Line.CardLootArray[j]];
        if (mDataCardLoot ~= nil) then
            local allCards = mDataCardLoot.cardID;
            if (allCards ~= nil) then
                for i = 1, #allCards do
                    local tempitem = CardModel.new();
                    tempitem.tableID = allCards[i];
                    tempitem.level = 1
                    tempitem.star = DataHero[tempitem.tableID].Star
                    tempitem.cost = DataHero[tempitem.tableID].Cost
                    tempitem.camp = DataHero[tempitem.tableID].Camp
                    tempitem.soilderType = DataHero[tempitem.tableID].BaseArmyType
                    self.templist:Push(tempitem);
                end
            end
        end
    end
    isRecruit = true;
    data[1] = self.templist;
    data[2] = isRecruit;
    if UIService:Instance():GetOpenedUI(UIType.UIRecruitUI) then
        UIService:Instance():ShowUI(UIType.UIHeroCardPackage, data);
        UIService:Instance():HideUI(UIType.UIRecruitUI);
    end
    
end

function UIRecruitKindItem:JudgeHasOpenedBtn( ... )
    -- body
    
end


-- 展开 显示招募按钮
function UIRecruitKindItem:ShowRecruitBtn(isLast)
    if self.IsOpen == true then
        return;
    end
    if self.ParentObj:GetRecruitKindItemLock() == true then
        self.ParentObj:SetRecruitKindItemLock(false);
        return;
    end
    self.ParentObj:SetRecruitKindItemLock(true);
    
    local HZCount = 0;
    self:SetLimitWidth();
    local tempWidth = width;
    local recuritUi = UIService:Instance():GetUIClass(UIType.UIRecruitUI);
    local moveValue = unfoldWidth -(5 * width -(self.gameObject.transform.localPosition.x + LimitWidth));
    if (isLast and self.Scrollbar ~= nil) then
        self.playTimer1 = Timer.New( function()
            HZCount = HZCount + 1;
            self.LayoutElement.minWidth = self.LayoutElement.minWidth + width / HZ;
            tempWidth = tempWidth + width / HZ;
            -- print(tempWidth);
            self.All.sizeDelta = Vector2.New(tempWidth, 527);
            if (HZCount == HZ) then
                self.ParentObj:SetRecruitKindItemLock(false);
            end
        end ,
        0.01, HZ,false)
        self.playTimer1:Start();
        recuritUi:MoveLayout(0 - unfoldWidth);
    else
        if self.gameObject.transform.localPosition.x >= 4 * width  and self.ParentObj:FindHadOpendItem(self) == false then
            if moveValue >= 0 then
                recuritUi:MoveLayout(0 - moveValue);
            end
        elseif self.gameObject.transform.localPosition.x >= 4 * width and self.ParentObj:FindHadOpendItem(self) == true then
            if moveValue >= 0 then
                recuritUi:MoveLayout(0 - moveValue + 223)
            end
        end


        self.playTimer1 = Timer.New( function()
            HZCount = HZCount + 1;
            self.LayoutElement.minWidth = self.LayoutElement.minWidth + width / HZ;
            tempWidth = tempWidth + width / HZ;
            -- print(tempWidth);
            self.All.sizeDelta = Vector2.New(tempWidth, 527);
            if (HZCount == HZ) then
                self.ParentObj:SetRecruitKindItemLock(false);
                if GuideServcice:Instance():GetIsFinishGuide() == false then
                    if GuideServcice:Instance():GetCurrentStep() == 56 then
                        GuideServcice:Instance():GoToNextStep();
                    end
                end
            end
        end ,
        0.01, HZ,false)
        self.playTimer1:Start();
    end
    self.IsOpen = true;

end

-- function OpenOrClosePackageEffect(gameObject,endTime,showTime,endFunction,operation)
--     -- body
--     if gameObject == nil then
--         return;
--     end
--     local cdTime = endTime - PlayerService:Instance():GetLocalTime()
--     if cdTime <= 0 then 
--         self.LayoutElement.minWidth = width;
--         self.All.sizeDelta = Vector2.New(unfoldWidth, 527);
--         return;
--     end
--     if operation then

--     else

--     end



-- end



function UIRecruitKindItem:StopAllTimer()
    if self.marchTimer~=nil then
        self.marchTimer:Stop();
    end
    if self.marchTimer1~=nil then
        self.marchTimer1:Stop();
    end
    if self.marchTimer2~=nil then
        self.marchTimer2:Stop();
    end
    if self.playTimer1~=nil then
        self.playTimer1:Stop();
    end
    if self.playTimer2~=nil then
        self.playTimer2:Stop();
    end
end
-- 关闭 不显示招募按钮
function UIRecruitKindItem:CloseRecruitBtn()
    if self.IsOpen == false then
        return;
    end
    if self.ParentObj:GetRecruitKindItemLock() == true then
        return;
    end
    -- print("CameIn")
    
    local tempWidth = unfoldWidth;
    self.playTimer2 = Timer.New( function()
        self.LayoutElement.minWidth = self.LayoutElement.minWidth - width / HZ;
        tempWidth = tempWidth - width / HZ;
        -- print(tempWidth);
        self.All.sizeDelta = Vector2.New(tempWidth, 527);
    end
    , 0.01, HZ,false)
    self.playTimer2:Start();
    self.IsOpen = false;
end

function UIRecruitKindItem:CloseRecruitBtnFastly()
    if self.ParentObj:GetRecruitKindItemLock() == true then
        return;
    end
    if self.IsOpen == false then
        return;
    end
    local tempWidth = unfoldWidth;
    self.playTimer2 = FrameTimer.New( function()
        self.LayoutElement.minWidth = self.LayoutElement.minWidth - width;
        tempWidth = tempWidth - width;
        -- print(tempWidth);
        self.All.sizeDelta = Vector2.New(tempWidth, 527);
    end
    , 1, 1)
    self.playTimer2:Start();
    self.IsOpen = false;
end


-- 设置回调
function UIRecruitKindItem:SetCallBack(object, fun, fun2, go, index)
    self.ParentObj = object;
    self.fun = fun;
    self.fun2 = fun2;
    self.go = go;
    self.index = index;
    self.Line = nil;
end

-- 初始化赵宝卡包
function UIRecruitKindItem:SetRecruitKind(info, isLast, Scrollbar, Layout)


    self.isLast = isLast;
    self.Scrollbar = Scrollbar;
    self.info = info;
    -- self.Effect.gameObject:SetActive(false);
    self.QuestionTipBtn.gameObject:SetActive(false);
    if info == nil then
        return;
    end
    if info._isOpen == 0 then
        self.gameObject:SetActive(false);
    end
    self.RedPoint.gameObject:SetActive(false);
    for i=1,RecruitService:Instance():GetNewRecruitListCount() do
        local newInfo = RecruitService:Instance():GetNewRecruitListByIndex(i);
        if newInfo ~= nil then
            if newInfo._recruitPackageId == info._recruitPackageId then 
                self.RedPoint.gameObject:SetActive(true);
            end
        end
    end


    self.DiscountConner.gameObject:SetActive(false)
    self.RecruitPackageId = info._recruitPackageId;
    self.RecruitTableId = info._tableId;
    self.isunlocked = false;

-- print(info._openBatch)
    if (self.RecruitTableId == 9 and info._openBatch) then
        -- 只有武将有
        self.RecruitBatchBtn.gameObject:SetActive(true)
    else
        self.RecruitBatchBtn.gameObject:SetActive(false)
    end

    self.Discount.gameObject:SetActive(false);
    self.TipsDown.gameObject:SetActive(false);
    self.CostObj.gameObject:SetActive(false);
    self.CoinIcon.gameObject:SetActive(true)
    self.RecruitBtnCoinIcon.gameObject:SetActive(true);
    self.RecruitBtnFree.gameObject:SetActive(false);
    self.RecruitBtnCost.gameObject:SetActive(true);

    self.Line = DataCardSet[self.RecruitTableId];

    self.MoreCount = self.Line.MoreTimes;

    if (self.Line.ConstructionID == 0 and self.Line.ConstructionLv == 0) then
        -- 如果没有填写 默认解锁
        self.isunlocked = true;
    elseif (self.Line.ConstructionID ~= 0 and self.Line.ConstructionLv ~= 0 and PlayerService:Instance():GetmainCityId() ~= 0) then
        local Construction = DataConstruction[self.Line.ConstructionID];
        if (FacilityService:Instance():GetFacilitylevelByIndex(PlayerService:Instance():GetmainCityId(), Construction.Type) >= self.Line.ConstructionLv) then
            self.isunlocked = true;
        end
    end

    if self.Line.CardSetInnerStar ~= "" or nil then
        self.RecruitTypeStar.text = self.Line.CardSetInnerStar;
    else
        self.RecruitTypeStar.transform.parent.gameObject:SetActive(false);
    end
    self.RecruitType.text = self.Line.Name;
    self.KindIcon.sprite = GameResFactory.Instance():GetResSprite(self.Line.CardSetPic);

    if (self.isunlocked == true) then
        -- �����ǽ���������
        self.Lock.gameObject:SetActive(false);
        self.CostObj.gameObject:SetActive(true);
        self.CloseCondition = self.Line.CloseCondition;
        self.CostType = self.Line.CostType;
        self.OneCost = self.Line.PriceForOnce;
        self.CoinIcon.gameObject:SetActive(true)
        if (info._isFree) then
            -- 免费
            self:SetFree();
        elseif (info._isDiscount) then
            -- 半价
            self.OneCost = self.OneCost / 2;
            self.CostObj.gameObject:SetActive(false);
            self.Discount.gameObject:SetActive(true);
            self.RecruitBtnCost.text = tostring(self.OneCost);
            self.DiscountConner.gameObject:SetActive(true)
        else
            self.CostObj.gameObject:SetActive(true);
            self.Discount.gameObject:SetActive(false);
            
            self.RecruitBtnCost.text = tostring(self.OneCost);
        end
        self.RecruitMoreBtnCost.text = self.Line.PriceForMore;

        if (self.CostType == 5) then
            if self.effectObj == nil then
                self.effectObj = EffectsService:Instance():AddEffect(self.Effect.gameObject,EffectsType.CallheroEffect,2);
            else
                -- self.effectObj.gameObject.transform:SetParent(self.Effect.gameObject.transform)
                -- self.effectObj.transform.localPosition = Vector3.zero;
                -- print("CameIn")
                -- EffectsService:Instance():RemoveEffect(self.effectObj);
                -- self.effectObj = EffectsService:Instance():AddEffect(self.Effect.gameObject,EffectsType.CallheroEffect,2);
            end
        end

        if (self.CostType == 4 and info._isFree == false) then
            -- ͭ��
            self.CoinIcon.sprite = GameResFactory.Instance():GetResSprite("Copper");
            -- ��������ͼƬ
            self.RecruitBtnCoinIcon.sprite = self.CoinIcon.sprite;
            self.RecruitMoreBtnCoinIcon.sprite = self.CoinIcon.sprite;
            self.Cost.text = "金币"..self.OneCost;
        end
        if (self.CostType == 5 and info._isFree == false) then
            -- ����
            self.CoinIcon.sprite = GameResFactory.Instance():GetResSprite("Diamond");
            -- ��������ͼƬ
            self.RecruitBtnCoinIcon.sprite = self.CoinIcon.sprite;
            self.RecruitMoreBtnCoinIcon.sprite = self.CoinIcon.sprite;            
            self.Cost.text = "宝石"..self.OneCost;
        end
        if (self.Line.MoreTimes ~= 1 and self.Line.MoreTimes ~= "") then
            -- ��ʾ�������鿨��ť
            self.RecruitMoreBtn.gameObject:SetActive(true);
            self.RecruitMoreBtnLabel.text = "招募" .. self.Line.MoreTimes .. "次"
            self.MoreTimes = self.Line.MoreTimes;
        else
            -- ����ʾ�������鿨��ť
            self.RecruitMoreBtn.gameObject:SetActive(false);
        end

        if (self.Line.FreeCD ~= 0 and self.Line.FreeCD ~= "" and info._isFree == false) then
            local cdTime = self.Line.FreeCD+ info._lastFreeTime;
            -- info._lastFreeTime
            if (cdTime > 0) then
                self.TipsDown.gameObject:SetActive(true);
                self.TipsDownChild.text = "以后免费";
                    CommonService:Instance():TimeDown(UIType.UIRecruitUI, cdTime, self.TipsDown, function() 
                            info._isFree = true
                            RecruitService:Instance():PushElementToNewRecruitList(info);
                            self:SetFree(); 
                            end);
            else
                info._isFree = true
                self:SetFree();
            end
        end

        if (info._cardLevel <= 1) then
            self.Corner.gameObject:SetActive(false);
        else
            self.Corner.gameObject:SetActive(true);
            self.CornerText.text = "" .. info._cardLevel .. "级";
        end


        if (self.Line.CombineToBasicCardSet == true) then
            local cdTime = info._overTime
            -- info._overTime
            if (cdTime <= 0) then
                self.go:SetActive(false);
            else
                self.TipsDown.gameObject:SetActive(true);
                self.TipsDownChild.text = "后合并到名将";
                CommonService:Instance():TimeDown(UIType.UIRecruitUI,cdTime, self.TipsDown, function() 
                    info._isOpne = false;
                    self.gameObject:SetActive(false);
                    end);
            end
        end

        if (self.RecruitTableId == 1) then
            self.TipLabel.text = "再招募" .. 5 - RemainderOperation:TakeOver(self.info._curRecruitTimes, 5) .. "次必获赠4星以上武将"
        else
            self.TipLabel.gameObject:SetActive(false);
        end

        if (self.Line.CloseCondition == 3) then
            if (self.RecruitTableId == 1) then
                self.QuestionTipBtn.gameObject:SetActive(true);
                self.TipLabel.text = "再招募" .. 5 - RemainderOperation:TakeOver(self.info._curRecruitTimes, 5) .. "次必获赠4星以上武将"
            else
                self.QuestionTipBtn.gameObject:SetActive(false);
            end
        else
            self.QuestionTipBtn.gameObject:SetActive(false);
            self.Littletips = "��ʧ�󣬿���ļ���佫�����ϵ�������";
        end

        if (self.Line.CloseCondition == 4) then
            if info._curRecruitTimes >= self.Line.CloseConditionPram2 then
                self._isOpne = false;
                self.gameObject:SetActive(false);
                return;
            end
            self.CoinIcon.gameObject:SetActive(false)
            self.OneCost = 0;
            self.Cost.text = "免费";
            self.RecruitBtnCost.text = "免费";
            self.CoinIcon.sprite = GameResFactory.Instance():GetResSprite("Copper");
            -- ��������ͼƬ
            self.RecruitBtnCoinIcon.sprite = self.CoinIcon.sprite;
            self.RecruitMoreBtnCoinIcon.sprite = self.CoinIcon.sprite;
            self.DiscountConner.gameObject:SetActive(false)
            -- self.TipsDown.gameObject:SetActive(true);
            -- self.TipsDown.text = "剩余次数"..self.Line.CloseConditionPram2-info._curRecruitTimes.."/"..self.Line.CloseConditionPram2;
            -- self.QuestionTipBtn.gameObject:SetActive(true);
            local cdTime = info._overTime
            -- info._overTime
            if (cdTime <= 0) then
                self.go:SetActive(false);
            else
                self.TipsDown.gameObject:SetActive(true);
                self.TipsDownChild.text = "后消失";
                CommonService:Instance():TimeDown(UIType.UIRecruitUI,cdTime, self.TipsDown, function() 
                    info._isOpne = false;
                    self.gameObject:SetActive(false);
                    end);
            end
        end

        if (self.Line.CloseCondition == 2) then 
             if info._curRecruitTimes >= self.Line.CloseConditionPram2 then
                info._isOpne = false;
                self.gameObject:SetActive(false);
             end

        end


        if (self.Line.DrawEveryDay ~= 0) then
            self.TipsDown.gameObject:SetActive(true);
            self.TipsDown.text = "<color=#6c9daf>剩余次数</color>" ;
            self.TipsDownChild.text = "<color=#6c9daf>"..5 - info._curRecruitTimes .. "/" .. self.Line.DrawEveryDay.."</color>";
            -- self.QuestionTipBtn.gameObject:SetActive(true);
            if info._curRecruitTimes == 5 then
                self.TipsUp.gameObject:SetActive(true);
                self.TipsUp.text = "0点重置"
                self.TipsDown.text = "剩余次数" ;
                self.TipsDownChild.text = 5 - info._curRecruitTimes .. "/" .. self.Line.DrawEveryDay;
                -- "<color=#EE5050FF>" .. CommonService:Instance():GetResourceCount(value) .. "</color>";
                self.CostObj.gameObject:SetActive(false);
            end
        end
    else
        -- 如果没有解锁
        self.Lock.gameObject:SetActive(true);
        self.TipsDown.gameObject:SetActive(true);
        self.Corner.gameObject:SetActive(false);
        local buildingname = FacilityService:Instance():GetFacilityNameByID(self.Line.ConstructionID);
        local buildingLv = self.Line.ConstructionLv;
        self.TipsDown.text = "需要" .. buildingname  ;
        self.TipsDownChild.text = "lv" .. buildingLv;
        self.KindIcon.sprite = GameResFactory.Instance():GetResSprite(self.Line.CardSetPicGray);
    end
    self:UpdateMoney()
    self:UpdateJade()
end

-- 设置免费
function UIRecruitKindItem:SetFree()
    self.CoinIcon.gameObject:SetActive(false)
    self.RecruitBtnCoinIcon.gameObject:SetActive(false);
    self.RecruitBtnFree.gameObject:SetActive(true);
    self.RecruitBtnCost.gameObject:SetActive(false);
    self.OneCost = 0;
    self.Cost.text = "免费";
    self.RecruitBtnCost.text = "免费";
    self.DiscountConner.gameObject:SetActive(false)
end

-- 时间转换
function UIRecruitKindItem:TimeFormat(time)
    local h = math.floor(time / 3600);
    local m = math.floor((time % 3600) / 60);
    local s = time % 3600 % 60;
    local timeText = ""
    if (h > 0) then
        timeText = string.format("%02d:%02d:%02d", h, m, s);
    else
        timeText = string.format("%02d:%02d", m, s);
    end
    return timeText;
end

-- -- 播放新卡包的特效
-- function UIRecruitKindItem:PlayNewCardEffect()
--     self.Effect.gameObject:SetActive(true);
--      local ltDescr =self.Effect:DOFade(0.5, 1)
--     ltDescr:OnComplete(self, function() self:PlayEffectOver() end)
-- end

-- -- 播放特效完成
-- function UIRecruitKindItem:PlayEffectOver()
--     self.Effect.gameObject:SetActive(false);
-- end

function UIRecruitKindItem:SetLimitWidth()
    -- body
    LimitWidth = RecruitService:Instance():GetLayoutObjWidth();
end

function UIRecruitKindItem:ShowCommonTips(MoreCount)
    -- body
    CommonService:Instance():ShowOkOrCancle(self, function() self:CommonOk(MoreCount) end
    , function() self:CommonCancle() end
    , "确认"
    , "当前已经使用玉符自动转化" .. RecruitService:Instance():GetTransUnderStarNum() .. "星武将卡，确定招募吗？"
    , "确认"
    , "取消")

end

function UIRecruitKindItem:CommonOk(MoreCount)
    -- body
    RecruitService:Instance():SetIsRecruit(true);
    self:SendMessage(MoreCount);
    UIService:Instance():HideUI(UIType.CommonOkOrCancle);
end
function UIRecruitKindItem:CommonCancle()
    -- body
    RecruitService:Instance():SetIsRecruit(false);
    UIService:Instance():HideUI(UIType.CommonOkOrCancle);
end

return UIRecruitKindItem;

-- endregion