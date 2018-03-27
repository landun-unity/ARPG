--
-- 客户端 --> 逻辑服务器
-- 交易信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local TransactionInfo = class("TransactionInfo", GameMessage);

--
-- 构造函数
--
function TransactionInfo:ctor()
    TransactionInfo.super.ctor(self);
    --
    -- 消耗所需资源类型
    --
    self.consumeResourceType = 0;
    
    --
    -- 增加资源的类型
    --
    self.addResourceType = 0;
    
    --
    -- 消耗的资源量
    --
    self.consumeNum = 0;
    
    --
    -- 增加的资源量
    --
    self.addNum = 0;
end

--@Override
function TransactionInfo:_OnSerial() 
    self:WriteInt32(self.consumeResourceType);
    self:WriteInt32(self.addResourceType);
    self:WriteInt32(self.consumeNum);
    self:WriteInt32(self.addNum);
end

--@Override
function TransactionInfo:_OnDeserialize() 
    self.consumeResourceType = self:ReadInt32();
    self.addResourceType = self:ReadInt32();
    self.consumeNum = self:ReadInt32();
    self.addNum = self:ReadInt32();
end

return TransactionInfo;
