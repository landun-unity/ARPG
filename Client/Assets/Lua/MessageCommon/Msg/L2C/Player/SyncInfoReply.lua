--
-- 逻辑服务器 --> 客户端
-- 同步信息的回复
-- @author czx
--
local List = require("common/List");

local SyncInfo = require("MessageCommon/Msg/L2C/Player/SyncInfo");

local GameMessage = require("common/Net/GameMessage");
local SyncInfoReply = class("SyncInfoReply", GameMessage);

--
-- 构造函数
--
function SyncInfoReply:ctor()
    SyncInfoReply.super.ctor(self);
    --
    -- 同步类型
    --
    self.allSyncList = List.new();
end

--@Override
function SyncInfoReply:_OnSerial() 
    
    local allSyncListCount = self.allSyncList:Count();
    self:WriteInt32(allSyncListCount);
    for i = 1, allSyncListCount, 1 do 
        local allSyncListValue = self.allSyncList:Get(i);
        
        self:WriteInt32(allSyncListValue.syncType);
        
        local allSyncListValueAllSyncIndexListCount = allSyncListValue.allSyncIndexList:Count();
        self:WriteInt32(allSyncListValueAllSyncIndexListCount);
        for i = 1, allSyncListValueAllSyncIndexListCount, 1 do 
            self:WriteInt64(allSyncListValue.allSyncIndexList:Get(i));
        end
    end
end

--@Override
function SyncInfoReply:_OnDeserialize() 
    
    local allSyncListCount = self:ReadInt32();
    for i = 1, allSyncListCount, 1 do 
        local allSyncListValue = SyncInfo.new();
        allSyncListValue.syncType = self:ReadInt32();
        
        local allSyncListValueAllSyncIndexListCount = self:ReadInt32();
        for i = 1, allSyncListValueAllSyncIndexListCount, 1 do 
            allSyncListValue.allSyncIndexList:Push(self:ReadInt64());
        end
        self.allSyncList:Push(allSyncListValue);
    end
end

return SyncInfoReply;
