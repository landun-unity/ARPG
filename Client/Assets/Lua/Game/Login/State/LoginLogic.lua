-- 请求部队信息
local BaseState = require("Game/State/BaseState")

local LoginLogic = class("LoginLogic", BaseState)

-- 构造函数
function LoginLogic:ctor(...)
    LoginLogic.super.ctor(self, ...);
end

-- 进入操作
function LoginLogic:OnEnterState(certificate)
    local msg = require("MessageCommon/Msg/C2L/Account/LoginVerfiy").new()
    msg:SetMessageId(C2L_Account.LoginVerfiy)
    msg.verfiyCode = certificate
    msg.mobileType = "123"
    msg.accountId = PlayerService:Instance():GetAccountId()
    msg.regionId = PlayerService:Instance():GetRegionId()
    NetService:Instance():SendHttpMessage(msg)
end

-- 离开操作
function LoginLogic:OnLeaveState(...)
end

return LoginLogic;
