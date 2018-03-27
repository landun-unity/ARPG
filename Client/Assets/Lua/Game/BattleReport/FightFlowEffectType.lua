--战斗流程效果枚举

FightFlowEffectType ={
	-- 攻击
	ChangeAttack = 1,

	-- 防御
	ChangeDefens = 2,

	-- 谋略
	ChangeStraegy = 3,	
    
	-- 速度
	ChangeSpeed = 4,	
    
	-- 攻城值
	ChangeSigeValue = 5,	
    
	-- 做伤害
	DoDamage = 6,	
    
	-- 添加状态
	AddState = 7,	
    
	-- 改变攻击距离
	ChangeAttackRange = 8,	
    
	-- 改变攻击百分比
	ChangeAttackPer = 9,	
    
	-- 改变防御百分比
	ChangeDefensPer = 10,
    
    -- 改变速度百分比
	ChangeSpeedPer = 11,
    
    -- 改变谋略百分比
	ChangeStraegyPer = 12,
    
    -- 改变攻城值百分比
	ChangeSigeValuePer = 13,
    
    -- 已经拥有一个状态
	HasOneState = 14,
    
    -- 恢复兵力
	RecoveryTroop = 15,
    
    -- 移除BUFF
	RemoveBuff = 16,	
}

return FightFlowEffectType