--[[ 
    选区界面
-- ]]

local UIBase = require("Game/UI/UIBase")
local UISelectServer = class("UISelectServer", UIBase)


function UISelectServer:ctor()
    UISelectServer.super.ctor(self)
    
    -- 确定按钮
    self._confirmBtn = nil

    -- 退出按钮
    self._exitBtn = nil

    -- 选区列表
    self._regionList = {}

    -- 区名称
    self._regionText = ""
    
    -- 区的个数
    self._REGION_COUNT = 1
end

-- 注册按钮控件
function UISelectServer:DoDataExchange()
    self._confirmBtn = self:RegisterController(UnityEngine.UI.Button, "Confirm")
    self._exitBtn = self:RegisterController(UnityEngine.UI.Button, "Exit")
    for i=1,self._REGION_COUNT do
    	self._regionList[i] = self:RegisterController(UnityEngine.UI.Toggle, ("frame/region" .. i))
    end
end

-- 注册按钮点击事件
function UISelectServer:DoEventAdd()
	self:AddListener(self._confirmBtn, self.OnClickConfirmBtn)
    self:AddListener(self._exitBtn, self.OnClickExitBtn)
    for i=1,#self._regionList do
    	self:AddToggleOnValueChanged(self._regionList[i], self.OnClickToggleRegion)
    end
end

-- 注册所有的通知
function UISelectServer:RegisterAllNotice()
    
end


function UISelectServer:OnShow(param)
    
end

-- 点击确定按钮
function UISelectServer:OnClickConfirmBtn()
	local uiStartGame = UIService:Instance():GetUIClass(UIType.UIStartGame)
	if uiStartGame ~= nil then
		uiStartGame:SetRegionNameText(self._regionText)
	end
	self:HideSelf()
end

-- 点击退出按钮
function UISelectServer:OnClickExitBtn()
	self:HideSelf()
end

-- 隐藏自己
function UISelectServer:HideSelf()
	UIService:Instance():HideUI(UIType.UISelectServer)
end

-- 点击区列表
function UISelectServer:OnClickToggleRegion()
	for i=1,#self._regionList do
    	if self._regionList[i].isOn then
    		self._regionText = self._regionList[i].gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text
    	end
    end
end


return UISelectServer