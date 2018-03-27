--
-- 逻辑服务器 --> 客户端
-- 交易信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local TransactionInfoPrompt = class("TransactionInfoPrompt", GameMessage);

--
-- 构造函数
--
function TransactionInfoPrompt:ctor()
    TransactionInfoPrompt.super.ctor(self);
    --
    -- 交易成功数量
    --
    self.transactionInfoNum = 0;
end

--@Override
function TransactionInfoPrompt:_OnSerial() 
    self:WriteInt32(self.transactionInfoNum);
end

--@Override
function TransactionInfoPrompt:_OnDeserialize() 
    self.transactionInfoNum = self:ReadInt32();
end

return TransactionInfoPrompt;
