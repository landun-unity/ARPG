--[[登陆平台管理]]

local GameManage = require("FrameWork/Game/GameManage")
local PlatformEnum = require("Game/Platform/PlatformEnum")
local EhooLoginPlatform = require("Game/Platform/EhooLoginPlatform")
local PlatformManager = class("PlatformManager",GameManage)

--[[构造函数]]
function PlatformManager:ctor()
	PlatformManager.super.ctor(self)
	--print("constructor running...")
	self.allLoginPlatfrom = {}
	self.currentPlatform = EhooLoginPlatform
	self:Init()
end

--[[初始化平台列表]]
function PlatformManager:Init()
	PlatformManager.super.ctor(self)
	if PlatformEnum == nil then
		print("!!!PlatformEnum is nil......")
	else
		self.allLoginPlatfrom[PlatformEnum.EhooPlatform] = EhooLoginPlatform
	end
end

--[[切换当前平台]]
function PlatformManager:ChangePlatform(platformEnum)
	if platformEnum == nil then
		print("!!!platformEnum is nil......")
	else
		self.currentPlatform = self.allLoginPlatfrom[platformEnum]
	end
end

--[[获取当前平台]]
function PlatformManager:GetPlatfrom()
	if self.currentPlatform == nil then
		print("!!!currentPlatform is nil......")
	else
		return self.currentPlatform
	end
end

return PlatformManager


