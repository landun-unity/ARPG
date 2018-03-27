--
-- 逻辑服务器 --> 客户端
-- 同步玩家所有设施
-- @author czx
--
local List = require("common/List");

local CityFacilityModel = require("MessageCommon/Msg/L2C/Facility/CityFacilityModel");
local SingleFacilityModel = require("MessageCommon/Msg/L2C/Facility/SingleFacilityModel");

local GameMessage = require("common/Net/GameMessage");
local OpenCityFacilityRespond = class("OpenCityFacilityRespond", GameMessage);

--
-- 构造函数
--
function OpenCityFacilityRespond:ctor()
    OpenCityFacilityRespond.super.ctor(self);
    --
    -- 城设施model
    --
    self.bList = List.new();
end

--@Override
function OpenCityFacilityRespond:_OnSerial() 
    
    local bListCount = self.bList:Count();
    self:WriteInt32(bListCount);
    for bListIndex = 1, bListCount, 1 do 
        local bListValue = self.bList:Get(bListIndex);
        
        self:WriteInt64(bListValue.buildId);
        
        local bListValuelistCount = bListValue.list:Count();
        self:WriteInt32(bListValuelistCount);
        for bListValuelistIndex = 1, bListValuelistCount, 1 do 
            local bListValuelistValue = bListValue.list:Get(bListValuelistIndex);
            
            self:WriteInt64(bListValuelistValue.id);
            self:WriteInt32(bListValuelistValue.level);
            self:WriteInt32(bListValuelistValue.tableid);
            self:WriteInt64(bListValuelistValue.nextUpgradeTime);
        end
    end
end

--@Override
function OpenCityFacilityRespond:_OnDeserialize() 
    
    local bListCount = self:ReadInt32();
    for i = 1, bListCount, 1 do 
        local bListValue = CityFacilityModel.new();
        bListValue.buildId = self:ReadInt64();
        
        local bListValuelistCount = self:ReadInt32();
        for i = 1, bListValuelistCount, 1 do 
            local bListValuelistValue = SingleFacilityModel.new();
            bListValuelistValue.id = self:ReadInt64();
            bListValuelistValue.level = self:ReadInt32();
            bListValuelistValue.tableid = self:ReadInt32();
            bListValuelistValue.nextUpgradeTime = self:ReadInt64();
            bListValue.list:Push(bListValuelistValue);
        end
        self.bList:Push(bListValue);
    end
end

return OpenCityFacilityRespond;
