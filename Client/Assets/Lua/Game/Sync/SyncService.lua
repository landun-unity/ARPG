local GameService = require("FrameWork/Game/GameService")

local SyncHandler = require("Game/Sync/SyncHandler")
local SyncManage = require("Game/Sync/SyncManage");
SyncService = class("SyncService", GameService)

-- 同步相关的服务
function SyncService:ctor( )
    SyncService._instance = self;
    SyncService.super.ctor(self, SyncManage.new(), SyncHandler.new());
end

--清空数据
function SyncService:Clear()
    self._logic:ctor()
end

-- 单例
function SyncService:Instance()
    return SyncService._instance;
end

-- 同步回调
function SyncService:RegisterSync(syncType, fun)
    self._logic:RegisterSync(syncType, fun);
end

-- 开始同步
function SyncService:StartSyncInfo()
    self._logic:StartSyncInfo();
end

-- 结束同步
function SyncService:StopSyncInfo()
    self._logic:StopSyncInfo();
end

return SyncService;