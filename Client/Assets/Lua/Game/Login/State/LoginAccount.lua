-- 请求部队信息
local BaseState = require("Game/State/BaseState")

local LoginAccount = class("LoginAccount", BaseState)

-- 构造函数
function LoginAccount:ctor(...)
    LoginAccount.super.ctor(self, ...);
    self.generateMd5 = GenerateMd5.New();
end

--获取md5加密sign值
function LoginAccount:_Md5Sign(account,passwordmd5)
    local md5Str = tostring(account) .. tostring(passwordmd5);
    return self.generateMd5:GenerateMd5Str(md5Str)
end

-- 进入操作
function LoginAccount:OnEnterState(account, password)
    local passwordmd5 = self.generateMd5:GenerateMd5Str(password)
    local msg = require("MessageCommon/Msg/C2A/EhooLogin/EhooLoginRequest").new()
    msg:SetMessageId(C2A_EhooLogin.EhooLoginRequest)
    msg.accountName = account
    msg.passworldmd5 = passwordmd5
    msg.appId = 1
    msg.ip = "dddd"
    msg.sign = self:_Md5Sign(account,passwordmd5)
    NetService:Instance():SendMessage(msg)
end

-- 离开操作
function LoginAccount:OnLeaveState(...)
end

return LoginAccount;
