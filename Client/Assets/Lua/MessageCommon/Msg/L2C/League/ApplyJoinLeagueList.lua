--
-- 逻辑服务器 --> 客户端
-- 申请加入同盟列表
-- @author czx
--
local List = require("common/List");

local ApplyJoinLeagueModel = require("MessageCommon/Msg/L2C/League/ApplyJoinLeagueModel");

local GameMessage = require("common/Net/GameMessage");
local ApplyJoinLeagueList = class("ApplyJoinLeagueList", GameMessage);

--
-- 构造函数
--
function ApplyJoinLeagueList:ctor()
    ApplyJoinLeagueList.super.ctor(self);
    --
    -- 申请是否已关闭
    --
    self.isShut = false;
    
    --
    -- 申请加入model
    --
    self.list = List.new();
end

--@Override
function ApplyJoinLeagueList:_OnSerial() 
    self:WriteBoolean(self.isShut);
    
    local listCount = self.list:Count();
    self:WriteInt32(listCount);
    for listIndex = 1, listCount, 1 do 
        local listValue = self.list:Get(listIndex);
        
        self:WriteInt64(listValue.playerId);
        self:WriteString(listValue.name);
        self:WriteInt32(listValue.influence);
        self:WriteInt32(listValue.province);
    end
end

--@Override
function ApplyJoinLeagueList:_OnDeserialize() 
    self.isShut = self:ReadBoolean();
    
    local listCount = self:ReadInt32();
    for i = 1, listCount, 1 do 
        local listValue = ApplyJoinLeagueModel.new();
        listValue.playerId = self:ReadInt64();
        listValue.name = self:ReadString();
        listValue.influence = self:ReadInt32();
        listValue.province = self:ReadInt32();
        self.list:Push(listValue);
    end
end

return ApplyJoinLeagueList;
