--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local UIBase = require("Game/UI/UIBase");
local UIGetItem = class("UIGetItem", UIBase);

--构造函数
function UIGetItem:ctor()
    UIGetItem.super.ctor(self);
    self._parent = nil;
    self._strText = nil;
end

--注册控件
function UIGetItem:DoDataExchange()
    self._strText = self:RegisterController(UnityEngine.UI.Text, "str");
end

function UIGetItem:ShowItem(parent, name, count)
    self._parent = parent;
    self._strText.text = "获得" .. name .. " " .. count;
    self:PlayAnim();
end

function UIGetItem:PlayAnim()
    self.transform.localPosition = Vector3.New(0, 0, 0);
    self.transform.localScale = Vector3.New(1, 1, 1);
    self.transform:SetAsLastSibling();
    if self.gameObject.activeSelf == false then
        self.gameObject:SetActive(true);
    end

    self.transform:DOScale( Vector3.New(0.8, 0.8, 0.8), 1)
    local mLeanTween =self.transform:DOLocalMove(Vector3.New(0, 50, 0), 1)
    mLeanTween:OnComplete(self,function()
        self:RecoverySelf();
    end )
end

function UIGetItem:RecoverySelf()
    if self.gameObject.activeSelf == true then
        self.gameObject:SetActive(false);
    end

    if self._parent ~= nil then
        self._parent:RecoveryUIItem(self);
    end
end

return UIGetItem;

--endregion
