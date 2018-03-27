
local UIBase = require("Game/UI/UIBase")

local UITactisTransExp = class("UITactisTransExp", UIBase)
local UIService = require("Game/UI/UIService")
local UIType = require("Game/UI/UIType")

local HeroCard = require("Game/Hero/HeroCardPart/UIHeroCard");
local DataHero = require("Game/Table/model/DataHero");
local DataHeroStar = require("Game/Table/model/DataHeroStar");
local List = require("common/List");
require("Game/UI/UIMix");
local CurrencyEnum = require("Game/Player/CurrencyEnum");

local ShowChooser = false;
local _chooseObj = nil;
local MaxSize = 10;
local DataGameConfig = require("Game/Table/model/DataGameConfig");
local SkillTransToExp = require("MessageCommon/Msg/C2L/Card/ConversionSkillXP");
local ChangeObj = nil;
local lastaddexp = 0;
local addexp = 0;
local MaxAwafeExp = 99999
local OriginalPosition = UnityEngine.Vector3(120, 0, 0);
local ChangPosition = UnityEngine.Vector3(120, 40, 0);
local ScrollBarPosition = UnityEngine.Vector3(-530, -123, 0);
require("Game/Player/CurrencyEnum");

function UITactisTransExp:ctor()
    UITactisTransExp.super.ctor(self)
    self._backBtn = nil;
    self._tipsBtn = nil;
    self._coinBtn = nil;
    self._jadeBtn = nil;
    self._costCoinLabel = nil;
    self._costJadeLabel = nil;
    self._expNumLabel = nil;
    self._chooseCardsNumLabel = nil;
    self._chooseBtn = nil;
    self._oneClickBtn = nil;
    self._choose1Btn = nil;
    self._choose2Btn = nil;
    self._choose3Btn = nil;
    self._chooseLabel = nil;
    self._choose1Label = nil;
    self._choose2Label = nil;
    self._choose32Label = nil;
    self._bottomObj = nil;
    self._parentObj = nil;
    self._HeroCardUIList = List.new();
    self._HeroObjList = List.new();
    self._InTheBoxList = List.new();
    self._boxTrans = nil;
    self._coinunitcost = nil;
    self._jadeunitcost = nil;
    self._AddBtn = nil;
    self._ownCoin = nil;
    self._ownJade = nil;
    self._percentChangge = nil;
    self._AddExp = nil;
    self._dragIn = true;
    self._curDragSingleDic = { };
    self._tempParent = UnityEngine.GameObject.Find("Canvas").transform;
    self._canvas = self._tempParent.gameObject:GetComponent(typeof(UnityEngine.Canvas));
    self._allHaveHeroCardDic = { };
    -- 对象 info
    self._allHeroCardDic = { };
    -- UIbase id
    self._allArmyCampDic = { };
    self._allBaseData = { }
    self._upDragBase = nil;
    -- Index UIbase
    self._myMIx = nil;
    self._underStar = 1;
    self.OldExp = -1;
    self.ShowSkillPackage = false;
    -- 关闭的时候是否需要打开战法技能背包
    self._CardInfoList = List.new();
    self.cardCountText = nil;
    self.pamp = false;
end

function UITactisTransExp:DoDataExchange()
    self._coinunitcost = DataGameConfig[204].OfficialData;
    self._jadeunitcost = DataGameConfig[205].OfficialData;
    self._backBtn = self:RegisterController(UnityEngine.UI.Button, "BackBtn");
    self._GoldenArrowsImage = self:RegisterController(UnityEngine.UI.Button, "Image (1)/GoldenArrowsImage");
    self._tipsBtn = self:RegisterController(UnityEngine.UI.Button, "TopObj/TactisObj/TipsBtn");
    self._coinBtn = self:RegisterController(UnityEngine.UI.Button, "TopObj/AllBtns/CoinBtn");
    self._jadeBtn = self:RegisterController(UnityEngine.UI.Button, "TopObj/AllBtns/JadeBtn");
    self._costCoinLabel = self:RegisterController(UnityEngine.UI.Text, "TopObj/AllBtns/CoinBtn/CostLabel");
    self._costJadeLabel = self:RegisterController(UnityEngine.UI.Text, "TopObj/AllBtns/JadeBtn/CostLabel");
    self._expNumLabel = self:RegisterController(UnityEngine.UI.Text, "TopObj/TactisObj/Bg/OwnCount");
    self._chooseCardsNumLabel = self:RegisterController(UnityEngine.UI.Text, "TopObj/AddCardsObj/Panel/AcrossHeadlineS2/ChooseCardsCount");
    self._bottomObj = self:RegisterController(UnityEngine.Transform, "BottomObj/SVParent");
    self._boxTrans = self:RegisterController(UnityEngine.Transform, "TopObj/AddCardsObj/Panel");
    -- self._tempParent = self:RegisterController(UnityEngine.Transform,"TopObj/AddCardsObj/Panel/TempParent");
    self._parentObj = self:RegisterController(UnityEngine.Transform, "TopObj/AddCardsObj/Panel/ParentObj");
    self._chooseBtn = self:RegisterController(UnityEngine.UI.Button, "BottomObj/ChooseBtn");
    self._oneClickBtn = self:RegisterController(UnityEngine.UI.Button, "BottomObj/ChooseBtn/OneClickBtn");
    self._choose1Btn = self:RegisterController(UnityEngine.UI.Button, "BottomObj/ChooseBtn/AllChooser/chooser1");
    self._choose2Btn = self:RegisterController(UnityEngine.UI.Button, "BottomObj/ChooseBtn/AllChooser/chooser2");
    self._choose3Btn = self:RegisterController(UnityEngine.UI.Button, "BottomObj/ChooseBtn/AllChooser/chooser3");
    self._chooseLabel = self:RegisterController(UnityEngine.UI.Text, "BottomObj/ChooseBtn/ChooseBtnLabel");
    self._choose1Label = self:RegisterController(UnityEngine.UI.Text, "BottomObj/ChooseBtn/AllChooser/chooser1/ChooserLabel");
    self._choose2Label = self:RegisterController(UnityEngine.UI.Text, "BottomObj/ChooseBtn/AllChooser/chooser2/ChooserLabel");
    self._choose3Label = self:RegisterController(UnityEngine.UI.Text, "BottomObj/ChooseBtn/AllChooser/chooser3/ChooserLabel");
    self._AddBtn = self:RegisterController(UnityEngine.UI.Button, "BottomObj/AddBtn");
    self._ownCoin = self:RegisterController(UnityEngine.UI.Text, "BottomObj/CoinImage/CoinCount");
    self._ownJade = self:RegisterController(UnityEngine.UI.Text, "BottomObj/JadeImage/JadeCount");
    _chooseObj = self:RegisterController(UnityEngine.Transform, "BottomObj/ChooseBtn/AllChooser");
    self._percentChangge = self:RegisterController(UnityEngine.UI.Text, "TopObj/TactisObj/Bg/PercentChangge");
    self._AddExp = self:RegisterController(UnityEngine.UI.Text, "TopObj/TactisObj/Bg/AddExp");
    self.particle = self:RegisterController(UnityEngine.Transform, "particle");

    self.GaryPic = self:RegisterController(UnityEngine.Transform, "TopObj/AllBtns/CoinBtn/TonYonButtonNormal2Grey");
    self.GaryPic1 = self:RegisterController(UnityEngine.Transform, "TopObj/AllBtns/JadeBtn/TonYonButtonNormal2Grey1");

end

-- 注册所有的事件
function UITactisTransExp:RegisterAllNotice()
    self:RegisterNotice(L2C_Player.SynchronizeWarfare, self.RefreshExp);
    self:RegisterNotice(L2C_Card.RemoveCard, self.RefreshHeroCard);
    self:RegisterNotice(L2C_Player.SyncGold, self.UpdateMoney);
    self:RegisterNotice(L2C_Player.SyncJade, self.UpdateJade);
    self:RegisterNotice(L2C_Player.RefreshCurrencyInfo, self.UpdateRescouce);
    self:RegisterNotice(L2C_Card.OneCardProperty, self.RefreshHeroCard);
end

-- 刷新战法经验
function UITactisTransExp:RefreshExp()
    local newExp = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Warfare):GetValue();
    local changeNum = SkillService:Instance():GetChangeNum()
    -- print(newExp .. "||" .. changeNum)
    if changeNum ~= 0 and changeNum < newExp then
        self:PlayParticle()
        CommonService:Instance():Play("Audio/ChangeEXp")
    else
        CommonService:Instance():Play("Audio/ChangeExpMoer")
        SkillService:Instance():SetChangeNum(0)
    end
    self._expNumLabel.text = tostring(newExp);
    self:ClearIntheBox();
    if (self.OldExp >= 0) and changeNum ~= 0 then
        self:ToChangeProgress(newExp - self.OldExp);
    end
    self.OldExp = newExp;
    self:ShowTheBox(false);
end

-- 播放暴击特效
function UITactisTransExp:PlayParticle()
    self.particle.gameObject:SetActive(true)
    local pos = self.particle.localPosition;
    local targetPos = pos + Vector3.up * 40;
    local ltDescrAddPiont = self.particle.transform:DOLocalMove(targetPos, 1)
    ltDescrAddPiont:OnComplete(self, function()
        self.particle.gameObject:SetActive(false)
        self.particle.localPosition = pos
        SkillService:Instance():SetChangeNum(0)
    end )
end


-- 更新资源
function UITactisTransExp:UpdateRescouce()
    self:UpdateMoney();
    self:UpdateJade();
end

-- 更新金币
function UITactisTransExp:UpdateMoney()
    local haveGold = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Money):GetValue();
    self._ownCoin.text = CommonService:Instance():GetResourceCount(haveGold);
end

-- 更新玉石
function UITactisTransExp:UpdateJade()
    self._ownJade.text = tostring(PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Jade):GetValue());
end

-- 卡牌状态更新 刷新列表
function UITactisTransExp:UpdateCard()
    local count = self._InTheBoxList:Count();
    for index = 1, count do
        local info = self._InTheBoxList:Get(index);
        if (info ~= nil and info.isProtect == true) then
            self:RemoveFromTheBox(info)
        end
    end
    self:ShowTheBox(true);
end

-- 刷新卡牌
function UITactisTransExp:RefreshHeroCard()
    -- self:OnShow();

    self:GetAllHeroList();
    -- self:RefreshUIShow();
    self._myMIx:MakeScrollDrag(self._CardInfoList, self._bottomObj, true, ScrollBarPosition);
    self:UpdateCard();

end

function UITactisTransExp:DoEventAdd()
    self:AddListener(self._backBtn, self.OnClickBackBtn);
    self:AddListener(self._GoldenArrowsImage, self.OnClickGoToRecruitBtn);
    self:AddListener(self._tipsBtn, self.OnClickTipsBtn);
    self:AddListener(self._coinBtn, self.OnClickCoinBtn);
    self:AddListener(self._jadeBtn, self.OnClickJadeBtn);
    self:AddListener(self._chooseBtn, self.OnClickChooseBtn);
    self:AddListener(self._oneClickBtn, self.OnClickOneClickBtn);
    self:AddListener(self._choose1Btn, self.OnClickChoose1Btn);
    self:AddListener(self._choose2Btn, self.OnClickChoose2Btn);
    self:AddListener(self._choose3Btn, self.OnClickChoose3Btn);
    self:AddListener(self._AddBtn, self.OnClickAddBtn);
    self:InitArmyCamp();
end

-- 点击关闭按钮
function UITactisTransExp:OnClickBackBtn()
    self._InTheBoxList:Clear();
    SkillService:Instance():SetChooseList(self._InTheBoxList);
    UIService:Instance():HideUI(UIType.UITactisTransExp);
    if (self.ShowSkillPackage) then
        UIService:Instance():ShowUI(UIType.UITactis)
    else
        if UIService:Instance():GetOpenedUI(UIType.ArmyFunctionUI) then
        else
            UIService:Instance():ShowUI(UIType.UIGameMainView)
        end
    end
    SkillService:Instance():SetChangeNum(0)
end


function UITactisTransExp:ReturnSkillExp(card)

    local firstSkillLv = card:GetSkillLevel(1);
    local secondSkillLv = card:GetSkillLevel(2);
    local thirdSkillLv = card:GetSkillLevel(3);
    local upSkillLvCostTactics = 0;
    if card:GetSkill(1) ~= nil then
        local dataFirstSkill = DataSkill[card:GetSkill(1)]
        for i = 1, firstSkillLv - 1 do
            upSkillLvCostTactics = upSkillLvCostTactics + dataFirstSkill.SkillUpNeedExp[i];
        end
    end
    if card:GetSkill(2) ~= nil then
        local dataSecondSkill = DataSkill[card:GetSkill(2)]
        for i = 1, secondSkillLv - 1 do
            upSkillLvCostTactics = upSkillLvCostTactics + dataSecondSkill.SkillUpNeedExp[i];
        end
    end
    if card:GetSkill(3) ~= nil then
        local dataThirdSkill = DataSkill[card:GetSkill(3)]
        for i = 1, thirdSkillLv - 1 do
            upSkillLvCostTactics = upSkillLvCostTactics + dataThirdSkill.SkillUpNeedExp[i];
        end
    end
    upSkillLvCostTactics = math.floor(upSkillLvCostTactics * 0.8);
    return upSkillLvCostTactics;

end

function UITactisTransExp:OnClickGoToRecruitBtn()
    -- print("OnClickGoToRecruitBtn")
    UIService:Instance():ShowUI(UIType.UIRecruitUI);
    self._InTheBoxList:Clear();
    SkillService:Instance():SetChooseList(self._InTheBoxList);
    UIService:Instance():HideUI(UIType.UITactisTransExp);
    UIService:Instance():HideUI(UIType.UITactis);
    UIService:Instance():HideUI(UIType.UIHeroCardPackage);

end

-- 点击提示按钮
function UITactisTransExp:OnClickTipsBtn()
    self.temp = { };
    self.temp[1] = "说明"
    self.temp[2] = "转化初始战法强化过的武将卡可返还:80%战法经验\n转化进阶过的武将卡可返还:该武将卡进阶数*基础战法经验\n消耗已觉醒的武将卡不会返还素材卡";
    UIService:Instance():ShowUI(UIType.UICommonTipSmall, self.temp)
end

-- 点击金币转换
function UITactisTransExp:OnClickCoinBtn()
    self:SendMsgToTransExp(CurrencyEnum.Money);
end

-- 点击玉石转换
function UITactisTransExp:OnClickJadeBtn()
    self:SendMsgToTransExp(CurrencyEnum.Jade);
end

-- 发送转换战法的消息
function UITactisTransExp:SendMsgToTransExp(args)
    local num = 0;
    local count = self._InTheBoxList:Count();
    local msg = SkillTransToExp.new();
    msg:SetMessageId(C2L_Card.ConversionSkillXP);
    msg.costType = args;
    for i = 1, count do
        msg.cards:Push(self._InTheBoxList:Get(i).id);
        if self._InTheBoxList:Get(i).star == 1 then
            num = num + 3 *(self._InTheBoxList:Get(i).advancedTime + 1)
        end
        if self._InTheBoxList:Get(i).star == 2 then
            num = num + 6 *(self._InTheBoxList:Get(i).advancedTime + 1)
        end
        if self._InTheBoxList:Get(i).star == 3 then
            num = num + 12 *(self._InTheBoxList:Get(i).advancedTime + 1)
        end
        if self._InTheBoxList:Get(i).star == 4 then
            num = num + 24 *(self._InTheBoxList:Get(i).advancedTime + 1)
        end
        if self._InTheBoxList:Get(i).star == 5 then
            num = num + 48 *(self._InTheBoxList:Get(i).advancedTime + 1)
        end
    end
    if args == CurrencyEnum.Jade then
        num = num * 2
    end

    for i = 1, count do
        num = num + self:ReturnSkillExp(self._InTheBoxList:Get(i))
    end

    SkillService:Instance():SetChangeNum(num + PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Warfare):GetValue())
    if num + PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Warfare):GetValue() > MaxAwafeExp then
        CommonService:Instance():ShowOkOrCancle(self, function()
            NetService:Instance():SendMessage(msg);
        end , nil, "确认", "继续转化战法经验会超出上限，超出的部分将会消失\n确认要继续转化战法经验吗？ ");
        return
    end
    NetService:Instance():SendMessage(msg);
end

--- 一键按钮
function UITactisTransExp:OnClickOneClickBtn()
    if (self._InTheBoxList:Count() == MaxSize) then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 58);
        return;
    end
    local count = self._InTheBoxList:Count()
    local canaddcard = false;
    for index = 1, self._CardInfoList:Count() do
        local info = self._CardInfoList:Get(index);
        if (DataHero[info.tableID] and self:ifInArmy(info) == false and self:ifLearnSkill(info) == false and self:ifprotected(info) == false and(DataHero[info.tableID]).Star <= self._underStar and self._InTheBoxList:Count() < MaxSize) and self:ifAwake(info) == false then
            self:AddToTheBox(info);
            if count ~= self._InTheBoxList:Count() then
                canaddcard = true;
            end
        end
    end
    if (canaddcard) then
        self:ShowTheBox(true);
    else
        if (self._InTheBoxList:Count() == MaxSize) then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, 58);
        else
            UIService:Instance():ShowUI(UIType.UICueMessageBox, 60);
        end
    end
end

-- 选择按钮
function UITactisTransExp:OnClickChooseBtn()
    if (ShowChooser) then
        ShowChooser = false;
        _chooseObj.gameObject:SetActive(ShowChooser);
    else
        ShowChooser = true;
        _chooseObj.gameObject:SetActive(ShowChooser);
    end
end

-- 选择按钮1
function UITactisTransExp:OnClickChoose1Btn()
    self.OnClickChooseBtn();
    self._chooseLabel.text = self._choose1Label.text;
    self._underStar = 1;
end

-- 选择按钮2
function UITactisTransExp:OnClickChoose2Btn()
    self.OnClickChooseBtn();
    self._chooseLabel.text = self._choose2Label.text;
    self._underStar = 2;
end

-- 选择按钮3
function UITactisTransExp:OnClickChoose3Btn()
    self.OnClickChooseBtn();
    self._chooseLabel.text = self._choose3Label.text;
    self._underStar = 3;
end

-- 加钱
function UITactisTransExp:OnClickAddBtn()
    UIService:Instance():ShowUI(UIType.RechargeUI);
end

-- 初始化所有卡牌列表
function UITactisTransExp:GetAllHeroList()
    self._CardInfoList:Clear();
    local count = HeroService:Instance():GetOwnHeroCount();
    for i = 1, count do
        self._CardInfoList:Push(HeroService:Instance():GetOwnHeroes(count + 1 - i));
    end
    self._CardInfoList = self:Sort(self._CardInfoList)
end

-- 获取打开时是否从战法背包页面
function UITactisTransExp:GetPamp()
    return self.pamp
end



-- override
function UITactisTransExp:OnShow(pamp)
    self.pamp = pamp
    if (pamp ~= nil and pamp == true) then
        self.ShowSkillPackage = true
    else
        self.ShowSkillPackage = false;
    end
    ShowChooser = false;
    lastaddexp = 0;
    addexp = 0;
    _chooseObj.gameObject:SetActive(false);
    self._AddExp.gameObject:SetActive(false);
    self._chooseLabel.text = self._choose1Label.text;
    self._underStar = 1;
    self:GetAllHeroList();
    self:RefreshUIShow();

    if self._myMIx == nil then
        local mMix = UIMix.new();
        -- mMix:SetLoadCallBack(function ()  self:LoadCallBack() end);

        mMix:SetLoadCallBack( function(obj)
            self.downPart = obj;
            self._myMIx = mMix;
            mMix:ScrollOnUpCB( function() self:OnMouseUp() end);
            mMix:ScrollOnClickCB( function(go, eventData) self:OnMouseClick(go, eventData) end);
            mMix:ScrollOnDownCB( function() self:OnMouseDown() end);
            mMix:SetPostionObj(self.gameObject)
            mMix:SetChooseBtn(false);
            obj:SetActive(true)
        end );
        mMix:MakeScrollDrag(self._CardInfoList, self._bottomObj, true, ScrollBarPosition);
        self._myMIx:GetDownPart().gameObject.transform.localPosition = Vector3.New(0, 80, 0);
    else
        self._myMIx:GetDownPart().gameObject.transform.localPosition = Vector3.New(0, 80, 0);
        self._myMIx:MakeScrollDrag(self._CardInfoList, self._bottomObj, true, ScrollBarPosition);
    end
    self:ClearIntheBox();
    self:ShowTheBox(true);
    self:RefreshExp();
    self:SetMoney();
    self.cardCountText = self.downPart.transform:Find("CardCountText"):GetComponent(typeof(UnityEngine.UI.Text));
    self.cardCountText.text = self._CardInfoList:Count() .. "/" .. HeroService:Instance():GetCardMaxLimit()
end

-- 设置金钱和玉石
function UITactisTransExp:SetMoney()
    local haveGold = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Money):GetValue();
    self._ownCoin.text = CommonService:Instance():GetResourceCount(haveGold);
    self._ownJade.text = tostring(PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Jade):GetValue());
end

-- 初始化 添加卡牌并隐藏
function UITactisTransExp:InitArmyCamp()
    for index = 1, MaxSize do
        if self._allArmyCampDic[index] == nil then
            local mdata = DataUIConfig[UIType.UIHeroCard];
            local uiBase = require(mdata.ClassName).new();
            GameResFactory.Instance():GetUIPrefab(mdata.ResourcePath, self._parentObj.transform, uiBase, function(go)
                uiBase:Init();
                if uiBase.gameObject then
                    self:AddOnDown(uiBase.gameObject, self.OnDownStartBtn);
                    self:AddOnUp(uiBase.gameObject, self.OnUpStartBtn);
                    self:AddOnClick(uiBase.gameObject, self.OnClickHeroBtn);
                    self:AddOnDrag(uiBase.gameObject, self.OnDragStartBtn);
                    self._allArmyCampDic[index] = uiBase;
                    self._allBaseData[uiBase.gameObject] = uiBase;
                    uiBase.gameObject:SetActive(false);
                end
            end );
        end
    end
end

-- 在已选择的卡牌中点击
function UITactisTransExp:OnClickHeroBtn(obj, eventData)
    if self._allHaveHeroCardDic[self._BeDragObj] then
        HeroService:Instance():ShowHeroInfoUI(self._allHaveHeroCardDic[self._BeDragObj].id);
    end
end

-- 滑动列表中卡牌点击
function UITactisTransExp:OnMouseClick(go, eventData)
    if self._BeDragData then
        HeroService:Instance():ShowHeroInfoUI(self._BeDragData.id);
    end
end

-- 按下执行方法
function UITactisTransExp:OnDownStartBtn(obj, eventData)
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

        GameResFactory.Instance():GetUIPrefab(mdata.ResourcePath, self._tempParent, uiBase, function(go)
            uiBase:Init();
            uiBase:SetHeroCardMessage(self._BeDragData);
            self._curDragObj = uiBase.gameObject;
            self._curDragBase = uiBase;
            self._curDragObj.transform.position = eventData.position;
            self:AddOnUp(self._curDragObj.gameObject, self.OnUpStartBtn);
            self:AddOnDrag(self._curDragObj.gameObject, self.OnDragStartBtn);

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

-- 拖动执行方法
function UITactisTransExp:OnDragStartBtn(obj, eventData)


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
    self._myMIx:SetCardChooseState(self._allArmyCampDic)
    if self._upDragBase then
        self._upDragBase:SetCardAlpha(false)
    end
end


-- 刷新显示
function UITactisTransExp:RefreshUIShow()

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

-- 设置每一个卡牌
function UITactisTransExp:SetSingleHeroCardData(mHeroCard, heroCard)
    mHeroCard:SetHeroCardMessage(heroCard);
    self._allHeroCardDic[heroCard.id] = mHeroCard;
    self._allHaveHeroCardDic[mHeroCard.gameObject] = heroCard;
end

-- 抬起手指回调
function UITactisTransExp:OnMouseUp(go, eventData)

    self._BeDragObj = self._myMIx:GetBeDragObj();
    self._localPointerPosition = self._myMIx:Get_localPointerPosition();
    if self._localPointerPosition then
    end
    if self._curDragObj then
        self:OnUpStartBtn(self._curDragObj.gameObject, eventData);
    end
    self._myMIx:SortingCardList(self._CardInfoList)
    self._myMIx:SetCardChooseState(self._allArmyCampDic)
end

-- 按下
function UITactisTransExp:OnMouseDown(go, eventData)
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

-- 抬起
function UITactisTransExp:OnUpStartBtn(obj, eventData)
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
    if self._upDragBase then
        self._upDragBase:SetCardAlpha(true)
    end
    local vecTemp = self._boxTrans.position;
    -- self._boxTrans.localPosition;
    local fWidth = self._boxTrans.gameObject:GetComponent(typeof(UnityEngine.RectTransform)).rect.width / 2;
    local fHeight = self._boxTrans.gameObject:GetComponent(typeof(UnityEngine.RectTransform)).rect.height / 2;
    local vecTemp2 = self._curDragObj.transform.position;
    local HeroInfo = self._BeDragData;
    if (HeroInfo == nil) then
        return;
    end
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
                local isAwake = self:ifAwake(HeroInfo)
                if isAwake then
                    self._curDragObj.gameObject:SetActive(false);
                    CommonService:Instance():ShowOkOrCancle(self, function()
                        self:AddToTheBox(HeroInfo);
                        self:ShowTheBox(true);
                        self.SetPrefabColor(obj, true);
                        self._myMIx:SortingCardList(self._CardInfoList)
                        self._myMIx:SetCardChooseState(self._allArmyCampDic)
                    end , nil, "确认", "已觉醒武将卡消耗后不会返还素材卡");
                    return
                end
                self:AddToTheBox(HeroInfo);
                self:ShowTheBox(true);
            end
        end
    else
        if (alreadyInTheBox == true and DragInTheBox == false) then
            self:RemoveFromTheBox(HeroInfo);
            self:ShowTheBox(true);
        end
    end
    self.SetPrefabColor(obj, true);
    self._curDragObj.gameObject:SetActive(false);
    self._myMIx:SortingCardList(self._CardInfoList)
    self._myMIx:SetCardChooseState(self._allArmyCampDic)
end



-- 设置预设颜色
function UITactisTransExp:SetPrefabColor(obj, mBool)
    if obj == nil then
        return;
    end
    local mImage = { };
end

-- 判断是否已经选择在列表中
function UITactisTransExp:IfInTheBox(info)
    for k, v in pairs(self._InTheBoxList._list) do
        if v == info then
            return true;
        end
    end
    return false;
end

-- 加入列表
function UITactisTransExp:AddToTheBox(info)
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
    self._InTheBoxList:Push(info);
    self:SetIfChecked(info, true);
end

-- 从列表中移除
function UITactisTransExp:RemoveFromTheBox(info)
    for k, v in pairs(self._InTheBoxList._list) do
        if v == info then
            self._InTheBoxList:Remove(info);
            self:SetIfChecked(info, false);
            return;
        end
    end
    self._myMIx:SortingCardList(self._CardInfoList)
    self._myMIx:SetCardChooseState(self._allArmyCampDic)
end

-- 清空列表
function UITactisTransExp:ClearIntheBox()
    for k, v in pairs(self._InTheBoxList._list) do
        self:SetIfChecked(v, false);
    end
    self._InTheBoxList:Clear();
end

-- 显示列表
function UITactisTransExp:ShowTheBox(ShowChangeAnimation)
    SkillService:Instance():SetChooseList(self._InTheBoxList);
    local size = self._InTheBoxList:Count();
    addexp = 0;
    for i = 1, size do
        self._allArmyCampDic[i].gameObject:SetActive(true);
        local info = self._InTheBoxList:Get(i);
        self._allArmyCampDic[i]:SetHeroCardMessage(info);
        self._allHaveHeroCardDic[self._allArmyCampDic[i].gameObject] = info;
        if (DataHero[info.tableID]) then
            addexp = addexp + self:GetExpByStar((DataHero[info.tableID]).Star) *(info.advancedTime + 1) + self:ReturnSkillExp(info);
        end
    end

    for i =(size + 1), MaxSize do
        self._allArmyCampDic[i].gameObject:SetActive(false);
    end

    local num = 0;
    local cardNum = 0;
    for k, v in pairs(self._InTheBoxList._list) do
        num = num + 1 + v.advancedTime;
    end

    if self._InTheBoxList:Count() > 0 then
        self.GaryPic.gameObject:SetActive(false)
        self.GaryPic1.gameObject:SetActive(false)
    else
        self.GaryPic.gameObject:SetActive(true)
        self.GaryPic1.gameObject:SetActive(true)
    end

    self:SetChooseNum(self._InTheBoxList:Count());
    if (addexp == 0) then
        self._percentChangge.text = "";
    else
        self._percentChangge.text = "+" .. addexp;
    end
    if (ShowChangeAnimation ~= nil and ShowChangeAnimation == true) then
        self:ToChangeProgress(addexp - lastaddexp);
    end
    lastaddexp = addexp;
    self._myMIx:SortingCardList(self._CardInfoList)
    self._myMIx:SetCardChooseState(self._allArmyCampDic)
end

-- 获取可以增加的经验
function UITactisTransExp:GetExpByStar(star)
    if star == nil then
        return 0;
    end
    for id = 1, #DataHeroStar do
        if (DataHeroStar[id].Star == star) then
            return DataHeroStar[id].ExchangeSkillXP;
        end
    end
    return 0;
end

-- 显示选中的列表个数
function UITactisTransExp:SetChooseNum(number)
    self._chooseCardsNumLabel.text = number .. "/" .. MaxSize;
    local costcoin = number * self._coinunitcost;
    local costjade = number * self._jadeunitcost;
    self._costCoinLabel.text = tostring(costcoin);
    self._costJadeLabel.text = tostring(costjade);
    if (number == 0) then
        self._coinBtn.interactable = false;
        self._jadeBtn.interactable = false;
    else
        if (PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Money):GetValue() < costcoin) then
            self._coinBtn.interactable = false;
        else
            self._coinBtn.interactable = true;
        end
        if (PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Jade):GetValue() < costjade) then
            self._jadeBtn.interactable = false;
        else
            self._jadeBtn.interactable = true;
        end
    end
end

-- 是否选中
function UITactisTransExp:SetIfChecked(info, checked)
    if self._allHeroCardDic[info.id] ~= nil then
        self._allHeroCardDic[info.id]:SetIfChecked(checked);
    end
end

-- 是否在部队中
function UITactisTransExp:ifInArmy(info)
    return PlayerService:Instance():CheckCardInArmy(info.id)
end

-- 是否学习过技能
function UITactisTransExp:ifLearnSkill(info)
    if (info == nil or info.allSkillSlotList[2] ~= 0 or info.allSkillSlotList[3] ~= 0) then
        return true
    end
    return false;
end


-- 改变经验动画特效
function UITactisTransExp:ToChangeProgress(addprogress)
    if (addprogress == 0) then
        return;
    end
    self._AddExp.gameObject:SetActive(true);
    if (addprogress > 0) then
        self._AddExp.text = "<color=#00FF00>+" .. addprogress .. "</color>";
    else
        self._AddExp.text = "<color=#FF0000>" .. addprogress .. "</color>";
    end
    ChangeObj = self._AddExp.gameObject;
    self._AddExp.transform.localPosition = OriginalPosition;
    self.cardCountText.text = self._CardInfoList:Count() .. "/" .. HeroService:Instance():GetCardMaxLimit()
    local ltDescr = self._AddExp.transform:DOLocalMove(ChangPosition, 1)
    ltDescr:OnComplete(self, self.ToChangeProgressOver);
end

-- 动画显示完
function UITactisTransExp:ToChangeProgressOver()
    if (ChangeObj) then
        ChangeObj:SetActive(false);
    end
end

-- 是否是保护中的卡牌
function UITactisTransExp:ifprotected(info)
    return info.isProtect;
end

-- 是否是j觉醒的卡牌
function UITactisTransExp:ifAwake(info)
    return info.isAwaken;
end


function UITactisTransExp:Sort(list)
    local Other = HeroService:Instance():sorting(HeroSortType.rarityDown, list);
    return Other
end

return UITactisTransExp;