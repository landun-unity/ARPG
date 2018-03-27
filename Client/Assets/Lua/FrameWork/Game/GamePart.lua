-- 游戏管理的基类
local IGamePart = require("FrameWork/Game/IGamePart")

-- 定义类
local GamePart = class("GamePart", IGamePart)

-- 构造函数
function GamePart:ctor()
    -- body
    GamePart.super.ctor(self);
    --print("GamePart:ctor");
end

-- 初始化
function GamePart:Init()
    -- body
    self:_OnInit();
end

-- 心跳 
function GamePart:HeartBeat()
    -- body
    self:_OnHeartBeat();
end

-- 停止 
function GamePart:Stop()
    -- body
    self:_OnStop();
end

-- 清空
function GamePart:Clear()
    
end

return GamePart;