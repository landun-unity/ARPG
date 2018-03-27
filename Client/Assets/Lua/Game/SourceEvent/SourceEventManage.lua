local GamePart = require("FrameWork/Game/GamePart")
local SourceEventManage = class("SourceEventManage", GamePart)

local SourceEventInfo = require("Game/SourceEvent/SourceEventInfo")
local UISourceEventManage = require("Game/SourceEvent/UISourceEventManage")
local List = require("common/List")

-- 构造函数
function SourceEventManage:ctor( )
	SourceEventManage.super.ctor(self)
    self.SourceEventDic = {};

    self.UISEManage = UISourceEventManage.new();
end

function SourceEventManage:GetSourceEventList(list)
    local count = list:Count();
    for index = 1,count do
        local model = list:Get(index);
        print("资源地事件 type : "..model.eventType.."  id:"..model.iD.." 坐标:"..model.positionX..","..model.positionY);
        local info = self:TransModeltoinfo(model);
        self.SourceEventDic[model.iD] = info;
        if(self.UISEManage == nil) then
            self.UISEManage = UISourceEventManage.new();
            self.UISEManage:AddUISourceEvent(info);
        else
            self.UISEManage:AddUISourceEvent(info);
        end
    end
end

function SourceEventManage:GetOneSourceEvent(model)
    print("资源地事件 type : "..model.eventType.."  id:"..model.iD.." 坐标:"..model.positionX..","..model.positionY);
    local info = self:TransModeltoinfo(model);
    self.SourceEventDic[model.iD] = info;
    if(self.UISEManage == nil) then
        self.UISEManage = UISourceEventManage.new();
        self.UISEManage:AddUISourceEvent(info);
    else
        self.UISEManage:AddUISourceEvent(info);
    end
end

function SourceEventManage:DeleteOneSourceEvent(id)
    if self.UISEManage ~= nil then
        self.UISEManage:DeleteUISourceEvent(id);
    end
    if self.SourceEventDic[id] then
        self.SourceEventDic[id] = nil;
    end
end

function SourceEventManage:TransModeltoinfo(model)
    local info = SourceEventInfo.new();
    info:TransModel(model);
    return info;
end

function SourceEventManage:GetSourceEventCount()
     return #self.SourceEventDic;
end

function SourceEventManage:GetSourceEventById(id)
    return self.SourceEventDic[id]
end

function SourceEventManage:isSourceEvent(x,y)
    for k,v in pairs(self.SourceEventDic) do
        if(v._positionX == x and v._positionY == y) then
            return v;
        end
    end
    return nil;
end

return SourceEventManage


