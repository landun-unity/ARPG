
local UIBase = require("Game/UI/UIBase");
local ArmyRemoveCardTipUI = class("ArmyRemoveCardTipUI",UIBase)

function ArmyRemoveCardTipUI:ctor()
    
    ArmyRemoveCardTipUI.super.ctor(self)
    self.tipWoodText = nil;
    self.tipIronText = nil;
    self.tipFoodText = nil;
    self.tipGoldText = nil;
    self.tipCancleBtn = nil;
    self.tipConfirmBtn = nil;

    self.confirmCallBack = nil;     --确定移除卡牌回调
    self.heroCard = nil;
end


function ArmyRemoveCardTipUI:DoDataExchange()
    self.tipWoodText = self:RegisterController(UnityEngine.UI.Text,"RemoveCardTip/AffirmImage/DownPart/WoodImage/ValueText");
    self.tipIronText = self:RegisterController(UnityEngine.UI.Text,"RemoveCardTip/AffirmImage/DownPart/IronImage/ValueText");
    self.tipFoodText = self:RegisterController(UnityEngine.UI.Text,"RemoveCardTip/AffirmImage/DownPart/FoodImage/ValueText");
    self.tipGoldText = self:RegisterController(UnityEngine.UI.Text,"RemoveCardTip/AffirmImage/DownPart/GoldImage/ValueText");
    self.tipCancleBtn = self:RegisterController(UnityEngine.UI.Button,"RemoveCardTip/AffirmImage/CancelButton");
    self.tipConfirmBtn = self:RegisterController(UnityEngine.UI.Button,"RemoveCardTip/AffirmImage/ConfirmButton");
end

function ArmyRemoveCardTipUI:DoEventAdd()
    self:AddListener(self.tipCancleBtn,self.OnClickCancleBtn);
    self:AddListener(self.tipConfirmBtn,self.OnClickConfirmBtn);
end

function ArmyRemoveCardTipUI:OnShow(heroCard)
    if heroCard == nil then
       -- print("heroCard is nil !!!!!!!!!!")
        return;
    end
    self.heroCard = heroCard;
    --print("当前要移除的卡牌的兵力:"..heroCard.troop);

    local troopCount = math.ceil((heroCard.troop - 100)*0.8);
    --print(troopCount);

    local mHeroData = DataHero[heroCard.tableID];  --静态表 
    local mResourceData = ArmyService:Instance():GetCardDataConscriptionResources(mHeroData.Star,mHeroData.Camp+1,mHeroData.BaseArmyType);
    
    self.tipWoodText.text = mResourceData.Wood * troopCount;
    self.tipIronText.text = mResourceData.Iorn * troopCount;
    self.tipFoodText.text = mResourceData.Food * troopCount;
    self.tipGoldText.text = 0;
end

--确定移除卡牌回调
function ArmyRemoveCardTipUI:RegistConfirmEvnet(callBack)
    self.confirmCallBack = callBack;
end

function ArmyRemoveCardTipUI:OnClickCancleBtn()
    UIService:Instance():HideUI(UIType.ArmyRemoveCardTipUI);
end

function ArmyRemoveCardTipUI:OnClickConfirmBtn()
    UIService:Instance():HideUI(UIType.ArmyRemoveCardTipUI);
    if  self.confirmCallBack ~= nil then
        self.confirmCallBack();
    end
end


return ArmyRemoveCardTipUI