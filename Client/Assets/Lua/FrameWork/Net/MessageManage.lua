-- 游戏管理的基类
local GamePart = require("FrameWork/Game/GamePart")

local NetType = require("NetCommon/Util/NetType")
local MessageService = require("FrameWork/Message/MessageService")

local Queue = require("common/Queue")

local GameMessage = require("common/Net/GameMessage");
local BinaryMessage = require("common/Net/BinaryMessage");

-- 定义类
local MessageManage = class("MessageManage", GamePart)

-- 构造函数
function MessageManage:ctor()
    self._allAdapterMap = {};
    self._allAdapterbyIdMap = {};
    self._adapterIndex = 0;
    self._receiveMessage = ByteArray.New();
    self._sendMessage = ByteArray.New();
    self._handler = require("NetCommon/Util/NetHandler");
    self._handler:SetObject(self);
    self._handler:SetConnectFunction(self._OnConnect);
    self._handler:SetDisconnectFunction(self._OnDisconnect);
    self._handler:SetReceiveFunction(self._OnReceive);
    MessageManage.super.ctor(self.super);

    self._messageQueue = Queue.new();
    --
    self._messageLimit = 10;
end

-- 初始化
function MessageManage:_OnInit()
end

-- 心跳
-- function MessageManage:HeartBeat()
--     --_HandleReceiveMessage();
--     --_HandleSendMessage();
    
-- end

-- 心跳
function MessageManage:_OnHeartBeat()
    --_HandleReceiveMessage();
    --_HandleSendMessage();
    
    self:_HandleMessageQueue();
end

function MessageManage:_HandleMessageQueue()
    local count = math.min(self._messageLimit, self._messageQueue:Count());

    for i = 1, count, 1 do
        MessageService:Instance():ReceiveMessage(self._messageQueue:Pop());
    end
end

-- 分配索引
function MessageManage:_AllocAdapterId( ... )
    -- body
    if self._adapterIndex == 2147483647 then
        -- body
        self._adapterIndex = 10000;
    end
    local adapterId = self._adapterIndex;
    self._adapterIndex = self._adapterIndex + 1;

    return adapterId;
end

-- 根据连接查找适配器
function MessageManage:_FindAdapterByContent(content)
    -- body
    if content == nil then
        -- body
        return nil;
    end
    return self._allAdapterMap[content];
end

-- 连接上
function MessageManage:_OnConnect(content, netType)
    -- body
    local adapter = self:_FindAdapterByContent(content);
    if adapter == nil then
        adapter = self:_CreateAdapter(content, netType);
    else
        adapter:Init(adapter:GetAdapterId(), content);
    end

    self:_HandleConnect(adapter);
    return adapter:GetAdapterId();
end

-- 处理连接
function MessageManage:_HandleConnect( adapter )
end

-- 断开连接
function MessageManage:_OnDisconnect(content)
    local adapter = self:_FindAdapterByContent(content);
    if adapter == nil then
        return;
    end

    self:_HandleDisconnect(adapter);
end

-- 处理断开连接
function MessageManage:_HandleDisconnect( adapter )
    
end

-- 接收到消息
function MessageManage:_OnReceive( content, block )
    if block:GetUseSize() < GameMessage:GetHeadLength() then
        return;
    end

    local adapter = self:_FindAdapterByContent(content);
    if adapter == nil then
        return;
    end

    self:_HandleReceiveMessage(adapter, block);
end

-- 创建适配器
function MessageManage:_CreateAdapter( content, netType )
    local adapter = self:_NewAdapter(netType);
    local adapterId = self:_AllocAdapterId();
    adapter:Init(adapterId, content);
    --print("adapterId........"..adapterId)
    self._allAdapterMap[content] = adapter;
    self._allAdapterbyIdMap[adapterId] = adapter;

    return adapter;
end

-- 创建适配器
function MessageManage:_NewAdapter( netType )
    if netType == NetType.HttpClient then
        return require("FrameWork/Net/Adapter/HttpClientAdapter").new();
    elseif netType == NetType.TCPClient then
        return require("FrameWork/Net/Adapter/TCPClientAdapter").new();
    else
        return nil;
    end
end

-- 接收到消息
function MessageManage:_HandleReceiveMessage(adapter, block)
    -- body
    if adapter == nil then
        return;
    end

    local msg = self:_DeserialMessage(block);
    if msg == nil then
        return;
    end

    msg:SetAdapterId(adapter:GetAdapterId());
    self._messageQueue:Push(msg);
    if(adapter.Adaptertype == NetType.HttpClient) then
        MessageService:Instance():ReceiveMessage(msg);
    end
    self:ReceivedMessage();
end

function MessageManage:ReceivedMessage()
    -- body
end

function MessageManage:_DeserialMessage( block )
    -- 初始化
    self._receiveMessage:InitBytes(block:GetBytes());
    self._receiveMessage:Reset();
    local length = self._receiveMessage:ReadInt32();
    local msgId = self._receiveMessage:ReadInt32();
    --print(msgId);
    local msg = MessageService:Instance():CreateMessage(msgId);
    if msg == nil then
        --print("我擦。真他么的邪门了"..msgId);
        msg = BinaryMessage.new();
        msg.block = MemBlock.New(block:GetUseSize() - GameMessage:GetHeadLength());
        msg.block:SetUseSize(block:GetUseSize() - GameMessage:GetHeadLength());
    end
    msg:SetByteArray(self._receiveMessage);
    msg:Deserialize();
    
    --[[
    if(msgId ~= 50397966) then
        print(" ------------收到消息了-------------  ",msgId)
    end
    ]]
    return msg;
end

-- 发送消息
function MessageManage:SendMessage( adapterId, msg )
    --print("发消息 11111111111111");
    local adapter = self._allAdapterbyIdMap[adapterId];
    if adapter == nil then
        -- body
        print("没有发出消息去  消息适配器为空了");
        return;
    end
    --print("发消息 222222222222");
    local block = self:_SerialMessage(msg);
    adapter:AddSendBlock(block);
    adapter:SendMessage(nil);
end

function MessageManage:_SerialMessage( msg )
    -- body
    msg:SetByteArray(self._sendMessage);
    msg:Serial();
    
    local block = MemBlock.New(self._sendMessage:GetWritePos());
    block:SetUseSize(self._sendMessage:GetWritePos());
    block:CopyBytes(self._sendMessage:GetBytes(), self._sendMessage:GetWritePos(), 0);
    
    return block;
end

return MessageManage;
