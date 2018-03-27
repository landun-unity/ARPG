--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");
local TaskJumpType = require("Game/Task/TaskJumpType");
local TaskRewardType = require("Game/Task/TaskRewardType");
local CurrencyEnum = require("Game/Player/CurrencyEnum");

local UIBase = require("Game/UI/UIBase");
local UITask = class("UITask", UIBase);

require("Game/Table/model/DataItem")
require("Game/Table/model/DataSkill")
require("Game/Table/model/DataHero")
require("Game/Table/model/DataCardLoot")
require("Game/Table/model/DataQuest")

-- 构造函数
function UITask:ctor()
    UITask.super.ctor(self);
    self._backBg = nil;
    self._closeBtn = nil;
    self._taskParent = nil;
    self._taskTitle = nil;
    self._targetTitle = nil;
    -- 右侧具体任务内容
    self._detailContent = nil;
    self._detailTitle = nil;
    self._detailTarget = nil;
    self._detailDes = nil;
    self._rewardTable = {}
    self._gotoBtn = nil;
    self._getBtn = nil;
    self._buildingText = nil;
    -- 所有已创建的item的类 包括已经隐藏的 从上到下key值依次为1，2，3。。。
    self._allTaskItemsClass = {};
    -- 普通任务的数量
    self._normalTaskCount = 0;
    -- 战略目标的数量
    self._targetTaskCount = 0;
    -- 每个任务item之间的间隔
    self._taskItemGap = 5;
    -- 任务标题的y值
    self._taskTitleYPosition = 0;
    -- 标题的高度
    self._titleHeight = 0;
    -- 目标标题的高度
    self._targetHeight = 0;
    -- 当前选中的task
    self._curTask = nil;
    -- 当前选中的task表数据
    self._curTableData = nil;
    -- 主城id
    self._mainCityID = nil;
end

--初始化界面 预加载预设
function UITask:OnInit()
    for index = 1, 10 do
        local uiTaskItem = require("Game/Task/UITaskItem").new();
        GameResFactory.Instance():GetUIPrefab("UIPrefab/UITaskItem", self._taskParent, uiTaskItem, function(go)
            uiTaskItem.gameObject.name = "UITaskItem" .. index;
            self._allTaskItemsClass[index] = uiTaskItem;
            uiTaskItem:Init();
        end );
    end
end

-- 控件查找
function UITask:DoDataExchange(args)
    self._backBg = self:RegisterController(UnityEngine.UI.Image, "blackBG");
    self._closeBtn = self:RegisterController(UnityEngine.UI.Button, "Content/closeBtn");
    self._taskParent = self:RegisterController(UnityEngine.RectTransform, "Content/taskList/ScrollRect/Content");
    self._taskTitle = self:RegisterController(UnityEngine.RectTransform, "Content/taskList/ScrollRect/Content/taskTitle");
    self._targetTitle = self:RegisterController(UnityEngine.RectTransform, "Content/taskList/ScrollRect/Content/targetTitle");
    self._detailContent = self:RegisterController(UnityEngine.RectTransform, "Content/DetailContent");
    self._detailTitle = self:RegisterController(UnityEngine.UI.Text, "Content/DetailContent/title");
    self._detailTarget = self:RegisterController(UnityEngine.UI.Text, "Content/DetailContent/target");
    self._detailDes = self:RegisterController(UnityEngine.UI.Text, "Content/DetailContent/des");
    for i = 1, 6 do
        self._rewardTable[i] = self:RegisterController(UnityEngine.RectTransform, "Content/DetailContent/rewardList/reward" .. i);
    end
    self._gotoBtn = self:RegisterController(UnityEngine.UI.Button, "Content/DetailContent/gotoBtn");
    self._getBtn = self:RegisterController(UnityEngine.UI.Button, "Content/DetailContent/getBtn");
    self._buildingText = self:RegisterController(UnityEngine.UI.Text, "Content/DetailContent/building");
end

-- 控件事件添加
function UITask:DoEventAdd()
    self:AddOnClick(self._backBg, self.OnCloseBtn);
    self:AddListener(self._closeBtn, self.OnCloseBtn);
    self:AddListener(self._gotoBtn, self.OnGoToBtn);
    self:AddListener(self._getBtn, self.OnGetBtn);
end

-- 注册所有的通知
function UITask:RegisterAllNotice()
    self:RegisterNotice(L2C_Task.OpenTaskListRespond, self.InitAllTask);
    self:RegisterNotice(L2C_Task.SyncSingleTask, self.InitAllTask);
    self:RegisterNotice(L2C_Task.TaskAwardRespond, self.InitAllTask);
end

-- 当界面显示的时候调用
function UITask:OnShow(param)
    local mainCityTiledId = PlayerService:Instance():GetMainCityTiledId();
    self._mainCityID = BuildingService:Instance():GetBuildingByTiledId(mainCityTiledId)._id;
	self._taskTitleYPosition = self._taskTitle.localPosition.y;
    self._titleHeight = self._taskTitle.rect.height;
    self._targetHeight = self._targetTitle.rect.height;
    self:InitAllTask();
end

-- 初始化所有任务
function UITask:InitAllTask()
    if self.gameObject.activeSelf == false then
        return;
    end

    self._normalTaskCount, self._targetTaskCount = TaskService:Instance():GetAllDataCount();
    if #self._allTaskItemsClass > self._normalTaskCount + self._targetTaskCount then
        for i = self._normalTaskCount + self._targetTaskCount + 1, #self._allTaskItemsClass do
            if self._allTaskItemsClass[i].gameObject ~= nil and self._allTaskItemsClass[i].gameObject.activeSelf == true then
                self._allTaskItemsClass[i].gameObject:SetActive(false);
            end
        end
    end

    if self._normalTaskCount + self._targetTaskCount > 0 then
        if self._detailContent.gameObject.activeSelf == false then
            self._detailContent.gameObject:SetActive(true);
        end

        for i = 1, self._normalTaskCount + self._targetTaskCount do
            if self._allTaskItemsClass[i] == nil then
                self:CreateTaskItem(i);
            else
                self:InitUITaskItem(i);
            end
        end
    else
        if self._detailContent.gameObject.activeSelf == true then
            self._detailContent.gameObject:SetActive(false);
        end
    end
end

-- 创建任务item
function UITask:CreateTaskItem(index)
    local uiTaskItem = require("Game/Task/UITaskItem").new();
    GameResFactory.Instance():GetUIPrefab("UIPrefab/UITaskItem", self._taskParent, uiTaskItem, function(go)
        uiTaskItem.gameObject.name = "UITaskItem" .. index;
        self._allTaskItemsClass[index] = uiTaskItem;
        uiTaskItem:Init();
        self:InitUITaskItem(index)
    end );
end

-- 初始化item
function UITask:InitUITaskItem(index)
    if self._allTaskItemsClass[index] == nil or self._allTaskItemsClass[index].gameObject == nil then
        return;
    end

    local data = TaskService:Instance():GetTaskByIndex(index);
    if data == nil then
        return;
    end

    if self._allTaskItemsClass[index].gameObject.activeSelf == false then
        self._allTaskItemsClass[index].gameObject:SetActive(true);
    end
    self._allTaskItemsClass[index]:InitData(data, self);

    if index == self._normalTaskCount + self._targetTaskCount then
        self:CalcAllItemsPosition();
        local firstTask = TaskService:Instance():GetFirstOverTask();
        local firstIsTarget = false;
        if firstTask ~= nil and firstTask:GetIsTarget() == true then
            firstIsTarget = true;
        end
        if firstTask == nil then
            firstTask = TaskService:Instance():GetTaskByIndex(1);
        end
        if firstTask ~= nil then
            self:ChooseOneItem(firstTask:GetTableId());
        end
        if firstIsTarget == true then
            self:UpdateContentPos();
        end
    end
end

-- 定位的任务不是最上面的任务时 更改content位置
function UITask:UpdateContentPos()
    local heightOffset = self._taskParent.parent.rect.height / 2;
    local parentX = self._taskParent.localPosition.x;
    local oneItemHeight = 0;
    if self._allTaskItemsClass[1] ~= nil and self._allTaskItemsClass[1].transform ~= nil then
        oneItemHeight = self._allTaskItemsClass[1].transform:GetComponent(typeof(UnityEngine.RectTransform)).rect.height;
    end
    local parentY = self._titleHeight + self._normalTaskCount * oneItemHeight + self._taskItemGap * self._normalTaskCount;
    self._taskParent.localPosition = Vector3.New(parentX, parentY + heightOffset, 0);
end

-- 计算所有item的位置，title的位置和content的高
function UITask:CalcAllItemsPosition()
    for i = 1, self._normalTaskCount do
        self:CalcOneItemPosition(i, false);
    end
    if self._targetTaskCount ~= 0 then
        for i = self._normalTaskCount + 1, self._normalTaskCount + self._targetTaskCount do
            self:CalcOneItemPosition(i, true);
        end
    end

    if self._allTaskItemsClass[1] == nil or self._allTaskItemsClass[1].transform == nil then
        return;
    end
    local oneItemHeight = self._allTaskItemsClass[1].transform:GetComponent(typeof(UnityEngine.RectTransform)).rect.height;

    local contentWidth = self._taskParent.rect.width;
    local contentHeight = self._titleHeight + self._targetHeight + (oneItemHeight * (self._normalTaskCount + self._targetTaskCount)) + (self._taskItemGap * (self._normalTaskCount + self._targetTaskCount + 3));
    self._taskParent.sizeDelta = Vector2.New(contentWidth, contentHeight);
    local parentX = self._taskParent.localPosition.x;
    self._taskParent.localPosition = Vector3.New(parentX, 0, 0);
    
    local newX = self._targetTitle.localPosition.x;
    local newY = self._taskTitleYPosition - (self._titleHeight * 0.5) - (self._targetHeight * 0.5) - (oneItemHeight * self._normalTaskCount) - (self._taskItemGap * (self._normalTaskCount + 1));
    self._targetTitle.localPosition = Vector3.New(newX, newY, 0);
end

-- 根据排序计算一个item的位置
function UITask:CalcOneItemPosition(index, isTarget)
    if self._allTaskItemsClass[index] == nil or self._allTaskItemsClass[index].transform == nil then
        return;
    end
    local oneItemTrans = self._allTaskItemsClass[index].transform;
    local oneItemHeight = oneItemTrans:GetComponent(typeof(UnityEngine.RectTransform)).rect.height;
    local newX = oneItemTrans.localPosition.x;
    local newY = 0;
    if isTarget == true then
        newY = self._taskTitleYPosition - (self._titleHeight * 0.5) - self._targetHeight - (oneItemHeight * (index - 0.5)) - (self._taskItemGap * (index + 1));
    else
        newY = self._taskTitleYPosition - (self._titleHeight * 0.5) - (oneItemHeight * (index - 0.5)) - (self._taskItemGap * index);
    end
    oneItemTrans.localPosition = Vector3.New(newX, newY, 0);
end

-- 选择一个任务
function UITask:ChooseOneItem(tableId)
    if #self._allTaskItemsClass < self._normalTaskCount + self._targetTaskCount then
        return;
    end

    self._curTask = TaskService:Instance():GetTaskByTableId(tableId);
    if self._curTask == nil then
        return;
    end

    self._curTableData = DataQuest[self._curTask:GetTableId()];
    if self._curTableData == nil then
        return;
    end

    for i = 1, self._normalTaskCount + self._targetTaskCount do
        if self._allTaskItemsClass[i]:GetTableId() == tableId then
            self._allTaskItemsClass[i]:ChangeChooseState(true);
        else
            self._allTaskItemsClass[i]:ChangeChooseState(false);
        end
    end

    self:UpdateDetailContent();
end

-- 更新右侧具体任务内容
function UITask:UpdateDetailContent()
    if self._curTableData == nil then
        return;
    end

    self._detailTitle.text = self._curTableData.QuestName;
    self._detailDes.text = self._curTableData.QuestExplain;

    for i = 1, 6 do
        self:SetReward(self._rewardTable[i], self._curTableData.Award[i], self._curTableData.AwardParameter1[i], self._curTableData.AwardParameter2[i]);
    end
    self:SetTargetDes();
    self:SetGotoBtn();
    self:SetGetBtn();
end

-- 单个奖励物品设置
function UITask:SetReward(rewardTrans, rewardType, para1, para2) 
    if rewardType == nil or para1 == nil or para2 == nil then
        rewardTrans.gameObject:SetActive(false);
        return;
    else
        rewardTrans.gameObject:SetActive(true);
    end

    -- icon
    local iconImage = rewardTrans:FindChild("icon"):GetComponent(typeof(UnityEngine.UI.Image));
    local itemData = DataItem[para1];
    if itemData ~= nil then
        iconImage.sprite = GameResFactory.Instance():GetResSprite(itemData.Icon1);
    end

    -- name and count
    local nameText = rewardTrans:FindChild("des"):GetComponent(typeof(UnityEngine.UI.Text));
    if rewardType == TaskRewardType.Item or rewardType == TaskRewardType.BuildQueue then
        local itemDataT = DataItem[para1];
        if itemDataT ~= nil then
            nameText.text = itemDataT.Name .. " " .. para2;
        end
    elseif rewardType == TaskRewardType.Skill then
        local skillData = DataSkill[para2];
        if skillData ~= nil then
            nameText.text = skillData.SkillnameText;
        end
    elseif rewardType == TaskRewardType.FourStarHero or rewardType == TaskRewardType.FiveStarHero then
        local heroData = DataHero[para2];
        if heroData ~= nil then
            nameText.text = heroData.Name;
        end
    else
        local lootData = DataCardLoot[para2];
        if lootData ~= nil then
            nameText.text = lootData.Name;
        end
    end
end

-- 目标描述设置
function UITask:SetTargetDes()
    if self._curTableData == nil then
        return;
    end

    local desStr = "";
    if self._curTableData.QuestType[1] == 24 then -- 木石粮铁单独判断
        for i = 1, 4 do
            if self._curTableData.QuestTarget[i] ~= nil and self._curTableData.Parameter[1] ~= nil then
                local curCount = 0;
                if i == 1 then
                    curCount = PlayerService:Instance():GetWoodYield();
                elseif i == 2 then
                    curCount = PlayerService:Instance():GetIronYield();
                elseif i == 3 then
                    curCount = PlayerService:Instance():GetStoneYield();
                elseif i == 4 then
                    curCount = PlayerService:Instance():GetFoodYield();
                end
                local targetCount = self._curTableData.Parameter[1];

                if curCount >= targetCount then
                    desStr = desStr .. "<color=#ffffff>" .. self._curTableData.QuestTarget[i] .. " " .. targetCount .. "/" .. targetCount .. "</color>";
                else
                    desStr = desStr .. "<color=#ff0000>" .. self._curTableData.QuestTarget[i] .. " " .. curCount .. "/" .. targetCount .. "</color>";
                end

                if i == 1 or i == 3 then
                    desStr = desStr .. "   ";
                elseif i == 2 then
                    desStr = desStr .. "\n";
                end
            end
        end
    else
        for i = 1, self._curTask:GetSchedule():Count() do
            if self._curTableData.QuestType[i] ~= 0 and self._curTableData.QuestTarget[i] ~= nil and self._curTableData.StatisticsNum[i] ~= nil and self._curTask:GetSchedule():Get(i) ~= nil then
                local curCount = self._curTask:GetSchedule():Get(i);
                local targetCount = self._curTableData.StatisticsNum[i];

                if curCount >= targetCount then
                    desStr = desStr .. "<color=#ffffff>" .. self._curTableData.QuestTarget[i] .. " " .. targetCount .. "/" .. targetCount .. "</color>";
                else
                    desStr = desStr .. "<color=#ff0000>" .. self._curTableData.QuestTarget[i] .. " " .. curCount .. "/" .. targetCount .. "</color>";
                end

                if i ~= self._curTask:GetSchedule():Count() then
                    desStr = desStr .. "   ";
                end
            end
        end
    end

    self._detailTarget.text = desStr;
end

-- 前往按钮设置
function UITask:SetGotoBtn()
    if self._curTableData == nil then
        return;
    end

    if self._curTableData.QuestType[1] == 0 then
        return;
    end

    local isCanReward = self._curTask:GetRewardState();
    if isCanReward == true or self._curTableData.Jump == 0 then
        self._gotoBtn.gameObject:SetActive(false);
        self._buildingText.gameObject:SetActive(false);
        return;
    end

    self._gotoBtn.gameObject:SetActive(true);

    -- 前往按钮上面升级提示设置
    if self._curTableData.Jump ~= TaskJumpType.FacilityJump then
        self._buildingText.gameObject:SetActive(false);
        return;
    end
    
    local curFacilityType = self._curTableData.JumpParameter;
    if curFacilityType == 0 then
        self._buildingText.gameObject:SetActive(false);
        return;
    end
    
    local curFacility = FacilityService:Instance():GetFacility(self._mainCityID, curFacilityType);
    if curFacility == nil then
        self._buildingText.gameObject:SetActive(false);
        return;
    end

    if curFacility:GetBuildingTime() == 0 then
        self._buildingText.gameObject:SetActive(false);
        return;
    end

    self._buildingText.gameObject:SetActive(true);

    if curFacility:GetLevel() == 0 then
        self._buildingText.text = "建设中";
    else
        self._buildingText.text = "Lv" .. curFacility:GetLevel() .. "升级中";
    end
end

-- 领取按钮设置
function UITask:SetGetBtn()
    if self._curTableData == nil then
        return;
    end
    if self._curTableData.QuestType[1] == 0 then
        return;
    end

    local isCanReward = self._curTask:GetRewardState();
    if isCanReward == true then
        self._getBtn.gameObject:SetActive(true);
    else
        self._getBtn.gameObject:SetActive(false);
    end
end

function UITask:OnCloseBtn()
    UIService:Instance():HideUI(UIType.UITask);
end

function UITask:OnGetBtn()
    if self._curTableData == nil then
        return;
    end

    -- 判断奖励预备兵和声望是否超过上限
    local awardRedifCount = 0;
    local awardFameCount = 0;
    for i = 1, 6 do
        if self._curTableData.Award[i] ~= nil and self._curTableData.Award[i] == TaskRewardType.Item
        and self._curTableData.AwardParameter1[i] ~= nil and self._curTableData.AwardParameter1[i] == 12
        and self._curTableData.AwardParameter2[i] ~= nil then
            awardRedifCount = self._curTableData.AwardParameter2[i];
        end
        if self._curTableData.Award[i] ~= nil and self._curTableData.Award[i] == TaskRewardType.Item
        and self._curTableData.AwardParameter1[i] ~= nil and self._curTableData.AwardParameter1[i] == 7
        and self._curTableData.AwardParameter2[i] ~= nil then
            awardFameCount = self._curTableData.AwardParameter2[i];
        end
    end

    if awardRedifCount > 0 then
        local mainCityTiledId = PlayerService:Instance():GetMainCityTiledId();
        local mainCity = BuildingService:Instance():GetBuildingByTiledId(mainCityTiledId);
        if mainCity ~= nil then
            if mainCity:GetBuildingRedif() + awardRedifCount > mainCity:GetBuildingMaxRedif() then
                local paramT = { };
                paramT[1] = "领取后预备兵将会超过上限，超过上限的不予保留";
                paramT[4] = true;
                UIService:Instance():ShowUI(UIType.MessageBox, paramT);
                MessageBox:Instance():RegisterOk( function()
                    self:GetAward();
                end );
                return;
            end
        end
    end

    if awardFameCount > 0 then
        local curFameCount = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Rnown):GetValue();
        local maxFameCount = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Rnown):GetMaxValue();
        --print(curFameCount .. "  " .. awardFameCount .. "  "  .. maxFameCount)
        if curFameCount + awardFameCount > maxFameCount then
            local paramT = { };
            paramT[1] = "领取奖励后名望会超出上限，超出的部分将会消失。确认要领取当前任务奖励吗？";
            paramT[4] = true;
            UIService:Instance():ShowUI(UIType.MessageBox, paramT);
            MessageBox:Instance():RegisterOk( function()
                self:GetAward();
            end );
            return;
        end
    end

    local requestId = self._curTask:GetRequestId();
    TaskService:Instance():AwardRequest(requestId);
end

function UITask:GetAward()
    if self._curTableData == nil then
        return;
    end

    local requestId = self._curTask:GetRequestId();
    TaskService:Instance():AwardRequest(requestId);
end

function UITask:OnGoToBtn()
    if self._curTableData == nil then
        return;
    end
    UIService:Instance():HideUI(UIType.UITask);
    local jumpType = self._curTableData.Jump;
    if jumpType == TaskJumpType.FacilityJump then
        self:GoToFacility(self._curTableData.JumpParameter);
    elseif jumpType == TaskJumpType.MainViewJump then
        self:GoToMainView();
    elseif jumpType == TaskJumpType.MainCityJump then
        self:GoToMainCity();
    elseif jumpType == TaskJumpType.HeroCardJump then
        -- 规则
    elseif jumpType == TaskJumpType.SkillJump then
        self:GoToSkill();
    else
        
    end
end

-- 跳转设施
function UITask:GoToFacility(facilityType)
    self:GoToMainCity(function()
        local param = {};
        param.id = self._mainCityID;
        param.facilityType = facilityType;
        UIService:Instance():ShowUI(UIType.UIFacility, param);
    end);
end

-- 跳转主界面
function UITask:GoToMainView()
    if UIService:Instance():GetOpenedUI(UIType.UIGameMainView) == true then
        return;
    end

    MapService:Instance():EnterOperator(OperatorType.ZoomOut);
    MapService:Instance():EnterOperator(OperatorType.Empty);
    UIService:Instance():ShowUI(UIType.UIGameMainView);
    UIService:Instance():HideUI(UIType.UIMainCity);
    MapService:Instance():OutCityCallBack()
end

-- 跳转主城
function UITask:GoToMainCity(callBack)
    if UIService:Instance():GetOpenedUI(UIType.UIMainCity) == true then
        local uiMainCity = UIService:Instance():GetUIClass(UIType.UIMainCity);
        if uiMainCity.buildingType == BuildingType.MainCity then
            if callBack ~= nil then 
                callBack();
            end
            return;
        else
            MapService:Instance():ChangeSmallerViewNoTween();
            local cityTiledId = PlayerService:Instance():GetMainCityTiledId();
            local pos = MapService:Instance():GetTiledPositionByIndex(cityTiledId);
            MapService:Instance():ScanTiledByUGUIPositionNotDelay(pos.x, pos.y);
            MapService:Instance():ChangeBiggerView(callBack);
            local building = BuildingService:Instance():GetBuildingByTiledId(cityTiledId)
            local param = {};
            param[0] = building;
            uiMainCity:OnShow(param);
            return;
        end
    end
    
    local cityTiledId = PlayerService:Instance():GetMainCityTiledId();
    MapService:Instance():SetCallBack(cityTiledId);
    MapService:Instance():SetChangeBiggerCallBack(callBack);
    MapService:Instance():ClickCityCallBack();
    local building = BuildingService:Instance():GetBuildingByTiledId(cityTiledId)
    local param = {};
    param[0] = building
    MapService:Instance():EnterOperator(OperatorType.ZoomOut);
    UIService:Instance():ShowUI(UIType.UIMainCity, param);
    UIService:Instance():HideUI(UIType.UIGameMainView);
end

-- 跳转战法
function UITask:GoToSkill()
    local roleId = PlayerService:Instance():GetPlayerId()
    SkillService:Instance():RequestPlayerSkillList(self.roleId)
    UIService:Instance():ShowUI(UIType.UITactis) 
    UIService:Instance():HideUI(UIType.UIGameMainView)
end

return UITask;

--endregion
