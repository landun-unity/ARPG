--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local UIBase = require("Game/UI/UIBase");
local UITaskItem = class("UITaskItem", UIBase);

require("Game/Table/model/DataQuest")

-- 构造函数
function UITaskItem:ctor()
    UITaskItem.super.ctor(self);
    self._tableId = 0;
    self._choose = nil;
    self._name = nil;
    self._over = nil;
    self._parent = nil;
end

-- 控件查找
function UITaskItem:DoDataExchange(args)
    self._choose = self:RegisterController(UnityEngine.UI.Image, "choose");
    self._name = self:RegisterController(UnityEngine.UI.Text, "name");
    self._over = self:RegisterController(UnityEngine.Transform, "over");
end

-- 控件事件添加
function UITaskItem:DoEventAdd()
    self:AddListener(self.transform:GetComponent(typeof(UnityEngine.UI.Button)),self.OnClickBtn);
end

-- 初始化界面
function UITaskItem:InitData(taskData, parent)
    tableData = DataQuest[taskData:GetTableId()];
    if tableData == nil then
        return;
    end
    self._tableId = taskData:GetTableId();
    self._name.text = tableData.QuestName;
    self._over.gameObject:SetActive(taskData:GetRewardState());
    self._parent = parent;
end

-- clickBtn
function UITaskItem:OnClickBtn()
    if self._parent == nil or self._tableId == 0 then
        return;
    end
    self._parent:ChooseOneItem(self._tableId);
end

function UITaskItem:ChangeChooseState(para)
    if self._choose ~= nil then
        self._choose.gameObject:SetActive(para);
    end
end

function UITaskItem:GetTableId()
    return self._tableId;
end

return UITaskItem;

--endregion
