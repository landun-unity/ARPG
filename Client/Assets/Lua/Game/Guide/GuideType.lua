--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

-- 新手引导大步骤

GuideType =
{
	None = 0,
			
	-- 获取第一张武将卡（1）客户端请求
	GetFirstCard = 1,
	
	-- 配置第一个部队大营（2）
	ConfigFirstArmyBack = 2,
	
	-- 第一次 出征（3）
	FirstBattle = 3,
	
	-- 第一次出征到达（4）
	FirstBattleArrive = 4,
	
	-- 点击战报（5）
	OpenBattleReport = 5,
	
	-- 获取第二张武将卡（6）客户端请求
	GetSecondCard = 6,
	
	-- 配置第一个部队中军（7）
	ConfigFirstArmyMid = 7,
	
	-- 立即征兵（8）
	ConscriptionImmediate = 8,
	
	-- 第二次 出征（9）
	SecondBattle = 9,
	
	-- 第二次出征到达（10）
	SecondBattleArrive = 10,
	
	-- 获取新手卡包（11）客户端请求
	GetNewerCardPacket = 11,
	
	-- 招募新手卡包（12）
	Recruit = 12,
	
	-- 开始升级校场（13）
	LevelUpFacility = 13,
	
	-- 升级校场完成（14）
	LevelUpFacilityOver = 14,
	
	-- 配置第二个部队大营（15）
	ConfigSecondArmyBack = 15,
	
	-- 配置第二个部队中军（16）
	ConfigSecondArmyMid = 16,
}

return GuideType;

--endregion