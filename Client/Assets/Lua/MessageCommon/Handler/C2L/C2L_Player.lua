require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Client * 16777216 + Terminal.Logic * 65536 + MessageHandler.Player * 256;

--
-- 客户端 --> 逻辑服务器
-- Player
-- @author czx
--
C2L_Player = 
{
    --
    -- 退出游戏
    --
    ExitGame = Begin + 0, 
    
    --
    -- 请求税收
    --
    InternalInfo = Begin + 1, 
    
    --
    -- 刷新同步信息
    --
    RefreshSyncInfo = Begin + 2, 
    
    --
    -- 请求聊天次数
    --
    RequestChatTimes = Begin + 3, 
    
    --
    -- 请求玩家货币信息
    --
    RequestCurrencyInfo = Begin + 4, 
    
    --
    -- 请求玩家政令
    --
    RequestDecree = Begin + 5, 
    
    --
    -- 请求强征
    --
    RequestForced = Begin + 6, 
    
    --
    -- 请求金币玉符
    --
    RequestGold = Begin + 7, 
    
    --
    -- 请求立即完成税收
    --
    RequestImmediateFinish = Begin + 8, 
    
    --
    -- 请求是否有该角色名称
    --
    RequestIsHavePlayerName = Begin + 9, 
    
    --
    -- 请求玉
    --
    RequestJade = Begin + 10, 
    
    --
    -- 请求玩家玉符
    --
    RequestJadey = Begin + 11, 
    
    --
    -- 请求跳过新手引导
    --
    RequestJumpGuide = Begin + 12, 
    
    --
    -- 请求玩家同盟信息
    --
    RequestLeagueInfo = Begin + 13, 
    
    --
    -- 请求每日奖励
    --
    RequestLoginGift = Begin + 14, 
    
    --
    -- 请求每日奖励信息
    --
    RequestLoginGiftInfo = Begin + 15, 
    
    --
    -- 主城标记信息
    --
    RequestMainCitySign = Begin + 16, 
    
    --
    -- 请求标记土地
    --
    RequestMarkTiled = Begin + 17, 
    
    --
    -- 请求服务器验证并开启新手保护期某个阶段
    --
    RequestOpenNewerPeriod = Begin + 18, 
    
    --
    -- 请求其它玩家的个人信息
    --
    RequestOtherPlayerBaseInfo = Begin + 19, 
    
    --
    -- 请求领地Id
    --
    RequestPlayerAllTiledInfo = Begin + 20, 
    
    --
    -- 请求建筑物同步信息
    --
    RequestPlayerBuilding = Begin + 21, 
    
    --
    -- 请求玩家势力值
    --
    RequestPlayerInfluence = Begin + 22, 
    
    --
    -- 请求玩家信息
    --
    RequestPlayerInfo = Begin + 23, 
    
    --
    -- 请求玩家资源信息
    --
    RequestResourceInfo = Begin + 24, 
    
    --
    -- 请求税收
    --
    RequestRevenue = Begin + 25, 
    
    --
    -- 同步新手引导进度
    --
    RequestSaveGuideStep = Begin + 26, 
    
    --
    -- 请求同步信息
    --
    RequestSyncInfo = Begin + 27, 
    
    --
    -- 请求税收
    --
    RequestTaexs = Begin + 28, 
    
    --
    -- 请求领地Id
    --
    RequestTiledIdInfo = Begin + 29, 
    
    --
    -- 主城取消标记信息
    --
    RequestUndoMainCitySign = Begin + 30, 
    
    --
    -- 请求标记土地
    --
    RequestUndoMarker = Begin + 31, 
    
    --
    -- 请求购买政令
    --
    RequsetBuyDercee = Begin + 32, 
    
    --
    -- 请求税收说明
    --
    RevenueIntroductions = Begin + 33, 
    
    --
    -- 屏幕中心发生变化
    --
    ScreenCenter = Begin + 34, 
    
    --
    -- 同步服务器时间
    --
    SendPlayerConnect = Begin + 35, 
    
    --
    -- 主城标记信息
    --
    SyncMainCitySign = Begin + 36, 
    
    --
    -- 请求标记土地
    --
    SyncMarkerInfo = Begin + 37, 
    
    --
    -- 同步服务器时间
    --
    SyncServerTimeRequest = Begin + 38, 
}

return C2L_Player;
