-- 空的操作
local BaseOperator = require("Game/Map/Operator/BaseOperator")

local ZoomOutOperator = class("ZoomOutOperator", BaseOperator)

-- 构造函数
function ZoomOutOperator:ctor()
    self._operatorType = nil;

    ZoomOutOperator.super.ctor(self, OperatorType.ZoomOut);
end

-- 是否可以进入状态
function ZoomOutOperator:CanEnterOperator(operatorType)
    
    self._operatorType = operatorType;

    if operatorType == OperatorType.Empty or operatorType == OperatorType.CancleClick or operatorType == OperatorType.Extension or operatorType == OperatorType.ClickBuilding then
        return true;
    end

    return false;
end

function ZoomOutOperator:EnterOperator(...)
    if ... == nil then
        return;
    end
    ClickService:Instance():ShowCityName(...);
end

function ZoomOutOperator:LeaveOperator()
	if self._operatorType == OperatorType.Empty then
        ClickService:Instance():HideCityName();
    end
end

return ZoomOutOperator;
