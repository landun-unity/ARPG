
--弹出地图消息处理


-- 登录消息处理
local IOHandler = require("FrameWork/Game/IOHandler")
local PmapHandler = class("PmapHandler", IOHandler)

-- 构造函数
function PmapHandler:ctor( )
    -- body
    PmapHandler.super.ctor(self);
end

-- 注册所有消息
function PmapHandler:RegisterAllMessage()
    -- body
end

return PmapHandler;