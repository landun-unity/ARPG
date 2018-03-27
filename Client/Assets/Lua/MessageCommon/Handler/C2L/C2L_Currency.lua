-- 逻辑服务器到客户端的建筑物消息
require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

-- 开始
local Begin = Terminal.Client * 16777216 + Terminal.Logic * 65536 + MessageHandler.Currency * 256;

-- 建筑物
C2L_Currency = 
{
	-- 请求同步玩家货币信息
	RequestCurrencyInfo = Begin,

	RequestDecree = Begin + 1,

	RequestJadey = Begin + 2,
}

return C2L_Currency;