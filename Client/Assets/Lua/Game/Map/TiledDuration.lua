--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

-- 本人拥有的地块耐久类
local TiledDuration = class("TiledDuration");
local VariationCalc = require("Game/Util/VariationCalc")

function TiledDuration:ctor()
    self._maxDuration = 0;
    -- 地块耐久变化量
    self.durableVar = VariationCalc.new()
end

-- 初始化地块耐久信息
function TiledDuration:SetDurableVar(curValue,maxValue,time)
    self._maxDuration = maxValue;
    self.durableVar:Init(curValue,PlayerService:Instance():GetLocalTime(),false)
    self.durableVar:SetVariationVal(maxValue*0.02)
    self.durableVar:SetMaxValue(maxValue)
    self.durableVar:SetVariationSpace(time)
end

-- 获取地块耐久
function TiledDuration:GetDurable()
    return self.durableVar:GetValue()
end

-- 获取地块最大耐久
function TiledDuration:GetMaxDuration()
    return self._maxDuration;
end

return TiledDuration

--endregion
