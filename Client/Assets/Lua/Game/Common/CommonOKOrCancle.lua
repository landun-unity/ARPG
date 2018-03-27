
local UIBase= require("Game/UI/UIBase");
local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");
require("Game/Recruit/RecruitService");

local CommonOKOrCancle=class("CommonOKOrCancle",UIBase);

function CommonOKOrCancle:ctor()
    CommonOKOrCancle.super.ctor(self)
end

function CommonOKOrCancle:DoDataExchange()
    --self.Title = self:RegisterController(UnityEngine.UI.Text,"Title")
    self.Tips = self:RegisterController(UnityEngine.UI.Text,"TipsBg/Tips")
    self.MoreObj = self:RegisterController(UnityEngine.Transform,"TipsBg/More")
    self.MoreTips = self:RegisterController(UnityEngine.UI.Text,"TipsBg/More/MoreTips")
    self.Title = self:RegisterController(UnityEngine.UI.Text,"Title")
    self.OkLabel = self:RegisterController(UnityEngine.UI.Text,"BtnParent/OkBtn/Ok")
    self.CancleLabel = self:RegisterController(UnityEngine.UI.Text,"BtnParent/CancleBtn/Cancle")
    self.OkBtn = self:RegisterController(UnityEngine.UI.Button,"BtnParent/OkBtn")
    self.CancleBtn = self:RegisterController(UnityEngine.UI.Button,"BtnParent/CancleBtn")
    self.BackBtn = self:RegisterController(UnityEngine.UI.Button,"BackBtn")
end

function CommonOKOrCancle:DoEventAdd()
  self:AddListener(self.OkBtn,self.OnClickOKBtn)
  self:AddListener(self.CancleBtn,self.OnClickCancleBtn)
   self:AddListener(self.BackBtn,self.OnClickCloseBtn)
end

function CommonOKOrCancle:OnShow(parem)   
    self.go = parem[1];
    self.fun1 = parem[2];
    self.fun2 = parem[3];
    if self.fun1 ~= nil then
        self.OkBtn.gameObject:SetActive(true);
    else
        self.OkBtn.gameObject:SetActive(false);
    end
    if self.fun2 ~= nil then
    end
    if(parem[4]) then
        self.Title.text = parem[4];
    else
        self.Title.text = "确认";
    end
    if(parem[5]) then
        self.Tips.text = parem[5];
    else
        self.Tips.text = "Are You Sure?";
    end
    if(parem[6]) then
        self.OkLabel.text = parem[6];
    else
        self.OkLabel.text = "确认";
    end
    if(parem[7]) then
        self.CancleLabel.text = parem[7];
    else
        self.CancleLabel.text = "取消";
    end
    if(parem[8]) then
        self.MoreObj.gameObject:SetActive(true)
        self.MoreTips.text = parem[8];
    else
        self.MoreObj.gameObject:SetActive(false)
    end
end

function CommonOKOrCancle:OnClickOKBtn()
     if(self.fun1 ~=nil) then
        self.fun1(self.go);
    end
    UIService:Instance():HideUI(UIType.CommonOKOrCancle)
end


function CommonOKOrCancle:OnClickCancleBtn()
    if(self.fun2 ~=nil) then
        self.fun2(self.go);
    end
    UIService:Instance():HideUI(UIType.CommonOKOrCancle)
end

function CommonOKOrCancle:OnClickCloseBtn()
  UIService:Instance():HideUI(UIType.CommonOKOrCancle)
end

return CommonOKOrCancle;