--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");

local UIBase = require("Game/UI/UIBase");
local UILoginAct = class("UILoginAct", UIBase);

-- 构造函数
function UILoginAct:ctor()
    UILoginAct.super.ctor(self);
    self._actContainer = nil;
    self._allItemsClassList = {};
end

-- 初始化的时候
function UILoginAct:OnInit()
    for index = 1, 28 do
        local uiLoginActItem = require("Game/Activity/Login/UILoginActItem").new();
        GameResFactory.Instance():GetUIPrefab("UIPrefab/UILoginActItem", self._actContainer, uiLoginActItem, function(go)
            uiLoginActItem.gameObject.name = "UILoginActItem" .. index;
            self._allItemsClassList[index] = uiLoginActItem;
            uiLoginActItem:Init();
        end );
    end
end

-- 控件查找
function UILoginAct:DoDataExchange(args)
    self._actContainer = self:RegisterController(UnityEngine.RectTransform, "Container/ScrollView/Grid");
end
-- 控件事件添加

function UILoginAct:DoEventAdd()

end

-- 注册所有的通知
function UILoginAct:RegisterAllNotice()
    self:RegisterNotice(L2C_Player.LoginGift, self.UpdateUIPanel);
end

-- 初始化界面
function UILoginAct:UpdateUIPanel()
    local allDataList = LoginActService:Instance():GetCurAllDataList();
    if allDataList == nil then
        UIService:Instance():HideUI(UIType.UIActivity);
        return;
    end

    -- 先把item都置成false？
    for i,v in pairs(allDataList) do
        if self._allItemsClassList[i] == nil then
            self:CreateUIItem(i, v);
        else
            if self._allItemsClassList[i].gameObject.activeSelf == false then
                self._allItemsClassList[i].gameObject:SetActive(true);
            end
            self._allItemsClassList[i]:UpdateUI(v);
        end
    end

    local tempX = self._actContainer.localPosition.x;
    self._actContainer.localPosition = Vector3.New(tempX, 0, 0);

    local canGet = LoginActService:Instance():GetIsCanGet();
    local curDay = LoginActService:Instance():GetCurDay();
    if canGet == nil or curDay == nil or allDataList[curDay] == nil then
        return;
    end

    if canGet == true then
        UIService:Instance():ShowUI(UIType.UILoginActItemScan, allDataList[curDay]);
    else
        UIService:Instance():HideUI(UIType.UILoginActItemScan);
    end
end

-- 创建item
function UILoginAct:CreateUIItem(index, tableData)
    local uiLoginActItem = require("Game/Activity/Login/UILoginActItem").new();
    GameResFactory.Instance():GetUIPrefab("UIPrefab/UILoginActItem", self._actContainer, uiLoginActItem, function(go)
        uiLoginActItem.gameObject.name = "UILoginActItem" .. index;
        self._allItemsClassList[index] = uiLoginActItem;
        uiLoginActItem:Init();
        uiLoginActItem:UpdateUI(tableData);
    end );
end

return UILoginAct;
--endregion
