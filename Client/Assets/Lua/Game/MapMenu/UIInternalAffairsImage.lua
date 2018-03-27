local UIBase = require("Game/UI/UIBase")

local UIInternalAffairsImage = class("UIInternalAffairsImage",UIBase)
local UIService=require("Game/UI/UIService")
local UIType=require("Game/UI/UIType")
local CurrencyEnum = require("Game/Player/CurrencyEnum")

function UIInternalAffairsImage:ctor()
	UIInternalAffairsImage.super.ctor(self)

	self.RevenueImage = nil;
	self.DealImage = nil;

	-- 第一次时间
	self._OneRevenueTime = nil;
	-- 第一次金币
	self._OneRevenueAmount = nil;
	-- 完成
	self._OneAccomplishImImage = nil;
	-- 征收
	self._OneLevyLsImage = nil;
	-- 不能征收
	self._OneLevyHsImage = nil;
	self._OneRevenueMoneyImage = nil;
	self._TwoRevenueTime = nil;
	self._TwoRevenueAmount = nil;
	self._TwoAccomplishImImage = nil;
	self._TwoLevyLsImage = nil;
	self._TwoLevyHsImage = nil;
	self._TwoRevenueMoneyImage = nil;
	self._ThreeRevenueTime = nil;
	self._ThreeRevenueAmount = nil;
	self._ThreeAccomplishImImage = nil;
	self._ThreeLevyLsImage = nil;
	self._ThreeLevyHsImage = nil;
	self._ThreeRevenueMoneyImage = nil;
	-- 说明按钮
	self._WhReminderImage = nil;
	-- 征收按钮
	self.levyButton = nil;
	-- 立即按钮
	self.immediatelyButton = nil;
	-- 强征按钮
	self.impressButton = nil;
	self.immediatelyTimeText = nil;
	self.impressLsText = nil;
	self.XImage = nil;
	-- 计时器
	self._requestTimer = nil;
	self.requestTime = false;
	self._RevenueTwo = false;
	self._requestTwoTimer = nil;
	self._requestTimingTimer = nil;
	self._requestTimers = nil;
	self._requestCountdown= nil;
	self._ImmediatelyinishTimer= nil;
	self.levyPanel = nil;
	self.levyText = nil;
	self.impressLs = 3;
	self.ImpresText = nil;
	self.AllTimeDownTable = {};

	self.RevenueNotObj = nil;
	self.RevenueOpenObj = nil;


	-----------------交易

	self.RevenueBigFrameImage = nil;
	self.TransactionalInterface = nil;

	self.Number = nil; --集世数
	self.scale = nil; --交易比
	self.OneNextImage = nil; -- 木
	self.TwoNextImage = nil; -- 铁
	self.ThreeNextImage = nil; -- 石
	self.FourNextImage = nil; -- 粮
	self.number1 = nil;
	self.number2 = nil;
	self.number3 = nil;
	self.number4 = nil;

	self.OneNextImage1 = nil; 
	self.TwoNextImage1 = nil;
	self.ThreeNextImage1 = nil;
	self.FourNextImage1 = nil;

	self.left = nil;
	self.resource = nil
	self.quantity = nil;

	self.right = nil; 
	self.resource1 = nil;
	self.quantity1 = nil;

	self.Next = nil;
	self.twoNext = nil;
	self.threeNext = nil;
	self.fortNext = nil;

	self.oneNext1 = nil
	self.twoNext1 = nil;
	self.threeNext1 = nil;
	self.fortNext1 = nil;

	self.ConsumeResource = 0
	self.AddResource = nil;
	self.ConfirmButton = nil;

	self.curresourceText = nil;
	self.expendresourceText = nil;

	self.resourceText1 = nil;
	self.resourceText2 = nil;

	self.Slider = nil;
	self.Panel = nil;
	self.ButtonGray = nil;

	self.sliderImage = nil;
	self.sliderImage1 = nil;

	self.transactionType = nil;
	self.goaltransactionType = nil;

	self.TransactionaOpenObj = nil;
	self.TransactionaOpenObjPanel = nil;
	self.nextImage = {}
	self.NextBtn = {}
end

function UIInternalAffairsImage:DoDataExchange()  
	self.RevenueImage = self:RegisterController(UnityEngine.UI.Toggle,"InternalAffairsObj/RevenueImage");
	self.DealImage = self:RegisterController(UnityEngine.UI.Toggle,"InternalAffairsObj/DealImage")

 	self._OneRevenueTime = self:RegisterController(UnityEngine.UI.Text,"RevenueBigFrameImage/RevenueOpenObj/Image/Image/OneRevenueObj/OneRevenueTimeText");
 	self._OneRevenueAmount = self:RegisterController(UnityEngine.UI.Text,"RevenueBigFrameImage/RevenueOpenObj/Image/Image/OneRevenueObj/OneRevenueMoneyText")
 	self._OneAccomplishImImage = self:RegisterController(UnityEngine.UI.Image,"RevenueBigFrameImage/RevenueOpenObj/Image/Image/OneRevenueObj/OneRevenueAccomplishImImage")
 	self._OneLevyLsImage = self:RegisterController(UnityEngine.UI.Image,"RevenueBigFrameImage/RevenueOpenObj/Image/Image/OneRevenueObj/OneRevenueLevyLsImage")
 	self._OneLevyHsImage = self:RegisterController(UnityEngine.UI.Image,"RevenueBigFrameImage/RevenueOpenObj/Image/Image/OneRevenueObj/OneRevenueLevyHsImage")
 	self._OneRevenueMoneyImage = self:RegisterController(UnityEngine.UI.Image,"RevenueBigFrameImage/RevenueOpenObj/Image/Image/OneRevenueObj/OneRevenueMoneyImage");
 	self._TwoRevenueTime = self:RegisterController(UnityEngine.UI.Text,"RevenueBigFrameImage/RevenueOpenObj/Image/Image/TwoRevenueObj/OneRevenueTimeText");
 	self._TwoRevenueAmount = self:RegisterController(UnityEngine.UI.Text,"RevenueBigFrameImage/RevenueOpenObj/Image/Image/TwoRevenueObj/OneRevenueMoneyText");
 	self._TwoAccomplishImImage = self:RegisterController(UnityEngine.UI.Image,"RevenueBigFrameImage/RevenueOpenObj/Image/Image/TwoRevenueObj/OneRevenueAccomplishImImage");
 	self._TwoLevyLsImage = self:RegisterController(UnityEngine.UI.Image,"RevenueBigFrameImage/RevenueOpenObj/Image/Image/TwoRevenueObj/OneRevenueLevyLsImage");
 	self._TwoLevyHsImage = self:RegisterController(UnityEngine.UI.Image,"RevenueBigFrameImage/RevenueOpenObj/Image/Image/TwoRevenueObj/OneRevenueLevyHsImage");
 	self._TwoRevenueMoneyImage = self:RegisterController(UnityEngine.UI.Image,"RevenueBigFrameImage/RevenueOpenObj/Image/Image/TwoRevenueObj/OneRevenueMoneyImage");
 	self._ThreeRevenueTime = self:RegisterController(UnityEngine.UI.Text,"RevenueBigFrameImage/RevenueOpenObj/Image/Image/ThreeRevenueObj/OneRevenueTimeText");
 	self._ThreeRevenueAmount = self:RegisterController(UnityEngine.UI.Text,"RevenueBigFrameImage/RevenueOpenObj/Image/Image/ThreeRevenueObj/OneRevenueMoneyText");
	self._ThreeAccomplishImImage = self:RegisterController(UnityEngine.UI.Image,"RevenueBigFrameImage/RevenueOpenObj/Image/Image/ThreeRevenueObj/OneRevenueAccomplishImImage");
	self._ThreeLevyLsImage = self:RegisterController(UnityEngine.UI.Image,"RevenueBigFrameImage/RevenueOpenObj/Image/Image/ThreeRevenueObj/OneRevenueLevyLsImage");
	self._ThreeLevyHsImage = self:RegisterController(UnityEngine.UI.Image,"RevenueBigFrameImage/RevenueOpenObj/Image/Image/ThreeRevenueObj/OneRevenueLevyHsImage");
	self._ThreeRevenueMoneyImage = self:RegisterController(UnityEngine.UI.Image,"RevenueBigFrameImage/RevenueOpenObj/Image/Image/ThreeRevenueObj/OneRevenueMoneyImage");
	self._WhReminderImage = self:RegisterController(UnityEngine.UI.Button,"RevenueBigFrameImage/RevenueOpenObj/Image/Image/WhReminderImage");


	self.levyButton = self:RegisterController(UnityEngine.UI.Button,"RevenueBigFrameImage/RevenueOpenObj/LevyObj/levyButton");
	self.levyPanel = self:RegisterController(UnityEngine.UI.Image,"RevenueBigFrameImage/RevenueOpenObj/LevyObj/impressLsText/Panel");
	self.levyText = self:RegisterController(UnityEngine.UI.Text,"RevenueBigFrameImage/RevenueOpenObj/LevyObj/impressLsText/Panel/Text");
	self.immediatelyButton = self:RegisterController(UnityEngine.UI.Button,"RevenueBigFrameImage/RevenueOpenObj/LevyObj/immediatelyTimeText/immediatelyButton");
	self.impressButton = self:RegisterController(UnityEngine.UI.Button,"RevenueBigFrameImage/RevenueOpenObj/LevyObj/impressLsText/impressButton");
	self.immediatelyTimeText = self:RegisterController(UnityEngine.UI.Text,"RevenueBigFrameImage/RevenueOpenObj/LevyObj/immediatelyTimeText");
	self.impressLsText = self:RegisterController(UnityEngine.UI.Text,"RevenueBigFrameImage/RevenueOpenObj/LevyObj/impressLsText");
	self.XImage = self:RegisterController(UnityEngine.UI.Button,"XImage");
	self.ImpresText = self:RegisterController(UnityEngine.UI.Text,"RevenueBigFrameImage/RevenueOpenObj/LevyObj/ImpressObj/ImpressText")

	self.RevenueNotObj = self:RegisterController(UnityEngine.Transform,"RevenueBigFrameImage/RevenueNotObj")
	self.RevenueOpenObj = self:RegisterController(UnityEngine.Transform,"RevenueBigFrameImage/RevenueOpenObj")
	self.RevenueBigFrameImage = self:RegisterController(UnityEngine.UI.Image,"RevenueBigFrameImage")
	self.TransactionalInterface = self:RegisterController(UnityEngine.UI.Image,"TransactionalInterface")
	------------------------交易
	self.TransactionaOpenObj = self:RegisterController(UnityEngine.Transform,"TransactionalInterface/TransactionaOpenObj")
	self.TransactionaOpenObjPanel = self:RegisterController(UnityEngine.UI.Image,"TransactionalInterface/TransactionaNotObj")
	self.Number = self:RegisterController(UnityEngine.UI.Text,"TransactionalInterface/TransactionaOpenObj/Number")
	self.scale = self:RegisterController(UnityEngine.UI.Text,"TransactionalInterface/TransactionaOpenObj/scale")
	self.OneNextImage = self:RegisterController(UnityEngine.UI.Toggle,"TransactionalInterface/TransactionaOpenObj/TrainingNext/OneNextImage")
	self.TwoNextImage = self:RegisterController(UnityEngine.UI.Toggle,"TransactionalInterface/TransactionaOpenObj/TrainingNext/TwoNextImage")
	self.ThreeNextImage = self:RegisterController(UnityEngine.UI.Toggle,"TransactionalInterface/TransactionaOpenObj/TrainingNext/ThreeNextImage")
	self.FourNextImage = self:RegisterController(UnityEngine.UI.Toggle,"TransactionalInterface/TransactionaOpenObj/TrainingNext/FourNextImage")
	self.NextBtn[1] = self.OneNextImage
	self.NextBtn[2] = self.TwoNextImage
	self.NextBtn[3] = self.ThreeNextImage
	self.NextBtn[4] = self.FourNextImage

	self.number1 = self:RegisterController(UnityEngine.UI.Text,"TransactionalInterface/TransactionaOpenObj/TrainingNext/OneNextImage/number1")
	self.number2 = self:RegisterController(UnityEngine.UI.Text,"TransactionalInterface/TransactionaOpenObj/TrainingNext/TwoNextImage/number2")
	self.number3 = self:RegisterController(UnityEngine.UI.Text,"TransactionalInterface/TransactionaOpenObj/TrainingNext/ThreeNextImage/number3")
	self.number4 = self:RegisterController(UnityEngine.UI.Text,"TransactionalInterface/TransactionaOpenObj/TrainingNext/FourNextImage/number4")

	self.OneNextImage1 = self:RegisterController(UnityEngine.UI.Toggle,"TransactionalInterface/TransactionaOpenObj/TrainingNext1/OneNextImage")
	self.TwoNextImage1 = self:RegisterController(UnityEngine.UI.Toggle,"TransactionalInterface/TransactionaOpenObj/TrainingNext1/TwoNextImage")
	self.ThreeNextImage1 = self:RegisterController(UnityEngine.UI.Toggle,"TransactionalInterface/TransactionaOpenObj/TrainingNext1/ThreeNextImage")
	self.FourNextImage1= self:RegisterController(UnityEngine.UI.Toggle,"TransactionalInterface/TransactionaOpenObj/TrainingNext1/FourNextImage")

	self.nextImage[1] = self.OneNextImage1
	self.nextImage[2] = self.TwoNextImage1
	self.nextImage[3] = self.ThreeNextImage1
	self.nextImage[4] = self.FourNextImage1



	self.left = self:RegisterController(UnityEngine.UI.Image,"TransactionalInterface/TransactionaOpenObj/left")
	self.resource = self:RegisterController(UnityEngine.UI.Text,"TransactionalInterface/TransactionaOpenObj/left/resource")
	self.quantity = self:RegisterController(UnityEngine.UI.Text,"TransactionalInterface/TransactionaOpenObj/left/quantity")

	self.right = self:RegisterController(UnityEngine.UI.Image,"TransactionalInterface/TransactionaOpenObj/right")
	self.resource1 = self:RegisterController(UnityEngine.UI.Text,"TransactionalInterface/TransactionaOpenObj/right/resource")
	self.quantity1 = self:RegisterController(UnityEngine.UI.Text,"TransactionalInterface/TransactionaOpenObj/right/quantity")
	self.ConfirmButton = self:RegisterController(UnityEngine.UI.Button,"TransactionalInterface/TransactionaOpenObj/Button")
	self.curresourceText = self:RegisterController(UnityEngine.UI.Text,"TransactionalInterface/TransactionaOpenObj/TrainingNext/Text1")
	self.expendresourceText = self:RegisterController(UnityEngine.UI.Text,"TransactionalInterface/TransactionaOpenObj/TrainingNext1/Text1")

	self.resourceText1 = self:RegisterController(UnityEngine.UI.Text,"TransactionalInterface/TransactionaOpenObj/TrainingNext/Text")
	self.resourceText2 = self:RegisterController(UnityEngine.UI.Text,"TransactionalInterface/TransactionaOpenObj/TrainingNext1/Text")

	self.Slider = self:RegisterController(UnityEngine.UI.Slider,"TransactionalInterface/TransactionaOpenObj/Slider");
	self.Panel = self:RegisterController(UnityEngine.UI.Image,"TransactionalInterface/TransactionaOpenObj/Panel")
	self.ButtonGray = self:RegisterController(UnityEngine.UI.Button,"TransactionalInterface/TransactionaOpenObj/ButtonGray")
	self.sliderImage = self:RegisterController(UnityEngine.UI.Image,"TransactionalInterface/TransactionaOpenObj/Slider/Background/Image")
	self.sliderImage1 =self:RegisterController(UnityEngine.UI.Image,"TransactionalInterface/TransactionaOpenObj/Slider/Handle Slide Area/Handle/Image")
end

--注册点击事件
function UIInternalAffairsImage:DoEventAdd()    
	self:AddOnClick(self._WhReminderImage,self.OnCilckWhReminder);
	self:AddOnClick(self.XImage,self.OnClickReturn);
	self:AddOnClick(self.levyButton,self.OnClickLevy);
	self:AddOnClick(self.levyButton1,self.OnClickLevy1)
	self:AddOnClick(self.levyButton2,self.OnClickLevy2)
	self:AddOnClick(self.impressButton,self.OnClickImpress)
	self:AddOnClick(self.immediatelyButton,self.OnClickImmediately)
	self:AddToggleOnValueChanged(self.RevenueImage, self.OnClickRevenueImage)
	self:AddToggleOnValueChanged(self.DealImage, self.OnClickDealImage);


	for i = 1, 4 do
		self.lua_behaviour:AddToggleOnValueChanged(self.NextBtn[i].gameObject,function ( ... )
    		return self.OnClickNextBtn(self, self.NextBtn[i], ...);
    	end)
	end

	for i = 1, 4 do
		self.lua_behaviour:AddOnClick(self.NextBtn[i].gameObject,function ( ... )
    		return self.OnClickNextImageBtn(self, self.NextBtn[i], ...);
    	end)
	end
	self:AddOnClick(self.ConfirmButton, self.ConfirmBtn)

	self:AddSliderOnValueChanged(self.Slider, self.OnSliderChanged);
	self:AddOnClick(self.ButtonGray, self.ClickBtnGray)
    self:AddOnUp(self.Slider, self.OnSliderUp);
    self:AddSliderOnValueChanged(self.Slider,self.SliderOnValueChanged)
    for i = 1, 4 do
    	self.lua_behaviour:AddToggleOnValueChanged(self.nextImage[i].gameObject,function ( ... )
    		return self.OnClickNext1Btn(self, self.nextImage[i], ...);
    	end)
    end

    for i = 1, 4 do 
    	self.lua_behaviour:AddOnClick(self.nextImage[i].gameObject,function ( ... )
    		return self.OnClickNextImage(self, self.nextImage[i], ...);
    	end)
    end
end


-- 注册所有的通知
function UIInternalAffairsImage:RegisterAllNotice()
	--print("注册所有的通知")
    self:RegisterNotice(L2C_Player.SyncReplyRevenue, self.RefreshValue);
    self:RegisterNotice(L2C_Player.SyncForced,self.Forced);
    self:RegisterNotice(L2C_Player.SyncImmediatelyFinish, self.ImmediatelyFinish)
    self:RegisterNotice(L2C_Player.RevenueInfo, self.RefreshValue)
    self:RegisterNotice(L2C_Player.RevenueCountInfo, self.SetSyncRevenueCountInfo)
    self:RegisterNotice(L2C_Player.SyncRevenueAllInfo, self.OnShow)
    self:RegisterNotice(L2C_Player.ReturnIntroductions, self.WhRminder)
    self:RegisterNotice(L2C_DomesticAffairs.TransactionInfoPrompt, self.MsgReturn)
end


function UIInternalAffairsImage:OnShow()
	self.TransactionalInterface.gameObject:SetActive(false); -- 交易
	self.RevenueBigFrameImage.gameObject:SetActive(true); -- 税收
	self:Transaction();
	self:ShowRevenue()
end

function UIInternalAffairsImage:Transaction()
	self.left.gameObject:SetActive(false)
	self.right.gameObject:SetActive(false)
	self.DealImage.isOn = false;
	self.RevenueImage.isOn = true
	self.Slider.enabled = false;
	self.sliderImage.gameObject:SetActive(true);
	self.sliderImage1.gameObject:SetActive(true);
	self:SetIsOnFalse()
	self:SetSliderToZero()
	self.ButtonGray.gameObject:SetActive(true);
	self.ConfirmButton.gameObject:SetActive(false);
end

function UIInternalAffairsImage:ShowRevenue()
	if FacilityService:Instance():GetFacilitylevelByIndex(PlayerService:Instance():GetmainCityId(),FacilityType.Residence) ~= nil and FacilityService:Instance():GetFacilitylevelByIndex(PlayerService:Instance():GetmainCityId(),FacilityType.Residence) >= 1  then
		self.RevenueOpenObj.gameObject:SetActive(true);
		self.RevenueNotObj.gameObject:SetActive(false);
	else
		self.RevenueOpenObj.gameObject:SetActive(false);
		self.RevenueNotObj.gameObject:SetActive(true);
		return;
	end
	local surplusReceiveCount = PlayerService:Instance():GetSurplusReceiveCount(); -- 征收次数
	local forced = PlayerService:Instance():GetForcedCounts() -- 强征次数
	if surplusReceiveCount == 0 then
		self._OneRevenueTime.gameObject:SetActive(false);
		self._OneRevenueMoneyImage.gameObject:SetActive(false);
		self._OneRevenueAmount.gameObject:SetActive(false);
		self._OneAccomplishImImage.gameObject:SetActive(false);
		self._OneLevyLsImage.gameObject:SetActive(true);
		self._OneLevyHsImage.gameObject:SetActive(false);


		self._TwoRevenueTime.gameObject:SetActive(false);
		self._OneRevenueMoneyImage.gameObject:SetActive(false);
		self._TwoRevenueAmount.gameObject:SetActive(false);
		self._TwoAccomplishImImage.gameObject:SetActive(false);
		self._TwoLevyLsImage.gameObject:SetActive(false);
		self._TwoLevyHsImage.gameObject:SetActive(true);

		self._ThreeRevenueTime.gameObject:SetActive(false);
		self._ThreeRevenueMoneyImage.gameObject:SetActive(false);
		self._ThreeRevenueAmount.gameObject:SetActive(false);
		self._ThreeAccomplishImImage.gameObject:SetActive(false);
		self._ThreeLevyLsImage.gameObject:SetActive(false);
		self._ThreeLevyHsImage.gameObject:SetActive(true);

		self.levyButton.gameObject:SetActive(true);
		self.immediatelyTimeText.gameObject:SetActive(false);
		self.impressLsText.gameObject:SetActive(false);
	elseif surplusReceiveCount == 1 then
		CommonService:Instance():RemoveTimeDownInfo(self.transform.gameObject)
		local finishTime = PlayerService:Instance():GetSecondCanClaimTime()
		local localTime = PlayerService:Instance():GetLocalTime();
		self.immediatelyTimeText.text = self:TimeFormat((finishTime - localTime) / 1000).." 后可以征收";
		self._OneRevenueMoneyImage.gameObject:SetActive(true);
		self._OneRevenueAmount.gameObject:SetActive(true);
		self._OneRevenueTime.gameObject:SetActive(true);
		self._OneAccomplishImImage.gameObject:SetActive(true);
		self._OneLevyLsImage.gameObject:SetActive(false);
		self.levyButton.gameObject:SetActive(false);
		self.immediatelyTimeText.gameObject:SetActive(true);
		local gold = PlayerService:Instance():GetOneGold();
		self._OneRevenueAmount.text = gold
		local Time = PlayerService:Instance():GetOneTime();
		self._OneRevenueTime.text = self:TimeFormat(Time/1000%86400+28800);

		if finishTime - localTime <= 0 then
			self.immediatelyTimeText.gameObject:SetActive(false);
			self.levyButton.gameObject:SetActive(true);
			self._TwoLevyHsImage.gameObject:SetActive(false);
			self._TwoLevyLsImage.gameObject:SetActive(true);
		end

		self:RevenueTimer(finishTime, surplusReceiveCount);
	elseif surplusReceiveCount == 2 then
		CommonService:Instance():RemoveTimeDownInfo(self.transform.gameObject)
		local finishTime = PlayerService:Instance():GetThirdCanClaimTime()
		local localTime = PlayerService:Instance():GetLocalTime();
		self.immediatelyTimeText.text = self:TimeFormat((finishTime - localTime) / 1000).." 后可以征收";
		self._OneRevenueMoneyImage.gameObject:SetActive(true);
		self._OneRevenueAmount.gameObject:SetActive(true);
		self._OneRevenueTime.gameObject:SetActive(true);
		self._OneAccomplishImImage.gameObject:SetActive(true);
		self._OneLevyLsImage.gameObject:SetActive(false);
		self.levyButton.gameObject:SetActive(false);
		self.immediatelyTimeText.gameObject:SetActive(true);
		self._TwoRevenueTime.gameObject:SetActive(true);
		self._TwoRevenueAmount.gameObject:SetActive(true);
		self._TwoRevenueMoneyImage.gameObject:SetActive(true);
		self._TwoAccomplishImImage.gameObject:SetActive(true);
		self._TwoLevyLsImage.gameObject:SetActive(false);
		self._TwoLevyHsImage.gameObject:SetActive(false)
		local oneGold = PlayerService:Instance():GetOneGold();
		local oneTime = PlayerService:Instance():GetOneTime();
		local twoGold = PlayerService:Instance():GetTwoGold();
		local twoTime = PlayerService:Instance():GetTwoTime();
		self._OneRevenueAmount.text = oneGold
		self._OneRevenueTime.text = self:TimeFormat(oneTime/1000%86400+28800);
		self._TwoRevenueAmount.text = twoGold;
		self._TwoRevenueTime.text = self:TimeFormat(twoTime/1000%86400+28800);
		if finishTime - localTime <= 0 then
			self.immediatelyTimeText.gameObject:SetActive(false);
			self.levyButton.gameObject:SetActive(true);
			self._ThreeLevyHsImage.gameObject:SetActive(false);
			self._ThreeLevyLsImage.gameObject:SetActive(true);
		end
		self:RevenueTimer(finishTime, surplusReceiveCount);
	elseif surplusReceiveCount == 3 then
		CommonService:Instance():RemoveTimeDownInfo(self.transform.gameObject)
		self._OneRevenueMoneyImage.gameObject:SetActive(true);
		self._OneRevenueAmount.gameObject:SetActive(true);
		self._OneRevenueTime.gameObject:SetActive(true);
		self._OneAccomplishImImage.gameObject:SetActive(true);
		self._OneLevyLsImage.gameObject:SetActive(false);
		self.levyButton.gameObject:SetActive(false);
		self.immediatelyTimeText.gameObject:SetActive(true);
		self._TwoRevenueTime.gameObject:SetActive(true);
		self._TwoRevenueAmount.gameObject:SetActive(true);
		self._TwoRevenueMoneyImage.gameObject:SetActive(true);
		self._TwoAccomplishImImage.gameObject:SetActive(true);
		self._TwoLevyLsImage.gameObject:SetActive(false);
		self._TwoLevyHsImage.gameObject:SetActive(false)
		self._ThreeLevyLsImage.gameObject:SetActive(false);
		self._ThreeAccomplishImImage.gameObject:SetActive(true);
		self._ThreeRevenueTime.gameObject:SetActive(true);
		self._ThreeRevenueMoneyImage.gameObject:SetActive(true);
		self._ThreeRevenueAmount.gameObject:SetActive(true);
		self.levyButton.gameObject:SetActive(false);
		self.immediatelyTimeText.gameObject:SetActive(false);
		self.impressLsText.gameObject:SetActive(true);
		self._ThreeLevyHsImage.gameObject:SetActive(false);
		local gold = PlayerService:Instance():GetThreeGold();
		local localTime = PlayerService:Instance():GetThreeTime();
		local forceCount = PlayerService:Instance():GetForcedCounts();
		local oneGold = PlayerService:Instance():GetOneGold();
		local oneTime = PlayerService:Instance():GetOneTime();
		local twoGold = PlayerService:Instance():GetTwoGold();
		local twoTime = PlayerService:Instance():GetTwoTime();
		
		self._OneRevenueAmount.text = oneGold
		self._OneRevenueTime.text = self:TimeFormat(oneTime/1000%86400+28800);
		self._TwoRevenueAmount.text = twoGold;
		self._TwoRevenueTime.text = self:TimeFormat(twoTime/1000%86400+28800);
		self._ThreeRevenueAmount.text = gold
		self._ThreeRevenueTime.text = self:TimeFormat(localTime/1000%86400+28800);
		self.impressLsText.text = "今日税收已用完,可强征"..forceCount.."次";
		if forced <= 0 then
			self.ImpresText.gameObject:SetActive(true);
			self.impressLsText.gameObject:SetActive(false);
		end
	end
end

-- 说明按钮
function UIInternalAffairsImage:OnCilckWhReminder()
	local msg = require("MessageCommon/Msg/C2L/Player/RevenueIntroductions").new();
    msg:SetMessageId(C2L_Player.RevenueIntroductions);
    NetService:Instance():SendMessage(msg);
end

function UIInternalAffairsImage:WhRminder()
	local opened = UIService:Instance():GetOpenedUI(UIType.UIInternalAffairsImage)
	if opened  then
		UIService:Instance():ShowUI(UIType.RevenueStatisticsPanel);
	end
end

-- 返回
function UIInternalAffairsImage:OnClickReturn()
	UIService:Instance():ShowUI(UIType.UIGameMainView)
	UIService:Instance():HideUI(UIType.UIInternalAffairsImage);
end

function UIInternalAffairsImage:OnClickLevy()
 	local msg = require("MessageCommon/Msg/C2L/Player/RequestRevenue").new();
    msg:SetMessageId(C2L_Player.RequestRevenue);
    msg.count = 1;
    NetService:Instance():SendMessage(msg);
 	PlayerService:Instance():SetNotCanReceive();
end

function UIInternalAffairsImage:TimeFormat(time)
    local h = math.floor(time / 3600);
    local m = math.floor((time % 3600) / 60);
    local s = time % 3600 % 60;
    local timeText = string.format("%02d:%02d:%02d",h, m, s);
    return timeText;
end

-- 税收计时器
function UIInternalAffairsImage:RevenueTimer(time, collectionCount)
 	CommonService:Instance():TimeDown(UIType.UIInternalAffairsImage, time,self.immediatelyTimeText,function()end);
end

function UIInternalAffairsImage:SetSyncRevenueCountInfo()
	local count = PlayerService:Instance():GetRevenueCount();
	CommonService:Instance():RemoveTimeDownInfo(self.transform.gameObject)
	if count == 1 then
		self.immediatelyTimeText.gameObject:SetActive(false);
		self.levyButton.gameObject:SetActive(true);
		self._TwoLevyHsImage.gameObject:SetActive(false);
		self._TwoLevyLsImage.gameObject:SetActive(true);
		PlayerService:Instance():SetIsCanReceive()
	elseif count == 2 then
		self.immediatelyTimeText.gameObject:SetActive(false);
		self.levyButton.gameObject:SetActive(true);
		self._ThreeLevyHsImage.gameObject:SetActive(false);
		self._ThreeLevyLsImage.gameObject:SetActive(true);
		PlayerService:Instance():SetIsCanReceive()
	end
end

-- 强征
function UIInternalAffairsImage:OnClickImpress()
	if PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Jade):GetValue() < 20 then
		local paramT = { };
	    paramT[1] = "您当前的宝石不足,是否前往充值界面?";
	    paramT[2] = "每次使用强征征收,需要消耗20宝石"
	    paramT[3] = true
	    paramT[4] = true;
	    paramT[5] = "前往充值";
	    paramT[6] = "宝石不足";
	    UIService:Instance():ShowUI(UIType.MessageBox, paramT);
	    MessageBox:Instance():RegisterOk( function()
	        self:CallBackOK();
	    end );
	else
		local msg = require("MessageCommon/Msg/C2L/Player/RequestForced").new();
		msg:SetMessageId(C2L_Player.RequestForced);
    	NetService:Instance():SendMessage(msg);
	end
end

function UIInternalAffairsImage:Forced()
	local forceRevenueCount = PlayerService:Instance():GetForceRevenueCount();
	if forceRevenueCount <= 0 then
		self.ImpresText.gameObject:SetActive(true);
		self.impressLsText.gameObject:SetActive(false);
	end
	self.impressLsText.text = "今日税收已用完,可强征"..forceRevenueCount.."次";
	self.levyPanel.gameObject:SetActive(true)
	local gold = PlayerService:Instance():GetClickRevenueGold();
	if gold ~= nil then
		self.levyText.text = "本次强征收取"..gold.."铜"
	end
	self:Timing();
end

function UIInternalAffairsImage:Timing()
	local EveryTwoHours = 3;
    self._requestTimingTimer = Timer.New(function()
    	EveryTwoHours = EveryTwoHours - 1 ;
    	if EveryTwoHours <= 0 then 
    	self.levyPanel.gameObject:SetActive(false);
    	end
    end, 1, -1, false)
    self._requestTimingTimer:Start()
end

-- 立即完成
function UIInternalAffairsImage:OnClickImmediately()
	if PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Jade):GetValue() < 20 then
		local paramT = { };
	    paramT[1] = "您当前的宝石不足,是否前往充值界面?";
	    paramT[2] = "每次使用立即征收,需要消耗20宝石"
	    paramT[3] = true
	    paramT[4] = true;
	    paramT[5] = "前往充值";
	    paramT[6] = "宝石不足";
	    UIService:Instance():ShowUI(UIType.MessageBox, paramT);
	    MessageBox:Instance():RegisterOk( function()
	        self:CallBackOK();
	    end );
	else
		local msg = require("MessageCommon/Msg/C2L/Player/RequestImmediateFinish").new();
	    msg:SetMessageId(C2L_Player.RequestImmediateFinish);
	    NetService:Instance():SendMessage(msg);
	end
end

function UIInternalAffairsImage:CallBackOK()
	UIService:Instance():ShowUI(UIType.RechargeUI)
	UIService:Instance():HideUI(UIType.UIInternalAffairsImage)
end




-------------------------交易----------------------------


-- 点击交易
function UIInternalAffairsImage:OnClickDealImage()
	if self:GetMarketCount() > 0 then
		self.TransactionaOpenObj.gameObject:SetActive(true)
		self.TransactionaOpenObjPanel.gameObject:SetActive(false);
	else
		self.TransactionaOpenObj.gameObject:SetActive(false)
		self.TransactionaOpenObjPanel.gameObject:SetActive(true);
	end
	if self.DealImage.isOn then
		self.RevenueBigFrameImage.gameObject:SetActive(false);
		self.TransactionalInterface.gameObject:SetActive(true);
		self:Trade();
		self:ResourceIsExceed()
	end
end

-- 点击税收
function UIInternalAffairsImage:OnClickRevenueImage()
	if self.RevenueImage.isOn then
		self.RevenueBigFrameImage.gameObject:SetActive(true);
		self.TransactionalInterface.gameObject:SetActive(false);
	end
end

function UIInternalAffairsImage:SetIsOnFalse()
	self.OneNextImage.isOn = false;
	self.TwoNextImage.isOn = false;
	self.ThreeNextImage.isOn = false;
	self.FourNextImage.isOn = false;
	self.OneNextImage1.isOn = false;
	self.TwoNextImage1.isOn = false;
	self.ThreeNextImage1.isOn = false;
	self.FourNextImage1.isOn = false;
	self:SetToggleToTrue()
	self:SetToggle()
end

function UIInternalAffairsImage:IsCanHoist()
	if self.OneNextImage.isOn == false and self.TwoNextImage.isOn == false and self.ThreeNextImage.isOn == false and self.FourNextImage.isOn == false then
		return true;
	end
	return false
end

function UIInternalAffairsImage:IsCanHoist1()
	if self.OneNextImage1.isOn == false and self.TwoNextImage1.isOn == false and self.ThreeNextImage1.isOn == false and self.FourNextImage1.isOn == false then
		return true;
	end
	return false
end

function UIInternalAffairsImage:OnClickNextBtn(obj)
	self:SetToggle()
	if obj == self.OneNextImage then
		if self.OneNextImage.isOn then
			self.ConsumeResource = self.number1.text
			self.left.gameObject:SetActive(true)
			self.resource.text = "木材"
			self:LeftText("待交易资源 木材")
			self.transactionType = CurrencyEnum.Wood
			self.left.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("timber1");
			if self.OneNextImage1.enabled == true then
				self:SetToggleImageActive(self.OneNextImage1)
			end
			self:ResourceIsExceed()			
		end
	elseif obj == self.TwoNextImage then
		if self.TwoNextImage.isOn then
			self.ConsumeResource = self.number2.text
			self.left.gameObject:SetActive(true)
			self.resource.text = "铁矿"
			self:LeftText("待交易资源 铁矿")
			self.transactionType = CurrencyEnum.Iron
			self.left.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("iron1");
			if self.TwoNextImage1.enabled == true then
				self:SetToggleImageActive(self.TwoNextImage1)
			end		
			self:ResourceIsExceed()
		end
	elseif obj == self.ThreeNextImage then
		if self.ThreeNextImage.isOn then
			self.ConsumeResource = self.number3.text
			self.left.gameObject:SetActive(true)
			self.resource.text = "石料"
			self:LeftText("待交易资源 石料")
			self.transactionType = CurrencyEnum.Stone
			self.left.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("stone1");
			if self.ThreeNextImage1.enabled == true then
				self:SetToggleImageActive(self.ThreeNextImage1)
			end		
			self:ResourceIsExceed()			
		end		
	elseif obj == self.FourNextImage then
		if self.FourNextImage.isOn then
			self.ConsumeResource = self.number4.text
			self.left.gameObject:SetActive(true)
			self.resource.text = "粮草"
			self:LeftText("待交易资源 粮草")
			self.transactionType = CurrencyEnum.Grain
			self.left.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("grain1");
			if self.FourNextImage1.enabled == true then
				self:SetToggleImageActive(self.FourNextImage1)
			end	
		end
	end
	if obj.isOn then
		self:ResourceIsExceed()
	end
end


function UIInternalAffairsImage:OnClickNext1Btn(obj)
	self:SetToggleToTrue()
	if obj == self.OneNextImage1 then
		if self.OneNextImage1.isOn then
			self.right.gameObject:SetActive(true)
			self.resource1.text = "木材"
			self:RightText("目标资源 木材")
			self.goaltransactionType = CurrencyEnum.Wood
			self.left.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("timber1");
			if self.OneNextImage.enabled == true then
				self:SetToggleImageActive(self.OneNextImage)
			end
		end
	elseif obj == self.TwoNextImage1 then
		if self.TwoNextImage1.isOn then
			self.right.gameObject:SetActive(true)
			self.resource1.text = "铁矿"
			self:RightText("目标资源 铁矿")
			self.goaltransactionType = CurrencyEnum.Iron
			self.left.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("iron1");
			if self.TwoNextImage.enabled == true then
				self:SetToggleImageActive(self.TwoNextImage)
			end			
		end
	elseif obj == self.ThreeNextImage1 then
		if self.ThreeNextImage1.isOn then
			self.right.gameObject:SetActive(true)
			self.resource1.text = "石料"
			self:RightText("目标资源 石料")
			self.goaltransactionType = CurrencyEnum.Stone
			self.left.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("stone1");
			if self.ThreeNextImage.enabled == true then
				self:SetToggleImageActive(self.ThreeNextImage)
			end
		end
	elseif obj == self.FourNextImage1 then
		if self.FourNextImage1.isOn then
			self.right.gameObject:SetActive(true)
			self.resource1.text = "粮草"
			self:RightText("目标资源 粮草")
			self.goaltransactionType = CurrencyEnum.Grain
			self.left.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("grain1");
			if self.FourNextImage.enabled == true then
				self:SetToggleImageActive(self.FourNextImage)
			end	
		end
	end
	self:SetSliderShow()
end


function UIInternalAffairsImage:ConfirmBtn()
    local paramT = { };
    paramT[1] = "是否确认将"..self.resource.text..self.quantity.text.."交易为"..self.resource1.text..self.quantity1.text.."";
    paramT[4] = true;
    UIService:Instance():ShowUI(UIType.MessageBox, paramT);
    MessageBox:Instance():RegisterOk( function()
        self:SendTransactionInfoMsg();
    end );
end

function UIInternalAffairsImage:SendTransactionInfoMsg()
	local msg = require("MessageCommon/Msg/C2L/DomesticAffairs/TransactionInfo").new();
    msg:SetMessageId(C2L_DomesticAffairs.TransactionInfo);
    msg.consumeResourceType = self.transactionType
    msg.addResourceType = self.goaltransactionType
    msg.consumeNum = self.quantity.text
    msg.addNum = self.quantity1.text
    NetService:Instance():SendMessage(msg);
end

function UIInternalAffairsImage:SetSliderShow()
	if self:IsCanHoist() == false and self:IsCanHoist1() == false and self.ConsumeResource ~= 0 then
		self.Slider.enabled = true
		self.sliderImage.gameObject:SetActive(false);
		self.sliderImage1.gameObject:SetActive(false);
	end	
end


--设置toggle是否可用
function UIInternalAffairsImage:SetToggleToTrue()
	if self.OneNextImage.enabled == false then
		self:SetImageActive(self.OneNextImage)
	end
	if self.TwoNextImage.enabled == false then
		self:SetImageActive(self.TwoNextImage)
	end
	if self.ThreeNextImage.enabled == false then
		self:SetImageActive(self.ThreeNextImage)
	end
	if self.FourNextImage.enabled == false then
		self:SetImageActive(self.FourNextImage)
	end
end

function UIInternalAffairsImage:SetImageActive(obj)
	local oneImage = obj.transform:Find("OneImage");
	if oneImage.gameObject.activeSelf == false then
		oneImage.gameObject:SetActive(true);
	end
	obj.enabled = true;
end

--设置toggle下图片是否显示
function UIInternalAffairsImage:SetToggleImageActive(obj)
	local oneImage = obj.transform:Find("OneImage");
		if oneImage.gameObject.activeSelf == true then
			oneImage.gameObject:SetActive(false);
		end
	obj.enabled = false;
end

function UIInternalAffairsImage:SetToggle()
	if self.OneNextImage1.enabled ==  false then
		self:SetImageActive(self.OneNextImage1)
	end
	if self.TwoNextImage1.enabled ==  false then
		self:SetImageActive(self.TwoNextImage1)
	end
	if self.ThreeNextImage1.enabled ==  false then
		self:SetImageActive(self.ThreeNextImage1)
	end
	if self.FourNextImage1.enabled ==  false then
		self:SetImageActive(self.FourNextImage1)
	end
end


function UIInternalAffairsImage:LeftText(str)
	self.curresourceText.gameObject:SetActive(false)
	self.resourceText1.text = str
	self.resourceText1.gameObject:SetActive(true);
end

function UIInternalAffairsImage:RightText(str)
	self.expendresourceText.gameObject:SetActive(false);
	self.resourceText2.text = str
	self.resourceText2.gameObject:SetActive(true);
end

-- slider
function UIInternalAffairsImage:OnSliderChanged()
	if self:IsCanHoist() == false and self:IsCanHoist1() == false and self.ConsumeResource ~= 0 then
		self.ButtonGray.gameObject:SetActive(false);
		self.ConfirmButton.gameObject:SetActive(true);
		if PlayerService:Instance():GetCurrencyVarCalcByKey(self.goaltransactionType):GetValue() + math.modf(self.Slider.value * self.ConsumeResource * ((self:GetMarketCount() + 3)/10)) < self:ExplosiveCartridgePrompt() then
			self.quantity.text = math.modf(self.Slider.value * self.ConsumeResource)
			self.quantity1.text = math.modf(self.Slider.value * self.ConsumeResource * ((self:GetMarketCount() + 3)/10))
		end
	end
end

function UIInternalAffairsImage:SetSliderToZero(  )
	self.Slider.value = 0
end

function UIInternalAffairsImage:Trade()
	self.Number.text = self:GetMarketCount() .."/".."3";     -- 集市数
	self.scale.text = "10"..":"..(self:GetMarketCount() + 3);     -- 交易比
	self.number1.text = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Wood):GetValue();   -- 木
	self.number2.text = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Iron):GetValue();   -- 铁
	self.number3.text = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Stone):GetValue();   -- 石
	self.number4.text = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Grain):GetValue();   -- 粮
end

-- 获取集市数
function UIInternalAffairsImage:GetMarketCount()
	local num = 0;
	local count = PlayerService:Instance():GetCityInfoCount()
	for i=1, count do
		local building = PlayerService:Instance():GetCityInfoByIndex(i)
		local ct = FacilityService:Instance():GetFacilitylevelByIndex(building.id,FacilityType.MarketHouse);
		if ct == 1 then
			num = num + 1;
		end
	end
	if num > 3 then
		num = 3;
	end
	return num;
end

function UIInternalAffairsImage:OnSliderUp()
	if self.Slider.value == 0 then
		self.ButtonGray.gameObject:SetActive(true);
		self.ConfirmButton.gameObject:SetActive(false);
	end

end
--右边image点击事件
function UIInternalAffairsImage:OnClickNextImage(obj)
	if self.OneNextImage1 == obj then
		if self.OneNextImage1.enabled == false then
			if self.transactionType == CurrencyEnum.Wood then
				UIService:Instance():ShowUI(UIType.UICueMessageBox,8015)
			elseif PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Wood):GetValue() > self:ExplosiveCartridgePrompt() then
				UIService:Instance():ShowUI(UIType.UICueMessageBox,8016)			
			end
		end
	elseif self.TwoNextImage1 == obj then
		if self.TwoNextImage1.enabled == false then
			if self.transactionType == CurrencyEnum.Iron then
				UIService:Instance():ShowUI(UIType.UICueMessageBox,8015)
			elseif PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Iron):GetValue() > self:ExplosiveCartridgePrompt() then
				UIService:Instance():ShowUI(UIType.UICueMessageBox,8016)
			end
		end

	elseif self.ThreeNextImage1 == obj  then
		if self.ThreeNextImage1.enabled == false then
			if self.transactionType == CurrencyEnum.Stone then
				UIService:Instance():ShowUI(UIType.UICueMessageBox,8015)
			elseif PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Stone):GetValue() > self:ExplosiveCartridgePrompt() then
				UIService:Instance():ShowUI(UIType.UICueMessageBox,8016)
			end
		end
	elseif self.FourNextImage1 == obj then
		if self.FourNextImage1.enabled == false then
			if self.transactionType == CurrencyEnum.Grain then
				UIService:Instance():ShowUI(UIType.UICueMessageBox,8015)
			elseif PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Grain):GetValue() > self:ExplosiveCartridgePrompt() then
				UIService:Instance():ShowUI(UIType.UICueMessageBox,8016)
			end
		end
	end

end

--左边image点击事件
function UIInternalAffairsImage:OnClickNextImageBtn(obj)
	if self.OneNextImage == obj then
		if self.OneNextImage.enabled == false then
			if self.goaltransactionType == CurrencyEnum.Wood then
				UIService:Instance():ShowUI(UIType.UICueMessageBox,8015)
			elseif PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Wood):GetValue() > self:ExplosiveCartridgePrompt() then
				UIService:Instance():ShowUI(UIType.UICueMessageBox,8016)			
			end
		end
	elseif self.TwoNextImage == obj then
		if self.TwoNextImage.enabled == false then
			if self.goaltransactionType == CurrencyEnum.Iron then
				UIService:Instance():ShowUI(UIType.UICueMessageBox,8015)
			elseif PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Iron):GetValue() > self:ExplosiveCartridgePrompt() then
				UIService:Instance():ShowUI(UIType.UICueMessageBox,8016)
			end
		end

	elseif self.ThreeNextImage == obj  then
		if self.ThreeNextImage.enabled == false then
			if self.goaltransactionType == CurrencyEnum.Stone then
				UIService:Instance():ShowUI(UIType.UICueMessageBox,8015)
			elseif PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Stone):GetValue() > self:ExplosiveCartridgePrompt() then
				UIService:Instance():ShowUI(UIType.UICueMessageBox,8016)
			end
		end
	elseif self.FourNextImage == obj then
		if self.FourNextImage.enabled == false then
			if self.goaltransactionType == CurrencyEnum.Grain then
				UIService:Instance():ShowUI(UIType.UICueMessageBox,8015)
			elseif PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Grain):GetValue() > self:ExplosiveCartridgePrompt() then
				UIService:Instance():ShowUI(UIType.UICueMessageBox,8016)
			end
		end
	end
end


function UIInternalAffairsImage:ResourceIsExceed()
	local count = self:ExplosiveCartridgePrompt()
	if PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Wood):GetValue() > self:ExplosiveCartridgePrompt() then
		if self.OneNextImage1.enabled == true then
			self:SetToggleImageActive(self.OneNextImage1)
		end
	end
	if PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Iron):GetValue() > self:ExplosiveCartridgePrompt() then
		if self.TwoNextImage1.enabled == true then
			self:SetToggleImageActive(self.TwoNextImage1)
		end
	end
	if PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Stone):GetValue() > self:ExplosiveCartridgePrompt() then
		if self.ThreeNextImage1.enabled == true then
			self:SetToggleImageActive(self.ThreeNextImage1)
		end
	end
	if PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Grain):GetValue() > self:ExplosiveCartridgePrompt() then
		if self.FourNextImage1.enabled == true then
			self:SetToggleImageActive(self.FourNextImage1)
		end
	end

end

function UIInternalAffairsImage:ExplosiveCartridgePrompt()
	local ResourcesMax = PlayerService:Instance():GetInitResourceMax();
	local cityList = PlayerService:Instance():GetPlayerCityList();
    for i = 1, #cityList do
        local city = BuildingService:Instance():GetBuildingByTiledId(cityList[i].tiledId);
        if city ~= nil then
            ResourcesMax = ResourcesMax + city:GetCityPropertyByFacilityProperty(FacilityProperty.ResourcesMax);
        end
    end
    return ResourcesMax
end


-- 提示框
function UIInternalAffairsImage:ClickBtnGray()
	if self:IsCanHoist() == true then
		UIService:Instance():ShowUI(UIType.UICueMessageBox,8012)
	elseif self:IsCanHoist1() == true then
		UIService:Instance():ShowUI(UIType.UICueMessageBox,8013)
	elseif self.Slider.value == 0 then
		UIService:Instance():ShowUI(UIType.UICueMessageBox,8014)
	end
end

-- 消息回来执行
function UIInternalAffairsImage:MsgReturn()
	local ResourceType = nil;
	self:Trade();
	-- self:SetToggleToTrue()
	-- self:SetToggle()
	if self.goaltransactionType == CurrencyEnum.Wood then
		ResourceType = "木材"
	elseif self.goaltransactionType == CurrencyEnum.Iron then
		ResourceType = "铁矿"
	elseif self.goaltransactionType == CurrencyEnum.Stone then
		ResourceType = "石料"
	elseif self.goaltransactionType == CurrencyEnum.Grain then
		ResourceType = "粮草"				
	end
	local param = {};
    param.name = ResourceType
    param.count = self.quantity1.text
    UIService:Instance():ShowUI(UIType.UIGetItemManage, param);
    self:SetSliderToZero();
    self.quantity.text = 0
	self.quantity1.text = 0
    --self:ResourceIsExceed()
end


-- 获取仓库最大值
function UIInternalAffairsImage:GetMaxResource()
	 local ResourcesMax = PlayerService:Instance():GetInitResourceMax();
	 local cityList = PlayerService:Instance():GetPlayerCityList();
	 for i = 1, #cityList do
        local city = BuildingService:Instance():GetBuildingByTiledId(cityList[i].tiledId);
        if city ~= nil then
            ResourcesMax = ResourcesMax + city:GetCityPropertyByFacilityProperty(FacilityProperty.ResourcesMax);
        end
     end
     return ResourcesMax
end

return UIInternalAffairsImage