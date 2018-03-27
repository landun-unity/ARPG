local GameService = require("FrameWork/Game/GameService")

local DefaultHandler = require("FrameWork/Game/DefaultHandler")
local NetManage = require("Game/Net/NetManage");
NetService = class("NetService", GameService)

function NetService:ctor( )
    -- body
    --print("NetService:ctor");
    NetService._instance = self;
    NetService.super.ctor(self, NetManage.new(), DefaultHandler.new());
end

-- 单例
function NetService:Instance()
    return NetService._instance;
end


--清空数据
function NetService:Clear()
    self._logic:ctor()
end


-- 发送消息
function NetService:SendMessage( msg ,isShowDisconnect)
    -- body
    -- if msg == nil or msg:GetMessageId() == nil then
    --     return;
    -- end
    -- self._logic:SendMessage(msg);
    self:SendTCPMessage(msg,isShowDisconnect);
end
-- 发送消息
function NetService:SendTCPMessage( msg ,isShowDisconnect)
    -- body
    if msg == nil or msg:GetMessageId() == nil then
        return;
    end
    --print("NetService SendTcpMessage");
    self._logic:SendTcpMessage(msg,isShowDisconnect);
end

function NetService:SendHttpMessage( msg )
    -- body
    self._logic:SendMessage(msg);
end

function NetService:ConnectTCPServer()
    -- body
    self._logic:ConnectServerTCP();
end

function NetService:CloseTcpServer()
    -- body
    self._logic:CloseTcpServer();
end

return NetService;