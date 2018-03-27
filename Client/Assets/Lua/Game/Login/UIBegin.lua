--[[
    Name:开始界面
--]]

    local UIBase= require("Game/UI/UIBase")

    local UIBegin=class("UIBegin",UIBase)
    local UIService=require("Game/UI/UIService")
    local UIType=require("Game/UI/UIType")

    local testText = nil

--开始游戏按钮
local startBtn = nil

--构造函数
function UIBegin:ctor()
	UIBegin.super.ctor(self)
end

--注册控件
function UIBegin:DoDataExchange()
  startBtn=self:RegisterController(UnityEngine.UI.Button,"Button")
  --testText = self:RegisterController(UnityEngine.UI.Text,"Text")
end

--注册控件点击事件
function UIBegin:DoEventAdd()
  self:AddListener(startBtn,self.OnClickStartBtn)
end


--点击开始游戏按钮逻辑
function UIBegin.OnClickStartBtn(self)
  UIBegin:TestGetMd5()
  UIService:Instance():ShowUI(UIType.UILoginGame)
  UIService:Instance():HideUI(UIType.UIBegin)
end

--lua调用生成MD5
function UIBegin:TestGetMd5()
  -- body
  local generateMd5 = GenerateMd5.New()
  local md5Str = generateMd5:GenerateMd5Str("hello")
  --print(md5Str)
end




return UIBegin
