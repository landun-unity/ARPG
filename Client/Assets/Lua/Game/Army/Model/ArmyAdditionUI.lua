--region *.lua
--Date
local UIBase = require("Game/UI/UIBase");
local ArmyAdditionUI = class("ArmyAdditionUI",UIBase)

function ArmyAdditionUI:ctor()
    
    ArmyAdditionUI.super.ctor(self)

    self.exitBtn = nil;
    self.exitBgBtn = nil;
    
    self.soliderText = nil;
    self.campText = nil;
    self.titleText = nil;

    self.soliderNoneText = nil;
    self.campNoneText = nil;
    self.titleNoneText = nil;

    self.soliderAddText = nil;
    self.campAddText = nil;
    self.titleAddText = nil;
end


function ArmyAdditionUI:DoDataExchange()
    self.exitBtn = self:RegisterController(UnityEngine.UI.Button,"BackgroundImage/ExitButton");
    self.exitBgBtn = self:RegisterController(UnityEngine.UI.Button,"Panel");
    
    self.soliderText = self:RegisterController(UnityEngine.UI.Text,"BackgroundImage/Grid/SoliderAdditionItem/SoliderText");
    self.campText = self:RegisterController(UnityEngine.UI.Text,"BackgroundImage/Grid/CampAdditionItem/CampText");
    self.titleText = self:RegisterController(UnityEngine.UI.Text,"BackgroundImage/Grid/TitleAdditionItem/TitleText");

    self.soliderNoneText = self:RegisterController(UnityEngine.UI.Text,"BackgroundImage/Grid/SoliderAdditionItem/NoneText");
    self.campNoneText = self:RegisterController(UnityEngine.UI.Text,"BackgroundImage/Grid/CampAdditionItem/NoneText");
    self.titleNoneText = self:RegisterController(UnityEngine.UI.Text,"BackgroundImage/Grid/TitleAdditionItem/NoneText");

    self.soliderAddText = self:RegisterController(UnityEngine.UI.Text,"BackgroundImage/Grid/SoliderAdditionItem/AddedText");
    self.campAddText = self:RegisterController(UnityEngine.UI.Text,"BackgroundImage/Grid/CampAdditionItem/AddedText");
    self.titleAddText = self:RegisterController(UnityEngine.UI.Text,"BackgroundImage/Grid/TitleAdditionItem/AddedText");
end

function ArmyAdditionUI:DoEventAdd()

    self:AddOnClick(self.exitBtn,self.OnCilckExitBtn);
    self:AddOnClick(self.exitBgBtn,self.OnCilckExitBtn);

end


function ArmyAdditionUI:OnShow(armyInfo)
    if armyInfo == nil then     
        self.soliderNoneText.gameObject:SetActive(true);
        self.campNoneText.gameObject:SetActive(true);
        self.titleNoneText.gameObject:SetActive(true);
        self.soliderAddText.gameObject:SetActive(false);
        self.campAddText.gameObject:SetActive(false);
        self.titleAddText.gameObject:SetActive(false);
        self.soliderText.text = "兵种加成";
        self.campText.text = "阵营加成";
        self.titleText.text = "称号加成";
        return;
    else
        --兵种加成
        local soldierAdd = armyInfo:CheckSoldierAddition();
        if soldierAdd == true then
            self.soliderNoneText.gameObject:SetActive(false);
            self.soliderAddText.gameObject:SetActive(true);
            local addedSoldierType = armyInfo:GetAddedSoldierType();
            self.soliderText.text = "兵种加成-"..self:GetArmySoldierTypeName(addedSoldierType);
            local addAttributesString = self:GetAddedAttrString(addedSoldierType,armyInfo,false);
            self.soliderAddText.text = addAttributesString.."\n"..self:GetAddedCardName(addedSoldierType,armyInfo,false);
        else
            self.soliderAddText.gameObject:SetActive(false);
            self.soliderNoneText.gameObject:SetActive(true);
        end
        --阵营加成
        local campAdd = armyInfo:CheckCampAddition();
        if campAdd == true then
            self.campNoneText.gameObject:SetActive(false);
            self.campAddText.gameObject:SetActive(true);
            local addedCamp = armyInfo:GetAddedCamp();
            self.campText.text = "阵营加成-"..self:GetCampName(addedCamp);
            local addAttributesString = self:GetAddedAttrString(addedCamp,armyInfo,true);
            self.campAddText.text = addAttributesString.."\n"..self:GetAddedCardName(addedCamp,armyInfo,true);
        else
            self.campAddText.gameObject:SetActive(false);
            self.campNoneText.gameObject:SetActive(true);
        end 
        --称号加成
        local titleAdd = armyInfo:CheckTitleAddition();
        if titleAdd == true then
            self.titleNoneText.gameObject:SetActive(false);
            self.titleAddText.gameObject:SetActive(true);
            --self.titleAddText.text = "";

        else
            self.titleAddText.gameObject:SetActive(false);
            self.titleNoneText.gameObject:SetActive(true);
        end    
    end
end

function ArmyAdditionUI:GetArmySoldierTypeName(baseType) 
    local name ="";
    if baseType == 1 then 
        name = "骑兵";
    elseif  baseType == 2 then 
        name = "弓兵";
    elseif  baseType == 3 then 
        name = "步兵";
    end
    return  name;  
end

function ArmyAdditionUI:GetCampName(camp) 
    local name ="";
    if camp == 1 then 
        name = "秦";
    elseif  camp == 2 then 
        name = "侍";
    elseif  camp == 3 then 
        name = "都铎";
    elseif  camp == 4 then 
        name = "维京";
    end
    return  name;  
end

--加成的卡牌名字
function ArmyAdditionUI:GetAddedCardName(camp,armyInfo,isCampAdd)
    local nameString = "受益武将： ";
    local count = armyInfo:GetCardCount();
    local index=0;
    for k, v in pairs(armyInfo.cardArray) do
        index = index +1;
        local heroData = DataHero[v.tableID];
        if isCampAdd == true then           
            if heroData ~= nil then
                if heroData.Camp == camp then
                    if index< count then
                        nameString = nameString.."<color=#FFFF00>"..heroData.Name.."</color>,";
                    else
                        nameString = nameString.."<color=#FFFF00>"..heroData.Name.."</color>";
                    end
                end
            end
        else
            if heroData ~= nil then
                --高级兵种类型比较前要装换为基本类型
                if v.baseArmy == camp then
                    if index< count then
                        nameString = nameString.."<color=#FFFF00>"..heroData.Name.."</color>,";
                    else
                        nameString = nameString.."<color=#FFFF00>"..heroData.Name.."</color>";
                    end
                end
            end
        end
    end
    return nameString;
end

--加成属性描述
function ArmyAdditionUI:GetAddedAttrString(camp,armyInfo,isCampAdd)
    local attrString = "";
    local building = BuildingService:Instance():GetBuilding(armyInfo.spawnBuildng)
    
    local count =0;   
    local campAdditionData= nil;
    if isCampAdd == true then 
        campAdditionData = ArmyService:Instance():GetCampAdditionData(camp);
        count = armyInfo:GetGetAddedCampCardCount();
    else
        campAdditionData = ArmyService:Instance():GetSoldierAdditionData(camp);
        count = armyInfo:GetGetAddedSoldierCardCount();
    end
    local buildId =0;
    local buildLevelAdded =0;
    if isCampAdd == true then
        if building._dataInfo.Type == BuildingType.MainCity then    
            buildId = campAdditionData.ConstructionType[1];    
        elseif building._dataInfo.Type == BuildingType.SubCity then
            buildId = campAdditionData.ConstructionType[2];
        end
        local curLevel = building:GetFacilitylevelByIndex(DataConstruction[buildId].Type);
        buildLevelAdded = DataConstruction[buildId].ConstructionFunctionParameter1[curLevel];
    end

    if count== 2 then
        local allAdded =0; 
        if campAdditionData.TwoMemberAttackBonus~= 0 then
            if isCampAdd == true then
                allAdded = (buildLevelAdded+campAdditionData.TwoMemberAttackBonus)/100;
            else
                allAdded = campAdditionData.TwoMemberAttackBonus/100;
            end
            --allAdded = (buildLevelAdded+campAdditionData.TwoMemberAttackBonus)/100;
            attrString = attrString.."攻击属性提高"..allAdded.."%  ";
        end
        if campAdditionData.TwoMemberDefenseBonus~= 0 then
            if isCampAdd == true then
                allAdded = (buildLevelAdded+campAdditionData.TwoMemberDefenseBonus)/100;
            else
                allAdded = campAdditionData.TwoMemberDefenseBonus/100;
            end 
            --allAdded = (buildLevelAdded+campAdditionData.TwoMemberDefenseBonus)/100;
            attrString = attrString.."防御属性提高"..allAdded.."%  ";
        end
        if campAdditionData.TwoMemberSpiritBonus~= 0 then
            if isCampAdd == true then
                allAdded = (buildLevelAdded+campAdditionData.TwoMemberSpiritBonus)/100;
            else
                allAdded = campAdditionData.TwoMemberSpiritBonus/100;
            end  
            --allAdded = (buildLevelAdded+campAdditionData.TwoMemberSpiritBonus)/100;
            attrString = attrString.."谋略属性提高"..allAdded.."%  ";
        end
        if campAdditionData.TwoMemberSpeedBonus~= 0 then
            if isCampAdd == true then
                allAdded = (buildLevelAdded+campAdditionData.TwoMemberSpeedBonus)/100;
            else
                allAdded = campAdditionData.TwoMemberSpeedBonus/100;
            end  
            --allAdded = (buildLevelAdded+campAdditionData.TwoMemberSpeedBonus)/100;
            attrString = attrString.."速度属性提高"..allAdded.."%  ";
        end
        if campAdditionData.TwoMemberSiegeBonus~= 0 then
            if isCampAdd == true then
                allAdded = (buildLevelAdded+campAdditionData.TwoMemberSiegeBonus)/100;
            else
                allAdded = campAdditionData.TwoMemberSiegeBonus/100;
            end  
            --allAdded = (buildLevelAdded+campAdditionData.TwoMemberSiegeBonus)/100;
            attrString = attrString.."攻城属性提高"..allAdded.."%  ";
        end           
    elseif count== 3 then 
        if campAdditionData.ThreeMemberAttackBonus~= 0 then
            if isCampAdd == true then
                allAdded = (buildLevelAdded+campAdditionData.ThreeMemberAttackBonus)/100;
            else
                allAdded = campAdditionData.ThreeMemberAttackBonus/100;
            end  
            --allAdded = (buildLevelAdded+campAdditionData.ThreeMemberAttackBonus)/100;
            attrString = attrString.."攻击属性提高"..allAdded.."%  ";
        end
        if campAdditionData.ThreeMemberDefenseBonus~= 0 then
            if isCampAdd == true then
                allAdded = (buildLevelAdded+campAdditionData.ThreeMemberDefenseBonus)/100;
            else
                allAdded = campAdditionData.ThreeMemberDefenseBonus/100;
            end  
            --allAdded = (buildLevelAdded+campAdditionData.ThreeMemberDefenseBonus)/100;
            attrString = attrString.."防御属性提高"..allAdded.."%  ";
        end
        if campAdditionData.ThreeMemberSpiritBonus~= 0 then
            if isCampAdd == true then
                allAdded = (buildLevelAdded+campAdditionData.ThreeMemberSpiritBonus)/100;
            else
                allAdded = campAdditionData.ThreeMemberSpiritBonus/100;
            end 
            --allAdded = (buildLevelAdded+campAdditionData.ThreeMemberSpiritBonus)/100;
            attrString = attrString.."谋略属性提高"..allAdded.."%  ";
        end
        if campAdditionData.ThreeMemberSpeedBonus~= 0 then 
            if isCampAdd == true then
                allAdded = (buildLevelAdded+campAdditionData.ThreeMemberSpeedBonus)/100;
            else
                allAdded = campAdditionData.ThreeMemberSpeedBonus/100;
            end 
            --allAdded = (buildLevelAdded+campAdditionData.ThreeMemberSpeedBonus)/100;
            attrString = attrString.."速度属性提高"..allAdded.."%  ";
        end
        if campAdditionData.ThreeMemberSiegeBonus~= 0 then
            if isCampAdd == true then
                allAdded = (buildLevelAdded+campAdditionData.ThreeMemberSiegeBonus)/100;
            else
                allAdded = campAdditionData.ThreeMemberSiegeBonus/100;
            end  
            --allAdded = (buildLevelAdded+campAdditionData.ThreeMemberSiegeBonus)/100;
            attrString = attrString.."攻城属性提高"..allAdded.."%  ";
        end 
    end
    return attrString;
end

--关闭界面
function ArmyAdditionUI:OnCilckExitBtn() 
    UIService:Instance():HideUI(UIType.ArmyAdditionUI);
end

return ArmyAdditionUI
