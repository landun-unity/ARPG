-- 同步相关消息处理
local IOHandler = require("FrameWork/Game/IOHandler")
local SyncHandler = class("SyncHandler", IOHandler)

-- 构造函数
function SyncHandler:ctor( )
    -- body
    SyncHandler.super.ctor(self);
end

-- 注册所有消息
function SyncHandler:RegisterAllMessage()
    self:RegisterMessage(L2C_Player.SyncInfoReply, self.HandleSyncInfoReply, require("MessageCommon/Msg/L2C/Player/SyncInfoReply"));
end

-- 处理同步信息
function SyncHandler:HandleSyncInfoReply(msg)
    self._logicManage:StartNextSyncInfo();
    local count = msg.allSyncList:Count();
    if count == nil or count == 0 then
        return;
    end
    for i=1,count do
        local syncInfo = msg.allSyncList:Get(i)
        for j=1,syncInfo.allSyncIndexList:Count(), 1 do
            self._logicManage:HandleSyncInfo(syncInfo.syncType, syncInfo.allSyncIndexList:Get(j));
        end
    end
end

return SyncHandler;
