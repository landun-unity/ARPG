--[[ 登陆游戏界面逻辑 ]]

local UIBase = require("Game/UI/UIBase");
local PlatformManager = require("Game/Platform/PlatformManager")
local PlatformEnum = require("Game/Platform/PlatformEnum")
local UIService = require("Game/UI/UIService");
local UIType = require("Game/UI/UIType");

local UILoginGame = class("UILoginGame", UIBase)

local AccountInputField = nil
local PwdInputField = nil

function UILoginGame:ctor()
    -- print("UILoginGame...")
    UILoginGame.super.ctor(self)
    self.loginBtn = nil
    self.accountBtn = nil
    self.backBtn = nil
    self._Button_Notice = nil;
    if PlatformManager ~= nil then
        PlatformManager:ctor()
    end
end

--[[ 注册按钮控件 ]]
function UILoginGame:DoDataExchange()
    self.loginBtn = self:RegisterController(UnityEngine.UI.Button, "StartGame")
    self.backBtn = self:RegisterController(UnityEngine.UI.Button, "BackBtn")
    self.accountBtn = self:RegisterController(UnityEngine.UI.Button, "AccountManager")
    self._Button_Notice = self:RegisterController(UnityEngine.UI.Button, "NoticeBtn");
    AccountInputField = self:RegisterController(UnityEngine.UI.InputField, "AccountInputField")
    PwdInputField = self:RegisterController(UnityEngine.UI.InputField, "PwdInputField")
end

--[[ 注册按钮点击事件 ]]
function UILoginGame:DoEventAdd()
    self:AddListener(self.loginBtn, self.OnClickLoginBtn)
    self:AddListener(self.accountBtn, self.OnClickAccountManageBtn)
    self:AddListener(self.backBtn, self.OnClickBackBtn)
    self:AddListener(self._Button_Notice, self.OnClickNoticeBtn)
end

-- 注册所有的通知
function UILoginGame:RegisterAllNotice()
    self:RegisterNotice(A2C_EhooLogin.EhooLoginRespond, self.NoticeCallBack)
end

function UILoginGame:NoticeCallBack()

end

function UILoginGame:OnShow(param)
    self.loginBtn.interactable = true;
end

--[[ 按钮点击触发事件 ]]
function UILoginGame:OnClickLoginBtn()
    local isRight = true;
    local baseClass = UIService:Instance():GetUIClass(UIType.UICueMessageBox);
    local isopen = UIService:Instance():GetOpenedUI(UIType.UICueMessageBox);
    if baseClass ~= nil and isopen == true then
        baseClass:Stop();
    end
    if PlatformManager ~= nil then
        local account = "";
        local password = "";
        if AccountInputField ~= nil then
            account = AccountInputField.text
            password = PwdInputField.text
        end
        local newAccount = string.gsub(account, "^%s*(.-)%s*$", "%1");
        local newPassword = string.gsub(password, "^%s*(.-)%s*$", "%1");
        if newAccount == "" and newPassword == "" then
            CommonService:Instance():WaitClickButton(self.loginBtn);
            UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.AccountPasswordAllNone);
            return;
        end
        GameResFactory.Instance():ChecKkName(account, function() end, function()
            isRight = false
        end )
        GameResFactory.Instance():ChecKkName(password, function() end, function()
            isRight = false
        end )
        if isRight == false then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, 1207);
            return;
        end
        PlatformManager:GetPlatfrom():Login(account, password)
    end
end

function UILoginGame:OnClickAccountManageBtn()
    PlatformManager:GetPlatfrom():AccountManage()
    UIService:Instance():HideUI(UIType.UILoginGame)
end

function UILoginGame:OnClickBackBtn()
    -- print("UILoginGame:OnClickBackBtn..........")
    UIService:Instance():HideUI(UIType.UILoginGame)
    UIService:Instance():ShowUI(UIType.UIBegin)
end

function UILoginGame:OnClickNoticeBtn()
    -- body
    UIService:Instance():ShowUI(UIType.UINotice, 0);
end

return UILoginGame