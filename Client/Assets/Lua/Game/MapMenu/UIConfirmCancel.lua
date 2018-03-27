local UIBase= require("Game/UI/UIBase");
local UIConfirmCancel=class("UIConfirmCancel",UIBase);        
local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");

--构造方法
function UIConfirmCancel:ctor()
    UIConfirmCancel.super.ctor(self);
    self.Text = nil;
    self.Confirm = nil;
    self.Cancel = nil;

    self._curTiledIndex = nil
	self._troopIndex = nil 
	self.buildingId = nil 
	self._trainingTimes = nil

end

--注册控件
function UIConfirmCancel:DoDataExchange()
    self.Text = self:RegisterController(UnityEngine.UI.Text,"Text");
    self.Confirm = self:RegisterController(UnityEngine.UI.Button,"Confirm")
    self.Cancel  = self:RegisterController(UnityEngine.UI.Button,"Cancel")
end

--注册按钮点击事件
function UIConfirmCancel:DoEventAdd()
	self:AddListener(self.Confirm,self.OnClickConfirmBtn);
    self:AddListener(self.Cancel,self.OnClickCancelBtn);
end

function UIConfirmCancel:OnShow(param)
	self._curTiledIndex = param.tiledIndex
	self._troopIndex = param.troopIndex
	self.buildingId = param.buildingId
	self._trainingTimes = param._trainingTimes
	self.Text.text  = "体力或政令不足时练兵将会终止,是否继续练兵?";
end

function UIConfirmCancel:OnClickConfirmBtn()
	  local msg = require("MessageCommon/Msg/C2L/Army/ArmyTrainingMsg").new();
      msg:SetMessageId(C2L_Army.ArmyTrainingMsg);
      msg.buildingId = self.buildingId;
      msg.index = self._troopIndex;
      msg.tiledIndex = self._curTiledIndex;
      msg.trainingTimes = self._trainingTimes;
      NetService:Instance():SendMessage(msg);  
      UIService:Instance():HideUI(UIType.UIConfirmCancel);
      UIService:Instance():HideUI(UIType.UIConfirm);
      UIService:Instance():ShowUI(UIType.UIGameMainView)
end

function UIConfirmCancel:OnClickCancelBtn()
	UIService:Instance():HideUI(UIType.UIConfirmCancel)
end

return UIConfirmCancel