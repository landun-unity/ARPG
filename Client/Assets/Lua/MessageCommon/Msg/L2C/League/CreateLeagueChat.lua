--
-- 逻辑服务器 --> 客户端
-- 创建同盟聊天
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local CreateLeagueChat = class("CreateLeagueChat", GameMessage);

--
-- 构造函数
--
function CreateLeagueChat:ctor()
    CreateLeagueChat.super.ctor(self);
    --
    -- 同盟id
    --
    self.leagueId = 0;
    
    --
    -- 同盟名称
    --
    self.leagueName = "";
    
    --
    -- 同盟职位
    --
    self.leadership = 0;
end

--@Override
function CreateLeagueChat:_OnSerial() 
    self:WriteInt64(self.leagueId);
    self:WriteString(self.leagueName);
    self:WriteInt32(self.leadership);
end

--@Override
function CreateLeagueChat:_OnDeserialize() 
    self.leagueId = self:ReadInt64();
    self.leagueName = self:ReadString();
    self.leadership = self:ReadInt32();
end

return CreateLeagueChat;
