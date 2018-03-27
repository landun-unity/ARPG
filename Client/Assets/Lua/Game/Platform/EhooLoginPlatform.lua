--[[Ehoo登陆平台]]

local BasePlatform = require("Game/Platform/BasePlatform")
local UIService = require("Game/UI/UIService")
local UIType = require("Game/UI/UIType")
local EhooLoginPlatfrom = class("EhooLoginPlatfrom",BasePlatform)

--[[初始化平台]]
function EhooLoginPlatfrom:InitPlatform()

end

--[[登陆]]

function EhooLoginPlatfrom:Login(account,password)
--	print("这里是ehoo平台登陆逻辑！")

	local account = account
	local password = password
    --print("账号"..account)
    --print("密码"..password)
	if LoginService == nil then
		print("!!!LoginService is nil......")
	else
		--LoginService:Instance():_DoLogin(account,password)
		EhooLoginPlatfrom:SendMessage(account,password)
	end
end

--[[登出]]
function EhooLoginPlatfrom:Logout()

end

--[[发消息]]
function EhooLoginPlatfrom:SendMessage(account,password)
	-- print(account.."-----------"..password)
	-- LoginService:Instance():_SendMessage(account,password)
	LoginService:Instance():EnterState(LoginStateType.LoginAccount, account,password);
end

--[[账号管理]]
function EhooLoginPlatfrom:AccountManage()
	UIService:Instance():ShowUI(UIType.UIRegisterAccount)
end


return EhooLoginPlatfrom