-- 状态类型

LoginStateType = 
{
    -- 注册账号服务器
    RegisterAccount = 1, ---第1步

    -- 登录帐号服务器
    LoginAccount = 2,  ---第2步

    -- 登录逻辑服务器
    LoginLogic = 3,  ---第3步

    -- 创建角色
    CreateRole = 4,  ---第2.5步

    -- 请求角色信息
    RequestPlayerInfo = 5,  ---第4步

    -- 显示地图
    CreateMap = 6,  --第5

    -- 请求建筑物信息
    RequestBuildingInfo = 7, ---第6

    -- 请求卡牌信息
    RequestCardInfo = 8,  -- 第11

    -- 请求战法信息
    RequestSkillInfo = 9, -- 第12

    -- 请求部队信息
    RequestArmyInfo = 10,  --第13

    -- 服务器时间
    ServerTime = 11, 

    -- 进入游戏
    EnterGame = 12, 

    -- 发送创建势力
    SendCreateRole = 13, 

    -- 请求资源信息
    RequestResourceInfo = 14,  --第8

    -- 请求金钱信息
    RequestCurrencyInfo = 15,  --第9

    -- 打开设施l
    OpenCityFacility = 16, --第10
    
    --请求充值信息 
    RequestRechargeInfo = 17,

    --请求邮件信息
    RequestMailInfo = 18,

    -- 空状态
    Empty = 20, 
    
    --同步标记信息
    SyncMarkerInfos = 21,

    --要所有的招募信息
    RequestRecruitInfo = 22,

    --     -- 请求税收
    -- RequestRevenues = 23,

    -- 请求玩家建筑物信息
    RequestPlayerBuilding = 23, -----？？


    --请求玩家同盟野城信息
    OpenOwnWildBuildRequest = 24,

    RequestTiledIdInfo = 25, --第7

    --要所有的招募信息
    RequestSourceEvent = 26,

      -- 请求创建要塞时间
    RequestSyncCreateFortTime = 27,

    -- 请求同步税收信息
    RequestRevenueIdInfo = 28,

    RequestOccupyWildCity = 29,

    RequestWordTendencyInfo = 30,

    OpenDiplomacyLeagueRequest= 31,

    JoinChannel = 32,

    RequestLeagueInfo = 33,

    RequestPlayerTiledInfo = 34,

    -- 请求玩家势力值
    RequestPlayerInfluence = 35.
}

return LoginStateType;
