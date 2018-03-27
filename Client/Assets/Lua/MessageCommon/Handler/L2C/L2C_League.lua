require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Logic * 16777216 + Terminal.Client * 65536 + MessageHandler.League * 256;

--
-- 逻辑服务器 --> 客户端
-- League
-- @author czx
--
L2C_League = 
{
    --
    -- 申请加入同盟列表
    --
    ApplyJoinLeagueList = Begin + 0, 
    
    --
    -- 同盟聊天分组基础信息
    --
    BaseLeagueChatTeamInfo = Begin + 1, 
    
    --
    -- 同盟聊天分组基础信息
    --
    BaseLeagueChatTeamModel = Begin + 2, 
    
    --
    -- 玩家打开被同盟邀请列表
    --
    BeInventLeagueListRespond = Begin + 3, 
    
    --
    -- 修改频道名字回复
    --
    ChangeLeagueChatTeamName = Begin + 4, 
    
    --
    -- 创建同盟聊天
    --
    CreateLeagueChat = Begin + 5, 
    
    --
    -- 创建同盟成功
    --
    CreateLeagueSuccess = Begin + 6, 
    
    --
    -- 下次禅让时间
    --
    DemiseTime = Begin + 7, 
    
    --
    -- 同盟同意玩家加入
    --
    LeagueAgreePlayerJoin = Begin + 8, 
    
    --
    -- 同盟攻城
    --
    LeagueChangeWildBuilding = Begin + 9, 
    
    --
    -- 增加同盟标记回复
    --
    LeagueMarkRespond = Begin + 10, 
    
    --
    -- 操作类型回复消息
    --
    LeagueOperationTipsMsg = Begin + 11, 
    
    --
    -- 下次入盟时间
    --
    NextJoinLeagueTime = Begin + 12, 
    
    --
    -- 打开指定盟回复
    --
    OpenAppiontLeagueRespond = Begin + 13, 
    
    --
    -- 打开外交盟回复
    --
    OpenDiplomacyLeagueRespond = Begin + 14, 
    
    --
    -- 打开自己盟回复
    --
    OpenLeagueBack = Begin + 15, 
    
    --
    -- 聊天分组名字
    --
    OpenLeagueChatTeamRespond = Begin + 16, 
    
    --
    -- 打开同盟标记回复
    --
    OpenLeagueMarkRespond = Begin + 17, 
    
    --
    -- 玩家打开被同盟邀请列表
    --
    OpenLeagueMemberBack = Begin + 18, 
    
    --
    -- 没有盟的回复
    --
    OpenNoLeagueBack = Begin + 19, 
    
    --
    -- 打开拥有野外建筑回复
    --
    OpenOwnWildBuildRespond = Begin + 20, 
    
    --
    -- 打开玩家信息回复
    --
    OpenPlayerInfoInLeagueRespond = Begin + 21, 
    
    --
    -- 同盟等级
    --
    OpenRevoltRespond = Begin + 22, 
    
    --
    -- 玩家打开周围盟
    --
    OpenRoundLeagueListRespond = Begin + 23, 
    
    --
    -- 打开周围玩家回复
    --
    OpenRoundPlayerRespond = Begin + 24, 
    
    --
    -- 玩家打开下属成员请求
    --
    OpenUnderMemberRespond = Begin + 25, 
    
    --
    -- 移除同盟聊天分组回复
    --
    RemoveLeagueChatTeam = Begin + 26, 
    
    --
    -- 移除同盟标记回复
    --
    RemoveLeagueMarkRespond = Begin + 27, 
    
    --
    -- 关闭入盟申请回复
    --
    ShutJoinApplyLeagueRespond = Begin + 28, 
    
    --
    -- 同盟等级
    --
    SyncLeagueLevel = Begin + 29, 
    
    --
    -- 增加同盟标记回复
    --
    SyncLeagueMarkRespond = Begin + 30, 
    
    --
    -- 同盟聊天分组基础信息
    --
    SyncPlayerBaseLeagueChatTeam = Begin + 31, 
    
    --
    -- 野城占领同盟信息
    --
    WildBuildingOccupyPlayerInfo = Begin + 32, 
}

return L2C_League;
