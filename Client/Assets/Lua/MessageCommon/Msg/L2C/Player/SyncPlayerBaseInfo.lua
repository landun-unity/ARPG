--
-- 逻辑服务器 --> 客户端
-- 同步玩家基本信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SyncPlayerBaseInfo = class("SyncPlayerBaseInfo", GameMessage);

--
-- 构造函数
--
function SyncPlayerBaseInfo:ctor()
    SyncPlayerBaseInfo.super.ctor(self);
    --
    -- 名字
    --
    self.name = "";
    
    --
    -- 主城的格子Id
    --
    self.mainCityTiledId = 0;
    
    --
    -- 主城的表Id
    --
    self.mainCityTableId = 0;
    
    --
    -- 主城Id
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
end

--@Override
function SyncPlayerBaseInfo:_OnSerial() 
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
end

--@Override
function SyncPlayerBaseInfo:_OnDeserialize() 
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
end

return SyncPlayerBaseInfo;
