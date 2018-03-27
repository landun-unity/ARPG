local GamePart = require("FrameWork/Game/GamePart")
local Skill = require("Game/Skill/Skill")
local List = require("common/List")

local SkillManage = class("SkillManage", GamePart)
local DataTable = require("Game/Table/model/DataSkill")
local SkillType = require("Game/Skill/SkillType");

-- 构造函数
function SkillManage:ctor()
    SkillManage.super.ctor(self)
    self._skillTable = { }
    self._skillTableDic = { }
    self._skillList = List.new()
    self._skillCommandList = List.new()
    -- 指挥  3
    self._skillActiveList = List.new()
    -- 主动   2
    self._skillPassiveList = List.new()
    -- 被动  1
    self._skillPursuitList = List.new()
    -- 追击  4
    self._tempTable = { }
    self._newSkill = nil;
    -- 新研究出来的战法
    self._LearnedSkill = nil;
    -- 刚刚研究成功可以学习的战法
    self.ChooseList = List.new();
    self.changeNum = 0;

    self.rememberHeroId = nil;

    -- 新鲜出炉的技能
    self.lastSkill = nil

end

--- 是否产生暴击
function SkillManage:GetChangeNum()
    return self.changeNum
end


function SkillManage:RememberHeroId(args)
    self.rememberHeroId = args;
end

function SkillManage:ReturnRememberID()
    return self.rememberHeroId;
end


function SkillManage:SetChangeNum(args)
    self.changeNum = args
end

-- 向表中添加技能信息
function SkillManage:AddSkillToTable(id, skill)
    if skill then
        self._skillTable[id] = skill
        self._skillTableDic[skill._tableId] = skill
        local skilltype = DataTable[skill._tableId].Type;
        if (skilltype == SkillType.Passive) then
            self._skillPassiveList:Push(skill)
        end
        if (skilltype == SkillType.Active) then
            self._skillActiveList:Push(skill)
        end
        if (skilltype == SkillType.Command) then
            self._skillCommandList:Push(skill)
        end
        if (skilltype == SkillType.Pursuit) then
            self._skillPursuitList:Push(skill)
        end
    end
end

-- 根据索引从list中获取战法信息
function SkillManage:GetSkillFromListByID(id)
    return self._skillTable[id];
end

function SkillManage:GetSkillByTableID(tableid)
    return self._skillTableDic[tableid];
end

-- 根据索引从list中获取战法信息
function SkillManage:GetSkillFromListByIndex(index)
    return self._skillList:Get(index)
end

-- 根据类型和索引从list中获取战法信息
function SkillManage:GetSkillByTypeAndIndex(skilltype, index)
    if (skilltype == SkillType.All) then
        return self._skillList:Get(index)
    end
    if (skilltype == SkillType.Passive) then
        return self._skillPassiveList:Get(index)
    end
    if (skilltype == SkillType.Active) then
        return self._skillActiveList:Get(index)
    end
    if (skilltype == SkillType.Command) then
        return self._skillCommandList:Get(index)
    end
    if (skilltype == SkillType.Pursuit) then
        return self._skillPursuitList:Get(index)
    end
    return nil;
end

-- 根据类型获取技能表的数量
function SkillManage:GetSkillCountByType(skilltype)
    if (skilltype == SkillType.All) then
        return self._skillList:Count()
    end
    if (skilltype == SkillType.Passive) then
        return self._skillPassiveList:Count()
    end
    if (skilltype == SkillType.Active) then
        return self._skillActiveList:Count()
    end
    if (skilltype == SkillType.Command) then
        return self._skillCommandList:Count()
    end
    if (skilltype == SkillType.Pursuit) then
        return self._skillPursuitList:Count()
    end
    return 0;
end

-- 获取技能表的数量
function SkillManage:GetSkillListSize()
    return self._skillList:Count()
end

-- 设置战法信息并返回
function SkillManage:SetSkillInfo(id, tableId, progress, learnHeroID)
    local skillInfo = Skill.new()
    skillInfo._id = id
    skillInfo._tableId = tableId
    skillInfo._progress = progress
    skillInfo._learnHeroID = learnHeroID
    return skillInfo
end


function SkillManage:SetAllSkillList()
    self._skillList:Clear();
    for index = 1, self._skillCommandList:Count() do
        local skill = self._skillCommandList:Get(index)
        self._skillList:Push(skill)
    end
    for index = 1, self._skillActiveList:Count() do
        local skill = self._skillActiveList:Get(index)
        self._skillList:Push(skill)
    end
    for index = 1, self._skillPassiveList:Count() do
        local skill = self._skillPassiveList:Get(index)
        self._skillList:Push(skill)
    end
    for index = 1, self._skillPursuitList:Count() do
        local skill = self._skillPursuitList:Get(index)
        self._skillList:Push(skill)
    end
end

-- 初始化战法信息列表
function SkillManage:SetSkillInfoList(skillModelList)
    self._newSkill = nil;
    self._LearnedSkill = nil;
    local count = skillModelList:Count()
    for index = 1, count do
        local skillMsgModel = skillModelList:Get(index)
        local skillInfo = self:SetSkillInfo(skillMsgModel.id, skillMsgModel.tableID, skillMsgModel.progress, skillMsgModel.learnHeroID)
        self:AddSkillToTable(skillMsgModel.id, skillInfo)
    end
    self:SortList(self._skillCommandList);
    self:SortList(self._skillActiveList);
    self:SortList(self._skillPassiveList);
    self:SortList(self._skillPursuitList);
    self:SetAllSkillList();
end

-- 战法研究进度刷新
function SkillManage:UpdateSkill(info)
    self:UpdateSkillInfo(info);
end

-- 更新战法信息
function SkillManage:UpdateSkillInfo(info)

    local oldSkillInfo = self:GetSkillFromListByID(info.id);
    local tableid = info.tableID
    if (tableid == nil) then
        tableid = oldSkillInfo._tableId;
    end
    local progress = info.progress;
    if (progress == nil) then
        progress = oldSkillInfo._tableId;
    end
    local learnheroid = info.learnHeroID;
    if (learnheroid == nil) then
        learnheroid = oldSkillInfo._learnHeroID;
    end
    local skillInfo = self:SetSkillInfo(info.id, tableid, progress, learnheroid)
    if skillInfo then
        if (DataTable[tableid] == nil) then
            return;
        end
        local skilltype = DataTable[tableid].Type;

        if (skilltype == SkillType.Passive) then
            if self._skillTable[info.id] then
                self._skillPassiveList:Remove(self._skillTable[info.id]);
            end
            self._skillPassiveList:Push(skillInfo);
            self:SortList(self._skillPassiveList);
        end
        if (skilltype == SkillType.Active) then
            if self._skillTable[info.id] then
                self._skillActiveList:Remove(self._skillTable[info.id]);
            end
            self._skillActiveList:Push(skillInfo);
            self:SortList(self._skillActiveList);
        end
        if (skilltype == SkillType.Command) then
            if self._skillTable[info.id] then
                self._skillCommandList:Remove(self._skillTable[info.id]);
            end
            self._skillCommandList:Push(skillInfo);
            self:SortList(self._skillCommandList);
        end
        if (skilltype == SkillType.Pursuit) then
            if self._skillTable[info.id] then
                self._skillPursuitList:Remove(self._skillTable[info.id]);
            end
            self._skillPursuitList:Push(skillInfo);
            self:SortList(self._skillPursuitList);
        end

    end
    if self._skillTable[info.id] == nil then

        self._newSkill = skillInfo;

    else

        if (self._skillTable[info.id]._progress < 10000 and skillInfo._progress >= 10000) then

            self._LearnedSkill = skillInfo;

        end
    end
    self._skillTable[info.id] = skillInfo

    self._skillTableDic[skillInfo._tableId] = skillInfo;

    self:SetAllSkillList();

    -- 刷新战法背包
    if UIService:Instance():GetOpenedUI(UIType.UITactis) == false then
        if UIService:Instance():GetOpenedUI(UIType.UIHeroCardPackage) == false then
            UIService:Instance():ShowUI(UIType.UITactis)
        end

    else

        UIService:Instance():GetUIClass(UIType.UITactis):OnShow()

    end

    local param = UIService:Instance():GetUIClass(UIType.UITactis):GetLastChangeSkill(skillInfo._tableId)

    local data = { skillInfo, param }

    self.lastSkill = param
    -- 刷新战法研究
    if UIService:Instance():GetOpenedUI(UIType.UITactisResearch) == false then

        UIService:Instance():ShowUI(UIType.UITactisResearch, data)

    else
        UIService:Instance():GetUIClass(UIType.UITactisResearch):OnShow(data)

    end
end
-- 获取最后一个技能
function SkillManage:GetLastSkill()
    if self.lastSkill == nil then
        return nil;
    else
        return self.lastSkill
    end
end

-- 清空储存
function SkillManage:SetLastSkill()
    self.lastSkill = nil;
end



-- 删除战法信息
function SkillManage:DeleteSkillInfo(info)
    local id = info.id;
    if self._skillTable[id] then
        self._skillList:Remove(self._skillTable[id]);
        local tableid = self._skillTable[id]._tableId;
        local skilltype = DataTable[tableid].Type;
        if (skilltype == SkillType.Passive) then
            self._skillPassiveList:Remove(self._skillTable[id]);
        end
        if (skilltype == SkillType.Active) then
            self._skillActiveList:Remove(self._skillTable[id]);
        end
        if (skilltype == SkillType.Command) then
            self._skillCommandList:Remove(self._skillTable[id]);
        end
        if (skilltype == SkillType.Pursuit) then
            self._skillPursuitList:Remove(self._skillTable[id]);
        end
        self._skillTable[id] = nil;
        self._skillTableDic[tableid] = nil;
    end
end

function SkillManage:SortList(Listinfo)
    -- table.sort(Listinfo._list,function(a,b) self:SortByProgress(a,b)end);
    local count = Listinfo:Count();
    if (count == 0) then
        return
    end
    for index = 1, count do
        local info = Listinfo:Get(index);
        for j = 1, index do
            if (j == index) then
                table.insert(self._tempTable, info);
                break;
            elseif (info._progress > self._tempTable[j]._progress) then
                table.insert(self._tempTable, j, info);
                break;
            end
        end
    end
    Listinfo:Clear();
    for k, v in pairs(self._tempTable) do
        Listinfo:Push(v);
    end
    self._tempTable = { }
end


function SkillManage:SortByProgress(a, b)
    if (a == nil or b == nil) then
        return false;
    end
    if (a._progress == nil or b._progress == nil) then
        return false;
    end
    if (a._progress == b._progress) then
        return false;
    end
    return a._progress > b._progress;
end

function SkillManage:GetNewSkill()
    return self._newSkil;
end

function SkillManage:GetCanLearnedSkill()
    return self._LearnedSkill;
end

function SkillManage:SetNewSkill()
    self._newSkil = nil;
end

function SkillManage:SetCanLearnedSkill()
    self._LearnedSkill = nil;
end

-- 设置选中的列表
function SkillManage:SetChooseList(List)
    self.ChooseList:Clear();
    local count = List:Count();
    for index = 1, count do
        local listinfo = List:Get(index);
        self.ChooseList:Push(listinfo);
    end
end

-- 判断是不是在选中的列表中
function SkillManage:GetIfChooseList(info)
    local count = self.ChooseList:Count();
    for index = 1, count do
        local listinfo = self.ChooseList:Get(index);
        if (listinfo == info) then
            return true;
        end
    end
    return false;
end


return SkillManage


