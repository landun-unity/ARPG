--[[
	游戏公告
	producer : ww
	date     : 17-1-11
]]

local UIBase = require("Game/UI/UIBase");
local UIType = require("Game/UI/UIType");
local UIService = require("Game/UI/UIService");
local UINotice = class("UINotice", UIBase);

--[[
	构造函数
]]
function UINotice:ctor()
	-- body
	UINotice.super.ctor(self);
	self._uri = DataConfig.Notice;
	self._TempText = {};
	self._Button_Close = nil;
	self._Text_NoticeTitle = nil;
	self._Text_NoticeContent = nil;
	self._fullNotice1 = {};
	self._fullNotice2 = {};
	self._fullNotice3 = {};
	self._ToggleGroup_NoticeToggles = nil;
	self._Toggle_NoticeTip1 = nil;
	self._Toggle_NoticeTip2 = nil;
	self._Toggle_NoticeTip3 = nil;
	self._Text_NoticeTip1 = nil;
	self._Text_NoticeTip2 = nil;
	self._Text_NoticeTip3 = nil;
	self._Image_NoticeTipCheck1 = nil;
	self._Image_NoticeTipCheck2 = nil;
	self._Image_NoticeTipCheck3 = nil;

end

function UINotice:DoDataExchange()
	-- body
	self._Button_Close = self:RegisterController(UnityEngine.UI.Button,"BackGround/CloseButton");
	self._Text_NoticeTitle = self:RegisterController(UnityEngine.UI.Text,"NoticeTip");
	self._Text_NoticeContent = self:RegisterController(UnityEngine.UI.Text,"NoticeContent");
	self._Text_NoticeTip1 = self:RegisterController(UnityEngine.UI.Text,"LeftGrid/NoticeTipToggle1/Label");
	self._Text_NoticeTip2 = self:RegisterController(UnityEngine.UI.Text,"LeftGrid/NoticeTipToggle2/Label");
	self._Text_NoticeTip3 = self:RegisterController(UnityEngine.UI.Text,"LeftGrid/NoticeTipToggle3/Label");
	self._Toggle_NoticeTip1 = self:RegisterController(UnityEngine.UI.Toggle,"LeftGrid/NoticeTipToggle1");
	self._Toggle_NoticeTip2 = self:RegisterController(UnityEngine.UI.Toggle,"LeftGrid/NoticeTipToggle2");
	self._Toggle_NoticeTip3 = self:RegisterController(UnityEngine.UI.Toggle,"LeftGrid/NoticeTipToggle3");
	self._ToggleGroup_NoticeToggles = self:RegisterController(UnityEngine.UI.ToggleGroup,"LeftGrid");
end

function UINotice:DoEventAdd()
	-- body
	self:AddListener(self._Button_Close,self.CloseButtonOnClick);
	self:AddToggleOnValueChanged(self._Toggle_NoticeTip1,self.NoticeTip1OnValueChange);
	self:AddToggleOnValueChanged(self._Toggle_NoticeTip2,self.NoticeTip2OnValueChange);
	self:AddToggleOnValueChanged(self._Toggle_NoticeTip3,self.NoticeTip3OnValueChange);
end

function UINotice:OnInit()
	-- body
	
end

function UINotice:CloseButtonOnClick()
	-- body
	UIService:Instance():HideUI(UIType.UINotice);
end

function UINotice:OnShow(type)
	-- body
	for id = 1,3 do
		local start = Time.time;
		-- local www = UnityEngine.WWW("http://"..self._uri.."GetNotice?id=1");
	    local www = UnityEngine.WWW("http://"..self._uri.."/Notice/GetNotice?id="..id.."&type="..type.."&state="..1);
	    while( not www.isDone )
	    do
	        if Time.time - start >= 2000 then
	            break;
	        end
	    end
	    if www.isDone then
	        self._TempText[id] = www.text;
	    end
	end
	self._Toggle_NoticeTip1.group = self._ToggleGroup_NoticeToggles;
	self._Toggle_NoticeTip2.group = self._ToggleGroup_NoticeToggles;
	self._Toggle_NoticeTip3.group = self._ToggleGroup_NoticeToggles;
	self._Toggle_NoticeTip1.isOn = true;
	self._Toggle_NoticeTip2.isOn = false;
	self._Toggle_NoticeTip3.isOn = false;
	local fullString1 = CommonService:Instance():StringSplit(self._TempText[1],"|");
	local fullString2 = CommonService:Instance():StringSplit(self._TempText[2],"|");
	local fullString3 = CommonService:Instance():StringSplit(self._TempText[3],"|");
	self._Text_NoticeTip1.text=fullString1[2];
	self._Text_NoticeTip2.text=fullString2[2];
	self._Text_NoticeTip3.text=fullString3[2];
	self._fullString = CommonService:Instance():StringSplit(self._TempText[1],"|");
	self._Text_NoticeTitle.text = self._fullString[2]
	self._Text_NoticeContent.text = self._fullString[3];
end

function UINotice:NoticeTip1OnValueChange()
	-- body
	self._fullString = CommonService:Instance():StringSplit(self._TempText[1],"|");
	self._Text_NoticeTitle.text = self._fullString[2]
	self._Text_NoticeContent.text = self._fullString[3];
end

function UINotice:NoticeTip2OnValueChange()
	-- body
	self._fullString = CommonService:Instance():StringSplit(self._TempText[2],"|");
	self._Text_NoticeTitle.text = self._fullString[2]
	self._Text_NoticeContent.text = self._fullString[3];
end

function UINotice:NoticeTip3OnValueChange()
	-- body
	self._fullString = CommonService:Instance():StringSplit(self._TempText[3],"|");
	self._Text_NoticeTitle.text = self._fullString[2]
	self._Text_NoticeContent.text = self._fullString[3];
end

return UINotice;