require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Logic * 16777216 + Terminal.Client * 65536 + MessageHandler.Army * 256;

--
-- 逻辑服务器 --> 客户端
-- Army
-- @author czx
--
L2C_Army = 
{
    --
    -- 增减要塞部队
    --
    AddFortArmy = Begin + 0, 
    
    --
    -- 部队练兵
    --
    ArmmingTrainingTime = Begin + 1, 
    
    --
    -- 部队信息
    --
    ArmyBaseInfo = Begin + 2, 
    
    --
    -- 部队出征回复
    --
    ArmyBattleReturnMsg = Begin + 3, 
    
    --
    -- 部队征兵回复
    --
    ArmyConscriptionRespond = Begin + 4, 
    
    --
    -- 部队屯田回复
    --
    ArmyFarmmingReturnMsg = Begin + 5, 
    
    --
    -- 屯田时间
    --
    ArmyFarmmingTime = Begin + 6, 
    
    --
    -- 部队屯田时间
    --
    ArmyFarmmingTimeMsg = Begin + 7, 
    
    --
    -- 部队驻守回复
    --
    ArmyGarrisonReturnMsg = Begin + 8, 
    
    --
    -- 部队征兵回复
    --
    ArmyImmediateConscriptionRespond = Begin + 9, 
    
    --
    -- 部队行军时间
    --
    ArmyMarchTime = Begin + 10, 
    
    --
    -- 同步线信息
    --
    ArmyOperationTipsMsg = Begin + 11, 
    
    --
    -- 部队出征回复
    --
    ArmyRetreatingReturnMsg = Begin + 12, 
    
    --
    -- 部队出征回复
    --
    ArmySweepReturnMsg = Begin + 13, 
    
    --
    -- 部队练兵经验
    --
    ArmyTrainingExp = Begin + 14, 
    
    --
    -- 部队出征回复
    --
    ArmyTrainingReturnMsg = Begin + 15, 
    
    --
    -- 部队出征回复
    --
    ArmyTransferomReturnMsg = Begin + 16, 
    
    --
    -- 同步线信息
    --
    HeroCardConscriptRespond = Begin + 17, 
    
    --
    -- 部队移除卡牌回复
    --
    HeroRemoveCardResponse = Begin + 18, 
    
    --
    -- 增减要塞部队
    --
    ReduceFortArmy = Begin + 19, 
    
    --
    -- 部队列表
    --
    SyncAllArmy = Begin + 20, 
    
    --
    -- 同步线信息
    --
    SyncLineMsg = Begin + 21, 
    
    --
    -- 部队信息
    --
    SyncPlayerFortArmy = Begin + 22, 
    
    --
    -- 同步玩家部队信息
    --
    SyncPlayerTroopInfo = Begin + 23, 
}

return L2C_Army;
