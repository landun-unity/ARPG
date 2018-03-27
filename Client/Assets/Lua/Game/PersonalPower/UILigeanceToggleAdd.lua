--[[
	Producer : ww
	date: 16-12-26
--]]
local UIBase = require("Game/UI/UIBase")
local UILigeanceToggleAdd = class("UILigeanceToggleAdd",UIBase)
local UIType = require("Game/UI/UIType")
local UIService = require("Game/UI/UIService")

local UIPersonalPower = require("Game/PersonalPower/UIPersonalPower");

function UILigeanceToggleAdd:ctor()
	UILigeanceToggleAdd.super.ctor(self);

	self._Toggle_Select = nil;
	self._Text_LigeanceType = nil;
	self._TiledType = nil;
	self._IsShow = true;

	self.dynamicShowInfoCallBack = nil; -- 回调
end

function UILigeanceToggleAdd:SetTiledType(type)
	-- body
	self._TiledType = type;
end

function UILigeanceToggleAdd:GetTiledType()
	-- body
	return self._TiledType;
end


function UILigeanceToggleAdd:DoDataExchange()
	self._Text_LigeanceType = self:RegisterController(UnityEngine.UI.Text,"Toggle/Label");
	self._Toggle_Select = self:RegisterController(UnityEngine.UI.Toggle,"Toggle");
end

function UILigeanceToggleAdd:DoEventAdd()
	self:AddToggleOnValueChanged(self._Toggle_Select,self.ToggleOnSelect);
end

function UILigeanceToggleAdd:ToggleOnSelect()
	if	self._TiledType == nil then
		return;
	end
	if self._IsShow == true then
		self._IsShow = false 		
	else 
		self._IsShow = true 
	end

	if self._IsShow == false then
		-- UIPersonalPower:Instance()._Button_AllSelect.gameObject:SetActive(true);
		-- UIPersonalPower:Instance()._Button_AllCancel.gameObject:SetActive(false);
		UIPersonalPower:Instance():RemoveNeedShowTypeList(self._TiledType);
	else
		-- UIPersonalPower:Instance()._Button_AllSelect.gameObject:SetActive(false);
		-- UIPersonalPower:Instance()._Button_AllCancel.gameObject:SetActive(true);
		UIPersonalPower:Instance():AddNeedShowTypeList(self._TiledType);
	end
	UIPersonalPower:Instance()._UILigeanceToggleStatuList[self._TiledType] = self._Toggle_Select.isOn;	
	UIPersonalPower:Instance():ShowAllSelectOrCancelButton();
	UIPersonalPower:Instance():RefreshShowInfo(self._TiledType);
end

function UILigeanceToggleAdd:RegistDynamicShowInfoEvnet(callback)
	-- body
	self.dynamicShowInfoCallBack = callback;
end


function UILigeanceToggleAdd:ShowText(str,count)
	-- body
	self._Text_LigeanceType.text = "<color=#ffe980>"..str.."</color>  "..count;
end


return UILigeanceToggleAdd;