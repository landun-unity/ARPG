require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Client * 16777216 + Terminal.Account * 65536 + MessageHandler.EhooLogin * 256;

--
-- 客户端 --> 账号服务器
-- EhooLogin
-- @author czx
--
C2A_EhooLogin = 
{
    --
    -- 亿虎登录请求
    --
    EhooLoginRequest = Begin + 0, 
    
    --
    -- 注册
    --
    EhooRegisterRequest = Begin + 1, 
}

return C2A_EhooLogin;
