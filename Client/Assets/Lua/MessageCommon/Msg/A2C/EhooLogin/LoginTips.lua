--
-- 账号服务器 --> 客户端
-- 登录提示
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local LoginTips = class("LoginTips", GameMessage);

--
-- 构造函数
--
function LoginTips:ctor()
    LoginTips.super.ctor(self);
    --
    -- 登录凭证
    --
    self.tips = 0;
end

--@Override
function LoginTips:_OnSerial() 
    self:WriteInt32(self.tips);
end

--@Override
function LoginTips:_OnDeserialize() 
    self.tips = self:ReadInt32();
end

return LoginTips;
