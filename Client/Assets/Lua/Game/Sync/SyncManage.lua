-- 登录管理
local GamePart = require("FrameWork/Game/GamePart")
require("Game/Sync/SyncType")

local SyncManage = class("SyncManage", GamePart)

-- 构造函数
function SyncManage:ctor( )
    SyncManage.super.ctor(self)
    -- 所有的同步事件
    self.allSyncMap = {};
    self.spaceTimer = nil;
    self.lastCheckTime = 0;
    self.lastSendTime = 0;
end

-- 初始化
function SyncManage:_OnInit()
end

-- 心跳
function SyncManage:_OnHeartBeat()
end

-- 停止
function SyncManage:_OnStop()
end

-- 同步回调
function SyncManage:RegisterSync(syncType, fun)
    if syncType == nil or fun == nil then
        return;
    end

    self.allSyncMap[syncType] = fun;
end

-- 处理同步信息
function SyncManage:HandleSyncInfo(syncType, index, syncIndex)
    if self.allSyncMap[syncType] == nil then
        self:RefreshSyncInfo(syncType, index); 
        return;
    end

    self.allSyncMap[syncType]();
end

-- 直接回复消息
function SyncManage:RefreshSyncInfo(syncType, index)
    local msg = require("MessageCommon/Msg/C2L/Player/RefreshSyncInfo").new();
    msg:SetMessageId(C2L_Player.RefreshSyncInfo);
    msg.syncType = syncType;
    msg.index = index;

    NetService:Instance():SendMessage(msg);
end

-- 请求同步信息 
function SyncManage:RequestSyncInfo()
    self.lastSendTime = Time.time;
    local msg = require("MessageCommon/Msg/C2L/Player/RequestSyncInfo").new();
    msg:SetMessageId(C2L_Player.RequestSyncInfo);

    NetService:Instance():SendMessage(msg);
end

-- 开始同步
function SyncManage:StartSyncInfo()
    if self.spaceTimer ~= nil then
        self:StopSyncInfo();
    end

    self:RequestSyncInfo();
    self.spaceTimer = Timer.New(function()
        self:CheckSyncInfo();
    end, 10, -1, false)
    self.spaceTimer:Start()
end

-- 监测时间
function SyncManage:CheckSyncInfo()
    if Time.time - self.lastSendTime <= 5 then
        return;
    end

    -- self:RequestSyncInfo();
end

-- 结束同步
function SyncManage:StopSyncInfo()
    if self.spaceTimer == nil then
        return;
    end

    self.spaceTimer:Stop()
    self.spaceTimer = nil;
end

-- 下次请求时间
function SyncManage:StartNextSyncInfo()
    -- local nextRequest = Timer.New(function()
    --     self:RequestSyncInfo();
    -- end, 1, 1, false);

    -- nextRequest:Start()
end

return SyncManage;
