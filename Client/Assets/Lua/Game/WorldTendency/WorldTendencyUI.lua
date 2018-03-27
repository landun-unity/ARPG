-- region *.lua
-- Date
local UIBase = require("Game/UI/UIBase");
local WorldTendencyUI = class("WorldTendencyUI", UIBase)
local DataEpicEvent = require("Game/Table/model/DataEpicEvent");
local WorldTaskUI = require("Game/WorldTendency/WorldTaskUI");
local WorldEvent = require("Game/WorldTendency/WorldEvent");
local List = require("common/list");

function WorldTendencyUI:ctor()

    WorldTendencyUI.super.ctor(self)

    self.worldBtn = nil;
    self.StateBtn1 = nil;
    self.StateBtn2 = nil;
    self.StateBtn3 = nil;
    self.StateBtn4 = nil;
    self.StateBtn5 = nil;
    self.StateBtn6 = nil;
    self.StateBtn7 = nil;
    self.StateBtn8 = nil;
    self.StateBtn9 = nil;
    self.StateBtn10 = nil;
    self.StateBtn11 = nil;
    self.StateBtn12 = nil;
    self.StateBtn13 = nil;
    self.backBtn = nil;
    self._parentObj = nil;
    self._parentObjWorld = nil;
    self._perfabPath = DataUIConfig[UIType.UIEpic].ResourcePath;
    self._worldPerfab = DataUIConfig[UIType.UIEvent].ResourcePath;
    self.taskList = List.new()
    self.eventList = List.new()
    self._EventMap = { }
    self._TaskMap = { }
    -- 所有的链表
    self.stateList0 = List.new()
    self.stateList1 = List.new()
    self.stateList2 = List.new()
    self.stateList3 = List.new()
    self.stateList4 = List.new()
    self.stateList5 = List.new()
    self.stateList6 = List.new()
    self.stateList7 = List.new()
    self.stateList8 = List.new()
    self.stateList9 = List.new()
    self.stateList10 = List.new()
    self.stateList11 = List.new()
    self.stateList12 = List.new()
    self.stateList13 = List.new()
    self.StateBtnParent = nil

end

function WorldTendencyUI:OnInit()
    self:LoadPrefab()
end


function WorldTendencyUI:DoDataExchange()

    self.worldBtn = self:RegisterController(UnityEngine.UI.Button, "StateScroll/Viewport/Content/Image");
    self.StateBtn1 = self:RegisterController(UnityEngine.UI.Button, "StateScroll/Viewport/Content/Image1");
    self.StateBtn2 = self:RegisterController(UnityEngine.UI.Button, "StateScroll/Viewport/Content/Image2");
    self.StateBtn3 = self:RegisterController(UnityEngine.UI.Button, "StateScroll/Viewport/Content/Image3");
    self.StateBtn4 = self:RegisterController(UnityEngine.UI.Button, "StateScroll/Viewport/Content/Image4");
    self.StateBtn5 = self:RegisterController(UnityEngine.UI.Button, "StateScroll/Viewport/Content/Image5");
    self.StateBtn6 = self:RegisterController(UnityEngine.UI.Button, "StateScroll/Viewport/Content/Image6");
    self.StateBtn7 = self:RegisterController(UnityEngine.UI.Button, "StateScroll/Viewport/Content/Image7");
    self.StateBtn8 = self:RegisterController(UnityEngine.UI.Button, "StateScroll/Viewport/Content/Image8");
    self.StateBtn9 = self:RegisterController(UnityEngine.UI.Button, "StateScroll/Viewport/Content/Image9");
    self.StateBtn10 = self:RegisterController(UnityEngine.UI.Button, "StateScroll/Viewport/Content/Image10");
    self.StateBtn11 = self:RegisterController(UnityEngine.UI.Button, "StateScroll/Viewport/Content/Image11");
    self.StateBtn12 = self:RegisterController(UnityEngine.UI.Button, "StateScroll/Viewport/Content/Image12");
    self.StateBtn13 = self:RegisterController(UnityEngine.UI.Button, "StateScroll/Viewport/Content/Image13");
    self.backBtn = self:RegisterController(UnityEngine.UI.Button, "Back");
    self._parentObj = self:RegisterController(UnityEngine.Transform, "TaskScroll/Viewport/Content");
    self._parentObjWorld = self:RegisterController(UnityEngine.Transform, "EventScorll/Viewport/Content");
    self.TaskScroll = self:RegisterController(UnityEngine.Transform, "TaskScroll");
    self.EventScroll = self:RegisterController(UnityEngine.Transform, "EventScorll");
    self.StateBtnParent = self:RegisterController(UnityEngine.Transform, "StateScroll/Viewport/Content");
    self.curEvent = self:RegisterController(UnityEngine.UI.Text, "StateScroll/Viewport/Content/Image/Text1");
    -- print(self._parentObjWorld)
end

function WorldTendencyUI:DoEventAdd()

    self:AddListener(self.StateBtn1, self.OnClickStateBtn1)
    self:AddListener(self.StateBtn2, self.OnClickStateBtn2)
    self:AddListener(self.StateBtn3, self.OnClickStateBtn3)
    self:AddListener(self.StateBtn4, self.OnClickStateBtn4)
    self:AddListener(self.StateBtn5, self.OnClickStateBtn5)
    self:AddListener(self.StateBtn6, self.OnClickStateBtn6)
    self:AddListener(self.StateBtn7, self.OnClickStateBtn7)
    self:AddListener(self.StateBtn8, self.OnClickStateBtn8)
    self:AddListener(self.StateBtn9, self.OnClickStateBtn9)
    self:AddListener(self.StateBtn10, self.OnClickStateBtn10)
    self:AddListener(self.StateBtn11, self.OnClickStateBtn11)
    self:AddListener(self.StateBtn12, self.OnClickStateBtn12)
    self:AddListener(self.StateBtn13, self.OnClickStateBtn13)

    self:AddListener(self.backBtn, self.OnClickbackBtn)
    self:AddListener(self.worldBtn, self.OnClickworldBtn)
end


function WorldTendencyUI:OnShow()
    self:SetAllList()
    self:ReShow()
    self:ReShowWorldEvent()
    self.btnType = 1
    self:ChangePic()
    self.StateBtnParent:GetChild(0).gameObject:SetActive(false)
end


function WorldTendencyUI:LoadPrefab()
    for i = 1, 10 do
        local mWorldTaskUI = self._TaskMap[i]
        if mWorldTaskUI == nil then
            mWorldTaskUI = WorldTaskUI.new();
            GameResFactory.Instance():GetUIPrefab(self._perfabPath, self._parentObj, mWorldTaskUI, function(go)
                self._TaskMap[i] = mWorldTaskUI;
            end
            )
        end
    end
    for i = 1, 13 do
        local mWorldEventUI = self._EventMap[i];
        if mWorldEventUI == nil then
            mWorldEventUI = WorldEvent.new();
            GameResFactory.Instance():GetUIPrefab(self._worldPerfab, self._parentObjWorld, mWorldEventUI, function(go)
                self._EventMap[i] = mWorldEventUI;
            end
            )
        end
    end
end 


function WorldTendencyUI:ReShow()

    local oldSize = self._parentObj.transform.childCount;
    for i = 1, oldSize do
        local child = self._parentObj.transform:GetChild(i - 1);
        child.gameObject:SetActive(false);
    end
    local size = self.taskList:Count();
    for i = 1, size do
        local mtask = self.taskList:Get(i)
        local mWorldTaskUI = self._TaskMap[i]
        if mWorldTaskUI == nil then
            mWorldTaskUI = WorldTaskUI.new();
            GameResFactory.Instance():GetUIPrefab(self._perfabPath, self._parentObj, mWorldTaskUI, function(go)
                mWorldTaskUI:Init();
                mWorldTaskUI:SetTaskMessage(mtask)
                mWorldTaskUI.gameObject:SetActive(true);
                self._TaskMap[i] = mWorldTaskUI;
            end
            )
        else
            local mdata = self._TaskMap[i];
            if mdata ~= nil then
                mdata:Init();
                mdata:SetTaskMessage(mtask)
                mdata.gameObject:SetActive(true);
            end

        end
    end
    self.TaskScroll.gameObject:SetActive(true)
    self.EventScroll.gameObject:SetActive(false)

end

function WorldTendencyUI:ResetPos()
    self._parentObj.localPosition = Vector3.zero
    self._parentObjWorld.localPosition = Vector3.zero
end

-- 天下大事

function WorldTendencyUI:ReShowWorldEvent()

    local oldSize = self._parentObjWorld.transform.childCount;
    for i = 1, oldSize do
        local child = self._parentObjWorld.transform:GetChild(i - 1);
        child.gameObject:SetActive(false);
    end
    self.eventList = self.stateList0;
    local size = self.stateList0:Count();
    print(size)
    for i = 1, size do
        local mWorldEventUI = self._EventMap[i];
        local mevent = self.eventList:Get(i)
        if mWorldEventUI == nil then
            mWorldEventUI = WorldEvent.new();
            GameResFactory.Instance():GetUIPrefab(self._worldPerfab, self._parentObjWorld, mWorldEventUI, function(go)
                mWorldEventUI:Init();
                -- 显示当前天下大事
                mWorldEventUI:SetEventMessage(mevent)
                mWorldEventUI:SetEventNum(i)
                mWorldEventUI.gameObject:SetActive(true);
                self._EventMap[i] = mWorldEventUI;
            end
            )
        else
            local mdata = self._EventMap[i];
            if mdata ~= nil then
                mdata:Init();
                if mevent.isDone == 0 and mevent.isOpen == 1 then
                    self.curEvent.text = mevent.Data.Name;
                end
                mdata:SetEventMessage(mevent)
                mdata:SetEventNum(i)
                if i == size then
                    mdata:SetLastImageFalse()
                end
                mdata.gameObject:SetActive(true);
            end

        end
    end

    self.TaskScroll.gameObject:SetActive(false)
    self.EventScroll.gameObject:SetActive(true)
end


function WorldTendencyUI:SetAllList()

    local list = WorldTendencyService:Instance():GetWorldEventList();
    self.stateList0:Clear()
    self.stateList1:Clear()
    self.stateList2:Clear()
    self.stateList3:Clear()
    self.stateList4:Clear()
    self.stateList5:Clear()
    self.stateList6:Clear()
    self.stateList7:Clear()
    self.stateList8:Clear()
    self.stateList9:Clear()
    self.stateList10:Clear()
    self.stateList11:Clear()
    self.stateList12:Clear()
    self.stateList13:Clear()
    for i = 1, list:Count() do
        if list:Get(i).Data.StateType == 0 then
            self.stateList0:Push(list:Get(i))
        end
        if list:Get(i).Data.StateType == 1 then
            self.stateList1:Push(list:Get(i))
        end
        if list:Get(i).Data.StateType == 2 then
            self.stateList2:Push(list:Get(i))
        end
        if list:Get(i).Data.StateType == 3 then
            self.stateList3:Push(list:Get(i))
        end
        if list:Get(i).Data.StateType == 4 then
            self.stateList4:Push(list:Get(i))
        end
        if list:Get(i).Data.StateType == 5 then
            self.stateList5:Push(list:Get(i))
        end
        if list:Get(i).Data.StateType == 6 then
            self.stateList6:Push(list:Get(i))
        end
        if list:Get(i).Data.StateType == 7 then
            self.stateList7:Push(list:Get(i))
        end
        if list:Get(i).Data.StateType == 8 then
            self.stateList8:Push(list:Get(i))
        end
        if list:Get(i).Data.StateType == 9 then
            self.stateList9:Push(list:Get(i))
        end
        if list:Get(i).Data.StateType == 10 then
            self.stateList10:Push(list:Get(i))
        end
        if list:Get(i).Data.StateType == 11 then
            self.stateList11:Push(list:Get(i))
        end
        if list:Get(i).Data.StateType == 12 then
            self.stateList12:Push(list:Get(i))
        end
        if list:Get(i).Data.StateType == 13 then
            self.stateList13:Push(list:Get(i))
        end
    end


end



function WorldTendencyUI:OnClickbackBtn()
    UIService:Instance():ShowUI(UIType.UIGameMainView)
    UIService:Instance():HideUI(UIType.WorldTendencyUI)
end


function WorldTendencyUI:ChangePic()
    for i = 1, self.StateBtnParent.childCount do
        self.StateBtnParent:GetChild(i - 1).gameObject.transform:GetChild(1).gameObject:SetActive(false)
    end
    self.StateBtnParent:GetChild(self.btnType).gameObject.transform:GetChild(1).gameObject:SetActive(true)
end


function WorldTendencyUI:OnClickworldBtn()
    self.taskList = self.stateList0;
    self:ReShowWorldEvent()
    self.btnType = 1
    self:ChangePic()
    self:ResetPos()
end


function WorldTendencyUI:OnClickStateBtn1()

    self.taskList = self.stateList1;
    self:ReShow()
    self.btnType = 14
    self:ChangePic()
    self:ResetPos()

end

function WorldTendencyUI:OnClickStateBtn2()
    self.taskList = self.stateList2;
    self:ReShow()
    self.btnType = 13
    self:ChangePic()
    self:ResetPos()

end

function WorldTendencyUI:OnClickStateBtn3()
    self.taskList = self.stateList3;
    self:ReShow()
    self.btnType = 12
    self:ResetPos()
    self:ChangePic()
end


function WorldTendencyUI:OnClickStateBtn4()
    self.taskList = self.stateList4;
    self:ReShow()
    self.btnType = 11
    self:ResetPos()
    self:ChangePic()
end

function WorldTendencyUI:OnClickStateBtn5()
    self.taskList = self.stateList5;
    self:ReShow()
    self.btnType = 10
    self:ResetPos()
    self:ChangePic()
end



function WorldTendencyUI:OnClickStateBtn6()
    self.taskList = self.stateList6
    self:ReShow()
    self.btnType = 9
    self:ResetPos()
    self:ChangePic()
end

function WorldTendencyUI:OnClickStateBtn7()
    self.taskList = self.stateList7
    self:ReShow()
    self.btnType = 8
    self:ResetPos()
    self:ChangePic()
end

function WorldTendencyUI:OnClickStateBtn8()
    self.taskList = self.stateList8
    self:ReShow()
    self.btnType = 7
    self:ResetPos()
    self:ChangePic()

end

function WorldTendencyUI:OnClickStateBtn9()
    self.taskList = self.stateList9
    self:ReShow()
    self.btnType = 6
    self:ResetPos()
    self:ChangePic()
end

function WorldTendencyUI:OnClickStateBtn10()
    self.taskList = self.stateList10
    self:ReShow()
    self.btnType = 5
    self:ResetPos()
    self:ChangePic()
end
function WorldTendencyUI:OnClickStateBtn11()
    self.taskList = self.stateList11
    self:ReShow()
    self.btnType = 4
    self:ResetPos()
    self:ChangePic()
end
function WorldTendencyUI:OnClickStateBtn12()
    self.taskList = self.stateList12
    self:ReShow()
    self.btnType = 3
    self:ResetPos()
    self:ChangePic()
end
function WorldTendencyUI:OnClickStateBtn13()
    self.taskList = self.stateList13
    self:ReShow()
    self.btnType = 2
    self:ResetPos()
    self:ChangePic()
end


return WorldTendencyUI