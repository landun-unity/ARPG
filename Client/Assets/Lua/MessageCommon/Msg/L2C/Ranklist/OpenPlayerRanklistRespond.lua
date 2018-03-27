--
-- 逻辑服务器 --> 客户端
-- 玩家打开被同盟邀请列表
-- @author czx
--
local List = require("common/List");

local PlayerModel = require("MessageCommon/Msg/L2C/Ranklist/PlayerModel");

local GameMessage = require("common/Net/GameMessage");
local OpenPlayerRanklistRespond = class("OpenPlayerRanklistRespond", GameMessage);

--
-- 构造函数
--
function OpenPlayerRanklistRespond:ctor()
    OpenPlayerRanklistRespond.super.ctor(self);
    --
    -- 个人排行model
    --
    self.playerList = List.new();
end

--@Override
function OpenPlayerRanklistRespond:_OnSerial() 
    
    local playerListCount = self.playerList:Count();
    self:WriteInt32(playerListCount);
    for playerListIndex = 1, playerListCount, 1 do 
        local playerListValue = self.playerList:Get(playerListIndex);
        
        self:WriteInt64(playerListValue.playerid);
        self:WriteInt32(playerListValue.rankPostion);
        self:WriteString(playerListValue.name);
        self:WriteInt32(playerListValue.province);
        self:WriteInt32(playerListValue.subcityNum);
        self:WriteInt32(playerListValue.fortNum);
        self:WriteInt32(playerListValue.landNum);
        self:WriteInt32(playerListValue.influence);
    end
end

--@Override
function OpenPlayerRanklistRespond:_OnDeserialize() 
    
    local playerListCount = self:ReadInt32();
    for i = 1, playerListCount, 1 do 
        local playerListValue = PlayerModel.new();
        playerListValue.playerid = self:ReadInt64();
        playerListValue.rankPostion = self:ReadInt32();
        playerListValue.name = self:ReadString();
        playerListValue.province = self:ReadInt32();
        playerListValue.subcityNum = self:ReadInt32();
        playerListValue.fortNum = self:ReadInt32();
        playerListValue.landNum = self:ReadInt32();
        playerListValue.influence = self:ReadInt32();
        self.playerList:Push(playerListValue);
    end
end

return OpenPlayerRanklistRespond;
