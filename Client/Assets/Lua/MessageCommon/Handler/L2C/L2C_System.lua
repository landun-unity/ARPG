-- 逻辑服务器到客户端的系统消息
require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

-- 开始
local Begin = Terminal.Logic * 16777216 + Terminal.Client * 65536 + MessageHandler.System * 256;

-- 系统
L2C_System = 
{
}

return L2C_System;