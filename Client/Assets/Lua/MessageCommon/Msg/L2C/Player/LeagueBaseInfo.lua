--
-- 逻辑服务器 --> 客户端
-- 同步玩家同盟相关消息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local LeagueBaseInfo = class("LeagueBaseInfo", GameMessage);

--
-- 构造函数
--
function LeagueBaseInfo:ctor()
    LeagueBaseInfo.super.ctor(self);
    --
    -- 上级盟id
    --
    self.superiorLeagueId = 0;
    
    --
    -- 上级盟名字
    --
    self.superiorName = "";
    
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
    -- 通知公告
    --
    self.notice = "";
    
    --
    -- 玩家红点提示
    --
    self.isPlayerRed = 0;
end

--@Override
function LeagueBaseInfo:_OnSerial() 
    self:WriteInt64(self.superiorLeagueId);
    self:WriteString(self.superiorName);
    self:WriteInt64(self.leagueId);
    self:WriteString(self.leagueName);
    self:WriteInt32(self.title);
    self:WriteInt32(self.leagueLevel);
    self:WriteString(self.notice);
    self:WriteInt32(self.isPlayerRed);
end

--@Override
function LeagueBaseInfo:_OnDeserialize() 
    self.superiorLeagueId = self:ReadInt64();
    self.superiorName = self:ReadString();
    self.leagueId = self:ReadInt64();
    self.leagueName = self:ReadString();
    self.title = self:ReadInt32();
    self.leagueLevel = self:ReadInt32();
    self.notice = self:ReadString();
    self.isPlayerRed = self:ReadInt32();
end

return LeagueBaseInfo;
