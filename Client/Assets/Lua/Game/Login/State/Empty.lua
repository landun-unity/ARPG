-- 请求部队信息
local BaseState = require("Game/State/BaseState")

local Empty = class("Empty", BaseState)

-- 构造函数
function Empty:ctor(...)
    Empty.super.ctor(self, ...);
end

-- 进入操作
function Empty:OnEnterState(...)
end

-- 离开操作
function Empty:OnLeaveState(...)
end

-- 进入游戏流程的一些状态是不能进去的
function Empty:CanEnterState(stateType)
    if stateType == LoginStateType.RegisterAccount   then
        return true;
    end
    return false;
end

return Empty;
