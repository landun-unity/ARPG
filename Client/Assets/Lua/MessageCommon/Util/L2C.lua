-- 客户端到账号服务器
require("MessageCommon/Util/Terminal")

-- 开始
local Begin = Terminal.Logic * 16777216 + Terminal.Client * 65536;

L2C = 
{
    -- 请求玩家列表
    GetPlayerListRespond = Begin;
    --创建玩家成功
    CreateRoleSuccess = Begin+1;
    --请求武将背包回复
    PlayerHeroCardListMsg=Begin+2;

	OnePlayerAddOneCardRespond = Begin + 3;
    --武将战法返回列表
    GetOnePlayerSkillListRespond = Begin + 4;

    --/******部队返回信息***********/

	 --* 获得部队列表信息
	ArmyRoleCardInfoList= Begin + 5;
	
	 --/******end***********/
	
	 --/********************************************League begin*************************************************/
	
	 --* 创建同盟成功
	CreateLeagueSuccess= Begin + 6;
	
	 --* 创建失败
	CreateLeagueFailed= Begin + 7;
	
	 --* 解散同盟成功
	DissolveLeagueSuccess= Begin + 8;
	
	 --* 解散同盟失败
	DissolveLeagueFailed= Begin + 9;
	
	 --* 打开同盟返回
	OpenLeagueBack= Begin + 10;
	
	 --* 打开同盟返回
	OpenLeagueMemberBack= Begin + 11;
	
	 --* 返回禅让时间点
	DemiseTime= Begin + 12;
	
	 --* 真正处理禅让
	RealHandlerDemise= Begin + 13;
	
	 --* 申请入盟列表下发
	ApplyJoinLeagueList= Begin + 14;
	
	 --* 被邀请盟返回
	BeInventLeagueListRespond= Begin + 15;
	
	 --* 打开周围同盟回复
	OpenRoundLeagueListRespond= Begin + 16;
	
	-- * 操作提示
	LeagueOperationTips= Begin + 17;
	
	-- * 添加同盟标记成功
	AddLeagueMarkRespond= Begin + 18;
	
	 --* 打开任命/罢免窗口响应
	OpenApointOrRecallRespond= Begin + 19;
	
	 --* 打开某个玩家返回
	OpenPlayerInfoInLeagueRespond= Begin + 20;

	 --* 没有盟返回
	OpenNoLeagueRespond= Begin + 21;

    --打开某一个盟返回(非自己盟)
    OpenAppiontLeagueRespond=Begin + 22;

	-- * 下次入盟时间
	NextJoinLeagueTime=Begin + 23;

	 --* 打开周围可邀请玩家list
	OpenRoundPlayerRespond=Begin + 24;

	-- * 打开/关闭同盟申请返回
	ShutJoinApplyLeagueRespond=Begin + 25;
	
	--/********************************************League end*************************************************/
	
	ArmyBattleReturnMsg = Begin + 26;



}