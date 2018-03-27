--
-- 逻辑服务器 --> 客户端
-- 打开周围玩家回复
-- @author czx
--
local List = require("common/List");

local RoundPlayerModel = require("MessageCommon/Msg/L2C/League/RoundPlayerModel");

local GameMessage = require("common/Net/GameMessage");
local OpenRoundPlayerRespond = class("OpenRoundPlayerRespond", GameMessage);

--
-- 构造函数
--
function OpenRoundPlayerRespond:ctor()
    OpenRoundPlayerRespond.super.ctor(self);
    --
    -- 周围玩家list
    --
    self.list = List.new();
end

--@Override
function OpenRoundPlayerRespond:_OnSerial() 
    
    local listCount = self.list:Count();
    self:WriteInt32(listCount);
    for listIndex = 1, listCount, 1 do 
        local listValue = self.list:Get(listIndex);
        
        self:WriteInt64(listValue.playerId);
        self:WriteString(listValue.name);
        self:WriteInt32(listValue.influence);
        self:WriteInt32(listValue.province);
        self:WriteInt32(listValue.coord);
        self:WriteBoolean(listValue.isInvented);
    end
end

--@Override
function OpenRoundPlayerRespond:_OnDeserialize() 
    
    local listCount = self:ReadInt32();
    for i = 1, listCount, 1 do 
        local listValue = RoundPlayerModel.new();
        listValue.playerId = self:ReadInt64();
        listValue.name = self:ReadString();
        listValue.influence = self:ReadInt32();
        listValue.province = self:ReadInt32();
        listValue.coord = self:ReadInt32();
        listValue.isInvented = self:ReadBoolean();
        self.list:Push(listValue);
    end
end

return OpenRoundPlayerRespond;
