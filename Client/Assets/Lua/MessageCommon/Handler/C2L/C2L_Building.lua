require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Client * 16777216 + Terminal.Logic * 65536 + MessageHandler.Building * 256;

--
-- 客户端 --> 逻辑服务器
-- Building
-- @author czx
--
C2L_Building = 
{
    --
    -- 取消放弃分城
    --
    CancelRemoveSubCityRequest = Begin + 0, 
    
    --
    -- 取消拆除要塞
    --
    ClickDeleteFort = Begin + 1, 
    
    --
    -- 部队练兵
    --
    CreatePlayerFort = Begin + 2, 
    
    --
    -- 创建分城
    --
    CreatePlayerSubCity = Begin + 3, 
    
    --
    -- 取消放弃要塞
    --
    DeleteFortTimer = Begin + 4, 
    
    --
    -- 要塞升级请求
    --
    deleteLandFort = Begin + 5, 
    
    --
    -- 拆除要塞
    --
    RemoveFort = Begin + 6, 
    
    --
    -- 拆除分城
    --
    RemoveSubCity = Begin + 7, 
    
    --
    -- 请求建筑物信息
    --
    RequestBuildingInfo = Begin + 8, 
    
    --
    -- 请求建筑物信息
    --
    RequestOccupyWildCity = Begin + 9, 
    
    --
    -- 同步创建要塞时间
    --
    SyncCreateFortTime = Begin + 10, 
    
    --
    -- 部队练兵
    --
    TearDownPlayerFort = Begin + 11, 
    
    --
    -- 取消升级要塞
    --
    UpdateFort = Begin + 12, 
    
    --
    -- 要塞升级时间
    --
    UpgradePlayerFort = Begin + 13, 
    
    --
    -- 立即升级
    --
    UpgradePromptlyPlayerFort = Begin + 14, 
    
    --
    -- 要塞升级请求
    --
    UpgradeRequest = Begin + 15, 
}

return C2L_Building;
