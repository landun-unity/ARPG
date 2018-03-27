
local UIBase = require("Game/UI/UIBase");
local UIType = require("Game/UI/UIType");
local UIService = require("Game/UI/UIService");
local UIRecruitShowCard = class("UIRecruitShowCard", UIBase);

function UIRecruitShowCard:OnUIInit()
-- 	-- body
	local UIHeroCard = require("Game/Hero/HeroCardPart/UIHeroCard").new();
    	local dataConfig = DataUIConfig[UIType.UIHeroCard];
    	if self.heroCardPrefab == nil then
		UIHeroCard = GameResFactory.Instance():GetUIPrefab(dataConfig.ResourcePath,self._Image_BackGround.gameObject.transform,UIHeroCard,function ()
		-- body
			UIHeroCard:Init();
			self.heroCardPrefab = UIHeroCard;
		end)	
	end
end


function UIRecruitShowCard:ctor()
	self.heroCardPrefab = nil;
	self._Button_BG = nil;
	self.index = 0;
	self.heroCard = nil;
end

function UIRecruitShowCard:DoDataExchange()
	-- body
	self._Button_BG = self:RegisterController(UnityEngine.UI.Button, "BGButton");
	self._Image_BackGround = self:RegisterController(UnityEngine.UI.Image,"BackGround");
end

function UIRecruitShowCard:DoEventAdd()
	-- body
	self:AddListener(self._Button_BG, self.BGButtonOnClick);
end

function UIRecruitShowCard:OnShow()
	-- body
	self:OnUIInit();
	self.heroCardPrefab.gameObject.transform.localScale = Vector3.New(1.5,1.5,0);
	self.heroCard = nil;
	self:BGButtonOnClick() 
end

function UIRecruitShowCard:BGButtonOnClick()
	-- body	
	-- print( self.heroCard )
	if self.heroCard ~= nil then
		RecruitService:Instance():RemoveNeedEffectShowCard(self.heroCard);
	end
	 -- print("NeedEffectShowCardListCount = "..RecruitService:Instance():GetNeedEffectShowCardListCount())
	if RecruitService:Instance():GetNeedEffectShowCardListCount() <=0 then
		-- print("HideUI");
		UIService:Instance():HideUI(UIType.FourStarHeroEffect);
		return;
	end
	self.heroCard = RecruitService:Instance():GetNeedEffectShowCardByIndex(1);
	-- print(self.heroCard)
	if self.heroCard ~= nil then
		-- print("sssssssssssssssssssssssssssssssssssssss")
		self.heroCardPrefab:SetRecruitHeroCard(self.heroCard._cardId,self.heroCard._cardTableId,self.heroCard._cardLevel);
	end
end

-- function UIRecruitShowCard:OnHide()
-- 	-- body
-- 	self.heroCardPrefab.gameObject:Destory();
-- end

return UIRecruitShowCard;