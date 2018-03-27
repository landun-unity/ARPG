--
-- 逻辑服务器 --> 客户端
-- 玩家打开被同盟邀请列表
-- @author czx
--
local List = require("common/List");

local MemberModel = require("MessageCommon/Msg/L2C/League/MemberModel");

local GameMessage = require("common/Net/GameMessage");
local OpenLeagueMemberBack = class("OpenLeagueMemberBack", GameMessage);

--
-- 构造函数
--
function OpenLeagueMemberBack:ctor()
    OpenLeagueMemberBack.super.ctor(self);
    --
    -- 成员model
    --
    self.list = List.new();
end

--@Override
function OpenLeagueMemberBack:_OnSerial() 
    
    local listCount = self.list:Count();
    self:WriteInt32(listCount);
    for listIndex = 1, listCount, 1 do 
        local listValue = self.list:Get(listIndex);
        
        self:WriteInt64(listValue.playerid);
        self:WriteString(listValue.name);
        self:WriteInt64(listValue.totalContribution);
        self:WriteInt64(listValue.weekContribution);
        self:WriteInt32(listValue.battleAchievment);
        self:WriteInt32(listValue.influence);
        self:WriteInt32(listValue.coord);
        self:WriteInt32(listValue.title);
        self:WriteInt32(listValue.cheifId);
        self:WriteBoolean(listValue.isBeFall);
        self:WriteInt64(listValue.nextAppointCoolingTime);
    end
end

--@Override
function OpenLeagueMemberBack:_OnDeserialize() 
    
    local listCount = self:ReadInt32();
    for i = 1, listCount, 1 do 
        local listValue = MemberModel.new();
        listValue.playerid = self:ReadInt64();
        listValue.name = self:ReadString();
        listValue.totalContribution = self:ReadInt64();
        listValue.weekContribution = self:ReadInt64();
        listValue.battleAchievment = self:ReadInt32();
        listValue.influence = self:ReadInt32();
        listValue.coord = self:ReadInt32();
        listValue.title = self:ReadInt32();
        listValue.cheifId = self:ReadInt32();
        listValue.isBeFall = self:ReadBoolean();
        listValue.nextAppointCoolingTime = self:ReadInt64();
        self.list:Push(listValue);
    end
end

return OpenLeagueMemberBack;
