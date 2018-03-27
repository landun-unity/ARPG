require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Client * 16777216 + Terminal.Logic * 65536 + MessageHandler.PersonalPower * 256;

--
-- 客户端 --> 逻辑服务器
-- PersonalPower
-- @author czx
--
C2L_PersonalPower = 
{
    --
    -- 修改个人介绍
    --
    ChangePlayerProfile = Begin + 0, 
    
    --
    -- 请求土地耐久
    --
    RequestTiledDurable = Begin + 1, 
}

return C2L_PersonalPower;
