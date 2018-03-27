--[[
    堡垒升级
--]]

local UIBase= require("Game/UI/UIBase");
local UIUpgradeBuilding=class("UIUpgradeBuilding",UIBase);        
local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");
require("Game/Table/InitTable");
local EventType = require("Game/Util/EventType");
local EventService = require("Game/Util/EventService")
local MapLoad = require("Game/Map/MapLoad")

--构造函数
function UIUpgradeBuilding:ctor()
    UIUpgradeBuilding.super.ctor(self);
    self.BuildingConfirm = nil;
    self.demolitionBtn = nil;
    self.closeBtn = nil;
    self._buildingText = nil;
    self._woodBuildingText = nil;
    self._ironBuildingText = nil;
    self._stornBuildingText = nil;
    self._level = nil;
    self.curTiledIndex = nil;
    self._buildingPlusFirst = nil;
    self._buildingPlusLast = nil;
    self._buildingPlusOneFirst = nil;
    self._buildingPlusOneLast = nil;
    self._buildingTimeText = nil;
    self._timeText= nil;
    self._requestTimer = nil;
    self._promptlyFulfill = nil;
    self.BuildingDemand1 = nil;
    self.currentGrade = nil;
    self.endGrade = nil;
    self.UpgradeBtn = nil;
    self.BuildingDemand = nil;
    self._requestTimerTable = {} ;

    self.abandonFortState = false;
    self.updateIcon = nil;
    self.texts = nil;
    self._imagepanel = nil;
    self.upgradeTimer = nil;

    -- 升级间隔
    self.upgradeInterval = 0;

    -- 箭头偏移量
    self.offset = 10

    self.buildingText = nil;

    self.BuidingTime = nil;
end

--初始化
function UIUpgradeBuilding:DoDataExchange()    
    self.BuildingConfirm = self:RegisterController(UnityEngine.UI.Button,"BuildingDemand/BuildingConfirm")
    self.demolitionBtn = self:RegisterController(UnityEngine.UI.Button,"TranslucenceImage1/demolitionBtn");
    self.closeBtn = self:RegisterController(UnityEngine.UI.Button,"backGround/closeBtn")
    self._buildingText = self:RegisterController(UnityEngine.UI.Text,"BuildingDemand/Grid/BuildingDemand/BuildingText1")
    self._woodBuildingText = self:RegisterController(UnityEngine.UI.Text,"BuildingDemand/Grid/BuildingDemandWood/BuildingText2")
    self._ironBuildingText = self:RegisterController(UnityEngine.UI.Text,"BuildingDemand/Grid/BuildingDemandIron/BuildingText3");
    self._stornBuildingText = self:RegisterController(UnityEngine.UI.Text,"BuildingDemand/Grid/BuildingDemandStone/BuildingText4")
    self._buildingPlusFirst = self:RegisterController(UnityEngine.UI.Text,"TextGrid/BuildingPlus/BuildingPlusFirst");
    self._buildingPlusLast = self:RegisterController(UnityEngine.UI.Text,"TextGrid/BuildingPlus/BuildingPlusLast");
    self._buildingPlusOneFirst = self:RegisterController(UnityEngine.UI.Text,"TextGrid/BuildingPlusOne/BuildingPlusOneFirst")
    self._buildingPlusOneLast = self:RegisterController(UnityEngine.UI.Text,"TextGrid/BuildingPlusOne/BuildingPlusOneLast");
    self._buildingTimeText = self:RegisterController(UnityEngine.UI.Text,"BuildingDemand/BuildingTimeText");
    self._timeText = self:RegisterController(UnityEngine.UI.Text,"BuildingImage/FacilityItem/facilitylevel")
    self._promptlyFulfill = self:RegisterController(UnityEngine.UI.Button,"BuildingDemand1/PromptlyFulfill")
    self.BuildingDemand1 = self:RegisterController(UnityEngine.RectTransform,"BuildingDemand1")
    self.currentGrade = self:RegisterController(UnityEngine.UI.Text,"BuildingDemand1/Upgrade/currentGrade")
    self.endGrade = self:RegisterController(UnityEngine.UI.Text,"BuildingDemand1/Upgrade/endGrade")
    self.UpgradeBtn = self:RegisterController(UnityEngine.UI.Button,"BuildingDemand1/Upgrade/UpgradeBtn")
    self.BuildingDemand = self:RegisterController(UnityEngine.RectTransform,"BuildingDemand")
    self.updateIcon = self:RegisterController(UnityEngine.UI.Image,"BuildingImage/FacilityItem/building");
    self.texts = self:RegisterController(UnityEngine.UI.Text,"texts")
    self._imagepanel = self:RegisterController(UnityEngine.UI.Image,"BuildingImage/FacilityItem/imagepanel")
    self.buildingText = self:RegisterController(UnityEngine.UI.Text,"buildingText")
    self.BuidingTime = self:RegisterController(UnityEngine.UI.Text,"BuildingDemand/BuidingTime")
end

--注册按钮点击事件
function UIUpgradeBuilding:DoEventAdd()
    self:AddListener(self.BuildingConfirm,self.OnClickBuildingConfirm);
    self:AddListener(self.demolitionBtn,self.OnClickDemolitionBtn);
    self:AddListener(self.closeBtn,self.OnClickCloseBtn);
    self:AddListener(self._promptlyFulfill,self.OnClickPromptlyFulfill);
    self:AddListener(self.UpgradeBtn,self.OnClickUpgradeBtn);
end

function UIUpgradeBuilding:RegisterAllNotice()
    self:RegisterNotice(L2C_Building.SyncUpdatePlayerFort, self.PromptleFun)
    self:RegisterNotice(L2C_Building.SyncUpdatePlayerFort, self.SetFortResources);
    self:RegisterNotice(L2C_Building.ReplyDeleteFortTimer, self.SetFortResources)
    self:RegisterNotice(L2C_Building.ReplyUpdateFortm, self.SetFortResources)
    self:RegisterNotice(L2C_Player.SyncBuildingInfo, self.SetFortResources)
    self:RegisterNotice(L2C_Player.SyncBuildingInfo, self.ShowUpgradeState)
    self:RegisterNotice(L2C_Building.ReplyUpdateFort,self.hideBox)
   -- self:RegisterNotice(L2C_Building.SyncUpdatePlayerFort, self.SetFortResources)
    ----print("???????????????????????????????????asdqw1d56qw4564qw5f1q51f5q4wf8q451fa+++++++++++++++++++++++++++")
end
function UIUpgradeBuilding:OnShow(curTiledIndex)
    self.curTiledIndex = curTiledIndex;
    self:SetFortResources();
    if PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Jade):GetValue() > 20 or self._level < 5  then
        self._promptlyFulfill.interactable = true;
    else
        self._promptlyFulfill.interactable = false;
    end
end

function UIUpgradeBuilding:SetFortResources()
    local building = BuildingService:Instance():GetBuildingByTiledId(self.curTiledIndex);
    self._level = BuildingService:Instance():GetBuildingByTiledId(self.curTiledIndex)._fortGrade;
    --print(self._level)
    ----print(self._level)
    self.BuildingConfirm.gameObject:SetActive(true);
    self._buildingTimeText.gameObject:SetActive(true);
--    self.BuildingDemand.gameObject:SetActive(true);
    if building._upgradeFortTime - PlayerService:Instance():GetLocalTime() > 0 then
        self:ShowUpgradeState();
    else
        self:PromptleFun()
    end
    self.BuidingTime.text = "<color=#e2bd75>需要时间</color>";
    -- self._imagepanel.gameObject:SetActive(true);
    -- self.texts.gameObject:SetActive(true);
    if self._level ~= nil then
    local count = PlayerService:Instance():GetDecreeSystem():GetCurValue();
    local Wood = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Wood):GetValue();
    local Iron = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Iron):GetValue();
    local Stone = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Stone):GetValue();
    if self._level == 1 then 
        self.buildingText.gameObject:SetActive(false)
        local woodText = DataBuilding[40002].UpgradeCostWood
        local ironText = DataBuilding[40002].UpgradeCostIron
        local stoneText = DataBuilding[40002].UpgradeCostStone
        local orderText = DataBuilding[40002].UpgradeCostCommand
        ----print(woodText.."   "..ironText.."  "..stoneText.."     "..orderText)
        -- if orderText <= count and woodText <= Wood and ironText <= Iron and stoneText <= Stone then
        --     self._buildingText.text = "<color=#E2BD75FF>政令</color> ".." <color=#FFFFFFFF>"..orderText.."</color>".."/".." <color=#E2BD75FF>"..count.."</color>";
        --     self._woodBuildingText.text = "<color=#E2BD75FF>木材</color> ".." <color=#FFFFFFFF>"..woodText.."</color>".."/".."<color=#E2BD75FF>"..Wood.."</color>";
        --     self._ironBuildingText.text = "<color=#E2BD75FF>铁矿</color> ".." <color=#FFFFFFFF>"..ironText.."</color>".."/".."<color=#E2BD75FF>"..Iron.."</color>"; 
        --     self._stornBuildingText.text = "<color=#E2BD75FF>石料</color> ".." <color=#FFFFFFFF>"..stoneText.."</color>".."/".."<color=#E2BD75FF>"..Stone.."</color>";
        -- end
        if orderText > count then
            self._buildingText.text = "<color=#E2BD75FF>政令</color> ".." <color=#a2341f>"..orderText.."</color>".."/".." <color=#E2BD75FF>"..count.."</color>";
        else
            self._buildingText.text = "<color=#E2BD75FF>政令</color> ".." <color=#FFFFFFFF>"..orderText.."</color>".."/".." <color=#E2BD75FF>"..count.."</color>";
        end
        if woodText > Wood then
            self._woodBuildingText.text = "<color=#E2BD75FF>木材</color> ".." <color=#a2341f>"..woodText.."</color>".."/".."<color=#E2BD75FF>"..Wood.."</color>";
        else
            self._woodBuildingText.text = "<color=#E2BD75FF>木材</color> ".." <color=#FFFFFFFF>"..woodText.."</color>".."/".."<color=#E2BD75FF>"..Wood.."</color>";
        end
        if ironText > Iron then 
            self._ironBuildingText.text = "<color=#E2BD75FF>铁矿</color> ".." <color=#a2341f>"..ironText.."</color>".."/".."<color=#E2BD75FF>"..Iron.."</color>"; 
        else
            self._ironBuildingText.text = "<color=#E2BD75FF>铁矿</color> ".." <color=#FFFFFFFF>"..ironText.."</color>".."/".."<color=#E2BD75FF>"..Iron.."</color>"; 
        end
        if stoneText > Stone then
            self._stornBuildingText.text = "<color=#E2BD75FF>石料</color> ".." <color=#a2341f>"..stoneText.."</color>".."/".."<color=#E2BD75FF>"..Stone.."</color>";
        else
            self._stornBuildingText.text = "<color=#E2BD75FF>石料</color> ".." <color=#FFFFFFFF>"..stoneText.."</color>".."/".."<color=#E2BD75FF>"..Stone.."</color>";
        end

        self._buildingPlusFirst.text = DataBuilding[40001].TroopsInTown;
        self._buildingPlusLast.text = DataBuilding[40002].TroopsInTown
        self._buildingPlusOneFirst.text = DataBuilding[40001].DurabilityBonus;
        self._buildingPlusOneLast.text = DataBuilding[40002].DurabilityBonus;
        self._timeText.text= "1/5"
        self.currentGrade.text = "Lv1"
        self.endGrade.text = "Lv2"
        
       local timer = DataBuilding[40002].UpgradeCostTime;
       local time =self:TimeFormat(timer/1000)
       self._buildingTimeText.text = " <color=#FFFFFFFF>"..time.."</color>";
        if Wood >= woodText and Iron >= ironText and Stone >= stoneText and count >= orderText then
            self.BuildingConfirm.interactable = true;
        else
            self.BuildingConfirm.interactable = false;
        end

    elseif self._level == 2 then
        self.buildingText.gameObject:SetActive(false)
        local woodText = DataBuilding[40003].UpgradeCostWood
        local ironText = DataBuilding[40003].UpgradeCostIron
        local stoneText = DataBuilding[40003].UpgradeCostStone
        local orderText = DataBuilding[40003].UpgradeCostCommand
        ----print(woodText.."   "..ironText.."  "..stoneText.."     "..orderText)
        if orderText > count then
            self._buildingText.text = "<color=#E2BD75FF>政令</color> ".." <color=#a2341f>"..orderText.."</color>".."/".." <color=#E2BD75FF>"..count.."</color>";
        else
            self._buildingText.text = "<color=#E2BD75FF>政令</color> ".." <color=#FFFFFFFF>"..orderText.."</color>".."/".." <color=#E2BD75FF>"..count.."</color>";
        end
        if woodText > Wood then
            self._woodBuildingText.text = "<color=#E2BD75FF>木材</color> ".." <color=#a2341f>"..woodText.."</color>".."/".."<color=#E2BD75FF>"..Wood.."</color>";
        else
            self._woodBuildingText.text = "<color=#E2BD75FF>木材</color> ".." <color=#FFFFFFFF>"..woodText.."</color>".."/".."<color=#E2BD75FF>"..Wood.."</color>";
        end
        if ironText > Iron then 
            self._ironBuildingText.text = "<color=#E2BD75FF>铁矿</color> ".." <color=#a2341f>"..ironText.."</color>".."/".."<color=#E2BD75FF>"..Iron.."</color>"; 
        else
            self._ironBuildingText.text = "<color=#E2BD75FF>铁矿</color> ".." <color=#FFFFFFFF>"..ironText.."</color>".."/".."<color=#E2BD75FF>"..Iron.."</color>"; 
        end
        if stoneText > Stone then
            self._stornBuildingText.text = "<color=#E2BD75FF>石料</color> ".." <color=#a2341f>"..stoneText.."</color>".."/".."<color=#E2BD75FF>"..Stone.."</color>";
        else
            self._stornBuildingText.text = "<color=#E2BD75FF>石料</color> ".." <color=#FFFFFFFF>"..stoneText.."</color>".."/".."<color=#E2BD75FF>"..Stone.."</color>";
        end
        self._buildingPlusFirst.text = DataBuilding[40002].TroopsInTown
        self._buildingPlusLast.text = DataBuilding[40003].TroopsInTown
        self._buildingPlusOneFirst.text = DataBuilding[40002].DurabilityBonus;
        self._buildingPlusOneLast.text = DataBuilding[40003].DurabilityBonus;
        self._timeText.text= "2/5"
        self.currentGrade.text = "Lv2"
        self.endGrade.text = "Lv3"

        local timer = DataBuilding[40003].UpgradeCostTime;
        local time =self:TimeFormat(timer/1000)
        self._buildingTimeText.text = " <color=#FFFFFFFF>"..time.."</color>";
        if Wood >= woodText and Iron >= ironText and Stone >= stoneText and count >= orderText then
            self.BuildingConfirm.interactable = true;
        else
            self.BuildingConfirm.interactable = false;
        end

    elseif self._level == 3 then
        self.buildingText.gameObject:SetActive(false)
        local woodText = DataBuilding[40004].UpgradeCostWood
        local ironText = DataBuilding[40004].UpgradeCostIron
        local stoneText = DataBuilding[40004].UpgradeCostStone
        local orderText = DataBuilding[40004].UpgradeCostCommand
        if orderText > count then
            self._buildingText.text = "<color=#E2BD75FF>政令</color> ".." <color=#a2341f>"..orderText.."</color>".."/".." <color=#E2BD75FF>"..count.."</color>";
        else
            self._buildingText.text = "<color=#E2BD75FF>政令</color> ".." <color=#FFFFFFFF>"..orderText.."</color>".."/".." <color=#E2BD75FF>"..count.."</color>";
        end
        if woodText > Wood then
            self._woodBuildingText.text = "<color=#E2BD75FF>木材</color> ".." <color=#a2341f>"..woodText.."</color>".."/".."<color=#E2BD75FF>"..Wood.."</color>";
        else
            self._woodBuildingText.text = "<color=#E2BD75FF>木材</color> ".." <color=#FFFFFFFF>"..woodText.."</color>".."/".."<color=#E2BD75FF>"..Wood.."</color>";
        end
        if ironText > Iron then 
            self._ironBuildingText.text = "<color=#E2BD75FF>铁矿</color> ".." <color=#a2341f>"..ironText.."</color>".."/".."<color=#E2BD75FF>"..Iron.."</color>"; 
        else
            self._ironBuildingText.text = "<color=#E2BD75FF>铁矿</color> ".." <color=#FFFFFFFF>"..ironText.."</color>".."/".."<color=#E2BD75FF>"..Iron.."</color>"; 
        end
        if stoneText > Stone then
            self._stornBuildingText.text = "<color=#E2BD75FF>石料</color> ".." <color=#a2341f>"..stoneText.."</color>".."/".."<color=#E2BD75FF>"..Stone.."</color>";
        else
            self._stornBuildingText.text = "<color=#E2BD75FF>石料</color> ".." <color=#FFFFFFFF>"..stoneText.."</color>".."/".."<color=#E2BD75FF>"..Stone.."</color>";
        end
        local timer = DataBuilding[40004].UpgradeCostTime;
        local time =self:TimeFormat(timer/1000)
        self._buildingTimeText.text = " <color=#FFFFFFFF>"..time.."</color>";
        self._buildingPlusFirst.text = DataBuilding[40003].TroopsInTown
        self._buildingPlusLast.text = DataBuilding[40004].TroopsInTown
        self._buildingPlusOneFirst.text = DataBuilding[40003].DurabilityBonus;
        self._buildingPlusOneLast.text = DataBuilding[40004].DurabilityBonus;
        self._timeText.text= "3/5"
        self.currentGrade.text = "Lv3"
        self.endGrade.text = "Lv4"


    if Wood >= woodText and Iron >= ironText and Stone >= stoneText and count >= orderText then
        self.BuildingConfirm.interactable = true;
    else
        self.BuildingConfirm.interactable = false;
    end
    elseif self._level == 4 then
        self.buildingText.gameObject:SetActive(false)
        local woodText = DataBuilding[40005].UpgradeCostWood
        local ironText = DataBuilding[40005].UpgradeCostIron
        local stoneText = DataBuilding[40005].UpgradeCostStone
        local orderText = DataBuilding[40005].UpgradeCostCommand
        if orderText > count then
            self._buildingText.text = "<color=#E2BD75FF>政令</color> ".." <color=#a2341f>"..orderText.."</color>".."/".." <color=#E2BD75FF>"..count.."</color>";
        else
            self._buildingText.text = "<color=#E2BD75FF>政令</color> ".." <color=#FFFFFFFF>"..orderText.."</color>".."/".." <color=#E2BD75FF>"..count.."</color>";
        end
        if woodText > Wood then
            self._woodBuildingText.text = "<color=#E2BD75FF>木材</color> ".." <color=#a2341f>"..woodText.."</color>".."/".."<color=#E2BD75FF>"..Wood.."</color>";
        else
            self._woodBuildingText.text = "<color=#E2BD75FF>木材</color> ".." <color=#FFFFFFFF>"..woodText.."</color>".."/".."<color=#E2BD75FF>"..Wood.."</color>";
        end
        if ironText > Iron then 
            self._ironBuildingText.text = "<color=#E2BD75FF>铁矿</color> ".." <color=#a2341f>"..ironText.."</color>".."/".."<color=#E2BD75FF>"..Iron.."</color>"; 
        else
            self._ironBuildingText.text = "<color=#E2BD75FF>铁矿</color> ".." <color=#FFFFFFFF>"..ironText.."</color>".."/".."<color=#E2BD75FF>"..Iron.."</color>"; 
        end
        if stoneText > Stone then
            self._stornBuildingText.text = "<color=#E2BD75FF>石料</color> ".." <color=#a2341f>"..stoneText.."</color>".."/".."<color=#E2BD75FF>"..Stone.."</color>";
        else
            self._stornBuildingText.text = "<color=#E2BD75FF>石料</color> ".." <color=#FFFFFFFF>"..stoneText.."</color>".."/".."<color=#E2BD75FF>"..Stone.."</color>";
        end
        self._buildingPlusFirst.text = DataBuilding[40004].TroopsInTown
        self._buildingPlusLast.text = DataBuilding[40005].TroopsInTown
        self._buildingPlusOneFirst.text = DataBuilding[40004].DurabilityBonus;
        self._buildingPlusOneLast.text = DataBuilding[40005].DurabilityBonus;
        self._timeText.text= "4/5"
        self.currentGrade.text = "Lv4"
        self.endGrade.text = "Lv5"

        local timer = DataBuilding[40005].UpgradeCostTime;
        local time =self:TimeFormat(timer/1000)
        self._buildingTimeText.text = " <color=#FFFFFFFF>"..time.."</color>";
        if Wood >= woodText and Iron >= ironText and Stone >= stoneText and count >= orderText then
            self.BuildingConfirm.interactable = true;
        else
            self.BuildingConfirm.interactable = false;
        end

    elseif self._level == 5 then
        local woodText = DataBuilding[40005].UpgradeCostWood
        local ironText = DataBuilding[40005].UpgradeCostIron 
        local stoneText = DataBuilding[40005].UpgradeCostStone
        local orderText = DataBuilding[40005].UpgradeCostCommand
        --print(woodText.."   "..ironText.."  "..stoneText.."     "..orderText)
     --   self.BuildingDemand.gameObject:SetActive(false);
        self._buildingText.text = "<color=#E2BD75FF>政令</color> ".." <color=#FFFFFFFF>"..orderText.."</color>".."/".." <color=#E2BD75FF>"..count.."</color>";
        self._woodBuildingText.text = "<color=#E2BD75FF>木材</color> ".." <color=#FFFFFFFF>"..woodText.."</color>".."/".."<color=#E2BD75FF>"..Wood.."</color>";
        self._ironBuildingText.text = "<color=#E2BD75FF>铁矿</color> ".." <color=#FFFFFFFF>"..ironText.."</color>".."/".."<color=#E2BD75FF>"..Iron.."</color>";
        self._stornBuildingText.text = "<color=#E2BD75FF>石料</color> ".." <color=#FFFFFFFF>"..stoneText.."</color>".."/".."<color=#E2BD75FF>"..Stone.."</color>";
        self._buildingPlusFirst.text = DataBuilding[40005].TroopsInTown
        self._buildingPlusLast.text = "--"
        self._buildingPlusOneFirst.text = DataBuilding[40005].DurabilityBonus;
        self._buildingPlusOneLast.text = "--"
        self._timeText.text= "5/5"
        self.currentGrade.text = "Lv5"
        self.endGrade.text = "Lv5"
        self.buildingText.gameObject:SetActive(true)
        self.buildingText.text = "--已达到最高级--"
        -- self._buildingTimeText.gameObject:SetActive(false);
        self.updateIcon.gameObject:SetActive(false);
        self.BuildingConfirm.gameObject:SetActive(false);
        self._buildingTimeText.gameObject:SetActive(false);
    end
    end
end


--点击升级
function UIUpgradeBuilding:OnClickBuildingConfirm()
    local building = BuildingService:Instance():GetBuildingByTiledId(self.curTiledIndex);
    if building == nil then
        UIService:Instance():HideUI(UIType.UIUpgradeBuilding)
        UIService:Instance():HideUI(UIType.UIMainCity);
        UIService:Instance():ShowUI(UIType.UIGameMainView)
        return
    end
    local playerFortBuildingId=PlayerService:Instance():GetPlayerFort(self.curTiledIndex)._id;
    local msg = require("MessageCommon/Msg/C2L/Building/UpgradePlayerFort").new();
    msg:SetMessageId(C2L_Building.UpgradePlayerFort);
    msg.buildingId = playerFortBuildingId;
    msg.tiledIndex = self.curTiledIndex
    NetService:Instance():SendMessage(msg);
    self.BuildingDemand1.gameObject:SetActive(true);
    self.BuildingDemand.gameObject:SetActive(false);
    --self._buildingTimeText.text = self:Timer(time);

end

--立即升级
function UIUpgradeBuilding:OnClickPromptlyFulfill()
    local building = BuildingService:Instance():GetBuildingByTiledId(self.curTiledIndex);
    if PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Jade):GetValue() < 20 or self._level == 5  then
        self._promptlyFulfill.interactable = false;
        return;
    end
    local playerFortBuildingId=PlayerService:Instance():GetPlayerFort(self.curTiledIndex)._id;
    local msg = require("MessageCommon/Msg/C2L/Building/UpgradePromptlyPlayerFort").new();
    msg:SetMessageId(C2L_Building.UpgradePromptlyPlayerFort);
    msg.buildingId = playerFortBuildingId;
    msg.tiledIndex = self.curTiledIndex
    NetService:Instance():SendMessage(msg);
end

function UIUpgradeBuilding:PromptleFun()
    --print("show   +++++++")
    if self.upgradeTimer ~= nil then
        self.upgradeTimer:Stop();
    end
    self.BuildingDemand.gameObject:SetActive(true);
    self.BuildingDemand1.gameObject:SetActive(false);
    local level = BuildingService:Instance():GetBuildingByTiledId(self.curTiledIndex)._fortGrade;
    self.currentGrade.text = "Lv."..level;
    self.endGrade.text = "Lv."..level+1;
    self:_Complete();
    self.texts.gameObject:SetActive(false);
end


--拆除要塞
function UIUpgradeBuilding:OnClickDemolitionBtn()
    local building = BuildingService:Instance():GetBuildingByTiledId(self.curTiledIndex);
    local paramT = {}
    paramT[1] = "是否确认放弃要塞?";
    paramT[2] = "成功放弃后,将失去本要塞所有功能.驻扎部队会撤回所属城市,征兵将直接取消";
    paramT[3] = true;
    paramT[4] = true;
    paramT[6] = "确认"
    UIService:Instance():ShowUI(UIType.MessageBox, paramT);
    MessageBox:Instance():RegisterOk( function()
        self:CallBackOK();
    end );

end

function UIUpgradeBuilding:CallBackOK()
    local playerFortBuildingId=PlayerService:Instance():GetPlayerFort(self.curTiledIndex)._id;
    local msg = require("MessageCommon/Msg/C2L/Building/RemoveFort").new();
    msg:SetMessageId(C2L_Building.RemoveFort);
    msg.buildingId = playerFortBuildingId;
    msg.index = self.curTiledIndex
    NetService:Instance():SendMessage(msg);
    UIService:Instance():HideUI(UIType.UIUpgradeBuilding);
    UIService:Instance():ShowUI(UIType.UIDeleteFort, self.curTiledIndex)
end

-- 关闭
function UIUpgradeBuilding:OnClickCloseBtn()
    local building = BuildingService:Instance():GetBuildingByTiledId(self.curTiledIndex);
    UIService:Instance():HideUI(UIType.UIUpgradeBuilding)
    EventService:Instance():TriggerEvent(EventType.fortRenovation);

    local baseClass = UIService:Instance():GetUIClass(UIType.UIMainCity);
    local isopen = UIService:Instance():GetOpenedUI(UIType.UIMainCity);
    if baseClass ~= nil and isopen == true then
        baseClass:SetDuration()
    end
end

--倒计时
function UIUpgradeBuilding:ShowUpgradeState()
    --print("进来了吗                               444444444444444444444444444444444444444444444444444444444444444444444")
    local building = BuildingService:Instance():GetBuildingByTiledId(self.curTiledIndex)
    if building == nil then
        return
    end
    -- if building._upgradeFortTime == 0 then
    --     return
    -- end
    if self.timerShow ~= nil then
        self._imagepanel.gameObject:SetActive(false)
        self.timerShow:Stop()
    end
    if self.upgradeTimer ~= nil then
        self.texts.gameObject:SetActive(false);
        self.upgradeTimer:Stop()
    end
    if building._upgradeFortTime - PlayerService:Instance():GetLocalTime() > 0 then
        self:ShowComplete();
        self.BuildingDemand1.gameObject:SetActive(true);
        self.BuildingDemand.gameObject:SetActive(false);
        self.upgradeInterval = building._upgradeFortTime - PlayerService:Instance():GetLocalTime()
        ----print(upgradeInterval);
        self:TimeDown(building)
        self.upgradeTimer = Timer.New(function ()
            --self.offset = -1 * self.offset
            local curInterval = building._upgradeFortTime - PlayerService:Instance():GetLocalTime()
            self._imagepanel.gameObject:SetActive(true)
            self._imagepanel.fillAmount = curInterval / self.upgradeInterval ;
            -- local position = self.updateIcon.transform.localPosition
            -- self.updateIcon.transform.localPosition = Vector3.New(position.x, position.y + self.offset, 0)
            if curInterval < 0 then
                self:_Complete()
                self.upgradeTimer:Stop();
            end
        end, 1, -1, false)
        self.upgradeTimer:Start()
    else
        self:_Complete()
        if self.timerShow ~= nil then 
            self.timerShow:Stop()
        end
        if self.upgradeTimer ~= nil then
            self.upgradeTimer:Stop()
        end
    end
    local baseClass = UIService:Instance():GetUIClass(UIType.UIMainCity);
    local isopen = UIService:Instance():GetOpenedUI(UIType.UIMainCity);
    if baseClass ~= nil and isopen == true then
        baseClass:RefreshBuildQueues()
    end

end

-- 升级倒计时
function UIUpgradeBuilding:TimeDown(building)
    local cdTime = math.floor((building._upgradeFortTime - PlayerService:Instance():GetLocalTime())/1000);
    self.texts.text = CommonService:Instance():GetDateString(cdTime);
    self.texts.gameObject:SetActive(true);
    CommonService:Instance():TimeDown(nil,building._upgradeFortTime,self.texts,function() self.texts.gameObject:SetActive(false) end);
end


function UIUpgradeBuilding:_Complete()
    --print("show   ----")
    if self._level == 5 then
        self.BuildingDemand.gameObject:SetActive(false);
    else
        self.BuildingDemand.gameObject:SetActive(true);
    end

    self.BuildingDemand1.gameObject:SetActive(false);
    self._imagepanel.gameObject:SetActive(false);
    self.updateIcon.gameObject:SetActive(false);
end

function UIUpgradeBuilding:ShowComplete()
    self._imagepanel.fillAmount = 1;
    self._imagepanel.gameObject:SetActive(true);
    self.texts.gameObject:SetActive(true);
    self.updateIcon.gameObject:SetActive(true);
end

function UIUpgradeBuilding:TimeFormat(time)
    local h = math.floor(time / 3600);
    local m = math.floor((time % 3600) / 60);
    local s = time % 3600 % 60;
    local timeText = string.format("%02d:%02d:%02d",h, m, s);
    return timeText;
end

-- 取消升级
function UIUpgradeBuilding:OnClickUpgradeBtn()
    UIService:Instance():ShowUI(UIType.UIDeleteFortCancelMarchAffirm, self.curTiledIndex)
end

function UIUpgradeBuilding:hideBox()
    self.texts.gameObject:SetActive(false);
    self:_Complete()
    if self.timerShow ~= nil then 
        self.timerShow:Stop()
    end
    if self.upgradeTimer ~= nil then
        self.upgradeTimer:Stop()
    end

end

function UIUpgradeBuilding:Fortexplicit()
    self.BuildingDemand1.gameObject:SetActive(false);
    self.BuildingDemand.gameObject:SetActive(true);
    self:SetFortResources()
end

return UIUpgradeBuilding