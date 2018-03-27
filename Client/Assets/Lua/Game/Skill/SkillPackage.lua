-- Anchor:Dr
-- Date  16/9/12
-- 技能(战法)背包

local UIBase = require("Game/UI/UIBase");
local SkillPackage = class("SkillPackage", UIBase);

-- override
function SkillPackage:ctor()
    -- 拆解战法按钮
    self._dismantleSkillBtn = nil;
    -- 转化战法经验
    self._translationSkillExpBtn = nil;
    --已拥有战法数/最大战法数
    self._skillNumText=nil;
    --已拥有战法经验
    self._skillExprenceText=nil;
    -- 已有或已开始研究的战法列表
    self._haveSkilles = { };

    --冲车
     

    SkillPackage.super.ctor(self);
end

-- override
function SkillPackage:DoDataExchange()

end

--设置已有技能
function SkillPackage:SetOwnSkilles(mhaveSkilles)
    self._haveSkilles = mhaveSkilles;
end

-- override
function SkillPackage:OnShow()
    
end


-- endregion
