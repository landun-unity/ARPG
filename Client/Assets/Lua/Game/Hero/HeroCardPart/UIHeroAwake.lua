-- region *.lua
-- Date

local UIBase = require("Game/UI/UIBase");
local UIHeroAwake = class("UIHeroAwake", UIBase);
local DataHero = require("Game/Table/model/DataHero");
local HeroCard = require("Game/Hero/HeroCardPart/HeroCard")
local UIHeroCard = require("Game/Hero/HeroCardPart/UIHeroCard")
require("Game/Hero/HeroCardPart/HeroSortType");
local DataSkill = require("Game/Table/model/DataSkill");
require("Game/Table/model/DataUIConfig")
local List = require("common/List")
local HeroCardList = nil;
require("Game/UI/UIMix");
local MaxSize = 2;
local pic = "Disassemble1";
local greenPic = "Disassemble"

function UIHeroAwake:ctor()

    self.data = { };
    UIHeroAwake.super.ctor(self)
    self.heroId = nil;
    self.heroCard = nil;
    self.awakehelp = nil;
    self.heroCardBar = nil;
    self.downPart = nil
    self.helpconfirm = nil;

    self.helpBtn = nil;
    self.back = nil;
    self._tempParent = UnityEngine.GameObject.Find("Canvas").transform;
    self._canvas = self._tempParent.gameObject:GetComponent(typeof(UnityEngine.Canvas));
    self._perfabPath = DataUIConfig[UIType.UIHeroCard].ResourcePath;
    self.HeroCardDic = { };
    self._allHeroCardDic = { };
    HeroCardList = List:new();
    self.awakeBtn = nil;
    -- 卡牌华东
    self._myMIx = nil;
    self._HeroCardObjList = List.new();
    self._dragIn = true;
    self._curDragSingleDic = { };
    self._allHaveHeroCardDic = { }
    self._InTheBoxList = List.new();
    self._herolistData = nil;
    self._initCardsTable = { }
    self._upBeDragBase = nil;
    self.beChangedCard = 0;
end

function UIHeroAwake:DoDataExchange()

    self.heroCard = self:RegisterController(UnityEngine.Transform, "Scroll/Cards");
    -- self.awakehelp = self:RegisterController(UnityEngine.Transform, "AwakeHelp");
    self.heroCardBar = self:RegisterController(UnityEngine.Transform, "Scroll/Content");
    --  self.helpconfirm = self:RegisterController(UnityEngine.UI.Button, "AwakeHelp/Button");
    self.awakeBtn = self:RegisterController(UnityEngine.UI.Button, "AwakenBtn");
    self.helpBtn = self:RegisterController(UnityEngine.UI.Button, "HelpBtn");
    self.back = self:RegisterController(UnityEngine.UI.Button, "BackBtn");
    self.InitCard1 = self:RegisterController(UnityEngine.Transform, "Scroll/Card1");
    self.InitCard2 = self:RegisterController(UnityEngine.Transform, "Scroll/Card2");
end

function UIHeroAwake:DoEventAdd()

    -- self:AddListener(self.helpconfirm.gameObject, self.OnClickhelpconfirm);
    self:AddListener(self.awakeBtn.gameObject, self.OnClickawakeBtn);
    self:AddListener(self.helpBtn.gameObject, self.OnClickhelpBtn);
    self:AddListener(self.back.gameObject, self.OnClickbackBtn);


end


function UIHeroAwake:OnClickhelpconfirm()

    --  self.awakehelp.gameObject:SetActive(false)

end

function UIHeroAwake:OnClickhelpBtn()

    -- self.awakehelp.gameObject:SetActive(true)
    --   self.awakehelp:SetAsLastSibling()
end

function UIHeroAwake:OnClickawakeBtn()

    if self.heroCard.transform:GetChild(0) ~= nil and self.heroCard.transform:GetChild(1) ~= nil then
        if self.heroCard.transform:GetChild(1).gameObject.activeSelf and self.heroCard.transform:GetChild(1).gameObject.activeSelf then
            if DataHero[self._InTheBoxList:Get(1).tableID].Star == DataHero[self.data[1].tableID].Star and DataHero[self._InTheBoxList:Get(2).tableID].Star == DataHero[self.data[1].tableID].Star then
                HeroService:Instance():SendAwakeMsg(self.data[1].id, self._InTheBoxList:Get(1).id, self._InTheBoxList:Get(2).id)
                return;
            else
                UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.NoCardForAdvance)
            end
        else
            UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.NoCardForAdvance)
        end
    else
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.NoCardForAdvance)
    end

end

function UIHeroAwake:OnClickbackBtn()
    UIService:Instance():HideUI(UIType.UIHeroAwake)
end

function UIHeroAwake:OnShow(data)
    if self.heroCard.childCount > 1 then
        self.heroCard:GetChild(0).gameObject:SetActive(false)
        self.heroCard:GetChild(1).gameObject:SetActive(false)
    end
    -- self.awakehelp.gameObject:SetActive(false)
    self.data = data;
    self:ReShow();
    self._InTheBoxList:Clear()
    self:InitCards()
    if self._myMIx == nil then
        local mMix = UIMix.new();
        mMix:SetLoadCallBack( function(obj)
            self.downPart = obj
            mMix:ScrollOnUpCB( function() self:OnMouseUp() end);
            mMix:ScrollOnDownCB( function() self:OnMouseDown() end);
            mMix:ScrollOnClickCB( function(go, eventData)
                self:OnMouseClick(go, eventData)
            end );
            mMix:SetPostionObj(self.gameObject);
            self._myMIx:GetDownPart().gameObject.transform.localPosition = Vector3.New(5.5 - 9.6 + 15, -185 + 31.7, 0)
            self._myMIx:GetDownPart().gameObject.transform.localScale = Vector3.New(.9, .9, 1)
            self._myMIx:GetDownPart().gameObject.transform:GetChild(3).gameObject:SetActive(false)
            self._myMIx:GetDownPart().gameObject.transform:GetChild(4).gameObject:SetActive(false)
            self._myMIx:GetDownPart().gameObject:SetActive(true)
        end );
        self._myMIx = mMix;
        mMix:MakeScrollDrag(self._herolistData, self.transform);
    else
        self._myMIx:MakeScrollDrag(self._herolistData, self.transform);
        self._myMIx:GetDownPart().gameObject.transform.localPosition = Vector3.New(5.5 - 9.6 + 15, -185 + 31.7, 0)
        self._myMIx:GetDownPart().gameObject.transform.localScale = Vector3.New(.9, .9, 1)
        self._myMIx:GetDownPart().gameObject.transform:GetChild(3).gameObject:SetActive(false)
        self._myMIx:GetDownPart().gameObject:SetActive(true)
    end
    local table = { self._initCardsTable[self.heroCard:GetChild(0).gameObject], self._initCardsTable[self.heroCard:GetChild(1).gameObject] }
    if self._myMIx then
        self._myMIx:SortingCardList(self._herolistData)
        self._myMIx:SetCardChooseState(table)
    end

    if self.HeroCardDic[1].gameObject.activeSelf and self.HeroCardDic[2].gameObject.activeSelf then
        self.awakeBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(greenPic);
    else
        self.awakeBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(pic);
    end
    self.cardCountText = self.downPart.transform:Find("CardCountText"):GetComponent(typeof(UnityEngine.UI.Text));
    self.cardCountText.text = self._herolistData:Count() .. "/" .. HeroService:Instance():GetCardMaxLimit()
end


function UIHeroAwake:ReShow()
    local mHero = DataHero[self.data[1].tableID];

    for k, v in pairs(HeroCardList._list) do
        if (v.gameObject.activeSelf == true) then
            v.gameObject:SetActive(false);
        end
    end
    local herolist = self:GetMyHeroList()
    self._herolistData = self:GetMyHeroList();
    self._herolistData = HeroService:Instance():sorting(HeroSortType.spliteHero, self._herolistData)
    local size = herolist:Count();
    local GetFromUnVisable = true;
end

-- 初始化列表
function UIHeroAwake:InitCards()
    for index = 1, MaxSize do
        if self.HeroCardDic[index] == nil then
            local mdata = DataUIConfig[UIType.UIHeroCard];
            local uiBase = require(mdata.ClassName).new();
            GameResFactory.Instance():GetUIPrefab(mdata.ResourcePath, self.heroCard.transform, uiBase, function(go)
                uiBase:Init();
                if uiBase.gameObject then
                    self:AddOnDown(uiBase.gameObject, self.OnDownStartBtn);
                    self:AddOnUp(uiBase.gameObject, self.OnUpStartBtn);
                    self:AddOnDrag(uiBase.gameObject, self.OnDragStartBtn);
                    self:AddOnClick(uiBase.gameObject, self.OnClickHeroBtn);
                    self.HeroCardDic[index] = uiBase;
                    self:SetInitCardPos(index, uiBase.gameObject)
                    self._initCardsTable[uiBase.gameObject] = uiBase
                    uiBase.gameObject:SetActive(false);
                end
            end );
        end
    end
end


function UIHeroAwake:SetInitCardPos(i, obj)
    obj.transform.localPosition = Vector3.New(-120 + 220 *(i - 1), 0, 0)
end


function UIHeroAwake:OnClickHeroBtn(obj, eventData)
    if self._allHaveHeroCardDic[self._BeDragObj] then
        HeroService:Instance():ShowHeroInfoUI(self.HeroCardDic[1]._heroId);
    end
end
-- 滑动列表中卡牌点击
function UIHeroAwake:OnMouseClick(go, eventData)
    --   if self._BeDragData then
    HeroService:Instance():ShowHeroInfoUI(self._BeDragData.id);
    -- end
end

function UIHeroAwake:OnDownStartBtn(obj, eventData)
    self._dragIn = false;
    if obj == nil then
    end

    self._BeDragObj = obj;
    self:SetPrefabColor(obj, false);
    if self._curDragObj == nil then
        local mdata = DataUIConfig[UIType.UIHeroCard];
        local uiBase = require(mdata.ClassName).new();
        GameResFactory.Instance():GetUIPrefab(mdata.ResourcePath, self._tempParent, uiBase, function(go)
            uiBase:Init();
            uiBase:SetHeroCardMessage(self._allHaveHeroCardDic[obj]);
            self._curDragObj = uiBase.gameObject;
            self._curDragBase = uiBase;
            self._curDragObj.transform.position = eventData.position;
            self:AddOnUp(self._curDragObj.gameObject, self.OnUpStartBtn);
            self:AddOnDrag(self._curDragObj.gameObject, self.OnDragStartBtn);
        end );
    else
        if self._curDragBase then
            self._curDragBase:SetHeroCardMessage(self._allHaveHeroCardDic[obj]);
            self._upBeDragBase = self._initCardsTable[obj]

        end
    end
    self._localPointerPosition = nil;
    self._curDragSingleDic[self._curDragObj] = self._allHaveHeroCardDic[obj];
end

function UIHeroAwake:OnDragStartBtn(obj, eventData)

    if obj == nil then
    end

    if self._curDragObj == nil then
        return;
    end

    local localPositonVec3 = UnityEngine.Vector3.zero;
    if self._curDragObj.transform == nil then
        return;
    end

    localPositonVec3.z = self._curDragObj.transform.localPosition.z;

    local _localPosition = nil;
    local isBoolPositon, _localPosition = UnityEngine.RectTransformUtility.ScreenPointToLocalPointInRectangle(self.gameObject:GetComponent(typeof(UnityEngine.RectTransform)), eventData.position, eventData.pressEventCamera);

    self._localPointerPosition = _localPosition;
    if isBoolPositon then
        localPositonVec3.x = _localPosition.x;
        localPositonVec3.y = _localPosition.y;
        self._curDragObj.gameObject:SetActive(true);
        self._curDragObj.gameObject.transform.localPosition = localPositonVec3;
    end
    if self._upBeDragBase then
        self._upBeDragBase:SetCardAlpha(false)

    end
end



function UIHeroAwake:SetSingleHeroCardData(mHeroCard, heroCard)
    mHeroCard:Init();
    mHeroCard:SetHeroCardMessage(heroCard);

    if self._allHeroCardDic[heroCard.id] == nil then
        self._allHeroCardDic[heroCard.id] = mHeroCard;
    end

end

function UIHeroAwake:OnMouseUp(go, eventData)

    self._BeDragObj = self._myMIx:GetBeDragObj();
    self._localPointerPosition = self._myMIx:Get_localPointerPosition();
    if self._localPointerPosition then
    end
    if self._curDragObj then
        self:OnUpStartBtn(self._curDragObj.gameObject, eventData);
    end
    local table = { self._initCardsTable[self.heroCard:GetChild(0).gameObject], self._initCardsTable[self.heroCard:GetChild(1).gameObject] }
    if self._myMIx then
        self._herolistData = HeroService:Instance():sorting(HeroSortType.spliteHero, self._herolistData)
        self._myMIx:SortingCardList(self._herolistData)
        self._myMIx:SetCardChooseState(table)
    end

end

function UIHeroAwake:OnMouseDown(go, eventData)
    self._dragIn = true;
    if self._myMIx then
        self._BeDragObj = self._myMIx:GetBeDragObj();
        self._BeDragData = self._myMIx:GetBeDragObjData();
        if self._BeDragObj == nil then
            return;
        end
        if self._curDragObj == nil then
            local mdata = DataUIConfig[UIType.UIHeroCard];
            local uiBase = require(mdata.ClassName).new();
            GameResFactory.Instance():GetUIPrefab(mdata.ResourcePath, self._tempParent, uiBase, function(go)
                uiBase:Init();
                uiBase:SetHeroCardMessage(self._BeDragData);
                self._curDragObj = uiBase.gameObject;
                self._curDragBase = uiBase;
                self._curDragObj.transform.localPosition = Vector3.zero;
                self._curDragObj.gameObject:SetActive(false);
                self._myMIx:SetCurDragObj(self._curDragObj);
            end );
        else
            self._curDragObj.gameObject:SetActive(false);
            if self._curDragBase then
                self._curDragBase:SetHeroCardMessage(self._BeDragData);
            end
            self._myMIx:SetCurDragObj(self._curDragObj);
            self._curDragObj.transform.localPosition = Vector3.zero;
        end
        self._localPointerPosition = nil;
        self._curDragSingleDic[self._curDragObj] = self._BeDragData;
    end
end

function UIHeroAwake:OnUpStartBtn(obj, eventData)
    if self._localPointerPosition == nil then

        if (self._curDragObj and self._curDragObj.gameObject) then
            self._curDragObj.gameObject:SetActive(false);
            self:SetPrefabColor(obj, true);
        else
            local mdata = DataUIConfig[UIType.UIHeroCard];
            local uiBase = require(mdata.ClassName).new();
            GameResFactory.Instance():GetUIPrefab(mdata.ResourcePath, self._tempParent, uiBase, function(go)
                uiBase:Init();
                uiBase:SetHeroCardMessage(self._allHaveHeroCardDic[self._BeDragObj]);
                self._curDragObj = uiBase.gameObject;
                self._curDragBase = uiBase;
                self._curDragObj.transform.localPosition = Vector3.zero;
                self._curDragObj.gameObject:SetActive(false);
                self._myMIx:SetCurDragObj(self._curDragObj);
            end );
        end
        return;
    end
    if self._upBeDragBase then
        self._upBeDragBase:SetCardAlpha(true)
    end

    local vecTempCard = self.InitCard1.position;
    local vecTempCard1 = self.InitCard2.position;
    local fWidth = self.InitCard1.gameObject:GetComponent(typeof(UnityEngine.RectTransform)).rect.width / 2;
    local fHeight = self.InitCard1.gameObject:GetComponent(typeof(UnityEngine.RectTransform)).rect.height / 2;
    local fWidth1 = self.InitCard2.gameObject:GetComponent(typeof(UnityEngine.RectTransform)).rect.width / 2;
    local fHeight1 = self.InitCard2.gameObject:GetComponent(typeof(UnityEngine.RectTransform)).rect.height / 2;
    local vecTemp2 = self._curDragObj.transform.position;
    local HeroInfo = self._BeDragData;
    local alreadyInTheBox = self:IfInTheBox(HeroInfo);
    local BoxlreadyInTheBox = self:IfInTheBox(self._allHaveHeroCardDic[self._BeDragObj]);
    local DragInTheBox = false;
    if ((vecTempCard.x - vecTemp2.x <= fWidth) and(vecTempCard.x - vecTemp2.x >=(0 - fWidth)) and(vecTempCard.y - vecTemp2.y <= fHeight) and(vecTempCard.y - vecTemp2.y >=(0 - fHeight))) then
        DragInTheBox = true;
        self.beChangedCard = 1;
    end
    if ((vecTempCard1.x - vecTemp2.x <= fWidth1) and(vecTempCard1.x - vecTemp2.x >=(0 - fWidth1)) and(vecTempCard1.y - vecTemp2.y <= fHeight1) and(vecTempCard1.y - vecTemp2.y >=(0 - fHeight1))) then
        self.beChangedCard = 2;
        DragInTheBox = true;
    end
    if (self._dragIn == true) then
        if (alreadyInTheBox == false and DragInTheBox == true) then
            if DataHero[HeroInfo.tableID].Star ~= DataHero[self.data[1].tableID].Star then
                UIService:Instance():ShowUI(UIType.UICueMessageBox, 900)
                self._curDragObj.gameObject:SetActive(false);
                return
            end
            if PlayerService:Instance():CheckCardInArmy(HeroInfo.id) then
                UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.HeroInArmy)
                self._curDragObj.gameObject:SetActive(false);
                return
            end
            if HeroInfo.isProtect then
                UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.HeroIsProtect)
                self._curDragObj.gameObject:SetActive(false);
                return
            end
            if HeroInfo and(HeroInfo:GetSkill(2) ~= 0 or HeroInfo:GetSkill(3) ~= 0) then
                UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.LearnedSkill)
                self._curDragObj.gameObject:SetActive(false);
                return
            end


            if self:ifAwake(HeroInfo) then
                self._curDragObj.gameObject:SetActive(false);
                CommonService:Instance():ShowOkOrCancle(self, function()
                    self:AddToTheBox(HeroInfo);
                    self:ShowTheBox();
                end , nil, "确认", "已觉醒武将卡消耗后不会返还素材卡");
                return
            end

            self:AddToTheBox(HeroInfo);
            self:ShowTheBox();
        end

        if (alreadyInTheBox == true and DragInTheBox == true) then
            for k, v in pairs(self.HeroCardDic) do
                if v._heroId == HeroInfo.id then
                    v.gameObject:SetActive(true)
                end
            end

        end
    else
        if (BoxlreadyInTheBox == true and DragInTheBox == false) then
            HeroInfo = self._allHaveHeroCardDic[self._BeDragObj];
            self:RemoveFromTheBox(HeroInfo);
            self:ShowTheBox();
        end

    end
    self.SetPrefabColor(obj, true);
    self._curDragObj.gameObject:SetActive(false);
    local table = { self._initCardsTable[self.heroCard:GetChild(0).gameObject], self._initCardsTable[self.heroCard:GetChild(1).gameObject] }
    if self._myMIx then
        self._herolistData = HeroService:Instance():sorting(HeroSortType.spliteHero, self._herolistData)
        self._myMIx:SortingCardList(self._herolistData)
        self._myMIx:SetCardChooseState(table)
    end
end


function UIHeroAwake:SetPrefabColor(obj, mBool)
    if obj == nil then
        return;

    end
    local mImage = { };

end

function UIHeroAwake:IfInTheBox(info)
    for k, v in pairs(self._InTheBoxList._list) do
        if v == info then
            return true;
        end
    end
    return false;
end

function UIHeroAwake:AddToTheBox(info)
    for k, v in pairs(self._InTheBoxList._list) do
        if v == info then
            return;
        end
    end
    -- 被替换的是否是第一个，如果是第一个就清空然后排序，如果不是直接添加进链表中
    if (self._InTheBoxList:Count() >= MaxSize) then
        if self.beChangedCard == 1 then
            self._InTheBoxList:Remove(self._InTheBoxList:Get(1))
            local first = self._InTheBoxList:Get(1)
            self._InTheBoxList:Clear()
            self._InTheBoxList:Push(info)
            self._InTheBoxList:Push(first)
        else
            self._InTheBoxList:Remove(self._InTheBoxList:Get(2))
            self._InTheBoxList:Push(info)
        end
    else
        self._InTheBoxList:Push(info)
    end


    local table = { self._initCardsTable[self.heroCard:GetChild(0).gameObject], self._initCardsTable[self.heroCard:GetChild(1).gameObject] }
    if self._myMIx then
        self._herolistData = HeroService:Instance():sorting(HeroSortType.spliteHero, self._herolistData)
        self._myMIx:SortingCardList(self._herolistData)
        self._myMIx:SetCardChooseState(table)
    end
end

function UIHeroAwake:RemoveFromTheBox(info)
    for k, v in pairs(self._InTheBoxList._list) do
        if v == info then
            self._InTheBoxList:Remove(info);
            local size = self._InTheBoxList:Count();
            return;
        end
    end
    local table = { self._initCardsTable[self.heroCard:GetChild(0).gameObject], self._initCardsTable[self.heroCard:GetChild(1).gameObject] }
    if self._myMIx then
        self._herolistData = HeroService:Instance():sorting(HeroSortType.spliteHero, self._herolistData)
        self._myMIx:SortingCardList(self._herolistData)
        self._myMIx:SetCardChooseState(table)
    end

end

function UIHeroAwake:ShowTheBox()
    local size = self._InTheBoxList:Count();
    local addexp = 0;
    for k, v in pairs(self.HeroCardDic) do
        v.gameObject:SetActive(false)
    end
    for i = 1, size do
        self.HeroCardDic[i].gameObject:SetActive(true);
        local info = self._InTheBoxList:Get(i);
        self.HeroCardDic[i]:SetHeroCardMessage(info);
        self._allHaveHeroCardDic[self.HeroCardDic[i].gameObject] = info;
    end

    if self._InTheBoxList:Count() == 0 then
        self.HeroCardDic[1].gameObject:SetActive(false);
        self.HeroCardDic[2].gameObject:SetActive(false);
    end

    local table = { self._initCardsTable[self.heroCard:GetChild(0).gameObject], self._initCardsTable[self.heroCard:GetChild(1).gameObject] }
    if self._myMIx then
        self._herolistData = self:GetMyHeroList();
        self._herolistData = HeroService:Instance():sorting(HeroSortType.spliteHero, self._herolistData)
        self._myMIx:SortingCardList(self._herolistData)
        self._myMIx:SetCardChooseState(table)
    end
    if self.HeroCardDic[1].gameObject.activeSelf and self.HeroCardDic[2].gameObject.activeSelf then
        self.awakeBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(greenPic);
    else
        self.awakeBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(pic);
    end
end

function UIHeroAwake:GetMyHeroList()

    local size = HeroService:Instance():GetOwnHeroCount();
    local herolist = List:new();
    for i = 1, size do
        if DataHero[self.data[1].tableID].Star == DataHero[HeroService:Instance():GetOwnHeroes(i).tableID].Star and HeroService:Instance():GetOwnHeroes(i).id ~= self.data[1].id then
            herolist:Push(HeroService:Instance():GetOwnHeroes(i))
        end
    end

    return herolist;

end

-- 是否是j觉醒的卡牌
function UIHeroAwake:ifAwake(info)
    return info.isAwaken;
end


return UIHeroAwake 
-- endregion


