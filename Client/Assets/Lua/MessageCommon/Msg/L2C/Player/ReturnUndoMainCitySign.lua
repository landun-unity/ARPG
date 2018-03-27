--
-- 逻辑服务器 --> 客户端
-- 主城标记回复
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ReturnUndoMainCitySign = class("ReturnUndoMainCitySign", GameMessage);

--
-- 构造函数
--
function ReturnUndoMainCitySign:ctor()
    ReturnUndoMainCitySign.super.ctor(self);
    --
    -- 格子索引
    --
    self.tiledIndex = 0;
end

--@Override
function ReturnUndoMainCitySign:_OnSerial() 
    self:WriteInt32(self.tiledIndex);
end

--@Override
function ReturnUndoMainCitySign:_OnDeserialize() 
    self.tiledIndex = self:ReadInt32();
end

return ReturnUndoMainCitySign;
