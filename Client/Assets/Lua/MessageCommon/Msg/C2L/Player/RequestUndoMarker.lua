--
-- 客户端 --> 逻辑服务器
-- 取消标记
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestUndoMarker = class("RequestUndoMarker", GameMessage);

--
-- 构造函数
--
function RequestUndoMarker:ctor()
    RequestUndoMarker.super.ctor(self);
    --
    -- 土地索引
    --
    self.tiledIndex = 0;
end

--@Override
function RequestUndoMarker:_OnSerial() 
    self:WriteInt32(self.tiledIndex);
end

--@Override
function RequestUndoMarker:_OnDeserialize() 
    self.tiledIndex = self:ReadInt32();
end

return RequestUndoMarker;