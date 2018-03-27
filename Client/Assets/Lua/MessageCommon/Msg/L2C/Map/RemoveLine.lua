--
-- 逻辑服务器 --> 客户端
-- 删除线
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RemoveLine = class("RemoveLine", GameMessage);

--
-- 构造函数
--
function RemoveLine:ctor()
    RemoveLine.super.ctor(self);
    --
    -- 线的唯一Id
    --
    self.lineId = 0;
end

--@Override
function RemoveLine:_OnSerial() 
    self:WriteInt64(self.lineId);
end

--@Override
function RemoveLine:_OnDeserialize() 
    self.lineId = self:ReadInt64();
end

return RemoveLine;
