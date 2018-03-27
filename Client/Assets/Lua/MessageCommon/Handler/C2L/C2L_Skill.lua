require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Client * 16777216 + Terminal.Logic * 65536 + MessageHandler.Skill * 256;

--
-- 客户端 --> 逻辑服务器
-- Skill
-- @author czx
--
C2L_Skill = 
{
    --
    -- 删除技能
    --
    DeleteOneSkill = Begin + 0, 
    
    --
    -- 遗忘技能
    --
    ForGetSkill = Begin + 1, 
    
    --
    -- 请求英雄卡牌
    --
    GetOnePlayerSkillList = Begin + 2, 
    
    --
    -- 学习技能
    --
    LearnSkill = Begin + 3, 
    
    --
    -- 研究技能
    --
    ResearchSkill = Begin + 4, 
    
    --
    -- 技能强化
    --
    SkillEnhance = Begin + 5, 
}

return C2L_Skill;
