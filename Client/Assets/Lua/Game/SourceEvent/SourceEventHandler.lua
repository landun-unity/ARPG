local IOHandler = require("FrameWork/Game/IOHandler")

local SourceEventHandler = class("SourceEventHandler", IOHandler)

function SourceEventHandler:ctor()
	SourceEventHandler.super.ctor(self)
end

-- 注册所有消息
function SourceEventHandler:RegisterAllMessage()
    self:RegisterMessage(L2C_SourceEvent.SourceEventList,self.GetSourceEventList,require("MessageCommon/Msg/L2C/SourceEvent/SourceEventList"));
    self:RegisterMessage(L2C_SourceEvent.SourceEvent,self.GetOneSourceEvent,require("MessageCommon/Msg/L2C/SourceEvent/SourceEvent"));
    self:RegisterMessage(L2C_SourceEvent.DeleteSourceEvent,self.DeleteOneSourceEvent,require("MessageCommon/Msg/L2C/SourceEvent/DeleteSourceEvent"));
end

--获取资源地事件列表
function SourceEventHandler:GetSourceEventList(msg)   
    --print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!GetSourceEventList")
	self._logicManage:GetSourceEventList(msg.allSourceEventList)
    LoginService:Instance():EnterState(LoginStateType.RequestArmyInfo);
end

function SourceEventHandler:GetOneSourceEvent(msg)
    --print("收到返回一个资源地事件")
	self._logicManage:GetOneSourceEvent(msg.info)
end

function SourceEventHandler:DeleteOneSourceEvent(msg)
    --print("收到返回删除一个资源地事件 id:"..msg.iD)
	self._logicManage:DeleteOneSourceEvent(msg.iD)
end

return SourceEventHandler


