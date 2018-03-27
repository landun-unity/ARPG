--
-- 逻辑服务器 --> 客户端
-- 同盟聊天分组基础信息
-- @author czx
--
local BaseLeagueChatTeamModel = class("BaseLeagueChatTeamModel");

function BaseLeagueChatTeamModel:ctor()
    --
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

return BaseLeagueChatTeamModel;
