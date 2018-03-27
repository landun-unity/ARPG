--[[
    政令界面
--]]

local UIBase= require("Game/UI/UIBase")
local UIService=require("Game/UI/UIService")
local UIType=require("Game/UI/UIType")
local DataGameConfig = require("Game/Table/Model/DataGameConfig");
local UIToken=class("UIToken",UIBase)
local EventType = require("Game/Util/EventType");
local EventService = require("Game/Util/EventService")

--构造函数
function UIToken:ctor()
	UIToken.super.ctor(self)
  	self.closeBtn = nil;
  	self.governmentTokenButton = nil;
  	self._Text_DecreeCount = nil;
  	self._Text_Timer = nil;
  	self._Times = nil;
  	self._Days = nil;
  	self._maxBuyTimes = DataGameConfig[512].OfficialData;
    self._governmentTokenButtonPressCount = 0;
end

--注册控件
function UIToken:DoDataExchange()
    self.closeBtn=self:RegisterController(UnityEngine.UI.Button,"governmentTokenImage/XButton");
    self.governmentTokenButton = self:RegisterController(UnityEngine.UI.Button,"governmentTokenImage/governmentTokenButton");
    self._Text_DecreeCount = self:RegisterController(UnityEngine.UI.Text,"governmentTokenImage/numberText");
    self._Text_Timer = self:RegisterController(UnityEngine.UI.Text,"governmentTokenImage/timeText");
end

--注册控件点击事件
function UIToken:DoEventAdd()
    self:AddListener(self.closeBtn,self.OnClickCloseBtn);
    self:AddListener(self.governmentTokenButton,self.OnClickgovernmentTokenButton);
end

function UIToken:OnShow(Time)
	-- body 
  self:FlashEachSecond(Time);
	self:JudyeShowButton();
	self._requestTimer = Timer.New( function()
        self:FlashEachSecond(Time);
        self:JudyeShowButton();
    end , 1, -1, false)
    self._requestTimer:Start();
	
end

function UIToken:JudyeShowButton()

	local times = PlayerService:Instance():GetBuyDecreeTimes();
	local days = PlayerService:Instance():GetBuyDecreeDays();
	if DataGameConfig[512].OfficialData - times < 1 then
		self.governmentTokenButton.gameObject:SetActive(false);
		return;
	end
end

function UIToken:FlashEachSecond(Time)
	-- body
	if PlayerService:Instance():GetDecreeSystem():GetCurValue() < PlayerService:Instance():GetDecreeSystem():GetMaxValue() then
        --print("PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Decree):GetValue()"..PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Decree):GetValue());
        -- print(lastUpdateTime);
        self._Text_Timer.gameObject:SetActive(true);
        self._Text_Timer.text = self:TimeFormat(PlayerService:Instance():GetDecreeSystem():GetLastUpdateTime() + DataGameConfig[514].OfficialData/1000 - PlayerService:Instance():GetLocalTime()/1000 -1);      
    else
        self._Text_Timer.gameObject:SetActive(false);
        self._Text_Timer.text = "00:00:00";
    end
	
	self._Text_DecreeCount.text = tostring(DataGameConfig[512].OfficialData-PlayerService:Instance():GetBuyDecreeTimes());
end

function UIToken:OnClickgovernmentTokenButton()		
  
	-- local Jade = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Jade):GetValue();
	-- local jade = Jade-60;
	-- PlayerService:Instance():GetDecreeSystem():ChangeCurValue(DataGameConfig[513].OfficialData);
	-- PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Jade):SetValue(jade);
	-- EventService:Instance():TriggerEvent(EventType.Resource);
  local Jade = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Jade):GetValue();
  if Jade < 60 then
    UIService:Instance():ShowUI(UIType.UICueMessageBox,UICueMessageType.NoJade);
    return;
  end
	local msg = require("MessageCommon/Msg/C2L/Player/RequsetBuyDercee").new();
  msg:SetMessageId(C2L_Player.RequsetBuyDercee);
  NetService:Instance():SendMessage(msg);
	self._governmentTokenButtonPressCount = self._governmentTokenButtonPressCount+ 1;
  if self._governmentTokenButtonPressCount >= 3 then
    self.governmentTokenButton.gameObject:SetActive(false)
  else
    self.governmentTokenButton.gameObject:SetActive(true);
  end
end



function UIToken:OnClickCloseBtn()
    UIService:Instance():HideUI(UIType.UIToken);
end

--点击开始游戏按钮逻辑
function UIToken.OnClickStartBtn(self)

end
function UIToken:TimeFormat(time)
    local h = math.floor(time / 3600);
    local m = 0;
    local s = 0;
    local timeText = nil;
    if time <= 0 then
        timeText = "00:00:00";
    else
        if time > 3600 then
             m = math.floor((time % 3600) / 60);
        else
             m = math.floor(time/60);
        end
        if time > 3600 then
             s = time % 3600 % 60;
        elseif time > 60 then
             s = time % 60;
        else
             s = time;
        end
        timeText = string.format("%02d:%02d:%02d", h, m, s);
    end    
    return timeText;
end

return UIToken
