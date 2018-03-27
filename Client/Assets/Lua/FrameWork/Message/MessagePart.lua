-- 登录管理
local GamePart = require("FrameWork/Game/GamePart")

local MessagePart = class("MessagePart", GamePart)

-- 构造函数
function MessagePart:ctor( )
    -- body
    self._allMessageHandlerMap = {};
    self._allMessageMap = {};
    self._allMessageObjectMap = {};
    self._allNoticeMap = {};
end

-- 初始化
function MessagePart:_OnInit()
end

-- 心跳
function MessagePart:_OnHeartBeat()
end

-- 停止
function MessagePart:_OnStop()
end

function MessagePart:RegisterMessage(msgId, msgFun, msg, object)
    self._allMessageHandlerMap[msgId] = msgFun;
    self._allMessageMap[msgId] = msg;
    self._allMessageObjectMap[msgId] = object;
end

-- 创建消息
function MessagePart:CreateMessage(msgId)
    local msg = self._allMessageMap[msgId];
    if msg == nil then
        return nil;
    end
    return msg.new();
end

-- 查找消息回调
function MessagePart:FindMessageFun( msgId )
    -- body
    return self._allMessageHandlerMap[msgId];
end

-- 查找消息处理的对象
function MessagePart:FindMessageObject( msgId )
    return self._allMessageObjectMap[msgId];
end

-- 注册事件
function MessagePart:RegisterNotice(msgId, obj, fun)
    if msgId == nil or obj == nil or fun == nil then
        return;
    end

    local msgIdCallBack = self._allNoticeMap[msgId];
    if msgIdCallBack == nil then
        msgIdCallBack = {};
        self._allNoticeMap[msgId] = msgIdCallBack;
    end
    -- print("添加排发====="..msgId);
    msgIdCallBack[obj] = fun;
end

-- 派发通知
function MessagePart:DispatchNotice(msgId)
    if msgId == nil then
        return;
    end

    local msgIdCallBack = self._allNoticeMap[msgId];
    if msgIdCallBack == nil then
        return nil;
    end

    -- 循环所有的回调
    for k,v in pairs(msgIdCallBack) do
        v(k);
    end
end

-- 删除派发
function MessagePart:RemoveNotice(msgId, obj)
    
    if msgId == nil then
        return;
    end
    print("删除排发====="..msgId);
    local msgIdCallBack = self._allNoticeMap[msgId];

    if msgIdCallBack == nil then
        return nil;
    end

    msgIdCallBack[obj] = nil;
end

--删除所有派发
function MessagePart:RemoveAllNotice()
    self._allNoticeMap ={}
end

return MessagePart;