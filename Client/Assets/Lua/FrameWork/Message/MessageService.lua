local GameService = require("FrameWork/Game/GameService")

local DefaultHandler = require("FrameWork/Game/DefaultHandler")
local MessagePart = require("FrameWork/Message/MessagePart");
MessageService = class("MessageService", GameService)

function MessageService:ctor( )
    -- body
    MessageService._instance = self;
    --print(DefaultHandler)
    MessageService.super.ctor(self, MessagePart.new(), DefaultHandler.new());
end

-- 单例
function MessageService:Instance()
    return MessageService._instance;
end

function MessageService:RegisterMessage(msgId, msgFun, msg, object)
    self._logic:RegisterMessage(msgId, msgFun, msg, object);
end

function MessageService:CreateMessage(msgId)
    return self._logic:CreateMessage(msgId);
end

function MessageService:ReceiveMessage(msg)
    if msg == nil then
        return;
    end
    local obj = self._logic:FindMessageObject(msg:GetMessageId());
    local fun = self._logic:FindMessageFun(msg:GetMessageId());
    if obj == nil or fun == nil then
        return;
    end
    fun(obj, msg);
    self:DispatchNotice(msg:GetMessageId());
end

-- 注册通知
function MessageService:RegisterNotice(msgId, obj, fun)
    self._logic:RegisterNotice(msgId, obj, fun)
end

-- 派发通知
function MessageService:DispatchNotice(msgId)
    self._logic:DispatchNotice(msgId);

end

-- 删除派发
function MessageService:RemoveNotice(msgId, obj)
    self._logic:RemoveNotice(msgId, obj)
end

-- 删除所有派发
function MessageService:RemoveAllNotice(msgId, obj)
    self._logic:RemoveAllNotice()
end

return MessageService;