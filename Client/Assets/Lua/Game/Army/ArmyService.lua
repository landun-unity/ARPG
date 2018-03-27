--[[
	部队对外接口
--]]

local GameService = require("FrameWork/Game/GameService")
local ArmyHandler = require("Game/Army/ArmyHandler")
local ArmyManage = require("Game/Army/ArmyManage");
ArmyService = class("ArmyService", GameService)

-- 构造函数
function ArmyService:ctor( )
    ArmyService._instance = self;
    ArmyService.super.ctor(self, ArmyManage.new(), ArmyHandler.new());
end

-- 单例
function ArmyService:Instance()
    return ArmyService._instance;
end

--清空数据
function ArmyService:Clear()
    self._logic:ctor()
end

function ArmyService:OnInit()
    self._logic:_OnInit()
end

-- 根据索引获取我主城中的部队
function ArmyService:GetMyArmyInMainCity(index)
    return self._logic:GetMyArmyInMainCity(index);
end

-- 根据索引获取城市中的部队
function ArmyService:GetArmyInCity(cityId,index)
    return self._logic:GetArmyInCity(cityId,index);
end

--判断卡牌是否在某個城市的部队中
function ArmyService:CheckCardInCityArmy(cardId,cityId)
    return self._logic:CheckCardInCityArmy(cardId,cityId);
end

--判断与卡牌同tableId的卡是否在某城市队伍中
function ArmyService:CheckSameCardInInCityArmy(cardTableId,cityId)
    return self._logic:CheckSameCardInInCityArmy(cardTableId,cityId);
end

--获取在军队中的卡牌的部队位置
function ArmyService:GetCardInArmyIndex(cardId,cityId)
    return self._logic:GetCardInArmyIndex(cardId,cityId);
end

--获取城市中配置大营的队伍列表
function ArmyService:GetHaveBackArmy(cityId)
    return self._logic:GetHaveBackArmy(cityId);
end

--获取卡牌的征兵消耗数据DataConscriptionResources
function ArmyService:GetCardDataConscriptionResources(mStar, mCamp, mArmyType)
    return self._logic:GetCSPData(mStar, mCamp, mArmyType);
end

-- 获取部队兵种加成表数据 (DataAbilityBonus)
function ArmyService:GetSoldierAdditionData(soldierType)
    return self._logic:GetSoldierAdditionData(soldierType);
end

--获取部队阵营加成表数据 (DataAbilityBonus)
function ArmyService:GetCampAdditionData(camp)
     return self._logic:GetCampAdditionData(camp);
end

-- 部队中是否有武将重伤(有武将重伤返回true)
function ArmyService:IsHaveHeroWound(armyInfo)
    return self._logic:IsHaveHeroWound(armyInfo);
end

-- 部队中是否有武将体力不足(有武将体力不足返回true)
function ArmyService:IsHaveHeroTired(armyInfo)
    return self._logic:IsHaveHeroTired(armyInfo);
end

return ArmyService;