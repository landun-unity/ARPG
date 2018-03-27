--[[游戏主界面]]

local UIBase= require("Game/UI/UIBase");
local GMCommand=class("GMCommand",UIBase);

local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");
local UIConfigTable=require("Game/Table/model/DataUIConfig");

local GMCommandItem = require("Game/GMCommand/GMCommandItem");

local GMInfo = require("MessageCommon/Msg/C2L/GM/GMInfo");

function GMCommand:ctor()
    GMCommand.super.ctor(self)
    self.GMCommandItemPrefab = UIConfigTable[UIType.GMCommandItem].ResourcePath;
end

--注册控件
function GMCommand:DoDataExchange()
    self.CloseBtn = self:RegisterController(UnityEngine.UI.Button,"Panel/CloseBtn")
    self.SendGMBtn = self:RegisterController(UnityEngine.UI.Button,"Panel/SendGM")
    self.UIInput = self:RegisterController(UnityEngine.UI.InputField,"Panel/InputField")
    self.Parent = self:RegisterController(UnityEngine.Transform,"Panel/ScrolView/Viewport/Content")
    self.Scrollbar = self:RegisterController(UnityEngine.UI.Scrollbar,"Panel/ScrolView/Viewport/Scrollbar Vertical")
end

--注册控件点击事件
function GMCommand:DoEventAdd()
    self:AddListener(self.CloseBtn,self.OnCloseBtn)
    self:AddListener(self.SendGMBtn,self.OnSendGMBtn)
end

--点击关闭按钮逻辑
function GMCommand:OnCloseBtn()
    UIService:Instance():HideUI(UIType.GMCommand)
end

--点击发送按钮
function GMCommand:OnSendGMBtn()
    if(self.UIInput.text ~= "") then
        self:SendGMCommond()
        self:AddItem()
    end
end

--发送到服务器输入的内容
function GMCommand:SendGMCommond()
    --这里写发送消息
    local msg = GMInfo.new();
    msg:SetMessageId(C2L_GM.GMInfo);
    msg.gMCommand = self.UIInput.text;
    NetService:Instance():SendMessage(msg);
end

function GMCommand:AddItem()
    local mGMCommandItem = GMCommandItem.new();
    GameResFactory.Instance():GetUIPrefab(self.GMCommandItemPrefab,self.Parent,mGMCommandItem,function (go)
        mGMCommandItem:Init();
        mGMCommandItem:SetText(self.UIInput.text);
    end);
    self.UIInput.text = ""
    self.Scrollbar.value = 0;
end

return GMCommand
