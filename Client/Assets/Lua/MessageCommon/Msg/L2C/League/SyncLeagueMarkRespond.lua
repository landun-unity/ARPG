--
-- 逻辑服务器 --> 客户端
-- 增加同盟标记回复
-- @author czx
--
local List = require("common/List");

local MarkModel = require("MessageCommon/Msg/L2C/League/MarkModel");

local GameMessage = require("common/Net/GameMessage");
local SyncLeagueMarkRespond = class("SyncLeagueMarkRespond", GameMessage);

--
-- 构造函数
--
function SyncLeagueMarkRespond:ctor()
    SyncLeagueMarkRespond.super.ctor(self);
    --
    -- 标记list
    --
    self.list = List.new();
end

--@Override
function SyncLeagueMarkRespond:_OnSerial() 
    
    local listCount = self.list:Count();
    self:WriteInt32(listCount);
    for listIndex = 1, listCount, 1 do 
        local listValue = self.list:Get(listIndex);
        
        self:WriteInt64(listValue.id);
        self:WriteString(listValue.name);
        self:WriteString(listValue.description);
        self:WriteInt64(listValue.publisherId);
        self:WriteString(listValue.publistName);
        self:WriteInt32(listValue.title);
        self:WriteInt32(listValue.coord);
        self:WriteInt32(listValue.tiledLevel);
    end
end

--@Override
function SyncLeagueMarkRespond:_OnDeserialize() 
    
    local listCount = self:ReadInt32();
    for i = 1, listCount, 1 do 
        local listValue = MarkModel.new();
        listValue.id = self:ReadInt64();
        listValue.name = self:ReadString();
        listValue.description = self:ReadString();
        listValue.publisherId = self:ReadInt64();
        listValue.publistName = self:ReadString();
        listValue.title = self:ReadInt32();
        listValue.coord = self:ReadInt32();
        listValue.tiledLevel = self:ReadInt32();
        self.list:Push(listValue);
    end
end

return SyncLeagueMarkRespond;
