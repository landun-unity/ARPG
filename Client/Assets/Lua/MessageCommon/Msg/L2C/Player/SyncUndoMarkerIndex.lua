--
-- 逻辑服务器 --> 客户端
-- 返回标记信息
-- @author czx
--
local List = require("common/List");

local TiledIndexModel = require("MessageCommon/Msg/L2C/Player/TiledIndexModel");

local GameMessage = require("common/Net/GameMessage");
local SyncUndoMarkerIndex = class("SyncUndoMarkerIndex", GameMessage);

--
-- 构造函数
--
function SyncUndoMarkerIndex:ctor()
    SyncUndoMarkerIndex.super.ctor(self);
    --
    -- 所有的格子索引
    --
    self.allTiledIndexList = List.new();
end

--@Override
function SyncUndoMarkerIndex:_OnSerial() 
    
    local allTiledIndexListCount = self.allTiledIndexList:Count();
    self:WriteInt32(allTiledIndexListCount);
    for allTiledIndexListIndex = 1, allTiledIndexListCount, 1 do 
        local allTiledIndexListValue = self.allTiledIndexList:Get(allTiledIndexListIndex);
        
        self:WriteInt32(allTiledIndexListValue.tiledIndex);
    end
end

--@Override
function SyncUndoMarkerIndex:_OnDeserialize() 
    
    local allTiledIndexListCount = self:ReadInt32();
    for i = 1, allTiledIndexListCount, 1 do 
        local allTiledIndexListValue = TiledIndexModel.new();
        allTiledIndexListValue.tiledIndex = self:ReadInt32();
        self.allTiledIndexList:Push(allTiledIndexListValue);
    end
end

return SyncUndoMarkerIndex;
