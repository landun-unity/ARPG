--
-- 逻辑服务器 --> 客户端
-- 玩家打开下属成员请求
-- @author czx
--
local List = require("common/List");

local UnderMemberModel = require("MessageCommon/Msg/L2C/League/UnderMemberModel");

local GameMessage = require("common/Net/GameMessage");
local OpenUnderMemberRespond = class("OpenUnderMemberRespond", GameMessage);

--
-- 构造函数
--
function OpenUnderMemberRespond:ctor()
    OpenUnderMemberRespond.super.ctor(self);
    --
    -- 下属成员model
    --
    self.list = List.new();
end

--@Override
function OpenUnderMemberRespond:_OnSerial() 
    
    local listCount = self.list:Count();
    self:WriteInt32(listCount);
    for listIndex = 1, listCount, 1 do 
        local listValue = self.list:Get(listIndex);
        
        self:WriteInt64(listValue.playerId);
        self:WriteString(listValue.name);
        self:WriteInt32(listValue.coord);
    end
end

--@Override
function OpenUnderMemberRespond:_OnDeserialize() 
    
    local listCount = self:ReadInt32();
    for i = 1, listCount, 1 do 
        local listValue = UnderMemberModel.new();
        listValue.playerId = self:ReadInt64();
        listValue.name = self:ReadString();
        listValue.coord = self:ReadInt32();
        self.list:Push(listValue);
    end
end

return OpenUnderMemberRespond;
