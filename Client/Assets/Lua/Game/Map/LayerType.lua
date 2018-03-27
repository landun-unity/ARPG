-- 地图层的类型
LayerType = 
{
    -- 错误的
    Error = 0,

    -- 州郡
	State = 1,
	
	-- 陆地
	Land = 2, 
	
	-- 路
	Road = 3, 
	
	-- 山
	Moutain = 4, 
	
	-- 资源层
	ResourceFront = 5, 
	
	--对象层
	Building = 6, 

	--野城层
	FieldBuilding = 7,

	-- 部队层
	Army = 8,

	-- 势力层
	Power = 9,

	-- 线
	Line = 10, 

    -- 视野
	View = 11, 

    -- 资源地事件
	SourceEvent = 12, 

	--UI
	UI = 13;

	-- 资源层
	ResourceBehind = 14,

	--野外建筑
	WildFort = 15,
    
    --虚线
    ImaginaryLine = 16, 

    -- 行为层（驻守）
    Sign = 17,

    -- 部队行为层2(练兵、屯田)
    ArmyBehaviourTwo = 18,

    --旗帜
    Flag = 19,

    --部队行走倒计时层
    ArmyWalkSlider = 20,
}

return LayerType;