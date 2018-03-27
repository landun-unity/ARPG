-- 定义类
local TCPClient = class("TCPClient")

require("init")
require("NetCommon/TCP/TCPState")

-- 构造函数
function TCPClient:ctor()
    self.host = "";
    self.port = 8401;
    self.socketClient = SocketClient.New();
    self.netHandler = nil;
    self.sendMessageQueue = Queue.new();
    self.isSending = false;
    self.connectState = 0;
end

function TCPClient:Init(netHandler, host, port)
    -- body
    self.netHandler = netHandler;
    self.host = host;
    self.port = port;
    self.socketClient:Init(host, port);
end

-- 连接服务器
function TCPClient:Connect()
    if self.connectState == TCPClient.ConnectSuccess or self.connectState == TCPClient.Connecting then
        return;
    end

    self.connectState = TCPClient.Connecting;
    self.socketClient:Connect();
end

-- 请求数据
function TCPClient:RequestData(data)
    self.sendMessageQueue:Push(data);
    self:StartRequest();
end

-- 发送数据
function TCPClient:StartRequest()
    if(self.connectState == TCPState.DisConnect) then
        return;
    end
    if self.isSending or self.sendMessageQueue:Count() == 0 then
        return;
    end
    self.isSending = true;
    local data = self.sendMessageQueue:Pop();    
    self.socketClient:Send(data);
end

-- 心跳
function TCPClient:HeartBeat()
    self:HandlerState();
    self:HandlerReceive();
end

-- 处理状态
function TCPClient:HandlerState()
    self.socketClient:CopyState();
    local count = self.socketClient:GetStateCount();
    for i=1, count, 1 do
        local state = self.socketClient:DequeueState();
        self:OnStateChanged(state);
    end
end

-- 状态发生变化
function TCPClient:OnStateChanged(state)
    if state == TCPState.ConnectSuccess then
        self:HandleConnect();
    elseif state == TCPState.DisConnect then
        self:HandleDisConnect();
    elseif state == TCPState.SendDone then
        self.isSending = false;
        --print("发送完成===================")
        self:StartRequest();
    elseif state == TCPState.ConnectFail then
        self.connectState = TCPState.ConnectFail;
    end
end

-- 处理连接成功
function TCPClient:HandleConnect()
    --print("tcp 链接上");
    self.connectState = TCPState.ConnectSuccess;
    local object = self.netHandler:GetObject();
    local fun = self.netHandler:GetConnectFunction();
    if object == nil or fun == nil then
        return;
    end

    -- 回调
    fun(object, self, require("NetCommon/Util/NetType").TCPClient);
end

-- 处理连接断开
function TCPClient:HandleDisConnect()
    self.connectState = TCPState.DisConnect;
    local object = self.netHandler:GetObject();
    local fun = self.netHandler:GetDisconnectFunction();
    if object == nil or fun == nil then
        return;
    end

    -- 回调
    fun(object, self, require("NetCommon/Util/NetType").TCPClient);
end

-- 处理消息接收
function TCPClient:HandlerReceive()
    while self:CheckMessage()
    do
        -- print("处理消息接收");
        self:HandleMessage();
    end
end

-- 监测是否有消息可以接收
function TCPClient:CheckMessage()
    local bufferSize = self.socketClient:BufferSize();
    if bufferSize <= 4 then
        -- print("bufferSize 出问题了 小于4"..bufferSize)
        return false;
    end

    local length = self.socketClient:BufferToInt32();
    if bufferSize < length + 4 then
        print("bufferSize 长度出问题了 不能 小于length=="..length.."   bufferSize==="..bufferSize)
        return false;
    end

    return true;
end

-- 处理单个消息
function TCPClient:HandleMessage()
    local object = self.netHandler:GetObject();
    local fun = self.netHandler:GetReceiveFunction();
    if object == nil or fun == nil then
        return;
    end

    local length = self.socketClient:BufferToInt32() + 4;
    -- print("消息长度为：：：：："..length)
    local block = MemBlock.New(length);
    block:SetUseSize(length);
    self.socketClient:ReadBuffer(block:GetBytes(), 0, length);
    
    fun(object, self, block);
end

function  TCPClient:Close()
    -- body
    self.socketClient:Close();
end
return TCPClient;