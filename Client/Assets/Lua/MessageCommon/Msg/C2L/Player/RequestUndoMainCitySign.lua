--
-- 客户端 --> 逻辑服务器
-- 主城取消标记信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestUndoMainCitySign = class("RequestUndoMainCitySign", GameMessage);

--
-- 构造函数
--
function RequestUndoMainCitySign:ctor()
    RequestUndoMainCitySign.super.ctor(self);
    --
    -- 索引
    --
    self.tiledIndex = 0;
end

--@Override
function RequestUndoMainCitySign:_OnSerial() 
    self:WriteInt32(self.tiledIndex);
end

--@Override
function RequestUndoMainCitySign:_OnDeserialize() 
    self.tiledIndex = self:ReadInt32();
end

return RequestUndoMainCitySign;
