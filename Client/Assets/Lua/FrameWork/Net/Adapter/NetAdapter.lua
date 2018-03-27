-- 游戏管理的基类
local NetAdapter = class("NetAdapter")
local NetType = require("NetCommon/Util/NetType")
-- 构造函数
function NetAdapter:ctor()
    -- body
    --print("NetAdapter:ctor");
    self._adapterId = 0;
    self._objectCache = nil;
    self._allMemMessageQueue = require("common/Queue").new();
    self.Adaptertype = NetType.HttpClient;
end

-- 适配器Id
function NetAdapter:GetAdapterId()
    -- body
    return self._adapterId;
end

-- 对象缓存
function NetAdapter:GetObjectCache()
    -- body
    return self._objectCache;
end

-- 初始化
function NetAdapter:Init(adapterId, objectParam)
    -- body
    self._adapterId = adapterId;
    self._objectCache = objectParam;
    self._allMemMessageQueue:Clear();
end

-- 添加发送队列
function NetAdapter:AddSendBlock(block)
    -- body
    self._allMemMessageQueue:Push(block);
end

-- 发送消息
function NetAdapter:SendMessage(block)
    -- body
end

-- 发送消息
function NetAdapter:SendData(data)
    -- body
end

return NetAdapter;