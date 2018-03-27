--
-- 客户端 --> 逻辑服务器
-- 踢人
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local KickOneMember = class("KickOneMember", GameMessage);

--
-- 构造函数
--
function KickOneMember:ctor()
    KickOneMember.super.ctor(self);
    --
    -- 被处理人
    --
    self.targetid = 0;
end

--@Override
function KickOneMember:_OnSerial() 
    self:WriteInt64(self.targetid);
end

--@Override
function KickOneMember:_OnDeserialize() 
    self.targetid = self:ReadInt64();
end

return KickOneMember;
