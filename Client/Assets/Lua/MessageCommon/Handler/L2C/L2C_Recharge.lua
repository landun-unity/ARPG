require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Logic * 16777216 + Terminal.Client * 65536 + MessageHandler.Recharge * 256;

--
-- 逻辑服务器 --> 客户端
-- Recharge
-- @author czx
--
L2C_Recharge = 
{
    --
    -- 领取月卡回复
    --
    GetMonthCardResponse = Begin + 0, 
    
    --
    -- 请求玩家所有的充值信息回复
    --
    RechargeInfoResponse = Begin + 1, 
    
    --
    -- 请求充值回复
    --
    RechargeOnceResponse = Begin + 2, 
}

return L2C_Recharge;
