-- 登录消息处理
local IOHandler = require("FrameWork/Game/IOHandler")
local UIHandler = class("UIHandler", IOHandler)

-- 构造函数
function UIHandler:ctor( )
    -- body
end

-- 注册所有消息
function UIHandler:RegisterAllMessage()
    -- body
    --print("UIHandler:RegisterAllMessage")
    --self:RegisterMessage(1, self.Message2, require("kkkkMesssage"));
end



return UIHandler;