-- region *.lua
-- Date16/10/14

local UIBase = require("Game/UI/UIBase")
local LeagueIntroUI = class("LeagueIntroUI", UIBase)
local UIService = require("Game/UI/UIService")
local UIType = require("Game/UI/UIType")

function LeagueIntroUI:ctor()

    LeagueIntroUI.super.ctor(self);
    self.LeagueConfirmBtn = nil;
    self.LeagueBackBtn = nil;
    self.inputFiled = nil;
end


-- 注册控件
function LeagueIntroUI:DoDataExchange()

    self.LeagueConfirmBtn = self:RegisterController(UnityEngine.UI.Button, "BackGroundImage/Confirm")
    self.LeagueBackBtn = self:RegisterController(UnityEngine.UI.Button, "BackGroundImage/Back")
    self.inputFiled = self:RegisterController(UnityEngine.UI.InputField, "BackGroundImage/NoticeInputField")

end

-- 注册点击事件
function LeagueIntroUI:DoEventAdd()

    self:AddListener(self.LeagueConfirmBtn, self.OnClickLeagueConfirmBtn)
    self:AddListener(self.LeagueBackBtn, self.OnClickLeagueBackBtn)
end

function LeagueIntroUI:OnShow()

    self.inputFiled.text = LeagueService:Instance():GetMyLeagueInfo().notice;

end


-- 点击按钮逻辑
function LeagueIntroUI:OnClickLeagueConfirmBtn()
    -- 发送消息
    LeagueService:Instance():RefreshLeagueNotice(self.inputFiled.text)
end

function LeagueIntroUI:OnClickLeagueBackBtn()
    UIService:Instance():HideUI(UIType.LeagueIntroUI)
end



return LeagueIntroUI
-- endregion