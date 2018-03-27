--
-- 逻辑服务器 --> 客户端
-- 同步标记信息
-- @author czx
--
local List = require("common/List");

local MainCityTiledIndexModel = require("MessageCommon/Msg/L2C/Player/MainCityTiledIndexModel");

local GameMessage = require("common/Net/GameMessage");
local SyncPlayerMainCitySign = class("SyncPlayerMainCitySign", GameMessage);

--
-- 构造函数
--
function SyncPlayerMainCitySign:ctor()
    SyncPlayerMainCitySign.super.ctor(self);
    --
    -- 建筑物列表
    --
    self.allTiledIndexList = List.new();
end

--@Override
function SyncPlayerMainCitySign:_OnSerial() 
    
    local allTiledIndexListCount = self.allTiledIndexList:Count();
    self:WriteInt32(allTiledIndexListCount);
    for allTiledIndexListIndex = 1, allTiledIndexListCount, 1 do 
        local allTiledIndexListValue = self.allTiledIndexList:Get(allTiledIndexListIndex);
        
        self:WriteInt32(allTiledIndexListValue.tiledIndex);
    end
end

--@Override
function SyncPlayerMainCitySign:_OnDeserialize() 
    
    local allTiledIndexListCount = self:ReadInt32();
    for i = 1, allTiledIndexListCount, 1 do 
        local allTiledIndexListValue = MainCityTiledIndexModel.new();
        allTiledIndexListValue.tiledIndex = self:ReadInt32();
        self.allTiledIndexList:Push(allTiledIndexListValue);
    end
end

return SyncPlayerMainCitySign;
