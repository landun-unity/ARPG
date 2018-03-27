require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Logic * 16777216 + Terminal.Client * 65536 + MessageHandler.Facility * 256;

--
-- 逻辑服务器 --> 客户端
-- Facility
-- @author czx
--
L2C_Facility = 
{
    --
    -- 同步一张卡牌
    --
    CityExpandRespond = Begin + 0, 
    
    --
    -- 设施操作枚举
    --
    FacilityOperationMsg = Begin + 1, 
    
    --
    -- 建造队列消息
    --
    OnBuildingFacility = Begin + 2, 
    
    --
    -- 同步玩家所有设施
    --
    OpenCityFacilityRespond = Begin + 3, 
    
    --
    -- 同步一张卡牌
    --
    SingleCityFacilityMsg = Begin + 4, 
    
    --
    -- 升级设施回复
    --
    SyncSingleCityTitled = Begin + 5, 
    
    --
    -- 升级设施回复
    --
    UpgradeFacilityRespond = Begin + 6, 
}

return L2C_Facility;
