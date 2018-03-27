-- 客户端到逻辑服务器的地图消息
require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

-- 开始
local Begin = Terminal.Client * 16777216 + Terminal.Logic * 65536 + MessageHandler.Map * 256;

-- 地图
C2L_Map = 
{
}

return C2L_Map;
