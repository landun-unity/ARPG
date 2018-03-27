require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Logic * 16777216 + Terminal.Client * 65536 + MessageHandler.Player * 256;

--
-- 逻辑服务器 --> 客户端
-- Player
-- @author czx
--
L2C_Player = 
{
    --
    -- 断开连接
    --
    Disconnect = Begin + 0, 
    
    --
    -- 同步玩家同盟相关消息
    --
    LeagueBaseInfo = Begin + 1, 
    
    --
    -- 发送奖励信息
    --
    LoginGift = Begin + 2, 
    
    --
    -- 同步玩家信息
    --
    PlayerBaseInfo = Begin + 3, 
    
    --
    -- 玩家新获得一块地
    --
    PlayerGainNewTiled = Begin + 4, 
    
    --
    -- 玩家新获得一块地
    --
    PlayerLostOldTiled = Begin + 5, 
    
    --
    -- 刷新资源信息
    --
    RefreshCurrencyInfo = Begin + 6, 
    
    --
    -- 刷新资源信息
    --
    ResponseBuyDecree = Begin + 7, 
    
    --
    -- 刷新资源信息
    --
    ResponseBuyDecreeSuccess = Begin + 8, 
    
    --
    -- 返回其它玩家的个人信息
    --
    ResponseIsHavePlayerName = Begin + 9, 
    
    --
    -- 返回其它玩家的个人信息
    --
    ResponseOtherPlayerBaseInfo = Begin + 10, 
    
    --
    -- 税收说明回复
    --
    ReturnIntroductions = Begin + 11, 
    
    --
    -- 主城标记回复
    --
    ReturnMainCitySign = Begin + 12, 
    
    --
    -- 返回标记信息
    --
    ReturnMarkResult = Begin + 13, 
    
    --
    -- 主城标记回复
    --
    ReturnUndoMainCitySign = Begin + 14, 
    
    --
    -- 返回标记信息
    --
    ReturnUnmarkResult = Begin + 15, 
    
    --
    -- 税收次数
    --
    RevenueCountInfo = Begin + 16, 
    
    --
    -- 税收信息
    --
    RevenueInfo = Begin + 17, 
    
    --
    -- 屏幕中心点的回复
    --
    ScreenCenterReply = Begin + 18, 
    
    --
    -- 同步玩家的所有建筑物
    --
    SyncBuildingInfo = Begin + 19, 
    
    --
    -- 同步玩家聊天次数
    --
    SyncChatTimes = Begin + 20, 
    
    --
    -- 刷新资源信息
    --
    SyncDecree = Begin + 21, 
    
    --
    -- 强征回复
    --
    SyncForced = Begin + 22, 
    
    --
    -- 同步金币玉符
    --
    SyncGold = Begin + 23, 
    
    --
    -- 同步新手引导进度
    --
    SyncGuide = Begin + 24, 
    
    --
    -- 同步战法经验
    --
    SynchronizeWarfare = Begin + 25, 
    
    --
    -- 同步服务器时间返回
    --
    SyncImmediatelyFinish = Begin + 26, 
    
    --
    -- 同步信息的回复
    --
    SyncInfoReply = Begin + 27, 
    
    --
    -- 刷新资源信息
    --
    SyncJade = Begin + 28, 
    
    --
    -- 循环同步服务器时间
    --
    SyncLoginServerTime = Begin + 29, 
    
    --
    -- 同步新手保护期阶段
    --
    SyncNewerPeriod = Begin + 30, 
    
    --
    -- 同步玩家的所有建筑物
    --
    SyncOwnerBuilding = Begin + 31, 
    
    --
    -- 同步玩家城池信息
    --
    SyncOwnerCity = Begin + 32, 
    
    --
    -- 同步玩家基本信息
    --
    SyncPlayerBaseInfo = Begin + 33, 
    
    --
    -- 同步玩家势力值
    --
    SyncPlayerInfluence = Begin + 34, 
    
    --
    -- 同步玩家信息结束
    --
    SyncPlayerInfoEnd = Begin + 35, 
    
    --
    -- 同步标记信息
    --
    SyncPlayerMainCitySign = Begin + 36, 
    
    --
    -- 同步标记信息
    --
    SyncPlayerMarkerInfo = Begin + 37, 
    
    --
    -- 同步玩家的所有建筑物
    --
    SyncRegionBuildingInfo = Begin + 38, 
    
    --
    -- 登录税收请求回复
    --
    SyncReplyRevenue = Begin + 39, 
    
    --
    -- 同步资源信息
    --
    SyncResource = Begin + 40, 
    
    --
    -- 同步税收信息
    --
    SyncRevenueAllInfo = Begin + 41, 
    
    --
    -- 同步领取时间
    --
    SyncRevenueInfo = Begin + 42, 
    
    --
    -- 同步税收第三次信息
    --
    SyncRevenueThreeInfo = Begin + 43, 
    
    --
    -- 同步服务器时间返回
    --
    SyncRevenueTwoInfo = Begin + 44, 
    
    --
    -- 同步服务器时间返回
    --
    SyncServerTimeRespond = Begin + 45, 
    
    --
    -- 同步服务器时间返回
    --
    SyncThreeReplyRevenue = Begin + 46, 
    
    --
    -- 同步格子信息
    --
    SyncTiledDurableList = Begin + 47, 
    
    --
    -- 同步格子信息
    --
    SyncTiledIdList = Begin + 48, 
    
    --
    -- 同步服务器时间返回
    --
    SyncTwoReplyRevenue = Begin + 49, 
}

return L2C_Player;
