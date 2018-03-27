-- 游戏管理的基类
local NetAdapter = require("FrameWork/Net/Adapter/NetAdapter")
local NetType = require("NetCommon/Util/NetType")
-- 定义类
local TCPClientAdapter = class("TCPClientAdapter", NetAdapter)

-- 构造函数
function TCPClientAdapter:ctor()
    self._content = nil;
    self.Adaptertype = NetType.TCPClient;
    TCPClientAdapter.super.ctor(self);
end

-- 初始化
function TCPClientAdapter:Init(adapterId, objectParam)
    -- body
    self._adapterId = adapterId;
    self._content = objectParam;

    TCPClientAdapter.super.Init(self, adapterId, objectParam);
end

-- 添加发送队列
function TCPClientAdapter:AddSendBlock(block)
    -- body
    self._allMemMessageQueue:Push(block);
end

-- 发送消息
function TCPClientAdapter:SendMessage(block)
    -- body
    local count = self._allMemMessageQueue:Count();
    for i=1,count do
        local sendData = self._allMemMessageQueue:Pop();
        self:SendData(sendData:GetBytes());
    end
end

-- 发送消息
function TCPClientAdapter:SendData(data)
    -- body
    self._content:RequestData(data);
end

return TCPClientAdapter;