--[[��Ϸ��ʾ����]]

local UIBase= require("Game/UI/UIBase");
local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");
require("Game/Recruit/RecruitService");

local CommonTipSmall=class("CommonTipSmall",UIBase);

function CommonTipSmall:ctor()
    CommonTipSmall.super.ctor(self)
    self.TroopsRepartoImage = nil;
end

--ע���ؼ�
function CommonTipSmall:DoDataExchange()
    self.Title = self:RegisterController(UnityEngine.UI.Text,"Title")
    self.Tips = self:RegisterController(UnityEngine.UI.Text,"Tips")
    self.OkBtn = self:RegisterController(UnityEngine.UI.Button,"OkBtn")
    self.BackBtn = self:RegisterController(UnityEngine.UI.Button,"BackBtn")
    self.TroopsRepartoImage = self:RegisterController(UnityEngine.UI.Text,"Image/TroopsRepartoImage/Text")
end

--ע���ؼ������¼�
function CommonTipSmall:DoEventAdd()
  self:AddListener(self.OkBtn,self.OnClickCloseBtn)
  self:AddListener(self.BackBtn,self.OnClickCloseBtn)
end

function CommonTipSmall:OnClickCloseBtn()
  UIService:Instance():HideUI(UIType.UICommonTipSmall)
end

function CommonTipSmall:OnShow(parem)
    self.Title.text = parem[1];
    self.Tips.text = parem[2];
    self.TroopsRepartoImage.text = parem[3]
end

return CommonTipSmall;