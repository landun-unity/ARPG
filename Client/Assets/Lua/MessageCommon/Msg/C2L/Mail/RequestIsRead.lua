--
-- 客户端 --> 逻辑服务器
-- 已读
-- @author czx
--
local List = require("common/List");

local GameMessage = require("common/Net/GameMessage");
local RequestIsRead = class("RequestIsRead", GameMessage);

--
-- 构造函数
--
function RequestIsRead:ctor()
    RequestIsRead.super.ctor(self);
    --
    -- 邮件ID是否已读
    --
    self.mailId = List.new();
end

--@Override
function RequestIsRead:_OnSerial() 
    
    local mailIdCount = self.mailId:Count();
    self:WriteInt32(mailIdCount);
    for mailIdIndex = 1, mailIdCount, 1 do 
        self:WriteInt64(self.mailId:Get(mailIdIndex));
    end
end

--@Override
function RequestIsRead:_OnDeserialize() 
    
    local mailIdCount = self:ReadInt32();
    for i = 1, mailIdCount, 1 do 
        self.mailId:Push(self:ReadInt64());
    end
end

return RequestIsRead;
