-- 游戏管理的基类
local IGamePart = class("IGamePart")

-- 构造函数
function IGamePart:ctor()
    -- body
    --print("IGamePart:ctor");
end

-- 初始化
function IGamePart:_OnInit()
end

-- 心跳
function IGamePart:_OnHeartBeat()
end

-- 停止的时候处理
function IGamePart:_OnStop( ... )
    -- body
end

return IGamePart;