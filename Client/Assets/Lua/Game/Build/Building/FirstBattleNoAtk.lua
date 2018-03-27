local UIBase = require("Game/UI/UIBase");
local FirstBattleNoAtk = class("FirstBattleNoAtk", UIBase)

function FirstBattleNoAtk:ctor()

    FirstBattleNoAtk.super.ctor(self)

    -- 首战奖励UI界面
    self.FirstBattleNoAtkInfo = nil;
    self.wood = nil;
    self.stone = nil;
    self.iron = nil;
    self.food = nil;
    self.killMoney = nil;
    self.AtkCityMoney = nil;

end


function FirstBattleNoAtk:DoDataExchange()
    -- 首战奖励UI界面
    self.wood = self:RegisterController(UnityEngine.UI.Text, "firstBattleInfono/wood");
    self.stone = self:RegisterController(UnityEngine.UI.Text, "firstBattleInfono/stone");
    self.iron = self:RegisterController(UnityEngine.UI.Text, "firstBattleInfono/iron");
    self.food = self:RegisterController(UnityEngine.UI.Text, "firstBattleInfono/food");
    self.killMoney = self:RegisterController(UnityEngine.UI.Text, "firstBattleInfono/killmoney");
    self.AtkCityMoney = self:RegisterController(UnityEngine.UI.Text, "firstBattleInfono/citymoney");

end

function FirstBattleNoAtk:DoEventAdd()



end


function FirstBattleNoAtk:OnShow(bd)

    self.transform.parent = self.gameObject.transform:Find("WildernesUI");
    self.transform.localPosition = Vector3.New(30. - 580, 0)
    self.wood.text = bd.wood
    self.stone.text =  bd.stone;
    self.iron.text =  bd.iron;
    self.food.text =  bd.food;
    self.killMoney.text =  bd.killMoney 
    self.AtkCityMoney.text =  bd.AtkCityMoney;

end


return FirstBattleNoAtk