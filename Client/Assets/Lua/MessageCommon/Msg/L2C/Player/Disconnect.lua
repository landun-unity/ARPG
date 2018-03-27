--
-- 逻辑服务器 --> 客户端
-- 断开连接
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local Disconnect = class("Disconnect", GameMessage);

--
-- 构造函数
--
function Disconnect:ctor()
    Disconnect.super.ctor(self);
    --
    -- 要断开的适配器Id
    --
    self.disConnectAdapterId = 0;
end

--@Override
function Disconnect:_OnSerial() 
    self:WriteInt64(self.disConnectAdapterId);
end

--@Override
function Disconnect:_OnDeserialize() 
    self.disConnectAdapterId = self:ReadInt64();
end

return Disconnect;
