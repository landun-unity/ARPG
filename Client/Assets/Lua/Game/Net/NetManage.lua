-- 登录管理
local MessageManage = require("FrameWork/Net/MessageManage")

local NetManage = class("NetManage", MessageManage)

local HttpClient = require("NetCommon/Http/HttpClient");
local TCPClient = require("NetCommon/TCP/TCPClient");

-- 构造函数
function NetManage:ctor( )
    NetManage.super.ctor(self);
    self._accountAdapterId = 0;
    self._accountClient = HttpClient.new();
    self._accountClient:Init(self._handler, DataConfig.Account);

    self._logicAdapterId = 0;
    self._logicClient = HttpClient.new();
    self._logicClient:Init(self._handler, DataConfig.Logic);


    -- 所有的聊天
    self.allChatMap = {};
    self.chatAdapterId = 0;
    self.chatServer = nil;
    
    self.alltcpServerMap = {};
    self.tcpServer = nil
    self.tcpServerID = 0;
    self.IsConnecting = false;
    self._connectTimer = nil;
    self._connectCheck = nil;

    self.isShowDisConnectUI = false;
    self.ShowTime = nil;
end

-- 初始化
function NetManage:_OnInit()
    self:ConnectChatServer(0, DataConfig.LogicTcp, 10001);
    --self:ConnectTCPServer(0, DataConfig.LogicTcp, 10002);
end

-- 心跳
function NetManage:_OnHeartBeat()
    self:HandlerChatHeartBeat();
    self:ShowDisConnectUI();
end
   
function NetManage:ShowDisConnectUI()
     -- body
    
    if(self.isShowDisConnectUI == true) then
        local time  = Time.time - self.ShowTime;
        if(time >= 2) then
            self.isShowDisConnectUI = false;
            self.ShowTime = Time.time;
--            if(UIService:Instance():GetOpenedUI(UIType.UIDisConnect) == false) then
--                UIService:Instance():ShowUI(UIType.UIDisConnect);
--            end
            local baseClass = UIService:Instance():GetUIClass(UIType.UIDisConnect);
            local isOpen =  UIService:Instance():GetOpenedUI(UIType.UIDisConnect);
            if baseClass == nil or isOpen == false then
                UIService:Instance():ShowUI(UIType.UIDisConnect);
            end
        end
    -- else
    --     local isOpen =  UIService:Instance():GetOpenedUI(UIType.UIDisConnect);
    --     if isOpen == true then
    --         UIService:Instance():HideUI(UIType.UIDisConnect);
    --     end
    end
 end 
-- 停止
function NetManage:_OnStop()
    
end

-- 处理聊天心跳
function NetManage:HandlerChatHeartBeat( ... )
    for k,v in pairs(self.allChatMap) do
        v:HeartBeat();
    end
    for k,v in pairs(self.alltcpServerMap) do
        v:HeartBeat();
    end
end

-- 处理连接
function NetManage:_HandleConnect( adapter )
    ------print("NetManage:_HandleConnect")
    if self._accountClient == adapter:GetObjectCache() then
        self._accountAdapterId = adapter:GetAdapterId();
    elseif self._logicClient == adapter:GetObjectCache() then
        self._logicAdapterId = adapter:GetAdapterId();
         ----print("逻辑服务器http===="..self._logicAdapterId)
    elseif self.chatServer == adapter:GetObjectCache() then
        --print("聊天http===="..adapter:GetAdapterId())
        self.chatAdapterId = adapter:GetAdapterId();
    else
        --print("链接成功了！！！！！！！！！！！！！！！！！！！！");
        self.IsConnecting = false;
        self.tcpServerID = adapter:GetAdapterId();
        local msg1 = require("MessageCommon/Msg/C2L/Player/SendPlayerConnect").new()
        msg1:SetMessageId(C2L_Player.SendPlayerConnect)
        self:SendTcpMessage(msg1,false);

        if(PlayerService:Instance():GetPlayerLoginState()) then
            --print("GoToEnterStateConnect")
            LoginService:Instance():GoToEnterStateConnect();
        else
            --print("GoToEnterState")
            LoginService:Instance():GoToEnterState();
        end
        
        if(self._connectTimer~=nil) then
            self._connectTimer:Stop();
            self._connectTimer = nil;
        end
    end
end

-- 处理断开连接
function NetManage:_HandleDisconnect( adapter )
    print("断开链接了。。。。。。。");
    -- 是自己退出的游戏则不做重新链接
    if(PlayerService:Instance():GetOutofGame()==true) then
        return ;
    end
    self.tcpServer.isSending = false;
    if(self.tcpServerID == adapter:GetAdapterId()) then
        if(self._connectTimer == nil) then
            self._connectTimer = Timer.New(function() 
                self:TcpConnect();
            end, 2, -1, false)
            self._connectTimer:Start()
        end
    end
end

function NetManage:TcpConnect()
    if(self.IsConnecting ==true) then
        return;
    end
    self.IsConnecting  = true;
    --print("开始链接");
    self.tcpServer:Connect();
    self._connectCheck = Timer.New(function() 
            self:ConnectCheck();
        end, 2, 1, false)
    self._connectCheck:Start()
end

function NetManage:ConnectCheck()
    if(self.IsConnecting ==true) then
        self.IsConnecting = false;
    end

    -- body
end
-- 发送消息
function NetManage:SendMessage( msg )
    local toTerminal = ToTerminal(msg:GetMessageId());
    if toTerminal == Terminal.Account then
        NetManage.super.SendMessage(self, self._accountAdapterId, msg);
    elseif toTerminal == Terminal.Logic then
        msg:SetRelationId(PlayerService:Instance():GetPlayerId());
        NetManage.super.SendMessage(self, self._logicAdapterId, msg);
        --print("self._logicAdapterId ===="..self._logicAdapterId);
    elseif toTerminal == Terminal.Chat then
        --print("聊天"..self.chatAdapterId)
        msg:SetRelationId(PlayerService:Instance():GetPlayerId());
        NetManage.super.SendMessage(self, self.chatAdapterId, msg);   
    end
    --[[
    if(msg:GetMessageId() ~=16974609) then
        --print("---------发送消息--------",msg:GetMessageId())
    end
    ]]
    -- self:SendTcpMessage(msg);
end

function NetManage:SendTcpMessage(msg,isOpenDisConnectUI)
    if(isOpenDisConnectUI ~= false) then
        if(self.isShowDisConnectUI == false) then
            self.isShowDisConnectUI = true;
            self.ShowTime = Time.time;
            -- --print(debug.traceback());
        end
    end
    local toTerminal = ToTerminal(msg:GetMessageId());
    if toTerminal == Terminal.Account then
        -- --print("Account"..self._logicAdapterId)
        NetManage.super.SendMessage(self, self._accountAdapterId, msg);
    elseif toTerminal == Terminal.Logic then
         -- --print("Logic"..self._logicAdapterId)
         -- --print("发送消息   消息类型:::"..typeof());
        --print(debug.traceback());
        msg:SetRelationId(PlayerService:Instance():GetPlayerId());
        NetManage.super.SendMessage(self, self.tcpServerID, msg);
    elseif toTerminal == Terminal.Chat then
        --print("Chat"..self._logicAdapterId)
        --print(self.chatAdapterId)
        msg:SetRelationId(PlayerService:Instance():GetPlayerId());
        NetManage.super.SendMessage(self, self.chatAdapterId, msg);
    end
end
function NetManage:ReceivedMessage()
    -- body
    -- print("你不走这？？？？")
    self.isShowDisConnectUI = false;
    self.ShowTime = Time.time;
    if(UIService:Instance():GetOpenedUI(UIType.UIDisConnect)) then
        UIService:Instance():HideUI(UIType.UIDisConnect);
    end
end
-- 获取聊天服务器
function NetManage:FindChatServer(serverId)
    if serverId == nil then
        return nil;
    end

    return self.allChatMap[serverId];
end

-- 创建聊天服务器
function NetManage:CreateChatServer(serverId, host, port)
    local chat = TCPClient.new();
    chat:Init(self._handler, host, port);
    self.allChatMap[serverId] = chat;

    return chat;
end

-- 连接聊天服务器
function NetManage:ConnectChatServer(serverId, host, port)
    self.chatServer = self:FindChatServer(serverId);
    if self.chatServer == nil then
        self.chatServer = self:CreateChatServer(serverId, host, port);
    end
    --print("连接聊天服务器")
    self.chatServer:Connect();
    --IsConnecting = true;
end

function NetManage:ConnectServerTCP()
    self.tcpServer = nil;
    self.tcpServer = self:CreateTCPServer();
    -- self:ConnectChatServer(0, "127.0.0.1", 10001);
    self.tcpServer:Connect();
end
-- 创建TCP服务器 serverId, host, port
function NetManage:CreateTCPServer()
    local chat = TCPClient.new();
    chat:Init(self._handler, DataConfig.LogicTcp, 10002);
    self.alltcpServerMap[0] = chat;
    return chat;
end

function NetManage:CloseTcpServer()
    -- body
    self.tcpServer:Close();
end
return NetManage;