--
-- 逻辑服务器 --> 客户端
-- 玩家打开周围盟
-- @author czx
--
local List = require("common/List");

local RoundLeagueModel = require("MessageCommon/Msg/L2C/League/RoundLeagueModel");

local GameMessage = require("common/Net/GameMessage");
local OpenRoundLeagueListRespond = class("OpenRoundLeagueListRespond", GameMessage);

--
-- 构造函数
--
function OpenRoundLeagueListRespond:ctor()
    OpenRoundLeagueListRespond.super.ctor(self);
    --
    -- 周围盟list
    --
    self.list = List.new();
end

--@Override
function OpenRoundLeagueListRespond:_OnSerial() 
    
    local listCount = self.list:Count();
    self:WriteInt32(listCount);
    for listIndex = 1, listCount, 1 do 
        local listValue = self.list:Get(listIndex);
        
        self:WriteInt64(listValue.leagueid);
        self:WriteString(listValue.name);
        self:WriteInt32(listValue.level);
        self:WriteInt32(listValue.num);
        self:WriteInt32(listValue.province);
        self:WriteInt32(listValue.coord);
        self:WriteBoolean(listValue.alreadApply);
    end
end

--@Override
function OpenRoundLeagueListRespond:_OnDeserialize() 
    
    local listCount = self:ReadInt32();
    for i = 1, listCount, 1 do 
        local listValue = RoundLeagueModel.new();
        listValue.leagueid = self:ReadInt64();
        listValue.name = self:ReadString();
        listValue.level = self:ReadInt32();
        listValue.num = self:ReadInt32();
        listValue.province = self:ReadInt32();
        listValue.coord = self:ReadInt32();
        listValue.alreadApply = self:ReadBoolean();
        self.list:Push(listValue);
    end
end

return OpenRoundLeagueListRespond;
