require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Logic * 16777216 + Terminal.Client * 65536 + MessageHandler.Skill * 256;

--
-- 逻辑服务器 --> 客户端
-- Skill
-- @author czx
--
L2C_Skill = 
{
    --
    -- 删除技能
    --
    DeleteOneSkillRespond = Begin + 0, 
    
    --
    -- 玩家技能回复
    --
    GetOnePlayerSkillListRespond = Begin + 1, 
    
    --
    -- 技能学习结果
    --
    LearnSkillResult = Begin + 2, 
    
    --
    -- 强化结果
    --
    SkillEnhanceResult = Begin + 3, 
    
    --
    -- 技能进度信息
    --
    UpdateSkill = Begin + 4, 
}

return L2C_Skill;
