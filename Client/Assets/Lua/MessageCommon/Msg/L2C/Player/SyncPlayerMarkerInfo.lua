--
-- 逻辑服务器 --> 客户端
-- 同步标记信息
-- @author czx
--
local List = require("common/List");

local TiledIndexModel = require("MessageCommon/Msg/L2C/Player/TiledIndexModel");

local GameMessage = require("common/Net/GameMessage");
local SyncPlayerMarkerInfo = class("SyncPlayerMarkerInfo", GameMessage);

--
-- 构造函数
--
function SyncPlayerMarkerInfo:ctor()
    SyncPlayerMarkerInfo.super.ctor(self);
    --
    -- 建筑物列表
    --
    self.allTiledIndexList = List.new();
end

--@Override
function SyncPlayerMarkerInfo:_OnSerial() 
    
    local allTiledIndexListCount = self.allTiledIndexList:Count();
    self:WriteInt32(allTiledIndexListCount);
    for allTiledIndexListIndex = 1, allTiledIndexListCount, 1 do 
        local allTiledIndexListValue = self.allTiledIndexList:Get(allTiledIndexListIndex);
        
        self:WriteString(allTiledIndexListValue.name);
        self:WriteInt32(allTiledIndexListValue.tiledIndex);
    end
end

--@Override
function SyncPlayerMarkerInfo:_OnDeserialize() 
    
    local allTiledIndexListCount = self:ReadInt32();
    for i = 1, allTiledIndexListCount, 1 do 
        local allTiledIndexListValue = TiledIndexModel.new();
        allTiledIndexListValue.name = self:ReadString();
        allTiledIndexListValue.tiledIndex = self:ReadInt32();
        self.allTiledIndexList:Push(allTiledIndexListValue);
    end
end

return SyncPlayerMarkerInfo;
