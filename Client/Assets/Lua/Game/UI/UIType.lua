﻿
--[[
    Name:UIType
    anchor:Dr
    Data:16/9/7
    attention��o??����?�¨�??????1��??��??
--]]

UIType =
{   
    LoadingUI = 0,
    
    UIBegin = 1,
    -- 2a��?��??a��?????
    UILogin = 2,
    -- 2a��?��?��???????
    UILoginGame = 3,
    -- ��??����???????
    UIGameMainView = 4,
    -- ��??��?��????
    UIRegisterAccount = 5,
    -- ����2��??o?????
    UIFoundPlayer = 6,
    -- ���?����??��????
    UIHeroCardPackage = 7,
    -- ????��3�㨹????
    UIHeroCard = 8,
    -- ?????��?��??
    UIHeroHandbook = 40,
    -- ????��???
    UIHeroHandbookCard = 41,
    -- ????��????��
    UIHeroCardInfo = 42,
    -- ?????��?��????
    UIHeroSpliteSkill = 43,
    -- ??����2e?a????
    UIHeroSpliteHero = 44,
    -- 2e?a????
    UIHeroAdvance = 45,
    -- ???????��
    UIHeroAwake = 46,
    -- ??????D?
    -- �����ԱԤ֪
    underMemberLeagueUI = 47,

    UITactis = 9,
    -- ??������3�㨹
    UISkillIcon = 10,
    -- ??������?����?��??
    LeagueUI = 12,
    -- ��????a??????
    LeagueDisExistUI = 13,
    -- ?��?����?��???????
    LeagueExistUI = 14,
    -- ��??����?��???????
    LeagueMemberUI = 15,
    -- ��???3��?��????
    LeagueAddUI = 16,
    -- ����???����?��???????
    LeagueInviteUI = 17,
    -- ��???????????
    LeagueIntroUI = 18,
    -- ��????������????
    LeagueAttentionUI = 19,
    -- ��???1|?��????
    LeagueLeaderInfoUI = 20,
    -- ???��D??��????
    InviteLeagueUI = 21,
    -- ��???????UI?��??
    PlayerInfoUI = 22,
    -- ��???D??��UI????
    AppiontLeagueUI = 23,
    -- ???����???????
    MemberLeagueUI = 24,
    -- ��???3��?��UI?��??
    AddLeagueUI = 25,
    -- ???����???UI?��??
    MemberPowerUI = 26,
    -- ��???3��?������?T?��??
    LeaderSelfPowerUI = 27,
    -- ???�¡�?��������?T?��??
    LeaderOtherPowerUI = 28,
    -- ???�¨���?T?��??
    LeagueOfficePosUI = 29,
    -- 1��?��?????��??
    ConfirmCancelUI = 30,
    -- ������?��????��??
    LeagueMemberAddUI = 31,
    -- ����?��3��?��????
    AddMemberUI = 32,
    -- ����?��3��?��?��??
    LeagueRequireInUI = 33,
    -- ???��?����?????
    RequireMemberUI = 34,
    -- ???��?����??��??
    LeaderRecallOtherPowerUI = 35,
    -- ???�¨�???????3��?������?T?��??
    CloseRequest = 36,
    -- 1?��?????
    SLeaderOtherPower = 37,
    -- ?��???�¨���?T?��??
    SLeaderRecallOtherPower = 38,
    -- ?��???�¨�???1��?��?��??
    SLeaderSelfPower = 39,
    -- ?��???�¡�?��������?T
    LeagueDonate = 200,
    -- ��????��?��????
    LeagueInfluence = 220,
    -- ��???��?��|
    UICityInfo = 221,
    -- ��???��?��|?��??
    relationLeague = 222,
    -- 1??�̨�????��?a
    LeagueForigen = 223,
    -- ��???��a??
    UILeagueMark = 224,
    -- Í¬ÃË±ê¼Ç
    FirstBattleNoAtk = 226,
    -- µØÍ¼ÐÅÏ¢Ô¤Öª
    PmapMateInfoUI = 275,

    rebellUI = 297,

    UIArmyFlag = 240,   --部队旗帜

    -- Ð¡µØÍ¼
    UIMinMap = 230,
    -- ÍË³öÍ¬ÃË
    ConfirmQuitLeague = 298,

    FirstBattle = 225,
    -- Ê×Õ½½±Àø
    RelationUI = 227,

    PmapPrefab = 228,

    CityBuildQueueItem = 55,
    UIMainCity = 50,
    -- ��??��3?3?
    CityShow = 51,
    -- 3?3?��?
    UIPandectObj = 52,
    UITextBox = 53,
    --  UIRecruitUI = 12,--?D??????
    --  UIRecruitKindItem = 13,--?D????����?��??��?
    --  UILand = 14, --������?D??��????
    --  UIBuild = 15, --?t3?????
    --  UIFort = 16, --?��?����a��?????
    -- ?��?t
    UIInternalAffairsImage = 651,

    UIScorll = 98,

    -- ???��????
    UIRecruitUI = 150,
    -- ?D??????
    UIRecruitKindItem = 151,
    -- ?D????����?��??��?
    RecruitHeroCards = 152,
    -- ������ļ
    UIRecruitBath = 153,
    -- ������ļ���鷵��
    UIBatchRecruit = 154,
    -- ������ļitem
    BatchRecruitItem = 155,

    --资源地加载的UI
    SourceEventItem = 156,

    --招募到四星以上的特效预制
    FourStarHeroEffect = 157,

    -- ?D????��??��??????

    UITactisTransExp = 160,
    -- ??������a???-?��????
    UITactisDetail = 161,
    -- ??����?��?��????
    UITactisResearch = 162,
    -- ??����?D??????
    TactisResearchSuccessful = 163,
    -- ??����?D??3��1|????

    UIBattleReport = 170,
    -- ??����????
    UIBattleReportItem = 171,
    -- ??����??����
    UIBattleReportDetail = 172,
    -- ??����?��?��
    UIBattleReportDetailItem = 173,
    -- ??����?��?��
    UIBattleReportItemArmy = 174,
    -- ??�����䨮��a?�訤��
    UIBattleReportRound = 175,
    -- ??o??��???��??��?
    UIBattleReportPersionRound = 176,
    -- ??��???o??��???��?�쨬?
    UIBattleReportCount = 177,
    -- ??������3??????
    UIBattleReportCountArmy = 178,
    -- ??������3??????��?��|
    UIBattleReportCountArmyItem = 179,
    -- ??������3??��?��|
    UIBattleReportDetailCard = 180,
    -- ??����?��?��?��??

    UICommonTipSmall = 190,
    -- 1?��?D?������?
    UICommonTip = 191,
    -- 1?��?������?
    CommonOKOrCancle = 192,
    -- 1?12������?��????��
    CommonGoToPosition = 193,
    -- 1?12��?��?��?��a��??3??��?����

    UIToken = 100,
    -- ?t��?????
    -- UILand = 101, --������?D??��????(?��??)
    UIBuild = 102,
    -- ?t3?????
    UIFort = 103,
    -- ?��?����a��?????
    UISelfLandFunction = 104,
    -- �����̡��?������?��?������?��?���診?????
    UISign = 105,
    -- ����??������?
    UIConfirm = 106,
    -- ������?�����̡��?������?��?������?��?���診?????
    UIInternal = 107,
    -- ?��?t????
    UIAbandonSoil = 108,
    -- ��??��������?
    UIMountain = 109,
    -- ��?�䡧�ꡧ?��??��?
    UIConfirmBuild = 110,
    -- ����?��?��?����a��?????
    UITheFort = 111,
    -- ��a��?????
    UIUpgradeFort = 112,
    -- ��y??��a��?????
    UIFortExplain = 113,
    -- ��a��??������????
    UISelfFort = 115,
    -- ��??�¡�??����a��?????�ꡧ��??��??��?
    UIAffirmUnseam = 116,
    -- ����?����??����??����a��?????
    UIWildernes = 117,
    -- �����?????�ꡧ��??��??��?
    UIPubilcClick = 229,
    -- Í¬ÃË°´Å¥Ô¤ÖÆ

    UIWildCity = 118,
    -- ����3?�ꡧ?��??��?
    WildeFortress = 119,
    -- ���㨪a?����a�ꡧ?��??��?
    UICustomsPass = 120,
    -- 1??���ꡧ?��??��?
    UIRiver = 121,
    -- o�����¡ꡧ?��??��?
    UIWildCityTown = 122,
    -- ����3?3???�ꡧ?��??��?
    UIMainCityTown = 123,
    -- ?��3?3???�ꡧ?��??��?
    UIWildeFort = 124,
    -- ���㨪a��a��?�ꡧ?��??��?
    UIOneselfSoilObj = 125,
    -- ?t3??��?�¡ꡧ?��??��?
    UIFortificationExplain = 127,
    -- ·Ö³Ç½çÃæ£¨Ô¤ÖÆ£©
    UIPointsCityPanel = 128,
    -- ????��??��3?3?
    UIOthersCity = 129,


    -- 地块顶端面板
    PanelTop = 130,


    --出征按钮
    UIButton_Battle = 131,
    --扫荡按钮
    UIButton_Sweep = 132,
    --屯田按钮
    UIButton_HoardGrain = 133,
    --练兵按钮
    UIButton_Train = 134,
    --驻守按钮
    UIButton_Garrison = 135,
    --调动按钮
    UIButton_Transfer = 136,
    --筑城按钮
    UIButton_BuildCity = 137,
    --解救按钮
    UIButton_Save = 138,
    --城市按钮
    UIButton_City = 139,
    --要塞按钮
    UIButton_Fort = 140,

    -- 地块右側面板
    PanelRight = 141,

    -- 被占领其他玩家城池
    UIOccupyOtherCityTown = 142,

    UIFacility = 201,
    -- ������?????
    UIFacilityProperty = 202,
    -- ?��?��????
    UIFacilityCancel = 203,
    -- ��???????
    UIConscriptionItem = 248,
    UISmallHeroCard = 249,
    -- D?����D??��?��??
    UIConscription = 350,
    -- ?�¡�?????
    ConscriptionConfirmUI = 351,
    -- ?�¡�?������?????
    ArmyFunctionUI = 352,
    -- ?��?��1|?��????(?????��?��?��?�¡�??��?��?��?��??)
    ArmySwapUI = 353,
    -- ?��?��?��??????
    ArmySwapItem = 354,
    -- ?��?��?��??????item?��??
    ArmyRemoveCardTipUI = 355,
    -- ÒÆ³ý¿¨ÅÆÈ·ÈÏ½çÃæ
    ArmyAdditionUI = 356,

    RechargeUI = 360,
    -- 3??��????
    RechargeItem = 361,
    -- 3??�̨�D����?��??
    RechargeGetMonthCardUI = 362,
    -- ������????��????
    MailUI = 363,
    -- ÓÊ¼þ½çÃæ
    MailWriteUI = 364,
    -- Ð´ÓÊ¼þ½çÃæ
    MailInfoItem = 365,
    -- ÓÊ¼þÁÐ±íitemÔ¤ÖÆ
    MailChatItem = 366,
    -- ÓÊ¼þÁÄÌìÁÐ±íitemÔ¤ÖÆ
    LinkManUI = 367,
    -- ÓÊ¼þÑ¡ÔñÁªÏµÈË½çÃæ
    LinkManItem = 368,
    -- ÓÊ¼þÑ¡ÔñÁªÏµÈË½çÃæ
    OperationUI = 369,
    -- Íæ¼Ò²Ù×÷½çÃæ

    GameBulletinBoardUI = 370,
    -- ?��?����?????
    GameBulletinItem = 371,
    -- ?��?����??��??
    PlayerInformationUI = 372,

    TroopsArrayPanel = 300,
    -- 2??��?����Y
    CamyIntroduce = 301,
    -- ?��???������
    ExplainPanel = 302,
    -- 3?��D?��?��
    ArmySwap = 303,
    -- 2??��?��??
    Extension = 304,
    -- ������?��??��
    CityObj = 305,
    -- 3?3?���?��
    UICityTroops = 306,
    -- 3?3??��??
    UICityCard = 307,
    -- 3?3??��???��??
    UIExtensionConfirm = 308;-- ��??��������?

    ArmyTipStateInfo = 400,
    -- ��?3??�¡�����?������??����D?�訦��
    UIArmyBattleDetail = 401,
    -- ��?3??�¨�����??1��?D??��?�訦��
    UIWarrListWnd = 402,
    -- 3?3?��??��?����D��D������㨬?????
    UIWarrCard = 403,
    -- 3?3??��?��?��???�訦��
    MessageBox = 404,
    -- D??�騬����?????
    UIStartTroopsImage = 405,
    UIArmyDetailGrid = 406,

    UIPmap = 500,
    --- �̡�3?��?��?????
    UIMateInfo = 501,
    -- ��?��?D??��?��??
    UIPic = 502,
    -- �̡�3?��?��?3??��?�訦��

    UIBorn = 510,
    -- 3?����???Y????

    UIActivity = 520,
    -- ???��????
    UILoginActItemScan = 521,
    -- ��??????��?1��????��????
    UITask = 522,

    UISignMainLocate = 654,
    
    --同盟分组
    UIAllianceChat = 655,

     --同盟分组信息
    UIAllianceInformation = 656,
    -- ��???????

    UICueMessageBox = 600,

    -- 个人势力
    UIPersonalPower = 601,

    --领土类型选择
    UILigeanceToggleAdd = 602,

    --领土显示
    UILigeanceAdd = 603,

    --个人介绍
    UIPlayerProfile = 604,

    --游戏公告
    UINotice = 605,

    -- ?�㨺?��3??
    RevenueStatisticsPanel = 652,
    -- ÁÄÌì½çÃæ
    UIChat = 700,

    -- GM¿Í»§¶Ë
    GMCommand = 1000,
    -- GMÃüÁîitem
    GMCommandItem = 1001,

    -- 新手保护期界面
    UINewerPeriod = 1111,

    -- Ҫ��
    UIConfirmfortressBuild = 1200,

    -- ��������
    UIUpgradeBuilding = 1202,

    -- ����
    UIFortOneselfLandFunctionPanel = 1201,

    -- Ҫ������
    UIFortBuilding = 1203,

    UIEpic = 1522,
    WorldTendencyUI = 1523,
    UIEvent = 1524,
    UIClickPic = 1525,
    EpicInfo = 1526,

    UIStartTroopsImage = 405,

    UISignLocate = 653,

    UIDeleteFort = 1205,

    UIDeleteFortCancelMarchAffirm = 1206,

    UIGetItemManage = 1550,

    UIGuideAllScreenClick = 2000,
    UIGuideAllScreenNoClick = 2001,
    UIGuideOneAreaClick = 2002,

    UIConfirmCancel = 2500,

    UIWildCityRewardsExplain = 6000,
    --断线 转圈  以后加的时候往上加 断线是最后一个
    UIDisConnect = 8000,

    UIArrow = 1333,
    -- 开始游戏界面
    UIStartGame = 1112,

    -- 选择服务器界面
    UISelectServer = 1113,
    -- 排行榜界面
    RankListUI = 1301,
    RankListItem = 1302,
    RankListHelpUI = 1303,

    UIBreathingFrame = 1400,
    --二次要塞确认
    UIFortOkBox = 1304,

    --领奖
    UIGetJade = 1305,

}
return UIType;