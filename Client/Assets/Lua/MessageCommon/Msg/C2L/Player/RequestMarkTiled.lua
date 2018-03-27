--
-- 客户端 --> 逻辑服务器
-- 请求标记土地
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestMarkTiled = class("RequestMarkTiled", GameMessage);

--
-- 构造函数
--
function RequestMarkTiled:ctor()
    RequestMarkTiled.super.ctor(self);
    --
    -- 标记名字
    --
    self.name = "";
    
    --
    -- 土地索引
    --
    self.tiledIndex = 0;
end

--@Override
function RequestMarkTiled:_OnSerial() 
    self:WriteString(self.name);
    self:WriteInt32(self.tiledIndex);
end

--@Override
function RequestMarkTiled:_OnDeserialize() 
    self.name = self:ReadString();
    self.tiledIndex = self:ReadInt32();
end

return RequestMarkTiled;
