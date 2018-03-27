-- 客户端到逻辑服务器的系统消息
require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

-- 开始
local Begin = Terminal.Client * 16777216 + Terminal.Logic * 65536 + MessageHandler.System * 256;

-- 系统
C2L_System = 
{
}

return C2L_System;
