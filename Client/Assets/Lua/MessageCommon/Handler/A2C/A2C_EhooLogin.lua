require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Account * 16777216 + Terminal.Client * 65536 + MessageHandler.EhooLogin * 256;

--
-- 账号服务器 --> 客户端
-- EhooLogin
-- @author czx
--
A2C_EhooLogin = 
{
    --
    -- 亿虎登录回复
    --
    EhooLoginRespond = Begin + 0, 
    
    --
    -- 注册回复
    --
    EhooRegisterRespond = Begin + 1, 
    
    --
    -- 登录提示
    --
    LoginErrorPrompt = Begin + 2, 
    
    --
    -- 登录提示
    --
    LoginTips = Begin + 3, 
}

return A2C_EhooLogin;
