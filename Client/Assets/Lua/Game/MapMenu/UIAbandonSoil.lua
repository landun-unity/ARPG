--[[
	放弃土地
	Author: zzy
--  Data:
--]]


local UIBase = require("Game/UI/UIBase")

local UIAbandonSoil = class("UIAbandonSoil",UIBase)
local UIService=require("Game/UI/UIService")
local UIType=require("Game/UI/UIType")


function UIAbandonSoil:ctor()
	print("UIAbandonSoil...")
	UIAbandonSoil.super.ctor(self)
	self.cancelbutton = nil
	self.confirmbutton = nil
	self._curTiledIndex = 0;
	self.BottomFiveUPText = nil;
	self.coordinateText = nil;
end

--判断加载预制
function UIAbandonSoil:OnShow(param)       
    self._curTiledIndex = param
    local tiled = MapService:Instance():GetTiledByIndex(self._curTiledIndex);
    if tiled == nil then 
    	return
    end
    if tiled._building ~= nil then
    	self.BottomFiveUPText.text = "土地放弃需要90分钟,放弃后将失去此土地的所有权,要塞也将被拆除,驻扎部队会撤回所属城市,征兵将直接取消"
    else
    	self.BottomFiveUPText.text = "土地放弃需要90分钟,放弃后将失去此土地的所有权"
    end
    local x,y = MapService:Instance():GetTiledCoordinate(self._curTiledIndex)
    self.coordinateText.text = "是否确认放弃领地(".."<color=#6BA0D3FF>"..x.."</color>"..",".."<color=#6BA0D3FF>"..y.."</color>"..")"
end
--注册控件
function UIAbandonSoil:DoDataExchange()
	--print("1111111111111111111")
	self.cancelbutton=self:RegisterController(UnityEngine.UI.Button,"ManorAbandonImage/cancelButton")
	self.confirmbutton=self:RegisterController(UnityEngine.UI.Button,"ManorAbandonImage/confirmButton")
	self.BottomFiveUPText = self:RegisterController(UnityEngine.UI.Text,"ManorAbandonImage/ChineseImage/BottomFiveUPImage/Text");
	self.coordinateText = self:RegisterController(UnityEngine.UI.Text,"ManorAbandonImage/ChineseImage/BottomFiveUPImage/coordinateText")
end


--注册控件点击事件
function UIAbandonSoil:DoEventAdd()
	self:AddListener(self.cancelbutton,self.OnClickcancelButton)
	self:AddListener(self.confirmbutton,self.OnClickconfirmButton)
end


--点击取消按钮逻辑
function UIAbandonSoil:OnClickcancelButton()
	--UIAbandonSoil:TestGetMd5()
	UIService:Instance():HideUI(UIType.UIAbandonSoil)
end

--点击确定
function UIAbandonSoil:OnClickconfirmButton()
	--UIAbandonSoil:TestGetMd5()
	self:OnclickGiveUPOwnerLand();
	UIService:Instance():HideUI(UIType.UIOneselfSoilObj)
	UIService:Instance():HideUI(UIType.UIAbandonSoil)
end

function UIAbandonSoil:OnclickGiveUPOwnerLand()
	local building = BuildingService:Instance():GetBuildingByTiledId(self._curTiledIndex);
	if building ~= nil then
		if building._dataInfo.Type == BuildingType.PlayerFort then
			local msg = require("MessageCommon/Msg/C2L/Building/deleteLandFort").new();
		    msg:SetMessageId(C2L_Building.deleteLandFort);
		    msg.buildingId = 123456;
		    msg.tiledIndex = self._curTiledIndex;
		    NetService:Instance():SendMessage(msg);
		else
			local msg = require("MessageCommon/Msg/C2L/Army/GiveUpOwnerLand").new();
		    msg:SetMessageId(C2L_Army.GiveUpOwnerLand);
		    msg.buildingId = 123456;
		    msg.tiledIndex = self._curTiledIndex;
		    local x,y = MapService:Instance():GetTiledCoordinate(msg.tiledIndex)
		    NetService:Instance():SendMessage(msg);  
		end
	else
		local msg = require("MessageCommon/Msg/C2L/Army/GiveUpOwnerLand").new();
	    msg:SetMessageId(C2L_Army.GiveUpOwnerLand);
	    msg.buildingId = 123456;
	    msg.tiledIndex = self._curTiledIndex;
	    local x,y = MapService:Instance():GetTiledCoordinate(msg.tiledIndex)
	    NetService:Instance():SendMessage(msg);  
	end
		UIService:Instance():HideUI(UIType.UIConfirm);
end

return UIAbandonSoil

 





