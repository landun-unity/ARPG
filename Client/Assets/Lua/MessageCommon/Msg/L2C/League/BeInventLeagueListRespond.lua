--
-- 逻辑服务器 --> 客户端
-- 玩家打开被同盟邀请列表
-- @author czx
--
local List = require("common/List");

local JoinLeagueModel = require("MessageCommon/Msg/L2C/League/JoinLeagueModel");

local GameMessage = require("common/Net/GameMessage");
local BeInventLeagueListRespond = class("BeInventLeagueListRespond", GameMessage);

--
-- 构造函数
--
function BeInventLeagueListRespond:ctor()
    BeInventLeagueListRespond.super.ctor(self);
    --
    -- 卡牌列表
    --
    self.list = List.new();
end

--@Override
function BeInventLeagueListRespond:_OnSerial() 
    
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
    end
end

--@Override
function BeInventLeagueListRespond:_OnDeserialize() 
    
    local listCount = self:ReadInt32();
    for i = 1, listCount, 1 do 
        local listValue = JoinLeagueModel.new();
        listValue.leagueId = self:ReadInt64();
        listValue.name = self:ReadString();
        listValue.province = self:ReadInt32();
        listValue.level = self:ReadInt32();
        listValue.num = self:ReadInt32();
        listValue.coord = self:ReadInt32();
        self.list:Push(listValue);
    end
end

return BeInventLeagueListRespond;
