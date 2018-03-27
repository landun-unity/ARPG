-- 登录管理
local GameMessage = require("common/Net/GameMessage")

local LoginMessage = class("LoginMessage", GameMessage)

-- 构造函数
function LoginMessage:ctor( )
    -- body
    LoginMessage.super.ctor(self);
    print("LoginMessage:ctor")
end

return LoginMessage;