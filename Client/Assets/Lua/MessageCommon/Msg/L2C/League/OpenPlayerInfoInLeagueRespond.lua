--
-- 逻辑服务器 --> 客户端
-- 打开玩家信息回复
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local OpenPlayerInfoInLeagueRespond = class("OpenPlayerInfoInLeagueRespond", GameMessage);

--
-- 构造函数
--
function OpenPlayerInfoInLeagueRespond:ctor()
    OpenPlayerInfoInLeagueRespond.super.ctor(self);
    --
    -- 玩家id
    --
    self.playerId = 0;
    
    --
    -- 名字
    --
    self.name = "";
    
    --
    -- 势力
    --
    self.influence = 0;
    
    --
    -- 盟id
    --
    self.leagueId = 0;
    
    --
    -- 盟名字
    --
    self.leagueName = "";
    
    --
    -- 官位
    --
    self.title = 0;
    
    --
    -- 自我介绍
    --
    self.selfIntroduce = "";
end

--@Override
function OpenPlayerInfoInLeagueRespond:_OnSerial() 
    self:WriteInt64(self.playerId);
    self:WriteString(self.name);
    self:WriteInt32(self.influence);
    self:WriteInt64(self.leagueId);
    self:WriteString(self.leagueName);
    self:WriteInt32(self.title);
    self:WriteString(self.selfIntroduce);
end

--@Override
function OpenPlayerInfoInLeagueRespond:_OnDeserialize() 
    self.playerId = self:ReadInt64();
    self.name = self:ReadString();
    self.influence = self:ReadInt32();
    self.leagueId = self:ReadInt64();
    self.leagueName = self:ReadString();
    self.title = self:ReadInt32();
    self.selfIntroduce = self:ReadString();
end

return OpenPlayerInfoInLeagueRespond;
