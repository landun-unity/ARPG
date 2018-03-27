--[[
	部队管理
--]]
local GamePart = require("FrameWork/Game/GamePart")
local MapService = require("Game/Map/MapService")
local LayerType = require("Game/Map/LayerType")
local ArmyState = require("Game/Army/ArmyState")
local EventService = require("Game/Util/EventService")
local EventType = require("Game/Util/EventType")
local ArmyDynamicInfoType = require("Game/Army/Model/ArmyDynamicInfoType")
local DataConscriptionResources = require("Game/Table/model/DataConscriptionResources");
local DataAbilityBonus = require("Game/Table/model/DataAbilityBonus");
require("Game/Hero/HeroService");
local ArmyManage = class("ArmyManage", GamePart)
require("Game/Army/ArmySlotType");


require("Game/Army/ArmyState")
require("Game/Army/ArmySlotType")


-- 构造函数
function ArmyManage:ctor( )
	ArmyManage.super.ctor(self);

    self._requestTimer = nil;
    self._targetTiledIndex = 0;
    self._isShow = true;

    self.parent = nil;

    -- 临时测试部队状态
    self.tempArmyState = nil
    -- 部队当前行为
    self.curArmyBehavior = nil

    self._csCostTable = { };    
    
    self.soldierAdditionTable ={};              --兵种加成表数据
    self.campAdditionTable ={};                 --阵营加成表数据
end

-- 初始化
function ArmyManage:_OnInit()
    --初始化读表 DataConscriptionResources （部队卡牌征兵消耗用）
	self:InitConscriptionResourcesTable();
    --初始化读表 DataAbilityBonus (部队兵种、阵营加成)      
    self:InitAbilityBonusTable();               
end

-- 初始化table : DataConscriptionResources
function ArmyManage:InitConscriptionResourcesTable()
    for k,v in pairs(DataConscriptionResources) do
        if self._csCostTable[v.Star] ~= nil then
            if self._csCostTable[v.Star][v.Camp] ~= nil then
                self._csCostTable[v.Star][v.Camp][v.ArmyType] = v;
            else
                self._csCostTable[v.Star][v.Camp] = {};
                if self._csCostTable[v.Star][v.Camp][v.ArmyType] == nil then
                    self._csCostTable[v.Star][v.Camp][v.ArmyType] = v;
                end
            end
        else
            self._csCostTable[v.Star] = {};
            self._csCostTable[v.Star][v.Camp] = {};
            if self._csCostTable[v.Star][v.Camp][v.ArmyType] == nil then
                self._csCostTable[v.Star][v.Camp][v.ArmyType] = v;
            end
        end
    end
end

-- 初始化table : DataAbilityBonus
function ArmyManage:InitAbilityBonusTable()
    for k,v in pairs(DataAbilityBonus) do      
        if v.ArmyType ~= 0 then 
            if self.soldierAdditionTable[v.ArmyType] == nil then 
                self.soldierAdditionTable[v.ArmyType] = v;
            end
        end
        if v.CampType ~= 0 then 
            if self.campAdditionTable[v.CampType] == nil then 
                self.campAdditionTable[v.CampType] = v;
            end
        end
    end
end

-- 同步线信息
function ArmyManage:_SyncLineInfo(param)
    self._targetTiledIndex = param.targetTiledIndex
	self.cdTime = math.floor(param.marchTime/1000)
	self.marchTimer = Timer.New(function()
			self.cdTime = self.cdTime > 0 and self.cdTime - 1 or 0
			if self.cdTime == 0 then
                if self.tempArmyState == ArmyState.MitaRoad then
                    self:RequestArmyDynamicInfo(ArmyDynamicInfoType.FarmmingTime)
                    self.curArmyBehavior = ArmyState.MitaIng
                    self:StartBehavior(ArmyState.MitaIng)
                elseif self.tempArmyState == ArmyState.TrainingRoad then
                    self:RequestArmyDynamicInfo(ArmyDynamicInfoType.TrainingTime)
                    self.curArmyBehavior = ArmyState.Training
                    self:StartBehavior(ArmyState.Training)
                elseif self.tempArmyState == ArmyState.GarrisonRoad then
                    self.curArmyBehavior = ArmyState.GarrisonIng
                    self:StartBehavior(ArmyState.GarrisonIng)
                end
				self.marchTimer:Stop()
			end
		end, 1, -1, false)
	self.marchTimer:Start()
end


-- 开始屯田
function ArmyManage:StartBehavior(armyState)
    -- self:ShowArmyState(armyState)
    -- -- 注册部队状态事件监听
    -- EventService:Instance():AddEventListener(EventType.ArmyStateReq,function( ... )
    --     if self.tempArmyState == ArmyState.Back then
    --         if self.curArmyBehavior == ArmyState.MitaIng then
    --             self:RequestArmyDynamicInfo(ArmyDynamicInfoType.FarmmingResource)
    --         elseif self.curArmyBehavior == ArmyState.Training then
    --             print("请求练兵经验")
    --         end
    --         -- 返回路上
    --         GameResFactory.Instance():DestroyOldChid(self.parent.gameObject)
    --         --self._isShow = true
    --     end
    -- end)
end


-- 不停的向服务器请求部队信息
-- function ArmyManage:_ArmyStateRequest()
--     self._requestTimer = Timer.New(function()
--         --self:_SendArmyStateRequest()
--     end, 2, -1, false)
--     self._requestTimer:Start()
-- end

-- 发送请求部队状态消息
-- function ArmyManage:_SendArmyStateRequest()
-- 	print("_SendArmyStateRequest............")
-- 	local msg = require("MessageCommon/Msg/C2L/Map/ArmyStateRequest").new();
--     msg:SetMessageId(C2L_Army.ArmyStateRequest);
--     msg.buildingId = 3000;
--     msg.index = 1;
--     NetService:Instance():SendMessage(msg); 
-- end

-- 处理部队屯田逻辑
-- function ArmyManage:ArmyFarmming(param)
--     if param.armyState == ArmyState.MitaIng then
--         self:ShowArmyState()
--     elseif param.armyState == ArmyState.Back then
--         print("屯田结束.........")
--         self._isShow = true
--         self._requestTimer:Stop()
--     end
-- end


function ArmyManage:ShowArmyState(armyState)
    --self:OnShowArmyState(LayerType.Army, armyState)
end

-- 显示部队状态
function ArmyManage:OnShowArmyState(layerType, armyState)
    --self._isShow = false
    local perfabRes = nil
	if layerType == nil then
        return
    end
    self.parent = MapService:Instance():GetLayerParent(layerType);
    if self.parent == nil then
        return
    end
    if armyState == ArmyState.MitaIng then
        --print("屯田中。。。。。")
        perfabRes = "Map/Farmming"
    elseif armyState == ArmyState.Training then
        --print("练兵中。。。。。")
        perfabRes = "Map/Training"
    elseif armyState == ArmyState.GarrisonIng then
        perfabRes = "Map/Garrisoning"
    else
        return
    end
    GameResFactory.Instance():GetResourcesPrefab(perfabRes, self.parent, function (tileImageObject)
    		self:_OnShowLayer(tileImageObject.transform, self.parent, layerType, self._targetTiledIndex)
        end);
end

-- 显示层
function ArmyManage:_OnShowLayer(tileTransform, parent, layerType ,tiledIndex)
    local x,y = MapService:Instance():GetTiledCoordinate(tiledIndex)
	if tileTransform == nil then
        return;
    end
    tileTransform:SetParent(parent)
    --tiled:SetTiledImage(layerType, tileTransform.gameObject);
    tileTransform.localPosition = MapService:Instance():GetTiledPositionByIndex(tiledIndex);
    tileTransform.localScale = Vector3.one;
end

-- 同步部队信息
function ArmyManage:HandlerArmyBaseInfo(msg)
    -- 触发事件
    self.tempArmyState = msg.state
    --print("部队状态 == " .. self.tempArmyState)
    EventService:Instance():TriggerEvent(EventType.ArmyStateReq)
    local building = BuildingService.Instance():GetBuilding(msg.spawnBuilding);
    --print("_____________msg.SpawnBuilding:     "..msg.spawnBuilding.."  msg.SpawnSlotId"..msg.spawnSlotId.."  msg.State: "..msg.state);
    if building == nil then 
        --print("building is nil");
        return;
    end
    local mArmyInfo = building:GetArmyInfo(msg.spawnSlotId+1);
    local herocard1 = HeroService:Instance():GetOwnHeroesById(msg.card1);
    local herocard2 = HeroService:Instance():GetOwnHeroesById(msg.card2);
    local herocard3 = HeroService:Instance():GetOwnHeroesById(msg.card3);

    --print("部队卡牌信息+++++++++++++++++  Card1:"..msg.card1.."  Card2:"..msg.card2.."  Card3:"..msg.card3.." msg.tiledId : "..msg.tiledId);

    --print(msg.farmmingStartTime.." "..msg.farmmingEndTime.." "..msg.trainingStartTime.." "..msg.trainingEndTime.." "..msg.battleStartTime.." "..msg.battleEndTime)

    mArmyInfo:SetArmyBaseInfo(msg.startTiled,msg.endTiled,msg.tiledId,msg.startTime,msg.endTime,msg.slotId,msg.spawnSlotId +1,msg.spawnBuilding,msg.state,msg.curBuildingId
        ,msg.farmmingStartTime,msg.farmmingEndTime,msg.trainingStartTime,msg.trainingEndTime,msg.battleStartTime,msg.battleEndTime,msg.totalTrainingTimes,msg.curTrainingTimes);
    if herocard1 then
        --print("++++++++++++++++++++++++++++++++++++++++++++++"..herocard1.RecoverTime.."  msg.soldier1Count:"..msg.soldier1Count); 
        mArmyInfo:SetCard(ArmySlotType.Back,herocard1,msg.soldier1Count);
        mArmyInfo:SetConscription(ArmySlotType.Back,msg.soldier1ConscriptionStartTime,msg.soldier1ConscriptionCount);
    else
        if mArmyInfo:GetCard(ArmySlotType.Back) then 
            mArmyInfo:RemoveCard(ArmySlotType.Back)
        end
    end 
    if herocard2 then
        --print("++++++++++++++++++++++++++++++++++++++++++++++"..herocard2.RecoverTime.."  msg.soldier2Count:"..msg.soldier2Count);  
        mArmyInfo:SetCard(ArmySlotType.Center,herocard2,msg.soldier2Count);
        mArmyInfo:SetConscription(ArmySlotType.Center,msg.soldier2ConscriptionStartTime,msg.soldier2ConscriptionCount);
    else
        if mArmyInfo:GetCard(ArmySlotType.Center) then 
            mArmyInfo:RemoveCard(ArmySlotType.Center)
        end
    end
    if herocard3 then
        --print("++++++++++++++++++++++++++++++++++++++++++++++"..herocard3.RecoverTime.."  msg.soldier3Count:"..msg.soldier3Count);  
        mArmyInfo:SetCard(ArmySlotType.Front,herocard3,msg.soldier3Count);
        mArmyInfo:SetConscription(ArmySlotType.Front,msg.soldier3ConscriptionStartTime,msg.soldier3ConscriptionCount);
    else
        if mArmyInfo:GetCard(ArmySlotType.Front) then 
            mArmyInfo:RemoveCard(ArmySlotType.Front)
        end
    end 

    --处理拆除分城时，部队在要塞里的逻辑删除部队逻辑
    if  herocard1==nil and herocard2==nil and herocard3==nil then 
        building:RemoveArmyInfo(mArmyInfo);
    end 

    self:HandleAddArmyInBuilding(msg);

    -- if msg.state == ArmyState.TransformRoad or msg.state == ArmyState.TransformArrive then
    --     print("调动")
    --     print(msg.endTiled)
    --     local building = BuildingService:Instance():GetBuildingByTiledId(msg.endTiled);
    --     print(building)
    --     if building ~= nil then
    --         if building._dataInfo.Type == BuildingType.WildFort then
    --             building:SetWildFortArmyInfo(mArmyInfo);
    --             print(building:GetWildFortArmyInfoCounts() .."              +++++++++++++++++++++")
    --         elseif building._dataInfo.Type == BuildingType.PlayerFort then
    --             building:SetArmyInfo(mArmyInfo);
    --             end 
    --         end
    --         --处理拆除分城时，部队在要塞里的逻辑删除部队逻辑
    --          if  herocard1==nil and herocard2==nil and herocard3==nil then 
    --                 building:RemoveArmyInfo(mArmyInfo);
    --     end
    -- end

    -- if msg.state ==  ArmyState.Back then
    --     local building = BuildingService:Instance():GetBuildingByTiledId(msg.startTiled);
    --     if building ~= nil then
    --         if building._dataInfo.Type == BuildingType.PlayerFort then
    --            building:RemoveArmyInfo(mArmyInfo)
    --         elseif building._dataInfo.Type == BuildingType.WildFort then
    --            building:RemoveWildFortArmyInfo(mArmyInfo)
    --            print(building:GetWildFortArmyInfoCounts().."              +++++++++++++++++++++")
    --         end
    --     end
    -- end

    -- if msg.state == ArmyState.TransformRoad then
    --     local building = BuildingService:Instance():GetBuildingByTiledId(msg.startTiled);
    --     if building ~= nil then
    --         if building._dataInfo.Type == BuildingType.PlayerFort then
    --            building:RemoveArmyInfo(mArmyInfo)
    --         elseif building._dataInfo.Type == BuildingType.WildFort then
    --            building:RemoveWildFortArmyInfo(mArmyInfo)
    --            print(building:GetWildFortArmyInfoCounts().."              +++++++++++++++++++++")
    --         end
    --     end
    -- end


end

--设置要塞加入到建筑中
function ArmyManage:HandleAddArmyInBuilding(msg)

    if msg.curBuildingId==msg.spawnBuilding then 
        --print("msg.curBuildingId==msg.spawnBuilding");
        return;
    end 

    local spawnBuilding = BuildingService.Instance():GetBuilding(msg.spawnBuilding);
    local curBuilding = BuildingService.Instance():GetBuilding(msg.curBuildingId);
    
    if curBuilding == nil then
        return
    end

    if curBuilding._dataInfo.Type ~= BuildingType.PlayerFort and curBuilding._dataInfo.Type ~= BuildingType.WildFort and curBuilding._dataInfo.Type ~= BuildingType.WildGarrisonBuilding then
        --print("curBuilding._dataInfo.Type ~= BuildingType.PlayerFort");
        return;
    end 

    --print("_____________msg.SpawnBuilding:     "..msg.spawnBuilding.."  msg.SpawnSlotId"..msg.spawnSlotId.."  msg.State: "..msg.state);
    if curBuilding == nil or spawnBuilding==nil then 
        --print("building is nil");
        return;
    end

    local mArmyInfo = spawnBuilding:GetArmyInfo(msg.spawnSlotId+1);
    curBuilding:SetArmyInfo(mArmyInfo,msg.slotId+1);

end



function ArmyManage:HandlerSyncPlayerFortArmy(msg)

end

--移除卡牌回复,处理掉该卡牌的兵力
function ArmyManage:HandlerArmyRemoveCard(cardId)
    local heroCard = HeroService:Instance():GetOwnHeroesById(cardId);
    if heroCard ~= nil then 
        heroCard:SetCardTroop(0);
    else
        -- print("不科学没有这张卡牌，怎么移除的。。。。")
    end
end

--获取一个城市的所有部队
function ArmyManage:GetCityArmys(cityId)
    local findCity = BuildingService:Instance():GetBuilding(cityId)
    if findCity ~= nil then 
        return findCity.allArmyList;
    else
        return nil;
    end
end

-- 根据索引获取我主城中的部队 index从1开始
function ArmyManage:GetMyArmyInMainCity(index)
    local mainCityTiledId = PlayerService:Instance():GetMainCityTiledId();
    local mainCityId = BuildingService:Instance():GetBuildingByTiledId(mainCityTiledId)._id;
    local mainCity = BuildingService:Instance():GetBuilding(mainCityId);
    local myArmy = mainCity:GetArmyInfo(index)
    return myArmy
end

function ArmyManage:GetArmyInCity(cityId,index)
    local city = BuildingService:Instance():GetBuilding(cityId);
    if city ~= nil then
        return city:GetArmyInfo(index);
    else
        return nil;
    end
end

--判断卡牌是否在某個城市的部队中
function ArmyManage:CheckCardInCityArmy(cardId,cityId)
    local armyInfos = self:GetCityArmys(cityId);
    for  i=1 ,#armyInfos do
        local armyInfo = armyInfos[i];
        if armyInfo ~= nil then 
            if armyInfo:CheckCardInArmy(cardId) then
                return true;
            end
        end
    end 
    return false;
end

--判断与卡牌同tableId的卡是否在某城市队伍中
function ArmyManage:CheckSameCardInInCityArmy(cardTableId,cityId)
    local armyInfos = self:GetCityArmys(cityId);
    for  i=1 ,#armyInfos do
        local armyInfo = armyInfos[i];
        if armyInfo ~= nil then 
            if armyInfo:CheckCardInArmyByTableId(cardTableId) then
                return true;
            end
        end
    end 
    return false;
end

function ArmyManage:GetCardInArmyIndex(cardId,cityId)
    if self:CheckCardInCityArmy(cardId,cityId) == false then
        return;
    end
    local armyInfos = self:GetCityArmys(cityId);
    for  i=1 ,#armyInfos do
        local armyInfo = armyInfos[i];
        if armyInfo ~= nil then 
            if armyInfo:CheckCardInArmy(cardId) then
                return armyInfo.spawnSlotIndex;
            end
        end
    end 
end

--获取城市中配置大营的部队
function ArmyManage:GetHaveBackArmy(cityId)
    local armyInfoList = {}
    local allArmyList = self:GetCityArmys(cityId);
    if allArmyList ~= nil then 
        for  i=1 ,#allArmyList do
            if allArmyList[i] ~= nil then 
                if allArmyList[i]:CheckArmyHaveBackCard() then
                table.insert(armyInfoList, allArmyList[i])
                end
            end
        end
    end
    return armyInfoList;
end

--更新队伍征兵  
function ArmyManage:RefreshArmyConscription(msg)
    --print("msg.buildingId: "..msg.buildingId.."  msg.index:"..msg.index.."   "..msg.backOverTime.."  "..msg.middleOverTime.."  "..msg.frontOverTime.."  "..msg.backCspNum.."  "..msg.middleCspNum.."  "..msg.frontCspNum);
    local building = BuildingService:Instance():GetBuilding(msg.buildingId);
    local army = building:GetArmyInfo(msg.index+1);
    army:SetConscription(ArmySlotType.Back,msg.backOverTime,msg.backCspNum);
    army:SetConscription(ArmySlotType.Center,msg.middleOverTime,msg.middleCspNum);
    army:SetConscription(ArmySlotType.Front,msg.frontOverTime,msg.frontCspNum);
end

--更新队伍立即征兵  
function ArmyManage:RefreshArmyImmediatelyConscription(msg)
    --print("msg.buildingId: "..msg.buildingId.."  msg.index: "..msg.armyindex.."   "..msg.backNowNum.."  "..msg.middleNowNum.."  "..msg.frontNowNum.."  msg.redifNum:"..msg.redifNum);
    local building = BuildingService:Instance():GetBuilding(msg.buildingId);
    local army = building:GetArmyInfo(msg.armyindex+1);
    army:UpdateSoldierCount(ArmySlotType.Back,msg.backNowNum);
    army:UpdateSoldierCount(ArmySlotType.Center,msg.middleNowNum);
    army:UpdateSoldierCount(ArmySlotType.Front,msg.frontNowNum);
    --刷新城市的预备兵数量
    --print("11111   " .. msg.curBuildingId .. "  " .. msg.buildingId)
    local city = BuildingService.Instance():GetBuilding(msg.curBuildingId);
    city:SetBuildingRedif(msg.redifNum);
end

--更新队伍取消征兵  
function ArmyManage:RefreshArmyCancleConscription(msg)
    --print("msg.bulidintId: "..msg.bulidintId.."  msg.index: "..msg.index.."   msg.slotType："..msg.slotType.."  msg.num："..msg.num.."  msg.overTime"..msg.overTime);
    local building = BuildingService:Instance():GetBuilding(msg.bulidintId);
    local army = building:GetArmyInfo(msg.index+1);
    army:UpdateSoldierCount(msg.slotType,msg.num,msg.overTime);
end

-- 请求部队动态信息
function ArmyManage:RequestArmyDynamicInfo(requestType)
    local msg = require("MessageCommon/Msg/C2L/Army/RequestArmyDynamicInfo").new();
    msg:SetMessageId(C2L_Army.RequestArmyDynamicInfo)
    msg.requestType = requestType;
    NetService:Instance():SendMessage(msg); 
end

--获取消耗数据(DataConscriptionResources)
function ArmyManage:GetCSPData(mStar, mCamp, mArmyType)
    if self._csCostTable[mStar] ~= nil  then
        if self._csCostTable[mStar][mCamp] ~= nil then
            if self._csCostTable[mStar][mCamp][mArmyType] ~= nil then
                return self._csCostTable[mStar][mCamp][mArmyType]
            else
                -- print("can't find data mArmyType==nil  which mArmyType="..mArmyType)
            end
        else
                -- print("can't find data mCamp==nil  which mCamp="..mCamp)
        end        
    else
        -- print("can't find data mStar==nil  which star="..mStar)
        return nil;
    end
end

--获取部队兵种加成表数据 (DataAbilityBonus)
function ArmyManage:GetSoldierAdditionData(soldierType)
    if self.soldierAdditionTable[soldierType] ~= nil then 
        return self.soldierAdditionTable[soldierType];
    end
    return nil;
end

--获取部队阵营加成表数据 (DataAbilityBonus)
function ArmyManage:GetCampAdditionData(camp)
    if self.campAdditionTable[camp] ~= nil then 
        return self.campAdditionTable[camp];
    end
    return nil;
end

-- 部队中是否有武将重伤(有武将重伤返回true)
function ArmyManage:IsHaveHeroWound(armyInfo)
    for k,v in pairs(ArmySlotType) do
        if v ~= ArmySlotType.None then
            if armyInfo:CheckArmyCardIsHurt(v) == true then 
                return true;
            end
        end
    end
    return false;
end

-- 部队中是否有武将体力不足(有武将体力不足返回true)
function ArmyManage:IsHaveHeroTired(armyInfo)
    for k,v in pairs(ArmySlotType) do
        if v ~= ArmySlotType.None then
            if armyInfo:CheckArmyCardIsTired(v) == true then
                return true;
            end
        end
    end
    return false
end

--要塞/野外要塞/军营增加一个部队
function ArmyManage:HandlerAddFortArmy(msg)
    -- body
    --     local building = BuildingService.Instance():GetBuilding(msg.spawnBuildingId);
    -- --print("_____________msg.SpawnBuilding:     "..msg.spawnBuilding.."  msg.SpawnSlotId"..msg.spawnSlotId.."  msg.State: "..msg.state);
    -- if building == nil then 
    --     --print("building is nil");
    --     return;
    -- end
    
    -- local mArmyInfo = building:GetArmyInfo(msg.spawnIndex+1);

    -- local curBuilding = BuildingService.Instance():GetBuilding(msg.curBuildingId);

    -- if curBuilding==nil then 
    --     return;
    -- end 

    -- curBuilding:AddArmyInfo(mArmyInfo);

end

--要塞/野外要塞/军营减少一个部队
function ArmyManage:HandlerReduceFortArmy(msg)
    -- body
    --print("ArmyManage:HandlerReduceFortArmy===============================");
    local building = BuildingService.Instance():GetBuilding(msg.spawnBuildingId);
    --print("_____________msg.SpawnBuilding:     "..msg.spawnBuilding.."  msg.SpawnSlotId"..msg.spawnSlotId.."  msg.State: "..msg.state);
    if building == nil then 
        --print("building is nil");
        return;
    end
    
    local mArmyInfo = building:GetArmyInfo(msg.spawnIndex+1);

    local curBuilding = BuildingService.Instance():GetBuilding(msg.curBuildingId);

    if curBuilding==nil then 
        return;
    end 
    --print("remove===========================================");
    --print(curBuilding._dataInfo.Type);
    curBuilding:RemoveArmyInfo(mArmyInfo);

end


return ArmyManage;

