-- 取消升级要塞

local UIBase = require("Game/UI/UIBase");
local UIDeleteFortCancelMarchAffirm = class("UIDeleteFortCancelMarchAffirm",UIBase);
local UIService=require("Game/UI/UIService")
local UIType=require("Game/UI/UIType")
local DataBuilding = require("Game/Table/model/DataBuilding")

--构造函数
function UIDeleteFortCancelMarchAffirm:ctor()
    UIDeleteFortCancelMarchAffirm.super.ctor(self);
    self.curTiledIndex = nil;
    self.ConfirmButton = nil;
    self.CancelButton = nil;
    self.AffirmText = nil;
    self.BottomFiveText = nil;
end

function UIDeleteFortCancelMarchAffirm:OnShow(curTiledIndex)
	self.curTiledIndex = curTiledIndex
	self:SetText();

end

function UIDeleteFortCancelMarchAffirm:DoDataExchange()    
    self.confirmBtn = self:RegisterController(UnityEngine.UI.Button,"AffirmImage/ConfirmButton")
    self.backBtn = self:RegisterController(UnityEngine.UI.Button,"AffirmImage/CancelButton");
    self.AffirmText = self:RegisterController(UnityEngine.UI.Text,"AffirmImage/ChineseImage/BottomFiveUPImage/AffirmText");
    self.BottomFiveText = self:RegisterController(UnityEngine.UI.Text,"AffirmImage/ChineseImage/BottomFiveImage/Text")
end

function UIDeleteFortCancelMarchAffirm:DoEventAdd()
    self:AddListener(self.confirmBtn,self.OnClickconfirmBtn);
    self:AddListener(self.backBtn,self.OnClickbackBtn);
end

function UIDeleteFortCancelMarchAffirm:OnClickconfirmBtn()
	local msg = require("MessageCommon/Msg/C2L/Building/UpdateFort").new();
    msg:SetMessageId(C2L_Building.UpdateFort);
    msg.tiledIndex = self.curTiledIndex
    NetService:Instance():SendMessage(msg);
end

function UIDeleteFortCancelMarchAffirm:OnClickbackBtn()
	UIService:Instance():HideUI(UIType.UIDeleteFortCancelMarchAffirm);
end

function UIDeleteFortCancelMarchAffirm:SetText()
	self.AffirmText.text = "是否确认取消建造与升级"
	self.BottomFiveText.text = "取消建造或升级将只返回80%资源";
end



return UIDeleteFortCancelMarchAffirm