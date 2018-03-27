local PmapOperaterManage = class("PmapOperaterManage")
require("Game/Map/Operator/OperatorType")

-- 操作管理
function PmapOperaterManage:ctor()
    -- 所有的操作Map
    self.allOperatorMap = {};
    -- 当前的操作
    self.curOperator = nil;
end

-- 进入操作
function PmapOperaterManage:EnterOperator(operatorType, ...)
    if self.curOperator ~= nil and self.curOperator:CanEnterOperator(operatorType) == false then
        return;
    end

    local operatorObject = self:FindOperator(operatorType);
    if operatorObject == nil then
        return;
    end

    if self.curOperator ~= nil then
        self.curOperator:LeaveOperator(...);
    end

    self.curOperator = operatorObject;
    self.curOperator:EnterOperator(...);
end

-- 注册所有的操作
function PmapOperaterManage:RegisterAllOperator()
    self:RegisterOperator(OperatorType.Empty, "EmptyOperator");
    self:RegisterOperator(OperatorType.Click, "ClickOperator");
    self:RegisterOperator(OperatorType.Move, "MoveOperator");
    self:RegisterOperator(OperatorType.ZoomOut, "ZoomOutOperator");
    self:RegisterOperator(OperatorType.Begin, "BeginOperator");
    self:RegisterOperator(OperatorType.CancleClick, "CancleClickOperator");

    self:RegisterOperator(OperatorType.EndMove, "EndMoveOperator");
    self:RegisterOperator(OperatorType.Extension, "ExtensionOperator");
    self:RegisterOperator(OperatorType.ExtensionClick, "ExtensionClickOperator");
    self:RegisterOperator(OperatorType.ClickBuilding, "ClickBuildingOperator");
end

-- 注册操作
function PmapOperaterManage:RegisterOperator(operatorType, operatorClass)
    if operatorType == nil or type(operatorType) ~= "number" then
        return;
    end

    self.allOperatorMap[operatorType] = require("Game/Map/Operator/" .. operatorClass).new();
end

-- 注册操作的回调
function PmapOperaterManage:RegisterCallBack(operatorType, enterFunction, leaveFunction)
    local operatorObject = self.allOperatorMap[operatorType];
    if operatorObject == nil then
        return;
    end

    operatorObject:SetCallBack(enterFunction, leaveFunction);
end

-- 查找操作类
function PmapOperaterManage:FindOperator(operatorType)
    if operatorType == nil or type(operatorType) ~= "number" then
        return nil;
    end

    return self.allOperatorMap[operatorType];
end

return PmapOperaterManage;

