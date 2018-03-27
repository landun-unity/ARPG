-- region *.lua
-- Date
local UIBase = require("Game/UI/UIBase");
local List = require("common/List");
local HeroCard = require("Game/Hero/HeroCardPart/HeroCard");
require("Game/Hero/HeroCardPart/HeroSortType");
require("Game/Hero/HeroCardPart/HeroHandSort");
local DataHero = require("Game/Table/model/DataHero")
local UIConfigTable = require("Game/Table/model/DataUIConfig");
local HeroHandbook = class("HeroHandbook", UIBase);
local HeroCardList = nil;
local UIHeroCard = require("Game/Hero/HeroCardPart/UIHeroCard");
local firstPos = Vector3.New(-470 - 16, 3960 - 4082, 0)
local CardNum = 24
local imageWidth = 1200
local detlax = 190
local detlay = 240
local CardRow = 0
local OldRow = 0
local cardWidth = 168
local cardHeight = 218

function HeroHandbook:ctor()
    HeroHandbook.super.ctor(self);
    -- 预制件路径
    self._perfabPath = UIConfigTable[UIType.UIHeroCard].ResourcePath;
    self.GirdPos = nil;
    HeroCardList = List:new();
    local canvas = UGameObject.Find("Canvas");
    self._canvas = canvas:GetComponent(typeof(UnityEngine.Canvas));
    -- 临时卡牌列表
    self._allHeroCardDic = { };
    self._BeDragData = nil;
    self.clickOn = false
    -- _tempDic = {};
    -- 所有的英雄
    self._allOwnHeroes = List:new();
    -- 返回按钮
    self.backBtn = nil;
    self._myList = List.new()
    self._btnState = 0;
    -- 排序按钮
    self.sortBtn = nil;
    self.sortText = nil;
    self.allBtn = nil;
    self.qunBtn = nil;
    self.weiBtn = nil;
    self.shuBtn = nil;
    self.wuBtn = nil;
    self.hanBtn = nil;
    self.numText = nil;
    self.sortMenu = nil;
    self._lastPosition = nil;
    self.startPos = Vector3.zero
    self.endPos = Vector3.zero
    self.lastMove = Vector3.zero
    self.startGirdPos = nil;
    -- 最后一次的位移
    self.ScorllPos = nil;
    self.ImageHeight = 0;
end

function HeroHandbook:DoDataExchange()

    self.GirdPos = self:RegisterController(UnityEngine.Transform, "ScrollView/Gird/Image");
    self.GirdPosImage = self:RegisterController(UnityEngine.RectTransform, "ScrollView/Gird/Image");
    self.Grid = self:RegisterController(UnityEngine.UI.ScrollRect, "ScrollView");
    self.sortMenu = self:RegisterController(UnityEngine.Transform, "mask/typebtn");
    self.backBtn = self:RegisterController(UnityEngine.UI.Button, "back");
    -- 排序按钮
    self.sortBtn = self:RegisterController(UnityEngine.UI.Button, "sorttype");
    self.allBtn = self:RegisterController(UnityEngine.UI.Button, "mask/typebtn/all");
    self.qunBtn = self:RegisterController(UnityEngine.UI.Button, "mask/typebtn/qun");
    self.weiBtn = self:RegisterController(UnityEngine.UI.Button, "mask/typebtn/wei");
    self.shuBtn = self:RegisterController(UnityEngine.UI.Button, "mask/typebtn/shu");
    self.wuBtn = self:RegisterController(UnityEngine.UI.Button, "mask/typebtn/wu");
    self.hanBtn = self:RegisterController(UnityEngine.UI.Button, "mask/typebtn/han");
    self.sortText = self:RegisterController(UnityEngine.UI.Text, "sorttype/sorttype");
    self.numText = self:RegisterController(UnityEngine.UI.Text, "num");
end

function HeroHandbook:DoEventAdd()

    self:AddListener(self.sortBtn, self.OnClicksortBtn)
    self:AddListener(self.backBtn, self.OnClickbackBtn)
    self:AddListener(self.allBtn, self.OnClickallBtn)
    self:AddListener(self.qunBtn, self.OnClickqunBtn)
    self:AddListener(self.weiBtn, self.OnClickweiBtn)
    self:AddListener(self.hanBtn, self.OnClickhanBtn)
    self:AddListener(self.shuBtn, self.OnClickshuBtn)
    self:AddListener(self.wuBtn, self.OnClickwuBtn)
    self:AddOnDown(self.Grid, self.OnDown);
    self:AddOnValueChanged(self.Grid, self.OnChange);
end


function HeroHandbook:OnInit()
    --    for i = 1, 24 do
    --        mHeroCard = UIHeroCard.new();
    --        GameResFactory.Instance():GetUIPrefab(self._perfabPath, self.GirdPos, mHeroCard, function(go)
    --            self._allHeroCardDic[i] = mHeroCard;
    --        end )
    --    end
end


function HeroHandbook:OnShow(data)
    self.sortMenu.gameObject:SetActive(false)
    if data ~= nil then
        local herolist = data[1]
        local sortType = data[2]
        self._myList = data[1]
        self:GetCurrentSortType(sortType)
        self.numText.text = tableSize
        CardRow = 0;
        -- 设置
        local cardCount = herolist:Count()
        if cardCount <= 6 then
            cardCount = 7
        end
        local imageHeight = cardCount / 6 * detlay
        if cardCount % 6 ~= 0 then
            imageHeight =(cardCount / 6 + 1) * detlay
        end

        self.GirdPosImage.sizeDelta = Vector2.New(imageWidth, imageHeight);
        self.GirdPos.localPosition = Vector3.New(0, - imageHeight / 2 - cardHeight / 2 - 100, 0)
        firstPos = Vector3.New(- imageWidth / 2 + cardWidth - 45, imageHeight / 2 - cardHeight / 2 - 30, 0)
        -- 按照星级排
        -- 成员内部调用
        for k, v in pairs(HeroCardList._list) do
            if (v.gameObject.activeSelf == true) then
                v.gameObject:SetActive(false);
            end
        end

        local GetFromUnVisable = true;
        -- 是否从隐藏的里面调用
        for i = 1, 24 do
            local heroCard = herolist:Get(i)
            local mHeroCard = self._allHeroCardDic[i]
            if (mHeroCard == nil) then
                GetFromUnVisable = false;
                mHeroCard = UIHeroCard.new();
                GameResFactory.Instance():GetUIPrefab(self._perfabPath, self.GirdPos, mHeroCard, function(go)
                    mHeroCard:Init();
                    mHeroCard:SetClickModel(true)
                    mHeroCard:SetHeroHandbookCardMessage(heroCard);
                    mHeroCard.gameObject:SetActive(true);
                    self._allHeroCardDic[i] = mHeroCard;
                    HeroCardList:Push(mHeroCard);
                    self:SetHeroCardPos(mHeroCard.gameObject, i)
                end );
            else
                self._allHeroCardDic[i].gameObject:SetActive(true);
                mHeroCard:SetHeroHandbookCardMessage(heroCard);
                self:SetHeroCardPos(mHeroCard.gameObject, i)
            end
        end
        for k, v in pairs(self._allHeroCardDic) do
            if self:CheckInMyCardList(v.hero.tableID) then
                v:SetPic(true)
            else
                v:SetPic(false)
            end
        end
    end
    self.startGirdPos = self.GirdPos.localPosition.y
end

function HeroHandbook:SetHeroCardPos(obj, i)
    obj.transform.localPosition = Vector3.New(firstPos.x +((i + 5) % 6) * detlax, firstPos.y - math.floor(((i - 1) / 6)) * detlay, 0)
end


function HeroHandbook:OnDown(go, eventData)
    self:HideSortMenu()
end

function HeroHandbook:OnChange(go, eventData)
    self:DragEvent();
end

function HeroHandbook:DragEvent()
    self.ScorllPos = math.floor(self.GirdPos.localPosition.y - self.startGirdPos)
    CardRow = math.floor(self.ScorllPos / detlay)
    if OldRow == CardRow then
    else
        OldRow = CardRow
        self:ReShow()
    end
end

function HeroHandbook:ReShow()
    for index = 1, CardNum do
        if self._myList ~= nil and self._myList:Get(index + 6 * CardRow) ~= nil and CardRow <= math.ceil(self._myList:Count() / 6 - 4) then
            local heroCard = self._myList:Get(index + 6 * CardRow)
            local mHeroCard = self._allHeroCardDic[index];
            mHeroCard:Init();
            self:SetHeroCardPos(mHeroCard.gameObject, index + 6 * CardRow)
            mHeroCard:SetHeroHandbookCardMessage(heroCard);
            mHeroCard.gameObject:SetActive(true);
            if self:CheckInMyCardList(mHeroCard.hero.tableID) then
                mHeroCard:SetPic(true)
            else
                mHeroCard:SetPic(false)
            end
        else
            return
        end
    end
end

function HeroHandbook:HideSortMenu()
    if self.gameObject.activeSelf then
        self.sortMenu.gameObject:SetActive(false)
    end
end


-- 获取当前的获取英雄的类型
function HeroHandbook:GetCurrentSortType(args)
    if args == HeroHandSort.all then
        self.sortText.text = "全部"
    end
    if args == HeroHandSort.han then
        self.sortText.text = "侍"
    end
    if args == HeroHandSort.wei then
        self.sortText.text = "都"
    end
    if args == HeroHandSort.shu then
        self.sortText.text = "维"
    end
    if args == HeroHandSort.qun then
        self.sortText.text = "秦"
    end

end


-- 所有
function HeroHandbook:OnClickallBtn()
    self.sortMenu.gameObject:SetActive(false)
    local data = { self:GetAllHero(), HeroHandSort.all };
    self.sortText.text = "全部"
    self:OnShow(data)
end
-- 群
function HeroHandbook:OnClickqunBtn()
    self.sortMenu.gameObject:SetActive(false)
    local data = { self:HeroHandbookSort(self:GetAllHero(), HeroHandSort.qun), HeroHandSort.qun }
    self:OnShow(data)
end
-- 魏
function HeroHandbook:OnClickweiBtn()
    self.sortMenu.gameObject:SetActive(false)
    local data = { self:HeroHandbookSort(self:GetAllHero(), HeroHandSort.wei), HeroHandSort.wei }
    self:OnShow(data)

end
-- 汉
function HeroHandbook:OnClickhanBtn()
    self.sortMenu.gameObject:SetActive(false)
    local data = { self:HeroHandbookSort(self:GetAllHero(), HeroHandSort.han), HeroHandSort.han }
    self:OnShow(data)
end
-- 蜀
function HeroHandbook:OnClickshuBtn()
    self.sortMenu.gameObject:SetActive(false)
    local data = { self:HeroHandbookSort(self:GetAllHero(), HeroHandSort.shu), HeroHandSort.shu }
    self:OnShow(data)
end
-- 吴
function HeroHandbook:OnClickwuBtn()
    self.sortMenu.gameObject:SetActive(false)
    local data = { self:HeroHandbookSort(self:GetAllHero(), HeroHandSort.wu) }
    self:OnShow(data)
end

-- 返回
function HeroHandbook:OnClickbackBtn()
    UIService:Instance():HideUI(UIType.UIHeroHandbook)
end

-- 排序显示
function HeroHandbook:OnClicksortBtn()

    if self.sortMenu.gameObject.activeSelf then
        self.sortMenu.gameObject:SetActive(false)
    else
        local pos = self.sortMenu.localPosition
        self.sortMenu.localPosition = pos + Vector3.up * 300
        self.sortMenu.gameObject:SetActive(true)
        self.sortMenu.transform:DOLocalMove(pos, 0.2)
    end

end


function HeroHandbook:HeroHandbookSort(_list, _type)

    local herolist = List:new();
    herolist:Clear();
    local size = _list:Count()
    local num = 0;
    if _type == HeroHandSort.all then
        herolist = _list;
        self.sortText.text = "全部"
        self.numText.text = size
    end

    if _type == HeroHandSort.han then
        for i = 1, size do
            if _list:Get(i).Camp == HeroHandSort.han then

                herolist:Push(_list:Get(i))
                num = num + 1;
            end
        end
        self.sortText.text = "侍"
        self.numText.text = num
    end

    if _type == HeroHandSort.wei then
        for i = 1, size do

            if _list:Get(i).Camp == HeroHandSort.wei then
                herolist:Push(_list:Get(i))
                num = num + 1;
            end
        end
        self.sortText.text = "都"
        self.numText.text = num
    end

    if _type == HeroHandSort.wu then
        for i = 1, size do

            if _list:Get(i).Camp == HeroHandSort.wu then
                herolist:Push(_list:Get(i))
                num = num + 1;
            end
        end
        self.numText.text = num
        self.sortText.text = "吴"
    end

    if _type == HeroHandSort.shu then
        for i = 1, size do
            if _list:Get(i).Camp == HeroHandSort.shu then
                herolist:Push(_list:Get(i))
                num = num + 1;
            end
        end
        self.numText.text = num
        self.sortText.text = "维"
    end

    if _type == HeroHandSort.qun then
        for i = 1, size do

            if _list:Get(i).Camp == HeroHandSort.qun then
                herolist:Push(_list:Get(i))
                num = num + 1;
            end
        end
        self.numText.text = num
        self.sortText.text = "秦"
    end

    return herolist

end

function HeroHandbook:GetMyHeroList()

    local size = HeroService:Instance():GetOwnHeroCount();
    local herolist = List:new();
    for i = 1, size do
        herolist:Push(HeroService:Instance():GetOwnHeroes(i))
    end
    return herolist;

end

function HeroHandbook:GetAllHero()
    local allhero = List.new()
    for k, v in pairs(DataHero) do
        if v.PokedexDisplay == 1 or self:CheckInMyCardList(v.ID) then
            allhero:Push(v)
        end
    end
    return allhero
end

function HeroHandbook:CheckInMyCardList(ID)

    local list = HeroService:Instance():GetCardMapLightList()
    local count = list:Count()
    for i = 1, count do
        if list:Get(i).id == ID then
            return true
        end
    end
    return false
end


return HeroHandbook
-- endregion
