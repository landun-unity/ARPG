require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Logic * 16777216 + Terminal.Client * 65536 + MessageHandler.Building * 256;

--
-- 逻辑服务器 --> 客户端
-- Building
-- @author czx
--
L2C_Building = 
{
    --
    -- 要塞升级
    --
    CreateSubCityTime = Begin + 0, 
    
    --
    -- 删除要塞
    --
    DeleteClickFort = Begin + 1, 
    
    --
    -- 删除要塞
    --
    DeleteFort = Begin + 2, 
    
    --
    -- 放弃要塞时间
    --
    DeleteFortTime = Begin + 3, 
    
    --
    -- 迁移主城
    --
    MoveMainCity = Begin + 4, 
    
    --
    -- 建造要塞时间
    --
    PlayerFortTime = Begin + 5, 
    
    --
    -- 移除格子上的建筑物
    --
    RemoveBuilding = Begin + 6, 
    
    --
    -- 删除要塞
    --
    ReplyDeleteFortTimer = Begin + 7, 
    
    --
    -- 删除要塞
    --
    ReplyUpdateFort = Begin + 8, 
    
    --
    -- 同步建筑物建造队列数量到客户端
    --
    SyncBuildQueueList = Begin + 9, 
    
    --
    -- 创建要塞回复
    --
    SyncCreatePlayerBuilding = Begin + 10, 
    
    --
    -- 创建要塞回复
    --
    SyncCreatePlayerBuildingTime = Begin + 11, 
    
    --
    -- 创建分城回复
    --
    SyncCreatePlayerSubCity = Begin + 12, 
    
    --
    -- 同步已占领野城信息
    --
    SyncOccupyWildCity = Begin + 13, 
    
    --
    -- 同步玩家要塞信息
    --
    SyncPlayerFort = Begin + 14, 
    
    --
    -- 要塞升级
    --
    SyncUpdatePlayerFort = Begin + 15, 
    
    --
    -- 标记信息改变
    --
    TiledByBuildingMarker = Begin + 16, 
    
    --
    -- 升级要塞时间
    --
    UpdateFortTime = Begin + 17, 
}

return L2C_Building;
