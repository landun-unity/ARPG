require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Logic * 16777216 + Terminal.Client * 65536 + MessageHandler.Account * 256;

--
-- 逻辑服务器 --> 客户端
-- Account
-- @author czx
--
L2C_Account = 
{
    --
    -- 创建玩家成功
    --
    CreateRoleSuccess = Begin + 0, 
    
    --
    -- 验证成功
    --
    GetPlayerListRespond = Begin + 1, 
}

return L2C_Account;
