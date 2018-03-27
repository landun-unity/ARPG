
LeagueOperateTipsType =
{

    None = 0,
    --
    -- 退出同盟成功2
    -- --
    QuitLeagueSuccess = 1,

    --
    -- 踢人成功3
    -- --
    KickMemberSuccess = 2,

    --
    -- 任命官员成功4
    -- --
    AppointOfficerSuccess = 3,

    --
    -- 建盟成功5
    --
    CreateLeagueSuccess = 4,

    --
    -- (盟主/副盟主)同意加入同盟成功6
    --
    AgreeJoinSuccess = 5,

    --
    -- 拒绝玩家入盟成功7
    --
    RefusePlayerJoinSuccess = 6,

    --
    -- (玩家)同意加入同盟成功8
    --
    JoinLeagueSuccess = 7,

    --
    -- 罢免官员成功9
    -- --
    RecallOfficerSuccess = 8,

    --
    -- 任命太守成功10
    AppointChiefSuccess = 9,

    --
    -- 罢免太守成功11
    -- --
    RecallChiefSuccess = 10,

    --
    -- 放弃自己的副盟主12
    -- --
    GiveUpMyViceLeagueSuccess = 11,

    --
    -- 取消禅让成功13
    --
    CancelDemiseSuccess = 12,

    --
    -- 发送邀请成功14
    --
    SendApplyInventSuccess = 13,

    --
    -- 申请加入同盟发送成功15
    --
    ApplyJoinLeagueSuccess = 14,

    --
    -- 取消申请加入同盟成功16
    --
    CancelApplyJoinLeagueSuccess = 15,

    --
    -- 添加同盟标记成功17
    --
    AddLeagueMarkSuccess = 16,

    --
    -- 删除同盟标记成功18
    --
    RemoveLeagueMarkSuccess = 17,

    ------------------------------------------------------------------------------------------分割线------------------------------------------------------------------------------------------------------------

    --
    -- 人数已达最大上限19
    -- --
    MemberOutOfLimit = 18,

    --
    -- 已有同盟20
    -- --
    AlreadyHaveLeague = 19,

    --
    -- 不存在此同盟了21
    --
    HaveNoSuchLeague = 20,

    --
    -- 没有足够的权限22
    --
    HaveNotEnoughPower = 21,

    --
    -- 解散同盟成功23
    --
    DissolveLeagueSuccess = 22,


    PlayerHaveNoLeague = 23,

    --
    -- 已经没有官职了25
    --
    HaveNoTitle = 24,

    --
    -- 已经不是太守了26
    --
    HaveNoChief = 25,

    --
    -- 已经有官职了27
    --
    AlreadyHaveTitle = 26,

    --
    -- 已经是此城太守了28
    --
    AlreadyIsThisChief = 27,

    --
    -- 入盟/建盟冷却中29
    --
    JoinInCooling = 28,

    --
    -- 同盟内人数大于1 30
    --
    MemberBiggerThanOne = 29,

    --
    -- 没在申请列表内31
    --
    IsNotInApplyList = 30,

    --
    -- 没有此玩家32
    --
    HaveNoSuchPlayer = 31,

    --
    -- 同盟申请已关闭33
    --
    ApplyIsShutDown = 32,

    --
    -- 设置关系冷却中34
    --
    ConfigDiplomacyCooling = 33,

    --
    -- 势力不足800  35
    --
    InfluenceIsNotEnough = 34,

    --
    -- 错误捐献36
    --
    IsWrongDonate = 35,

    --
    -- 没有足够资源337
    --
    HaveNotEnoughResource = 36,

    --
    -- 同盟已达最大等级3638
    --
    LeagueIsMaxLevel = 37,

    --
    -- 设置外交关系成功3739
    --
    CofigDiplomacySuccess = 38,

    --
    -- 捐献成功3840
    --
    DonateSuccess = 39,

    --
    -- 已达最大同盟标记限制 41
    --
    AlreadyMaxMarkLimit = 40,

    --
    -- 土地已被标记4042
    --
    TitledAlreadyMark = 41,

    --
    -- 同盟标记已被删除4143
    --
    MarkAlreadyDelete = 42,

    --
    -- 沦陷状态中44
    --
    AlreadBeFalled = 43,

    --
    -- 已经设置过同盟关系了45
    AlreadConfig = 44,



    AlreadyExistLeague = 45,

    -- 不能对自己设置外交关系
    CannotDiplomacyMySelf = 46,


    RevoltDonateSuccess = 47,

    -- 反叛成功
    RevoltSuccess = 48,

    -- 刷新同盟公告成功
    RefreshLeagueNoticeSucess = 49,

    -- 同盟没在本州内
    LeagueNotInLocalSpawn = 50,

    -- 邀请玩家加入同盟分组成功
    InventLeagueChatTeamSuccess = 51,

    -- 踢人出同盟聊天分组
    KickMemberOutChatTeam = 52,

    -- 修改同盟聊天分组名字成功
    ChangeLeagueChatNameSuccess = 53,

    -- 创建同盟聊天分组成功
    CreateLeagueChatTeamSuccess = 54,

    -- 同意加入时候已经不再申请列表里面
    areadyDisInList = 55,
    --
    -- 结束54
    --
    End;
}

return LeagueOperateTipsType;