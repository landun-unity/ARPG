--
-- 逻辑服务器 --> 客户端
-- 聊天分组model
-- @author czx
--
local ChatMemberModel = class("ChatMemberModel");

function ChatMemberModel:ctor()
    --
    -- 玩家id
    --
    self.playerId = 0;
    
    --
    -- 玩家名字
    --
    self.name = "";
end

return ChatMemberModel;
