local UIBase= require("Game/UI/UIBase");
local UIBattleReportPersionRound=class("UIBattleReportPersionRound",UIBase);
local List = require("common/List");
local UIType=require("Game/UI/UIType");
local UIConfigTable=require("Game/Table/model/DataUIConfig");
local DetailItem = require("Game/BattleReport/UIBattleReport/UIBattleReportDetailItem");
local EffectType = require("Game/BattleReport/BattleReportFlow/BattleReportEffectType");
local DataHero = require("Game/Table/model/DataHero");
local DataSkill = require("Game/Table/model/DataSkill");
local DataBuff = require("Game/Table/model/DataBuff");
local DataEffect = require("Game/Table/model/DataEffect");
local ArmySlotType = require("Game/Army/ArmySlotType");
local ArmyType = require("Game/Hero/HeroCardPart/ArmyType");
local CampType = require("Game/Hero/HeroCardPart/CampType");
local addHeight = 50; --增加的高度度
local EveryOneHeight = 30; --每增加一个增加的高度
local titleHeight = 25;

local Red = "<color=#ae3030>"
local Green = "<color=#2cb251>"
local colorEnd = "</color>";

function UIBattleReportPersionRound:ctor()
    UIBattleReportPersionRound.super.ctor(self)
    self._AllItemList = List.new();
    self.DetailItemPrefab = UIConfigTable[UIType.UIBattleReportDetailItem].ResourcePath;
    self.TitleObj = nil;
    self.Title = nil;
    self.Parent = nil;
    self.roundindex = 0;
    self.roundBg = nil;
    self.titleBg = nil;
    self.isbeforeround = false;
    self.isGray = false;
    self.DeadCards = {}; --血量为0的卡牌
end

function UIBattleReportPersionRound:DoDataExchange()
    self.TitleObj = self:RegisterController(UnityEngine.Transform,"Front")
    self.Title = self:RegisterController(UnityEngine.UI.Text,"Front/TitleBg/TitleLabel")
    self.Parent = self:RegisterController(UnityEngine.Transform,"Parent")
    self.titleBg = self:RegisterController(UnityEngine.UI.Image,"Front/TitleBg")
    self.roundBg = self.TitleObj.parent.gameObject:GetComponent(typeof(UnityEngine.UI.Image));
end

function UIBattleReportPersionRound:initGrayBack()
    self.isGray = false;
end

--初始化每一个个人回合
function UIBattleReportPersionRound:InitPersonRound(TiledHeroId,infoList,battletype,isbeforeround,isgray)
    local titleName = self:GetHeroName(TiledHeroId,false)
    self.Title.text = titleName;
    --print("-----------------------标题-------------------------",self.Title.text)
    self.isbeforeround = isbeforeround;
    if(self.isbeforeround or isgray) then
        self.TitleObj.gameObject:SetActive(false)
        self.roundBg.enabled = false;
    else
        self.TitleObj.gameObject:SetActive(true)
        self.roundBg.enabled = true;
    end
    self:SetAllFalse();
    if(infoList)~= nil then
        local count = infoList:Count();
        for index =1,count do
            local info = infoList:Get(index);
            if(TiledHeroId == info.AttackHeroId) then
                self:SetBack(info.AIsAttackPart,battletype,self.isgray)
            else
                self:SetBack(info.DIsAttackPart,battletype,self.isgray)
            end
            if(info.BattleFlowType == BattleFlowType.Skill or info.BattleFlowType == BattleFlowType.DoReadySkill or info.BattleFlowType == BattleFlowType.ChaseSkill or info.BattleFlowType == BattleFlowType.ReadySkill or info.BattleFlowType == BattleFlowType.NormalAttack) then        
                self:InitSkillRound(TiledHeroId,info,battletype);
            end
            if(info.BattleFlowType == BattleFlowType.Effect) then
                self:InitEffectRound(info,battletype,false);
            end
            if(info.BattleFlowType == BattleFlowType.buff) then
                self:InitEffectRound(info,battletype,true);
            end
        end
    end
end

--初始化每一行的技能
function UIBattleReportPersionRound:InitSkillRound(TiledHeroId,info,battletype)
    local isourpart1 = BattleReportService:Instance():isOurPart(info.AIsAttackPart,battletype);
    local isourpart2 = BattleReportService:Instance():isOurPart(info.DIsAttackPart,battletype);

    local attackname = self:GetHeroName(info.AttackHeroId,true,isourpart1)
    local defencename = self:GetHeroName(info.DefenceHeroId,true,isourpart2)
    local skillname = self:GetSkillName(info.SkillId)
    
    if(defencename =="" or defencename == "XXX") then
        if(self.isbeforeround) then
            self:InitImageAndText(false,BattleReportService:Instance():getAttackerOrDefenderSprite(info.AIsAttackPart,isourpart1),attackname.."的战法"..skillname.."生效");
        else
            --print("info.BattleFlowType======================================="..info.BattleFlowType);
            if(info.BattleFlowType == BattleFlowType.DoReadySkill) then
                self:InitImageAndText(false,BattleReportService:Instance():getAttackerOrDefenderSprite(info.AIsAttackPart,isourpart1),attackname.."的"..skillname.." 开始准备！");
            elseif(info.BattleFlowType == BattleFlowType.ReadySkill) then
                self:InitImageAndText(false,BattleReportService:Instance():getAttackerOrDefenderSprite(info.AIsAttackPart,isourpart1),attackname.."的"..skillname.." 准备中！");
            elseif(info.BattleFlowType == BattleFlowType.ChaseSkill) then
                self:InitImageAndText(false,BattleReportService:Instance():getAttackerOrDefenderSprite(info.AIsAttackPart,isourpart1),attackname.."的攻击发动"..skillname);
            else
                self:InitImageAndText(false,BattleReportService:Instance():getAttackerOrDefenderSprite(info.AIsAttackPart,isourpart1),attackname.."发动"..skillname);
            end
            --self:InitImageAndText(false,BattleReportService:Instance():getAttackerOrDefenderSprite(info.AIsAttackPart,isourpart1),attackname.."发动"..skillname);
        end
    else
         self:InitImageAndText(false,BattleReportService:Instance():getAttackerOrDefenderSprite(info.AIsAttackPart,isourpart1)
         ,attackname.."对"
         ,BattleReportService:Instance():getAttackerOrDefenderSprite(info.DIsAttackPart,isourpart2)--false,info.DIsAttackPart)
         ,defencename.."发动"..skillname);
    end
    for index = 1,info.EffectList:Count() do
        local effect = info.EffectList:Get(index)
        self:InitOneEffect(effect,battletype)
    end
end

--设置颜色背景
function UIBattleReportPersionRound:SetBack(isattackPart,battletype,isgray)
    -- if(self.isGray == true) then
    --     return
    -- end
    if((isattackPart and battletype ~= BattleReportType.Defence)or(isattackPart == false and battletype == BattleReportType.Defence)) then --我方 用蓝色背景
        self.titleBg.sprite = GameResFactory.Instance():GetResSprite("AttackerTitleBg");
        if(isgray) then
        self.roundBg.sprite = GameResFactory.Instance():GetResSprite("removeBg");
        else
        self.roundBg.sprite = GameResFactory.Instance():GetResSprite("AttackerBg");
        end
        -- print("-----------------------我方 蓝色-------------------------")
    else                                                            --敌方 用红色背景
        self.titleBg.sprite = GameResFactory.Instance():GetResSprite("DefenderTitleBg");
        if(isgray) then
        self.roundBg.sprite = GameResFactory.Instance():GetResSprite("removeBg");
        else
        self.roundBg.sprite = GameResFactory.Instance():GetResSprite("DefenderBg");
        end
        -- print("-----------------------敌方 红色-------------------------")
    end
end

--设置成灰色背景 目前没有用
function UIBattleReportPersionRound:SetGrayBack()
    self.roundBg.sprite = GameResFactory.Instance():GetResSprite("removeBg");
    self.isGray = true;
    -- print("----------------------------------------------设为灰色",self.roundBg.gameObject.name)
    --self.roundBg.sprite = GameResFactory.Instance():GetResSprite("AttackerBg");
end

--设置攻方阵容和守方阵容用的
function UIBattleReportPersionRound:InitAllEffectRound(infoList,battletype,isbeforeround)
    self:SetAllFalse();
    self.isbeforeround = isbeforeround;
    if(self.isbeforeround) then
        self.TitleObj.gameObject:SetActive(false)
        self.roundBg.enabled = false;
        self:InitImageAndText(false,nil,"【攻方阵容】");
    else
        self.TitleObj.gameObject:SetActive(true)
        self.roundBg.enabled = true;
    end
    local AddDefence = false;
    local addEnter = false; --添加回车
    local count = infoList:Count();
    for index = 1,count do
        local info = infoList:Get(index);
        if(info.EffectType == EffectType.DefenseTroopNum and AddDefence == false) then
            AddDefence = true;
            self:InitImageAndText(false,nil,"【守方阵容】");
        end
        if(info.EffectType == nil)then
            if(addEnter == false) then
                addEnter = true;
                self:InitImageAndText(false,nil,"");
            end
            -- print("info.BattleFlowType ",info.BattleFlowType)
            if(info.BattleFlowType == BattleFlowType.OneHeroFlow) then
                --print("info.TiledHeroId ",info.TiledHeroId)
                local OneHeroFlowcount = info.FlowList:Count();
                -- print("OneHeroFlowcount ",OneHeroFlowcount)
                for index = 1,OneHeroFlowcount do
                    local effect = info.FlowList:Get(index);
                    if(effect.BattleFlowType == BattleFlowType.Effect or effect.BattleFlowType == BattleFlowType.buff) then
                        self:InitEffectRound(effect,battletype,false)
                    else
                        self:InitSkillRound(info.TiledHeroId,effect,battletype)
                    end
                end
            end
        else
            self:InitEffectRound(info,battletype,false)
        end
    end
end

--设置一行效果
function UIBattleReportPersionRound:InitEffectRound(info,battletype,isbuff)
    self:InitOneEffect(info,battletype,isbuff)
end

--设置一行效果详情
function UIBattleReportPersionRound:InitOneEffect(info,battletype,isbuff)
    if(info.isgray) then
        -- self:SetGrayBack();
        self.TitleObj.gameObject:SetActive(false)
        self.roundBg.enabled = false;
    end

    local skillType = info.EffectType;
    if(skillType == nil) then
        print("skillType is nil");
        return;
    end
    local skillparam = info.EffectParam;
    local skillparam2 = info.EffectParam2;
    local skillparam3 = info.EffectParam3;
    if(info.EffectId == -1 or skillType == EffectType.AddBuff)then --如果这个卡牌血量为0 就不在显示他的动态
        if(self.DeadCards[info.DefenceHeroId]~=nil and self.DeadCards[info.DefenceHeroId]) then
            return;
        end
    end
    -- if(skillType == EffectType.AddState) then  --表里没有这种类型就不显示
    --     --if(skillparam<=0 or skillparam>12) then  --添加了状态临时去掉 不需要显示了
    --         return;
    --     --end
    -- end
    local isourpart1 = BattleReportService:Instance():isOurPart(info.DIsAttackPart,battletype);
    local isourpart2 = BattleReportService:Instance():isOurPart(info.AIsAttackPart,battletype);

    local attackname = self:GetHeroName(info.AttackHeroId,true,isourpart2)
    local defencename = self:GetHeroName(info.DefenceHeroId,true,isourpart1)
    local effectName = self:GetEffectName(info.EffectId)
    if(info.BattleFlowType ==BattleFlowType.buff) then
        isbuff = true;
    end
    if(isbuff) then
        effectName = self:GetBuffName(info.EffectId)
    end

    local des = self:GetDesByEffectTypeAndParam(skillType,skillparam,skillparam2,skillparam3);
    
    if(info.EffectId == -1)then
        effectName= self:GetSkillName(skillparam2);
        self:InitImageAndText(true,
        BattleReportService:Instance():getAttackerOrDefenderSprite(info.DIsAttackPart,isourpart1)
        ,defencename.."的来自"
        ,BattleReportService:Instance():getAttackerOrDefenderSprite(info.AIsAttackPart,isourpart2)
        ,attackname..effectName.."的"..des.."消失了");
    else
        if(self.isbeforeround and skillType == EffectType.AddBuff) then
            self:InitImageAndText(true,
            BattleReportService:Instance():getAttackerOrDefenderSprite(info.DIsAttackPart,isourpart1)
            --,defencename.."的"..effectName..","..des);
            ,defencename.."的"..des);
        elseif(skillType == EffectType.Pursuit) then
             self:InitImageAndText(false,
             BattleReportService:Instance():getAttackerOrDefenderSprite(info.AIsAttackPart,isourpart2)
            ,attackname.."的攻击发动"..des);
        elseif(skillType == EffectType.NoDoSkill) then
            self:InitImageAndText(false,
            BattleReportService:Instance():getAttackerOrDefenderSprite(info.AIsAttackPart,isourpart2)
            ,attackname.."处于犹豫状态，无法发动主动战法");
        elseif(skillType == EffectType.NoCommanAttack) then
            self:InitImageAndText(false,
            BattleReportService:Instance():getAttackerOrDefenderSprite(info.AIsAttackPart,isourpart2)
            ,attackname.."处于怯战状态，无法进行普通攻击");
        elseif(skillType == EffectType.HasSameBuff) then
            self:InitImageAndText(true,
             BattleReportService:Instance():getAttackerOrDefenderSprite(info.AIsAttackPart,isourpart2)
            ,attackname.."已存在"..des);
        elseif(skillType == EffectType.HasOtherBuff) then
            self:InitImageAndText(true,
             BattleReportService:Instance():getAttackerOrDefenderSprite(info.AIsAttackPart,isourpart2)
            ,attackname.."已存在同等或更强"..des);
        elseif(skillType == EffectType.ReplaceBuff) then
            self:InitImageAndText(true,
                BattleReportService:Instance():getAttackerOrDefenderSprite(info.AIsAttackPart,isourpart2)
            ,attackname.."的"..des.."被刷新了");
        elseif(skillType == EffectType.AttackRangeNotEnough) then
            effectName = self:GetSkillName(info.EffectId);
            self:InitImageAndText(false,
            BattleReportService:Instance():getAttackerOrDefenderSprite(info.AIsAttackPart,isourpart2)
            ,attackname..effectName..des);
        elseif(skillType == EffectType.NormalAttackRangeNotEnough) then
            self:InitImageAndText(false,
            BattleReportService:Instance():getAttackerOrDefenderSprite(info.AIsAttackPart,isourpart2)
            ,attackname..des);
        elseif(skillType == EffectType.AttackBack) then
            self:InitImageAndText(false,
            BattleReportService:Instance():getAttackerOrDefenderSprite(info.AIsAttackPart,isourpart2)
            ,attackname.."进行了反击");
        elseif(skillType == EffectType.RemoveProper) then
            effectName = self:GetSkillName(info.EffectId);
                self:InitImageAndText(true,
            BattleReportService:Instance():getAttackerOrDefenderSprite(info.DIsAttackPart,isourpart1)
            ,defencename.."的来自"
            ,BattleReportService:Instance():getAttackerOrDefenderSprite(info.AIsAttackPart,isourpart2)
            ,attackname..effectName.."的"..des.."消失了");
        elseif(skillType == EffectType.DoubleAttack) then
            self:InitImageAndText(false,
            BattleReportService:Instance():getAttackerOrDefenderSprite(info.AIsAttackPart,isourpart2)
            ,attackname.."执行了两次攻击");
        elseif(skillType == EffectType.AttackTroopNum) then
            self:InitImageAndText(false,
            BattleReportService:Instance():getAttackerOrDefenderSprite(info.AIsAttackPart,isourpart2)
            ,self:GetPosition(skillparam3)..attackname.." "..skillparam.."级 兵力<color=#E6CFACFF>"..skillparam2.."</color>");
        elseif(skillType == EffectType.DefenseTroopNum) then
            self:InitImageAndText(false,
            BattleReportService:Instance():getAttackerOrDefenderSprite(info.DIsAttackPart,isourpart1)
            ,self:GetPosition(skillparam3)..attackname.." "..skillparam.."级 兵力<color=#E6CFACFF>"..skillparam2.."</color>");
        elseif(skillType == EffectType.Flight) then
            self:InitImageAndText(false,
            BattleReportService:Instance():getAttackerOrDefenderSprite(info.DIsAttackPart,isourpart1)
            ,defencename.."因大营无法再战，溃逃<color=#E6CFACFF>"..skillparam.."</color>兵力("..skillparam2..")");
        elseif(skillType == EffectType.NormalAttackDamage) then
            self:InitImageAndText(true,
            BattleReportService:Instance():getAttackerOrDefenderSprite(info.DIsAttackPart,isourpart1)
            ,defencename.."损失了<color=#E6CFACFF>"..skillparam.."</color>兵力".."("..skillparam2..")")
            if(skillparam2 == 0)then
                self:AddOverRound(BattleReportService:Instance():getAttackerOrDefenderSprite(info.DIsAttackPart,isourpart1),defencename.."无法再战");
                self.DeadCards[info.DefenceHeroId] = true;
            end
        elseif(skillType == EffectType.NoCanBeRemoveBuff) then
            self:InitImageAndText(true,
            BattleReportService:Instance():getAttackerOrDefenderSprite(info.AIsAttackPart,isourpart2)
            ,attackname.."没有可被移除的效果")
        elseif(skillType == EffectType.StopReadySkill) then
            self:InitImageAndText(true,
            BattleReportService:Instance():getAttackerOrDefenderSprite(info.AIsAttackPart,isourpart2)
            ,attackname.."的"..des.."被打断")
        elseif(skillType == EffectType.AddState) then
             self:InitImageAndText(true,
            BattleReportService:Instance():getAttackerOrDefenderSprite(info.AIsAttackPart,isourpart2)
            ,attackname..self:GetSkillName(skillparam).."的"..des.."对"..defencename.."生效!")
        elseif(skillType == EffectType.BuffNotEffect) then
            self:InitImageAndText(true,
            BattleReportService:Instance():getAttackerOrDefenderSprite(info.AIsAttackPart,isourpart2)
            ,attackname..self:GetSkillName(skillparam).."的"..des.."对"..defencename.."没有生效!")
        elseif(skillType == EffectType.ArmsAddition) then
            if(skillparam == 1) then
                self:InitImageAndText(true,
                BattleReportService:Instance():getAttackerOrDefenderSprite(info.AIsAttackPart,isourpart2)
                ,"部队获得"..skillparam3..self:GetArmys(skillparam2).."属性加成!")
            else
                self:InitImageAndText(true,
                BattleReportService:Instance():getAttackerOrDefenderSprite(info.AIsAttackPart,isourpart2)
                ,"部队获得"..skillparam3..self:GetArmys(skillparam2).."属性加成!")
            end
         elseif(skillType == EffectType.CampAddition) then
            if(skillparam == 1) then
                self:InitImageAndText(true,
                BattleReportService:Instance():getAttackerOrDefenderSprite(info.AIsAttackPart,isourpart2)
                ,"部队获得"..self:GetCamp(skillparam2).."阵营加成!")
            else
                self:InitImageAndText(true,
                BattleReportService:Instance():getAttackerOrDefenderSprite(info.AIsAttackPart,isourpart2)
                ,"部队获得"..self:GetCamp(skillparam2).."阵营加成!")
            end   
        elseif(skillType == EffectType.AdvanceAction) then
             self:InitImageAndText(true,
            BattleReportService:Instance():getAttackerOrDefenderSprite(info.AIsAttackPart,isourpart2)
            ,attackname..self:GetSkillName(skillparam).."使"..defencename.."获得先手")
        else
            if(skillType == EffectType.DoBuffDamage) then
                 self:InitImageAndText(true,BattleReportService:Instance():getAttackerOrDefenderSprite(info.DIsAttackPart,isourpart1)
                ,defencename.."由于"
                ,BattleReportService:Instance():getAttackerOrDefenderSprite(info.AIsAttackPart,isourpart2)
                ,attackname..effectName.."施加的"..des);
            else
                local temp = self:GetBuffName(skillparam3);
                self:InitImageAndText(true,
                BattleReportService:Instance():getAttackerOrDefenderSprite(info.DIsAttackPart,isourpart1)
                ,defencename.."由于"
                ,BattleReportService:Instance():getAttackerOrDefenderSprite(info.AIsAttackPart,isourpart2)
                ,attackname.."的"..effectName..","..des);
            end
            if((skillType == EffectType.DoDamage or skillType == EffectType.DoBuffDamage) and skillparam2 ==0) then  --如果这个卡牌血量为0 就显示他无法再战
                    -- print("------------无法再战------------")
                    self:AddOverRound(BattleReportService:Instance():getAttackerOrDefenderSprite(info.DIsAttackPart,isourpart1),defencename.."无法再战");
                    self.DeadCards[info.DefenceHeroId] = true;
                end
        end
    end
end

function UIBattleReportPersionRound:GetArmys(cardtype)
    local des = "";
    if(cardtype==ArmyType.Qi) then
        des = "骑兵";
    elseif(cardtype == ArmyType.Gong) then
        des = "弓兵";
    elseif(cardtype == ArmyType.Bu) then
        des = "步兵";
    end
    return des;
end

function UIBattleReportPersionRound:GetCamp(camptype)
    local des = "";
    if(camptype==CampType.Qin) then
        des = "秦";
    elseif(camptype==CampType.Janpan) then
        des = "侍";
    elseif(camptype==CampType.Europe) then
        des = "都铎";
    elseif(camptype==CampType.Viking) then
        des = "维京";
    end
    return des;
end

--返回位置 大营 中军 前锋
function UIBattleReportPersionRound:GetPosition(pos)
    if(pos ==ArmySlotType.Back) then
        return "(大营)";
    elseif(pos ==ArmySlotType.Center) then
        return "(中军)";
    else
        return "(前锋)";
    end
    return "";
end

--添加兵力为0的时候新增一条无法再战
function UIBattleReportPersionRound:AddOverRound(image,text)
    self:InitImageAndText(true,image,text)
end

--通过类型参数获取effect效果描述
function UIBattleReportPersionRound:GetDesByEffectTypeAndParam(effecttype,param,param2,param3)
    local temp = ""
    if(effecttype == EffectType.ChangeAttack) then
        if(param>=0) then
            temp ="攻击力增加<color=#E6CFACFF>"..string.format("%.1f", param/10).."</color>("..string.format("%.1f", param2/10)..")";
        else
            temp ="攻击力减少<color=#E6CFACFF>"..(-string.format("%.1f", param/10)).."</color>("..string.format("%.1f", param2/10) ..")";
        end
    end
    if(effecttype == EffectType.ChangeDefens) then
        if(param>=0) then
            temp ="防御力增加<color=#E6CFACFF>"..string.format("%.1f", param/10).."</color>("..string.format("%.1f", param2/10) ..")";
        else
            temp ="防御力减少<color=#E6CFACFF>"..(-string.format("%.1f", param/10)).."</color>("..string.format("%.1f", param2/10) ..")";
        end
    end
    if(effecttype == EffectType.ChangeStraegy) then
        if(param>=0) then
            temp ="谋略增加<color=#E6CFACFF>"..string.format("%.1f", param/10).."</color>("..string.format("%.1f", param2/10) ..")";
        else
            temp ="谋略减少<color=#E6CFACFF>"..(-string.format("%.1f", param/10)).."</color>("..string.format("%.1f", param2/10) ..")";
        end
    end
    if(effecttype == EffectType.ChangeSpeed) then
        if(param>=0) then
            temp ="速度增加<color=#E6CFACFF>"..string.format("%.1f", param/10).."</color>("..string.format("%.1f", param2/10) ..")";
        else
            temp ="速度减少<color=#E6CFACFF>"..(-string.format("%.1f", param/10)).."</color>("..string.format("%.1f", param2/10) ..")";
        end
    end
    if(effecttype == EffectType.ChangeSigeValue) then
        if(param>=0) then
            temp ="攻城值增加<color=#E6CFACFF>"..string.format("%.1f", param/10).."</color>("..string.format("%.1f", param2/10) ..")";
        else
            temp ="攻城值减少<color=#E6CFACFF>"..(-string.format("%.1f", param/10)).."</color>("..string.format("%.1f", param2/10) ..")";
        end
    end
    if(effecttype == EffectType.DoDamage) then
        temp ="损失<color=#E6CFACFF>"..param.."</color>兵力("..param2..")";
       
    end
    if(effecttype == EffectType.DoBuffDamage) then
        temp =self:GetBuffBattleReport(param3).."损失<color=#E6CFACFF>"..param.."</color>兵力("..param2..")";
       
    end
    if(effecttype == EffectType.AddState) then
        temp =self:GetAddBuffName(param2);
    end
     if(effecttype == EffectType.BuffNotEffect) then
        temp =self:GetAddBuffName(param2);
    end
    if(effecttype == EffectType.ChangeAttackRange) then
        if(param>=0) then
            temp ="攻击距离增加"..param.."("..param2..")";
        else
            temp ="攻击距离减少"..(-param).."("..param2..")";
        end
    end
    if(effecttype == EffectType.ChangeAttackPer) then
        if(param2<0)then param2 = -param2; end
        if(param>=0) then
            temp ="攻击力增加<color=#E6CFACFF>"..param.."%</color>".."("..param2..")("..param3..")";
        else
            temp ="攻击力减少<color=#E6CFACFF>"..(-param).."%</color>".."("..param2..")("..param3..")";
        end
    end
    if(effecttype == EffectType.ChangeDefensPer) then
        if(param2<0)then param2 = -param2; end
        if(param>=0) then
            temp ="防御力增加<color=#E6CFACFF>"..param.."%</color>".."("..param2..")("..param3..")";
        else
            temp ="防御力减少<color=#E6CFACFF>"..(-param).."%</color>".."("..param2..")("..param3..")";
        end
    end
    if(effecttype == EffectType.ChangeSpeedPer) then
        if(param2<0)then param2 = -param2; end
        if(param>=0) then
            temp ="速度值增加<color=#E6CFACFF>"..param.."%</color>".."("..param2..")("..param3..")";
        else
            temp ="速度值减少<color=#E6CFACFF>"..(-param).."%</color>".."("..param2..")("..param3..")";
        end
    end
    if(effecttype == EffectType.ChangeStraegyPer) then
        if(param2<0)then param2 = -param2; end
        if(param>=0) then
            temp ="谋略值增加<color=#E6CFACFF>"..param.."%</color>".."("..param2..")("..param3..")";
        else
            temp ="谋略值减少<color=#E6CFACFF>"..(-param).."%</color>".."("..param2..")("..param3..")";
        end
    end
    --[[if(effecttype == EffectType.ChangeSigeValuePer) then
        if(param>=0) then
            temp ="攻城值增加"..param.."%";
        else
            temp ="攻城值减少"..(-param).."%";
        end
    end]]
    if(effecttype == EffectType.CommonDamageAddPC) then
        if(param>=0) then
            temp ="普攻伤害增加<color=#E6CFACFF>"..param.."%</color>";
        else
            temp ="普攻伤害减少<color=#E6CFACFF>"..(-param).."%</color>";
        end
    end

    if(effecttype == EffectType.SkillDamageAddPC) then
        if(param>=0) then
            temp ="战法伤害增加<color=#E6CFACFF>"..param.."%</color>";
        else
            temp ="战法伤害减少<color=#E6CFACFF>"..(-param).."%</color>";
        end
    end

    if(effecttype == EffectType.SetPhysicsDeepenPC) then
        if(param>=0) then
            temp ="造成的物理伤害增加<color=#E6CFACFF>"..param.."%</color>";
        else
            temp ="造成的物理伤害减少<color=#E6CFACFF>"..(-param).."%</color>";
        end
    end

    if(effecttype == EffectType.SetStrategyDeepenPC) then
        if(param>=0) then
            temp ="造成的策略伤害增加<color=#E6CFACFF>"..param.."%</color>";
        else
            temp ="造成的策略伤害减少<color=#E6CFACFF>"..(-param).."%</color>";
        end
    end

    if(effecttype == EffectType.GetPhysicsDeepenPC) then
        if(param>=0) then
            temp ="受到的物理伤害增加<color=#E6CFACFF>"..param.."%</color>";
        else
            temp ="受到的物理伤害减少<color=#E6CFACFF>"..(-param).."%</color>";
        end
    end

    if(effecttype == EffectType.GetStrategyDeepenPC) then
        if(param>=0) then
            temp ="受到的策略伤害增加<color=#E6CFACFF>"..param.."%</color>";
        else
            temp ="受到的策略伤害减少<color=#E6CFACFF>"..(-param).."%</color>";
        end
    end

    if(effecttype == EffectType.HasOneState) then
        temp ="已经拥有一个状态"..param;
    end
    if(effecttype == EffectType.RecoveryTroop) then
        temp ="回复<color=#E6CFACFF>"..param.."</color>兵力("..param2..")";
    end
    if(effecttype == EffectType.RemoveBuff) then --移除的状态
        temp = self:GetAddBuffName(param);
    end
    if(effecttype == EffectType.AddBuff) then
        temp = self:GetAddBuffName(param).."已施加";
    end
    if(effecttype == EffectType.Pursuit) then
        temp = self:GetSkillName(param);
    end
    if(effecttype == EffectType.NoDoSkill) then
        temp = "禁止放技能";
    end
    if(effecttype == EffectType.NoCommanAttack) then
        temp = "禁止普攻";
    end
    if(effecttype == EffectType.HasSameBuff) then
        temp = self:GetAddBuffName(param)
    end
    if(effecttype == EffectType.HasOtherBuff) then
        temp = self:GetAddBuffName(param)
    end
    if(effecttype == EffectType.ReplaceBuff) then
        temp = self:GetAddBuffName(param)
    end
    if(effecttype == EffectType.AttackRangeNotEnough) then
        -- temp = self:GetEffectName(param).."距离"；
        temp = "的有效距离内没有目标";
    end
    if(effecttype == EffectType.NormalAttackRangeNotEnough) then
        -- temp = self:GetEffectName(param).."距离"；
        temp = "由于射程不足,无法进行攻击";
    end
    if(effecttype == EffectType.RemoveProper) then
         temp = self:GetAddBuffName(param)
    end
    if(effecttype == EffectType.StopReadySkill) then
        temp = self:GetSkillName(param);
    end
    return temp;
end

--获取相应状态的名称
function UIBattleReportPersionRound:GetStateName(state)
    local temp = "state = "..state;
    if(state == 1) then temp = "二次普通攻击";
    elseif(state == 2) then temp = "禁止普攻";
    elseif(state == 3) then temp = "禁止主动战法";
    elseif(state == 4) then temp = "禁止回复兵力";
    elseif(state == 5) then temp = "优先行动";
    elseif(state == 6) then temp = "洞察状态";
    elseif(state == 7) then temp = "无视规避";
    elseif(state == 8) then temp = "暴走状态";
    elseif(state == 9) then temp = "援护友军";
    elseif(state == 10) then temp = "挑衅状态";
    elseif(state == 11) then temp = "规避物伤";
    elseif(state == 12) then temp = "规避策伤";
    end
    return temp;
end

--获取英雄名字
function UIBattleReportPersionRound:GetHeroName(heroid,havebracket,isourpart)
    local line = DataHero[heroid];
    if(line~=nil) then
        if(havebracket) then
            if(isourpart~=nil) then
                if(isourpart == true) then
                    return Green.."【"..line.Name.."】"..colorEnd;
                end
                if(isourpart == false) then
                    return Red.."【"..line.Name.."】"..colorEnd;
                end
            end
            return "【"..line.Name.."】";
        else
            return line.Name;
        end
    end
    return "";
end

--获取id名字
function UIBattleReportPersionRound:GetSkillName(Skillid)
    local line = DataSkill[Skillid];
    if(line~=nil) then
        if(line.SkillnameText == "普通攻击") then
            return line.SkillnameText;
        else
            return "【"..line.SkillnameText.."】";
        end
    end
    return "技能id为"..Skillid;
end

--获取效果名字
function UIBattleReportPersionRound:GetEffectName(Effectid)
    if(Effectid == nil)then
        return nil;
    end
    local line = DataEffect[Effectid];
    if(line~=nil) then
        return "【"..line.Name.."】";
    end
    --return "";
    return "效果的名字没有找到 Effectid为"..Effectid;
end

--获取buff名字
function UIBattleReportPersionRound:GetBuffName(buffid)
    local line = DataBuff[buffid];
    if(line~=nil) then
        return "【"..line.Name.."】";
    end
    return "buff的名字没有找到 buffid为"..buffid;
end
--获取buff BattleReport 战报描述
function UIBattleReportPersionRound:GetBuffBattleReport(buffid)
    local line = DataBuff[buffid];
    if(line~=nil) then
        return line.BattleReport;
    end
    return "buff的战报描述没有找到 buffid为"..buffid;
end
--获取buff中BattleReport这列内容
function UIBattleReportPersionRound:GetAddBuffName(buffid)
    local line = DataBuff[buffid];
    if(line~=nil) then
        if(line.BattleReport =="" or line.BattleReport ==" ") then
            print(buffid)
        end
        return line.BattleReport;
    end
    return "buff的名字没有找到 buffid为"..buffid;
end

--初始化每一行文本
function UIBattleReportPersionRound:InitImageAndText(inner,image1,text1,image2,text2,image3,text3)
     self.roundindex = self.roundindex + 1;
    local mDetailItem = self._AllItemList:Get(self.roundindex);
    if(mDetailItem~=nil) then
        mDetailItem.gameObject:SetActive(true);
        mDetailItem:InitImageAndText(image1,text1,image2,text2,image3,text3)
        if(inner)then
             mDetailItem:SetinnerPosition();
        end
    else
        mDetailItem = DetailItem.new();
        GameResFactory.Instance():GetUIPrefab(self.DetailItemPrefab,self.Parent,mDetailItem,function (go)
            mDetailItem:Init();
            self._AllItemList:Push(mDetailItem);
            mDetailItem:InitImageAndText(image1,text1,image2,text2,image3,text3)
            if(inner)then
             mDetailItem:SetinnerPosition();
            end
        end);
    end
end

--隐藏所有的列表
function UIBattleReportPersionRound:SetAllFalse()
    for index = 1,self._AllItemList:Count() do
        self._AllItemList:Get(index).gameObject:SetActive(false);
    end
    self.DeadCards = {}
    self.roundindex = 0;
end

return UIBattleReportPersionRound