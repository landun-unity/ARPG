--
-- 逻辑服务器 --> 客户端
-- 同步玩家信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local PlayerBaseInfo = class("PlayerBaseInfo", GameMessage);

--
-- 构造函数
--
function PlayerBaseInfo:ctor()
    PlayerBaseInfo.super.ctor(self);
    --
    -- 名称
    --
    self.name = "";
    
    --
    -- 主城的格子
    --
    self.mainCityTiledId = 0;
    
    --
    -- 主城的表Id
    --
    self.mainCityTableId = 0;
    
    --
    -- 主城的Id
    --
    self.mainCityId = 0;
    
    --
    -- 上级盟id
    --
    self.superiorLeagueId = 0;
    
    --
    -- 自己盟id
    --
    self.leagueId = 0;
    
    --
    -- 同盟名字
    --
    self.leagueName = "";
    
    --
    -- 自己在盟中的职位
    --
    self.title = 0;
    
    --
    -- 同盟等级
    --
    self.leagueLevel = 0;
    
    --
    -- 玩家介绍
    --
    self.playerProfile = "";
    
    --
    -- 背包上限
    --
    self.cardPackageMax = 0;
    
    --
    -- 基础建造队列上限
    --
    self.baseConstructQueueMax = 0;
    
    --
    -- 临时建造队列上限
    --
    self.tempConstructQueueMax = 0;
    
    --
    -- 新手引导进度
    --
    self.guideStep = 0;
    
    --
    -- 出生州
    --
    self.spawnState = 0;
    
    --
    -- 当前新手保护期阶段
    --
    self.curNewerPeriod = 0;
    
    --
    -- 新手保护期结束时间
    --
    self.newerPeriodEndTime = 0;
    
    --
    -- 玩家免费聊天次数
    --
    self.chatTimes = 0;
end

--@Override
function PlayerBaseInfo:_OnSerial() 
    self:WriteString(self.name);
    self:WriteInt32(self.mainCityTiledId);
    self:WriteInt32(self.mainCityTableId);
    self:WriteInt64(self.mainCityId);
    self:WriteInt64(self.superiorLeagueId);
    self:WriteInt64(self.leagueId);
    self:WriteString(self.leagueName);
    self:WriteInt32(self.title);
    self:WriteInt32(self.leagueLevel);
    self:WriteString(self.playerProfile);
    self:WriteInt32(self.cardPackageMax);
    self:WriteInt32(self.baseConstructQueueMax);
    self:WriteInt32(self.tempConstructQueueMax);
    self:WriteInt32(self.guideStep);
    self:WriteInt32(self.spawnState);
    self:WriteInt32(self.curNewerPeriod);
    self:WriteInt64(self.newerPeriodEndTime);
    self:WriteInt32(self.chatTimes);
end

--@Override
function PlayerBaseInfo:_OnDeserialize() 
    self.name = self:ReadString();
    self.mainCityTiledId = self:ReadInt32();
    self.mainCityTableId = self:ReadInt32();
    self.mainCityId = self:ReadInt64();
    self.superiorLeagueId = self:ReadInt64();
    self.leagueId = self:ReadInt64();
    self.leagueName = self:ReadString();
    self.title = self:ReadInt32();
    self.leagueLevel = self:ReadInt32();
    self.playerProfile = self:ReadString();
    self.cardPackageMax = self:ReadInt32();
    self.baseConstructQueueMax = self:ReadInt32();
    self.tempConstructQueueMax = self:ReadInt32();
    self.guideStep = self:ReadInt32();
    self.spawnState = self:ReadInt32();
    self.curNewerPeriod = self:ReadInt32();
    self.newerPeriodEndTime = self:ReadInt64();
    self.chatTimes = self:ReadInt32();
end

return PlayerBaseInfo;
