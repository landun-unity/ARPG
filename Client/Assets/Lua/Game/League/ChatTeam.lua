--
-- 逻辑服务器 --> 客户端
--
local ChatTeam = class("ChatTeam");

function ChatTeam:ctor()
    -- 主管id
    --
    self.leaderId = 0;
    --
    -- 聊天分组名字
    --
    self.name = "";
    --
    -- leader名字
    --
    self.leaderName = "";
end

return ChatTeam;
