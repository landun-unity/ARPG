local UIBase = require("Game/UI/UIBase")

local ExplainPanel = class("ExplainPanel",UIBase)
local UIService=require("Game/UI/UIService")
local UIType=require("Game/UI/UIType")


function ExplainPanel:ctor()
	ExplainPanel.super.ctor(self)
	self.Confirm = nil;
	self.Text = nil;
end


--注册控件
function ExplainPanel:DoDataExchange()
	self.Confirm = self:RegisterController(UnityEngine.UI.Button,"OneBottomImage/Confirm");
	self.Text = self:RegisterController(UnityEngine.UI.Text,"Image/Text");
end

--注册控件点击事件
function ExplainPanel:DoEventAdd()
	self:AddListener(self.Confirm,self.OnClickConfirm);
end

function ExplainPanel:OnClickConfirm()
	UIService:Instance():HideUI(UIType.ExplainPanel);
end

function ExplainPanel:OnShow(buildingType)
	self.buildingType = buildingType;
	self:SetText();
end

function ExplainPanel:SetText()
	if self.buildingType == BuildingType.MainCity then
		self.Text.text = " \n  <color=#e2bd75>【主城简介】</color>\n是势力的根本。可在城内进行设施建造，部队配置，部队征兵、扩建操作。\n  <color=#e2bd75>【主城视野】</color>\n以主城为中心的5格土地范围内，是主城的视野范围。视野范围内可查看到其他势力的部队信息、建造中的要塞。可与同盟成员共享视野。\n  <color=#e2bd75>【主城沦陷】</color>\n主城耐久被敌方同盟队部降低到0时会处于沦陷状态,并会失去一定数量的资源与领地,敌方同盟成员则可以借沦陷领地地出征。可上缴资源给敌方同盟进行反叛,脱离沦陷。(注意:只有加入同盟后才能使敌方沦陷)"
	elseif self.buildingType == BuildingType.PlayerFort then
		self.Text.text = "\n  <color=#e2bd75>【要塞简介】</color>\n可调动放置部队到要塞中,并允许1支部队在内征兵,适合前线征战的部队休整。\n  <color=#e2bd75>【要塞视野】</color>\n以要塞为中心的2格土地范围内，是要塞的视野范围。视野范围内可查看到其他势力的部队信息、建造中的要塞。可与同盟成员共享视野。\n  <color=#e2bd75>【要塞拆除】</color>\n可在堡垒设施界面中手动拆除,或受到地方部队攻击,耐久降为0时被拆除。";
	elseif self.buildingType == BuildingType.SubCity then
		self.Text.text = "\n  <color=#e2bd75>【分城简介】</color>\n与主城功能类似,可在城内进行设施建造,部队配置、部队征兵、扩建操作。\n  <color=#e2bd75>【分城视野】</color>\n以分城为中心的4格土地范围内，是分城的视野范围。视野范围内可查看到其他势力的部队信息。可与同盟成员共享视野。\n  <color=#e2bd75>【分城拆除】</color>\n可在都督府设施界面中手动拆除。或受到敌方部队攻击,耐久降为0时被拆除。分城拆除后会变成废墟,在废墟上重建分城可保留原分城建造的设施,但设施等级会随机下降。";
	elseif self.buildingType == BuildingType.WildFort then
		self.Text.text = "\n  <color=#e2bd75>【要塞简介】</color>\n可调动放置5只部队到要塞中,并允许1支部队在内征兵。适合前线征战的部队休整。\n  <color=#e2bd75>【要塞视野】</color>\n以要塞为中心的2格土地范围内，是要塞的视野范围。视野范围内可查看到其他势力的部队信息。可与同盟成员共享视野。\n  <color=#e2bd75>【放弃或失去要塞】</color>\n可点击地块并选择放弃功能放弃要塞,或受到敌方部队攻击,耐久降为0时被地方占领";
	end
end

return ExplainPanel;