-- 请求部队信息
local BaseState = require("Game/State/BaseState")

local RegisterAccount = class("RegisterAccount", BaseState)

-- 构造函数
function RegisterAccount:ctor(...)
    RegisterAccount.super.ctor(self, ...);
    self.generateMd5 = GenerateMd5.New();
end

-- 进入操作
function RegisterAccount:OnEnterState(account, password)
    local passwordmd5 = self.generateMd5:GenerateMd5Str(password)

    local msg = require("MessageCommon/Msg/C2A/EhooLogin/EhooRegisterRequest").new()
    print(C2A_EhooLogin.EhooRegisterRequest)
    msg:SetMessageId(C2A_EhooLogin.EhooRegisterRequest)
    msg.accountName = account
    msg.password = passwordmd5
    msg.appId = 1
    NetService:Instance():SendMessage(msg)
end

-- 离开操作
function RegisterAccount:OnLeaveState(...)
end

return RegisterAccount;
