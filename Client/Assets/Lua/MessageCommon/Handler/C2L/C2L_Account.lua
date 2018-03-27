require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Client * 16777216 + Terminal.Logic * 65536 + MessageHandler.Account * 256;

--
-- 客户端 --> 逻辑服务器
-- Account
-- @author czx
--
C2L_Account = 
{
    --
    -- 创建角色
    --
    CreateRole = Begin + 0, 
    
    --
    -- 登录验证
    --
    LoginVerfiy = Begin + 1, 
}

return C2L_Account;
