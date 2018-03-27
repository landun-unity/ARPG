--
-- 逻辑服务器 --> 客户端
-- 返回标记信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ReturnUnmarkResult = class("ReturnUnmarkResult", GameMessage);

--
-- 构造函数
--
function ReturnUnmarkResult:ctor()
    ReturnUnmarkResult.super.ctor(self);
    --
    --  返回已标记格子index
    --
    self.tiledIndex = 0;
end

--@Override
function ReturnUnmarkResult:_OnSerial() 
    self:WriteInt32(self.tiledIndex);
end

--@Override
function ReturnUnmarkResult:_OnDeserialize() 
    self.tiledIndex = self:ReadInt32();
end

return ReturnUnmarkResult;
