--
-- 逻辑服务器 --> 客户端
-- 打开外交盟回复
-- @author czx
--
local List = require("common/List");

local DiplomacyLeagueModel = require("MessageCommon/Msg/L2C/League/DiplomacyLeagueModel");

local GameMessage = require("common/Net/GameMessage");
local OpenDiplomacyLeagueRespond = class("OpenDiplomacyLeagueRespond", GameMessage);

--
-- 构造函数
--
function OpenDiplomacyLeagueRespond:ctor()
    OpenDiplomacyLeagueRespond.super.ctor(self);
    --
    -- 关系盟list
    --
    self.list = List.new();
end

--@Override
function OpenDiplomacyLeagueRespond:_OnSerial() 
    
    local listCount = self.list:Count();
    self:WriteInt32(listCount);
    for listIndex = 1, listCount, 1 do 
        local listValue = self.list:Get(listIndex);
        
        self:WriteInt64(listValue.leagueId);
        self:WriteString(listValue.name);
        self:WriteInt32(listValue.province);
        self:WriteInt32(listValue.level);
        self:WriteInt32(listValue.num);
        self:WriteInt32(listValue.coord);
        self:WriteInt32(listValue.influence);
        self:WriteInt64(listValue.nextSettingTime);
        self:WriteInt32(listValue.mType);
    end
end

--@Override
function OpenDiplomacyLeagueRespond:_OnDeserialize() 
    
    local listCount = self:ReadInt32();
    for i = 1, listCount, 1 do 
        local listValue = DiplomacyLeagueModel.new();
        listValue.leagueId = self:ReadInt64();
        listValue.name = self:ReadString();
        listValue.province = self:ReadInt32();
        listValue.level = self:ReadInt32();
        listValue.num = self:ReadInt32();
        listValue.coord = self:ReadInt32();
        listValue.influence = self:ReadInt32();
        listValue.nextSettingTime = self:ReadInt64();
        listValue.mType = self:ReadInt32();
        self.list:Push(listValue);
    end
end

return OpenDiplomacyLeagueRespond;
