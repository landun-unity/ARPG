-- 战斗结果类型
ReporterType ={
	
	--空 
	None = 0,
	--占领土地
	
	OccupyLand = 1,

	--占领要塞
	OccupyBuild = 2,
	
	--同盟占领野城
	OccuptWildCity = 3,
	--失去领地
	LoseLand = 4,
	--成功附属
	AttackSucces = 5,
	--被附属
	BeAttackLose = 6,
}

return ReporterType