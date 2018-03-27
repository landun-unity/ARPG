-- 游戏管理的基类
local IIOHandler = require("FrameWork/Game/IIOHandler")
local MessageService = require("FrameWork/Message/MessageService")

-- 定义类
local IOHandler = class("IOHandler", IIOHandler)

-- 构造函数
function IOHandler:ctor()
    -- body
    IOHandler.super.ctor(self);
    --print("IOHandler:ctor");
    self._logicManage = nil;
end

-- 初始化
function IOHandler:Init( part )
    -- body
    --print("IOHandler:Init");
    self._logicManage = part;
end

function IOHandler:RegisterMessage(msgId, msgFun, msg)
    MessageService:Instance():RegisterMessage(msgId, msgFun, msg, self);
end

return IOHandler;