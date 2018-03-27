-- 游戏管理的基类
local IGameManage = class("IGameManage")

-- 构造函数
function IGameManage:ctor()
    -- body
    --print("IGameManage:ctor");
end

-- 注册所有服务
-- 此函数是一个接口
function IGameManage:_RegisterAllService()
    --print("IGameManage:_RegisterCommonService");
end

return IGameManage;