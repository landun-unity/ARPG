--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

    local UIBase = require("Game/UI/UIBase")
    local UIService = require("Game/UI/UIService")
    local UIType = require("Game/UI/UIType")
    ConscriptionConfirmUI = class("ConscriptionConfirmUI", UIBase)
    
function ConscriptionConfirmUI:ctor()
    ConscriptionConfirmUI.super.ctor(self)
    self.contentText = nil;
    self.cancelWarningText = nil;
    self.confirmBtn = nil;
    self.cancelBtn = nil;

    self.confirmCallBack = nil;     --确定征兵回调
    self.cancelCallBack = nil;      --取消征兵回调
end
  
--注册控件
function ConscriptionConfirmUI:DoDataExchange()   
   self.contentText = self:RegisterController(UnityEngine.UI.Text,"AffirmImage/ContentText");
   self.cancelWarningText = self:RegisterController(UnityEngine.UI.Text,"AffirmImage/CancelWarningText");
   self.confirmBtn = self:RegisterController(UnityEngine.UI.Button,"AffirmImage/ConfirmButton");   
   self.cancelBtn = self:RegisterController(UnityEngine.UI.Button,"AffirmImage/CancelButton");   
end

--注册控件点击事件
function ConscriptionConfirmUI:DoEventAdd()
  self:AddListener(self.confirmBtn,self.OnClickConfirmBtn)
  self:AddListener(self.cancelBtn,self.OnClickCancelBtn)
end

--注册确定征兵回调
function ConscriptionConfirmUI:RegistConfirmEvnet(callBack)
    self.confirmCallBack = callBack;
end

--注册取消征兵回调
function ConscriptionConfirmUI:RegistCancelEvnet(callBack)
    self.cancelCallBack = callBack;
end

-- 显示
--param[1] 确定征兵显示的内容  param[2] 取消征兵显示的内容  param[3] 确定立即征兵显示的内容 
function ConscriptionConfirmUI:OnShow(param)
    if param[1] ~= nil then
        self.contentText.text = param[1];
        self.cancelWarningText.gameObject:SetActive(false);
    elseif param[2] ~= nil then
        self.contentText.text = param[2];
        self.cancelWarningText.gameObject:SetActive(true);
    elseif param[3] ~= nil then
        self.contentText.text = param[3];
        self.cancelWarningText.gameObject:SetActive(false);
    end    
end

function ConscriptionConfirmUI:OnClickConfirmBtn(args)
    UIService:Instance():HideUI(UIType.ConscriptionConfirmUI);
    if  self.confirmCallBack ~= nil then
        self.confirmCallBack();
    end
    
end

function ConscriptionConfirmUI:OnClickCancelBtn(args)
    if  self.cancelCallBack ~= nil then
        self.cancelCallBack();
    end
end

return ConscriptionConfirmUI

--endregion
