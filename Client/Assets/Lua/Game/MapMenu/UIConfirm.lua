--[[
    确定扫荡，驻守，屯田，练兵界面
--]]
    local UIBase= require("Game/UI/UIBase");
    local UIConfirm=class("UIConfirm",UIBase);        
    local UIService=require("Game/UI/UIService");
    local UIType=require("Game/UI/UIType");
    local SelfLand = require("Game/MapMenu/SelfLand");
    local ArmyManage = require("Game/Army/ArmyManage");
    local DataHeroLevel = require("Game/Table/model/DataHeroLevel");
    local ArmyInfo = require("Game/Army/ArmyInfo");
    local ArmySlotType = require("Game/Army/ArmySlotType");
    local DataHero = require("Game/Table/model/DataHero");
    local HeroCard = require("Game/Hero/HeroCardPart/HeroCard")
    local ArmyInfo = require("Game/Army/ArmyInfo");
    local SourceEventType = require("Game/SourceEvent/SourceEventType")
    local DataGameConfig = require("Game/Table/model/DataGameConfig")
    local CurrencyEnum = require("Game/Player/CurrencyEnum")

--构造函数
function UIConfirm:ctor()
    UIConfirm.super.ctor(self);
    self.lootBackBtn = nil;
    self.garrisonBackBtn = nil;
    self.wastelandBackBtn = nil;
    self.trainingBackBtn = nil; 
    self.battleBackBtn = nil;
    self.transferBackBtn = nil;     
    self.sweepBtn = nil;  
    self.defendBtn = nil;
    self.tondenBtn = nil;
    self.trainingBtn = nil;
    self.battleBtn = nil;
    self.transferBtn = nil;
    -- 当前要操作的格子
    self._curTiledIndex = nil;
    self._troopIndex = nil;

     -- 出征
    self._battle = nil;


    -- 大营
    self._armyCampName = nil;
    self._gradeCampText = nil;
    --卡牌星级
    self._CampStar = { };
    self.yellowCampStar1 = nil;
    self.yellowCampStar2 = nil;
    self.yellowCampStar3 = nil;
    self.yellowCampStar4 = nil;
    self.yellowCampStar5 = nil;

    -- 卡牌兵种
    self._soldierType = nil;
    self._distanceText = nil;

    -- 总兵力
    self._troopsText = nil;

    -- 中锋
    self._armyCenterName = nil;
    self._gradeCenterText = nil;
    self._CenterStar = { };
    self._yellowCenterStar1 = nil;
    self._yellowCenterStar2 = nil;
    self._yellowCenterStar3 = nil;
    self._yellowCenterStar4 = nil;
    self._yellowCenterStar5 = nil;
    self._centerSoldierType = nil;
    self._centerDistanceText = nil;

    -- 前锋
    self._armyforwardName = nil;
    self._gradeforwardText = nil;
    self._forwardStar = { };
    self._yellowforwardStar1 = nil;
    self._yellowforwardStar2 = nil;
    self._yellowforwardStar3 = nil;
    self._yellowforwardStar4 = nil;
    self._yellowforwardStar5 = nil;
    self._forwardSoldierType = nil;
    self._forwardDistanceText = nil;

    self._SpeedText = nil;
    self._siegeText = nil;

    -------- 出征
    -- 地的等级 坐标
    self._landLevelBattleText = nil;
    -- 消耗体力
    self._physicalPowerText = nil;
    -- 行军距离
    self._distanceText = nil;
    -- 敌军兵力加成
    self._distanceAdditionText = nil;
    -- 行军时间
    self._marchTimeText = nil;
    -- 到达时间
    self._arriveTimeText = nil;
    -- 提示信息
    self.noticeText = nil;

    -------- 调动
    -- 地的等级 坐标
    self._landLevelSwapText = nil;
    -- 消耗体力
    self._physicalPowerSwapText = nil;
    -- 行军距离
    self._distanceSwapText = nil;
    -- 敌军兵力加成
   -- self._distanceAdditionSwapText = nil;
    -- 行军时间
    self._marchTimeSwapText = nil;
    -- 到达时间
    self._arriveTimeSwapText = nil;

    ---------扫荡
    -- 地的等级 坐标
    self._landLevelSweepText = nil;
    -- 消耗体力
    self._physicalPowerSweepText = nil;
    -- 行军距离
    self._distanceSweepText = nil;
    -- 敌军兵力加成
    self._distanceAdditionSweepText = nil;
    -- 行军时间
    self._marchTimeSweepText = nil;
    -- 到达时间
    self._arriveTimeSweepText = nil;

    ---------驻守
    -- 地的等级 坐标
    self._landLevelDefendText = nil;
     -- 消耗体力
    self._physicalPowerDefendText = nil;
    -- 行军距离
    self._distanceDefendText = nil;
    -- 敌军兵力加成
   -- self._distanceAdditionDefendText = nil;
    -- 行军时间
    self._marchTimeDefendText = nil;
    -- 到达时间
    self._arriveTimeDefendText = nil;

    ---------屯田
    -- 地的等级 坐标
    self._landLeveltondenText = nil;
     -- 消耗体力
    self._physicalPowertondenText = nil;
    -- 政令
    self._tokenText = nil;
    -- 行军距离
    self._distanceTondenText = nil;
    -- 行军时间
    self._marchTimeTondenText = nil;
    -- 到达时间
    self._arriveTimeTondenText = nil;
    -- 屯田时间
    self._tondenTimeText = nil;
    -- 预计收入木材
    self._incomeWoodText = nil;
    -- 预计收入石料
    self._incomeIronText = nil;
    -- 预计收入铁矿
    self._incomeStoneText = nil;
    -- 预计收入粮草
    self._incomeGrainText = nil;
    
    ----------练兵
    -- 地的等级 坐标
    self._landLevelTrainingText = nil;
    -- 消耗体力
    self._physicalPowerTrainingText = nil;
    -- 政令
    self._tokenTrainingText = nil;
    -- 行军距离
    self._distanceTrainingText = nil;
    -- 行军时间
    self._marchTimeTrainingText = nil;
    -- 到达时间
    self._arriveTimeTrainingText = nil;
    -- 练兵时间
    self._trainingTimeText = nil;
    -- 1次
    self._NneNextBtn = nil;
    -- 2次
    self._TwoNextbtn = nil;
    -- 3次
    self._ThreeNextbtn = nil;
    -- 4次
    self._FourNextBtn = nil;
    -- 预计收入经验
    self._expText = nil;

    self.armyInfo = nil;
    self.askButton = nil;



    -------
    self.fatherCamp = nil;
    self.fatherCenter = nil;
    self.fatherForward = nil;
    self.ArmyInfo = nil;

    self.camp = {}
    self.middle = {}
    self.forward = {}
    self.buildingId = nil;

    -- 练兵次数
    self._trainingTimes = 0

  self.HeroCardCamp = {}
  self.HeroCardCenter = {}
  self.HeroCardForward = {}

  -- 部队类型
  self.troopType = nil;
  self.TrainingThat = nil;

  -- 警告面板
  self._warningPanel = nil

  -- 取消按钮
  self._concelBtn = nil

  -- 确认按钮
  self._confirmBtn = nil 

  self._back = nil
end

--注册控件
function UIConfirm:DoDataExchange()  
  self._back = self:RegisterController(UnityEngine.UI.Button,"Back");
    --扫荡
    self.lootBackBtn=self:RegisterController(UnityEngine.UI.Button,"SweepAffirmImage/xSButton");
    self.sweepBtn=self:RegisterController(UnityEngine.UI.Button,"SweepAffirmImage/sweepButton");
    --驻守
    self.garrisonBackBtn=self:RegisterController(UnityEngine.UI.Button,"DefendAffirmImage/xDButton"); 
    self.defendBtn=self:RegisterController(UnityEngine.UI.Button,"DefendAffirmImage/defendButton");
    --屯田
    self.wastelandBackBtn=self:RegisterController(UnityEngine.UI.Button,"TondenAffirmImage/xTButton");
    self.tondenBtn=self:RegisterController(UnityEngine.UI.Button,"TondenAffirmImage/tondenButton");
    self._warningPanel=self:RegisterController(UnityEngine.Transform,"TondenAffirmImage/WarningPanel");
    self._concelBtn=self:RegisterController(UnityEngine.UI.Button,"TondenAffirmImage/WarningPanel/ConcelBtn");
    self._confirmBtn=self:RegisterController(UnityEngine.UI.Button,"TondenAffirmImage/WarningPanel/ConfirmBtn");
    --练兵
    self.trainingBackBtn=self:RegisterController(UnityEngine.UI.Button,"TrainingAffirmImage/xTrButton");
    self.trainingBtn=self:RegisterController(UnityEngine.UI.Button,"TrainingAffirmImage/trainButton");
    --出征
    self.battleBackBtn=self:RegisterController(UnityEngine.UI.Button,"ExpeditionsAffirmImage/xEButton");
    self.battleBtn=self:RegisterController(UnityEngine.UI.Button,"ExpeditionsAffirmImage/battleButton");
    --调动
    self.transferBackBtn=self:RegisterController(UnityEngine.UI.Button,"TransferImage/xTrasButton"); 
    self.transferBtn=self:RegisterController(UnityEngine.UI.Button,"TransferImage/transferButton");

   ---------------------------大营-----------------------
  --self._armyCampName=self:RegisterController(UnityEngine.UI.Text,"TroopsArrayImage/BottomFiveImage/OneGeneralSmallHeroCard/HeroNameText");
  --self._gradeCampText=self:RegisterController(UnityEngine.UI.Text,"TroopsArrayImage/BottomFiveImage/OneGeneralSmallHeroCard/GradeText");
  --self.yellowCampStar1=self:RegisterController(UnityEngine.UI.Image,"TroopsArrayImage/BottomFiveImage/OneGeneralSmallHeroCard/StarImage/YellowStar/YellowImage1");
  --self.yellowCampStar2=self:RegisterController(UnityEngine.UI.Image,"TroopsArrayImage/BottomFiveImage/OneGeneralSmallHeroCard/StarImage/YellowStar/YellowImage2");
  --self.yellowCampStar3=self:RegisterController(UnityEngine.UI.Image,"TroopsArrayImage/BottomFiveImage/OneGeneralSmallHeroCard/StarImage/YellowStar/YellowImage3");
  --self.yellowCampStar4=self:RegisterController(UnityEngine.UI.Image,"TroopsArrayImage/BottomFiveImage/OneGeneralSmallHeroCard/StarImage/YellowStar/YellowImage4");
  --self.yellowCampStar5=self:RegisterController(UnityEngine.UI.Image,"TroopsArrayImage/BottomFiveImage/OneGeneralSmallHeroCard/StarImage/YellowStar/YellowImage5");
  self._CampStar[1]=self.yellowCampStar1;
  self._CampStar[2]=self.yellowCampStar2;
  self._CampStar[3]=self.yellowCampStar3;
  self._CampStar[4]=self.yellowCampStar4;
  self._CampStar[5]=self.yellowCampStar5;
  --self._soldierType=self:RegisterController(UnityEngine.UI.Image,"TroopsArrayImage/BottomFiveImage/OneGeneralSmallHeroCard/SoldierType/GongBingImage");
  --self._distanceText=self:RegisterController(UnityEngine.UI.Text,"TroopsArrayImage/BottomFiveImage/OneGeneralSmallHeroCard/SoldierType/DistanceText");
  self._troopsText=self:RegisterController(UnityEngine.UI.Text,"TroopsArrayImage/NumericalObj/TroopsText");

  ---------------------------- 中锋----------------------

  --self._armyCenterName=self:RegisterController(UnityEngine.UI.Text,"TroopsArrayImage/BottomFiveImage/TwoGeneralSmallHeroCard/HeroNameText");
  --self._gradeCenterText=self:RegisterController(UnityEngine.UI.Text,"TroopsArrayImage/BottomFiveImage/TwoGeneralSmallHeroCard/GradeText");
  --self._yellowCenterStar1=self:RegisterController(UnityEngine.UI.Image,"TroopsArrayImage/BottomFiveImage/TwoGeneralSmallHeroCard/StarImage/YellowStar/YellowImage1");
  --self._yellowCenterStar2=self:RegisterController(UnityEngine.UI.Image,"TroopsArrayImage/BottomFiveImage/TwoGeneralSmallHeroCard/StarImage/YellowStar/YellowImage2");
  --self._yellowCenterStar3=self:RegisterController(UnityEngine.UI.Image,"TroopsArrayImage/BottomFiveImage/TwoGeneralSmallHeroCard/StarImage/YellowStar/YellowImage3");
  --self._yellowCenterStar4=self:RegisterController(UnityEngine.UI.Image,"TroopsArrayImage/BottomFiveImage/TwoGeneralSmallHeroCard/StarImage/YellowStar/YellowImage4");
  --self._yellowCenterStar5=self:RegisterController(UnityEngine.UI.Image,"TroopsArrayImage/BottomFiveImage/TwoGeneralSmallHeroCard/StarImage/YellowStar/YellowImage5");
  self._CenterStar[1]=self._yellowCenterStar1;
  self._CenterStar[2]=self._yellowCenterStar2;
  self._CenterStar[3]=self._yellowCenterStar3;
  self._CenterStar[4]=self._yellowCenterStar4;
  self._CenterStar[5]=self._yellowCenterStar5;
  --self._centerSoldierType=self:RegisterController(UnityEngine.UI.Image,"TroopsArrayImage/BottomFiveImage/TwoGeneralSmallHeroCard/SoldierType/GongBingImage");
  --self._centerDistanceText=self:RegisterController(UnityEngine.UI.Text,"TroopsArrayImage/BottomFiveImage/TwoGeneralSmallHeroCard/SoldierType/DistanceText");

  ----------------------------前锋---------------------

  --self._armyforwardName=self:RegisterController(UnityEngine.UI.Text,"TroopsArrayImage/BottomFiveImage/ThreeGeneralSmallHeroCard/HeroNameText");
  --self._gradeforwardText=self:RegisterController(UnityEngine.UI.Text,"TroopsArrayImage/BottomFiveImage/ThreeGeneralSmallHeroCard/GradeText");
  --self._yellowforwardStar1=self:RegisterController(UnityEngine.UI.Image,"TroopsArrayImage/BottomFiveImage/ThreeGeneralSmallHeroCard/StarImage/YellowStar/YellowImage1");
  --self._yellowforwardStar2=self:RegisterController(UnityEngine.UI.Image,"TroopsArrayImage/BottomFiveImage/ThreeGeneralSmallHeroCard/StarImage/YellowStar/YellowImage2");
  --self._yellowforwardStar3=self:RegisterController(UnityEngine.UI.Image,"TroopsArrayImage/BottomFiveImage/ThreeGeneralSmallHeroCard/StarImage/YellowStar/YellowImage3");
  --self._yellowforwardStar4=self:RegisterController(UnityEngine.UI.Image,"TroopsArrayImage/BottomFiveImage/ThreeGeneralSmallHeroCard/StarImage/YellowStar/YellowImage4");
  --self._yellowforwardStar5=self:RegisterController(UnityEngine.UI.Image,"TroopsArrayImage/BottomFiveImage/ThreeGeneralSmallHeroCard/StarImage/YellowStar/YellowImage5");
  self._forwardStar[1]=self._yellowforwardStar1;
  self._forwardStar[2]=self._yellowforwardStar2;
  self._forwardStar[3]=self._yellowforwardStar3;
  self._forwardStar[4]=self._yellowforwardStar4;
  self._forwardStar[5]=self._yellowforwardStar5;
  --self._forwardSoldierType=self:RegisterController(UnityEngine.UI.Image,"TroopsArrayImage/BottomFiveImage/ThreeGeneralSmallHeroCard/SoldierType/GongBingImage");
  --self._forwardDistanceText=self:RegisterController(UnityEngine.UI.Text,"TroopsArrayImage/BottomFiveImage/ThreeGeneralSmallHeroCard/SoldierType/DistanceText");

  self._SpeedText=self:RegisterController(UnityEngine.UI.Text,"TroopsArrayImage/NumericalObj/SpeedText");
  self._siegeText=self:RegisterController(UnityEngine.UI.Text,"TroopsArrayImage/NumericalObj/SiegeText")

  ---------------------出征---------------------------
  self._landLevelBattleText=self:RegisterController(UnityEngine.UI.Text,"ExpeditionsAffirmImage/landLevelText");
  self._physicalPowerText=self:RegisterController(UnityEngine.UI.Text,"ExpeditionsAffirmImage/physicalPowerText");
  self._distanceText=self:RegisterController(UnityEngine.UI.Text,"ExpeditionsAffirmImage/distanceText");
  self._distanceAdditionText=self:RegisterController(UnityEngine.UI.Text,"ExpeditionsAffirmImage/distanceAdditionText");
  self._marchTimeText=self:RegisterController(UnityEngine.UI.Text,"ExpeditionsAffirmImage/marchTimeText");
  self._arriveTimeText=self:RegisterController(UnityEngine.UI.Text,"ExpeditionsAffirmImage/arriveTimeText");
  self._noticeText = self:RegisterController(UnityEngine.UI.Text,"ExpeditionsAffirmImage/noticeText");

  ---------------------调动--------------------------
  self._landLevelSwapText=self:RegisterController(UnityEngine.UI.Text,"TransferImage/landLevelText");
  self._physicalPowerSwapText=self:RegisterController(UnityEngine.UI.Text,"TransferImage/physicalPowerText")
  self._distanceSwapText=self:RegisterController(UnityEngine.UI.Text,"TransferImage/distanceText");
  self._distanceAdditionSwapText=self:RegisterController(UnityEngine.UI.Text,"TransferImage/distanceAdditionText");
  self._marchTimeSwapText=self:RegisterController(UnityEngine.UI.Text,"TransferImage/marchTimeText");
  self._arriveTimeSwapText=self:RegisterController(UnityEngine.UI.Text,"TransferImage/arriveTimeText");

  ---------------------扫荡--------------------------
  self._landLevelSweepText=self:RegisterController(UnityEngine.UI.Text,"SweepAffirmImage/landLevelText");
  self._physicalPowerSweepText=self:RegisterController(UnityEngine.UI.Text,"SweepAffirmImage/physicalPowerText");
  self._distanceSweepText=self:RegisterController(UnityEngine.UI.Text,"SweepAffirmImage/distanceText");
  self._distanceAdditionSweepText=self:RegisterController(UnityEngine.UI.Text,"SweepAffirmImage/distanceAdditionText");
  self._marchTimeSweepText=self:RegisterController(UnityEngine.UI.Text,"SweepAffirmImage/marchTimeText");
  self._arriveTimeSweepText=self:RegisterController(UnityEngine.UI.Text,"SweepAffirmImage/arriveTimeText");

  ---------------------驻守--------------------------
  self._landLevelDefendText=self:RegisterController(UnityEngine.UI.Text,"DefendAffirmImage/landLevelText");
  self._physicalPowerDefendText=self:RegisterController(UnityEngine.UI.Text,"DefendAffirmImage/physicalPowerText");
  self._distanceDefendText=self:RegisterController(UnityEngine.UI.Text,"DefendAffirmImage/distanceText");
 -- self._distanceAdditionDefendText=self:RegisterController(UnityEngine.UI.Text,"DefendAffirmImage/distanceAdditionText");
  self._marchTimeDefendText=self:RegisterController(UnityEngine.UI.Text,"DefendAffirmImage/marchTimeText");
  self._arriveTimeDefendText=self:RegisterController(UnityEngine.UI.Text,"DefendAffirmImage/arriveTimeText");

  ---------------------屯田--------------------------
  self._landLeveltondenText=self:RegisterController(UnityEngine.UI.Text,"TondenAffirmImage/landLevelText");
  self._physicalPowertondenText=self:RegisterController(UnityEngine.UI.Text,"TondenAffirmImage/physicalPowerText");
  self._tokenText=self:RegisterController(UnityEngine.UI.Text,"TondenAffirmImage/tokenText");
  self._distanceTondenText=self:RegisterController(UnityEngine.UI.Text,"TondenAffirmImage/distanceText");
  self._marchTimeTondenText=self:RegisterController(UnityEngine.UI.Text,"TondenAffirmImage/marchTimeText");
  self._arriveTimeTondenText=self:RegisterController(UnityEngine.UI.Text,"TondenAffirmImage/arriveTimeText");
  self._tondenTimeText=self:RegisterController(UnityEngine.UI.Text,"TondenAffirmImage/tondenTimeText");
  self._incomeWoodText=self:RegisterController(UnityEngine.UI.Text,"TondenAffirmImage/incomeWoodText");
  self._incomeIronText=self:RegisterController(UnityEngine.UI.Text,"TondenAffirmImage/incomeIronText");
  self._incomeStoneText=self:RegisterController(UnityEngine.UI.Text,"TondenAffirmImage/incomeStoneText");
  self._incomeGrainText=self:RegisterController(UnityEngine.UI.Text,"TondenAffirmImage/incomeGrainText");

  --------------------练兵---------------------------
  self._landLevelTrainingText=self:RegisterController(UnityEngine.UI.Text,"TrainingAffirmImage/landLevelText");
  self._physicalPowerTrainingText=self:RegisterController(UnityEngine.UI.Text,"TrainingAffirmImage/physicalPowerText");
  self._tokenTrainingText=self:RegisterController(UnityEngine.UI.Text,"TrainingAffirmImage/tokenText");
  self._distanceTrainingText=self:RegisterController(UnityEngine.UI.Text,"TrainingAffirmImage/distanceText");
  self._marchTimeTrainingText=self:RegisterController(UnityEngine.UI.Text,"TrainingAffirmImage/marchTimeText");
  self._arriveTimeTrainingText=self:RegisterController(UnityEngine.UI.Text,"TrainingAffirmImage/arriveTimeText");
  self._trainingTimeText=self:RegisterController(UnityEngine.UI.Text,"TrainingAffirmImage/tondenTimeText");
  self._NneNextBtn=self:RegisterController(UnityEngine.UI.Toggle,"TrainingAffirmImage/TrainingNext/NneNextImage");
  self._TwoNextbtn=self:RegisterController(UnityEngine.UI.Toggle,"TrainingAffirmImage/TrainingNext/TwoNextImage");
  self._ThreeNextbtn=self:RegisterController(UnityEngine.UI.Toggle,"TrainingAffirmImage/TrainingNext/ThreeNextImage");
  self._FourNextBtn=self:RegisterController(UnityEngine.UI.Toggle,"TrainingAffirmImage/TrainingNext/FiveNextImage");
  self._expText=self:RegisterController(UnityEngine.UI.Text,"TrainingAffirmImage/expText");


  --------
  self.fatherCamp = self:RegisterController(UnityEngine.Transform,"TroopsArrayImage/ArmyCast/NotOpenedBorder1");
  self.fatherCenter = self:RegisterController(UnityEngine.Transform,"TroopsArrayImage/ArmyCast/NotOpenedBorder2");
  self.fatherForward = self:RegisterController(UnityEngine.Transform,"TroopsArrayImage/ArmyCast/NotOpenedBorder3");

  self.fatherForwardText = self:RegisterController(UnityEngine.UI.Text,"TroopsArrayImage/ArmyCast/NotOpenedBorder3/Text")

  self.askButton = self:RegisterController(UnityEngine.UI.Button,"TondenAffirmImage/askButton")
  self.TrainingThat = self:RegisterController(UnityEngine.UI.Button,"TrainingAffirmImage/TrainingaskButton")
end


--注册点击事件
function UIConfirm:DoEventAdd()
  self:AddListener(self.lootBackBtn,self.OnClickBackBtn);
  self:AddListener(self.garrisonBackBtn,self.OnClickBackBtn);  
  self:AddListener(self.wastelandBackBtn,self.OnClickBackBtn);
  self:AddListener(self.trainingBackBtn,self.OnClickBackBtn);
  self:AddListener(self.battleBackBtn,self.OnClickBackBtn);
  self:AddListener(self.transferBackBtn,self.OnClickBackBtn);  
  self:AddListener(self.sweepBtn,self.OnClickSweep);
  self:AddListener(self.defendBtn,self.OnCilckDefend);
  self:AddListener(self.tondenBtn,self.OnClickTonden);
  self:AddListener(self.trainingBtn,self.OnclickTraining);
  self:AddListener(self.battleBtn,self.OnClickBattle);
  self:AddListener(self.transferBtn,self.OnClickTransfer);
  self:AddToggleOnValueChanged(self._NneNextBtn,self.OnClickNneNext);
  self:AddToggleOnValueChanged(self._TwoNextbtn,self.OnClickTwoNext);
  self:AddToggleOnValueChanged(self._ThreeNextbtn,self.OnClickThreeNext);
  self:AddToggleOnValueChanged(self._FourNextBtn,self.OnClickFourNext);
  self:AddListener(self.askButton,self.OnClickAskBtn)
  self:AddListener(self.TrainingThat, self.OnClickTrainingThatBtn)
  self:AddListener(self._concelBtn,self.OnClickConcelBtn);
  self:AddListener(self._confirmBtn,self.OnClickConfirmBtn);
  self:AddListener(self._back,self.OnClickBackBtn);
end

function UIConfirm:OnClickNneNext()
  if self._NneNextBtn.isOn then
    self._trainingTimes = 1
    self:RefreshTrainingInfo()
  end
  self._tokenTrainingText.text = "3";
end
function UIConfirm:OnClickTwoNext()
  if self._TwoNextbtn.isOn then
    self._trainingTimes = 2
    self:RefreshTrainingInfo()
  end
  self._tokenTrainingText.text = "6";
end
function UIConfirm:OnClickThreeNext()
  if self._ThreeNextbtn.isOn then
    self._trainingTimes = 3
    self:RefreshTrainingInfo()
  end
  self._tokenTrainingText.text = "9";
end
function UIConfirm:OnClickFourNext()
  if self._FourNextBtn.isOn then
    self._trainingTimes = 5
    self:RefreshTrainingInfo()
  end
  self._tokenTrainingText.text = "15";
end

--返回按钮
function UIConfirm:OnClickBackBtn()       
    UIService:Instance():HideUI(UIType.UIConfirm);  
    --UIService:Instance():ShowUI(UIType.UIGameMainView)  
end

function UIConfirm:OnClickAskBtn()
      param = {}
      param[1] = "屯田"
      param[2] = "屯田收益:随土地等级提高而提高,同时能从周围的领地获得15%的收益\n屯田时间:30分钟,增加部队兵力可以缩短时间";
      UIService:Instance():ShowUI(UIType.UICommonTipSmall, param)
end

function UIConfirm:OnClickTrainingThatBtn()
      param = {}
      param[1] = "确认"
      param[2] = "练兵收益:获得大量武将经验,平分至队伍中各武将;获得经验随土地等级提高而提高\n单次练兵时间:25分钟";
      UIService:Instance():ShowUI(UIType.UICommonTipSmall, param)
end


--判断加载预制
function UIConfirm:OnShow(param)  
    self.troopType = param.troopType   
    self:DoVerdict(param.troopType); 
    self._curTiledIndex = param.tiledIndex    
    self._troopIndex = param.troopIndex 
    self.ArmyInfo = param.armyInfo;
    self.buildingId = param.buildingId;
    self:SetBattleInfo();
    self:SetSwapInfo();
    self:SetSweepInfo();
    self:SetDefendInfo();
    self:SetTondenInfo();
    self:SetTrainingInfo();
    self:SetGenerals();



end

-- 到达地坐标
function UIConfirm:AvstigningCoords()
      local startTiledX,startTiledY = MapService:Instance():GetTiledCoordinate(self._curTiledIndex);
      return startTiledX,startTiledY;
end

-- 行军距离
function UIConfirm:MarchDistance()
      local startTiledX,startTiledY = MapService:Instance():GetTiledCoordinate(self._curTiledIndex);
      local tiledId = BuildingService:Instance():GetBuilding(self.buildingId)._tiledId;
      local targetTiledX,targetTiledY = MapService:Instance():GetTiledCoordinate(tiledId);
      local distances =math.sqrt((targetTiledX - startTiledX)*(targetTiledX - startTiledX)*12960000+(targetTiledY - startTiledY)*(targetTiledY - startTiledY)*12960000)/3600;
      local troopsAddition = distances*0.03;
      local distance = string.format("%.1f", distances);
      return distance;
end
-- 行军时间
function UIConfirm:MarchTime()
      local distance = self:MarchDistance();
      local mArmyInfo = ArmyManage:GetMyArmyInMainCity(self._troopIndex);
      local speed = self.ArmyInfo:GetSpeedContainFacility();
      local marchTime = distance*3600/speed;
      local timeString = self:TimeFormat(marchTime);
      return timeString;
end
--调动（如要塞到要塞）部队时需要的时间时别的三分之一
function UIConfirm:TransferMarchTime()
      local distance = self:MarchDistance();
      local mArmyInfo = ArmyManage:GetMyArmyInMainCity(self._troopIndex);
      local speed = self.ArmyInfo:GetSpeedContainFacility();
      local marchTime = distance*3600/speed/3;
      local timeString = self:TimeFormat(marchTime);
      return timeString;
end


function UIConfirm:TimeFormat(time)
    local h = math.floor(time / 3600);
    local m = math.floor((time % 3600) / 60);
    local s = time % 3600 % 60;
    local timeText = string.format("%02d:%02d:%02d",h, m, s);
    return timeText;
end

-- 敌军兵力加成
function UIConfirm:troopsAddition()
      local distance = self:MarchDistance();
      local troop = distance*0.03*100;
      local troops = "<color=#e6e6c6>敌军兵力+</color>".."<color=#e6e6c6>"..math.modf(troop).."%".."</color>";
      return troops;
end
-- 到达时间
function UIConfirm:ArriveTime()
      local distance = self:MarchDistance();
      local mArmyInfo = ArmyManage:GetMyArmyInMainCity(self._troopIndex);
      local speed = mArmyInfo:GetSpeedContainFacility();
      local marchTime = distance*3600/speed;

      local dates = os.time();

      local time = dates%86400+marchTime+28800;
      local times = self:TimeFormat(time);

      local year = os.date("%Y-%m-%d");
      local date = year.." "..times;
      return date;
end
-- 计算屯田时间
function UIConfirm:TondenTime() 
    local tondenTime = 1860 - (self.ArmyInfo:GetAllSoldierCount() * 0.6)
    if tondenTime < 60 then
      tondenTime = 60;
    end
    return tondenTime;
end



-- -- 出征
function UIConfirm:OnClickBattle()
  local msg = require("MessageCommon/Msg/C2L/Army/ArmyBattleMsg").new();
  msg:SetMessageId(C2L_Army.ArmyBattleMsg);
  msg.buildingId = self.buildingId;
  msg.index = self._troopIndex;
  msg.tiledIndex = self._curTiledIndex;
  NetService:Instance():SendMessage(msg);
  UIService:Instance():HideUI(UIType.UIConfirm);
  UIService:Instance():HideUI(UIType.UISelfLandFunction)
  UIService:Instance():ShowUI(UIType.UIGameMainView)
  CommonService:Instance():Play("Audio/GoBattle")
end
-- 调动
function UIConfirm:OnClickTransfer()
  self:IsTroop()
  local msg = require("MessageCommon/Msg/C2L/Army/ArmyTransferomMsg").new();
  msg:SetMessageId(C2L_Army.ArmyTransferomMsg);
  msg.buildingId = self.buildingId;
  msg.index = self._troopIndex;
  ------print(msg.index)
  msg.tiledIndex = self._curTiledIndex;
  NetService:Instance():SendMessage(msg)
  UIService:Instance():HideUI(UIType.UIConfirm); 
  UIService:Instance():HideUI(UIType.UISelfLandFunction)
  UIService:Instance():ShowUI(UIType.UIGameMainView)
end

-- 扫荡
function UIConfirm:OnClickSweep()
   self:IsTroop()
    local msg = require("MessageCommon/Msg/C2L/Army/ArmySweepMsg").new();
    msg:SetMessageId(C2L_Army.ArmySweepMsg)
    msg.buildingId = self.buildingId;
    msg.index = self._troopIndex;
    msg.tiledIndex = self._curTiledIndex;
    msg.sourceEventType = self:GetSourceEventType()
    NetService:Instance():SendMessage(msg);
    UIService:Instance():HideUI(UIType.UIConfirm); 
    UIService:Instance():HideUI(UIType.UISelfLandFunction)
    UIService:Instance():ShowUI(UIType.UIGameMainView)
end

-- 驻守
function UIConfirm:OnCilckDefend()
    --self:IsTroop()
    local msg = require("MessageCommon/Msg/C2L/Army/ArmyGarrisonMsg").new()
    msg:SetMessageId(C2L_Army.ArmyGarrisonMsg)
    msg.buildingId = self.buildingId;
    msg.index = self._troopIndex;
    msg.tiledIndex = self._curTiledIndex;
    NetService:Instance():SendMessage(msg);  
    UIService:Instance():HideUI(UIType.UIConfirm);
    UIService:Instance():HideUI(UIType.UISelfLandFunction)
    UIService:Instance():ShowUI(UIType.UIGameMainView)
end

-- 屯田
function UIConfirm:OnClickTonden()
    self:IsTroop()
    local tiled = MapService:Instance():GetTiledByIndex(self._curTiledIndex)
    if tiled == nil then
     return
    end
    if self:IsHaveResourceOverMax(tiled) then
      self._warningPanel.gameObject:SetActive(true)
    else
      self:SendArmyFarmmingMsg()
    end
end

-- 发送屯田消息
function UIConfirm:SendArmyFarmmingMsg()
    local msg = require("MessageCommon/Msg/C2L/Army/ArmyFarmmingMsg").new();
    msg:SetMessageId(C2L_Army.ArmyFarmmingMsg);
    msg.buildingId = self.buildingId;
    msg.index = self._troopIndex;
    msg.tiledIndex = self._curTiledIndex;
    NetService:Instance():SendMessage(msg); 
    UIService:Instance():HideUI(UIType.UIConfirm);
    UIService:Instance():HideUI(UIType.UISelfLandFunction)
    UIService:Instance():ShowUI(UIType.UIGameMainView)
end

-- 点击取消按钮
function UIConfirm:OnClickConcelBtn()
  self._warningPanel.gameObject:SetActive(false)
end

-- 点击确认按钮
function UIConfirm:OnClickConfirmBtn()
  self._warningPanel.gameObject:SetActive(false)
  self:SendArmyFarmmingMsg()
    
end

-- 练兵
function UIConfirm:OnclickTraining()
    self:IsTroop()
    if self:IsTraining() == true then
      local msg = require("MessageCommon/Msg/C2L/Army/ArmyTrainingMsg").new();
      msg:SetMessageId(C2L_Army.ArmyTrainingMsg);
      msg.buildingId = self.buildingId;
      msg.index = self._troopIndex;
      msg.tiledIndex = self._curTiledIndex;
      msg.trainingTimes = self._trainingTimes;
      NetService:Instance():SendMessage(msg);  
      UIService:Instance():HideUI(UIType.UIConfirm);
      UIService:Instance():HideUI(UIType.UISelfLandFunction)
      UIService:Instance():ShowUI(UIType.UIGameMainView)
    end
end
-- 体力政令不足 提示框
function UIConfirm:IsTraining()
    local decree = PlayerService:Instance():GetDecreeSystem():GetCurValue()
    param = {}
    param.tiledIndex = self._curTiledIndex
    param.troopIndex = self._troopIndex
    param.buildingId = self.buildingId
    param._trainingTimes = self._trainingTimes
    if self:IsHaveHeroTired(self.ArmyInfo,self._trainingTimes) == true or decree < self._trainingTimes * 3 then
      UIService:Instance():ShowUI(UIType.UIConfirmCancel,param);
      return false ;
    end
    return true
end

function UIConfirm:IsHaveHeroTired(armyInfo, count)
    -- for k,v in pairs(ArmySlotType) do
    --     while true do
    --         local heroCard = armyInfo:GetCard(v)
    --         ----print(count)
    --         if heroCard == nil then
    --             break
    --         end
    --         if heroCard.power:GetValue() < 20*count then
    --             return true
    --         end
    --         break
    --     end
    -- end
    return false
end

-- function UIConfirm:decreeCount(count)
--     local decree = PlayerService:Instance():GetDecreeSystem():GetCurValue()
--     if decree < count then
--        UIService:Instance():ShowUI(UIType.UICueMessageBox,UICueMessageType.trainingCount);
--     end
-- end

function UIConfirm:IsTroop()
    local tiled = MapService:Instance():GetTiledByIndex(self._curTiledIndex);
    if tiled ~= nil then
        if PlayerService:Instance():GetPlayerId() ~= tiled.tiledInfo.ownerId then
            UIService:Instance():ShowUI(UIType.UICueMessageBox,UICueMessageType.UnableDoOperation);
            return
        end
    end
end

-- 获取地块或者建筑物名称
function UIConfirm:GetTiledOrBuildingName(tiled)
  if tiled == nil then
    return ""
  end
  local data = tiled:GetResource()
  if tiled._building ~= nil then
    data = MapService:Instance():GetBuildingDataTile(tiled)
  end
  if data == nil then
    return ""
  end
  local landLv = data.TileLv
  local name = "土地Lv.".. tostring(landLv)
  local town = tiled:GetTown()
  if town ~= nil then
    local building = town._building
    if building ~= nil then
      if building._dataInfo.Type == BuildingType.MainCity or building._dataInfo.Type == BuildingType.SubCity or building._dataInfo.Type == BuildingType.PlayerFort then
          name = building._name .. "-城区"
      else
          name = building._dataInfo.Name .. "-城区"
      end
    end
  end
  local building = tiled:GetBuilding()
  if building ~= nil then
    if building._dataInfo.Type == BuildingType.MainCity or building._dataInfo.Type == BuildingType.SubCity or building._dataInfo.Type == BuildingType.PlayerFort then
        name = building._name
    else
        name = building._dataInfo.Name
    end
  end
  return name
end

-- 出征
function UIConfirm:SetBattleInfo()
  if self.troopType ~= SelfLand.battle then
    return
  end
     local startTiledX,startTiledY = self:AvstigningCoords();
     local tiledIndex = MapService:Instance():GetTiledIndex(startTiledX,startTiledY)
     local tiled = MapService:Instance():GetTiledByIndex(self._curTiledIndex)
     if tiled == nil then
       ------print("此处的tiled不应为空，我在这里return")
       return
     end
     -- local landLv = tiled:GetResource().TileLv;
     -- --------print("土地等级是 == " .. landLv)
     -- local build = tiled:GetBuilding()--BuildingService:Instance():GetBuildingByTiledId(self._curTiledIndex);
     -- if build == nil then
     --  print("build is nil")
     -- end
     -- if build ~= nil then
     --  print("到底有没有建筑物。。。" .. self:GetTiledOrBuildingName(tiled))
     --    -- if build._dataInfo.Type == BuildingType.MainCity then        
     --    --   self._landLevelBattleText.text = build._name .. "("..startTiledX..","..startTiledY..")";
     --    -- elseif build._dataInfo.Type == BuildingType.SubCity then
     --    --   self._landLevelBattleText.text = build._name .. "("..startTiledX..","..startTiledY..")";
     --    -- elseif build._dataInfo.Type == BuildingType.PlayerFort then
     --    --   self._landLevelBattleText.text = build._name .. "("..startTiledX..","..startTiledY..")";
     --    if build._dataInfo.Type == BuildingType.WildFort then
     --      self._landLevelBattleText.text = "野外要塞" .. "("..startTiledX..","..startTiledY..")";
     --    else
     --      self._landLevelBattleText.text = build._name .. "("..startTiledX..","..startTiledY..")";
     --    end
     -- elseif tiled._town ~= nil then
     --    print("点击城区有没有进来这里")
     --      self._landLevelBattleText.text = tiled._town._building._name .. "-城区" .. "("..startTiledX..","..startTiledY..")";
     -- else
     --      self._landLevelBattleText.text = "土地Lv.".. tostring(landLv) .."("..startTiledX..","..startTiledY..")";
     -- end
     self._landLevelBattleText.text = self:GetTiledOrBuildingName(tiled) .. "("..startTiledX..","..startTiledY..")"
     self._physicalPowerText.text = self:GetNeedPhysical();
     local distance = self:MarchDistance();
     local distances = string.format("%.1f",distance);
     self._distanceText.text = distances;

     local timeString = self:MarchTime();
     self._marchTimeText.text = timeString;

     local date = self:ArriveTime();
     self._arriveTimeText.text = date;
     ------print(tiled);
     if tiled ~= nil then
      if tiled._town ~= nil then
        if tiled._town._building._dataInfo.Type == BuildingType.WildBuilding then
          self._distanceAdditionText.gameObject:SetActive(false);
        end
      else
        self._distanceAdditionText.gameObject:SetActive(true);
        if build then
          self._distanceAdditionText.text = "";
        else
          local troops = self:troopsAddition();
          self._distanceAdditionText.text = troops;
        end
      end
     end
     -- if build then
     --  self._noticeText.text = "敌情难测，请斟酌形行事";
     -- else
     --  self._noticeText.text = "敌军兵力弱小,可兵不血刃胜之";
     -- end
    self:GetArmyTroop()
end

function UIConfirm:ArmyTroopsAdditionPrompt()
  local tiled = MapService:Instance():GetTiledByIndex(self._curTiledIndex)
  if tiled == nil then
    return
  end
  local resource = self.tiled:GetResource();
  local defenderTroop = resource.NPCTroopHeroUnitNum;
  local armyTotalTroop = self.ArmyInfo:GetAllSoldierCount()
end


function UIConfirm:GetArmyTroop()
  local armyTroop = self.ArmyInfo:GetAllSoldierCount()
  local distance = self:MarchDistance()
  local tiled = MapService:Instance():GetTiledByIndex(self._curTiledIndex)
  if tiled == nil then
    return
  end
  if tiled.tiledInfo ~= nil and tiled.tiledInfo.ownerId == 0 then
    local resource = tiled:GetResource()
    if tiled._building ~= nil then
      resource = MapService:Instance():GetBuildingDataTile(tiled)
    end
    -- local resource = tiled:GetResource()
    local npcTroop = nil 
    if resource.TileLv == "6" or resource.TileLv == "7" or resource.TileLv == "8" or resource.TileLv == "9" then
        npcTroop = resource.NPCTroopHeroUnitNum*2.15
    else
        npcTroop = resource.NPCTroopHeroUnitNum
    end
    local troop = armyTroop/(npcTroop * (1+distance*0.03))
    if troop <= DataGameConfig[509].OfficialData/10000 then
        self._noticeText.text = "<color=#AA5252FF>敌军强势，勿要以卵击石</color>"
    elseif troop > DataGameConfig[509].OfficialData/10000 and troop <= DataGameConfig[508].OfficialData/10000 then
        self._noticeText.text = "<color=#B39156FF>战胜虽易，但损失不可避免</color>"
    elseif troop > DataGameConfig[508].OfficialData/10000 and troop <= DataGameConfig[507].OfficialData/10000 then
        self._noticeText.text = "<color=#A19F55FF>敌军虽弱，但可能会有一定损失</color>"
    elseif troop > DataGameConfig[507].OfficialData/10000 then
        self._noticeText.text = "<color=#71B448FF>敌军势弱，可轻易击破</color>"
    end
  elseif tiled.tiledInfo ~= nil and tiled.tiledInfo.ownerId ~= PlayerService:Instance():GetPlayerId() then
      self._noticeText.text = "<color=#A19F55FF>敌情不明，需谨慎行事</color>"
  end
end

-- 调动
function UIConfirm:SetSwapInfo()
  if self.troopType ~= SelfLand.transfer then
    return
  end
    local startTiledX,startTiledY = self:AvstigningCoords();
    local tiled = MapService:Instance():GetTiledByIndex(self._curTiledIndex)
    if tiled == nil then
     return
    end
    -- local landLv = tiled:GetResource().TileLv;
    -- local build = BuildingService:Instance():GetBuildingByTiledId(self._curTiledIndex);
    --  if build ~= nil then
    --     if build._dataInfo.Type == BuildingType.MainCity then        
    --       self._landLevelSwapText.text = build._name .. "("..startTiledX..","..startTiledY..")";
    --     elseif build._dataInfo.Type == BuildingType.SubCity then
    --       self._landLevelSwapText.text = build._name .. "("..startTiledX..","..startTiledY..")";
    --     elseif build._dataInfo.Type == BuildingType.PlayerFort then
    --       self._landLevelSwapText.text = build._name .. "("..startTiledX..","..startTiledY..")";
    --     elseif build._dataInfo.Type == BuildingType.WildFort then
    --       self._landLevelSwapText.text = build._name .. "("..startTiledX..","..startTiledY..")";
    --     end
    --  elseif tiled._town ~= nil then
    --       self._landLevelSwapText.text = tiled._town._building._name .. "-城区" .. "("..startTiledX..","..startTiledY..")";
    --  else
    --       self._landLevelSwapText.text = "土地Lv.".. tostring(landLv) .."("..startTiledX..","..startTiledY..")";
    --  end
    self._landLevelSwapText.text = self:GetTiledOrBuildingName(tiled) .. "("..startTiledX..","..startTiledY..")"
    --self._landLevelSwapText.text = "土地Lv."..landLv.."("..startTiledX..","..startTiledY..")";
    self._physicalPowerSwapText.text = self:GetNeedPhysical();
    local distance = self:MarchDistance();
    local distances = string.format("%.1f",distance);
    self._distanceSwapText.text = distances;

    local timeString = self:TransferMarchTime();
    self._marchTimeSwapText.text = timeString;

    self._distanceAdditionSwapText.text = "";

    local date = self:ArriveTime();
    self._arriveTimeSwapText.text = date;
end

-- 扫荡
function UIConfirm:SetSweepInfo()

if self.troopType ~= SelfLand.loot then
    return
  end
    local startTiledX,startTiledY = self:AvstigningCoords();
    local tiled = MapService:Instance():GetTiledByIndex(self._curTiledIndex)
    if tiled == nil then
     return
    end
    -- local landLv = tiled:GetResource().TileLv;
    -- local build = BuildingService:Instance():GetBuildingByTiledId(self._curTiledIndex);
    --  if build ~= nil then
    --     if build._dataInfo.Type == BuildingType.MainCity then        
    --       self._landLevelSweepText.text = build._name .. "("..startTiledX..","..startTiledY..")";
    --     elseif build._dataInfo.Type == BuildingType.SubCity then
    --       self._landLevelSweepText.text = build._name .. "("..startTiledX..","..startTiledY..")";
    --     elseif build._dataInfo.Type == BuildingType.PlayerFort then
    --       self._landLevelSweepText.text = build._name .. "("..startTiledX..","..startTiledY..")";
    --     end
    --  elseif tiled._town ~= nil then
    --       self._landLevelSweepText.text = tiled._town._building._name .. "-城区" .. "("..startTiledX..","..startTiledY..")";
    --  else
    --       self._landLevelSweepText.text = "土地Lv.".. tostring(landLv) .."("..startTiledX..","..startTiledY..")";
    --  end
    --self._landLevelSweepText.text = "土地Lv."..landLv.."("..startTiledX..","..startTiledY..")";
    self._landLevelSweepText.text = self:GetTiledOrBuildingName(tiled) .. "("..startTiledX..","..startTiledY..")"
    self._physicalPowerSweepText.text = self:GetNeedPhysical();

    local distance = self:MarchDistance();
    local distances = string.format("%.1f",distance);
    self._distanceSweepText.text = distances;

    local troops = self:troopsAddition();
    self._distanceAdditionSweepText.text = troops;

    local timeString = self:MarchTime();
    self._marchTimeSweepText.text = timeString;

    local date = self:ArriveTime();
    self._arriveTimeSweepText.text = date;

    self:GetArmyTroop()
end

-- 驻守
function UIConfirm:SetDefendInfo()
if self.troopType ~= SelfLand.garrison then
    return
  end
    local startTiledX,startTiledY = self:AvstigningCoords();
    local tiled = MapService:Instance():GetTiledByIndex(self._curTiledIndex)
    if tiled == nil then
     return
    end
    -- local landLv = tiled:GetResource().TileLv;
    -- local build = BuildingService:Instance():GetBuildingByTiledId(self._curTiledIndex);
    --  if build ~= nil then
    --     if build._dataInfo.Type == BuildingType.MainCity then        
    --       self._landLevelDefendText.text = build._name .. "("..startTiledX..","..startTiledY..")";
    --     elseif build._dataInfo.Type == BuildingType.SubCity then
    --       self._landLevelDefendText.text = build._name .. "("..startTiledX..","..startTiledY..")";
    --     elseif build._dataInfo.Type == BuildingType.PlayerFort then
    --       self._landLevelDefendText.text = build._name .. "("..startTiledX..","..startTiledY..")";
    --     elseif build._dataInfo.Type == BuildingType.WildFort then
    --       self._landLevelDefendText.text = build._name .. "("..startTiledX..","..startTiledY..")";
    --     end
    --  elseif tiled._town ~= nil then
    --       self._landLevelDefendText.text = tiled._town._building._name .. "-城区" .. "("..startTiledX..","..startTiledY..")";
    --  else
    --       self._landLevelDefendText.text = "土地Lv.".. tostring(landLv) .."("..startTiledX..","..startTiledY..")";
    --  end
     self._landLevelDefendText.text = self:GetTiledOrBuildingName(tiled) .. "("..startTiledX..","..startTiledY..")"
    --self._landLevelDefendText.text = "土地Lv."..landLv.."("..startTiledX..","..startTiledY..")";
    self._physicalPowerDefendText.text = self:GetNeedPhysical();

    local distance = self:MarchDistance();
    local distances = string.format("%.1f",distance);
    self._distanceDefendText.text = distances;

    local timeString = self:MarchTime();
    self._marchTimeDefendText.text = timeString;

    local date = self:ArriveTime();
    self._arriveTimeDefendText.text = date;
end

-- 屯田
function UIConfirm:SetTondenInfo()
  if self.troopType ~= SelfLand.wasteland then
    return
  end
    local startTiledX,startTiledY = self:AvstigningCoords();
    local tiled = MapService:Instance():GetTiledByIndex(self._curTiledIndex)
    if tiled == nil then
     return
    end
    -- local landLv = tiled:GetResource().TileLv;
    -- local build = BuildingService:Instance():GetBuildingByTiledId(self._curTiledIndex);
    --  if build ~= nil then
    --     if build._dataInfo.Type == BuildingType.MainCity then        
    --       self._landLeveltondenText.text = build._name .. "("..startTiledX..","..startTiledY..")";
    --     elseif build._dataInfo.Type == BuildingType.SubCity then
    --       self._landLeveltondenText.text = build._name .. "("..startTiledX..","..startTiledY..")";
    --     elseif build._dataInfo.Type == BuildingType.PlayerFort then
    --       self._landLeveltondenText.text = build._name .. "("..startTiledX..","..startTiledY..")";
    --     end
    --  elseif tiled._town ~= nil then
    --       self._landLeveltondenText.text = tiled._town._building._name .. "-城区" .. "("..startTiledX..","..startTiledY..")";
    --  else
    --       self._landLeveltondenText.text = "土地Lv.".. tostring(landLv) .."("..startTiledX..","..startTiledY..")";
    --  end
     self._landLeveltondenText.text = self:GetTiledOrBuildingName(tiled) .. "("..startTiledX..","..startTiledY..")"
    --self._landLeveltondenText.text = "土地Lv."..landLv.."("..startTiledX..","..startTiledY..")";
    self._physicalPowertondenText.text  = self:GetNeedPhysical();
    self._tokenText.text = "3";
    -- 行军距离
    local distance = self:MarchDistance();
    local distances = string.format("%.1f",distance);
    self._distanceTondenText.text = distances;
    -- 行军时间
    local timeString = self:MarchTime();
    self._marchTimeTondenText.text = timeString;

    local date = self:ArriveTime();
    self._arriveTimeTondenText.text = date;

    self._tondenTimeText.text = self:TimeFormat(self:TondenTime());

    if self:IsOverResourceMax(tiled, CurrencyEnum.Wood) and MapService:Instance():GetTiledFarmmingAccount(tiled, CurrencyEnum.Wood) ~= 0 then
      self._incomeWoodText.text = "<color=#BF3636FF>" .. MapService:Instance():GetTiledFarmmingAccount(tiled, CurrencyEnum.Wood) .. "</color>";
    else
      self._incomeWoodText.text = MapService:Instance():GetTiledFarmmingAccount(tiled, CurrencyEnum.Wood);
    end

    if self:IsOverResourceMax(tiled, CurrencyEnum.Iron) and MapService:Instance():GetTiledFarmmingAccount(tiled, CurrencyEnum.Iron) ~= 0 then
      self._incomeIronText.text = "<color=#BF3636FF>" .. MapService:Instance():GetTiledFarmmingAccount(tiled, CurrencyEnum.Iron) .. "</color>";
    else
      self._incomeIronText.text = MapService:Instance():GetTiledFarmmingAccount(tiled, CurrencyEnum.Iron);
    end

    if self:IsOverResourceMax(tiled, CurrencyEnum.Stone) and MapService:Instance():GetTiledFarmmingAccount(tiled, CurrencyEnum.Stone) ~= 0 then
      self._incomeStoneText.text = "<color=#BF3636FF>" .. MapService:Instance():GetTiledFarmmingAccount(tiled, CurrencyEnum.Stone) .. "</color>";
    else
      self._incomeStoneText.text = MapService:Instance():GetTiledFarmmingAccount(tiled, CurrencyEnum.Stone);
    end

    if self:IsOverResourceMax(tiled, CurrencyEnum.Grain) and MapService:Instance():GetTiledFarmmingAccount(tiled, CurrencyEnum.Grain) ~= 0 then
      self._incomeGrainText.text = "<color=#BF3636FF>" .. MapService:Instance():GetTiledFarmmingAccount(tiled, CurrencyEnum.Grain) .. "</color>";
    else
      self._incomeGrainText.text = MapService:Instance():GetTiledFarmmingAccount(tiled, CurrencyEnum.Grain);
    end
end

-- 是否爆仓
function UIConfirm:IsOverResourceMax(tiled, currencyEnum)
  local resourceMax = PlayerService:Instance():GetResourceMax()
  --print("资源产量上限 == " .. resourceMax)
  local resourceVal = PlayerService:Instance():GetCurrencyVarCalcByKey(currencyEnum):GetValue()
  -- print("资源产量 == " .. resourceVal)
  if resourceVal + MapService:Instance():GetTiledFarmmingAccount(tiled, currencyEnum) > resourceMax then
    -- print("资源总量 == " .. resourceVal + MapService:Instance():GetTiledFarmmingAccount(tiled, currencyEnum))
    return true
  end
  return false
end

-- 是否有资源爆仓
function UIConfirm:IsHaveResourceOverMax(tiled)
  if self:IsOverResourceMax(tiled, CurrencyEnum.Wood) then
    return true
  elseif self:IsOverResourceMax(tiled, CurrencyEnum.Iron) then
    return true
  elseif self:IsOverResourceMax(tiled, CurrencyEnum.Stone) then
    return true
  elseif self:IsOverResourceMax(tiled, CurrencyEnum.Grain) then
    return true
  end
  return false
end

-- 练兵
function UIConfirm:SetTrainingInfo()
  self._NneNextBtn.isOn = true
  self._TwoNextbtn.isOn = false
  self._ThreeNextbtn.isOn = false
  self._FourNextBtn.isOn =   false
  if self.troopType ~= SelfLand.training then
    return
  end
    local startTiledX,startTiledY = self:AvstigningCoords();
    local tiled = MapService:Instance():GetTiledByIndex(self._curTiledIndex)
    if tiled == nil then
     return
    end
    self._expText.text = tiled:GetResource().TrainingExp * self._trainingTimes
    -- local landLv = tiled:GetResource().TileLv;
    -- local build = BuildingService:Instance():GetBuildingByTiledId(self._curTiledIndex);
    --  if build ~= nil then
    --     if build._dataInfo.Type == BuildingType.MainCity then        
    --       self._landLevelTrainingText.text = build._name .. "("..startTiledX..","..startTiledY..")";
    --     elseif build._dataInfo.Type == BuildingType.SubCity then
    --       self._landLevelTrainingText.text = build._name .. "("..startTiledX..","..startTiledY..")";
    --     elseif build._dataInfo.Type == BuildingType.PlayerFort then
    --       self._landLevelTrainingText.text = build._name .. "("..startTiledX..","..startTiledY..")";
    --     end
    --  elseif tiled._town ~= nil then
    --       self._landLevelTrainingText.text = tiled._town._building._name .. "-城区" .. "("..startTiledX..","..startTiledY..")";
    --  else
    --       self._landLevelTrainingText.text = "土地Lv.".. tostring(landLv) .."("..startTiledX..","..startTiledY..")";
    --  end
    --self._landLevelTrainingText.text = "土地Lv."..landLv.."("..startTiledX..","..startTiledY..")";
     self._landLevelTrainingText.text = self:GetTiledOrBuildingName(tiled) .. "("..startTiledX..","..startTiledY..")"
    

    local distance = self:MarchDistance();
    local distances = string.format("%.1f",distance);
    self._distanceTrainingText.text = distances;

    local timeString = self:MarchTime();
    self._marchTimeTrainingText.text = timeString;

    local date = self:ArriveTime();
    self._arriveTimeTrainingText.text = date;

    -- 练兵时间
    --self._trainingTimeText.text = "0";
    self:OnClickNneNext();
    
end

-- 刷新练兵信息
function UIConfirm:RefreshTrainingInfo()
    local tiled = MapService:Instance():GetTiledByIndex(self._curTiledIndex)
    if tiled == nil then
     return
    end
    self._physicalPowerTrainingText.text = self:GetNeedPhysical() * self._trainingTimes
    self._tokenTrainingText.text = 3 * self._trainingTimes
    -- 预计收入经验
    self._expText.text = tiled:GetResource().TrainingExp * self._trainingTimes
    local trainingTime = 1500 * self._trainingTimes
    self._trainingTimeText.text = self:TimeFormat(trainingTime)
end

function UIConfirm:SetHeroCardCamp(armyInfo,armySlotType,i)
    local mdata = DataUIConfig[UIType.UISmallHeroCard];
    local UISmallHeroCard = require(mdata.ClassName).new()
    local back = armyInfo:GetCard(ArmySlotType.Back);
    GameResFactory.Instance():GetUIPrefab(mdata.ResourcePath,self.fatherCamp,UISmallHeroCard,function (go)
            UISmallHeroCard:Init()
            UISmallHeroCard:SetUISmallHeroCardMessage(back,false);
            UISmallHeroCard:SetCardSoliderCount(armyInfo:GetIndexSoldierCount(armySlotType));
            UISmallHeroCard:SetArmyCountFalse();
  end);  
    self.HeroCardCamp[i] = UISmallHeroCard
   -- self:insertCamp(UISmallHeroCard)
end

function UIConfirm:SetHeroCardCenter(armyInfo,armySlotType,i)
    local mdata = DataUIConfig[UIType.UISmallHeroCard];
    local UISmallHeroCard = require(mdata.ClassName).new()
    local Center = armyInfo:GetCard(ArmySlotType.Center);
    GameResFactory.Instance():GetUIPrefab(mdata.ResourcePath,self.fatherCenter,UISmallHeroCard,function (go)
            UISmallHeroCard:Init()
            UISmallHeroCard:SetUISmallHeroCardMessage(Center,false);
            UISmallHeroCard:SetCardSoliderCount(armyInfo:GetIndexSoldierCount(armySlotType));
            UISmallHeroCard:SetArmyCountFalse();
  end);  
   -- self:insertCamp(UISmallHeroCard)
   self.HeroCardCenter[i] = UISmallHeroCard
end

function UIConfirm:SetHeroCardForward(armyInfo,armySlotType,i)
    local mdata = DataUIConfig[UIType.UISmallHeroCard];
    local UISmallHeroCard = require(mdata.ClassName).new()
    local Front = armyInfo:GetCard(ArmySlotType.Front);
    GameResFactory.Instance():GetUIPrefab(mdata.ResourcePath,self.fatherForward,UISmallHeroCard,function (go)
            UISmallHeroCard:Init()
            UISmallHeroCard:SetUISmallHeroCardMessage(Front,false);
            UISmallHeroCard:SetCardSoliderCount(armyInfo:GetIndexSoldierCount(armySlotType));
            UISmallHeroCard:SetArmyCountFalse();
  end);  
    self.HeroCardForward[i] = UISmallHeroCard
   -- self:insertCamp(UISmallHeroCard)
end

function UIConfirm:Set( ... )
  -- body
end

function UIConfirm:insertCamp(obj)
  if obj == nil then
    return
  end
  table.insert(self.camp, obj);
end

function UIConfirm:GetCamp(index)
  return self.camp[index];
end

function UIConfirm:SetGenerals()
   local armyInfo = self.ArmyInfo;
   local armySlot = armyInfo.spawnSlotIndex;
   for i = 1 ,#self.HeroCardCamp do
    local x = self.HeroCardCamp[i];
    x.gameObject:SetActive(false);
   end
  for i=1,#self.HeroCardCenter do
    local x = self.HeroCardCenter[i]
    x.gameObject:SetActive(false);
  end
  for i=1,#self.HeroCardForward do
    local x = self.HeroCardForward[i]
    x.gameObject:SetActive(false);
  end
     if armyInfo:GetCard(ArmySlotType.Back) ~= nil then

      local back = armyInfo:GetCard(ArmySlotType.Back)
      for i=1, 1 do
        local UISmallHeroCard = self.HeroCardCamp[i]
        if UISmallHeroCard == nil then
          self:SetHeroCardCamp(armyInfo,ArmySlotType.Back,i);
        else
          UISmallHeroCard.gameObject:SetActive(true)
          UISmallHeroCard:Init()
          UISmallHeroCard:SetUISmallHeroCardMessage(back,false);
          UISmallHeroCard:SetCardSoliderCount(armyInfo:GetIndexSoldierCount(ArmySlotType.Back));
          UISmallHeroCard:SetArmyCountFalse();
        end
      end
     end
     if armyInfo:GetCard(ArmySlotType.Center) ~= nil then
        local Center = armyInfo:GetCard(ArmySlotType.Center)
        for i=1, 1 do
          local UISmallHeroCard = self.HeroCardCenter[i]
          if UISmallHeroCard == nil then
            self:SetHeroCardCenter(armyInfo,ArmySlotType.Center,i);
          else
            UISmallHeroCard.gameObject:SetActive(true)
            UISmallHeroCard:Init()
            UISmallHeroCard:SetUISmallHeroCardMessage(Center,false);
            UISmallHeroCard:SetCardSoliderCount(armyInfo:GetIndexSoldierCount(ArmySlotType.Center));
            UISmallHeroCard:SetArmyCountFalse();
          end
        end
     end
     if armyInfo:CheckArmyOpenFront() == false then
      self.fatherForwardText.text = "<color=#AA5252FF>未开放,统帅厅Lv.</color>".."<color=#AA5252FF>"..armySlot.."</color>".."<color=#AA5252FF>开放</color>"
     elseif armyInfo:CheckArmyOpenFront() == true  then
      self.fatherForwardText.text = "未配置";
      if armyInfo:GetCard(ArmySlotType.Front) ~= nil then
        local Front = armyInfo:GetCard(ArmySlotType.Front)
        for i=1,1 do
            local UISmallHeroCard = self.HeroCardForward[i]
            if UISmallHeroCard == nil then
              self:SetHeroCardForward(armyInfo,ArmySlotType.Front,i);
            else
              UISmallHeroCard.gameObject:SetActive(true)
              UISmallHeroCard:Init()
              UISmallHeroCard:SetUISmallHeroCardMessage(Front,false);
              UISmallHeroCard:SetCardSoliderCount(armyInfo:GetIndexSoldierCount(ArmySlotType.Front));
              UISmallHeroCard:SetArmyCountFalse();
            end
        end
      end
     end
   self._siegeText.text = "<color=#FFD783FF>攻城</color>  ".."<color=#e6e6c6>"..armyInfo:GetAllAttackCityValue().."</color>"
   self._SpeedText.text="<color=#FFD783FF>速度</color>  ".."<color=#e6e6c6>"..armyInfo:GetSpeedContainFacility().."</color>"
   self._troopsText.text = "<color=#FFD783FF>总兵力</color>  ".."<color=#e6e6c6>"..armyInfo:GetAllSoldierCount().."</color>"
end

--判断界面的显示
function UIConfirm:DoVerdict(par)
    --调动
    if par == SelfLand.transfer then
       local loot = self.gameObject.transform:FindChild("TransferImage");
       loot.gameObject:SetActive(true);
       local loot = self.gameObject.transform:FindChild("SweepAffirmImage");
       loot.gameObject:SetActive(false);
       local garrison = self.gameObject.transform:FindChild("DefendAffirmImage");
       garrison.gameObject:SetActive(false);
       local wasteland = self.gameObject.transform:FindChild("TondenAffirmImage");
       wasteland.gameObject:SetActive(false);
       local training = self.gameObject.transform:FindChild("TrainingAffirmImage");
       training.gameObject:SetActive(false); 
       local loot = self.gameObject.transform:FindChild("ExpeditionsAffirmImage");
       loot.gameObject:SetActive(false);
    end
    --出征
    if par == SelfLand.battle then
       local loot = self.gameObject.transform:FindChild("ExpeditionsAffirmImage");
       loot.gameObject:SetActive(true);
       local loot = self.gameObject.transform:FindChild("TransferImage");
       loot.gameObject:SetActive(false);
       local loot = self.gameObject.transform:FindChild("SweepAffirmImage");
       loot.gameObject:SetActive(false);
       local garrison = self.gameObject.transform:FindChild("DefendAffirmImage");
       garrison.gameObject:SetActive(false);
       local wasteland = self.gameObject.transform:FindChild("TondenAffirmImage");
       wasteland.gameObject:SetActive(false);
       local training = self.gameObject.transform:FindChild("TrainingAffirmImage");
       training.gameObject:SetActive(false); 
    end
    --扫荡
    if par == SelfLand.loot then
        local loot = self.gameObject.transform:FindChild("SweepAffirmImage");
        loot.gameObject:SetActive(true);
        local garrison = self.gameObject.transform:FindChild("DefendAffirmImage");
        garrison.gameObject:SetActive(false);
        local wasteland = self.gameObject.transform:FindChild("TondenAffirmImage");
        wasteland.gameObject:SetActive(false);
        local training = self.gameObject.transform:FindChild("TrainingAffirmImage");
        training.gameObject:SetActive(false);
        local loot = self.gameObject.transform:FindChild("TransferImage");
        loot.gameObject:SetActive(false);
        local loot = self.gameObject.transform:FindChild("ExpeditionsAffirmImage");
        loot.gameObject:SetActive(false);
    end
    --驻守
    if par == SelfLand.garrison then        
        local loot = self.gameObject.transform:FindChild("SweepAffirmImage");
        loot.gameObject:SetActive(false);
        local garrison = self.gameObject.transform:FindChild("DefendAffirmImage");
        garrison.gameObject:SetActive(true);
        local wasteland = self.gameObject.transform:FindChild("TondenAffirmImage");
        wasteland.gameObject:SetActive(false);
        local training = self.gameObject.transform:FindChild("TrainingAffirmImage");
        training.gameObject:SetActive(false); 
        local loot = self.gameObject.transform:FindChild("TransferImage");
        loot.gameObject:SetActive(false);
        local loot = self.gameObject.transform:FindChild("ExpeditionsAffirmImage");
        loot.gameObject:SetActive(false);
    end
    --屯田
    if par == SelfLand.wasteland then
        local loot = self.gameObject.transform:FindChild("SweepAffirmImage");
        loot.gameObject:SetActive(false);   
        local wasteland = self.gameObject.transform:FindChild("TondenAffirmImage");
        wasteland.gameObject:SetActive(true);  
        local garrison = self.gameObject.transform:FindChild("DefendAffirmImage");
        garrison.gameObject:SetActive(false);
        local training = self.gameObject.transform:FindChild("TrainingAffirmImage");
        training.gameObject:SetActive(false);
        local loot = self.gameObject.transform:FindChild("TransferImage");
        loot.gameObject:SetActive(false);
        local loot = self.gameObject.transform:FindChild("ExpeditionsAffirmImage");
        loot.gameObject:SetActive(false);
    end
    --练兵
    if par == SelfLand.training then
        local loot = self.gameObject.transform:FindChild("SweepAffirmImage");
        loot.gameObject:SetActive(false);
        local training = self.gameObject.transform:FindChild("TrainingAffirmImage");
        training.gameObject:SetActive(true);
        local garrison = self.gameObject.transform:FindChild("DefendAffirmImage");
        garrison.gameObject:SetActive(false);  
        local wasteland = self.gameObject.transform:FindChild("TondenAffirmImage");
        wasteland.gameObject:SetActive(false);
        local loot = self.gameObject.transform:FindChild("TransferImage");
        loot.gameObject:SetActive(false); 
        local loot = self.gameObject.transform:FindChild("ExpeditionsAffirmImage");
        loot.gameObject:SetActive(false);     
    end
end

-- 获取扫荡类型
function UIConfirm:GetSourceEventType()
  local tiled = MapService:Instance():GetTiledByIndex(self._curTiledIndex)
  local sourceEventInfo = SourceEventService:Instance():isSourceEvent(tiled._x, tiled._y);
  if sourceEventInfo then
    return sourceEventInfo._eventType
  else
    return SourceEventType.non
  end
end

-- 获取当前需要的体力值
function UIConfirm:GetNeedPhysical()
    local physicalDataLine = 103;
    if NewerPeriodService:Instance():IsInNewerPeriod() == true then
        physicalDataLine = 904;
    end
    local physicalData = DataGameConfig[physicalDataLine];
    if physicalData ~= nil then
        return physicalData.OfficialData;
    end
    return 20;
end


return UIConfirm;
