require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Client * 16777216 + Terminal.Logic * 65536 + MessageHandler.Facility * 256;

--
-- 客户端 --> 逻辑服务器
-- Facility
-- @author czx
--
C2L_Facility = 
{
    --
    -- 取消升级设施
    --
    CancelUpgradeFacility = Begin + 0, 
    
    --
    -- 同步一张卡牌
    --
    CityExpandRequest = Begin + 1, 
    
    --
    -- 打开城市设施
    --
    OpenCityFacility = Begin + 2, 
    
    --
    -- 请求所有的建造队列
    --
    RequestConstructionQueue = Begin + 3, 
    
    --
    -- 升级设施
    --
    UpgradeFacilityRequest = Begin + 4, 
    
    --
    -- 立即升级设施
    --
    UpgradeImmediateRequest = Begin + 5, 
}

return C2L_Facility;
