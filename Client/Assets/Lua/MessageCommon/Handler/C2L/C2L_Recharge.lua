require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Client * 16777216 + Terminal.Logic * 65536 + MessageHandler.Recharge * 256;

--
-- 客户端 --> 逻辑服务器
-- Recharge
-- @author czx
--
C2L_Recharge = 
{
    --
    -- 领取月卡
    --
    GetMonthCard = Begin + 0, 
    
    --
    -- 请求玩家的充值信息
    --
    GetRechargeInfo = Begin + 1, 
    
    --
    -- 请求充值
    --
    RechargeOnce = Begin + 2, 
}

return C2L_Recharge;
