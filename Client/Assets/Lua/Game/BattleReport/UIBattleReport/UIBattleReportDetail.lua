--[[游戏主界面]]

local UIBase= require("Game/UI/UIBase");
local UIService=require("Game/UI/UIService");
local UIBattleReportDetail=class("UIBattleReportDetail",UIBase);
local List = require("common/List");
local UIBattleReportRound = require("Game/BattleReport/UIBattleReport/UIBattleReportRound");
local UIType=require("Game/UI/UIType");
local UIConfigTable=require("Game/Table/model/DataUIConfig");
local ArmySlotType = require("Game/Army/ArmySlotType");
local ShareBattleReport = require("MessageCommon/Msg/C2L/BattleReport/ShareBattleReport");
local BattleResultType =  require("Game/BattleReport/BattleResultType");
local BattleReportType = require("Game/BattleReport/BattleReportType");
local HeroData = require("Game/Table/model/DataHero");

local bigSize = Vector3.New(2, 2, 1); --战平的缩放大小

function UIBattleReportDetail:ctor()
    UIBattleReportDetail.super.ctor(self)
    self.info = nil;
    self.Detailinfo = nil;
    self.backBtn = nil;
    self.AddressBtn = nil;
    self.countBtn = nil;
    self.SendToChatBtn = nil;
    self.gridParent = nil;
    self._AllItemList = List.new();
    self.UIBattleReportRoundPrefab = UIConfigTable[UIType.UIBattleReportRound].ResourcePath;
    self.OurPartSlider = nil;
    self.EnemySlider = nil;
    self.OurPartArmNum = nil;
    self.EnemyArmNum = nil;
    self.OurPartAttackType = nil;
    self.EnemyAttackType = nil;
    self.OurPartName = nil;
    self.EnemyName = nil;
    self.OurPartAllianceName = nil;
    self.EnemyAllianceName = nil;
    self._layout = nil;
    self.result = nil;
    self.OurPartCardsParent = nil;
    self.EnemyCardsParent = nil;
    self.DragSlider = nil;
    self.AttackLeft = 0;
    self.DefenceLeft = 0;
    self.OurPartCards = {};
    self.EnemyCards = {};
    self.OurWoundNum = {};
    self.OtherWoundNum = {};
    self.OurLeftNum = {};
    self.OtherLeftNum = {};
    self.index = 0;
end

--注册控件
function UIBattleReportDetail:DoDataExchange()
    self.backBtn = self:RegisterController(UnityEngine.UI.Button,"detailBackBtn")
    self.AddressBtn = self:RegisterController(UnityEngine.UI.Button,"ScrolObj/ScrollView/Layout/Grid/AddressBtn")
    self.countBtn = self:RegisterController(UnityEngine.UI.Button,"ScrolObj/ScrollView/Layout/Grid/countBtn")
    self.SendToChatBtn = self:RegisterController(UnityEngine.UI.Button,"ScrolObj/ScrollView/Layout/Grid/SendToChatBtn")
    self.gridParent = self:RegisterController(UnityEngine.Transform,"ScrolObj/ScrollView/Layout/Grid")
    self.OurPartSlider = self:RegisterController(UnityEngine.UI.Slider,"ScrolObj/ScrollView/Layout/Parent/OurPart/Slider")
    self.EnemySlider = self:RegisterController(UnityEngine.UI.Slider,"ScrolObj/ScrollView/Layout/Parent/Enemy/Slider")
    self.OurPartArmNum = self:RegisterController(UnityEngine.UI.Text,"ScrolObj/ScrollView/Layout/Parent/OurPart/ArmNum")
    self.EnemyArmNum = self:RegisterController(UnityEngine.UI.Text,"ScrolObj/ScrollView/Layout/Parent/Enemy/ArmNum")
    self.OurPartAttackType = self:RegisterController(UnityEngine.UI.Image,"ScrolObj/ScrollView/Layout/Parent/OurPart/bg")
    self.EnemyAttackType = self:RegisterController(UnityEngine.UI.Image,"ScrolObj/ScrollView/Layout/Parent/Enemy/bg")
    self.OurPartName = self:RegisterController(UnityEngine.UI.Text,"ScrolObj/ScrollView/Layout/Parent/OurPart/nameobj/Text")
    self.EnemyName = self:RegisterController(UnityEngine.UI.Text,"ScrolObj/ScrollView/Layout/Parent/Enemy/nameobj/Text")
    self.OurPartAllianceName = self:RegisterController(UnityEngine.UI.Text,"ScrolObj/ScrollView/Layout/Parent/OurPart/AllianceObj/Text")
    self.EnemyAllianceName = self:RegisterController(UnityEngine.UI.Text,"ScrolObj/ScrollView/Layout/Parent/Enemy/AllianceObj/Text")
    self._layout = self:RegisterController(UnityEngine.Transform,"ScrolObj/ScrollView/Layout")
    self.result = self:RegisterController(UnityEngine.UI.Image,"ScrolObj/ScrollView/Layout/Parent/result")
    self.OurPartCardsParent = self:RegisterController(UnityEngine.Transform,"ScrolObj/ScrollView/Layout/Parent/OurPart/Cards")
    self.EnemyCardsParent = self:RegisterController(UnityEngine.Transform,"ScrolObj/ScrollView/Layout/Parent/Enemy/Cards")
    self.DragSlider = self:RegisterController(UnityEngine.UI.Scrollbar,"ScrolObj/Scrollbar")
end

--注册控件点击事件
function UIBattleReportDetail:DoEventAdd()
    self:AddListener(self.backBtn,self.OnClickbackBtn)
    self:AddListener(self.AddressBtn,self.OnClickAddressBtn)
    self:AddListener(self.countBtn,self.OnClickcountBtn)
    self:AddListener(self.SendToChatBtn,self.OnClickSendToChatBtn)
end

--初始化是个人战报
function UIBattleReportDetail:OnShow(pamp)
    --print(debug.traceback());
   
    self.AttackLeft = 0;
    self.DefenceLeft = 0;
    self.OurWoundNum = {};
    self.OtherWoundNum = {};
    self.OurLeftNum = {};
    self.OtherLeftNum = {};
    self.info = pamp[1]
    self.Detailinfo = pamp[2]
    self.index = pamp[3]
    local line = HeroData[self.Detailinfo.BeforeRound:Get(1).CardID];
    if(line == nil) then
        self.countBtn.gameObject:SetActive(false);
    else
        self.countBtn.gameObject:SetActive(true);
    end
    BattleReportService:Instance():SetCurrentDetailInfo(self.Detailinfo)
    self:SetAllFalse();
    self:InitLeftNum();
    if(self.info._battleType == BattleReportType.Defence) then
        self:SetLeftArmySlider(self.AttackLeft,self.info._dTroopNum,self.OurPartArmNum,self.OurPartSlider); --测试数据
        self:SetLeftArmySlider(self.DefenceLeft,self.info._aTroopNum,self.EnemyArmNum,self.EnemySlider);--测试数据
        self.EnemyAttackType.sprite = GameResFactory.Instance():GetResSprite("attackSign");
        self.OurPartAttackType.sprite = GameResFactory.Instance():GetResSprite("defendSign");
    else
        self:SetLeftArmySlider(self.AttackLeft,self.info._aTroopNum,self.OurPartArmNum,self.OurPartSlider); --测试数据
        self:SetLeftArmySlider(self.DefenceLeft,self.info._dTroopNum,self.EnemyArmNum,self.EnemySlider);--测试数据
        self.OurPartAttackType.sprite = GameResFactory.Instance():GetResSprite("attackSign");
        self.EnemyAttackType.sprite = GameResFactory.Instance():GetResSprite("defendSign");
    end
    self:setResult();   
    self:AddCards();
    
    self:SetAttackAndDefender();
    self:SetPreparatoryStage();
    self:SetRound();
    self:ResetScrollRect();
    if GuideServcice:Instance():GetIsFinishGuide() == false then
        GuideServcice:Instance():GoToNextStep();
    end

    if pamp[4] ~= nil or PlayerService:Instance():GetLeagueId() == 0 then
        self.SendToChatBtn.gameObject:SetActive(false);
    else
        self.SendToChatBtn.gameObject:SetActive(true);
    end
end

--点击关闭按钮逻辑
function UIBattleReportDetail:OnClickbackBtn()
    UIService:Instance():HideUI(UIType.UIBattleReportDetail)
    BattleReportService:Instance():SetCurrentDetailInfo(nil)
end

function UIBattleReportDetail:ResetScrollRect()
    self.DragSlider.value = 1;
    self.DragSlider.size = 0;
    self.DragSlider.value = math.abs(self.DragSlider.value - 0.0001);
    self._layout.localPosition = Vector3.zero;
end

function UIBattleReportDetail:OnClickAddressBtn()
    local x, y = MapService:Instance():GetTiledCoordinate(self.info._tileIndex)
    self.temp = {};
    self.temp[1] = "是否跳转到坐标<color=#599ba9>("..x..","..y..")</color>";
    self.temp[2] = self;
    self.temp[3] = self.ConfirmGoto;
    UIService:Instance():ShowUI(UIType.CommonGoToPosition,self.temp)
end

--确定跳转
function UIBattleReportDetail:ConfirmGoto()
   local baseClass1 = UIService:Instance():GetUIClass(UIType.UIChat);
    local isopen1 = UIService:Instance():GetOpenedUI(UIType.UIChat);
    if baseClass1 ~= nil and isopen1 == true then
        UIService:Instance():HideUI(UIType.UIChat);
    end
      local baseClass2 = UIService:Instance():GetUIClass(UIType.LeagueExistUI);
    local isopen2 = UIService:Instance():GetOpenedUI(UIType.LeagueExistUI);
    if baseClass2 ~= nil and isopen2 == true then
        UIService:Instance():HideUI(UIType.LeagueExistUI);
    end
   UIService:Instance():HideUI(UIType.UIBattleReport)
   UIService:Instance():HideUI(UIType.UIBattleReportDetail)
   UIService:Instance():ShowUI(UIType.UIGameMainView)
   BattleReportService:Instance():SetCurrentDetailInfo(nil)
   MapService:Instance():ScanTiled(self.info._tileIndex)
end

--点击连续战斗按钮
function UIBattleReportDetail:OnClickcountBtn()
    local temp = {};
     if(self.info._battleType == BattleReportType.Defence) then
        temp[4] = self.Detailinfo.AttackHero
        temp[5] = self.Detailinfo.AttackCountList
        temp[6] = self.info._resultType
        temp[1] = self.Detailinfo.DefensHero
        temp[2] = self.Detailinfo.DefenseCountList
        temp[3] = self:getEnemyBattleResult(self.info._resultType)
    else
        temp[1] = self.Detailinfo.AttackHero
        temp[2] = self.Detailinfo.AttackCountList
        temp[3] = self.info._resultType
        temp[4] = self.Detailinfo.DefensHero
        temp[5] = self.Detailinfo.DefenseCountList
        temp[6] = self:getEnemyBattleResult(self.info._resultType)
    end
   
    UIService:Instance():ShowUI(UIType.UIBattleReportCount,temp)
end

--获得敌方战斗结果
function UIBattleReportDetail:getEnemyBattleResult(resulttype)
    if(resulttype == BattleResultType.Win) then
        return BattleResultType.Lose
    elseif(resulttype == BattleResultType.Lose) then
        return BattleResultType.Win
    elseif(resulttype == BattleResultType.DieTogether) then
        return BattleResultType.DieTogether
    end
    return BattleResultType.Draw
end

--分享到聊天按钮
function UIBattleReportDetail:OnClickSendToChatBtn()
    -- print("攻大营"..self.info._dCardTableID)
    -- print("防大营"..self.info._aCardTableID)
    -- print("index"..self.info._tileIndex)
    -- print("个人的时候就是个人ID 同盟的时候就是同盟ID"..id)
    -- print("战报分组 1个人 2同盟"..BattleReportService:Instance():GetGroup())
    -- print("战报Id"..self.info._iD)
    -- print("下标"..self.index)
    local id = 0;
    if BattleReportService:Instance():GetGroup() == ReportGroup.Alliance then
       id = PlayerService:Instance():GetLeagueId();
    else
       id = PlayerService:Instance():GetPlayerId();
    end
    local params = {};
    params[1] = PlayerService:Instance():GetPlayerId();
    params[2] = PlayerService:Instance():GetName();
    params[3] = 0;
    local BattleReportChat = require("Game/Chat/BattleReportChat").new();
    BattleReportChat._dCardTableID = self.info._dCardTableID;
    BattleReportChat._aCardTableID = self.info._aCardTableID;
    BattleReportChat._tileIndex = self.info._tileIndex;
    BattleReportChat._buildingId = self.info.buildingID;
    BattleReportChat._name = self.info.name;
    BattleReportChat._id = id;
    BattleReportChat._group = BattleReportService:Instance():GetGroup();
    BattleReportChat._iD = self.info._iD;
    BattleReportChat._index = self.index;
    params[4] = BattleReportChat;
    UIService:Instance():ShowUI(UIType.OperationUI, params);
end

--剩余数量
function UIBattleReportDetail:InitLeftNum()
    local count = self.Detailinfo.BeforeRound:Count();
    -- print("++++++++++++++++++++++++++++++++++++++++++"..count);
    for index = 1,count do
        local info = self.Detailinfo.BeforeRound:Get(index);
        if(info.OutType ==OutOfBattleReportType.TroopNum)then
            local isourpart = BattleReportService:Instance():isOurPart(info.IsAttackPart,self.info._battleType);
            if(isourpart) then
                self.AttackLeft = self.AttackLeft + info.troopNum;

                local  attackcount = self.Detailinfo.AttackCountList:Count();
                -- print("attackcount ===="..attackcount);
                -- for i,v in pairs(self.Detailinfo.AttackCountList) do
                --     if(v.cardID == info.cardId) then
                --         self.OurWoundNum[info.cardId] = v.woundNumSum;
                --         print(v.woundNumSum);
                --     end
                -- end
                for i=1,attackcount do
                    local infor = self.Detailinfo.AttackCountList:Get(i);
                    if(infor.cardID == info.cardId) then
                        self.OurWoundNum[info.cardId] = infor.woundNumSum;
                    end
                end
                -- self.OurWoundNum[info.cardId] = info.woundNum;

                self.OurLeftNum[info.cardId] = info.troopNum;
            else
                self.DefenceLeft = self.DefenceLeft + info.troopNum;
                -- self.OtherWoundNum[info.cardId] = info.woundNum;
                local  dcount = self.Detailinfo.DefenseCountList:Count();
                -- print("dcount ===="..dcount);
                for i=1,dcount do
                    local infor = self.Detailinfo.DefenseCountList:Get(i);
                    if(infor.cardID == info.cardId) then
                        self.OtherWoundNum[info.cardId] = infor.woundNumSum;
                    end
                end

                self.OtherLeftNum[info.cardId] = info.troopNum;
            end
        end
    end
end

--设置准备阶段
function UIBattleReportDetail:SetPreparatoryStage()
    local mUIBattleReportRound = self._AllItemList:Get(1);
    if(mUIBattleReportRound~=nil) then
        mUIBattleReportRound.gameObject:SetActive(true);
        mUIBattleReportRound:InitPreparatoryStage(self.Detailinfo.BeforeRound,self.info._battleType,self.info._resultType,self.info._drawTimes);
    else
        mUIBattleReportRound = UIBattleReportRound.new();
        GameResFactory.Instance():GetUIPrefab(self.UIBattleReportRoundPrefab,self.gridParent,mUIBattleReportRound,function (go)
            mUIBattleReportRound:Init();
            mUIBattleReportRound:SetUnBattle(self,self.SetUnBattle)
            mUIBattleReportRound:InitPreparatoryStage(self.Detailinfo.BeforeRound,self.info._battleType,self.info._resultType,self.info._drawTimes);
            self._AllItemList:Push(mUIBattleReportRound);
        end);
    end
    
end

--设置未战斗 显示未战的标题
function UIBattleReportDetail:SetUnBattle()
    self.result.sprite = GameResFactory.Instance():GetResSprite("NoWar");
    self.result:SetNativeSize();
    self.result.transform.localScale = bigSize;
end

--设置结果
function UIBattleReportDetail:setResult()
    if(self.info._battleType ~= BattleReportType.Defence) then
        self.result.sprite = GameResFactory.Instance():GetResSprite(BattleReportService:Instance():GetResultSprite(self.info._resultType));
    else
        self.result.sprite = GameResFactory.Instance():GetResSprite(BattleReportService:Instance():GetResultSprite(self:getEnemyBattleResult(self.info._resultType)));
    end
    
    if(self.info._resultType == BattleResultType.Draw) then
        self.result:SetNativeSize();
        self.result.transform.localScale = bigSize;
    else
        self.result:SetNativeSize();
        self.result.transform.localScale = Vector3.one;
    end
end

--设置每一回合
function UIBattleReportDetail:SetRound()
    local count = self.Detailinfo.FightFlowRound:Count();    -- 多少个回合 测试
    --print("拥有这么多个回合 ",count);
    for index = 1,count do    
        local OneRound = self.Detailinfo.FightFlowRound:Get(index)
        local mUIBattleReportRound = self._AllItemList:Get(index+1); --有一个是准备阶段 所以要加1
        if(mUIBattleReportRound~=nil) then
            mUIBattleReportRound.gameObject:SetActive(true);
            mUIBattleReportRound:InitRound(index,OneRound,self.info._battleType);
        else
            mUIBattleReportRound = UIBattleReportRound.new();
            GameResFactory.Instance():GetUIPrefab(self.UIBattleReportRoundPrefab,self.gridParent,mUIBattleReportRound,function (go)
                mUIBattleReportRound:Init();
                mUIBattleReportRound:InitRound(index,OneRound,self.info._battleType);
                self._AllItemList:Push(mUIBattleReportRound);
            end);
        end
    end
    --战斗结束
    local mUIBattleReportRound = self._AllItemList:Get(count+2); --有一个是准备阶段 所以要加1
    if(mUIBattleReportRound~=nil) then
        mUIBattleReportRound.gameObject:SetActive(true);
        mUIBattleReportRound:BattleOver();
        self:ResetScrollRect();
    else
        mUIBattleReportRound = UIBattleReportRound.new();
        GameResFactory.Instance():GetUIPrefab(self.UIBattleReportRoundPrefab,self.gridParent,mUIBattleReportRound,function (go)
            mUIBattleReportRound:Init();
            mUIBattleReportRound:BattleOver();
            self._AllItemList:Push(mUIBattleReportRound);
            self:ResetScrollRect();
        end);
    end
end

--设置攻防两方
function UIBattleReportDetail:SetAttackAndDefender()
    if(self.info._battleType == BattleReportType.Defence) then
        self:SetleagueAndName(self.OurPartName,self.info._dPlayerName);
        self:SetleagueAndName(self.OurPartAllianceName,self.info._dleagueName);
        self:SetleagueAndName(self.EnemyName,self.info._aPlayerName);
        self:SetleagueAndName(self.EnemyAllianceName,self.info._dleagueName);
    else
        self:SetleagueAndName(self.OurPartName,self.info._aPlayerName);
        self:SetleagueAndName(self.OurPartAllianceName,self.info._aleagueName);
        self:SetleagueAndName(self.EnemyName,self.info._dPlayerName);
        self:SetleagueAndName(self.EnemyAllianceName,self.info._dleagueName);
    end
end

function UIBattleReportDetail:SetleagueAndName(Label,text)
    Label.text = text
    if(text == "") then
        Label.transform.parent.gameObject:SetActive(false);
    else
         Label.transform.parent.gameObject:SetActive(true);
    end
end

--设置进度条和文本
function UIBattleReportDetail:SetLeftArmySlider(left,all,numlabel,slider)
    numlabel.text = left.."/<color=#ffff00>"..all.."</color>";
    if all == 0 then
        slider.value = 0;
    else
        slider.value = math.abs(left/all);
    end
end

--增加敌我各3个卡牌
function UIBattleReportDetail:AddCards()
    for index = 1, 3 do
        if self.OurPartCards[index] ~= nil then
            self.OurPartCards[index].gameObject:SetActive(false);
            if(self.info._battleType == BattleReportType.Defence) then
                self:InitCards(self.Detailinfo.DefensHero:Get(4-index),self.OurPartCards[index],true);
            else
                self:InitCards(self.Detailinfo.AttackHero:Get(4-index),self.OurPartCards[index],true);
            end
        else
            local mdata = DataUIConfig[UIType.UIBattleReportDetailCard];
            local uiBase = require(mdata.ClassName).new();
            GameResFactory.Instance():GetUIPrefab(mdata.ResourcePath, self.OurPartCardsParent, uiBase, function(go)
                uiBase:Init();
                uiBase:SetGo(go);
                self.OurPartCards[index] = uiBase;
                self.OurPartCards[index].gameObject:SetActive(false);
                if(self.info._battleType == BattleReportType.Defence) then
                    self:InitCards(self.Detailinfo.DefensHero:Get(4-index),self.OurPartCards[index],true);
                else
                    self:InitCards(self.Detailinfo.AttackHero:Get(4-index),self.OurPartCards[index],true);
                end
            end );
           
        end
        if self.EnemyCards[index] ~= nil then
            self.EnemyCards[index].gameObject:SetActive(false);
            if(self.info._battleType == BattleReportType.Defence) then
                self:InitCards(self.Detailinfo.AttackHero:Get(index),self.EnemyCards[index],false);
            else
                self:InitCards(self.Detailinfo.DefensHero:Get(index),self.EnemyCards[index],false);
            end
        else
            local mdata = DataUIConfig[UIType.UIBattleReportDetailCard];
            local uiBase = require(mdata.ClassName).new();
            GameResFactory.Instance():GetUIPrefab(mdata.ResourcePath, self.EnemyCardsParent, uiBase, function(go)
                uiBase:Init();
                uiBase:SetGo(go);
                self.EnemyCards[index] = uiBase;
                self.EnemyCards[index].gameObject:SetActive(false);
                if(self.info._battleType == BattleReportType.Defence) then
                    self:InitCards(self.Detailinfo.AttackHero:Get(index),self.EnemyCards[index],false);
                else
                    self:InitCards(self.Detailinfo.DefensHero:Get(index),self.EnemyCards[index],false);
                end
            end );
        end
    end
end

--初始化每张卡牌武将
function UIBattleReportDetail:InitCards(info,dic,isOurPart)
    if(info == nil) then
        return;
    end
    local slottype = info.position
    if(slottype>0 and slottype <= 3) then
        if(dic) then
            dic.gameObject:SetActive(true);
            dic:InitCard(info);
            if(isOurPart)then
                dic:SetWoundTroop(self.OurWoundNum)
                dic:SetLeftTroop(self.OurLeftNum)
            else
                dic:SetWoundTroop(self.OtherWoundNum)
                dic:SetLeftTroop(self.OtherLeftNum)
            end
        end
    end
end

--所有的隐藏
function UIBattleReportDetail:SetAllFalse()
    for index = 1,self._AllItemList:Count() do
        self._AllItemList:Get(index).gameObject:SetActive(false);
    end
end

return UIBattleReportDetail
