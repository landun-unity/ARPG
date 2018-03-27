-- 游戏服务的基类
local IGameService = class("IGameService")

-- 构造函数
function IGameService:ctor()
    -- body
    --print("IGameService:ctor");
end

-- 注册所有服务
-- 此函数是一个接口
function IGameService:Init()
end

-- 心跳
function IGameService:HeartBeat()
end

-- 心跳
function IGameService:Stop()
end

return IGameService;