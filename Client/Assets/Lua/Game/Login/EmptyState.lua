-- 请求部队信息
local BaseState = require("Game/State/BaseState")

local EmptyState = class("EmptyState", BaseState)

-- 构造函数
function EmptyState:ctor( )
    EmptyState.super.ctor(self);
end

-- 进入操作
function BaseState:OnEnterState(...)
end

-- 离开操作
function BaseState:OnLeaveState(...)
end

return EmptyState;
