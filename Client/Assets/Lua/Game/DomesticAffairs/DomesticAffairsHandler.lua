-- 建筑物消息处理
local IOHandler = require("FrameWork/Game/IOHandler")

local DomesticAffairsHandler = class("DomesticAffairsHandler", IOHandler)

-- 构造函数
function DomesticAffairsHandler:ctor()
    -- body
    DomesticAffairsHandler.super.ctor(self);
end

-- 注册所有消息
function DomesticAffairsHandler:RegisterAllMessage()
    --获取端口	IP ID
    --self:RegisterMessage(L2C_Chat.ChatSever, self.HandleSyncChatSever, require("MessageCommon/Msg/C2Chat/Chat/JoinChannel"));
    self:RegisterMessage(L2C_DomesticAffairs.TransactionInfoPrompt, self.TransactionInfoPrompt, require("MessageCommon/Msg/L2C/DomesticAffairs/TransactionInfoPrompt"));
end
function DomesticAffairsHandler:TransactionInfoPrompt(msg)
	print("===================================="..msg.transactionInfoNum)
end
return DomesticAffairsHandler