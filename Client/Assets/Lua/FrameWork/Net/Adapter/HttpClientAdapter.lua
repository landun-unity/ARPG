-- 游戏管理的基类
local NetAdapter = require("FrameWork/Net/Adapter/NetAdapter")
local NetType = require("NetCommon/Util/NetType")
-- 定义类
local HttpClientAdapter = class("HttpClientAdapter", NetAdapter)

-- 构造函数
function HttpClientAdapter:ctor()
    -- body
    --print("HttpClientAdapter:ctor");
    self._content = nil;
    self.Adaptertype = NetType.HttpClient;
    HttpClientAdapter.super.ctor(self);
end

-- 初始化
function HttpClientAdapter:Init(adapterId, objectParam)
    -- body
    self._adapterId = adapterId;
    self._content = objectParam;

    HttpClientAdapter.super.Init(self, adapterId, objectParam);
end

-- 添加发送队列
function HttpClientAdapter:AddSendBlock(block)
    -- body
    self._allMemMessageQueue:Push(block);
end

-- 发送消息
function HttpClientAdapter:SendMessage(block)
    -- body
    local count = self._allMemMessageQueue:Count();
    for i=1,count do
        local sendData = self._allMemMessageQueue:Pop();
        self:SendData(sendData:GetBytes());
    end
end

-- 发送消息
function HttpClientAdapter:SendData(data)
    -- body
    self._content:RequestData(data);
end

return HttpClientAdapter;