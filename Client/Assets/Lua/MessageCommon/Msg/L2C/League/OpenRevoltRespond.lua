--
-- 逻辑服务器 --> 客户端
-- 同盟等级
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local OpenRevoltRespond = class("OpenRevoltRespond", GameMessage);

--
-- 构造函数
--
function OpenRevoltRespond:ctor()
    OpenRevoltRespond.super.ctor(self);
    --
    -- 当前进度值
    --
    self.curRevolt = 0;
    
    --
    -- 最大进度值
    --
    self.maxRevolt = 0;
end

--@Override
function OpenRevoltRespond:_OnSerial() 
    self:WriteInt32(self.curRevolt);
    self:WriteInt32(self.maxRevolt);
end

--@Override
function OpenRevoltRespond:_OnDeserialize() 
    self.curRevolt = self:ReadInt32();
    self.maxRevolt = self:ReadInt32();
end

return OpenRevoltRespond;
