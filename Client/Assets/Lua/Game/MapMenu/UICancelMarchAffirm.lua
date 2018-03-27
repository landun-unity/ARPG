--[[放弃要塞确认按钮]]--
local UIBase= require("Game/UI/UIBase");
local UICancelMarchAffirm=class("UICancelMarchAffirm",UIBase);        
local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");

--构造函数
function UICancelMarchAffirm:ctor()
    UICancelMarchAffirm.super.ctor(self);
    self.AffirmText = nil;
    self.abandonText = nil;
    self.ConfirmButton = nil;
    self.curTiledIndex = curTiledIndex;
    self.CancelButton = nil;
end


function UICancelMarchAffirm:DoDataExchange()
	self.AffirmText = self:RegisterController(UnityEngine.UI.Text,"AffirmImage/ChineseImage/BottomFiveUPImage/AffirmText");
	self.abandonText = self:RegisterController(UnityEngine.UI.Text,"AffirmImage/ChineseImage/BottomFiveImage/Text")
	self.ConfirmButton = self:RegisterController(UnityEngine.UI.Button,"AffirmImage/ConfirmButton")
    self.CancelButton = self:RegisterController(UnityEngine.UI.Button,"AffirmImage/CancelButton")
end

function UICancelMarchAffirm:OnShow(curTiledIndex)
	self.curTiledIndex = curTiledIndex;
	self.AffirmText.text = "是否确认放弃要塞？";
	self.abandonText.text = "成功放弃后,将失去本要塞所有功能,驻扎部队回撤回所属城市,征兵将直接取消";
end

function UICancelMarchAffirm:DoEventAdd()
   self:AddListener(self.ConfirmButton,self.OnClickConfirmButton);
   self:AddListener(self.CancelButton, self.OnClickCancelButton)

end

function UICancelMarchAffirm:OnClickCancelButton()
    UIService:Instance():HideUI(UIType.UICancelMarchAffirm)
end

function UICancelMarchAffirm:OnClickConfirmButton()

    local playerFortBuildingId=PlayerService:Instance():GetPlayerFort(self.curTiledIndex)._id;
    local msg = require("MessageCommon/Msg/C2L/Building/RemoveFort").new();
    msg:SetMessageId(C2L_Building.RemoveFort);
    msg.buildingId = playerFortBuildingId;
    msg.index = self.curTiledIndex
    NetService:Instance():SendMessage(msg);
    UIService:Instance():HideUI(UIType.UICancelMarchAffirm);
    UIService:Instance():HideUI(UIType.UIUpgradeBuilding);
    UIService:Instance():ShowUI(UIType.UIDeleteFort, self.curTiledIndex)
end


return UICancelMarchAffirm