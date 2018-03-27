


local UIBase = require("Game/UI/UIBase")

local UITactisResearch = class("UITactisResearch", UIBase)
local UIService = require("Game/UI/UIService")
local UIType = require("Game/UI/UIType")
local ArmyType = require("Game/Hero/HeroCardPart/ArmyType")
local CampType = require("Game/Hero/HeroCardPart/CampType");
local HeroCard = require("Game/Hero/HeroCardPart/UIHeroCard");
local List = require("common/List");

local SKillResearch = require("MessageCommon/Msg/C2L/Skill/ResearchSkill");
local DataSkill = require("Game/Table/model/DataSkill")
local DataHero = require("Game/Table/model/DataHero")
require("Game/UI/UIMix");
local MaxSize = 10;
local SkillID = 0;
local LastProgress = 0;
local ChangPosition = UnityEngine.Vector3(0, 40, 0);
local ChangeObj = nil;
local Effect = nil;

function UITactisResearch:ctor()
    UITactisResearch.super.ctor(self)
    self._backBtn = nil;
    self._tipsBtn = nil;
    self._researchTipBtn = nil;
    self._tipsLabel = nil;
    self._skillName = nil;
    self._mask = nil;
    self._progressNum = nil;
    self._percent = nil;
    self._percentChangge = nil;
    self._researchBtn = nil;
    self._chooseCardsNumLabel = nil;
    self._bottomObj = nil;
    self._parentObj = nil;
    self._HeroCardUIList = List.new();
    self._HeroObjList = List.new();
    self._InTheBoxList = List.new();
    self._CardInfoList = List.new();
    self._boxTrans = nil;
    self._dragIn = true;
    self._curDragSingleDic = { };
    self._tempParent = UnityEngine.GameObject.Find("Canvas").transform;
    self._canvas = self._tempParent.gameObject:GetComponent(typeof(UnityEngine.Canvas));
    self._allHaveHeroCardDic = { };
    self._allHeroCardDic = { };
    self._allArmyCampDic = { };
    self._allBaseData = { }
    self._upDragBase = nil;
    self._myMIx = nil;
    self._skillInfo = nil;
    self._skillLine = nil;
    self._effectobj = nil;
    self._currentProgress = 0;
    self.GoldenArrowsImage = nil;
    self.commandPic = "Tactics03"
    self.attackPic = "Tactics04"
    self.activePic = "Tactics01"
    self.passivePic = "Tactics02"
    self.currentShowPercent = 0;
    self.PreHeroList = List.new()

    self.param = nil;

end

function UITactisResearch:DoDataExchange()
    self._backBtn = self:RegisterController(UnityEngine.UI.Button, "BackBtn");
    self._tipsBtn = self:RegisterController(UnityEngine.UI.Button, "TopObj/TactisObj/TipsBtn");
    self._researchTipBtn = self:RegisterController(UnityEngine.UI.Button, "TopObj/AllBtns/ResearchTipBtn");
    self._tipsLabel = self:RegisterController(UnityEngine.UI.Text, "TopObj/TactisObj/TipsObj/TipsLabel");
    self._skillName = self:RegisterController(UnityEngine.UI.Button, "TopObj/TactisObj/SkillIcon/SkillName");
    self._skillIcon = self:RegisterController(UnityEngine.UI.Image, "TopObj/TactisObj/SkillIcon/SkillBtn");
    self._mask = self:RegisterController(UnityEngine.UI.Image, "TopObj/TactisObj/SkillIcon/Mask");
    self._addMask = self:RegisterController(UnityEngine.UI.Image, "TopObj/TactisObj/SkillIcon/AddMask");
    self._progressNum = self:RegisterController(UnityEngine.UI.Text, "TopObj/TactisObj/SkillIcon/ProgressNum");
    self._percent = self:RegisterController(UnityEngine.UI.Text, "TopObj/TactisObj/SkillIcon/Percent");
    self._percentChangge = self:RegisterController(UnityEngine.UI.Text, "TopObj/TactisObj/SkillIcon/PercentChangge");
    self._researchBtn = self:RegisterController(UnityEngine.UI.Button, "TopObj/AllBtns/ResearchBtn");
    self._chooseCardsNumLabel = self:RegisterController(UnityEngine.UI.Text, "TopObj/AddCardsObj/ChooseCardsCount");
    self._bottomObj = self:RegisterController(UnityEngine.Transform, "BottomObj");
    self._boxTrans = self:RegisterController(UnityEngine.Transform, "TopObj/AddCardsObj/Panel");
    -- self._tempParent = self:RegisterController(UnityEngine.Transform,"TopObj/AddCardsObj/Panel/TempParent");
    self._parentObj = self:RegisterController(UnityEngine.Transform, "TopObj/AddCardsObj/Panel/ParentObj");
    self._effectobj = self:RegisterController(UnityEngine.Transform, "TopObj/TactisObj/EffectObj");
    self.GoldenArrowsImage = self:RegisterController(UnityEngine.UI.Button, "GoldenArrowsImage");
    self.cardCountText = nil;
end

-- 初始化
function UITactisResearch:OnInit()
    self._researchBtn.interactable = false;
end


function UITactisResearch:DoEventAdd()
    self:AddListener(self._backBtn, self.OnClickBackBtn);
    self:AddListener(self._tipsBtn, self.OnClickTipsBtn);
    self:AddListener(self._researchTipBtn, self.OnClickResearchTipsBtn);
    self:AddListener(self._researchBtn, self.OnClickResearchBtn);
    self:AddListener(self.GoldenArrowsImage, self.OnClickGoldenArrowsImage);

    self:InitArmyCamp();
end

-- 注册所有的事件
function UITactisResearch:RegisterAllNotice()
    self:RegisterNotice(L2C_Skill.UpdateSkill, self.RefreshSkillInfo);
    self:RegisterNotice(L2C_Skill.DeleteOneSkillRespond, self.RefreshSkillInfo);
    self:RegisterNotice(L2C_Card.RemoveCard, self.RefreshHeroCard);
    self:RegisterNotice(L2C_Card.OneCardProperty, self.RefreshHeroCard);
end

-- 刷新技能
function UITactisResearch:RefreshSkillInfo()
    CommonService:Instance():Play("Audio/ResearchSkill")
    local info = SkillService:Instance():GetSkillFromListByID(self._skillInfo._id);
    if (info ~= nil) then
        self._skillInfo = info;
        self:SetSkillInfo();
        self:ShowEffect();
    else
        self:OnClickBackBtn();
    end
end

-- 刷新英雄卡牌
function UITactisResearch:RefreshHeroCard()
    self:GetHeroList();
    -- self:RefreshUIShow();
    CommonService:Instance():Play("Audio/LearnSkill")
    self._myMIx:MakeScrollDrag(self._CardInfoList, self._bottomObj, true);
    self:UpdateCard();
end

-- 卡牌状态更新 刷新列表
function UITactisResearch:UpdateCard()
    local count = self._InTheBoxList:Count();
    for index = 1, count do
        local info = self._InTheBoxList:Get(index);
        if (info ~= nil and info.isProtect == true) then
            self:RemoveFromTheBox(info)
        end
    end
    self:ShowTheBox(true);
end

-- 点击关闭界面
function UITactisResearch:OnClickBackBtn()
    self._InTheBoxList:Clear();
    SkillService:Instance():SetChooseList(self._InTheBoxList);
    UIService:Instance():HideUI(UIType.UITactisResearch);
    if SkillService:Instance():GetLastSkill() ~= nil then
        print(SkillService:Instance():GetLastSkill())
        self.param = SkillService:Instance():GetLastSkill()
        SkillService:Instance():SetLastSkill()
        -- 清空已备下次使用
    end
    UIService:Instance():ShowUI(UIType.UITactisDetail, self.param)
    -- print("--------------------- 关闭研究界面 -------------------------")
    -- 下面两行用来显示隐藏的详情和背包界面
    -- UIService:Instance():ShowUI(UIType.UITactisDetail)  --这个不好控制先隐藏 因为强化也可能是这个界面
    if UIService:Instance():GetOpenedUI(UIType.UIHeroCardInfo) == false then
        UIService:Instance():ShowUI(UIType.UITactis)
    end
end

-- 点击提示
function UITactisResearch:OnClickTipsBtn()
    self.temp = { };
    self.temp[1] = "说明"
    self.temp[2] = "消耗初始战法强化过的武将卡：返还80%的战法经验\n消耗进阶过的武将卡，默认提升的研究度=该武将卡增加的研究进度*进阶次数\n消耗已觉醒的武将卡不会返还素材卡";
    UIService:Instance():ShowUI(UIType.UICommonTipSmall, self.temp)
end
-- 点击跳转招募界面

function UITactisResearch:OnClickGoldenArrowsImage()
    -- 跳转招募界面
end

-- 点击提示
function UITactisResearch:OnClickResearchTipsBtn()
    self.temp = { };
    self.temp[1] = "说明"
    local str1 = "";
    if self._skillLine.ResearchProgressOfHero[1] ~= 0 then
        local one = DataHero[self._skillLine.ResearchProgressOfHero[1]];
        str1 = str1 .. "\n               【" .. self:GetCamp(one.Camp) .. "·" .. one.Name .. "·" .. self:GetArmyType(one.BaseArmyType) .. "】   +" .. self._skillLine.ResearchProgressPreHero[1] / 100 .. "%"
    end
    if self._skillLine.ResearchProgressOfHero[2] ~= nil then
        local two = DataHero[self._skillLine.ResearchProgressOfHero[2]];
        str1 = str1 .. "\n               【" .. self:GetCamp(two.Camp) .. "·" .. two.Name .. "·" .. self:GetArmyType(two.BaseArmyType) .. "】   +" .. self._skillLine.ResearchProgressPreHero[2] / 100 .. "%"
    end
    if self._skillLine.ResearchProgressOfHero[3] ~= nil then
        local three = DataHero[self._skillLine.ResearchProgressOfHero[3]];
        str1 = str1 .. "\n               【" .. self:GetCamp(three.Camp) .. "·" .. three.Name .. "·" .. self:GetArmyType(three.BaseArmyType) .. "】   + " .. self._skillLine.ResearchProgressPreHero[3] / 100 .. "%"
    end
    self.temp[2] = "本技能研究素材:\n                " .. self._skillLine.ResearchConditionText .. "<color=#00FF00>" .. str1 .. "</color>";
    UIService:Instance():ShowUI(UIType.UICommonTipSmall, self.temp)
end

function UITactisResearch:GetArmyType(i)
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

function UITactisResearch:GetCamp(i)
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




-- 点击研究
function UITactisResearch:OnClickResearchBtn()
    local count = self._InTheBoxList:Count();
    if (count < 1) then
        pirnt("have no choice");
        return;
    end
    local msg = SKillResearch.new();
    msg:SetMessageId(C2L_Skill.ResearchSkill);
    msg.skillID = self._skillInfo._id;
    for i = 1, count do
        msg.cards:Push(self._InTheBoxList:Get(i).id);
    end
    NetService:Instance():SendMessage(msg);
end

-- 初始化卡牌列表
function UITactisResearch:GetHeroList()
    self._CardInfoList:Clear();
    self.PreHeroList:Clear()
    local count = HeroService:Instance():GetOwnHeroCount();
    for i = 1, count do
        local heroinfo = HeroService:Instance():GetOwnHeroes(count + 1 - i);
        if (self:ifCanResearch(heroinfo)) then
            self._CardInfoList:Push(heroinfo);
        end;
    end
    local HeroCardList = List.new()
    for k, v in pairs(self.PreHeroList._list) do
        HeroCardList:Push(v)
    end
    self._CardInfoList = HeroService:Instance():sorting(HeroSortType.spliteHero, self._CardInfoList)
    for k, v in pairs(self._CardInfoList._list) do
        HeroCardList:Push(v);
    end
    self._CardInfoList = HeroCardList

end

-- 是否能够研究
function UITactisResearch:ifCanResearch(heroinfo)
    local heroId = heroinfo.tableID;
    if (DataHero[heroId] == nil) then
        return false;
    end
    local herotype = DataHero[heroId].Star;
    -- 英雄卡牌星级类型 table
    local herotypes = self._skillLine.ResearchProgressOfHeroClassification;
    -- 英雄所需武将星级table
    local heroids = self._skillLine.ResearchProgressOfHero;
    -- 指定武将研究进度
    local count1 = #herotypes;
    local count2 = #heroids;

    for index = 1, count1 do
        if (herotypes[index] + 2 == herotype) then
            return true;
        end
    end

    for index = 1, count2 do
        if (heroids[index] == heroId) then
            self.PreHeroList:Push(heroinfo)
        end
    end
    return false;
end


-- 设置图片
function UITactisResearch:GetImage(num)

    if num == nil then
        return nil;
    end
    if num == 3 then

        return GameResFactory.Instance():GetResSprite(self.commandPic);
    end
    if num == 4 then

        return GameResFactory.Instance():GetResSprite(self.attackPic);
    end
    if num == 1 then

        return GameResFactory.Instance():GetResSprite(self.activePic);
    end

    if num == 2 then

        return GameResFactory.Instance():GetResSprite(self.passivePic);
    end
end


-- override
function UITactisResearch:OnShow(param)
    self.param = param[2]
    self.PreHeroList:Clear()
    self._effectobj.gameObject:SetActive(false);
    self._percentChangge.gameObject:SetActive(false);
    LastProgress = 0;
    self._skillInfo = param[1];
    SkillID = self._skillInfo._tableId;
    self._skillLine = DataSkill[SkillID];
    self:GetHeroList();
    self:RefreshUIShow();
    self._progressNum.text = "-/" .. self._skillLine.MaxLearnNum;
    self._skillIcon.sprite = self:GetImage(self._skillLine.Type)

    if self._myMIx == nil then
        local mMix = UIMix.new();
        mMix:SetLoadCallBack( function(obj)
            self.cardCountText = obj.transform:Find("CardCountText"):GetComponent(typeof(UnityEngine.UI.Text));
            self._myMIx = mMix;
            mMix:ScrollOnUpCB( function() self:OnMouseUp() end);
            mMix:ScrollOnClickCB( function(go, eventData) self:OnMouseClick(go, eventData) end);
            mMix:ScrollOnDownCB( function() self:OnMouseDown() end);
            mMix:SetPostionObj(self.gameObject)
            mMix:SetChooseBtn(false);
            obj:SetActive(true)
        end );
        mMix:MakeScrollDrag(self._CardInfoList, self._bottomObj, true);
        self._myMIx:GetDownPart().gameObject.transform.localPosition = Vector3.New(0, -10, 0);
    else
        self._myMIx:MakeScrollDrag(self._CardInfoList, self._bottomObj, true);
        self._myMIx:GetDownPart().gameObject.transform.localPosition = Vector3.New(0, -10, 0);
    end
    self:SetSkillInfo();
    self:ClearIntheBox();
    local newskillinfo = SkillService:Instance():GetNewSkill();
    if (self._skillInfo == newskillinfo) then
        self:ShowEffect();
        SkillService:Instance():SetNewSkill();
    end
    self.cardCountText.text = self._CardInfoList:Count() .. "/" .. HeroService:Instance():GetCardMaxLimit()
end

-- 设置技能数据
function UITactisResearch:SetSkillInfo()
    if (self._skillInfo._progress >= 10000) then
        self._InTheBoxList:Clear();
        SkillService:Instance():SetChooseList(self._InTheBoxList);
        UIService:Instance():HideUI(UIType.UITactisResearch);
        if UIService:Instance():GetOpenedUI(UIType.UIHeroCardInfo) == false then
            UIService:Instance():ShowUI(UIType.UITactis)
        end
        UIService:Instance():HideUI(UIType.UITactisDetail);
        return;
    end
    self._currentProgress = self._skillInfo._progress / 100;
    self._percent.text = self._currentProgress .. "%";
    self:ClearIntheBox();
    self:ShowTheBox();
end

-- 初始化时设置卡牌并隐藏
function UITactisResearch:InitArmyCamp()

    for index = 1, MaxSize do
        if self._allArmyCampDic[index] == nil then
            local mdata = DataUIConfig[UIType.UIHeroCard];
            local uiBase = require(mdata.ClassName).new();
            GameResFactory.Instance():GetUIPrefab(mdata.ResourcePath, self._parentObj.transform, uiBase, function(go)
                uiBase:Init();
                if uiBase.gameObject then
                    self:AddOnDown(uiBase, self.OnDownStartBtn);
                    self:AddOnUp(uiBase, self.OnUpStartBtn);
                    self:AddOnClick(uiBase, self.OnClickHeroBtn);
                    self:AddOnDrag(uiBase, self.OnDragStartBtn);
                    self._allArmyCampDic[index] = uiBase;
                    self._allBaseData[uiBase.gameObject] = uiBase;
                    uiBase.gameObject:SetActive(false);
                    -- ������
                end
            end );
        end
    end

end

-- 点击英雄按钮
function UITactisResearch:OnClickHeroBtn(obj, eventData)
    if self._allHaveHeroCardDic[self._BeDragObj] then
        HeroService:Instance():ShowHeroInfoUI(self._allHaveHeroCardDic[self._BeDragObj].id);
    end
end

-- 滑动列表中卡牌点击
function UITactisResearch:OnMouseClick(go, eventData)
    if self._BeDragData then
        HeroService:Instance():ShowHeroInfoUI(self._BeDragData.id);
    end
end

-- 按下
function UITactisResearch:OnDownStartBtn(obj, eventData)
    self._dragIn = false;
    if obj == nil then
    end
    self._BeDragObj = obj;
    self._BeDragData = self._allHaveHeroCardDic[obj]
    -- self._myMIx:GetBeDragObjData();
    self:SetPrefabColor(obj, false);
    if self._curDragObj == nil then
        local mdata = DataUIConfig[UIType.UIHeroCard];
        local uiBase = require(mdata.ClassName).new();
        GameResFactory.Instance():GetUIPrefab(mdata.ResourcePath, self._ParentObjTrans.transform, uiBase, function(go)
            uiBase:Init();
            uiBase:SetHeroCardMessage(self._BeDragData);
            self._curDragObj = uiBase.gameObject;
            self._curDragBase = uiBase;
            self._curDragObj.transform.position = eventData.position;
            self:AddOnUp(self._curDragObj, self.OnUpStartBtn);
            self:AddOnDrag(self._curDragObj, self.OnDragStartBtn);

        end );
    else
        if self._curDragBase then
            self._curDragBase:SetHeroCardMessage(self._BeDragData);
        end
    end
    self._localPointerPosition = nil;
    self._curDragSingleDic[self._curDragObj] = self._BeDragData;
    self._upDragBase = self._allBaseData[obj]

end

-- 拖动
function UITactisResearch:OnDragStartBtn(obj, eventData)

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

    if self._upDragBase then
        self._upDragBase:SetCardAlpha(false)
    end
end

-- 刷新
function UITactisResearch:RefreshUIShow()
    local size = self._CardInfoList:Count();
    local mObjIndex = -1;
    local HaveUICount = self._HeroCardUIList:Count();
    for index = 1, HaveUICount do
        self._HeroCardUIList:Get(index).gameObject:SetActive(false)
    end
    --    for index = 1, size do
    --        local heroCardinfo = self._CardInfoList:Get(index);
    --        if heroCardinfo == nil then
    --                break
    --            end
    --        local mdata = DataUIConfig[UIType.UIHeroCard];
    --        if index > HaveUICount then
    --            local mHeroCard = HeroCard.new();
    --            GameResFactory.Instance():GetUIPrefab(mdata.ResourcePath, self.transform, mHeroCard, function(go)
    --                mHeroCard:Init();
    --                self._HeroCardUIList:Push(mHeroCard);
    --                self._HeroObjList:Push(mHeroCard.gameObject)
    --                self:SetSingleHeroCardData(mHeroCard, heroCardinfo);
    --            end );
    --        else
    --            local mHeroCard = self._HeroCardUIList:Get(index);
    --            mHeroCard.gameObject:SetActive(true);
    --            self:SetSingleHeroCardData(mHeroCard, heroCardinfo);
    --        end
    --    end
end

-- 设置卡牌数据
function UITactisResearch:SetSingleHeroCardData(mHeroCard, heroCard)
    mHeroCard:SetHeroCardMessage(heroCard);
    self._allHeroCardDic[heroCard.id] = mHeroCard;
    self._allHaveHeroCardDic[mHeroCard.gameObject] = heroCard;
end

-- 抬起
function UITactisResearch:OnMouseUp(go, eventData)

    self._BeDragObj = self._myMIx:GetBeDragObj();
    self._localPointerPosition = self._myMIx:Get_localPointerPosition();
    if self._localPointerPosition then
    end
    if self._curDragObj then
        self:OnUpStartBtn(self._curDragObj.gameObject, eventData);
    end
    self:GetHeroList()
    self._myMIx:SortingCardList(self._CardInfoList)
    self._myMIx:SetCardChooseState(self._allArmyCampDic)

end

-- 按下
function UITactisResearch:OnMouseDown(go, eventData)

    self._dragIn = true;
    if self._myMIx then

        self._BeDragObj = self._myMIx:GetBeDragObj();
        self._BeDragData = self._myMIx:GetBeDragObjData();
        if self._BeDragObj == nil then
            return;
        end
        if self._curDragObj == nil then
            -- �ҵ���������
            local mdata = DataUIConfig[UIType.UIHeroCard];
            local uiBase = require(mdata.ClassName).new();

            -- ����Ԥ��
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

-- 抬起
function UITactisResearch:OnUpStartBtn(obj, eventData)
    if self._localPointerPosition == nil then
        if self._curDragObj.gameObject then
            self._curDragObj.gameObject:SetActive(false);
            self:SetPrefabColor(obj, true);
        end
        return;
    end
    if self._upDragBase then
        self._upDragBase:SetCardAlpha(true)
    end
    local vecTemp = self._boxTrans.position;
    -- self._boxTrans.localPosition;
    local fWidth = self._boxTrans.gameObject:GetComponent(typeof(UnityEngine.RectTransform)).rect.width / 2;
    local fHeight = self._boxTrans.gameObject:GetComponent(typeof(UnityEngine.RectTransform)).rect.height / 2;
    local vecTemp2 = self._curDragObj.transform.position;
    local HeroInfo = self._BeDragData;
    local alreadyInTheBox = self:IfInTheBox(HeroInfo);
    local DragInTheBox = false;
    if ((vecTemp.x - vecTemp2.x <= fWidth) and(vecTemp.x - vecTemp2.x >=(0 - fWidth)) and(vecTemp.y - vecTemp2.y <= fHeight) and(vecTemp.y - vecTemp2.y >=(0 - fHeight))) then
        DragInTheBox = true;
    end
    if (self._dragIn == true) then
        if (alreadyInTheBox == false and DragInTheBox == true) then
            local inarmy = self:ifInArmy(HeroInfo);
            local learnskill = self:ifLearnSkill(HeroInfo);
            local isprotected = self:ifprotected(HeroInfo);
            if (inarmy or learnskill or isprotected) then
                if (inarmy) then
                    UIService:Instance():ShowUI(UIType.UICueMessageBox, 56);
                elseif (isprotected) then
                    UIService:Instance():ShowUI(UIType.UICueMessageBox, 55);
                elseif (learnskill) then
                    UIService:Instance():ShowUI(UIType.UICueMessageBox, 57);
                end
            else

                if self:ifAwake(HeroInfo) then
                    self._curDragObj.gameObject:SetActive(false);
                    CommonService:Instance():ShowOkOrCancle(self, function()
                        self:AddToTheBox(HeroInfo);
                        self:ShowTheBox();
                        self.SetPrefabColor(obj, true);
                    end , nil, "确认", "已觉醒武将卡消耗后不会返还素材卡");
                    return
                end
                self:AddToTheBox(HeroInfo);
                self:ShowTheBox();
            end
        end
    else
        if (alreadyInTheBox == true and DragInTheBox == false) then
            self:RemoveFromTheBox(HeroInfo);
            self:ShowTheBox();
        end
    end
    self.SetPrefabColor(obj, true);
    self._curDragObj.gameObject:SetActive(false);

end


-- 设置预设颜色
function UITactisResearch:SetPrefabColor(obj, mBool)
    if obj == nil then
        return;

    end
    local mImage = { };

    -- mImage = obj.gameObject:GetComponentsInChildren(typeof(UnityEngine.UI.Image));
end

-- 是否在列表中
function UITactisResearch:IfInTheBox(info)
    for k, v in pairs(self._InTheBoxList._list) do
        if v == info then
            return true;
        end
    end
    return false;
end

-- 加入列表
function UITactisResearch:AddToTheBox(info)
    if self._CardInfoList:Count() == 0 then
        return
    end
    if (self._InTheBoxList:Count() >= MaxSize) then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 58);
        return;
    end
    for k, v in pairs(self._InTheBoxList._list) do
        if v == info then
            return;
        end
    end
    if ((LastProgress + self._currentProgress) >= 100) then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 61);
        return;
    end
    self._InTheBoxList:Push(info);
    self:SetIfChecked(info, true);
end

-- 移除列表
function UITactisResearch:RemoveFromTheBox(info)
    for k, v in pairs(self._InTheBoxList._list) do
        if v == info then
            self._InTheBoxList:Remove(info);
            self:SetIfChecked(info, false);
            return;
        end
    end
    if self._myMIx then
        self:GetHeroList()
        self._myMIx:SortingCardList(self._CardInfoList)
        self._myMIx:SetCardChooseState(self._allArmyCampDic)
    end
end

-- 清空列表
function UITactisResearch:ClearIntheBox()
    for k, v in pairs(self._InTheBoxList._list) do
        self:SetIfChecked(v, false);
    end
    self._InTheBoxList:Clear();
end

function UITactisResearch:SetIfChecked(info, checked)
    if self._allHeroCardDic[info.id] ~= nil then
        self._allHeroCardDic[info.id]:SetIfChecked(checked);
    end
end

-- 显示列表
function UITactisResearch:ShowTheBox()
    SkillService:Instance():SetChooseList(self._InTheBoxList);
    local size = self._InTheBoxList:Count();

    local addProgress = 0;
    for i = 1, size do
        self._allArmyCampDic[i].gameObject:SetActive(true);
        local info = self._InTheBoxList:Get(i);
        self._allArmyCampDic[i]:SetHeroCardMessage(info);
        self._allHaveHeroCardDic[self._allArmyCampDic[i].gameObject] = info;
        addProgress = addProgress + self:GetAddProgress(info)
    end

    for i =(size + 1), MaxSize do
        self._allArmyCampDic[i].gameObject:SetActive(false);
    end
    self:SetChooseNum(size);
    self:SetProgress(addProgress);
    self:GetHeroList()
    self._myMIx:SortingCardList(self._CardInfoList)
    self._myMIx:SetCardChooseState(self._allArmyCampDic)
end

-- 获取进度
function UITactisResearch:GetAddProgress(heroinfo)
    local heroId = heroinfo.tableID;
    local herotype = DataHero[heroinfo.tableID].HeroType;
    local herotypes = self._skillLine.ResearchProgressOfHeroClassification;
    local herotypesadd = self._skillLine.ResearchProgressPreClassification;
    local heroids = self._skillLine.ResearchProgressOfHero;
    local heroidsadd = self._skillLine.ResearchProgressPreHero;
    local herotypeCount = #herotype;
    local count1 = #herotypes;
    local count2 = #heroids;
    for index = 1, count1 do
        for index = 1, count2 do
            if (heroids[index] == heroId) then
                return heroidsadd[1] / 100 + heroidsadd[1] / 100 * heroinfo.advancedTime;
            end
        end
        for inde = 1, herotypeCount do
            if (herotypes[index] == herotype[inde]) then
                return herotypesadd[index] / 100 + herotypesadd[index] / 100 * heroinfo.advancedTime;
            end
        end
    end

    return 0;
end

-- 设置显示数量
function UITactisResearch:SetChooseNum(number)
    self._chooseCardsNumLabel.text = number .. "/" .. MaxSize;
    if (number == 0) then
        self._researchBtn.interactable = false;
    else
        self._researchBtn.interactable = true;
    end
end

-- 设置进度
function UITactisResearch:SetProgress(addProgress)
    local less = self._mask.fillAmount
    self._mask.fillAmount =(1 -(addProgress / 100 + self._currentProgress) / 100);
    self._addMask.fillAmount = addProgress / 100;
    -- 增加的进度
    local angel =(self._currentProgress / 100) * 360;
    self._addMask.transform.localEulerAngles = UnityEngine.Vector3(0, 0, - angel);
    self._tipsLabel.text = "增加进度：" .. addProgress .. "%";
    self:ToChangeProgress(addProgress - LastProgress);
    LastProgress = addProgress;

    if addProgress == 0 then
        self._percent.text = math.floor((1 - self._mask.fillAmount + 0.001) * 100) .. "%";
        if math.floor((1 - self._mask.fillAmount + 0.001) * 100) >= 100 then
            self._percent.text = "100%"
            self._addMask.fillAmount = less
        end
    else
        self._percent.text = math.floor((1 - self._mask.fillAmount + 0.001) * 100 + addProgress) .. "%";
        if math.floor((1 - self._mask.fillAmount + 0.001) * 100 + addProgress) >= 100 then
            self._percent.text = "100%"
            self._addMask.fillAmount = less
        end
    end
end

-- 是否在部队中
function UITactisResearch:ifInArmy(info)
    return PlayerService:Instance():CheckCardInArmy(info.id)
end

-- 是否学过
function UITactisResearch:ifLearnSkill(info)
    if (info.allSkillSlotList[2] ~= 0 or info.allSkillSlotList[3] ~= 0) then
        return true
    end
    return false;
end

-- 改变进度特效
function UITactisResearch:ToChangeProgress(addprogress)
    if (addprogress == 0) then
        return;
    end

    if (addprogress > 0) then
        self._percentChangge.text = "<color=#00FF00>" .. addprogress .. "%" .. "</color>";
    else
        self._percentChangge.text = "<color=#FF0000>" .. addprogress .. "%" .. "</color>";
    end
    self._percentChangge.gameObject:SetActive(true);
    ChangeObj = self._percentChangge.gameObject;
    self._percentChangge.transform.localPosition = Vector3.zero;
    local ltDescr = self._percentChangge.transform:DOLocalMove(ChangPosition, 1)
    ltDescr:OnComplete(self, self.ToChangeProgressOver)
end

-- 特效over
function UITactisResearch:ToChangeProgressOver()
    if (ChangeObj) then
        ChangeObj:SetActive(false);
    end
end

-- 是否在保护中
function UITactisResearch:ifprotected(info)
    return info.isProtect;
end

-- 显示特效
function UITactisResearch:ShowEffect()
    self._effectobj.gameObject:SetActive(true);
    Effect = self._effectobj.gameObject;
    local ltDescr = Effect.transform:DOScale(Vector3.one, 1)
    ltDescr:OnComplete(self, self.ShowEffectEnd);
end

-- 显示特效结束
function UITactisResearch:ShowEffectEnd()
    if (Effect) then
        Effect:SetActive(false);
    end

end

-- 是否是j觉醒的卡牌
function UITactisResearch:ifAwake(info)
    return info.isAwaken;
end



return UITactisResearch;