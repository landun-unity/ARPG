--[[
	变化量计算
--]]

local VariationCalc = class("VariationCalc")

function VariationCalc:ctor()
    -- 上次数量
    self._lastVal = 0

    -- 增长数率
    self._variationVal = 0

    -- 上次更新时间
    self._lastUpdateTime = 0

    -- 更新间隔
    self._variationSpace = 1000

    -- 最大值
    self._maxValue = 2147483648

    -- 是否可以逾越
    self._canOver = false
end

-- 初始化
function VariationCalc:Init(lastValue, lastUpdateTime, bool)
    self._lastVal = lastValue
    self._lastUpdateTime = lastUpdateTime
    self._canOver = bool
end

-- 获取当前值
function VariationCalc:GetValue()
    if self._lastVal >= self._maxValue then
        return self._lastVal
    end
    local updateVal = 0
    local curTimestamp = self:_GetCurSystemTimestamp()
    local variationTime = math.floor((curTimestamp - self._lastUpdateTime) / self._variationSpace)
    updateVal = self._variationVal * variationTime + self._lastVal
    local curVal = updateVal
    if updateVal > self._maxValue then
        curVal = self._maxValue
    end
    return curVal
end

-- 增加当前值
function VariationCalc:ChangeValue(value)
    if value == nil then
        value = 0
    end
    self:_UpdateValue()
    self._lastVal = self._lastVal + value
    if self._canOver == false then
        if self._lastVal >= self._maxValue then
            self._lastVal = self._maxValue
        end
    end
end

-- 设置当前值
function VariationCalc:SetValue(value)
    if value == nil then
        value = 0
    end
    self:_UpdateValue()
    self._lastVal = value
    if self._canOver == false then
        if self._lastVal >= self._maxValue then
            self._lastVal = self._maxValue
        end
    end
end

-- 更新当前数值
function VariationCalc:_UpdateValue()
    if self._variationVal == 0 then
        return
    end
    if self._lastVal ~= self:GetValue() then
        self._lastVal = self:GetValue()
        self._lastUpdateTime = (self:GetValue() - self._lastVal) / self._variationVal * self._variationSpace + self._lastUpdateTime
    end
end

-- 获取当前系统时间戳
function VariationCalc:_GetCurSystemTimestamp()
    return PlayerService:Instance():GetLocalTime()
end

function VariationCalc:SetMaxValue(value)
    self._maxValue=value;
end

function VariationCalc:GetMaxValue()
    -- body
    return self._maxValue;
end

function VariationCalc:GetLastUpdateTime( ... )
    -- body
    return self._lastUpdateTime;
end

function VariationCalc:SetLastUpdateTime(value)
    -- body
    self._lastUpdateTime = value;
end

-- 设置变化量
function VariationCalc:SetVariationVal(variationVal)
    self._variationVal = variationVal
end

function VariationCalc:GetVariationVal()
    -- body
    return self._variationVal;
end

-- 设置更新间隔
function VariationCalc:SetVariationSpace(variationSpace)
    self._variationSpace = variationSpace
end

return VariationCalc


