-- 游戏管理的基类
local IIOHandler = class("IIOHandler")

-- 构造函数
function IIOHandler:ctor()
    -- body
    --print("IIOHandler:ctor");
end

-- 初始化
function IIOHandler:Init(part)
end

-- 心跳
function IIOHandler:RegisterAllMessage()
end

return IIOHandler;