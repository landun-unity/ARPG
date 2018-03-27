local GameService = require("FrameWork/Game/GameService")
local PlayerManage = require("Game/Player/PlayerManage")
local DefaultHandler = require("FrameWork/Game/DefaultHandler")
local CurrencyEnum = require("Game/Player/CurrencyEnum")

PlayerService = class("PlayerService", GameService)

function PlayerService:ctor()
    PlayerService._instance = self;
    PlayerService.super.ctor(self, PlayerManage.new(), DefaultHandler.new());
end


function PlayerService:Instance()
    return PlayerService._instance
end


--清空数据
function PlayerService:Clear()
    self._logic:ctor()
end


-- 设置玩家roleId
function PlayerService:SetSpawnState(SpawnState)
    self._logic:SetSpawnState(SpawnState);
end

-- 设置玩家roleId
function PlayerService:GetSpawnState()
   return self._logic:GetSpawnState();
end


-- 设置玩家roleId
function PlayerService:SetPlayerId(roleId)
    self._logic:SetPlayerId(roleId)
end

-- 获取玩家上级同盟名称
function PlayerService:GetsuperiorName()
    return self._logic:GetsuperiorName()
end
function PlayerService:SetsuperiorName(args)
    self._logic:SetsuperiorName(args)
end

-- 获取Card所在Buidling
function PlayerService:GetCardBuilding(args)
  return  self._logic:GetCardBuilding(args)
end

-- 获取玩家roleId
function PlayerService:GetPlayerId()
    return self._logic:GetPlayerId()
end

-- 设置玩家账号Id
function PlayerService:SetAccountId(accountId)
    self._logic:SetAccountId(accountId)
end


-- 获取玩家账号Id
function PlayerService:GetAccountId()
    return self._logic:GetAccountId()
end

-- 获取名称
function PlayerService:GetName()
    return self._logic:GetName();
end

-- 设置名称
function PlayerService:SetName(name)
    return self._logic:SetName(name);
end

-- 设置同盟名称
function PlayerService:SetLeagueName(args)
    self._logic:SetLeagueName(args)
end

function PlayerService:GetLeagueName()

    return self._logic:GetLeagueName()

end


-- 设置玩家同盟id
function PlayerService:SetLeagueId(_leagueid)
    self._logic:SetLeagueId(_leagueid)
end

function PlayerService:GetLeagueId()

    return self._logic:GetLeagueId()

end

function PlayerService:GetArmyInfoByCardId(cardid)
   return  self._logic:GetArmyInfoByCardId(cardid)
end


-- 设置玩家同盟等级
function PlayerService:GetLeagueLevel()
    -- body
    return self._logic:GetLeagueLevel();
end
function PlayerService:SetLeagueLevel(leagueLevel)
    -- body
    self._logic:SetLeagueLevel(leagueLevel);
end

-- 设置玩家建造队列上限值
function PlayerService:SetConstructionQueueMaxValue(baseMax, tempMax)
    self._logic:SetConstructionQueueMaxValue(baseMax, tempMax);
end

-- 获取玩家基础建造队列上限
function PlayerService:GetPlayerBaseConsMax()
    return self._logic:GetPlayerBaseConsMax();
end

-- 获取玩家临时建造队列上限
function PlayerService:GetPlayerTempConsMax()
    return self._logic:GetPlayerTempConsMax();
end

-- 设置玩家职位
function PlayerService:SetPlayerTitle(_title)

    self._logic:SetPlayerTitle(_title)
end

function PlayerService:GetPlayerTitle()

    return self._logic:GetPlayerTitle()

end

-- 玩家主城id
function PlayerService:SetmainCityId(_mainCityId)

    self._logic:SetmainCityId(_mainCityId)
end

function PlayerService:GetmainCityId()

    return self._logic:GetmainCityId()

end

-- 设置玩家上级信息
function PlayerService:SetsuperiorLeagueId(superiorLeagueId)

    self._logic:SetsuperiorLeagueId(superiorLeagueId)
end

function PlayerService:GetsuperiorLeagueId()

    return self._logic:GetsuperiorLeagueId()

end


-- 添加要塞
function PlayerService:SetPlayerFort(index, fort)
    return self._logic:SetPlayerFort(index, fort)
end
-- 获取要塞
function PlayerService:GetPlayerFort(index)
    return self._logic:GetPlayerFort(index)
end
function PlayerService:GetPlayerFortCount()
    return self._logic:GetPlayerFortCount()
end

function PlayerService:DeleteFort(tiledIndex)
    return self._logic:DeleteFort(tiledIndex)
end

-- 获取建设完成的要塞
function PlayerService:GetSucceedFort(index)
    return self._logic:GetSucceedFort(index);
end

-- 获取建设完成要塞的数量
function PlayerService:GetSucceedFortsCount()
    return self._logic:GetSucceedFortsCount();
end

-- 获取玩家所有建设完成的建筑列表
function PlayerService:GetAllCity()
    return self._logic:GetAllCity();
end

-- 获取玩家所有建设完成的建筑数量
function PlayerService:GetAllCityListCount()
    return self._logic:GetAllCityListCount();
end

-- 根据当前建筑获取在排序列表中的位置
function PlayerService:GetAllCityIndexByBuildingId(buildingId)
    return self._logic:GetAllCityIndexByBuildingId(buildingId);
end

-- 获取上一个建筑
function PlayerService:GetLeftCity(buildingId)
    return self._logic:GetLeftCity(buildingId);
end

-- 获取下一个建筑
function PlayerService:GetRightCity(buildingId)
    return self._logic:GetRightCity(buildingId);
end

function PlayerService:SetFort(fort)
    return self._logic:SetFort(fort)
end
function PlayerService:GetFort(index)
    return self._logic:GetFort(index)
end
function PlayerService:GetFortCount()
    return self._logic:GetFortCount()
end
function PlayerService:DeletePlayerFort(build)
    return self._logic:DeletePlayerFort(build)
end

function PlayerService:SetFortNum(num)
    return self._logic:SetFortNum(num)
end
function PlayerService:GetFortNum()
    return self._logic:GetFortNum()
end

-- 设置主城的格子索引
function PlayerService:SetMainCityTiledId(mainCityTiledId)
    self._logic:SetMainCityTiledId(mainCityTiledId);
end

-- 获取主城的格子Id
function PlayerService:GetMainCityTiledId()
    return self._logic:GetMainCityTiledId();
end

-- 获取木石粮铁等信息
function PlayerService:GetCurrencyVarCalcByKey(currencyEnum)
    return self._logic:GetCurrencyVarCalcByKey(currencyEnum);
end

function PlayerService:SyncLoginServerTime(mTime)
    self._logic:SyncLoginServerTime(mTime);
end

function PlayerService:SetLocalTime(mTime)
    self._logic:SetLocalTime(mTime);
end

-- 得到服务器时间
function PlayerService:GetLocalTime()
    return self._logic:GetLocalTime();
end


-- 获取标记信息
function PlayerService:GetMarkerListByIndex(index)
    return self._logic:GetMarkerListByIndex(index)
end
-- 设置标记信息
function PlayerService:InsertMarkerList(tiledIndex)
    return self._logic:InsertMarkerList(tiledIndex)
end
-- 获取标记信息长度
function PlayerService:GetMarkerCount()
    return self._logic:GetMarkerCount();
end
-- 删除一条标记信息
function PlayerService:DeleteMarker(tiledIndex)
    return self._logic:DeleteMarker(tiledIndex)
end
-- 清空标记列表
function PlayerService:ClearMarker()
    return self._logic:ClearMarker()
    -- body
end


-- 设置标记图标键值段
function PlayerService:InsertMakrerIconMap(index, resTransform)
    return self._logic:InsertMakrerIconMap(index, resTransform);
end
-- 获取标记图标键值段
function PlayerService:GetMarkerIconMap(index)
    return self._logic:GetMarkerIconMap(index);
end
-- 删除标记图标键值段
function PlayerService:RemoveMarkerIconMap(index)
    return self._logic:RemoveMarkerIconMap(index);
end


function PlayerService:SetfinallyCollectionTime(time)
    return self._logic:SetfinallyCollectionTime(time)
end

function PlayerService:GetfinallyCollectionTimeCount()
    return self._logic:GetfinallyCollectionTimeCount()
end

function PlayerService:GetfinallyCollectionTime(index)
    return self._logic:GetfinallyCollectionTime(index)
end


-- 向玩家城市信息列表中添加城市信息
function PlayerService:AddCityToPlayerCityInfoList(cityInfo)
    self._logic:AddCityToPlayerCityInfoList(cityInfo)
end

-- 新建分城加入玩家城市列表！！！临时先这么写
function PlayerService:AddSubCityToPlayerCityInfoList(building)
    self._logic:AddSubCityToPlayerCityInfoList(building)
end

-- 删除玩家分城
function PlayerService:RemoveSubCity(building)
    self._logic:RemoveSubCity(building);
end

-- 获取城市信息数量
function PlayerService:GetCityInfoCount()
    return self._logic:GetCityInfoCount()
end

-- 获取玩家城市列表
function PlayerService:GetPlayerCityList()
    return self._logic:GetPlayerCityList()
end

-- 通过index获取城市信息
function PlayerService:GetCityInfoByIndex(index)
    return self._logic:GetCityInfoByIndex(index)
end

-- 创建要塞时间
function PlayerService:InsertCreateBuildingTime(time)
    return self._logic:InsertCreateBuildingTime(time)
end


function PlayerService:GetCreateBuildingTime(index)
    return self._logic:GetCreateBuildingTime(index)
end

function PlayerService:GetCreateBuildingTimeCount()
    return self._logic:GetCreateBuildingTimeCount();
end

--[[
    操作玩家领地
]]

function PlayerService:AddTiledIdToPlayerTiledList(tiledId)
    return self._logic:AddTiledIdToPlayerTiledList(tiledId);
end

function PlayerService:RemoveTiledIdToPlayerTiledList(tiledId)
    return self._logic:RemoveTiledIdToPlayerTiledList(tiledId);
end

function PlayerService:GetTiledIdListCount()
    -- body
    return self._logic:GetTiledIdListCount();
end

function PlayerService:GetTiledIdByIndex(index)
    -- body
    return self._logic:GetTiledIdByIndex(index);
end

function PlayerService:ClearAllTiledIdFromTiledList()
    -- body
    self._logic:ClearAllTiledIdFromTiledList();
end



-- 判断与卡牌同tableId的卡是否已经在某个城市的队伍中
function PlayerService:CheckSameCardInInCityArmy(cardTableId)
    return self._logic:CheckSameCardInInCityArmy(cardTableId);
end

-- 判断卡牌是否在部队中
function PlayerService:CheckCardInArmy(cardId)
    return self._logic:CheckCardInArmy(cardId);
end

-- 获取卡牌所在的部队(不在部队中返回nil)
function PlayerService:GetCardInArmy(cardId)
    return self._logic:GetCardInArmy(cardId);
end

-- 获取所有城市中所有状态不为NONE的部队
function PlayerService:GetAllNotNoneArmyInfos()
    return self._logic:GetAllNotNoneArmyInfos();
end

-- 判断是否有可以出征的部队
function PlayerService:IsHaveCanSendArmy()
    return self._logic:IsHaveCanSendArmy();
end

-- 创建要塞当前时间
function PlayerService:InsertFortCurrentTime(time)
    return self._logic:InsertFortCurrentTime(time)
end

function PlayerService:GetFortCurrentTime(index)
    return self._logic:GetFortCurrentTime(index)
end

function PlayerService:GetFortCurrentTimeCount()
    return self._logic:GetFortCurrentTimeCount()
end

function PlayerService:InsertFortMap(index, resTransform)
    return self._logic:InsertFortMap(index, resTransform)
end

function PlayerService:GetFortMap(index)
    return self._logic:GetFortMap(index)
end

function PlayerService:RemoveFortMap(index)
    return self._logic:RemoveFortMap(index)
end

function PlayerService:GetProfile()
    return self._logic:GetProfile();
end

function PlayerService:SetProfile(profile)
    self._logic:SetProfile(profile);
end

function PlayerService:SetCollectionGold(gold)
    self._logic:SetCollectionGold(gold)
end

function PlayerService:GetCollectionGold()
    return self._logic:GetCollectionGold();
end

function PlayerService:SetCreateTemporaryFort(build)
    return self._logic:SetCreateTemporaryFort(build)
end

function PlayerService:GetCreateTemporaryFort(index)
    return self._logic:GetCreateTemporaryFort(index)
end

function PlayerService:GetCreateTemporaryFortCount()
    return self._logic:GetCreateTemporaryFortCount()
end

function PlayerService:GetInitResourceMax()
    -- body
    return self._logic:GetInitResourceMax();
end

-- 是否是我的城市
function PlayerService:IsMyCity(buildingIndex)
    return self._logic:IsMyCity(buildingIndex)
end

function PlayerService:AddTiledDurableInfoToList(tiledDurableInfo)
    return self._logic:AddTiledDurableInfoToList(tiledDurableInfo);
end

function PlayerService:RemoveTiledDurableInfoToList(tiledDurableInfo)
    return self._logic:RemoveTiledDurableInfoToList(tiledDurableInfo);
end

function PlayerService:GetTiledDurableListCount()
    -- body
    return self._logic:GetTiledDurableListCount();
end

function PlayerService:GetTiledDurableByIndex(index)
    -- body
    return self._logic:GetTiledDurableByIndex(index);
end

function PlayerService:ClearAllTiledDurableFromTiledList()
    -- body
    self._logic:ClearAllTiledDurableFromTiledList();
end



function PlayerService:AddTiledInfoToList(tiledInfo)
    return self._logic:AddTiledInfoToList(tiledInfo);
end

function PlayerService:GetTiledInfoListCount()
    -- body
    return self._logic:GetTiledInfoListCount();
end

function PlayerService:GetTiledInfoByIndex(index)
    -- body
    return self._logic:GetTiledInfoByIndex(index);
end

function PlayerService:ClearAllTiledInfoFromTiledList()
    -- body
    self._logic:ClearAllTiledInfoFromTiledList();
end

function PlayerService:RemoveOneTiledInfoFromTiledList(index)
    -- body
    self._logic:RemoveOneTiledInfoFromTiledList(index);
end
function PlayerService:GetAllTiledList()
    return self._logic:GetAllTiledList();
end



function PlayerService:SetClickRevenueGold(gold)
    return self._logic:SetClickRevenueGold(gold)
end
function PlayerService:GetClickRevenueGold()
    return self._logic:GetClickRevenueGold()
end

function PlayerService:SetRevenueCount(count)
    return self._logic:SetRevenueCount(count)
end
function PlayerService:GetRevenueCount()
    return self._logic:GetRevenueCount()
end

function PlayerService:SetRevenuefinishTime(time)
    return self._logic:SetRevenuefinishTime(time)
end
function PlayerService:GetRevenuefinishTime()
    return self._logic:GetRevenuefinishTime()
end

function PlayerService:SetForceRevenueCount(count)
   return self._logic:SetForceRevenueCount(count)
end
function PlayerService:GetForceRevenueCount()
    return self._logic:GetForceRevenueCount()
end




function PlayerService:SetOneGold(gold)
    return self._logic:SetOneGold(gold)
end
function PlayerService:GetOneGold()
    return self._logic:GetOneGold()
end

function PlayerService:SetTwoGold(gold)
    return self._logic:SetTwoGold(gold)
end
function PlayerService:GetTwoGold()
    return self._logic:GetTwoGold()
end

function PlayerService:SetThreeGold(gold)
    return self._logic:SetThreeGold(gold)
end
function PlayerService:GetThreeGold()
    return self._logic:GetThreeGold()
end

function PlayerService:SetOneTime(time)
    return self._logic:SetOneTime(time)
end
function PlayerService:GetOneTime()
    return self._logic:GetOneTime()
end

function PlayerService:SetTwoTime(time)
    return self._logic:SetTwoTime(time)
end
function PlayerService:GetTwoTime()
    return self._logic:GetTwoTime()
end

function PlayerService:SetThreeTime(time)
    return self._logic:SetThreeTime(time)
end
function PlayerService:GetThreeTime()
    return self._logic:GetThreeTime()
end

function PlayerService:SetForcedCount(count)
    return self._logic:SetForcedCount(count)
end
function PlayerService:GetForcedCounts()
    return self._logic:GetForcedCounts()
end

function PlayerService:SetSecondCanClaimTime(time)
    return self._logic:SetSecondCanClaimTime(time)
end
function PlayerService:GetSecondCanClaimTime()
    return self._logic:GetSecondCanClaimTime()
end

function PlayerService:SetthirdCanClaimTime(time)
    return self._logic:SetthirdCanClaimTime(time)
end
function PlayerService:GetThirdCanClaimTime()
    return self._logic:GetThirdCanClaimTime()
end

function PlayerService:SetSurplusReceiveCount(surplusReceiveCount)
    return self._logic:SetSurplusReceiveCount(surplusReceiveCount)
end
function PlayerService:GetSurplusReceiveCount()
    return self._logic:GetSurplusReceiveCount()
end
function PlayerService:DeleteSurplusReceiveCount()
    return self._logic:DeleteSurplusReceiveCount()
end

function PlayerService:SetIntroductionsRevenueGold(gold)
    return self._logic:SetIntroductionsRevenueGold(gold)
end
function PlayerService:GetIntroductionsRevenueGold()
    return self._logic:GetIntroductionsRevenueGold()
end

function PlayerService:SetWildCityRevenueGold(gold)
    return self._logic:SetWildCityRevenueGold(gold)
end
function PlayerService:GetWildCityRevenueGold()
    return self._logic:GetWildCityRevenueGold()
end

function PlayerService:GetDecreeSystem()
    -- body
    return self._logic:GetDecreeSystem();
end

function PlayerService:GetBuyDecreeDays()
    -- body
    return self._logic:GetBuyDecreeDays();
end

function PlayerService:SetBuyDecreeDays(value)
    -- body
    self._logic:SetBuyDecreeDays(value);
end

function PlayerService:GetBuyDecreeTimes()
    -- body
    return self._logic:GetBuyDecreeTimes();
end

function PlayerService:SetBuyDecreeTimes(value)
    -- body
    self._logic:SetBuyDecreeTimes(value);
end

function PlayerService:GetWoodYield()
    return self._logic:GetWoodYield()
end

function PlayerService:GetIronYield()
    return self._logic:GetIronYield()
end

function PlayerService:GetStoneYield()
    return self._logic:GetStoneYield()
end

function PlayerService:GetFoodYield()
    return self._logic:GetFoodYield()
end

function PlayerService:CheckFoodIsMinus(subCount)
    return self._logic:CheckFoodIsMinus(subCount);
end

-- 获取资源产量
function PlayerService:GetResourceOutput(currencyEnum)
    return self._logic:GetResourceOutput(currencyEnum)
end

function PlayerService:GetTotalResourceYield()
    self._logic:GetTotalResourceYield();
end

function PlayerService:SetMarker(Marker)
    self._logic:SetMarker(Marker);
end

function PlayerService:GetMarker(index)
    return self._logic:GetMarker(index)
end

function PlayerService:GetMarkerCt()
    return self._logic:GetMarkerCt()
end

function PlayerService:DeleteMarkers(tiledIndex)
    self._logic:DeleteMarkers(tiledIndex);
end

function PlayerService:SetMarkerMap(marker,index)
    self._logic:SetMarkerMap(marker,index)
end

function PlayerService:GetMarkerMap(index)
    return self._logic:GetMarkerMap(index)
end

function PlayerService:RemoveMarkerMap(index)
    self._logic:RemoveMarkerMap(index)
end

function PlayerService:AddCreateOccupyWildFort(building)
    self._logic:AddCreateOccupyWildFort(building)
end

function PlayerService:GetOccupyWildFort(index)
    return self._logic:GetOccupyWildFort(index)
end

function PlayerService:GetOccupyWildFortCount()
    return self._logic:GetOccupyWildFortCount()
end

function PlayerService:RemoveOccuptWildFortCount(building)
    self._logic:RemoveOccuptWildFortCount(building)
end

function PlayerService:SetOutofGame()
    -- body
    self._logic:SetOutofGame();
end

function PlayerService:GetOutofGame()
    -- body
    return self._logic:GetoutofGame();
end


function PlayerService:SetPlayerIsLogined( )
    -- body
    self._logic:SetPlayerIsLogined();
end

function PlayerService:GetPlayerLoginState()
    return self._logic:GetPlayerLoginState();
end

--增加一个计时器
function PlayerService:AddOneTimer(args)
    self._logic:AddOneTimer(args)
end

--停止全部计时器
function PlayerService:StopAllTimers()
      self._logic:StopAllTimers()
end


function PlayerService:GetHostilityLeagueCount()
    return self._logic:GetHostilityLeagueCount()
end

-- 获取玩家所有分城数量（包括在建中）
function PlayerService:GetAllSubCityCount()
    return self._logic:GetAllSubCityCount();
end

function PlayerService:GetFromSubCityList(index)
    return self._logic:GetFromSubCityList(index)
end


-- 根据声望值和已拥有分城数判断是否可再建分城
function PlayerService:CanCreateSubCityBaseFameValue()
    return self._logic:CanCreateSubCityBaseFameValue();
end

-- 获取资源上限
function PlayerService:GetResourceMax()
    return self._logic:GetResourceMax()
end

function PlayerService:CanCreateFortBaseFameValue()
    return self._logic:CanCreateFortBaseFameValue()
end

function PlayerService:SetIsCanReceive()
    self._logic:SetIsCanReceive()
end

function PlayerService:SetNotCanReceive()
    self._logic:SetNotCanReceive()
end

function PlayerService:GetIsCanReceive()
    return self._logic:GetIsCanReceive();
end

function PlayerService:SetPlayerInfluence(influence)
    self._logic:SetPlayerInfluence(influence)
end

function PlayerService:GetPlayerInfluence()
    return self._logic:GetPlayerInfluence()
end

function PlayerService:SetCertificate(certificate)
    self._logic:SetCertificate(certificate)
end

function PlayerService:GetCertificate()
    return self._logic:GetCertificate()
end

function PlayerService:SetRegionId(regionId)
    self._logic:SetRegionId(regionId)
end

function PlayerService:GetRegionId()
    return self._logic:GetRegionId()
end

function PlayerService:ExitGame()
    self._logic:ExitGame()
end

function PlayerService:SetPlayerChatTimes(time)
    self._logic:SetPlayerChatTimes(time)
end

function PlayerService:GetPlayerChatTimes()
    return self._logic:GetPlayerChatTimes();
end

function PlayerService:AddLeagueRelation(id,type)
    self._logic:AddLeagueRelation(id,type)
end

function PlayerService:GetLeagueRelation( id )
    return self._logic:GetLeagueRelation(id)
end

return PlayerService

