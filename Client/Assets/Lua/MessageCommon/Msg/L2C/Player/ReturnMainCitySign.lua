--
-- 逻辑服务器 --> 客户端
-- 主城标记回复
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ReturnMainCitySign = class("ReturnMainCitySign", GameMessage);

--
-- 构造函数
--
function ReturnMainCitySign:ctor()
    ReturnMainCitySign.super.ctor(self);
    --
    -- 格子索引
    --
    self.tiledIndex = 0;
end

--@Override
function ReturnMainCitySign:_OnSerial() 
    self:WriteInt32(self.tiledIndex);
end

--@Override
function ReturnMainCitySign:_OnDeserialize() 
    self.tiledIndex = self:ReadInt32();
end

return ReturnMainCitySign;
