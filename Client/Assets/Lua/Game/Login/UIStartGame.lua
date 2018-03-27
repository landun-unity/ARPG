--[[ 
    开始游戏界面
-- ]]

local UIBase = require("Game/UI/UIBase")
local LoginStateType = require("Game/Login/State/LoginStateType")
local UIStartGame = class("UIStartGame", UIBase)


function UIStartGame:ctor()
    UIStartGame.super.ctor(self)

    -- 选区按钮
    self._selectRegionBtn = nil

    -- 开始游戏按钮
    self._startGame = nil

    -- 区名称
    self._regionName = ""
end

-- 注册按钮控件
function UIStartGame:DoDataExchange()
    self._selectRegionBtn = self:RegisterController(UnityEngine.UI.Button, "selectRegion")
    self._startGame = self:RegisterController(UnityEngine.UI.Button, "startGame")
end

-- 注册按钮点击事件
function UIStartGame:DoEventAdd()
    self:AddListener(self._selectRegionBtn, self.OnClickSelectRegionBtn)
    self:AddListener(self._startGame, self.OnClickStartGameBtn)
end

-- 注册所有的通知
function UIStartGame:RegisterAllNotice()
    
end


function UIStartGame:OnShow(param)
    self._regionName = "1区"
    -- print("服务器区的名称 == " .. self._regionName)
    self._selectRegionBtn.transform:FindChild("regionText").gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text = "1区"
end

-- 点击选区按钮
function UIStartGame:OnClickSelectRegionBtn()
    UIService:Instance():ShowUI(UIType.UISelectServer)
end

-- 点击开始游戏按钮
function UIStartGame:OnClickStartGameBtn()
    -- print("服务器区ID == " .. self:GetRegionId())
    if self:GetRegionId() == 0 then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.NoSelectServerRegion)
        return
    end
    self:SaveRegionId()
    local certificate = PlayerService:Instance():GetCertificate()
    LoginService:Instance():EnterState(LoginStateType.LoginLogic, certificate)
    UIService:Instance():HideUI(UIType.UIStartGame)
end

-- 设置区名称
function UIStartGame:SetRegionNameText(regionName)
    self._regionName = regionName
    self._selectRegionBtn.transform:FindChild("regionText").gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text = regionName
end

-- 保存区Id
function UIStartGame:SaveRegionId()
    PlayerService:Instance():SetRegionId(self:GetRegionId())
end


-- 获取区Id
function UIStartGame:GetRegionId()
    if self._regionName == "1区" then
        return 1
    elseif self._regionName == "2区" then
        return 2
    elseif self._regionName == "3区" then
        return 3
    elseif self._regionName == "4区" then
        return 4
    end
    return 0
end



return UIStartGame