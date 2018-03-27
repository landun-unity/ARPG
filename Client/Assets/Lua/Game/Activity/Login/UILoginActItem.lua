--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");

local UIBase = require("Game/UI/UIBase");
local UILoginActItem = class("UILoginActItem", UIBase);

-- 构造函数
function UILoginActItem:ctor()
    UILoginActItem.super.ctor(self);
    self._icon = nil;
    self._num = nil;
    self._haveGet = nil;
    self._thisBtn = nil;
    self._data = nil;
end

-- 控件查找
function UILoginActItem:DoDataExchange(args)
    self._icon = self:RegisterController(UnityEngine.UI.Image, "icon");
    self._num = self:RegisterController(UnityEngine.UI.Text, "num");
    self._haveGet = self:RegisterController(UnityEngine.UI.Image, "haveGet");
end

-- 控件事件添加
function UILoginActItem:DoEventAdd()
    self:AddListener(self.transform:GetComponent(typeof(UnityEngine.UI.Button)),self.OnClickBtn);
end

-- 初始化界面
function UILoginActItem:UpdateUI(para)
    self._data = para;

    if para == nil then
        return;
    end

    self._num.text = para.Day;
    self._icon.sprite = GameResFactory.Instance():GetResSprite(para.Gift1Icon);
    local curDay = LoginActService:Instance():GetCurDay();
    local canGet = LoginActService:Instance():GetIsCanGet();
    if para.Day < curDay or (para.Day == curDay and canGet == false) then
        self._haveGet.transform.gameObject:SetActive(true);  
    else
        self._haveGet.transform.gameObject:SetActive(false); 
    end
end

-- clickBtn
function UILoginActItem:OnClickBtn()
    UIService:Instance():ShowUI(UIType.UILoginActItemScan, self._data);
end

return UILoginActItem;

--endregion
