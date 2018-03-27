
--未发生战斗的枚举类型

NullReportReasonType ={
	
	--没有相邻土地
	NoAdjacentTiled = 0,
	
	--土地免战
	TiledFree = 1,
	
	--土地被占领
	TiledStateChange = 2,
}

return NullReportReasonType