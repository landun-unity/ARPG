--
-- 客户端 --> 逻辑服务器
-- 直接邀请他人入盟
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ImmediateInviteOther = class("ImmediateInviteOther", GameMessage);

--
-- 构造函数
--
function ImmediateInviteOther:ctor()
    ImmediateInviteOther.super.ctor(self);
    --
    -- 目标的名字
    --
    self.targetPlayerName = "";
end

--@Override
function ImmediateInviteOther:_OnSerial() 
    self:WriteString(self.targetPlayerName);
end

--@Override
function ImmediateInviteOther:_OnDeserialize() 
    self.targetPlayerName = self:ReadString();
end

return ImmediateInviteOther;
