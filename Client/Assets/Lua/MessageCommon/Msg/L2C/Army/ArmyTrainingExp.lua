--
-- 逻辑服务器 --> 客户端
-- 部队练兵经验
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ArmyTrainingExp = class("ArmyTrainingExp", GameMessage);

--
-- 构造函数
--
function ArmyTrainingExp:ctor()
    ArmyTrainingExp.super.ctor(self);
    --
    -- 部队练兵经验
    --
    self.marchTime = 0;
end

--@Override
function ArmyTrainingExp:_OnSerial() 
    self:WriteInt32(self.marchTime);
end

--@Override
function ArmyTrainingExp:_OnDeserialize() 
    self.marchTime = self:ReadInt32();
end

return ArmyTrainingExp;
