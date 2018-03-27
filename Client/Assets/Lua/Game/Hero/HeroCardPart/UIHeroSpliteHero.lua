-- region *.lua
-- Date
-- UIHeroSpliteHero拆解战法界面

local UIBase = require("Game/UI/UIBase");
local UIHeroSpliteHero = class("UIHeroSpliteHero", UIBase);
local DataHero = require("Game/Table/model/DataHero");
local HeroCard = require("Game/Hero/HeroCardPart/HeroCard")
local UIHeroCard = require("Game/Hero/HeroCardPart/UIHeroCard")
local DataSkill = require("Game/Table/model/DataSkill");
require("Game/Table/model/DataUIConfig")
local List = require("common/List")
require("Game/Hero/HeroCardPart/HeroSortType");
require("Game/UI/UIMix");
local HeroCardList = nil;
local MaxSize = 1;
local ArmyType = require("Game/Hero/HeroCardPart/ArmyType")
local CampType = require("Game/Hero/HeroCardPart/CampType");
local pic = "Disassemble1";
local greenPic = "Disassemble";
function UIHeroSpliteHero:ctor()

    self.data = { };
    UIHeroSpliteHero.super.ctor(self)
    self.heroId = nil;
    self.skillBtn = nil;
    self.skill2Btn = nil;
    self.skillname = nil;
    self.skill2name = nil;
    self.skilltype = nil;
    self.skillrange = nil;
    self.targettype = nil;
    self.armtype = nil;
    self.probability = nil;
    self.splitBtn = nil;
    self.splitText = nil;
    self.basematter = nil;
    self.target = nil;
    self.skillintro = nil;
    self.back = nil;
    self.canShow = false;
    self.heroCard = nil;
    self.addBtn = nil;
    self._perfabPath = DataUIConfig[UIType.UIHeroCard].ResourcePath;
    self.heroCardBar = nil;
    self.HeroCardDic = { };
    HeroCardList = List:new();
    self._allHeroCardDic = { };
    self.isskill1 = true;
    self._tempParent = UnityEngine.GameObject.Find("Canvas").transform;
    self._canvas = self._tempParent.gameObject:GetComponent(typeof(UnityEngine.Canvas));
    -- 卡牌华东
    self._myMIx = nil;
    self._HeroCardObjList = List.new();
    self._dragIn = true;
    self._curDragSingleDic = { };
    self._allHaveHeroCardDic = { }
    self._InTheBoxList = List.new();
    self._refreshHeroCard = { }
    self._heroCardDataList = nil;
    self._FromTactis = false;
    self.expValue = nil;
    self._maxLv = 10;
    self.skillnameBackImage = nil
    self.skill2nameBackImage = nil
    self.skillintro1 = nil;
    self.armySortIsShow = false
    self.sortType = HeroSortType.spliteHero
    self.cardCountText = nil;
    self.formDownPart = false;
    self.question = nil;
    self.isIn = false;

end

function UIHeroSpliteHero:DoDataExchange()
    self.heroCard = self:RegisterController(UnityEngine.Transform, "herocard");
    self.skillBtn = self:RegisterController(UnityEngine.UI.Button, "skillname");
    self.skill2Btn = self:RegisterController(UnityEngine.UI.Button, "skillname1");
    self.skillname = self:RegisterController(UnityEngine.UI.Text, "skillname/Text");
    self.skill2name = self:RegisterController(UnityEngine.UI.Text, "skillname1/Text");
    self.skilltype = self:RegisterController(UnityEngine.UI.Text, "Scrolltext/Viewport/Content/type/Text");
    self.skillrange = self:RegisterController(UnityEngine.UI.Text, "Scrolltext/Viewport/Content/range/Text");
    self.targettype = self:RegisterController(UnityEngine.UI.Text, "Scrolltext/Viewport/Content/target/Text");
    self.armytype = self:RegisterController(UnityEngine.Transform, "Scrolltext/Viewport/Content/targettype");
    self.probability = self:RegisterController(UnityEngine.UI.Text, "Scrolltext/Viewport/Content/jilv");
    self.splitBtn = self:RegisterController(UnityEngine.UI.Button, "split");
    self.splitText = self:RegisterController(UnityEngine.UI.Text, "split/Text");
    self.addBtn = self:RegisterController(UnityEngine.UI.Button, "add");
    self.heroCardBar = self:RegisterController(UnityEngine.Transform, "Scrollhero/Content");
    self.skillintro = self:RegisterController(UnityEngine.UI.Text, "Scrolltext/Viewport/Content/level");
    self.skillintro1 = self:RegisterController(UnityEngine.UI.Text, "Scrolltext/Viewport/Content/NextLevel");
    self.back = self:RegisterController(UnityEngine.UI.Button, "back");
    self.defult = self:RegisterController(UnityEngine.Transform, "Scrolltext/defult");
    self.mask = self:RegisterController(UnityEngine.UI.Image, "split");
    self.expValue = self:RegisterController(UnityEngine.UI.Text, "add/Text");
    self.heroContent = self:RegisterController(UnityEngine.Transform, "Scrolltext/Viewport/Content");
    self.skillnameBackImage = self:RegisterController(UnityEngine.Transform, "skillname/Image");
    self.skill2nameBackImage = self:RegisterController(UnityEngine.Transform, "skillname1/Image");

    self.basematter = self:RegisterController(UnityEngine.UI.Text, "Scrolltext/Viewport/Content/basematter");
    self.matterone = self:RegisterController(UnityEngine.UI.Text, "Scrolltext/Viewport/Content/matterOne");
    self.mattertwo = self:RegisterController(UnityEngine.UI.Text, "Scrolltext/Viewport/Content/matterTwo");
    self.matterthree = self:RegisterController(UnityEngine.UI.Text, "Scrolltext/Viewport/Content/matterThree");
    self.matteroneText = self:RegisterController(UnityEngine.UI.Text, "Scrolltext/Viewport/Content/matterOne/Textone");
    self.mattertwoText = self:RegisterController(UnityEngine.UI.Text, "Scrolltext/Viewport/Content/matterTwo/Textwo");
    self.matterthreeText = self:RegisterController(UnityEngine.UI.Text, "Scrolltext/Viewport/Content/matterThree/Texthree");
    self.question = self:RegisterController(UnityEngine.UI.Button, "Scrolltext/defult/question");
    self.Aready = self:RegisterController(UnityEngine.UI.Text, "skillname/aready");
    self.Aready2 = self:RegisterController(UnityEngine.UI.Text, "skillname1/aready1");
end

function UIHeroSpliteHero:DoEventAdd()

    self:AddListener(self.skillBtn.gameObject, self.OnClickskillBtn);
    self:AddListener(self.skill2Btn.gameObject, self.OnClickskill2Btn);
    self:AddListener(self.splitBtn.gameObject, self.OnClicksplitBtn);
    self:AddListener(self.back.gameObject, self.OnClickbackBtn);
    self:AddListener(self.addBtn.gameObject, self.OnClickaddBtn);
    self:AddListener(self.question, self.OnClickquesionBtn);
end

function UIHeroSpliteHero:OnClickquesionBtn()
    self.temp = { };
    self.temp[1] = "说明"
    self.temp[2] = "拆解初始战法强化过的武将卡：返还80%战法经验\n拆解进阶过的武将卡，拆解过的战法的进阶次数*对应的研究度\n已觉醒武将卡消耗后不会返还素材卡";
    UIService:Instance():ShowUI(UIType.UICommonTipSmall, self.temp)
end
function UIHeroSpliteHero:OnClickaddBtn()
    self:OnClickbackBtn()
    UIService:Instance():HideUI(UIType.UITactis);
    SkillService:Instance():SetChangeNum(0)
    UIService:Instance():ShowUI(UIType.UITactisTransExp, true);
end


function UIHeroSpliteHero:RegisterAllNotice()
    self:RegisterNotice(L2C_Skill.UpdateSkill, self.GetASkill);
end

function UIHeroSpliteHero:GetASkill()
    local isopen = UIService:Instance():GetOpenedUI(UIType.UIHeroSpliteHero)
    local isopenSkill = UIService:Instance():GetOpenedUI(UIType.UITactisDetail);
    if isopen then
        UIService:Instance():HideUI(UIType.UIHeroCardPackage);
        UIService:Instance():GetUIClass(UIType.UIHeroSpliteHero):OnShow()
        if isopenSkill == false then
            UIService:Instance():HideUI(UIType.UIHeroCardInfo);
            UIService:Instance():ShowUI(UIType.UITactis)
        end
    end
end

function UIHeroSpliteHero:IfContainSkill(Id)
    local count = SkillService:Instance():GetSkillListSize();
    for i = 1, count do
        if SkillService:Instance():GetSkillFromListByID(Id) ~= nil then
            return true
        end
    end
    return false
end


function UIHeroSpliteHero:OnShow(data)
    self.data = data;
    if (self.data == nil) then
        self._FromTactis = true;
    else
        self._FromTactis = false;
    end
    self:ReShow()
    if self._myMIx == nil then
        local mMix = UIMix.new();
        mMix:SetLoadCallBack( function(obj)
            self:AddArmyConfigLister(obj);
            mMix:ScrollOnUpCB( function() self:OnMouseUp() end);
            mMix:ScrollOnDownCB( function() self:OnMouseDown() end);
            mMix:ScrollOnClickCB( function(go, eventData)
                self:OnMouseClick(go, eventData)
            end );
            mMix:SetPostionObj(self.gameObject);
            self._myMIx:GetDownPart().gameObject.transform.localPosition = Vector3.New(5.5 - 9.6 + 15, -185 + 31.7, 0)
            self._myMIx:GetDownPart().gameObject.transform.localScale = Vector3.New(.9, .9, 1)
            self._myMIx:GetDownPart().gameObject.transform:GetChild(3).gameObject:SetActive(false)
            self._myMIx:GetDownPart().gameObject:SetActive(true)

        end );
        self._myMIx = mMix;
        mMix:MakeScrollDrag(self._heroCardDataList, self.transform);
    else
        self._myMIx:MakeScrollDrag(self._heroCardDataList, self.transform);
        self._myMIx:GetDownPart().gameObject.transform.localPosition = Vector3.New(5.5 - 9.6 + 15, -185 + 31.7, 0)
        self._myMIx:GetDownPart().gameObject.transform.localScale = Vector3.New(.9, .9, 1)
        self._myMIx:GetDownPart().gameObject.transform:GetChild(3).gameObject:SetActive(false)
        self._myMIx:GetDownPart().gameObject:SetActive(true)
    end
    self._InTheBoxList:Clear()
    self:InitCards()

    if self._FromTactis == false then
        if self:ifAwake(self.data[1]) then
            CommonService:Instance():ShowOkOrCancle(self, function()
                self:ShowTheBox();
                self.skill2nameBackImage.gameObject:SetActive(false)
                self.defult.gameObject:SetActive(false)
                local mHero = DataHero[self.data[1].tableID];
                self:SetMessage(DataSkill[mHero.ExtractSkillIDArray[1]])
            end , function()
                self.heroCard:GetChild(0).gameObject:SetActive(false)
                self.defult.gameObject:SetActive(true)
                self.skillBtn.gameObject:SetActive(false)
                self.skill2Btn.gameObject:SetActive(false)
                self.mask.sprite = GameResFactory.Instance():GetResSprite(pic);
            end , "确认", "已觉醒武将卡消耗后不会返还素材卡");
            return
        end
    end
    self:ShowTheBox();
    self.skill2nameBackImage.gameObject:SetActive(false)
    if self._FromTactis == true then
        self.defult.gameObject:SetActive(true)
    else
        self.defult.gameObject:SetActive(false)
        local mHero = DataHero[self.data[1].tableID];
        self:SetMessage(DataSkill[mHero.ExtractSkillIDArray[1]])
    end
end

-- 滑动部分注册、监听
function UIHeroSpliteHero:AddArmyConfigLister(obj)
    self.downPartObj = obj;
    local parentPath = DataUIConfig[UIType.UIScorll].ResourcePath;
    self.cardCountText = obj.transform:Find("CardCountText"):GetComponent(typeof(UnityEngine.UI.Text));
    self.sortListObj = obj.transform:Find("SortListObj"):GetComponent(typeof(UnityEngine.Transform));
    self.closeSortBgBtn1 = obj.transform:Find("SortArmyBtn"):GetComponent(typeof(UnityEngine.UI.Button));
    self.closeSortBgBtn = obj.transform:Find("SortListObj/BackgroundBgBtn"):GetComponent(typeof(UnityEngine.UI.Button));
    self.rarityButton = obj.transform:Find("SortListObj/RarityButton"):GetComponent(typeof(UnityEngine.UI.Button));
    self.classSystemButton = obj.transform:Find("SortListObj/ClassSystemButton"):GetComponent(typeof(UnityEngine.UI.Button));
    self.campButton = obj.transform:Find("SortListObj/CampButton"):GetComponent(typeof(UnityEngine.UI.Button));
    self.gradeButton = obj.transform:Find("SortListObj/GradeButton"):GetComponent(typeof(UnityEngine.UI.Button));
    self.efficiencyButton = obj.transform:Find("SortListObj/EfficiencyButton"):GetComponent(typeof(UnityEngine.UI.Button));
    self.generalCardButton = obj.transform:Find("SortListObj/GeneralCardButton"):GetComponent(typeof(UnityEngine.UI.Button));
    self.cardCountText.text = self._heroCardDataList:Count() .. "/" .. HeroService:Instance():GetCardMaxLimit()
    self:AddListener(self.closeSortBgBtn, self.OnClickSortArmyBtn);
    self:AddListener(self.closeSortBgBtn1, self.OnClickSortArmyBtn);
    self:AddListener(self.rarityButton, self.OnClickRarityButton);
    self:AddListener(self.classSystemButton, self.OnClickClassSystemButton);
    self:AddListener(self.campButton, self.OnClickCampButton);
    self:AddListener(self.gradeButton, self.OnClickGradeButton);
    self:AddListener(self.efficiencyButton, self.OnClickEfficiencyButton);
    self:AddListener(self.generalCardButton, self.OnClickGeneralCardButton);
    self:SetSortListObj(false);
    self.closeSortBgBtn1.gameObject:SetActive(false)

end

-- 点击开、关排序按钮
function UIHeroSpliteHero:OnClickSortArmyBtn()
    if self.armySortIsShow == false then
        self.armySortIsShow = true;
    else
        self.armySortIsShow = false;
    end
    self:SetSortListObj(self.armySortIsShow);
end

function UIHeroSpliteHero:OnClickRarityButton()
    self:OnClickSortArmyBtn();
    self.sortType = HeroSortType.rarity;
    self._myMIx:SortingCardList(self:GetMyHeroList())

end

function UIHeroSpliteHero:OnClickClassSystemButton()
    self:OnClickSortArmyBtn();
    self.sortType = HeroSortType.armTtpe;
    self._myMIx:SortingCardList(self:GetMyHeroList())

end

function UIHeroSpliteHero:OnClickCampButton()
    self:OnClickSortArmyBtn();
    self.sortType = HeroSortType.camp;
    self._myMIx:SortingCardList(self:GetMyHeroList())
end

function UIHeroSpliteHero:OnClickGradeButton()
    self:OnClickSortArmyBtn();
    self.sortType = HeroSortType.level;
    self._myMIx:SortingCardList(self:GetMyHeroList())

end

function UIHeroSpliteHero:OnClickEfficiencyButton()
    self:OnClickSortArmyBtn();
    self.sortType = HeroSortType.cost;
    self._myMIx:SortingCardList(self:GetMyHeroList())

end

function UIHeroSpliteHero:OnClickGeneralCardButton()
    self:OnClickSortArmyBtn();
    self.sortType = HeroSortType.spliteHero;
    self._myMIx:SortingCardList(self:GetMyHeroList())

end

function UIHeroSpliteHero:SetSortListObj(isShow)
    if self.sortListObj ~= nil then
        self.sortListObj.gameObject:SetActive(isShow);
    end
end


function UIHeroSpliteHero:ReShow()

    if self.data == nil then
        self._heroCardDataList = self:GetMyHeroList();
    else
        local mHero = DataHero[self.data[1].tableID];
        self.skillname.text = DataSkill[mHero.ExtractSkillIDArray[1]].SkillnameText;
        if mHero.ExtractSkillIDArray[2] == nil then
            self.skill2Btn.gameObject:SetActive(false)
        else
            self.skill2name.text = DataSkill[mHero.ExtractSkillIDArray[2]].SkillnameText;
        end
        if self:IfContainSkill(mHero.ExtractSkillIDArray[1]) then
            self.mask.sprite = GameResFactory.Instance():GetResSprite(pic);
            self.Aready.gameObject:SetActive(true)
        else
            self.mask.sprite = GameResFactory.Instance():GetResSprite(greenPic);
            self.Aready.gameObject:SetActive(false)
        end
        if self:IfContainSkill(mHero.ExtractSkillIDArray[2]) then
            self.Aready2.gameObject:SetActive(true)
        else
            self.Aready2.gameObject:SetActive(false)
        end
        self:SetMessage(DataSkill[mHero.ExtractSkillIDArray[1]])


        for k, v in pairs(self._refreshHeroCard) do
            if (v.gameObject.activeSelf == true) then
                v.gameObject:SetActive(false);
            end
        end

        local herolist = self:GetMyHeroList()
        self._heroCardDataList = self:GetMyHeroList();
        local size = herolist:Count();
    end
    self.expValue.text = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Warfare):GetValue();

end

function UIHeroSpliteHero:RefreshExp()
    self.expValue.text = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Warfare):GetValue();
end

-- 初始化列表
function UIHeroSpliteHero:InitCards()
    if self.data == nil then
        self.data = { }
        self.data[1] = HeroCard.new()
    end
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
            self.HeroCardDic[1] = mHeroCard;
            self:AddToTheBox(mHeroCard)
            if self.data[1].tableID == 0 then
                self.HeroCardDic[1].gameObject:SetActive(false)
            else
                self.HeroCardDic[1].gameObject:SetActive(true)
            end
            self:ShowTheBox();
        end )
    else
        self.HeroCardDic[1]:SetHeroCardMessage(heroindex);
        self:AddToTheBox(mHeroCard)
        if self.data[1].tableID == 0 then
            self.HeroCardDic[1].gameObject:SetActive(false)
        else
            self.HeroCardDic[1].gameObject:SetActive(true)
        end
    end
end





function UIHeroSpliteHero:OnDownStartBtn(obj, eventData)
    self:SetSortListObj(false);
    self.armySortIsShow = false;

    self.formDownPart = true;
    self._dragIn = false;
    if obj == nil then
    end
    self._BeDragObj = obj;
    self:SetPrefabColor(obj, false);
    if self._curDragObj == nil then
        if self.data[1].tableID == 0 then
            return;
        end
        local mdata = DataUIConfig[UIType.UIHeroCard];
        local uiBase = require(mdata.ClassName).new();

        GameResFactory.Instance():GetUIPrefab(mdata.ResourcePath, self._tempParent, uiBase, function(go)
            uiBase:Init();
            uiBase:SetHeroCardMessage(self.data[1]);
            self._curDragObj = uiBase.gameObject;
            self:AddToTheBox(self.data[1])
            self._curDragBase = uiBase;
            self._curDragObj.transform.position = eventData.position;
            self:AddOnUp(self._curDragObj.gameObject, self.OnUpStartBtn);
            self:AddOnDrag(self._curDragObj.gameObject, self.OnDragStartBtn);
        end );
    else
        if self._curDragBase then
            self._curDragBase:SetHeroCardMessage(self.data[1]);
            self:AddToTheBox(self.data[1])
        end
    end
    self._localPointerPosition = nil;
    self._curDragSingleDic[self._curDragObj] = self._allHaveHeroCardDic[obj];
end


-- 滑动列表中卡牌点击
function UIHeroSpliteHero:OnClickHeroBtn(go, eventData)

    if self._allHaveHeroCardDic[self._BeDragObj] then
        HeroService:Instance():ShowHeroInfoUI(self.HeroCardDic[1]._heroId);
    end
end
-- 滑动列表中卡牌点击
function UIHeroSpliteHero:OnMouseClick(go, eventData)

    if self._BeDragData then
        HeroService:Instance():ShowHeroInfoUI(self._BeDragData.id);
    end
end



function UIHeroSpliteHero:OnDragStartBtn(obj, eventData)

    if obj == nil then
        -- print("obj is nil");
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



function UIHeroSpliteHero:SetSingleHeroCardData(mHeroCard, heroCard)


    if self._allHeroCardDic[heroCard.id] == nil then
        self._allHeroCardDic[heroCard.id] = mHeroCard;
    end

    if self._allHaveHeroCardDic[mHeroCard.gameObject] == nil then

        self._HeroCardObjList:Push(mHeroCard.gameObject);

    end

    self._allHaveHeroCardDic[mHeroCard.gameObject] = heroCard;

end

function UIHeroSpliteHero:OnMouseUp(go, eventData)
    if self._curDragObj then
        self._curDragObj.gameObject:SetActive(false)
    end

    self._BeDragObj = self._myMIx:GetBeDragObj();
    self._BeDragData = self._myMIx:GetBeDragObjData();
    self._localPointerPosition = self._myMIx:Get_localPointerPosition();
    if self._localPointerPosition then

    end

    if self._curDragObj then
        self:OnUpStartBtn(self._curDragObj.gameObject, eventData);
    end

end


function UIHeroSpliteHero:OnMouseDown(go, eventData)
    -- print("UIHeroSpliteHero:OnMouseDown(")
    self:SetSortListObj(false);
    self.armySortIsShow = false;
    self._dragIn = true;
    self._BeDragObj = self._myMIx:GetBeDragObj();
    self._BeDragData = self._myMIx:GetBeDragObjData();
    if self._myMIx then
        self._myMIx:SetCurDragObj(nil);
        self._BeDragObj = self._myMIx:GetBeDragObj();
        if self._BeDragObj == nil or self._BeDragObj.gameObject.activeInHierarchy == false then
            self._myMIx:SetCurDragObj(nil);
            return;
        end
        -- print(self._BeDragObj)
        if self._curDragObj == nil then
            -- print(self._BeDragObj)
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
                -- --print("in self.curdrag");
                self._curDragBase:SetHeroCardMessage(self._BeDragData);
                self._myMIx:SetCurDragObj(self._curDragObj);
            end
            self._myMIx:SetCurDragObj(self._curDragObj);
            self._curDragObj.transform.localPosition = Vector3.zero;
        end
        self._localPointerPosition = nil;
        self._curDragSingleDic[self._curDragObj] = self._BeDragData;
    end

    -- print(self._BeDragObj)
end


function UIHeroSpliteHero:OnUpStartBtn(obj, eventData)
    -- print(self._curDragObj)
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
    local isInTheBox = self:IfInTheBox(self.data[1]);
    local alreadyInTheBox = self:IfInTheBox(HeroInfo);
    local DragInTheBox = false;

    if ((vecTemp.x - vecTemp2.x <= fWidth) and(vecTemp.x - vecTemp2.x >=(0 - fWidth)) and(vecTemp.y - vecTemp2.y <= fHeight) and(vecTemp.y - vecTemp2.y >=(0 - fHeight))) then
        DragInTheBox = true;
    else
        DragInTheBox = false;
    end

    if DragInTheBox == true then
        if HeroInfo and HeroInfo.isProtect then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, 55)
            DragInTheBox = false;
        end
        if PlayerService:Instance():CheckCardInArmy(HeroInfo.id) then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.HeroInArmy)
            DragInTheBox = false;
            return;
        end
        if HeroInfo and(HeroInfo:GetSkill(2) ~= 0 or HeroInfo:GetSkill(3) ~= 0) then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.LearnedSkill)
            DragInTheBox = false;
            return;
        end

        if self:ifAwake(HeroInfo) then
            self._curDragObj.gameObject:SetActive(false);
            CommonService:Instance():ShowOkOrCancle(self, function()
                if (self._dragIn == true) then
                    if (alreadyInTheBox == false and DragInTheBox == true) then

                        self.data[1] = self._BeDragData
                        self:AddToTheBox(HeroInfo);
                        self.heroCard:GetChild(0).gameObject:SetActive(true)
                        self:ShowTheBox();
                    end
                end
                if (alreadyInTheBox == false and DragInTheBox == false) then
                    self:RemoveFromTheBox(HeroInfo);
                end

                if (alreadyInTheBox == true and DragInTheBox == true) then
                    self.heroCard:GetChild(0).gameObject:SetActive(true)
                    self._myMIx:SortingCardList(self:GetMyHeroList())
                    self._myMIx:SetCardChooseState(self.HeroCardDic)

                    if self.heroCard.transform:GetChild(0).gameObject.activeSelf == false then
                        self.defult.gameObject:SetActive(true)
                        self.mask.sprite = GameResFactory.Instance():GetResSprite(pic);
                        self.skillBtn.gameObject:SetActive(false)
                        self.skill2Btn.gameObject:SetActive(false)
                        self.splitText.text = ""
                    else
                        self.defult.gameObject:SetActive(false)
                        self.mask.sprite = GameResFactory.Instance():GetResSprite(greenPic);
                    end
                    self.data[1] = self._BeDragData
                end
                self.SetPrefabColor(obj, true);
            end , nil, "确认", "已觉醒武将卡消耗后不会返还素材卡");
            return
        end

        if (self._dragIn == true) then
            if (alreadyInTheBox == false and DragInTheBox == true) then

                self.data[1] = self._BeDragData
                self:AddToTheBox(HeroInfo);
                self.heroCard:GetChild(0).gameObject:SetActive(true)
                self:ShowTheBox();
            end
        end
        if (alreadyInTheBox == false and DragInTheBox == false) then
            self:RemoveFromTheBox(HeroInfo);
        end

        if (alreadyInTheBox == true and DragInTheBox == true) then
            self.heroCard:GetChild(0).gameObject:SetActive(true)
            self._myMIx:SortingCardList(self:GetMyHeroList())
            self._myMIx:SetCardChooseState(self.HeroCardDic)

            if self.heroCard.transform:GetChild(0).gameObject.activeSelf == false then
                self.defult.gameObject:SetActive(true)
                self.mask.sprite = GameResFactory.Instance():GetResSprite(pic);

                self.skillBtn.gameObject:SetActive(false)
                self.skill2Btn.gameObject:SetActive(false)
                self.splitText.text = ""
            else
                self.defult.gameObject:SetActive(false)
                self.mask.sprite = GameResFactory.Instance():GetResSprite(greenPic);
            end
            self.data[1] = self._BeDragData
        end
        self.SetPrefabColor(obj, true);
        self._curDragObj.gameObject:SetActive(false);
    else
        self.SetPrefabColor(obj, true);
        self._curDragObj.gameObject:SetActive(false);
        if DragInTheBox == false then
            if self.formDownPart then
                self.heroCard:GetChild(0).gameObject:SetActive(false)
                self._myMIx:SortingCardList(self:GetMyHeroList())
                self._myMIx:SetCardChooseState(self.HeroCardDic)
            else
                self.formDownPart = false
            end

            if self.heroCard.transform:GetChild(0).gameObject.activeSelf == false then
                self.defult.gameObject:SetActive(true)
                self.mask.sprite = GameResFactory.Instance():GetResSprite(pic);
                self.skillBtn.gameObject:SetActive(false)
                self.skill2Btn.gameObject:SetActive(false)
                self.splitText.text = ""
            else
                self.mask.sprite = GameResFactory.Instance():GetResSprite(greenPic);
                self.defult.gameObject:SetActive(false)
            end
        end
        if isInTheBox == true and DragInTheBox == false then
            self:RemoveFromTheBox(self.data[1]);
        end
    end

end



function UIHeroSpliteHero:SetPrefabColor(obj, mBool)
    if obj == nil then
        return;
    end
    local mImage = { };

end


function UIHeroSpliteHero:IfInTheBox(info)
    for k, v in pairs(self._InTheBoxList._list) do
        if v == info then
            return true;
        end
    end
    return false;
end

function UIHeroSpliteHero:AddToTheBox(info)
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

function UIHeroSpliteHero:RemoveFromTheBox(info)
    for k, v in pairs(self._InTheBoxList._list) do
        if v == info then
            self._InTheBoxList:Remove(info);
            return;
        end
    end
end

-- 是否是j觉醒的卡牌
function UIHeroSpliteHero:ifAwake(info)
    return info.isAwaken;
end



function UIHeroSpliteHero:ShowTheBox()

    local size = self._InTheBoxList:Count();
    for i = 1, size do
        local info = self._InTheBoxList:Get(i);
        self.HeroCardDic[i]:SetHeroCardMessage(info);
        self:ChangeData(info)
        self._allHaveHeroCardDic[self.HeroCardDic[i].gameObject] = info;
    end

    if size == 0 and self.heroCard:GetChild(0) ~= nil then
        self.heroCard:GetChild(0).gameObject:SetActive(false);
        self.defult.gameObject:SetActive(true)
        self.mask.sprite = GameResFactory.Instance():GetResSprite(pic);
        self.skillBtn.gameObject:SetActive(false)
        self.skill2Btn.gameObject:SetActive(false)
        self.splitText.text = ""
    else
        self.defult.gameObject:SetActive(false)
    end

    if self.heroCard.transform:GetChild(0).gameObject.activeSelf == false then
        self.defult.gameObject:SetActive(true)
        self.mask.sprite = GameResFactory.Instance():GetResSprite(pic);
        self.skillBtn.gameObject:SetActive(false)
        self.skill2Btn.gameObject:SetActive(false)
        self.splitText.text = ""
    else
        self.defult.gameObject:SetActive(false)
    end
    self._myMIx:SortingCardList(self:GetMyHeroList())
    self._myMIx:SetCardChooseState(self.HeroCardDic)
    self.formDownPart = false

end
function UIHeroSpliteHero:GetMyHeroList()

    local size = HeroService:Instance():GetOwnHeroCount();
    local herolist = List:new();
    for i = 1, size do
        if DataHero[HeroService:Instance():GetOwnHeroes(i).tableID].Star > 2 and DataHero[HeroService:Instance():GetOwnHeroes(i).tableID].ExtractSkillIDArray[1] ~= nil then
            herolist:Push(HeroService:Instance():GetOwnHeroes(i))
        end
    end
    herolist = HeroService:Instance():sorting(self.sortType, herolist)
    return herolist;

end

function UIHeroSpliteHero:SetMessage(id)
    self.heroContent.localPosition = Vector3.zero
    print(self:IfContainSkill(id.ID))
    if self:IfContainSkill(id.ID) then
        self.mask.sprite = GameResFactory.Instance():GetResSprite(pic);
    else
        self.mask.sprite = GameResFactory.Instance():GetResSprite(greenPic);
    end
    self.skilltype.text = id.TypeText;
    if id.Range == 0 then
        self.skillrange.text = "--"
    else
        self.skillrange.text = id.Range
    end
    self.targettype.text = id.TargetTypeText;
    self:SetCamp(id.ArmyTypeLearnable)
    self.probability.text = id.SkillChanceText / 100 .. "%";
    self:SetCurIntro(self.skillintro, id, 1)
    self:SetCurIntro(self.skillintro1, id, 2)
    self.splitText.text = id.SkillResolveNeedExp;

    self.basematter.text = id.ResearchConditionText
    if id.ResearchProgressOfHero[1] ~= 0 then
        local one = DataHero[id.ResearchProgressOfHero[1]];
        self.matterone.text = "【" .. self:GetCamp(one.Camp) .. "·" .. one.Name .. "·" .. self:GetArmyType(one.BaseArmyType) .. "】"
        self.matteroneText.text = "+" .. id.ResearchProgressPreHero[1] / 100 .. "%"
    else
        self.matterone.text = ""
        self.matteroneText.text = ""
    end
    if id.ResearchProgressOfHero[2] ~= nil then
        local two = DataHero[id.ResearchProgressOfHero[2]];
        self.mattertwo.text = "【" .. self:GetCamp(two.Camp) .. "·" .. two.Name .. "·" .. self:GetArmyType(two.BaseArmyType) .. "】"
        self.mattertwoText.text = "+" .. id.ResearchProgressPreHero[1] / 100 .. "%"
    else
        self.mattertwo.text = ""
        self.mattertwoText.text = ""
    end

    if id.ResearchProgressOfHero[3] ~= nil then
        local three = DataHero[id.ResearchProgressOfHero[3]];
        self.matterthree.text = "【" .. self:GetCamp(three.Camp) .. "·" .. three.Name .. "·" .. self:GetArmyType(three.BaseArmyType) .. "】"
        self.matterthreeText.text = "+" .. id.ResearchProgressPreHero[1] / 100 .. "%"
    else
        self.matterthree.text = ""
        self.matterthreeText.text = ""
    end

end

function UIHeroSpliteHero:GetArmyType(i)
    if i == ArmyType.Qi then
        return "骑"
    end
    if i == ArmyType.Gong then
        return "弓"
    end
    if i == ArmyType.Bu then
        return "步"
    end
end

function UIHeroSpliteHero:GetCamp(i)
    if i == CampType.Qin then
        return "秦"
    end
    if i == CampType.Janpan then
        return "侍"
    end
    if i == CampType.Europe then
        return "都铎"
    end
    if i == CampType.Viking then
        return "维京"
    end
end



-- 通过等级获得加成
function UIHeroSpliteHero:GetBufferByLv(lv, i, id)
    if (i == 0) then
        return 0;
    end
    local temp =((id.FinalSkillParameter[i] - id.InitialSkillParameter[i]) /(self._maxLv - 1) *(lv - 1) + id.InitialSkillParameter[i]) / 10;
    return temp;
    -- return string.format("%.1f", temp)
end


function UIHeroSpliteHero:SetCurIntro(label, id, lv)

    local count = #id.InitialSkillParameter
    local tempNums = { }
    for index = 1, count do
        tempNums[index] = self:GetBufferByLv(lv, index, id);
    end
    if (count == 0) then
        -- 这是临时的 正式的用下面那四种
        label.text = id.Skilldescription;
    end
    if (count == 1) then
        label.text = string.format(id.Skilldescription, tempNums[1]);
    end
    if (count == 2) then
        label.text = string.format(id.Skilldescription, tempNums[1], tempNums[2]);
    end
    if (count == 3) then
        label.text = string.format(id.Skilldescription, tempNums[1], tempNums[2], tempNums[3]);
    end
    if (count == 4) then
        label.text = string.format(id.Skilldescription, tempNums[1], tempNums[2], tempNums[2], tempNums[3]);
    end

end



function UIHeroSpliteHero:ChangeData(info)
    self.skillBtn.gameObject:SetActive(true)
    if self.data[1].tableID == 0 then
        return
    end
    self.skillnameBackImage.gameObject:SetActive(true)
    self.skill2nameBackImage.gameObject:SetActive(false)
    local heroSkill = DataHero[self.HeroCardDic[1].heroCard.tableID];
    local skillid = DataHero[self.HeroCardDic[1].heroCard.tableID].ExtractSkillIDArray[1];
    local skill = DataSkill[skillid];
    self:SetMessage(skill)
    self.isskill1 = true
    self.skillname.text = skill.SkillnameText
    if heroSkill.ExtractSkillIDArray[2] ~= nil then
        self.skill2Btn.gameObject:SetActive(true)
        self.skill2name.text = DataSkill[heroSkill.ExtractSkillIDArray[2]].SkillnameText
    else
        self.skill2Btn.gameObject:SetActive(false)
    end
    if self:IfContainSkill(heroSkill.ExtractSkillIDArray[1]) then
        self.Aready.gameObject:SetActive(true)
        self.isIn = true
    else
        self.Aready.gameObject:SetActive(false)
        self.isIn = false
    end
    if self:IfContainSkill(heroSkill.ExtractSkillIDArray[2]) then
        self.Aready2.gameObject:SetActive(true)
    else
        self.Aready2.gameObject:SetActive(false)
    end
end

function UIHeroSpliteHero:OnClickskillBtn()
    if self.HeroCardDic[1].gameObject.activeSelf == false then
        return
    end
    local skillid = DataHero[self.HeroCardDic[1].heroCard.tableID].ExtractSkillIDArray[1];
    local skill = DataSkill[skillid];
    self:SetMessage(skill)
    self.skill2nameBackImage.gameObject:SetActive(false)
    self.skillnameBackImage.gameObject:SetActive(true)

    self.isskill1 = true;

end

function UIHeroSpliteHero:OnClickskill2Btn()
    if self.HeroCardDic[1].gameObject.activeSelf == false then
        return
    end
    local skillid = DataHero[self.HeroCardDic[1].heroCard.tableID].ExtractSkillIDArray[2];
    local skill = DataSkill[skillid];
    self:SetMessage(skill)
    self.skill2nameBackImage.gameObject:SetActive(true)
    self.skillnameBackImage.gameObject:SetActive(false)
    self.isskill1 = false
end

function UIHeroSpliteHero:GotoUITactisTransExp()
    UIService:Instance():HideUI(UIType.UIHeroAwake)
    UIService:Instance():HideUI(UIType.UIHeroAdvance)
    UIService:Instance():HideUI(UIType.UIHeroSpliteHero)
    UIService:Instance():ShowUI(UIType.UITactisTransExp);
    UIService:Instance():HideUI(UIType.UITactisDetail);
    UIService:Instance():HideUI(UIType.UIHeroCardInfo);
end

function UIHeroSpliteHero:Cancle()
    -- 空方法保留
end


function UIHeroSpliteHero:OnClicksplitBtn()
    if self.HeroCardDic[1] == nil then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.NoCardForAdvance)
        return
    end

    if self.HeroCardDic[1].gameObject.activeSelf == false then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.NoCardForAdvance)
        return
    end

    if self.isIn then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 901)
        return
    end

    if tonumber(self.splitText.text) > PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Warfare):GetValue() then
        CommonService:Instance():ShowOkOrCancle(self, self.GotoUITactisTransExp, self.Cancle, "确认", "战法经验不足以强化\n去转换战法经验");
        return
    end
    if self.HeroCardDic[1].heroCard.isProtect then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.HeroIsProtect)
        return
    end
    CommonService:Instance():ShowOkOrCancle(self, self.SpliteFun, self.Cancle, "确认", "是否消耗【" .. HeroService:Instance():GetHeroNameById(self.HeroCardDic[1].heroCard.tableID) .. "】并拆解成战法\n拆解成战法后武将卡会消失");
end


function UIHeroSpliteHero:SpliteFun()
    local id = self.HeroCardDic[1].heroCard.id
    CommonService:Instance():Play("Audio/SplitHero")
    if self.isskill1 then
        local skillid = DataHero[self.HeroCardDic[1].heroCard.tableID].ExtractSkillIDArray[1]
        HeroService:Instance():SendExtractSkillMsg(id, skillid)
    else

        local skillid = DataHero[self.HeroCardDic[1].heroCard.tableID].ExtractSkillIDArray[2]
        HeroService:Instance():SendExtractSkillMsg(id, skillid)
    end
    UIService:Instance():HideUI(UIType.UIHeroSpliteHero)
    SkillService:Instance():SetChangeNum(0)
end


function UIHeroSpliteHero:OnClickbackBtn()

    UIService:Instance():HideUI(UIType.UIHeroSpliteHero)
    if UIService:Instance():GetOpenedUI(UIType.ArmyFunctionUI) == false then
        UIService:Instance():ShowUI(UIType.UIGameMainView)
    end
    if UIService:Instance():GetOpenedUI(UIType.UIHeroCardPackage) == false then
        UIService:Instance():ShowUI(UIType.UITactis);
    end
end

function UIHeroSpliteHero:SetCamp(mCamp)

    local tranParent = self.armytype.transform;
    tranParent.gameObject:SetActive(true);

    for i = 1, table.getn(mCamp) do
        if mCamp[i] then
            tranParent:GetChild(mCamp[i] -1).gameObject:SetActive(true);
        else
            tranParent:GetChild(mCamp[i] -1).gameObject:SetActive(false);
        end

    end
end



return UIHeroSpliteHero 
-- endregion





-- endregion
