--[[
	部队状态
--]]

ArmyState =
{
	-- 空状态
	None = 0,

	-- 出征的路上
	BattleRoad = 1,

	-- 战平
	BattleIng = 2,

	-- 扫荡路上
	SweepRoad = 3,

	-- 扫荡战平
	SweepIng = 4,

	-- 驻守路上
	GarrisonRoad = 5,

	-- 驻守中
	GarrisonIng = 6,

	-- 屯田路上
	MitaRoad = 7,

	-- 屯田中
	MitaIng = 8,

	-- 练兵路上
	TrainingRoad = 9,

	-- 练兵中
	Training = 10,

	-- 解救路上
	RescueRoad = 11,

	-- 解救中战平
	RescueIng = 12,

	-- 调动路上
	TransformRoad = 13,

	-- 调动到达
	TransformArrive = 14,

	-- 返回中
	Back = 15,
}

return ArmyState;
