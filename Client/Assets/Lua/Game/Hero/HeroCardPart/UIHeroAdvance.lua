-- Date

local UIBase = require("Game/UI/UIBase");
local UIHeroAdvance = class("UIHeroAdvance", UIBase);
local DataHero = require("Game/Table/model/DataHero");
local HeroCard = require("Game/Hero/HeroCardPart/HeroCard")
local UIHeroCard = require("Game/Hero/HeroCardPart/UIHeroCard")
require("Game/Hero/HeroCardPart/HeroSortType");
local DataSkill = require("Game/Table/model/DataSkill");
require("Game/Table/model/DataUIConfig")
local List = require("common/List")
require("Game/UI/UIMix");
local HeroCardList = nil;
local MaxSize = 1;
local pic = "Disassemble1";
local greenPic = "Disassemble";
function UIHeroAdvance:ctor()

    self.data = { };
    UIHeroAdvance.super.ctor(self)
    self.heroId = nil;
    self.back = nil;
    self.heroCard = nil;
    self.AdvanceBtn = nil;
    self._perfabPath = DataUIConfig[UIType.UIHeroCard].ResourcePath;
    self.heroCardBar = nil;
    self.helpBtn = nil;
    self.helpUI = nil;
    self.confirmBtn = nil;
    self.CardData = nil;
    self.HeroCardDic = { };
    HeroCardList = List:new();
    self.fromSkill = false
    self._allHeroCardDic = { };
    self._tempParent = UnityEngine.GameObject.Find("Canvas").transform;
    self._canvas = self._tempParent.gameObject:GetComponent(typeof(UnityEngine.Canvas));
    -- 卡牌华东
    self._myMIx = nil;
    self._HeroCardObjList = List.new();
    self._dragIn = true;
    self._curDragSingleDic = { };
    self._curDragObj = nil;
    self._allHaveHeroCardDic = { }
    self._InTheBoxList = List.new();
    self.sameHeroList = List.new()
    self.dragFormUp = false
    self._refreshHeroCard = { }
    self.upBeDragBase = nil;
    self.LoseBottomImage2 = nil;
end

function UIHeroAdvance:DoDataExchange()
    self.heroCard = self:RegisterController(UnityEngine.Transform, "heroCard");

    self.AdvanceBtn = self:RegisterController(UnityEngine.UI.Button, "UpgradeBtn");
    self.back = self:RegisterController(UnityEngine.UI.Button, "BackBtn");
    self.helpBtn = self:RegisterController(UnityEngine.UI.Button, "HelpBtn");
    self.LoseBottomImage2 = self:RegisterController(UnityEngine.Transform, "LoseBottomImage2");
    self.heroCardBar = self:RegisterController(UnityEngine.Transform, "Scrollhero");
    self.helpUI = self:RegisterController(UnityEngine.Transform, "HelpUI");
    self.confirmBtn = self:RegisterController(UnityEngine.UI.Button, "HelpUI/confirmBtn");
end

function UIHeroAdvance:DoEventAdd()

    self:AddListener(self.AdvanceBtn.gameObject, self.OnClickAdvanceBtn);
    self:AddListener(self.helpBtn.gameObject, self.OnClickhelpBtn);
    self:AddListener(self.back.gameObject, self.OnClickbackBtn);
    self:AddListener(self.confirmBtn.gameObject, self.OnClickconfirmBtn);
end


-- 关闭按钮 
function UIHeroAdvance:OnClickbackBtn()
    UIService:Instance():HideUI(UIType.UIHeroAdvance)
    UIService:Instance():ShowUI(UIType.UIHeroCardInfo, self.data)
end
-- 打开帮助
function UIHeroAdvance:OnClickhelpBtn()

    self.helpUI.gameObject:SetActive(true)
    self.helpUI.parent = nil;
    self.helpUI.parent = self.transform;
    self.helpUI.localPosition = Vector3.zero
end
-- 关闭帮助
function UIHeroAdvance:OnClickconfirmBtn()
    self.helpUI.gameObject:SetActive(false)

end

-- 进阶按钮
function UIHeroAdvance:OnClickAdvanceBtn()
    if self.heroCard.childCount == 0 or self.heroCard:GetChild(0).gameObject.activeSelf == false then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.NoCardForAdvance)
    else
        HeroService:Instance():SendAdvanceMessage(self.data[1].id, self._InTheBoxList:Get(1).id)
    end
end

function UIHeroAdvance:GetData()
    return self.data
end


function UIHeroAdvance:OnShow(data)

    self.AdvanceBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(pic);
    self.helpUI.gameObject:SetActive(false)
    self.data = data;
    for i = 1, #self._allHeroCardDic do

        self._allHeroCardDic[i].gameObject:SetActive(false);

    end
    if self.heroCard.transform.childCount > 0 then
        for i = 1, self.heroCard.transform.childCount do
            self.heroCard.transform:GetChild(i - 1).gameObject:SetActive(false)
        end
    end

    self:InitCards()
    self:ReShow()
    self.sameHeroList = HeroService:Instance():sorting(HeroSortType.spliteHero, self.sameHeroList)

    self._InTheBoxList:Clear();
    self:ShowTheBox();

    if self._myMIx == nil then
        local mMix = UIMix.new();
        mMix:SetLoadCallBack( function(obj)
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
        mMix:MakeScrollDrag(self.sameHeroList, self.transform);
    else
        self._myMIx:MakeScrollDrag(self.sameHeroList, self.transform);
        self._myMIx:GetDownPart().gameObject.transform.localPosition = Vector3.New(5.5 - 9.6 + 15, -185 + 31.7, 0)
        self._myMIx:GetDownPart().gameObject.transform.localScale = Vector3.New(.9, .9, 1)
        self._myMIx:GetDownPart().gameObject.transform:GetChild(3).gameObject:SetActive(false)
        self._myMIx:GetDownPart().gameObject:SetActive(true)
    end
    if self._myMIx then
        self._myMIx:SetCardChooseState(self.HeroCardDic)
    end
    self._myMIx:GetDownPart().gameObject.transform:Find("CardCountText").gameObject:SetActive(false)

    if self.sameHeroList:Count() == 0 then
        self.LoseBottomImage2:SetAsLastSibling()
        self.LoseBottomImage2.gameObject:SetActive(true)
    else
        self.LoseBottomImage2.gameObject:SetActive(false)
    end
end


function UIHeroAdvance:ReShow()
    -- ----print("UIHeroSpliteHero:ReShow")
    -- ----print(self.data[1].tableID)

    for k, v in pairs(self._refreshHeroCard) do
        if (v.gameObject.activeSelf == true) then
            v.gameObject:SetActive(false);
        end
    end
    local herolist = self:GetMyHeroList()
    local size = herolist:Count();
    local GetFromUnVisable = true;
    local InList = List:new();
    local OutList = List:new();

    -- 是否从隐藏的里面调用
    local sameHeroList = List.new();
    for index = 1, size do

        local sameheroCard = herolist:Get(index);

        if sameheroCard.id ~= self.data[1].id then
            -- if sameheroCard.tableID == self.data[1].tableID or sameheroCard.tableID == DataHero[self.data[1].tableID].MixID[1] then
            if sameheroCard.tableID == self.data[1].tableID then
                sameHeroList:Push(sameheroCard)
            end
        end
    end

    for i = 1, sameHeroList:Count() do
        if PlayerService:Instance():CheckCardInArmy(sameHeroList:Get(i).id) then
            InList:Push(sameHeroList:Get(i))
        else
            OutList:Push(sameHeroList:Get(i))
        end
    end

    sameHeroList:Clear()
    for i = 1, OutList:Count() do
        sameHeroList:Push(OutList:Get(i))
    end
    for i = 1, InList:Count() do
        sameHeroList:Push(InList:Get(i))
    end


    self.sameHeroList = sameHeroList
    local sameHerosize = self.sameHeroList:Count();
    local tablesize = #self._refreshHeroCard;




end

-- 初始化列表
function UIHeroAdvance:InitCards()
    local heroindex = self.data[1]
    local mHeroCard = UIHeroCard:new();
    if #self.HeroCardDic == 0 then

        GameResFactory.Instance():GetUIPrefab(self._perfabPath, self.heroCard.transform, mHeroCard, function(go)
            mHeroCard:Init();
            mHeroCard:SetHeroCardMessage(heroindex, true)
            self:AddOnDown(mHeroCard.gameObject, self.OnDownStartBtn);
            self:AddOnUp(mHeroCard.gameObject, self.OnUpStartBtn);
            self:AddOnClick(mHeroCard.gameObject, self.OnClickHeroBtn);
            self:AddOnDrag(mHeroCard.gameObject, self.OnDragStartBtn);

        end )
        self.HeroCardDic[1] = mHeroCard;
        self.HeroCardDic[1]:SetHeroCardMessage(heroindex);
    else
        self.HeroCardDic[1]:SetHeroCardMessage(heroindex);
    end
end



function UIHeroAdvance:OnClickHeroBtn(obj, eventData)
    if self._allHaveHeroCardDic[self._BeDragObj] then
        HeroService:Instance():ShowHeroInfoUI(self.HeroCardDic[1]._heroId);
    end
end


-- ����

function UIHeroAdvance:OnDownStartBtn(obj, eventData)

    -- ----print("UIHeroAdvance:OnDownStartBtn")
    self._dragIn = false;
    if obj == nil then
        -- ----print("obj is nil");
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
        end
    end
    self._localPointerPosition = nil;
    self._curDragSingleDic[self._curDragObj] = self._allHaveHeroCardDic[obj];
end


function UIHeroAdvance:OnDragStartBtn(obj, eventData)

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

    self.HeroCardDic[1]:SetCardAlpha(false)

end



function UIHeroAdvance:SetSingleHeroCardData(mHeroCard, heroCard)

    if self._allHeroCardDic[heroCard.id] == nil then
        self._allHeroCardDic[heroCard.id] = mHeroCard;
    end
    self._allHaveHeroCardDic[mHeroCard.gameObject] = heroCard;

end

-- 滑动列表中卡牌点击
function UIHeroAdvance:OnMouseClick(go, eventData)
    if self._BeDragData then
        HeroService:Instance():ShowHeroInfoUI(self._myMIx:GetBeDragBase()._heroId);
    end
end

function UIHeroAdvance:OnMouseUp(go, eventData)

    if self._curDragObj then
        self._curDragObj.gameObject:SetActive(false)
    end

    self._BeDragObj = self._myMIx:GetBeDragObj();
    self._localPointerPosition = self._myMIx:Get_localPointerPosition();
    if self._localPointerPosition then
    end

    if self._curDragObj then
        self:OnUpStartBtn(self._curDragObj.gameObject, eventData);
    end

end

function UIHeroAdvance:OnMouseDown(go, eventData)

    self._dragIn = true;
    if self._myMIx then
        self._myMIx:SetCurDragObj(nil);
        self._BeDragObj = self._myMIx:GetBeDragObj();
        self._BeDragData = self._myMIx:GetBeDragObjData();
        self.__BeDragBase = self._myMIx:GetBeDragBase();
        if self._BeDragObj == nil or self._BeDragObj.gameObject.activeInHierarchy == false then
            self._myMIx:SetCurDragObj(nil);
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
                self._myMIx:SetCurDragObj(self._curDragObj);
            end
            self._myMIx:SetCurDragObj(self._curDragObj);
            self._curDragObj.transform.localPosition = Vector3.zero;
        end
        self._localPointerPosition = nil;
        self._curDragSingleDic[self._curDragObj] = self._BeDragData;
    end
    self.dragFormUp = true
end


function UIHeroAdvance:OnUpStartBtn(obj, eventData)

    if self._curDragObj then
        self._curDragObj.gameObject:SetActive(false)
    end
    if self._localPointerPosition == nil then
        if (self._curDragObj and self._curDragObj.gameObject) then
            self._curDragObj.gameObject:SetActive(false);
            self:SetPrefabColor(obj, true);
        else
        end
        return;
    end
    self.HeroCardDic[1]:SetCardAlpha(true)

    local vecTemp = self.heroCard.position;
    local fWidth = self.heroCard.gameObject:GetComponent(typeof(UnityEngine.RectTransform)).rect.width / 2;
    local fHeight = self.heroCard.gameObject:GetComponent(typeof(UnityEngine.RectTransform)).rect.height / 2;
    local vecTemp2 = self._curDragObj.transform.position;
    local HeroInfo = self._BeDragData;
    local alreadyInTheBox = self:IfInTheBox(HeroInfo);
    local DragInTheBox = false;

    if ((vecTemp.x - vecTemp2.x <= fWidth) and(vecTemp.x - vecTemp2.x >=(0 - fWidth)) and(vecTemp.y - vecTemp2.y <= fHeight) and(vecTemp.y - vecTemp2.y >=(0 - fHeight))) then
        DragInTheBox = true;
    end

    if DragInTheBox == true then
        if HeroInfo.isProtect then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, 55)
            DragInTheBox = false;
        end
        if HeroInfo and PlayerService:Instance():CheckCardInArmy(HeroInfo.id) then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.HeroInArmy)
            DragInTheBox = false;
        end

        if HeroInfo and(HeroInfo:GetSkill(2) ~= 0 or HeroInfo:GetSkill(3) ~= 0) then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.LearnedSkill)
            DragInTheBox = false;
        end

        if HeroInfo and HeroInfo.advancedTime + self.data[1].advancedTime + 1 > self.data[1].star then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, 2405)
        end

        if self:ifAwake(HeroInfo) then
            self._curDragObj.gameObject:SetActive(false);
            CommonService:Instance():ShowOkOrCancle(self, function()

                if (self._dragIn == true) then
                    if (alreadyInTheBox == false and DragInTheBox == true) then
                        self:AddToTheBox(HeroInfo);
                        self:ShowTheBox();
                    end
                end
                if (alreadyInTheBox == true and DragInTheBox == true) then
                    self.heroCard:GetChild(0).gameObject:SetActive(true)
                    self.AdvanceBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(greenPic);
                    self:ShowTheBox();
                end
                self.SetPrefabColor(obj, true);
            end , nil, "确认", "已觉醒武将卡消耗后不会返还素材卡");
            return
        end

        if (self._dragIn == true) then
            if (alreadyInTheBox == false and DragInTheBox == true) then
                self:AddToTheBox(HeroInfo);
                self:ShowTheBox();
            end
        end
        if (alreadyInTheBox == true and DragInTheBox == true) then
            self.heroCard:GetChild(0).gameObject:SetActive(true)
            self.AdvanceBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(greenPic);
            self:ShowTheBox();
        end
        self.SetPrefabColor(obj, true);
        self._curDragObj.gameObject:SetActive(false);
    else
        if DragInTheBox == false and self.dragFormUp == false then
            self:RemoveFromTheBox(HeroInfo);
            self:ShowTheBox();
        end
        if self.heroCard:GetChild(0).gameObject.activeSelf then
            self.AdvanceBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(greenPic);
        else
            self.AdvanceBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(pic);
        end
        self.SetPrefabColor(obj, true);
        self._curDragObj.gameObject:SetActive(false);
    end
    if self._myMIx then
        self.sameHeroList = HeroService:Instance():sorting(HeroSortType.spliteHero, self.sameHeroList)
        self._myMIx:SortingCardList(self.sameHeroList)
        self._myMIx:SetCardChooseState(self.HeroCardDic)
    end
    self.dragFormUp = false
end


function UIHeroAdvance:SetPrefabColor(obj, mBool)
    if obj == nil then
        return;
    end
    local mImage = { };

end


function UIHeroAdvance:IfInTheBox(info)
    for k, v in pairs(self._InTheBoxList._list) do
        if v == info then
            return true;
        end
    end
    return false;
end

function UIHeroAdvance:AddToTheBox(info)
    if self.sameHeroList:Count() == 0 then
        return
    end
    if (self._InTheBoxList:Count() >= MaxSize) then
        self._InTheBoxList:Clear()
    end
    for k, v in pairs(self._InTheBoxList._list) do
        if v == info then
            return;
        end
    end
    self._InTheBoxList:Push(info);
end

function UIHeroAdvance:RemoveFromTheBox(info)
    for k, v in pairs(self._InTheBoxList._list) do
        if v == info then
            self._InTheBoxList:Remove(info);
            local size = self._InTheBoxList:Count();
            return;
        end
    end
    if self._myMIx then
        self.sameHeroList = HeroService:Instance():sorting(HeroSortType.spliteHero, self.sameHeroList)
        self._myMIx:SortingCardList(self.sameHeroList)
        self._myMIx:SetCardChooseState(self.HeroCardDic)
    end
end

function UIHeroAdvance:CheckCardNumBool()
    if self.sameHeroList:Count() == 0 then
        return false
    end
    return true
end

function UIHeroAdvance:ShowTheBox()
    local size = self._InTheBoxList:Count();
    print(size)
    for i = 1, size do
        self.HeroCardDic[i].gameObject:SetActive(true);
        local info = self._InTheBoxList:Get(i);
        self.HeroCardDic[i]:SetHeroCardMessage(info);
        self._allHaveHeroCardDic[self.HeroCardDic[i].gameObject] = info;
    end
    if self._InTheBoxList:Count() == 0 then
        self.HeroCardDic[1].gameObject:SetActive(false);
    else
    end
    if self.heroCard:GetChild(0).gameObject.activeSelf then
        self.AdvanceBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(greenPic);
    else
        self.AdvanceBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(pic);
    end
    if self._myMIx then
        self.sameHeroList = HeroService:Instance():sorting(HeroSortType.spliteHero, self.sameHeroList)
        self._myMIx:SortingCardList(self.sameHeroList)
        self._myMIx:SetCardChooseState(self.HeroCardDic)
    end
end

function UIHeroAdvance:GetMyHeroList()

    local size = HeroService:Instance():GetOwnHeroCount();
    local herolist = List:new();
    for i = 1, size do
        herolist:Push(HeroService:Instance():GetOwnHeroes(i))
    end

    return herolist;

end

-- 是否是j觉醒的卡牌
function UIHeroAdvance:ifAwake(info)
    return info.isAwaken;
end


return UIHeroAdvance 



-- endregion
