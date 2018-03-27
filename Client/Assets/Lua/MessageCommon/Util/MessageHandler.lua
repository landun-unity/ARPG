--所有的系统区分
MessageHandler = 
{
	--系统调用相关
	System = 0, 
	
	--账号登陆
	EhooLogin = 1,
	
	--账号相关
	Account = 2, 
	
	--玩家相关
	Player = 3, 
	
	--建筑物相关
	Building = 4, 
	
	--地图相关
	Map = 5, 
	
	--同盟
	League = 6,
	
	--技能
	Skill = 7, 
	
	--部队
	Army = 8, 
	
	--卡牌
	Card = 9, 

	-- 货币
	Currency = 10,

	-- 设施
	Facility = 11,

    --战报
    BattleReport = 12,

    --充值
    Recharge = 13,

    --邮箱
    Mail = 14,

    --GM
    GM = 15,

    --招募
    Recruit = 16,

    --任务
    Task = 17,

    --天下大势
    WorldTendency = 18,

	--跑马灯
	Marquee = 19,

    --资源地事件
    SourceEvent = 20,
	
	-- 聊天
	Chat = 21, 

	-- 个人势力
	PersonalPower = 22,

	--GM后台
	GMBackGround = 23,
	
	--排行榜
	Ranklist = 24,

	-- 内政
	DomesticAffairs = 25,


}

return MessageHandler;
