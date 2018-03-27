local GameService = require("FrameWork/Game/GameService")

local LoginHandler = require("Game/Login/LoginHandler")
local LoginManage = require("Game/Login/LoginManage");
LoginService = class("LoginService", GameService)

function LoginService:ctor()
    -- body
    -- print("LoginService:ctor");
    LoginService._instance = self;
    LoginService.super.ctor(self, LoginManage.new(), LoginHandler.new());
end

-- 单例
function LoginService:Instance()
    return LoginService._instance;
end


-- 注册所有状态
function LoginService:RegisterAllState()
    self._logic:RegisterAllState()
end

-- 清空数据
function LoginService:Clear()
    self._logic:ctor()
end

-- 登陆逻辑
function LoginService:_DoLogin(account, password)
    self._logic:_DoLogin(account, password)
end

-- 发送注册消息
function LoginService:SendRegisterMessage(account, password)
    self._logic:SendRegisterMessage(account, password)
end

-- 设置玩家的出生州
function LoginService:SetBornStateId(stateId)
    self._logic:SetBornStateId(stateId);
end

-- 获取玩家的出生州
function LoginService:GetBornStateId()
    return self._logic:GetBornStateId();
end

-- 完成一项登录
function LoginService:CompleteLoginTask()
    self._logic:CompleteLoginTask();
end

-- 进入状态
function LoginService:EnterState(loginState, ...)
    self._logic:EnterState(loginState, ...)
end

-- 检查登录状态 
function LoginService:IsLoginState(loginState)
    return self._logic:IsLoginState(loginState);
end
function LoginService:GoToEnterState()
    self._logic:GoToEnterState();
end
function LoginService:GoToEnterStateConnect()
    -- body
    self._logic:GoToEnterStateConnect()
end
-- 打开第二场景时GameStart调用:
function LoginService:GameStart()
    self._logic:GameStart()
end

function LoginService:GetExit()
    return self._logic:GetExitGame()
end

function LoginService:SetExit(args)
    self._logic:SetExitGame(args)
end

function LoginService:ExitGame()
    self._logic:ExitGame()
end

-- 是否包含角色名称
function LoginService:IsHavePlayerName()
    return self._logic:IsHavePlayerName()
end
return LoginService;