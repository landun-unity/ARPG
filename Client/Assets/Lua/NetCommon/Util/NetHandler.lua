-- 定义类
local NetHandler = class("NetHandler")

-- 构造函数
function NetHandler:ctor()
    -- 网络访问
    self._object = nil;
    self._onConnectFunction = nil;
    self._onDisconnectFunction = nil;
    self._onReceiveFunction = nil;
end

function NetHandler:SetObject(object)
    -- body
    self._object = object
end

function NetHandler:GetObject()
    -- body
    return self._object
end

function NetHandler:SetConnectFunction(connectFunction)
    -- body
    --print(connectFunction)
    self._onConnectFunction = connectFunction
end

function NetHandler:GetConnectFunction()
    -- body
    return self._onConnectFunction
end

function NetHandler:SetDisconnectFunction(disconnectFunction)
    -- body
    self._onDisconnectFunction = disconnectFunction
end

function NetHandler:GetDisconnectFunction()
    -- body
    return self._onDisconnectFunction
end

function NetHandler:SetReceiveFunction(receiveFunction)
    -- body
    self._onReceiveFunction = receiveFunction
end

function NetHandler:GetReceiveFunction()
    -- body
    return self._onReceiveFunction
end

return NetHandler;