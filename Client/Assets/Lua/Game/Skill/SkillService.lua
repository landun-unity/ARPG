local GameService = require("FrameWork/Game/GameService")
local SkillManage = require("Game/Skill/SkillManage")
local SkillHandler = require("Game/Skill/SkillHandler")
local Skill = require("Game/Skill/Skill")
local List = require("common/List")
SkillService = class("SkillService", GameService)

function SkillService:ctor()
    -- body
    SkillService._instance = self;
    SkillService.super.ctor(self, SkillManage.new(), SkillHandler.new());
end


function SkillService:Instance()
    return SkillService._instance
end

-- 清空数据
function SkillService:Clear()
    self._logic:ctor()
end

-- 将roleId传到逻辑服
function SkillService:RequestPlayerSkillList(roleId)
    self._handler:RequestPlayerSkillList(roleId)
end

-- 将技能信息添加到表中
function SkillService:AddSkillToTable(id, skill)
    self._logic:AddSkillToTable(id, skill)
end

-- 通过index获取战法
function SkillService:GetSkillFromListByIndex(index)
    return self._logic:GetSkillFromListByIndex(index)
end

--获取最后一个技能
function SkillService:GetLastSkill()
    return self._logic:GetLastSkill()
end

--清空存储
function SkillService:SetLastSkill()
    return self._logic:SetLastSkill()
end


-- 根据类型和索引从list中获取战法信息
function SkillService:GetSkillByTypeAndIndex(skilltype, index)
    return self._logic:GetSkillByTypeAndIndex(skilltype, index)
end

-- 通过战法ID获取战法
function SkillService:GetSkillFromListByID(id)
    return self._logic:GetSkillFromListByID(id)
end

function SkillService:GetSkillByTableID(tableid)
    return self._logic:GetSkillByTableID(tableid)
end

-- 获取列表长度
function SkillService:GetSkillListSize()
    return self._logic:GetSkillListSize()
end

-- 根据类型获取技能表的数量 --fromhero 是否是来自英雄页面
function SkillService:GetSkillCountByType(skilltype)
    return self._logic:GetSkillCountByType(skilltype)
end

function SkillService:GetNewSkill()
    return self._logic:GetNewSkill();
end

function SkillService:GetCanLearnedSkill()
    return self._logic:GetCanLearnedSkill();
end

function SkillService:SetNewSkill()
    self._logic:SetNewSkill();
end

function SkillService:SetCanLearnedSkill()
    self._logic:SetCanLearnedSkill();
end

-- 传入Hero id,英雄学习战法的位置
-- id为唯一ID，skillpos为战法槽位置
function SkillService:HeroLearnSkill(id, skillPos)
    local heroinfo = HeroService:Instance():GetOwnHeroesById(id);
    temp = { };
    temp[1] = id;
    temp[2] = skillPos;
    self:RememberHeroId(id)
    UIService:Instance():HideUI(UIType.UIHeroCardInfo)
    UIService:Instance():ShowUI(UIType.UITactis, temp)
end

function SkillService:RememberHeroId(id)
    self._logic:RememberHeroId(id)
end

function SkillService:ReturnRememberID()
    HeroService:Instance():ShowHeroInfoUI(self._logic:ReturnRememberID())
end

-- 传入Hero id,英雄强化战法的位置
-- id为唯一ID，skillpos为战法槽位置
-- canStrengthen 是可以强化技能 true 可以 false 不可以
function SkillService:HeroStrengthenSkill(id, skillTableId, canStrengthen)
    self.param = { };
    self.param[1] = 2;
    -- 是否来自武将强化
    local skillInfo = Skill.new()
    skillInfo._id = 0;
    skillInfo._tableId = skillTableId
    skillInfo._progress = 10000;
    skillInfo._learnHeroID = List.new()
    self.param[2] = skillInfo;
    local heroinfo = HeroService:Instance():GetOwnHeroesById(id);
    if (heroinfo) then
        local Currentskilllv = 1;
        for index = 1, 3 do
            if (heroinfo.allSkillSlotList[index] and heroinfo.allSkillSlotList[index] == skillTableId) then
                Currentskilllv = heroinfo.allSkillLevelList[index];
                self.param[4] = index;
                self.param[5] = Currentskilllv;
                self.param[6] = canStrengthen;
            end
        end
    end
    self.param[3] = id;
    UIService:Instance():ShowUI(UIType.UITactisDetail, self.param);
end

function SkillService:GetSkillBgByType(skilltype)
    if (skilltype == SkillType.Passive) then
        return GameResFactory.Instance():GetResSprite("Tactics02");
    end
    if (skilltype == SkillType.Active) then
        return GameResFactory.Instance():GetResSprite("Tactics01");
    end
    if (skilltype == SkillType.Command) then
        return GameResFactory.Instance():GetResSprite("Tactics04");
    end
    if (skilltype == SkillType.Pursuit) then
        return GameResFactory.Instance():GetResSprite("Tactics03");
    end
    return nil;
end

-- 设置选中的列表
function SkillService:SetChooseList(ChooseList)
    self._logic:SetChooseList(ChooseList);
end

-- 判断是不是在选中的列表中
function SkillService:GetIfChooseList(info)
    return self._logic:GetIfChooseList(info);
end

-- 获取转化战法经验增加量
function SkillService:GetChangeNum()
    return self._logic:GetChangeNum()
end
function SkillService:SetChangeNum(args)
    self._logic:SetChangeNum(args)
end
return SkillService

