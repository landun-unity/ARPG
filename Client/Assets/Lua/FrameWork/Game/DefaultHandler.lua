-- 游戏管理的基类
local IIOHandler = require("FrameWork/Game/IIOHandler")

-- 定义类
local DefaultHandler = class("DefaultHandler", IIOHandler)

-- 构造函数
function DefaultHandler:ctor()
    -- body
    --print("DefaultHandler:ctor");
    self._logicManage = nil;
    DefaultHandler.super.ctor(self);
end

-- 初始化
function DefaultHandler:Init( part )
    -- body
    --print("DefaultHandler:Init");
    self._logicManage = part;
end

return DefaultHandler;