--
-- 逻辑服务器 --> 客户端
-- 同步玩家部队信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SyncPlayerTroopInfo = class("SyncPlayerTroopInfo", GameMessage);

--
-- 构造函数
--
function SyncPlayerTroopInfo:ctor()
    SyncPlayerTroopInfo.super.ctor(self);
    --
    -- 部队战斗状态
    --
    self.battleResultType = 0;
    
    --
    -- 大营武将id
    --
    self.backHeroId = 0;
    
    --
    -- 大营武将等级
    --
    self.backHeroLev = 0;
    
    --
    -- 大营武将升级后剩余经验
    --
    self.backHeroExp = 0;
    
    --
    -- 大营武将升级后剩余点
    --
    self.backHeroPoint = 0;
    
    --
    -- 大营武将剩余兵力
    --
    self.backHeroRemainSoldier = 0;
    
    --
    -- 大营武将剩余体力
    --
    self.backHeroPower = 0;
    
    --
    -- 大营武将重伤恢复时间
    --
    self.backWoundRecoverTime = 0;
    
    --
    -- 大营武将疲劳恢复时间
    --
    self.backTiredRecoverTime = 0;
    
    --
    -- 大营武将id
    --
    self.midHeroId = 0;
    
    --
    -- 中军武将等级
    --
    self.midHeroLev = 0;
    
    --
    -- 中军武将升级后剩余经验
    --
    self.midHeroExp = 0;
    
    --
    -- 中军武将升级后剩余点
    --
    self.midHeroPoint = 0;
    
    --
    -- 中军武将剩余兵力
    --
    self.midHeroRemainSoldier = 0;
    
    --
    -- 中军武将剩余体力
    --
    self.midHeroPower = 0;
    
    --
    -- 中军武将重伤恢复时间
    --
    self.midWoundRecoverTime = 0;
    
    --
    -- 中军武将疲劳恢复时间
    --
    self.midTiredRecoverTime = 0;
    
    --
    -- 大营武将id
    --
    self.frontHeroId = 0;
    
    --
    -- 前锋武将等级
    --
    self.frontHeroLev = 0;
    
    --
    -- 前锋武将升级后剩余经验
    --
    self.frontHeroExp = 0;
    
    --
    -- 前锋武将升级后剩余点
    --
    self.frontHeroPoint = 0;
    
    --
    -- 前锋武将剩余兵力
    --
    self.frontHeroRemainSoldier = 0;
    
    --
    -- 前锋武将剩余体力
    --
    self.frontHeroPower = 0;
    
    --
    -- 前锋武将重伤恢复时间
    --
    self.frontWoundRecoverTime = 0;
    
    --
    -- 前锋武将疲劳恢复时间
    --
    self.frontTiredRecoverTime = 0;
end

--@Override
function SyncPlayerTroopInfo:_OnSerial() 
    self:WriteInt32(self.battleResultType);
    self:WriteInt64(self.backHeroId);
    self:WriteInt32(self.backHeroLev);
    self:WriteInt32(self.backHeroExp);
    self:WriteInt32(self.backHeroPoint);
    self:WriteInt32(self.backHeroRemainSoldier);
    self:WriteInt32(self.backHeroPower);
    self:WriteInt64(self.backWoundRecoverTime);
    self:WriteInt64(self.backTiredRecoverTime);
    self:WriteInt64(self.midHeroId);
    self:WriteInt32(self.midHeroLev);
    self:WriteInt32(self.midHeroExp);
    self:WriteInt32(self.midHeroPoint);
    self:WriteInt32(self.midHeroRemainSoldier);
    self:WriteInt32(self.midHeroPower);
    self:WriteInt64(self.midWoundRecoverTime);
    self:WriteInt64(self.midTiredRecoverTime);
    self:WriteInt64(self.frontHeroId);
    self:WriteInt32(self.frontHeroLev);
    self:WriteInt32(self.frontHeroExp);
    self:WriteInt32(self.frontHeroPoint);
    self:WriteInt32(self.frontHeroRemainSoldier);
    self:WriteInt32(self.frontHeroPower);
    self:WriteInt64(self.frontWoundRecoverTime);
    self:WriteInt64(self.frontTiredRecoverTime);
end

--@Override
function SyncPlayerTroopInfo:_OnDeserialize() 
    self.battleResultType = self:ReadInt32();
    self.backHeroId = self:ReadInt64();
    self.backHeroLev = self:ReadInt32();
    self.backHeroExp = self:ReadInt32();
    self.backHeroPoint = self:ReadInt32();
    self.backHeroRemainSoldier = self:ReadInt32();
    self.backHeroPower = self:ReadInt32();
    self.backWoundRecoverTime = self:ReadInt64();
    self.backTiredRecoverTime = self:ReadInt64();
    self.midHeroId = self:ReadInt64();
    self.midHeroLev = self:ReadInt32();
    self.midHeroExp = self:ReadInt32();
    self.midHeroPoint = self:ReadInt32();
    self.midHeroRemainSoldier = self:ReadInt32();
    self.midHeroPower = self:ReadInt32();
    self.midWoundRecoverTime = self:ReadInt64();
    self.midTiredRecoverTime = self:ReadInt64();
    self.frontHeroId = self:ReadInt64();
    self.frontHeroLev = self:ReadInt32();
    self.frontHeroExp = self:ReadInt32();
    self.frontHeroPoint = self:ReadInt32();
    self.frontHeroRemainSoldier = self:ReadInt32();
    self.frontHeroPower = self:ReadInt32();
    self.frontWoundRecoverTime = self:ReadInt64();
    self.frontTiredRecoverTime = self:ReadInt64();
end

return SyncPlayerTroopInfo;
