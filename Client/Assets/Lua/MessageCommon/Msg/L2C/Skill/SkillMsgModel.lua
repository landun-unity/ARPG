--
-- 逻辑服务器 --> 客户端
-- 技能消息结构
-- @author czx
--
local List=require("common/List");

local SkillMsgModel = class("SkillMsgModel");

function SkillMsgModel:ctor()
    --
    -- 技能Id
    --
    self.id = 0;
    
    --
    -- 表Id
    --
    self.tableID = 0;
    
    --
    -- 进度
    --
    self.progress = 0;
    
    --
    -- 学习的卡牌列表
    --
    self.learnHeroID = List.new();
end

return SkillMsgModel;
