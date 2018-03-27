--
-- 客户端 --> 逻辑服务器
-- 退出同盟
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local QuitLeagueChatTeam = class("QuitLeagueChatTeam", GameMessage);

--
-- 构造函数
--
function QuitLeagueChatTeam:ctor()
    QuitLeagueChatTeam.super.ctor(self);
    --
    -- 频道id
    --
    self.chatTeamId = 0;
end

--@Override
function QuitLeagueChatTeam:_OnSerial() 
    self:WriteInt64(self.chatTeamId);
end

--@Override
function QuitLeagueChatTeam:_OnDeserialize() 
    self.chatTeamId = self:ReadInt64();
end

return QuitLeagueChatTeam;
