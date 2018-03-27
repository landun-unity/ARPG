--
-- 逻辑服务器 --> 客户端
-- 领取成功
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ReturnIsReceive = class("ReturnIsReceive", GameMessage);

--
-- 构造函数
--
function ReturnIsReceive:ctor()
    ReturnIsReceive.super.ctor(self);
    --
    -- 邮件ID
    --
    self.mailId = 0;
    
    --
    -- 邮件类型
    --
    self.mailType = 0;
end

--@Override
function ReturnIsReceive:_OnSerial() 
    self:WriteInt64(self.mailId);
    self:WriteInt32(self.mailType);
end

--@Override
function ReturnIsReceive:_OnDeserialize() 
    self.mailId = self:ReadInt64();
    self.mailType = self:ReadInt32();
end

return ReturnIsReceive;
