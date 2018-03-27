
-- 战法

local SkillMsgModel = class("SkillMsgModel");

local List = require("common/List")

function SkillMsgModel:ctor()

    -- 唯一ID
    self.id = 0

    -- 静态表ID
    self.tableID = 0

    -- 进度
    self.progress = 0

    --学习的英雄卡牌列表
    self.learnHeroID = List.new()

end

return SkillMsgModel