--
-- 客户端 --> 逻辑服务器
-- 创建同盟聊天分组请求
-- @author czx
--
local List = require("common/List");

local GameMessage = require("common/Net/GameMessage");
local CreateLeagueChatTeamQuest = class("CreateLeagueChatTeamQuest", GameMessage);

--
-- 构造函数
--
function CreateLeagueChatTeamQuest:ctor()
    CreateLeagueChatTeamQuest.super.ctor(self);
    --
    -- 同盟聊天名字
    --
    self.name = "";
    
    --
    -- 玩家idlist
    --
    self.list = List.new();
end

--@Override
function CreateLeagueChatTeamQuest:_OnSerial() 
    self:WriteString(self.name);
    
    local listCount = self.list:Count();
    self:WriteInt32(listCount);
    for listIndex = 1, listCount, 1 do 
        self:WriteInt64(self.list:Get(listIndex));
    end
end

--@Override
function CreateLeagueChatTeamQuest:_OnDeserialize() 
    self.name = self:ReadString();
    
    local listCount = self:ReadInt32();
    for i = 1, listCount, 1 do 
        self.list:Push(self:ReadInt64());
    end
end

return CreateLeagueChatTeamQuest;
