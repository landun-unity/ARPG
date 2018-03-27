require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Logic * 16777216 + Terminal.Client * 65536 + MessageHandler.Map * 256;

--
-- 逻辑服务器 --> 客户端
-- Map
-- @author czx
--
L2C_Map = 
{
    --
    -- 添加一条基于战平部队的敌方提示
    --
    AddEnemyTipBattle = Begin + 0, 
    
    --
    -- 添加一条基于线的敌方提示
    --
    AddEnemyTipLine = Begin + 1, 
    
    --
    -- 添加一根线
    --
    AddLine = Begin + 2, 
    
    --
    -- 移除一条基于战平部队的敌方提示
    --
    RemoveEnemyTipsBattle = Begin + 3, 
    
    --
    -- 移除一条基于线的敌方提示
    --
    RemoveEnemyTipsLine = Begin + 4, 
    
    --
    -- 删除线
    --
    RemoveLine = Begin + 5, 
    
    --
    -- 同步一个格子信息
    --
    RemovePlayerOneTiled = Begin + 6, 
    
    --
    -- 同步线信息
    --
    SyncLine = Begin + 7, 
    
    --
    -- 同步单条线信息
    --
    SyncOneLine = Begin + 8, 
    
    --
    -- 同步格子信息
    --
    SyncPlayerAllTiled = Begin + 9, 
    
    --
    -- 同步建筑物信息
    --
    SyncPlayerBuilding = Begin + 10, 
    
    --
    -- 同步一个格子信息
    --
    SyncPlayerOneTiled = Begin + 11, 
    
    --
    -- 同步格子信息
    --
    SyncRegionTiled = Begin + 12, 
    
    --
    -- 同步单个格子
    --
    SyncTiled = Begin + 13, 
    
    --
    -- 同步一个玩家视野内的所有线
    --
    SynePlayerAllLine = Begin + 14, 
}

return L2C_Map;
