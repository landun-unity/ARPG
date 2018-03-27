--
-- 客户端 --> 逻辑服务器
-- 邀请他人入盟
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local InviteOther = class("InviteOther", GameMessage);

--
-- 构造函数
--
function InviteOther:ctor()
    InviteOther.super.ctor(self);
    --
    -- 被邀请者id
    --
    self.targetPlayerid = 0;
end

--@Override
function InviteOther:_OnSerial() 
    self:WriteInt64(self.targetPlayerid);
end

--@Override
function InviteOther:_OnDeserialize() 
    self.targetPlayerid = self:ReadInt64();
end

return InviteOther;
