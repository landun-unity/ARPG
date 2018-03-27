
local UIBase= require("Game/UI/UIBase");
local List = require("common/List")
local UIExtensionConfirm=class("UIExtensionConfirm",UIBase); 
function UIExtensionConfirm:ctor()
    UIExtensionConfirm.super.ctor(self);
    self.confirmBtn = nil;
    self.backBtn = nil;

    self.param = nil;
end

function UIExtensionConfirm:RegisterAllNotice()
    --扩建消息
    self:RegisterNotice(L2C_Facility.CityExpandRespond, self.OnClickBackBtn);
end


--注册控件
function UIExtensionConfirm:DoDataExchange()
  	self.confirmBtn = self:RegisterController(UnityEngine.UI.Button,"confirmBtn");
    self.backBtn = self:RegisterController(UnityEngine.UI.Button,"backBtn");
end

--注册控件点击事件
function UIExtensionConfirm:DoEventAdd()
    self:AddListener(self.backBtn,self.OnClickBackBtn);
	self:AddListener(self.confirmBtn,self.OnClickConfirmBtn);
end

function UIExtensionConfirm:OnClickConfirmBtn()
	local msg = require("MessageCommon/Msg/C2L/Facility/CityExpandRequest").new();
    msg:SetMessageId(C2L_Facility.CityExpandRequest);
 
    local cityTiledList = List.new();
    msg.buildingId = self.param.buildingId;
    msg.titled = self.param.tiledIndex;
    msg.canExpandTime = self.param.canExpandTime;
    for k,v in pairs(self.param.cityTiled) do
		cityTiledList:Push(v);
	end
	for i=1,cityTiledList:Count() do 
		local title=cityTiledList:Get(i);
		local model=require("MessageCommon/Msg/C2L/Facility/C2LCityTitleModel").new();
		model.index=title._index;
		model.tableid=title._tableId;
		model.level=title._level;
        model.folkType=title._ResidenceType;
        msg.list:Push(model);
	end 


    NetService:Instance():SendMessage(msg);
end

function UIExtensionConfirm:OnClickBackBtn()
	UIService:Instance():HideUI(UIType.UIExtensionConfirm);
end

function UIExtensionConfirm:OnShow(param)
	--print(param);
	self.param = param;
end

return UIExtensionConfirm;