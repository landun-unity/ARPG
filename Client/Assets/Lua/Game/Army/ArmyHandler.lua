
--[[
	部队消息处理
--]]
local IOHandler = require("FrameWork/Game/IOHandler")
local ArmyState = require("Game/Army/ArmyState")
local ArmyOperationTipsType = require("Game/Army/Model/ArmyOperationTipsType")
local BattleResultType = require("Game/Army/BattleResultType")
local LoadResourcesPrefab = require("Game/Util/LoadResourcesPrefab")

local ArmyHandler = class("ArmyHandler", IOHandler)
-- 构造函数
function ArmyHandler:ctor()
    -- body
    ArmyHandler.super.ctor(self);
    self._drawLoadResourcesPrefab = LoadResourcesPrefab.new()
end

-- 注册所有消息
function ArmyHandler:RegisterAllMessage()
    self:RegisterMessage(L2C_Army.ArmyBattleReturnMsg, self.GetArmyBattleRes, require("MessageCommon/Msg/L2C/Map/ArmyBattleReturnMsg"));
    self:RegisterMessage(L2C_Army.ArmyGarrisonReturnMsg, self.GetArmyGarrisonRes, require("MessageCommon/Msg/L2C/Map/ArmyGarrisonReturnMsg"));
    self:RegisterMessage(L2C_Army.ArmySweepReturnMsg, self.GetArmySweepRes, require("MessageCommon/Msg/L2C/Map/ArmySweepReturnMsg"));
    self:RegisterMessage(L2C_Army.ArmyTransferomReturnMsg, self.GetArmySTransferomRes, require("MessageCommon/Msg/L2C/Map/ArmyTransferomReturnMsg"));
    self:RegisterMessage(L2C_Army.ArmyTrainingReturnMsg, self.GetArmyTrainingRes, require("MessageCommon/Msg/L2C/Map/ArmyTrainingReturnMsg"));
    self:RegisterMessage(L2C_Army.ArmyFarmmingReturnMsg, self.GetArmyFarmmingRes, require("MessageCommon/Msg/L2C/Map/ArmyFarmmingReturnMsg"));
    self:RegisterMessage(L2C_Army.ArmyRetreatingReturnMsg, self.GetArmyRetreatingRes, require("MessageCommon/Msg/L2C/Map/ArmyRetreatingReturnMsg"));
    self:RegisterMessage(L2C_Army.SyncLineMsg, self.SyncLineInfo, require("MessageCommon/Msg/L2C/Map/SyncLineMsg"));

    self:RegisterMessage(L2C_Army.ArmyConscriptionRespond, self.GetArmyConscriptingRes, require("MessageCommon/Msg/L2C/Army/ArmyConscriptionRespond"));
    self:RegisterMessage(L2C_Army.HeroCardConscriptRespond, self.GetCancelArmyConscriptingRes, require("MessageCommon/Msg/L2C/Army/HeroCardConscriptRespond"));
    self:RegisterMessage(L2C_Army.ArmyImmediateConscriptionRespond, self.GetImmediatelyArmyConscriptingRes, require("MessageCommon/Msg/L2C/Army/ArmyImmediateConscriptionRespond"));

    self:RegisterMessage(L2C_Army.ArmyBaseInfo, self.HandlerArmyBaseInfo, require("MessageCommon/Msg/L2C/Army/ArmyBaseInfo"));
    self:RegisterMessage(L2C_Army.HeroRemoveCardResponse, self.HandlerArmyRemoveCard, require("MessageCommon/Msg/L2C/Army/HeroRemoveCardResponse"));

    self:RegisterMessage(L2C_Army.ArmyMarchTime, self.AcceptArmyMarchTime, require("MessageCommon/Msg/L2C/Army/ArmyMarchTime"));

    self:RegisterMessage(L2C_Army.ArmyOperationTipsMsg, self.AcceptArmyOperationTips, require("MessageCommon/Msg/L2C/Army/ArmyOperationTipsMsg"));

    self:RegisterMessage(L2C_Army.ArmyFarmmingTime, self.AcceptArmyFarmmingTime, require("MessageCommon/Msg/L2C/Army/ArmyFarmmingTime"));

    self:RegisterMessage(L2C_Army.ArmmingTrainingTime, self.AcceptArmmingTrainingTime, require("MessageCommon/Msg/L2C/Army/ArmmingTrainingTime"));

    self:RegisterMessage(L2C_Army.ArmyTrainingExp, self.AcceptArmyTrainingExp, require("MessageCommon/Msg/L2C/Army/ArmyTrainingExp"));

    self:RegisterMessage(L2C_Army.SyncPlayerTroopInfo, self.HandlerSyncPlayerTroopInfo, require("MessageCommon/Msg/L2C/Army/SyncPlayerTroopInfo"));
    self:RegisterMessage(L2C_Army.SyncAllArmy, self.HandlerSyncAllArmy, require("MessageCommon/Msg/L2C/Army/SyncAllArmy"));
    self:RegisterMessage(L2C_Army.SyncPlayerFortArmy, self.HandlerSyncPlayerFortArmy, require("MessageCommon/Msg/L2C/Army/SyncPlayerFortArmy"));

    self:RegisterMessage(L2C_Army.AddFortArmy, self.HandlerAddFortArmy, require("MessageCommon/Msg/L2C/Army/AddFortArmy"));
    self:RegisterMessage(L2C_Army.ReduceFortArmy, self.HandlerReduceFortArmy, require("MessageCommon/Msg/L2C/Army/ReduceFortArmy"));
    --self:RegisterMessage(L2C_Army.GiveUpLandTime, self.HandlerDealGiveUpLandTime,require("MessageCommon/Msg/L2C/Army/GiveUpLandTime"));

end

-- 获取出征结果
function ArmyHandler:GetArmyBattleRes(msg)
    local playerId = msg.playerId
    --print(playerId)
end

-- 获取驻守结果
function ArmyHandler:GetArmyGarrisonRes(msg)
    local playerId = msg.playerId
    --print("驻守" .. playerId)
    -- body
end

-- 获取扫荡结果
function ArmyHandler:GetArmySweepRes(msg)
    local playerId = msg.playerId
    --print("扫荡" .. playerId)
end

-- 获取调动结果
function ArmyHandler:GetArmySTransferomRes(msg)
    local playerId = msg.playerId
    --print("调动" .. playerId)
end

-- 获取练兵结果
function ArmyHandler:GetArmyTrainingRes(msg)
    local playerId = msg.playerId
    --print("练兵" .. playerId)
end

-- 获取屯田结果
function ArmyHandler:GetArmyFarmmingRes(msg)
    local playerId = msg.playerId
    --print("屯田" .. playerId)
end

-- 获取撤退结果
function ArmyHandler:GetArmyRetreatingRes(msg)
    local playerId = msg.playerId
    --print("撤退" .. playerId)
end

-- 队伍功能界面刷新
function ArmyHandler:RefreshArmyFunctionUI(args)
    local baseClass = UIService:Instance():GetUIClass(UIType.ArmyFunctionUI);
    if baseClass ~= nil then
        baseClass:RefreshArmyPart();
        baseClass:RefreshUIShow();
    end
end

--城池界面刷新
function ArmyHandler:RefreshCityObj(args)
    local baseClass = UIService:Instance():GetUIClass(UIType.CityObj);
    local isOpen =  UIService:Instance():GetOpenedUI(UIType.CityObj);
    if baseClass ~= nil then
        baseClass:OnShow();
    end
end

--征兵刷新新
function ArmyHandler:RefreshUIConscription(args)
    local baseClass = UIService:Instance():GetUIClass(UIType.UIConscription);
    local isOpen =  UIService:Instance():GetOpenedUI(UIType.UIConscription);
    if baseClass ~= nil and isOpen == true then        
        baseClass:RefreshResourceData();
        baseClass:CheckConscriptionQueueState();
        baseClass:ShowConscriptionBtnState();
        baseClass:SetArmyInfo();
        baseClass:RefreshAllCost();
    end
end

-- 征兵返回
function ArmyHandler:GetArmyConscriptingRes(msg)
    CommonService:Instance():Play("Audio/GetSoilder")
    self._logicManage:RefreshArmyConscription(msg);
    UIService:Instance():HideUI(UIType.ConscriptionConfirmUI);
    UIService:Instance():HideUI(UIType.UIConscription);
    
    self:RefreshArmyFunctionUI();
    self:RefreshCityObj();
end

-- 立即征兵返回,征兵时间到返回的是HandlerArmyBaseInfo
function ArmyHandler:GetImmediatelyArmyConscriptingRes(msg)
    CommonService:Instance():Play("Audio/GetSoilder")
    self._logicManage:RefreshArmyImmediatelyConscription(msg);
    UIService:Instance():HideUI(UIType.UIConscription);
    self:RefreshArmyFunctionUI();
    self:RefreshCityObj();
    PlayerService:Instance():GetTotalResourceYield();
end

-- 取消征兵返回
function ArmyHandler:GetCancelArmyConscriptingRes(msg)
    self._logicManage:RefreshArmyCancleConscription(msg);
    self:RefreshUIConscription();
    self:RefreshCityObj();
end

-- 同步线信息
function ArmyHandler:SyncLineInfo(msg)
    --print("行军时间" .. msg.marchTime)
    self._logicManage:_SyncLineInfo(msg)
end

-- 部队信息
function ArmyHandler:HandlerArmyBaseInfo(msg)
    LogManager:Instance():Log(" 同步部队信息消息 ArmyHandler:HandlerArmyBaseInfo ！！！！！！！！！！！！！！！！！");
    for k, v in pairs(ArmyState) do
        if v == msg.State then
            --print(k)
        end
    end
    self._logicManage:HandlerArmyBaseInfo(msg.army)
    self:RefreshCityObj();
    self:RefreshUIConscription();
    local baseClass = UIService:Instance():GetUIClass(UIType.ConscriptionConfirmUI);
    local isOpen =  UIService:Instance():GetOpenedUI(UIType.ConscriptionConfirmUI);
    if baseClass ~= nil and isOpen == true then        
        UIService:Instance():HideUI(UIType.ConscriptionConfirmUI);
    end
    self:RefreshArmyFunctionUI();
    PlayerService:Instance():GetTotalResourceYield();
end

function ArmyHandler:RefreshArmyFunctionUI()
    local baseClass = UIService:Instance():GetUIClass(UIType.ArmyFunctionUI);
    local isOpen =  UIService:Instance():GetOpenedUI(UIType.ArmyFunctionUI);
    if baseClass ~= nil and isOpen == true then        
        baseClass:ArmyBaseCallBack();
    end
end

-- 移除卡牌回复
function ArmyHandler:HandlerArmyRemoveCard(msg)
    ----print("移除卡牌回复"..msg.removedCardId);
    self._logicManage:HandlerArmyRemoveCard(msg.removedCardId);
    self:RefreshArmyFunctionUI();
end

function ArmyHandler:HandlerSyncPlayerFortArmy(msg)
    for k, v in pairs(ArmyState) do
        if v == msg.State then
        --print(k)
        end
    end
    self._logicManage:HandlerSyncPlayerFortArmy(msg.army)
end

-- 接收部队行军时间
function ArmyHandler:AcceptArmyMarchTime(msg)
    --print("Army March Time ===" .. msg.marchTime)
end

-- 接收提示消息
function ArmyHandler:AcceptArmyOperationTips(msg)
    if msg.mType == ArmyOperationTipsType.HaveNoBorderLand then
        --print("没有相邻地块。。。")
    end
end


function ArmyHandler:AcceptArmyFarmmingTime(msg)
    --print("屯田时间=======" .. msg.farmmingTime)
end

function ArmyHandler:AcceptArmmingTrainingTime(msg)
    -- body
    --print("练兵时间=======" .. msg.traningTime)
end

function ArmyHandler:AcceptArmyTrainingExp(msg)
    -- body
    --print("练兵经验=======" .. msg.marchTime)
end

-- 同步玩家部队信息
function ArmyHandler:HandlerSyncPlayerTroopInfo(msg)
	for k,v in pairs(BattleResultType) do
		if v == msg.battleResultType then
			--print("战斗结果======" .. k)
		end
	end
    LogManager:Instance():Log("战斗结束同步部队信息:"..msg.backTiredRecoverTime.."  "..msg.midTiredRecoverTime.." "..msg.frontTiredRecoverTime);
    -- 大营武将
    local backHero = HeroService:Instance():GetOwnHeroesById(msg.backHeroId)
    if backHero ~= nil then
    	backHero.level = msg.backHeroLev
    	backHero.exp = msg.backHeroExp
        backHero.point = msg.backHeroPoint
    	backHero.troop = msg.backHeroRemainSoldier
        --print("HandlerSyncPlayerTroopInfo msg.backHeroPower: "..msg.backHeroPower)
        backHero.power:SetValue(msg.backHeroPower);
        backHero.RecoverTime = msg.backWoundRecoverTime
        backHero.TiredTime = msg.backTiredRecoverTime;
        if backHero.RecoverTime > 0 then 
            backHero:SetHurtTimer();
        end
        if backHero.TiredTime > 0 then 
            backHero:SetTiredTimer();
        end
    end    
    -- 中军武将
    local midHero = HeroService:Instance():GetOwnHeroesById(msg.midHeroId)
    if midHero ~= nil then
    	midHero.level = msg.midHeroLev
    	midHero.exp = msg.midHeroExp
    	midHero.point = msg.midHeroPoint
    	midHero.troop = msg.midHeroRemainSoldier
        midHero.power:SetValue(msg.midHeroPower);
        midHero.RecoverTime = msg.midWoundRecoverTime
        midHero.TiredTime = msg.midTiredRecoverTime;
        if midHero.RecoverTime > 0 then 
            midHero:SetHurtTimer();
        end
        if midHero.TiredTime > 0 then 
            midHero:SetTiredTimer();
        end
    end    
    -- 前锋武将
    local frontHero = HeroService:Instance():GetOwnHeroesById(msg.frontHeroId)
    if frontHero ~= nil then
    	frontHero.level = msg.frontHeroLev
    	frontHero.point = msg.frontHeroPoint
    	frontHero.exp = msg.frontHeroExp
    	frontHero.troop = msg.frontHeroRemainSoldier
        frontHero.power:SetValue(msg.frontHeroPower);
        frontHero.RecoverTime = msg.frontWoundRecoverTime
        frontHero.TiredTime = msg.frontTiredRecoverTime;
        if frontHero.RecoverTime > 0 then 
            frontHero:SetHurtTimer();
        end
        if frontHero.TiredTime > 0 then 
            frontHero:SetTiredTimer();
        end
    end
    self:RefreshArmyFunctionUI();    
end

-- 部队信息
function ArmyHandler:HandlerSyncAllArmy(msg)
    local count = msg.allArmyList:Count();
    for i=1,count, 1 do
        self._logicManage:HandlerArmyBaseInfo(msg.allArmyList:Get(i));
    end
    LoginService:Instance():EnterState(LoginStateType.OpenCityFacility);
end

-- 放弃土地时间回复
function ArmyHandler:HandlerDealGiveUpLandTime(msg)
    --print(msg.giveUpTime .. "++++++++++++++++")
    -- local tiledIndex = msg.tiledIndex;
    -- local building = BuildingService:Instance():GetBuildingByTiledId(tiledIndex)
    
    -- local building = BuildingService:Instance():GetBuildingByTiledId(tiledIndex)
    -- if building ~= nil then
    --     local buildingId = building._id;
    --     BuildingService:Instance():DeleteBuilding(buildingId)
    --     BuildingService:Instance():DeleteBuildingTiled(tiledIndex)
    --     PlayerService:Instance():DeleteFort(tiledIndex)
    --     PlayerService:Instance():DeletePlayerFort(building)
    --     local x,y = MapService:Instance():GetTiledCoordinate(tiledIndex)
    --     MapService:Instance():HandleCreateTiled(x,y)
    --     local tiled = MapService:Instance():GetTiledByIndex(tiledIndex);
    --     tiled:DeleteFort();
    --     local UISignObject = PlayerService:Instance():GetFortMap(tiledIndex);
    --     self._drawLoadResourcesPrefab:Recovery(UISignObject);
    --     PlayerService:Instance():RemoveFortMap(tiledIndex)
    --     MapService:Instance():RefreshFortHideTiled(building)
    --     local x,y = MapService:Instance():GetTiledCoordinate(tiledIndex)
    --     MapService:Instance():HandleCreateTiled(x,y)
    -- end

end

function ArmyHandler:HandlerAddFortArmy(msg)
    -- body
    self._logicManage:HandlerAddFortArmy(msg)
end

function ArmyHandler:HandlerReduceFortArmy(msg)
    -- body
    self._logicManage:HandlerReduceFortArmy(msg)
end


return ArmyHandler;