--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");

local UIBase = require("Game/UI/UIBase");
local UILoginActItemScan = class("UILoginActItemScan", UIBase);

-- 构造函数
function UILoginActItemScan:ctor()
    UILoginActItemScan.super.ctor(self);
    self._titleText = nil;
    self._sureBtn = nil;
    self._blackBgImage = nil;

    self._gift1 = nil;
    self._gift2 = nil;
    self._gift3 = nil;
    self._gift4 = nil;
    self._gift5 = nil;

    self._curDayData = nil;
end

-- 控件查找
function UILoginActItemScan:DoDataExchange(args)
    self._titleText = self:RegisterController(UnityEngine.UI.Text, "Container/Background/Title");
    self._sureBtn = self:RegisterController(UnityEngine.UI.Button, "Container/sureBtn");
    self._blackBgImage = self:RegisterController(UnityEngine.UI.Image, "blackBG");

    self._gift1 = self:RegisterController(UnityEngine.RectTransform, "Container/Items/ScrollView/Grid/GiftItem1");
    self._gift2 = self:RegisterController(UnityEngine.RectTransform, "Container/Items/ScrollView/Grid/GiftItem2");
    self._gift3 = self:RegisterController(UnityEngine.RectTransform, "Container/Items/ScrollView/Grid/GiftItem3");
    self._gift4 = self:RegisterController(UnityEngine.RectTransform, "Container/Items/ScrollView/Grid/GiftItem4");
    self._gift5 = self:RegisterController(UnityEngine.RectTransform, "Container/Items/ScrollView/Grid/GiftItem5");
end

-- 控件事件添加
function UILoginActItemScan:DoEventAdd()
    self:AddListener(self._sureBtn, self.OnSureBtnClick);
    self:AddOnClick(self._blackBgImage, self.OnSureBtnClick);

    self:AddListener(self._gift1:GetComponent(typeof(UnityEngine.UI.Button)), self.OnGift1Click);
    self:AddListener(self._gift2:GetComponent(typeof(UnityEngine.UI.Button)), self.OnGift2Click);
    self:AddListener(self._gift3:GetComponent(typeof(UnityEngine.UI.Button)), self.OnGift3Click);
    self:AddListener(self._gift4:GetComponent(typeof(UnityEngine.UI.Button)), self.OnGift4Click);
    self:AddListener(self._gift5:GetComponent(typeof(UnityEngine.UI.Button)), self.OnGift5Click);
end

-- 当界面显示的时候调用
function UILoginActItemScan:OnShow(data)
    self._curDayData = data;
    if self._curDayData == nil then
        return;
    end

    self._titleText.text = "登录第" .. self._curDayData.Day .. "天奖励";
    self:InitItem(data.Gift1Type, self._gift1, data.Gift1Icon, data.Gift1Name);
    self:InitItem(data.Gift2Type, self._gift2, data.Gift2Icon, data.Gift2Name);
    self:InitItem(data.Gift3Type, self._gift3, data.Gift3Icon, data.Gift3Name);
    self:InitItem(data.Gift4Type, self._gift4, data.Gift4Icon, data.Gift4Name);
    self:InitItem(data.Gift5Type, self._gift5, data.Gift5Icon, data.Gift5Name);
end

function UILoginActItemScan:InitItem(giftType, itemTrans, icon, name)
    if giftType == 0 then
        itemTrans.gameObject:SetActive(false);
    else
        itemTrans.gameObject:SetActive(true);
        itemTrans:FindChild("name"):GetComponent(typeof(UnityEngine.UI.Text)).text = name;
        itemTrans:FindChild("icon"):GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(icon);
    end
end

function UILoginActItemScan:OnSureBtnClick()
    if self._curDayData == nil then
        return;
    end

    local canGet = LoginActService:Instance():GetIsCanGet();
    local curDay = LoginActService:Instance():GetCurDay();

    if curDay == nil then
        return;
    end

    if self._curDayData.Day == curDay and canGet == true then
        LoginActService:Instance():GetLoginGiftRequest();
    else
        UIService:Instance():HideUI(UIType.UILoginActItemScan);
    end
end

function UILoginActItemScan:OnGift1Click()
    if self._curDayData == nil or self._curDayData.Gift1Type == 0 then
        return;
    end
    --print("点击第一个礼物");
end

function UILoginActItemScan:OnGift2Click()
    if self._curDayData == nil or self._curDayData.Gift2Type == 0 then
        return;
    end
    --print("点击第二个礼物");
end

function UILoginActItemScan:OnGift3Click()
    if self._curDayData == nil or self._curDayData.Gift3Type == 0 then
        return;
    end
    --print("点击第三个礼物");
end

function UILoginActItemScan:OnGift4Click()
    if self._curDayData == nil or self._curDayData.Gift4Type == 0 then
        return;
    end
    --print("点击第四个礼物");
end

function UILoginActItemScan:OnGift5Click()
    if self._curDayData == nil or self._curDayData.Gift5Type == 0 then
        return;
    end
    --print("点击第五个礼物");
end

return UILoginActItemScan;

--endregion
