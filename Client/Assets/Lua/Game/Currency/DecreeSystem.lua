local DecreeSystem = class("DecreeSystem")

function DecreeSystem:ctor()
    -- 上次数量
    self._lastVal = 0

    -- 增长数率
    self._variationVal = 0

    -- 上次更新时间
    self._lastUpdateTime = 0

    -- 更新间隔
    self._variationSpace = 1

    -- 最大值
    self._maxValue = 2147483648;

    --当前值
    self._curValue = 0;

    --逾越值
    self._overValue = 0;
end

function DecreeSystem:Init(lastValue,variationVal,variationSpace)
    self._lastVal = lastValue
    self._variationVal = variationVal;
    self.variationSpace = variationSpace;
end

function DecreeSystem:GetCurValue()
    -- body
    self._lastVal = self:GrowthValue();
    return self._lastVal + self._overValue;

end

function DecreeSystem:GrowthValue()
    -- body
    local updateVal = 0
    local curTimestamp = PlayerService:Instance():GetLocalTime()/1000;
    local variationTime = (curTimestamp - self._lastUpdateTime) / self._variationSpace
    updateVal = self._variationVal * variationTime + self._lastVal;
    self._lastUpdateTime = self._lastUpdateTime + self._variationSpace * math.floor(variationTime);
    -- print(self._variationSpace);
    -- print(variationTime)
    -- print(math.floor(variationTime));
    -- print(self._lastUpdateTime);
    if updateVal > self._maxValue then
        return self._maxValue
    end
    return math.floor(updateVal)
end

function DecreeSystem:ChangeCurValue(value)
    -- body
    -- if self._lastVal+self._overValue >= self._maxValue and self._overValue + self._lastVal + value < self._maxValue then
    --     self._lastUpdateTime = self:_GetCurSystemTimestamp();
    -- end
    -- if self._lastVal + value <= self._maxValue then
    --     self._lastVal = self._lastVal+value;
    -- else
    --     self._overValue = self._lastVal+value-self._maxValue+self._overValue;
    --     self._lastVal = self._maxValue;
    -- end    
    
    if value > 0 then
        if self._lastVal + value <=self._maxValue then
            self._lastVal = self._lastVal + value;
        else
            self._overValue = self._lastVal + value - self._maxValue + self._overValue;
            self._lastVal = self._maxValue;
            self._lastUpdateTime = PlayerService:Instance():GetLocalTime()/1000;
        end
    elseif value < 0 then
        self._lastUpdateTime = PlayerService:Instance():GetLocalTime()/1000;
        if self._overValue + value >= 0 then 
            self._overValue = self._overValue + value;
        else
            self._lastValue = self._lastValue +self._overValue+ value;
            self._overValue = 0;
        end
    end
    
end

function DecreeSystem:UpdateCurValue(value)
    -- body
    if value > self._maxValue then
        self._lastVal = self._maxValue ;
        self._overValue = value - self._maxValue;
    else
        self._lastVal = value;
        self._overValue = 0;
    end
end

function DecreeSystem:SetMaxValue(value)
    -- if self._lastVal + self._overValue >= self._maxValue then
    --     self._lastUpdateTime = PlayerService:Instance():GetLocalTime()/1000;
    -- end
    -- if self._lastVal + self._overValue >= value then
    --     self._lastUpdateTime = PlayerService:Instance():GetLocalTime()/1000;
    -- end
    -- if self._lastVal >= value then
    --     self._overValue = self._lastVal - value;
    --     self._lastVal = self._maxValue;
    --     self._lastUpdateTime = PlayerService:Instance():GetLocalTime()/1000;
    -- end
    local curValue = self:GetCurValue();
    if curValue >= value then
        self._overValue = curValue - value;
        self._lastVal = value;
        self._lastUpdateTime = PlayerService:Instance():GetLocalTime()/1000;
    elseif curValue < value then
        self._overValue = 0;
        self._lastVal = curValue;
    end
    self._maxValue=value;
end

function DecreeSystem:GetMaxValue()
    -- body
    return self._maxValue;
end

function DecreeSystem:GetLastUpdateTime()
    -- body
    return self._lastUpdateTime;
end

function DecreeSystem:SetLastUpdateTime(value)
    -- body
    self._lastUpdateTime = value;
end

-- 设置变化量
function DecreeSystem:SetVariationVal(variationVal)
    self._variationVal = variationVal
end

function DecreeSystem:GetVariationVal()
    -- body
    return self._variationVal;
end

-- 设置更新间隔
function DecreeSystem:SetVariationSpace(variationSpace)
    self._variationSpace = variationSpace
end

function DecreeSystem:GetVariationSpace()
    -- body
    return self._variationSpace;
end

function DecreeSystem:SetOverValue(value)
    -- body
    self._overValue = value;
end

function DecreeSystem:GetOverValue( ... )
    -- body
    return self._overValue;
end

return DecreeSystem;