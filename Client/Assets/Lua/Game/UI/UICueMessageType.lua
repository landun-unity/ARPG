--[[
	提示信息枚举
	王伟
--]]


UICueMessageType =
{
    -- ！！！！谁特么的再不按顺序往里插 或者把注释写在下面 被我找log查出来直接下野沦了！！！！！
    --------------------------------------------

    --没钱
    NoMoney = 1,

    --没钻石
    NoJade = 4,

    --沦陷中
    befalled = 7,

    --名称错误
    CorrectName = 8,
    
    --该同盟不在玩家所属州
    LeagueNotInLocalSpawn = 11,
    -- 玩家权限不足
    NoPowerToDo = 14,

    -- 同盟捐献时，势力值不足
    LeagueInfluenceNotEnough = 26,

    -- 出征时，没有相邻地块
    HaveNoBorderTiled = 28,

    -- 屯田，练兵时，玩家政令数量不足
    decreeCount = 36,

    --武将不在城池中
    HeroAbsenceCity = 41,

    --武将保护中
    HeroIsProtect = 42,

    -- 转化队伍中的武将
    HeroInArmy = 56,

    -- 素材卡数量不足
    NoCardForAdvance = 59,

    -- 同盟标记已满
    LeagueMarkFull = 84,

    -- 解散同盟时
    RemoveLeagueMembers = 85,

    -- 部队需返回城市才能再次出征
    ArmyBattleState = 86,

    -- 部队征兵中无法进行出征
    ArmyConscribe = 87,

    -- 三星以下卡牌不可拆解
    CantSpliteTheCard = 88,

    -- 图鉴界面无法进行此操作
    CantOpenInHandBook = 89,

    --武将重伤无法出征
    ArmyGeneralsSevereInjuries = 90,

    --武将体力不足无法出征
    ArmyGeneralsMuscleLack = 91,

    -- 等级不够学技能
    CantLearnSkill =92,

    -- 同盟标记没写东西
    LeagueMarkWriteFalseInfo  =93,

    -- 添加同盟标记成功
    AddLeagueMarkSucess = 94,

    -- 标记成功
    MarkerSucceed = 95,

    -- 取消标记成功
    CancelMarker = 96,

    --关系冷却时间未到
    timeCooling = 97,

    --捐献成功
    DonateSucess =98,

    --没有同盟
    HaveNoLeague = 99,

    --玉符不足
    jadeInadequate = 100,

    -- 不能强征
    nocanForced = 101,

    --请输入“退出”退出同盟
    quitleague = 102,

    --请输入“重置”重置卡牌
    InputReset =46,
  
    --武将低于15级
    LevelUnderfifteen =112,

    --武将未加点
    NoPointAdd = 113,

    --名称存在
    LeagueNameIsUsed = 116,

    --标记已满
    AlreadyMaxMarkLimit =119,

    -- 免战期间不能放弃土地
    CannotGiveUpLand = 123,

    -- 要塞部队以满
    ArmyNumSaturation = 130,

    -- 要塞名字太长
    FortName = 140,

    -- 分城名字太长
    cityName =141,

    -- 免战时间中
    InAvoidTime = 160,

   -- 用户名不能为空
   UserNameIsNone = 124,

   -- 用户名已经存在
   AlreadyHaveName = 125,

   RecruitNoCount = 126,

   PackageCloseInfo = 127,

    -- 要塞不存在
    wildFortNoExistence = 180,

    -- 无法对非友方进行此操作
    UnableDoOperation = 300,

    --此属性没有加点
    NoPointAddAtHere = 902,
     --没有点数
    NoPointCanAdd = 903,
    
    --已学习战法
    LearnedSkill = 904,

    --无法遗忘战法
    CanNotDeleteSkill = 905,

      --没有权限
    HaveNoPower =1002,


      --没有输入名称
      PleaseInPutName = 1008,
    CofigDiplomacySuccess =1209,
    -- 输入坐标有误
    PositionIsWrong = 2100,

    --请先选择自定义次数
    ChooseFirst = 2300,

    --请拖动滑块选择自定义招募次数
    SlideFirst = 2301,

    --请先选择上方的招募方式
    ChooseMothed = 2302,

    -- 征兵中的部队无法进行行动
    armyConscribe = 5000,

    -- 行军距离大于500,无法派出部队
    armyDistanceMark=6000,

    -- 练兵过程中政令可能不足，不足部队会自动撤退
    trainingCount = 7000,

    FortSensitiveWords = 7001,

    SubCitySensitiveWords = 7002,

    playerNameSensitiveWords = 7003,

    leagueNameSensitiveWords = 7004,

    areadyDisInList = 7005,

    passWordError = 8000,

    UserNameExistence = 8001,

    GoodTVDreamWordsUserName = 8002,
    GoodTVDreamWordsPassWord = 8003,
    TwicePassWordUnlike = 8004,
    AccountPasswordAllNone = 8005,

    -- 未选择服务器分区
    NoSelectServerRegion = 8006,

    -- 目标地块已经占领
    IsAreadyOccupy = 8007,

    DetectionTirm = 8010,
    --要塞确认提示输入不正确
    InputIsWrong = 8011,

    TradePrompt =8012,

    TradeGoalResource = 8013,

    sliderIsZero = 8014,

    SameResourceNoTrade = 8015,

    resourceTypeSame = 8016,
    --------------------------------------------
    -- ！！！！谁特么的再不按顺序往里插 或者把注释写在下面 被我找log查出来直接下野沦了！！！！！
    -- !!! 插插插
}
return UICueMessageType;