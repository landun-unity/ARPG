--
-- 客户端 --> 逻辑服务器
-- 主城标记信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestMainCitySign = class("RequestMainCitySign", GameMessage);

--
-- 构造函数
--
function RequestMainCitySign:ctor()
    RequestMainCitySign.super.ctor(self);
    --
    -- 索引
    --
    self.tiledIndex = 0;
end

--@Override
function RequestMainCitySign:_OnSerial() 
    self:WriteInt32(self.tiledIndex);
end

--@Override
function RequestMainCitySign:_OnDeserialize() 
    self.tiledIndex = self:ReadInt32();
end

return RequestMainCitySign;
