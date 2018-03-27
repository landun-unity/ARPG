--
-- 逻辑服务器 --> 客户端
-- 同步信息
-- @author czx
--
local List=require("common/List");

local SyncInfo = class("SyncInfo");

function SyncInfo:ctor()
    --
    -- 同步类型
    --
    self.syncType = 0;
    
    --
    -- 同步信息的索引
    --
    self.allSyncIndexList = List.new();
end

return SyncInfo;
