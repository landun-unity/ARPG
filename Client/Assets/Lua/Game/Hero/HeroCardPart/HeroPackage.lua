-- Anchor:Dr
-- Date:16/9/13
-- 英雄卡牌背包

local UIBase = require("Game/UI/UIBase");
local List = require("common/List");
local HeroCard = require("Game/Hero/HeroCardPart/HeroCard");
require("Game/Hero/HeroCardPart/HeroSortType");
require("Game/Hero/HeroCardPart/HeroHandSort");
require("Game/Table/model/DataHero")
local UIConfigTable = require("Game/Table/model/DataUIConfig");
local HeroPackage = class("HeroPackage", UIBase);
local UIHeroCard = require("Game/Hero/HeroCardPart/UIHeroCard");

local firstPosy = 0;
local firstPosx = 0;

local AddX = 180;
local AddY = -240

local betweeny = 10
local CardNum = 24;
local CardRow = 0;
local imageWidth = 1000
local cardHeight = 218;
local cardWidth = 164;
local OldRow = 0;

function HeroPackage:ctor()
    HeroPackage.super.ctor(self);
    -- 预制件路径
    self._perfabPath = UIConfigTable[UIType.UIHeroCard].ResourcePath;
    -- 预制父物体
    self._parentObj = nil;
    self.HeroCardList = List.new();
    -- 临时卡牌列表
    self._allHeroCardDic = { };
    -- _tempDic = {};
    -- 所有的英雄
    self._allOwnHeroes = List.new();
    -- 返回按钮
    self._backBtn = nil;
    self.pageButton = nil;
    self.heroPicBtn = nil;
    self.page = nil;
    self.heroNum = nil
    self.rarity = nil;
    self.armTtpe = nil;
    self.camp = nil;
    self.level = nil;
    self.cost = nil;
    self.default = nil;
    self.lastMove = Vector3.zero
    self.myHeroList = nil;
    self.srotType = nil;
    self._myList = nil;
    self.ScorllPos = nil;
    self.GirdPos = nil;
    self.recuitList = nil;
    self.isRecruit = nil;

    local canvas = UGameObject.Find("Canvas");
    self._canvas = canvas:GetComponent(typeof(UnityEngine.Canvas));
    --
    self._localPointerPosition = nil;
    -- 拖拽滑动效果
    self.startPos = Vector3.zero
    self.endPos = Vector3.zero
    self.ImageHeight = 0;
    self._ctorVect = nil;
    self._mMove = nil;
    self._btnState = nil;
    self._scorllState = 0;
    self._upCallBack = nil;
    self._downCallBack = nil;
    self._clickCallBack = nil;
    self._lastPosition = nil;
    self._BeDragObj = nil;
    self._BeDragData = nil;
    self.lastGirdPos = nil;
    self.clickOn = false
end



-- override
function HeroPackage:DoDataExchange()

    self.scrollView = self:RegisterController(UnityEngine.UI.ScrollRect, "CancelButton/ScrollView");
    self.GirdPos = self:RegisterController(UnityEngine.Transform, "CancelButton/ScrollView/Grid/Image");
    self.GirdPosImage = self:RegisterController(UnityEngine.RectTransform, "CancelButton/ScrollView/Grid/Image");
    self._parentObj = self:RegisterController(UnityEngine.Transform, "CancelButton/ScrollView/Grid/Image");
    self._backBtn = self:RegisterController(UnityEngine.UI.Button, "CancelButton/Background/QuitButton/Button");
    self.heroPicBtn = self:RegisterController(UnityEngine.UI.Button, "CancelButton/Background/GeneralButton/Button1");
    self.GenerBtn = self:RegisterController(UnityEngine.Transform, "CancelButton/Background/GeneralButton");
    self.page = self:RegisterController(UnityEngine.UI.Image, "CancelButton/Page");
    self.pageButton = self:RegisterController(UnityEngine.UI.Button, "CancelButton/PageButton");
    self.rarity = self:RegisterController(UnityEngine.UI.Button, "CancelButton/Page/rarity");
    self.armTtpe = self:RegisterController(UnityEngine.UI.Button, "CancelButton/Page/armTtpe");
    self.camp = self:RegisterController(UnityEngine.UI.Button, "CancelButton/Page/camp");
    self.level = self:RegisterController(UnityEngine.UI.Button, "CancelButton/Page/level");
    self.cost = self:RegisterController(UnityEngine.UI.Button, "CancelButton/Page/cost");
    self.default = self:RegisterController(UnityEngine.UI.Button, "CancelButton/Page/default");
    self.heroNum = self:RegisterController(UnityEngine.UI.Text, "CancelButton/num");
    -- 滑动方式更改
    -- self.BackImage = self:RegisterController(UnityEngine.UI.RectTransform, "CancelButton/ScrollView/Grid/Image");
end

function HeroPackage:DoEventAdd()
    self:AddListener(self._backBtn, self.OnClickBackBtn)
    self:AddListener(self.heroPicBtn, self.OnClickheroPicBtn)
    self:AddListener(self.pageButton, self.OnClickPageBtn)
    self:AddListener(self.rarity, self.OnClickrarityBtn)
    self:AddListener(self.armTtpe, self.OnClickarmTtpeBtn)
    self:AddListener(self.camp, self.OnClickcampBtn)
    self:AddListener(self.level, self.OnClicklevelBtn)
    self:AddListener(self.cost, self.OnClickcostBtn)
    self:AddListener(self.default, self.OnClickdefaultBtn)
    self:AddOnDown(self.scrollView, self.OnDown);
    self:AddOnValueChanged(self.scrollView, self.OnChange);
    self:AddOnUp(self.scrollView, self.OnUp);
end

function HeroPackage:_OnHeartBeat()
    GameResFactory.Instance():CloseUIOnTouch( function()
        if self.page.gameObject.activeSelf then
            self.page.gameObject:SetActive(false)
        end
    end );
end

function HeroPackage:OnInit()
    self:LoadPrefab()
end

function HeroPackage:LoadPrefab()
    for index = 1, CardNum do
        local mHeroCard = self._allHeroCardDic[index];
        if mHeroCard == nil then
            mHeroCard = UIHeroCard.new();
            GameResFactory.Instance():GetUIPrefab(self._perfabPath, self._parentObj, mHeroCard, function(go)
                mHeroCard:Init();
                self.HeroCardList:Push(mHeroCard);
                self._allHeroCardDic[index] = mHeroCard
            end );
        end
    end
end

-- 返回按钮
function HeroPackage:OnClickBackBtn()
    UIService:Instance():HideUI(UIType.UIHeroCardPackage);
    UIService:Instance():ShowUI(UIType.UIGameMainView);
    if self.isRecruit ~= nil and self.isRecruit == true then
        UIService:Instance():ShowUI(UIType.UIRecruitUI);
    end
end


-- 点击武将图鉴 
function HeroPackage:OnClickheroPicBtn()
    local msg = require("MessageCommon/Msg/C2L/Card/GeneralsAlt").new();
    msg:SetMessageId(C2L_Card.GeneralsAlt);
    NetService:Instance():SendMessage(msg);
end

function HeroPackage:GoToHeroHandBook()
    local data = { self:GetAllHero(), HeroHandSort.all };
    UIService:Instance():ShowUI(UIType.UIHeroHandbook, data);
end


function HeroPackage:HideSortMenu()
    if self.gameObject.activeSelf then
        self.page.gameObject:SetActive(false)
    end
end


function HeroPackage:OnClickPageBtn()

    if self.page.gameObject.activeSelf then
        self.page.gameObject:SetActive(false)
    else
        self.page.gameObject:SetActive(true)
    end

end


function HeroPackage:OnClickrarityBtn()
    self:SetSortType(HeroSortType.rarity);
    if self.recuitList == nil then
        UIService:Instance():GetUIClass(UIType.UIHeroCardPackage):OnShow()
    else
        UIService:Instance():GetUIClass(UIType.UIHeroCardPackage):OnShow(self.recuitList)
    end
end

function HeroPackage:OnClickarmTtpeBtn()
    self:SetSortType(HeroSortType.armTtpe);
    if self.recuitList == nil then
        UIService:Instance():GetUIClass(UIType.UIHeroCardPackage):OnShow()
    else
        UIService:Instance():GetUIClass(UIType.UIHeroCardPackage):OnShow(self.recuitList)
    end
end

function HeroPackage:OnClickcampBtn()
    self:SetSortType(HeroSortType.camp);
    if self.recuitList == nil then
        UIService:Instance():GetUIClass(UIType.UIHeroCardPackage):OnShow()
    else
        UIService:Instance():GetUIClass(UIType.UIHeroCardPackage):OnShow(self.recuitList)
    end
end

function HeroPackage:OnClicklevelBtn()
    self:SetSortType(HeroSortType.level);
    if self.recuitList == nil then
        UIService:Instance():GetUIClass(UIType.UIHeroCardPackage):OnShow()
    else
        UIService:Instance():GetUIClass(UIType.UIHeroCardPackage):OnShow(self.recuitList)
    end
end

function HeroPackage:OnClickcostBtn()
    self:SetSortType(HeroSortType.cost);
    if self.recuitList == nil then
        UIService:Instance():GetUIClass(UIType.UIHeroCardPackage):OnShow()
    else
        UIService:Instance():GetUIClass(UIType.UIHeroCardPackage):OnShow(self.recuitList)
    end
end
function HeroPackage:OnClickdefaultBtn()
    self:SetSortType(HeroSortType.default);
    if self.recuitList == nil then
        UIService:Instance():GetUIClass(UIType.UIHeroCardPackage):OnShow()
    else
        UIService:Instance():GetUIClass(UIType.UIHeroCardPackage):OnShow(self.recuitList)
    end
end
-- override
-- @mParem:拥有武将卡list
function HeroPackage:OnShow(param)
    -- 初始化位置
    self.isRecruit = nil;
    local data = nil;
    if param ~= nil then
        data = param[1];
        local isRecruit = param[2];
        if isRecruit ~= nil and isRecruit == true then
            self.isRecruit = isRecruit;
        end
    end
    self.page.gameObject:SetActive(false);
    local herolist = self:GetMyHeroList()
    local sortType = self:GetSortType()
    self._myList = herolist;
    if data ~= nil then
        self._myList = data
        self.recuitList = data
        self.GenerBtn.gameObject:SetActive(false)
        self.heroNum.text = self.recuitList:Count()
    else
        self.recuitList = nil
        if HeroService:Instance():GetCardMaxLimit() ~= nil then
            self.heroNum.text = self._myList:Count() .. "/" .. HeroService:Instance():GetCardMaxLimit()
        end
        self.GenerBtn.gameObject:SetActive(true)
    end
    self._myList = HeroService:Instance():sortingInPackage(sortType, self._myList)
    HeroService:Instance():SetSortList(self._myList)
    -- 设置Content的高度，获取第一张卡牌的位置
    local cardCount = self._myList:Count()
    if cardCount <= 6 then
        cardCount = 7
    end
    local imageHeight = math.floor(cardCount / 6) * - AddY
    if cardCount % 6 ~= 0 then
        imageHeight = math.floor(cardCount / 6 + 1) * - AddY
    end
    self.ImageHeight = imageHeight
    self.GirdPosImage.sizeDelta = Vector2.New(imageWidth, imageHeight);
    firstPosx = - imageWidth / 2 + cardWidth / 2 - 30
    firstPosy = imageHeight / 2 + cardHeight / 2
    -- 设置初始的卡牌24 张
    self:HandleShow()

    -- 招募界面时需要将卡牌表进行重新摆放到为值0
    if self.isRecruit then
        self:ResetPackagePos()
    end

end

-- 重置背包位置
function HeroPackage:ResetPackagePos()
    self.GirdPos.localPosition = Vector3.New(0, - self.ImageHeight / 2, 0)
end


function HeroPackage:HandleShow()
    -- 是否从隐藏的里面调用
    for index = 1, CardNum do
        local heroCard = self._myList:Get(index)
        local mHeroCard = self._allHeroCardDic[index];
        if mHeroCard == nil then
            local uibase = UIHeroCard.new();
            GameResFactory.Instance():GetUIPrefab(self._perfabPath, self._parentObj, uibase, function(go)
                uibase:Init();
                uibase:SetClickModel(true)
                -- 招募CanShow ==false
                if self.isRecruit then
                    uibase:SetHeroCardMessage(heroCard, false);
                else
                    uibase:SetHeroCardMessage(heroCard, true);
                end

                uibase:SetHeroInArmy(heroCard)
                uibase:SetHeroBelongsCityName(heroCard)
                uibase:CanShowRedPoint(heroCard)
                uibase:SetStatePicFalse()
                self:SetHeroCardPos(uibase.gameObject, index)
                self._allHeroCardDic[index] = uibase;
                self.HeroCardList:Push(uibase);
                if index > self._myList:Count() then
                    self._allHeroCardDic[index].gameObject:SetActive(false)
                else
                    self._allHeroCardDic[index].gameObject:SetActive(true)
                end
            end );
        else
            mHeroCard:SetClickModel(true)

            -- 招募CanShow ==false
            if self.isRecruit then
                mHeroCard:SetHeroCardMessage(heroCard, false);
            else
                mHeroCard:SetHeroCardMessage(heroCard, true);
            end

            mHeroCard:SetHeroInArmy(heroCard)
            mHeroCard:SetHeroBelongsCityName(heroCard)
            mHeroCard:CanShowRedPoint(heroCard)
            mHeroCard:SetStatePicFalse()
            self:SetHeroCardPos(mHeroCard.gameObject, index)
            if index > self._myList:Count() then
                self._allHeroCardDic[index].gameObject:SetActive(false)
            else
                self._allHeroCardDic[index].gameObject:SetActive(true)
            end
        end
    end
end




function HeroPackage:RefreshShow()
    for index = 1, CardNum do
        local heroCard = self._myList:Get(index + 6 * CardRow)
        local mHeroCard = self._allHeroCardDic[index];
        mHeroCard:CanShowRedPoint(heroCard)
    end
end

function HeroPackage:ReShow()
    for index = 1, CardNum do
        if self._myList ~= nil and self._myList:Get(index + 6 * CardRow) ~= nil and self._myList:Get(index + 6 * CardRow).tableID ~= nil and CardRow <= math.ceil(self._myList:Count() / 6 - 4) then
            local heroCard = self._myList:Get(index + 6 * CardRow)
            local mHeroCard = self._allHeroCardDic[index];
            mHeroCard:SetClickModel(true)
            self:SetHeroCardPos(mHeroCard.gameObject, index + 6 * CardRow)

            -- 招募CanShow ==false
            if self.isRecruit then
                mHeroCard:SetHeroCardMessage(heroCard, false);
            else
                mHeroCard:SetHeroCardMessage(heroCard, true);
            end

            mHeroCard:SetHeroInArmy(heroCard)
            mHeroCard:SetHeroBelongsCityName()
            mHeroCard:SetHeroBelongsCityName(heroCard)
            mHeroCard:CanShowRedPoint(heroCard)
        else
            return
        end
    end
end

function HeroPackage:OnDown(go, eventData)
    self:HideSortMenu()
end

function HeroPackage:SetDownCallBack(downCallBack)
    self._downCallBack = downCallBack;
end

function HeroPackage:ScrollOnDownCallBack(go, eventData)
    if self._downCallBack == nil then
        return;
    end
    self._downCallBack(go, eventData);
end



function HeroPackage:OnChange(go, eventData)
    if self.page.gameObject.activeInHierarchy then
        self.page.gameObject:SetActive(false)
    end
    self:DragEvent();
end


function HeroPackage:DragEvent()
    self._btnState = 1
    self.ScorllPos = math.floor(self.GirdPos.localPosition.y + self.ImageHeight / 2)
    CardRow = math.floor(self.ScorllPos / - AddY)
    if OldRow == CardRow then
    else
        OldRow = CardRow
        if self.recuitList == nil then
            self:ReShow()
        else
            self:ReShow(self.recuitList)
        end
    end

end

function HeroPackage:OnUp(go, eventData)
end


function HeroPackage:SetUpCallBack(upCallBack)
    self._upCallBack = upCallBack;
end
function HeroPackage:ScrollOnUpCallBack(go, eventData)
    if self._upCallBack == nil then
        return;
    end

    self._upCallBack(go, eventData);
end

function HeroPackage:SetClickCallBack(clickCallBack)
    self._clickCallBack = clickCallBack;
end

function HeroPackage:ScrollOnClickCallBack(go, eventData)
    if self._clickCallBack == nil then
        return;
    end
    self._clickCallBack(go, eventData);
end


function HeroPackage:SetHeroCardPos(obj, i)
    local index = i % CardNum
    local x = firstPosx +(index - 1) % 6 * AddX
    local y = firstPosy + math.ceil(i / 6) * AddY;
    obj.transform.localPosition = Vector3.New(x, y, 0)
end


function HeroPackage:SetSortType(_type)
    if _type == nil then
        self.srotType = HeroSortType.default;
    end
    self.srotType = _type;
end

function HeroPackage:GetSortType()
    if self.srotType == nil then
        return HeroSortType.rarity;
    end
    return self.srotType
end

function HeroPackage:GetMyHeroList()

    local size = HeroService:Instance():GetOwnHeroCount();
    local herolist = List.new();
    for i = 1, size do
        herolist:Push(HeroService:Instance():GetOwnHeroes(i))
    end
    return herolist;

end

function HeroPackage:GetAllHero()

    local allhero = List.new()
    for k, v in pairs(DataHero) do
        if v.PokedexDisplay == 1 or self:CheckInMyCardList(v.ID) then
            allhero:Push(v)
        end
    end
    return allhero

end

function HeroPackage:CheckInMyCardList(ID)
    for i = 1, HeroService:Instance():GetOwnHeroCount() do
        if HeroService:Instance():GetOwnHeroes(i).tableID == ID then
            return true
        end
    end
    return false
end


--- y隐藏所有卡牌提高运行效率
function HeroPackage:SetAllCardsAcitve(args)
    for index = 1, HeroService:Instance():GetOwnHeroCount() do
        if self._allHeroCardDic[index].gameObject ~= nil then
            self._allHeroCardDic[index].gameObject:SetActive(args)
        end
    end
end



return HeroPackage;



-- endregion