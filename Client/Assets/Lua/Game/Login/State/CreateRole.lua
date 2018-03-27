-- 请求部队信息
local BaseState = require("Game/State/BaseState")

local CreateRole = class("CreateRole", BaseState)

-- 构造函数
function CreateRole:ctor(...)
    CreateRole.super.ctor(self, ...);
end

-- 进入操作
function CreateRole:OnEnterState(...)
	UIService:Instance():HideUI(UIType.UIRegisterAccount)
    UIService:Instance():ShowUI(UIType.UIBorn)
    UIService:Instance():HideUI(UIType.UILoginGame)
end

-- 离开操作
function CreateRole:OnLeaveState(...)
end

return CreateRole;
