require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Client * 16777216 + Terminal.Logic * 65536 + MessageHandler.Army * 256;

--
-- 客户端 --> 逻辑服务器
-- Army
-- @author czx
--
C2L_Army = 
{
    --
    -- 部队出征
    --
    ArmyBattleMsg = Begin + 0, 
    
    --
    -- 部队征兵
    --
    ArmyConscription = Begin + 1, 
    
    --
    -- 部队屯田
    --
    ArmyFarmmingMsg = Begin + 2, 
    
    --
    -- 部队驻守
    --
    ArmyGarrisonMsg = Begin + 3, 
    
    --
    -- 部队征兵
    --
    ArmyImmediateConscription = Begin + 4, 
    
    --
    -- 部队撤退
    --
    ArmyRetreatingImmediately = Begin + 5, 
    
    --
    -- 部队撤退
    --
    ArmyRetreatingMsg = Begin + 6, 
    
    --
    -- 部队扫荡
    --
    ArmySweepMsg = Begin + 7, 
    
    --
    -- 部队练兵
    --
    ArmyTrainingMsg = Begin + 8, 
    
    --
    -- 部队调动
    --
    ArmyTransferomMsg = Begin + 9, 
    
    --
    -- 取消部队征兵
    --
    CancelArmyConscription = Begin + 10, 
    
    --
    -- 取消放弃土地
    --
    CancelGiveUpOwnerLand = Begin + 11, 
    
    --
    -- 配置部队
    --
    ConfigArmy = Begin + 12, 
    
    --
    -- 交换部队
    --
    ExchangeArmyCard = Begin + 13, 
    
    --
    -- 放弃土地
    --
    GiveUpOwnerLand = Begin + 14, 
    
    --
    -- 移除部队卡牌
    --
    RemoveArmyCard = Begin + 15, 
    
    --
    -- 请求部队动态信息
    --
    RequestArmyDynamicInfo = Begin + 16, 
    
    --
    -- 请求部队信息
    --
    RequestArmyInfo = Begin + 17, 
    
    --
    -- 部队调动
    --
    RequestArmySwap = Begin + 18, 
}

return C2L_Army;
