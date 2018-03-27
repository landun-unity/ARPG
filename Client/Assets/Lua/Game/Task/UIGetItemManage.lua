--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local UIBase = require("Game/UI/UIBase");
local UIGetItemManage = class("UIGetItemManage", UIBase);

--构造函数
function UIGetItemManage:ctor()
    UIGetItemManage.super.ctor(self);
    self._container = nil;
    self._offsetTime = 0.5;
    self._lastSyncTime = 0;
    self._needShowItem = Queue.new();
    self._uiItemQueue = Queue.new();
end

--注册控件
function UIGetItemManage:DoDataExchange()
    self._container = self:RegisterController(UnityEngine.RectTransform, "Container");
end

function UIGetItemManage:OnShow(param)
    if param ~= nil and param.name ~= nil and param.count ~= nil then
        self._needShowItem:Push(param);
    end
end

function UIGetItemManage:_OnHeartBeat()
    if self._needShowItem:Count() > 0 then
        if UnityEngine.Time.time - self._lastSyncTime > self._offsetTime then
            self._lastSyncTime = UnityEngine.Time.time;
            local item = self._needShowItem:Pop();
            if item ~= nil and item.name ~= nil and item.count ~= nil then
                self:LoadItem(item.name, item.count);
            end
        end
    end
end

function UIGetItemManage:LoadItem(name, count)
    if self._uiItemQueue:Count() ~= 0 then
        local uiItem = self._uiItemQueue:Pop();
        uiItem:ShowItem(self, name, count);
        return;
    end

    local uiItem = require("Game/Task/UIGetItem").new();
    GameResFactory.Instance():GetUIPrefab("UIPrefab/UIGetItem", self._container, uiItem,
        function (go)
            uiItem:Init();
            uiItem:ShowItem(self, name, count);
        end 
    );
end

function UIGetItemManage:RecoveryUIItem(uiItem)
    self._uiItemQueue:Push(uiItem);
end

return UIGetItemManage;

--endregion
