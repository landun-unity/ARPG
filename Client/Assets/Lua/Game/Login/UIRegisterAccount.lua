--[[ 注册账号界面 ]]

local UIBase = require("Game/UI/UIBase");
local UIRegisterAccount = class("UIRegisterAccount", UIBase)
local UIService = require("Game/UI/UIService");
local UIType = require("Game/UI/UIType");
local LoginService = require("Game/Login/LoginService")

local accountInputField = nil
local passwordInputField1 = nil
local passwordInputField2 = nil

local accountText = nil
local passwordText1 = nil
local passwordText2 = nil
local judgeText = nil
local AccountText = nil
function UIRegisterAccount:ctor()
    UIRegisterAccount.super.ctor(self)
    self.confirmBtn = nil


end

--[[ 注册按钮控件 ]]
function UIRegisterAccount:DoDataExchange()
    print("register confirmBtn..............")
    self.confirmBtn = self:RegisterController(UnityEngine.UI.Button, "RegisterBack/ConfirmBtn")
    self.backBtn = self:RegisterController(UnityEngine.UI.Button, "RegisterBack/BackBtn")
    accountInputField = self:RegisterController(UnityEngine.UI.InputField, "RegisterBack/account")
    passwordInputField1 = self:RegisterController(UnityEngine.UI.InputField, "RegisterBack/password1")
    passwordInputField2 = self:RegisterController(UnityEngine.UI.InputField, "RegisterBack/password2")
    judgeText = self:RegisterController(UnityEngine.UI.Text, "RegisterBack/judgeText")
    AccountText = self:RegisterController(UnityEngine.UI.Text, "RegisterBack/AccountText")
end

--[[ 注册按钮点击事件 ]]
function UIRegisterAccount:DoEventAdd()
    print("register confirmBtn  event.............")
    self:AddListener(self.confirmBtn, self.OnClickConfirmBtn)
    self:AddListener(self.backBtn, self.OnClickBackBtn)
end

--[[ 按钮点击触发事件 ]]
function UIRegisterAccount:OnClickConfirmBtn()

    local isRight = true;
    local baseClass = UIService:Instance():GetUIClass(UIType.UICueMessageBox);
    local isopen = UIService:Instance():GetOpenedUI(UIType.UICueMessageBox);
    if baseClass ~= nil and isopen == true then
        baseClass:Stop();
    end
    accountText = accountInputField.text
    passwordText1 = passwordInputField1.text
    passwordText2 = passwordInputField2.text
    AccountText.text = ""
    judgeText.text = ""
    if accountText == "" then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 8002);
        -- AccountText.text = "请输入账号"
        return
    end
    if passwordText1 == "" or passwordText2 == "" then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 8003);
        -- judgeText.text = "请输入密码"
        return
    end
    if passwordText1 ~= passwordText2 then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 8004);
        -- judgeText.text = "两次密码输入不一致"
        return
    end
    GameResFactory.Instance():ChecKkName(accountText, function() end, function()
        isRight = false
    end )
    GameResFactory.Instance():ChecKkName(passwordText2, function() end, function()
        isRight = false
    end )
    GameResFactory.Instance():ChecKkName(passwordText1, function() end, function()
        isRight = false
    end )
    if isRight == false then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 1207);
        return
    end
    -- UIService:Instance():HideUI(UIType.UIRegisterAccount)
    -- UIService:Instance():ShowUI(UIType.UILoginGame)
    LoginService:Instance():SendRegisterMessage(accountText, passwordText1)


end

--[[ 返回按钮点击触发事件 ]]
function UIRegisterAccount.OnClickBackBtn(self)
    UIService:Instance():HideUI(UIType.UIRegisterAccount);
    UIService:Instance():ShowUI(UIType.UIBegin)
end




return UIRegisterAccount