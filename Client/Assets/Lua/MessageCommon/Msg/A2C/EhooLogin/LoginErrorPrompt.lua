--
-- 账号服务器 --> 客户端
-- 登录或注册错误提示
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local LoginErrorPrompt = class("LoginErrorPrompt", GameMessage);

--
-- 构造函数
--
function LoginErrorPrompt:ctor()
    LoginErrorPrompt.super.ctor(self);
    --
    -- 返回客户端提示号
    --
    self.tips = 0;
end

--@Override
function LoginErrorPrompt:_OnSerial() 
    self:WriteInt32(self.tips);
end

--@Override
function LoginErrorPrompt:_OnDeserialize() 
    self.tips = self:ReadInt32();
end

return LoginErrorPrompt;
