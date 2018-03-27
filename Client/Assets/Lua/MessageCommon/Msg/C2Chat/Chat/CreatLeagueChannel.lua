--
-- 客户端 --> 聊天服务器
-- 加入频道
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local CreatLeagueChannel = class("CreatLeagueChannel", GameMessage);

--
-- 构造函数
--
function CreatLeagueChannel:ctor()
    CreatLeagueChannel.super.ctor(self);
    --
    -- 频道Id
    --
    self.channelId = 0;
    
    --
    -- 国家
    --
    self.country = 0;
    
    --
    -- 同盟名字
    --
    self.leagueName = "";
    
    --
    -- 职位
    --
    self.leadership = 0;
end

--@Override
function CreatLeagueChannel:_OnSerial() 
    self:WriteInt64(self.channelId);
    self:WriteInt64(self.country);
    self:WriteString(self.leagueName);
    self:WriteInt32(self.leadership);
end

--@Override
function CreatLeagueChannel:_OnDeserialize() 
    self.channelId = self:ReadInt64();
    self.country = self:ReadInt64();
    self.leagueName = self:ReadString();
    self.leadership = self:ReadInt32();
end

return CreatLeagueChannel;
