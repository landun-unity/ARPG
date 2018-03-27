--
-- 逻辑服务器 --> 客户端
-- 已读
-- @author czx
--
local List = require("common/List");

local GameMessage = require("common/Net/GameMessage");
local ReturnIsRead = class("ReturnIsRead", GameMessage);

--
-- 构造函数
--
function ReturnIsRead:ctor()
    ReturnIsRead.super.ctor(self);
    --
    -- 邮件ID
    --
    self.mailId = List.new();
    
    --
    -- 邮件类型
    --
    self.mailType = 0;
end

--@Override
function ReturnIsRead:_OnSerial() 
    
    local mailIdCount = self.mailId:Count();
    self:WriteInt32(mailIdCount);
    for mailIdIndex = 1, mailIdCount, 1 do 
        self:WriteInt64(self.mailId:Get(mailIdIndex));
    end
    self:WriteInt32(self.mailType);
end

--@Override
function ReturnIsRead:_OnDeserialize() 
    
    local mailIdCount = self:ReadInt32();
    for i = 1, mailIdCount, 1 do 
        self.mailId:Push(self:ReadInt64());
    end
    self.mailType = self:ReadInt32();
end

return ReturnIsRead;
