require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Client * 16777216 + Terminal.Logic * 65536 + MessageHandler.League * 256;

--
-- 客户端 --> 逻辑服务器
-- League
-- @author czx
--
C2L_League = 
{
    --
    -- 增加同盟标记
    --
    AddLeagueMark = Begin + 0, 
    
    --
    -- 盟主/副盟主同意入盟
    --
    AgreeJoin = Begin + 1, 
    
    --
    -- 申请禅让
    --
    ApplyDemise = Begin + 2, 
    
    --
    -- 申请加入同盟
    --
    ApplyJoin = Begin + 3, 
    
    --
    -- 任命太守
    --
    AppointChief = Begin + 4, 
    
    --
    -- 任命官员
    --
    AppointOfficer = Begin + 5, 
    
    --
    -- 登录请求同盟聊天分组请求
    --
    BaseLeagueChatTeamQuest = Begin + 6, 
    
    --
    -- 取消申请加入
    --
    CancelApplyJoin = Begin + 7, 
    
    --
    -- 取消禅让
    --
    CancelDemise = Begin + 8, 
    
    --
    -- 修改频道名字
    --
    ChangeLeagueChatTeamName = Begin + 9, 
    
    --
    -- 增加同盟经验
    --
    ChangeLeagueExpience = Begin + 10, 
    
    --
    -- 设置同盟关系
    --
    ConfigRelationRequest = Begin + 11, 
    
    --
    -- 创建同盟
    --
    CreateLeague = Begin + 12, 
    
    --
    -- 创建同盟聊天分组请求
    --
    CreateLeagueChatTeamQuest = Begin + 13, 
    
    --
    -- 解散同盟
    --
    DissolveLeague = Begin + 14, 
    
    --
    -- 解散同盟聊天分组
    --
    DissolveLeagueChatTeamQuest = Begin + 15, 
    
    --
    -- 同盟捐献请求
    --
    DonateRequest = Begin + 16, 
    
    --
    -- 确定反叛请求
    --
    EnsureRevoltRequest = Begin + 17, 
    
    --
    -- 放弃我的副盟主
    --
    GiveUpMyViceLeader = Begin + 18, 
    
    --
    -- 打开指定盟
    --
    HandleRequestImmediateOpenAppointLeague = Begin + 19, 
    
    --
    -- 直接申请入盟
    --
    ImmediateApplyJoin = Begin + 20, 
    
    --
    -- 直接邀请他人入盟
    --
    ImmediateInviteOther = Begin + 21, 
    
    --
    -- 邀请他人入盟
    --
    InviteOther = Begin + 22, 
    
    --
    -- 邀请他人入聊天分组
    --
    InviteOtherJoinLeagueChatTeam = Begin + 23, 
    
    --
    -- 踢人
    --
    KickOneMember = Begin + 24, 
    
    --
    -- 踢出聊天频道
    --
    KickOneMemberOutChatTeam = Begin + 25, 
    
    --
    -- 踢人
    --
    LeagueCapture = Begin + 26, 
    
    --
    -- 盟主/副盟主打开申请列表
    --
    OpenApplyList = Begin + 27, 
    
    --
    -- 玩家打开被邀请盟列表
    --
    OpenBeInventLeague = Begin + 28, 
    
    --
    -- 打开创建同盟聊天分组频道
    --
    OpenCreateLeagueChatTeam = Begin + 29, 
    
    --
    -- 打开同盟外交请求
    --
    OpenDiplomacyLeagueRequest = Begin + 30, 
    
    --
    -- 打开创建同盟
    --
    OpenLeagueChatTeam = Begin + 31, 
    
    --
    -- 打开同盟标记请求
    --
    OpenLeagueMarkRequest = Begin + 32, 
    
    --
    -- 打开拥有野外建筑请求
    --
    OpenOwnWildBuildRequest = Begin + 33, 
    
    --
    -- 打开玩家信息框
    --
    OpenPlayerInfoInLeague = Begin + 34, 
    
    --
    -- 打开反叛界面请求
    --
    OpenRevoltRequest = Begin + 35, 
    
    --
    -- 打开周围同盟列表
    --
    OpenRoundLeagueList = Begin + 36, 
    
    --
    -- 盟主/副盟主打开周围玩家列表
    --
    OpenRoundPlayer = Begin + 37, 
    
    --
    -- 打开下属成员消息
    --
    OpenUnderMemberRequest = Begin + 38, 
    
    --
    -- 玩家同意加入同盟
    --
    PlayerAgreeJoinInvent = Begin + 39, 
    
    --
    -- 退出同盟
    --
    QuitLeague = Begin + 40, 
    
    --
    -- 退出同盟
    --
    QuitLeagueChatTeam = Begin + 41, 
    
    --
    -- 罢免太守
    --
    RecallChief = Begin + 42, 
    
    --
    -- 罢免官员
    --
    RecallOfficer = Begin + 43, 
    
    --
    -- 减少同盟经验
    --
    ReduceLeagueExpience = Begin + 44, 
    
    --
    -- 改变公告
    --
    RefreshLeagueNotice = Begin + 45, 
    
    --
    -- 盟主/副盟主拒绝玩家加入
    --
    RefuseJoin = Begin + 46, 
    
    --
    -- 删除同盟标记
    --
    RemoveLeagueMark = Begin + 47, 
    
    --
    -- 请求野城占领同盟信息
    --
    RequestOccupyLeagueInfo = Begin + 48, 
    
    --
    -- 打开指定盟
    --
    RequestOpenAppointLeague = Begin + 49, 
    
    --
    -- 打开我的盟
    --
    RequestOpenLeague = Begin + 50, 
    
    --
    -- 打开盟成员
    --
    RequestOpenLeagueMembers = Begin + 51, 
    
    --
    -- 反叛捐献请求
    --
    RevoltRequest = Begin + 52, 
    
    --
    -- 打开/关闭同盟申请
    --
    ShutJoinApplyLeague = Begin + 53, 
}

return C2L_League;
