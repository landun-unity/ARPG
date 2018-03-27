-- 游戏管理的基类
local IGameService = require("FrameWork/Game/IGameService")

-- 定义类
local GameService = class("GameService", IGameService)

-- 构造函数
function GameService:ctor(part, handler)
    -- body
    --print("GameService:ctor")
    self._logic = part;
    self._handler = handler;
    if self._handler ~= nil then
        -- body
        self._handler:Init(self._logic);
    end

    self._service = self;
    GameService.super.ctor(self.super);
end

-- 初始化
function GameService:Init()
    -- body
    if self._logic ~= nil then
        -- body
        self._logic:Init();
    end

    if self._handler ~= nil then
        -- body
        self._handler:RegisterAllMessage();
    end
end

-- 心跳
function GameService:HeartBeat()
    -- body
    if self._logic ~= nil then
        -- body
        self._logic:HeartBeat();
    end
end

-- 停止
function GameService:Stop()
    -- body
    if self._logic ~= nil then
        -- body
        self._logic:Stop();
    end
end

-- 清空
function GameService:Clear()
    -- body
    if self._logic ~= nil then
        -- body
        self._logic:Clear();
    end
end

-- 清空清空数据
function GameService:ClearData()
    -- body
    if self._logic ~= nil then
        -- body
        self._logic:ClearData();
    end
end


return GameService;