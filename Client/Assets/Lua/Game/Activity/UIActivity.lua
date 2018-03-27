--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local UIService = require("Game/UI/UIService");
local UIType = require("Game/UI/UIType");
local ActivityType = require("Game/Activity/ActivityType");

local UIBase = require("Game/UI/UIBase");
local UIActivity = class("UIActivity", UIBase);

-- 构造函数
function UIActivity:ctor()
    UIActivity.super.ctor(self);
    self._closeBtn = nil;
    self._actContainer = nil;
    self._blackBgImage = nil;
    self._allActPanelClassList = {};
end

-- 初始化的时候
function UIActivity:OnInit()
    self:PreLoadPrefab(ActivityType.LoginAct, "Login/UILoginAct", "UILoginAct");

end

-- 预加载逻辑
function UIActivity:PreLoadPrefab(actType, classPathName, prefabName)
    local actClass = require("Game/Activity/" .. classPathName).new();
    GameResFactory.Instance():GetUIPrefab("UIPrefab/" .. prefabName, self._actContainer, actClass, function(go)
        self._allActPanelClassList[actType] = actClass;
        actClass:Init();
    end );
end

-- 控件查找
function UIActivity:DoDataExchange(args)
    self._actContainer = self:RegisterController(UnityEngine.RectTransform, "Container/Container");
    self._blackBgImage = self:RegisterController(UnityEngine.UI.Image, "blackBG");
    self._closeBtn = self:RegisterController(UnityEngine.UI.Button, "Container/closeBtn");
end

-- 控件事件添加
function UIActivity:DoEventAdd()
    self:AddListener(self._closeBtn, self.OnCloseBtn);
    self:AddOnClick(self._blackBgImage, self.OnCloseBtn);
end

-- 当界面显示的时候调用
function UIActivity:OnShow(actType)
	--更新活动界面显示隐藏 更新左侧toggle状态
    if actType == ActivityType.LoginAct then
        self:ShowActPanel(ActivityType.LoginAct, "Login/UILoginAct", "UILoginAct");
    else
        
    end
end

-- 创建不同的活动界面
function UIActivity:ShowActPanel(actType, classPathName, prefabName)
    if self._allActPanelClassList[actType] == nil then
        local actClass = require("Game/Activity/" .. classPathName).new();
        GameResFactory.Instance():GetUIPrefab("UIPrefab/" .. prefabName, self._actContainer, actClass, function(go)
            self._allActPanelClassList[actType] = actClass;
            actClass:Init();
            actClass:UpdateUIPanel();
        end );
    else
        if self._allActPanelClassList[actType].gameObject.activeSelf == false then
            self._allActPanelClassList[actType].gameObject:SetActive(true);
        end
        self._allActPanelClassList[actType]:UpdateUIPanel();
    end
end

-- closeBtn
function UIActivity:OnCloseBtn()
    UIService:Instance():HideUI(UIType.UIActivity);
end

return UIActivity;

--endregion