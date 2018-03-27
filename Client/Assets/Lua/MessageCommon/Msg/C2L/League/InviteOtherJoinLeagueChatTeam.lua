--
-- 客户端 --> 逻辑服务器
-- 邀请他人入聊天分组
-- @author czx
--
local List = require("common/List");

local GameMessage = require("common/Net/GameMessage");
local InviteOtherJoinLeagueChatTeam = class("InviteOtherJoinLeagueChatTeam", GameMessage);

--
-- 构造函数
--
function InviteOtherJoinLeagueChatTeam:ctor()
    InviteOtherJoinLeagueChatTeam.super.ctor(self);
    --
    -- 玩家idlist
    --
    self.list = List.new();
end

--@Override
function InviteOtherJoinLeagueChatTeam:_OnSerial() 
    
    local listCount = self.list:Count();
    self:WriteInt32(listCount);
    for listIndex = 1, listCount, 1 do 
        self:WriteInt64(self.list:Get(listIndex));
    end
end

--@Override
function InviteOtherJoinLeagueChatTeam:_OnDeserialize() 
    
    local listCount = self:ReadInt32();
    for i = 1, listCount, 1 do 
        self.list:Push(self:ReadInt64());
    end
end

return InviteOtherJoinLeagueChatTeam;
