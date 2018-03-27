-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成

local IOHandler = require("FrameWork/Game/IOHandler")
local WorldTendencyHandler = class("WorldTendencyHandler", IOHandler)
local List = require("common/list");
local WorldTask = require("Game/WorldTendency/WorldTask")
local DataEpicEvent = require("Game/Table/model/DataEpicEvent");

-- 构造函数

function WorldTendencyHandler:ctor()
    WorldTendencyHandler.super.ctor(self);
end

function WorldTendencyHandler:RegisterAllMessage()
    self:RegisterMessage(L2C_WorldTendency.ResponseWordTendencyInfo, self.HandleResponseWordTendencyInfo, require("MessageCommon/Msg/L2C/WorldTendency/ResponseWordTendencyInfo"));
    self:RegisterMessage(L2C_WorldTendency.ReponseGetAward, self.HandleReponseGetAward, require("MessageCommon/Msg/L2C/WorldTendency/ReponseGetAward"));
    self:RegisterMessage(L2C_WorldTendency.WorldTendencyDoneResponse, self.HandleReponseRefresh, require("MessageCommon/Msg/L2C/WorldTendency/WorldTendencyDoneResponse"));
end

function WorldTendencyHandler:HandleReponseRefresh(msg)
    local tableId = msg.tableId;
    if UIService:Instance():GetUIClass(UIType.UIGameMainView) ~= nil then
        UIService:Instance():GetUIClass(UIType.UIGameMainView):ShowWorldRedPoint()
    end
end

function WorldTendencyHandler:HandleResponseWordTendencyInfo(msg)
    local list = List.new();
    for k, v in pairs(msg.wordTendencyInfoList._list) do
        local mtask = WorldTask.new();
        mtask.tableId = v.tableId
        mtask.isOpen = v.isOpen;
        mtask.paramValueOne = v.paramValueOne
        mtask.paramValueTwo = v.paramValueTwo
        mtask.isDone = v.isDone
        mtask.doneTime = v.doneTime
        mtask.isGetAward = v.isGetAward
        mtask.Data = DataEpicEvent[v.tableId]
        mtask.couldGetAward = v.couldGetAward;
        mtask.endTime = v.endTime
        list:Push(mtask)
    end
    self._logicManage:SetWorldEventList(list)
    UIService:Instance():HideUI(UIType.UIGameMainView)
    local baseClass = UIService:Instance():GetUIClass(UIType.WorldTendencyUI);
    local isopen = UIService:Instance():GetOpenedUI(UIType.WorldTendencyUI);
    if isopen == false then
        if LoginService:Instance():IsLoginState(LoginStateType.Empty) then
            UIService:Instance():ShowUI(UIType.WorldTendencyUI)
            UIService:Instance():GetUIClass(UIType.UIGameMainView):CanShowWorldPoint()
        end
    else
        baseClass:ResetPos()
        baseClass:OnShow()
    end

end

function WorldTendencyHandler:HandleReponseGetAward(msg)
    self._logicManage:SendWorldTendencyMessage()
end


return WorldTendencyHandler
-- endregion
