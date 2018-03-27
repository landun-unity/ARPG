--
-- 客户端 --> 逻辑服务器
-- 踢出聊天频道
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local KickOneMemberOutChatTeam = class("KickOneMemberOutChatTeam", GameMessage);

--
-- 构造函数
--
function KickOneMemberOutChatTeam:ctor()
    KickOneMemberOutChatTeam.super.ctor(self);
    --
    -- 被处理人
    --
    self.targetid = 0;
end

--@Override
function KickOneMemberOutChatTeam:_OnSerial() 
    self:WriteInt64(self.targetid);
end

--@Override
function KickOneMemberOutChatTeam:_OnDeserialize() 
    self.targetid = self:ReadInt64();
end

return KickOneMemberOutChatTeam;
