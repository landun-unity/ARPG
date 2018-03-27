--[[
	producer: ww 
	date:16-12-29
	
]]

local UIBase= require("Game/UI/UIBase");
local UIPlayerProfile=class("UIPlayerProfile",UIBase);
local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");
local PlayerService = require("Game/Player/PlayerService");
local UIPersonalPower = require("Game/PersonalPower/UIPersonalPower");

function UIPlayerProfile:ctor( )

	UIPlayerProfile.super.ctor(self);
	
	self._Button_Confirm = nil;
	self._Button_Back = nil;
	self._InputFiled_Profile =nil;
	self._Text_TopTip = nil;
	self._Text_ConfrimText = nil;
	self._Text_Profile = nil;
end

function UIPlayerProfile:DoDataExchange()
	self._Button_Confirm = self:RegisterController(UnityEngine.UI.Button,"BackGroundImage/Confirm");
	self._Button_Back = self:RegisterController(UnityEngine.UI.Button,"BackGroundImage/Back");
	self._Text_TopTip = self:RegisterController(UnityEngine.UI.Text,"BackGroundImage/Image/Text");
	self._Text_ConfrimText = self:RegisterController(UnityEngine.UI.Text,"BackGroundImage/Confirm/Text");
	self._Text_ProfilePlaceholder = self:RegisterController(UnityEngine.UI.Text,"BackGroundImage/NoticeInputField/Placeholder");
	self._InputFiled_Profile = self:RegisterController(UnityEngine.UI.InputField,"BackGroundImage/NoticeInputField");
end

function UIPlayerProfile:DoEventAdd()
	self:AddListener(self._Button_Confirm,self.ConfirmOnClick);
	self:AddListener(self._Button_Back,self.BackOnClick);
end

function UIPlayerProfile:OnShow()
	self._Text_TopTip.text = "个人介绍";
	self._Text_ConfrimText.text = "确定";
	self._Text_ProfilePlaceholder.text = "介绍";
	self._InputFiled_Profile.text = UIPersonalPower:Instance()._Text_PersonalInfo.text;
end

function UIPlayerProfile:ConfirmOnClick()		
	--print("self._InputFiled_Profile.text = ",self._InputFiled_Profile.text);
	self:SendChangePlayerProfile(self._InputFiled_Profile.text);
	PlayerService:Instance():SetProfile(self._InputFiled_Profile.text);
	UIPersonalPower:Instance()._Text_PersonalInfo.text = self._InputFiled_Profile.text;
	UIService:Instance():HideUI(UIType.UIPlayerProfile);
	if UIPersonalPower:Instance()._Text_PersonalInfo.text ~= "" then
		UIPersonalPower:Instance()._Text_PersonalInfo.gameObject:SetActive(true);
		UIPersonalPower:Instance()._Text_PersonalInfoNotice.gameObject:SetActive(false);
	else
		UIPersonalPower:Instance()._Text_PersonalInfo.gameObject:SetActive(false);
		UIPersonalPower:Instance()._Text_PersonalInfoNotice.gameObject:SetActive(true);
	end
end

function UIPlayerProfile:BackOnClick()
	UIService:Instance():HideUI(UIType.UIPlayerProfile);
end

function UIPlayerProfile:SendChangePlayerProfile(profile)
	local msg = require("MessageCommon/Msg/C2L/PersonalPower/ChangePlayerProfile").new();
	msg:SetMessageId(C2L_PersonalPower.ChangePlayerProfile);
	if msg == nil then 
		return;
	end
	msg.playerProfile = profile;
	NetService:Instance():SendMessage(msg);
end

return UIPlayerProfile;