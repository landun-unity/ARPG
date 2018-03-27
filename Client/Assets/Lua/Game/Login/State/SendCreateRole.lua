-- 发送创建消息
local BaseState = require("Game/State/BaseState")

local SendCreateRole = class("SendCreateRole", BaseState)

-- 构造函数
function SendCreateRole:ctor(...)
    SendCreateRole.super.ctor(self, ...);
end

-- 进入操作
function SendCreateRole:OnEnterState(roleName, state)
    local msg = require("MessageCommon/Msg/C2L/Account/CreateRole").new()
    msg:SetMessageId(C2L_Account.CreateRole)
    msg.accountId = PlayerService:Instance():GetAccountId()
    msg.regionId = PlayerService:Instance():GetRegionId()
    msg.roleName = roleName
    msg.state = state
    NetService:Instance():SendHttpMessage(msg)
end

-- 离开操作
function SendCreateRole:OnLeaveState(...)
end

return SendCreateRole;
