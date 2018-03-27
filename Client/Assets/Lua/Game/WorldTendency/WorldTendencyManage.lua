-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
local GamePart = require("FrameWork/Game/GamePart");
local WorldTendencyManage = class("WorldTendencyManage", GamePart);
local List = require("common/list");
require("Game/UI/UIService")

function WorldTendencyManage:ctor()
    WorldTendencyManage.super.ctor(self);

    self.WorldTaskList = nil;
    self.CanShowUI = false

end

function WorldTendencyManage:SetWorldEventList(list)

    self.WorldTaskList = list;

end

function WorldTendencyManage:GetCanShow()
    return self.CanShowUI
end

function WorldTendencyManage:SetCanShow(args)
    self.CanShowUI = args
end


function WorldTendencyManage:GetWorldEventList()

    return self.WorldTaskList

end

-- 发送请球天下大势消息

function WorldTendencyManage:SendWorldTendencyMessage()

    local msg = require("MessageCommon/Msg/C2L/WorldTendency/RequestWordTendencyInfo").new();
    msg:SetMessageId(C2L_WorldTendency.RequestWordTendencyInfo)
    NetService:Instance():SendMessage(msg)
end
-- 领取奖励
function WorldTendencyManage:SendGetAwardMessage(tableId)
    local msg = require("MessageCommon/Msg/C2L/WorldTendency/RequestGetAward").new();
    msg:SetMessageId(C2L_WorldTendency.RequestGetAward)
    msg.tableId = tableId
    NetService:Instance():SendMessage(msg)

end

function WorldTendencyManage:FindTaskByID(id)

    for k, v in pairs(self.WorldTaskList._list) do
        if v.tableId == id then
            return v;
        end

    end


end


return WorldTendencyManage