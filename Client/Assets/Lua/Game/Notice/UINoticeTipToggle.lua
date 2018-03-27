--[[
	游戏公告左侧标题toggle
	producer : ww
	date     : 17-1-11
]]
local UIBase = require("Game/UI/UIBase");
local UIType = require("Game/UI/UIType");
local UIService = require("Game/UI/UIService");
local UINoticeTipToggle = class("UINoticeTipToggle", UIBase);

--[[
	构造函数
]]
function UINoticeTipToggle:ctor()
	-- body
	UINoticeTipToggle.super.ctor(self);

	self._Text_NoticeTip = nil;
end

function UINoticeTipToggle:DoDataExchange()
	-- body
	self._Text_NoticeTip = self:RegisterController(UnityEngine.UI.Text,"Label");
end

function UINoticeTipToggle:DoEventAdd()
	-- body

end

return UINoticeTipToggle;