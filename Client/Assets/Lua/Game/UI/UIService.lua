
-- Anchor:Dr
-- Date 16/9/10;
--
local GameService = require("FrameWork/Game/GameService");

local UIHandler = require("Game/UI/UIHandler");
local UIManager = require("Game/UI/UIManager");
UIService = class("UIService", GameService);

function UIService:ctor()
    UIService._instance = self;
    UIService.super.ctor(self, UIManager.new(), UIHandler.new());
    self.allOpenMap = { }
end

-- 单例
function UIService:Instance()
    return UIService._instance;
end

function UIService:LoadCommonBlackBg()
    self._logic:LoadCommonBlackBg()
end


function UIService:ClearcommonBlackBg()
    self._logic:ClearcommonBlackBg()
end


-- 清空数据
function UIService:Clear()
    self._logic:ctor()
end

-- showUi
function UIService:ShowUI(_type, param, callBack)
    CommonService:Instance():Play("Audio/Point")
    self.allOpenMap[_type] = true
    return self._logic:ShowUI(_type, param, callBack);
end

function UIService:SetIsLogin(args)
    self._logic:SetIslogin(args)
end

function UIService:GetIsLogin()
    return self._logic:GetIsLogin()
end

function UIService:AddUI(_type, uiBase)
    self._logic:AddUI(_type, uiBase);
end

function UIService:RemoveUI(_type)
    self._logic:RemoveUI(_type);
end

-- InitUI
function UIService:InitUI(_type)
    return self._logic:InitUI(_type);
end

-- showUi
function UIService:HideUI(_type, param, call)
    if self.allOpenMap[_type] ~= nil then
        self.allOpenMap[_type] = false
    end
    return self._logic:HideUI(_type, param, call);
end


-- 获取Canvas
function UIService:GetUIRootCanvas()
    return self._logic:GetUIRootCanvas();
end

-- 获取界面baseClass
function UIService:GetUIClass(_type)
    return self._logic:GetUIClass(_type);
end

-- 界面是否打开
function UIService:GetOpenedUI(_type)
    if self:GetUIClass(_type) == nil then
        return false;
    else
        if self.allOpenMap[_type] == nil then
            return false
        else
            return self.allOpenMap[_type]
        end
    end
    return false;
end

-- 初始化配置
function UIService:InitConfig()
    self._logic:InitConfig();
end

-- 初始化配置
function UIService:Init()
    self._logic:Init();
end

function UIService:AddClickUI(clickUI)
    self._logic:AddClickUI(clickUI);
end

-- 退出时清空所有点击UI层
function UIService:ClearClickUI()
    self._logic:ClearClickUI()
end

function UIService:GetClickUI(index)
    return self._logic:GetClickUI(index);
end

function UIService:GetClickUICount()
    return self._logic:GetClickUICount()
end

-- 主城标记板
function UIService:AddMainUI(clickUI)
    return self._logic:AddMainUI(clickUI);
end

function UIService:GetMainUI(index)
    return self._logic:GetMainUI(index);
end

function UIService:GetMainUICount()
    return self._logic:GetMainUICount();
end

function UIService:GetUpUI(index)
    return self._logic:GetUpUI(index)
end

function UIService:IsMarked(tiled)
    return self._logic:IsMarked(tiled)
end

function UIService:AddFortImage(obj)
    return self._logic:AddFortImage(obj)
end

function UIService:HideFortImage()
    return self._logic:HideFortImage()
end

function UIService:ShowFortImage()
    return self._logic:ShowFortImage()
end

function UIService:Clear()
    self._logic:Clear()
end


return UIService;

-- endregion
