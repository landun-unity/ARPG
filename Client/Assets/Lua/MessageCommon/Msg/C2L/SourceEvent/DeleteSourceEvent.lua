﻿--
-- 客户端 --> 逻辑服务器
-- 删除资源地消息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local DeleteSourceEvent = class("DeleteSourceEvent", GameMessage);

--
-- 构造函数
--
function DeleteSourceEvent:ctor()
    DeleteSourceEvent.super.ctor(self);
    --
    -- 资源地ID
    --
    self.iD = 0;
end

--@Override
function DeleteSourceEvent:_OnSerial() 
    self:WriteInt32(self.iD);
end

--@Override
function DeleteSourceEvent:_OnDeserialize() 
    self.iD = self:ReadInt32();
end

return DeleteSourceEvent;
