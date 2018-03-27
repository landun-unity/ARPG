--[[创建玩家界面]]

local UIBase= require("Game/UI/UIBase");
local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");

local LoginService = require("Game/Login/LoginService")

require("Game/Table/InitTable")
local DataBannedWord = require("Game/Table/model/DataBannedWord")

local UIFoundPlayer = class("UIFoundPlayer",UIBase)

--[[初始化控件名称]]
-- local PlayerNameField = nil
-- local RandomBtn = nil
-- local ConfirmBtn = nil
-- local _rowList = {}
-- local _rowId = 0;

--[[构造函数]]
function UIFoundPlayer:ctor( ... )
	UIFoundPlayer.super.ctor(self)
    self.playerName = nil
    math.randomseed(os.time())
    self.playerNameField =nil
    self.randomBtn = nil
    self.confirmBtn = nil
    self.backBtn = nil
    self._nameList = {}
    self._rowId = 0
    self._wholeName = ""
    self._stateName = nil
end

--[[注册按钮控件]]
function UIFoundPlayer:DoDataExchange()
	self.playerNameField = self:RegisterController(UnityEngine.UI.InputField,"Image/InputName")
	self.randomBtn = self:RegisterController(UnityEngine.UI.Button,"Image/random")
	self.confirmBtn = self:RegisterController(UnityEngine.UI.Button,"Image/certain")
    self.backBtn = self:RegisterController(UnityEngine.UI.Button,"Image/back")
    self._stateName = self:RegisterController(UnityEngine.UI.Text,"Image/Across/Image/Text")
end

--[[注册按钮点击事件]]
function UIFoundPlayer:DoEventAdd()
	self:AddListener(self.randomBtn,self.OnClickRandomBtn)	
	self:AddListener(self.confirmBtn,self.OnClickConfirmBtn)
    self:AddListener(self.backBtn,self.OnClickBackBtn)
end

-- 当界面显示的时候调用
function UIFoundPlayer:OnShow(param)
    local stateId = LoginService:Instance():GetBornStateId()
    print("选区的州id == " .. stateId)
    self._stateName.text = DataState[stateId].Name
end

-- 注册所有的通知
function UIFoundPlayer:RegisterAllNotice()
    self:RegisterNotice(L2C_Player.ResponseIsHavePlayerName, self.IsHavePlayerNameCallBack)
end

-- 是否包含角色名称回调
function UIFoundPlayer:IsHavePlayerNameCallBack()
    if LoginService:Instance():IsHavePlayerName() == false then
        LoginService:Instance():EnterState(LoginStateType.SendCreateRole, self.playerNameField.text, LoginService:Instance():GetBornStateId())
    else
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.AlreadyHaveName)
    end
end

--[[点击随机名按钮事件]]
function UIFoundPlayer:OnClickRandomBtn()
    self:RandomName()
    table.insert(self._nameList, self._wholeName);
	self.playerNameField.text = self._wholeName
end

--[[点击确定按钮]]
function UIFoundPlayer:OnClickConfirmBtn()
    local isRight = true;
    self._nameList = {}
    if self:_IsInputEmpty() == false then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.UserNameIsNone)
        return
    elseif self:IsContainSensitiveWords(self.playerNameField.text) == true then
        UIService:Instance():ShowUI(UIType.UICueMessageBox,7003);
        return;
    end
    GameResFactory.Instance():ChecKkName(self.playerNameField.text, function() end, function()
        isRight = false
    end )
    if isRight == false then
        UIService:Instance():ShowUI(UIType.UICueMessageBox,1207);
        return;
    end
    self:RequestIsHaveName()
end

function UIFoundPlayer:IsContainSensitiveWords(name)
    -- for i=1,3540 do
    --    if DataBannedWord[i].ShieldingWords == name then
    --         return true
    --    end
    -- end
    -- return false
    return CommonService:Instance():LimitText(name)
end

--[[点击返回按钮]]
 function UIFoundPlayer:OnClickBackBtn()
     UIService:Instance():HideUI(UIType.UIFoundPlayer)
     --UIService:Instance():ShowUI(UIType.UIBorn)
 end

-- 从表中随机获取名字
function UIFoundPlayer:RandomName()
    local firstNameRowId = self:_GetNameRowId()
    local nameRowId = self:_GetNameRowId()
    local firstName = DataRandomName[firstNameRowId].Surname
    local name = DataRandomName[nameRowId].Name
    self._wholeName = firstName .. name
    if self:_IsHaveRowName(wholeName) then
        self:RandomGetName()
    end
end

-- 获得名称行号
function UIFoundPlayer:_GetNameRowId()
    return math.random(table.getn(DataRandomName))
end

-- 是否已经包含该ID
function UIFoundPlayer:_IsHaveRowName()
    for i = 1, #self._nameList do
        if self._wholeName == self._nameList[i] then
            return true
        end
    end
    return false
end

-- 检测输入的用户名是否为空(空==false)
function UIFoundPlayer:_IsInputEmpty()
    local inputLen = string.len(self.playerNameField.text)
    if inputLen == 0 then
        return false
    end
    return true
end

-- 请求是否包含该名称
function UIFoundPlayer:RequestIsHaveName()
    local name = self.playerNameField.text
    local msg = require("MessageCommon/Msg/C2L/Player/RequestIsHavePlayerName").new()
    msg:SetMessageId(C2L_Player.RequestIsHavePlayerName)
    msg.playerName = name
    NetService:Instance():SendHttpMessage(msg)
end

return UIFoundPlayer