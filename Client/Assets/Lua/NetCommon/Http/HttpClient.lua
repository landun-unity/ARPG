-- 定义类
local HttpClient = class("HttpClient")

require("init")

-- 构造函数
function HttpClient:ctor()
    -- 网络访问
    self._www = nil
    self._isSending = false
    self._uri = "127.0.0.1:8080/Binary";
    self._netHandler = nil;
    self._sendMessageQueue = Queue.new();
end

function HttpClient:Init(netHandler, uri)
    -- body
    self._netHandler = netHandler;
    self._uri = uri;
    local object = self._netHandler:GetObject();
    local fun = self._netHandler:GetConnectFunction();
    if object == nil or fun == nil then
        return;
    end

    -- 回调
    fun(object, self, require("NetCommon/Util/NetType").HttpClient);
end

-- 请求数据
function HttpClient:RequestData(data)
    self._sendMessageQueue:Push(data);
    self:StartRequest();
end

-- 发送数据
function HttpClient:StartRequest()
    if self._isSending or self._sendMessageQueue:Count() == 0 then
        if self._isSending then
        end

        return;
    end

    if self._www ~= nil then
        self._www:Dispose();
    end
    local data = self._sendMessageQueue:Pop();
    coroutine.start(function()
            self:Request(data);
            self:StartRequest();
        end);
end

-- 请求
function HttpClient:Request(data)
    self._isSending = true;
    -- print("Queue Count = " .. self._sendMessageQueue:Count());
    local start = Time.time;
	local www = UnityEngine.WWW("http://"..self._uri, data);
    --print(Time.time - start);
    
    while( not www.isDone )
    do
        if Time.time - start >= 2000 then
            break;
        end
        coroutine.step()
        -- print(Time.time - start);
    end

    -- print(Time.time - start);

    if www.isDone then
        self:HandlerRespond(www);
    end

    local endTime = Time.time;
    self._isSending = false;
    -- print(endTime - start);
end

-- 处理消息
function HttpClient:HandlerRespond(www)
    local object = self._netHandler:GetObject();
    local fun = self._netHandler:GetReceiveFunction();
    if object == nil or fun == nil then
        return;
    end

    local length = www.bytesDownloaded;
    --print("HttpClient Lenght = " .. length);
    if length < 4 then
        --print("Error11111111 Receive Length : " .. length .. "ddddd: " .. System.BitConverter.Count(www.bytes));
        return;
    end

    local readSize = 0;
    while(readSize < length)
    do
        if length - readSize < 4 then
            -- print("Error2222222222 Receive Length : " .. length .. "  ReadSize : " .. readSize);
            return;
        end
        local msglength = System.BitConverter.ToInt32(www.bytes, readSize) + 4;
        if (readSize + msglength) > length then
            return;
        end

        if msglength <= 0 then
            --print("Receive Length : " .. length);
            --print("msglength Length : " .. msglength);
            --print("Msg Length Is smaller zero!!!!!!!!!!!!");
            return;
        end

        local block = MemBlock.New(msglength);
        block:CopyBytes(www.bytes, msglength, readSize);
        block:SetUseSize(msglength);
        readSize = readSize + msglength;
        -- print("ReadSize: " .. readSize);
        fun(object, self, block);
    end
end

return HttpClient;