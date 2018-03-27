
--Õ½±¨µÄÐ§¹ûÀàÐÍ

BattleReportEffectType ={
	
	--¿ÕµÄ
	None = 0,
	
	--¹¥»÷
	ChangeAttack = 1,
	
	--·ÀÓù
	ChangeDefens = 2,
	
	--Ä±ÂÔ
	ChangeStraegy = 3,
	
	--ËÙ¶È
	ChangeSpeed = 4,
	
	--¹¥³ÇÖµ
	ChangeSigeValue = 5,
	
	
	--¸Ä±ä¹¥»÷¾àÀë
	ChangeAttackRange = 6,

	--ÆÕ¹¥ÉËº¦ÔöÇ¿°Ù·Ö±È
	CommonDamageAddPC = 7,
	
	--Õ½·¨ÉËº¦ÔöÇ¿°Ù·Ö±È
	SkillDamageAddPC = 8,
	
	--Ôì³ÉÎïÀíÉËº¦¼ÓÉî°Ù·Ö±È
	SetPhysicsDeepenPC = 9,
	
	--Ôì³É²ßÂÔÉËº¦¼ÓÉî°Ù·Ö±È
	SetStrategyDeepenPC = 10,
	
	--ÊÜµ½ÎïÀíÉËº¦¼ÓÉî°Ù·Ö±È
	GetPhysicsDeepenPC = 11,
	
	--ÊÜµ½²ßÂÔÉËº¦¼ÓÉî°Ù·Ö±È
	GetStrategyDeepenPC = 12,

	--¸Ä±ä¹¥»÷°Ù·Ö±È
	ChangeAttackPer = 13,
	
	--¸Ä±ä·ÀÓù°Ù·Ö±È
	ChangeDefensPer = 14,
	
	--¸Ä±äÄ±ÂÔ°Ù·Ö±È
	ChangeStraegyPer = 15,
	--¸Ä±äËÙ¶È°Ù·Ö±È
	ChangeSpeedPer = 16,
	
	

    --×öÉËº¦
	DoDamage = 17,
	
	--Ìí¼Ó×´Ì¬
	AddState = 18,

	--ÒÑ¾­ÓµÓÐÒ»¸ö×´Ì¬
	HasOneState = 19,
	
	--»Ö¸´±øÁ¦
	RecoveryTroop = 20,
	
	--ÒÆ³ýBUFF
	RemoveBuff = 21,

    --Ìí¼ÓBUff
    AddBuff = 22,

	--×·»÷
	Pursuit = 23,
	
	--½ûÖ¹·Å¼¼ÄÜ
	NoDoSkill = 24,
	
	--½ûÖ¹ÆÕ¹¥
	NoCommanAttack = 25,
	
	--ÓµÓÐÏàÍ¬µÄbuff
	HasSameBuff = 26,

	--ÓµÓÐÆäËûÀàÐÍµÄbuff
	HasOtherBuff = 27,

    --buff±»Ìæ»»ÁË
	ReplaceBuff = 28,

    --攻击距离不够
    AttackRangeNotEnough = 29,

    --移除属性
	RemoveProper = 30,

    --两次普攻
    DoubleAttack = 31,

    --攻击方兵力
    AttackTroopNum = 32,

    --防守方兵力
    DefenseTroopNum = 33,

    --普通攻击距离不足
    NormalAttackRangeNotEnough = 34,

    --反击
    AttackBack = 35,

    --溃逃
    Flight = 36,

    --普通攻击伤害
	NormalAttackDamage = 37,

	--没有可被移除的效果
	NoCanBeRemoveBuff = 38,

	--断准备技能
	StopReadySkill = 39,

	--BUFF没有生效
	BuffNotEffect = 40,
	
	
	--buff生效
	BuffEffect = 41,

	-- Buff的伤害
	DoBuffDamage = 42,


	-- 兵种加成
	ArmsAddition = 43,
	
	-- 阵营加成
	CampAddition = 44,

	-- 优先行动
	AdvanceAction = 45,
}

return BattleReportEffectType