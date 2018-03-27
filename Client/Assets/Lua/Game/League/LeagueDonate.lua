-- region *.lua
-- Date
local UIBase = require("Game/UI/UIBase");
local LeagueDonate = class("LeagueDonate", UIBase)
local DataAlliesLevel = require("Game/Table/model/DataAlliesLevel")

function LeagueDonate:ctor()

    LeagueDonate.super.ctor(self)
    self.donateExp = 0;
    self.level = 0;
    self.Maxexp = 0;
    self.expSlider = nil
    self.wood = 0
    self.woodSlider = 0;
    self.woodmax = 0;
    self.metal = 0;
    self.metalSlider = 0;
    self.metalmax = 0;
    self.rock = 0;
    self.rockSlider = 0;
    self.rockmax = 0;
    self.food = 0;
    self.foodSlider = 0;
    self.foodmax = 0;
    self.confirmBtn = nil;
    self.backBtn = nil;

    -- 木石铁粮
    self.mywood = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Wood):GetValue(wood)
    self.mymetal = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Iron):GetValue(iron)
    self.myrock = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Stone):GetValue(stone)
    self.myfood = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Grain):GetValue(grain)
    --- 临时数据（木石铁粮）
    self.MaxSize = 300000
    self.MinSize = 100000
end


function LeagueDonate:DoDataExchange()

    self.donateExp = self:RegisterController(UnityEngine.UI.Text, "Image3/DonateExp")
    self.level = self:RegisterController(UnityEngine.UI.Text, "Level")
    self.Maxexp = self:RegisterController(UnityEngine.UI.Text, "Slider/Exp")
    self.expSlider = self:RegisterController(UnityEngine.UI.Slider, "Slider")
    self.wood = self:RegisterController(UnityEngine.UI.Text, "resources/wood/woodnum")
    self.woodSlider = self:RegisterController(UnityEngine.UI.Slider, "resources/wood/Sliderwood")
    self.woodmax = self:RegisterController(UnityEngine.UI.Text, "resources/wood/maxwood")

    self.metal = self:RegisterController(UnityEngine.UI.Text, "resources/metal/metalnum")
    self.metalSlider = self:RegisterController(UnityEngine.UI.Slider, "resources/metal/Slidermetal")
    self.metalmax = self:RegisterController(UnityEngine.UI.Text, "resources/metal/maxmetal")

    self.rock = self:RegisterController(UnityEngine.UI.Text, "resources/rock/rocknum")
    self.rockSlider = self:RegisterController(UnityEngine.UI.Slider, "resources/rock/Sliderrock")
    self.rockmax = self:RegisterController(UnityEngine.UI.Text, "resources/rock/maxrock")
    self.food = self:RegisterController(UnityEngine.UI.Text, "resources/food/foodnum")
    self.foodSlider = self:RegisterController(UnityEngine.UI.Slider, "resources/food/Sliderfood")
    self.foodmax = self:RegisterController(UnityEngine.UI.Text, "resources/food/maxfood")
    self.confirmBtn = self:RegisterController(UnityEngine.UI.Button, "confirm")
    self.backBtn = self:RegisterController(UnityEngine.UI.Button, "back")
end

function LeagueDonate:DoEventAdd()

    self:AddListener(self.confirmBtn, self.OnClickconfirmBtn)
    self:AddListener(self.backBtn, self.OnClickbackBtn)
    self:AddSliderOnValueChanged(self.woodSlider, self.woodSliderChanged);
    self:AddSliderOnValueChanged(self.metalSlider, self.metalSliderChanged);
    self:AddSliderOnValueChanged(self.rockSlider, self.rockSliderChanged);
    self:AddSliderOnValueChanged(self.foodSlider, self.foodSliderChanged);

end


function LeagueDonate:OnShow()

    self:ReShow();

end



function LeagueDonate:ReShow()
    self.woodSlider.value = 0
    self.metalSlider.value = 0
    self.rockSlider.value = 0
    self.foodSlider.value = 0
    self.mywood = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Wood):GetValue(wood)
    self.mymetal = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Iron):GetValue(iron)
    self.myrock = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Stone):GetValue(stone)
    self.myfood = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Grain):GetValue(grain)
    if self.mywood == 0 then
        self.woodSlider.maxValue = 0;
    else
        self.woodSlider.maxValue = 1;
    end

    if self.mymetal == 0 then
        self.metalSlider.maxValue = 0;
    else
        self.metalSlider.maxValue = 1;
    end
    if self.myfood == 0 then
        self.foodSlider.maxValue = 0;
    else
        self.foodSlider.maxValue = 1;
    end
    if self.myrock == 0 then
        self.rockSlider.maxValue = 0;
    else
        self.rockSlider.maxValue = 1;
    end
    self.level.text = LeagueService:Instance():GetMyLeagueInfo().level
    local league = LeagueService:Instance():GetMyLeagueInfo();
    self.Maxexp.text = league.exp - DataAlliesLevel[league.level].SumExp + DataAlliesLevel[league.level].UpgradeXP .. "/" .. DataAlliesLevel[league.level].UpgradeXP;
    self.expSlider.value =(league.exp - DataAlliesLevel[league.level].SumExp + DataAlliesLevel[league.level].UpgradeXP) / DataAlliesLevel[league.level].UpgradeXP;
    self.woodmax.text = self.mywood
    self.metalmax.text = self.mymetal
    self.rockmax.text = self.myrock
    self.foodmax.text = self.myfood
    self.donateExp.text = "0";
end

function LeagueDonate:OnValueChange() 
    local num = tonumber(self.donateExp.text) / 10
    local league = LeagueService:Instance():GetMyLeagueInfo();
    self.Maxexp.text = league.exp - DataAlliesLevel[league.level].SumExp + DataAlliesLevel[league.level].UpgradeXP + num .. "/" .. DataAlliesLevel[league.level].UpgradeXP;
    self.expSlider.value =(league.exp - DataAlliesLevel[league.level].SumExp + DataAlliesLevel[league.level].UpgradeXP) + num / DataAlliesLevel[league.level].UpgradeXP;
    self.level.text = "Lv.".. self:GetLevel(league.exp, num)
end


function LeagueDonate:GetLevel(exp, num)

    for k, v in pairs(DataAlliesLevel) do
        if v.SumExp > exp + num then
            if v.ID == 50 then
                return v.ID
            end
            return v.ID
        end
    end

end


function LeagueDonate:woodSliderChanged()
    self.wood.text = math.floor(self.woodSlider.value * self.mywood)
    if self.mywood >= self.MaxSize then
        if self.woodSlider.value > 1 / 3 then
            self.woodSlider.value = 1 / 3
        end
    else
        if self.woodSlider.value > self.MinSize / self.mywood then
            self.woodSlider.value = self.MinSize / self.mywood
            self.wood.text = self.MinSize
        end
    end
    self.donateExp.text = math.floor((tonumber(self.wood.text) + tonumber(self.metal.text) + tonumber(self.rock.text) + tonumber(self.food.text)) / 100)
    self:OnValueChange()
end

function LeagueDonate:metalSliderChanged()
    self.metal.text = math.floor(self.metalSlider.value * self.mymetal)
    if self.mymetal >= self.MaxSize then
        if self.metalSlider.value > 1 / 3 then
            self.metalSlider.value = 1 / 3
        end
    else
        if self.metalSlider.value > self.MinSize / self.mymetal then
            self.metalSlider.value = self.MinSize / self.mymetal
            self.metal.text = self.MinSize
        end
    end
    self.donateExp.text = math.floor((tonumber(self.wood.text) + tonumber(self.metal.text) + tonumber(self.rock.text) + tonumber(self.food.text)) / 100)
    self:OnValueChange()
end

function LeagueDonate:rockSliderChanged()
    self.rock.text = math.floor(self.rockSlider.value * self.myrock)
    if self.myrock >= self.MaxSize then
        if self.rockSlider.value > 1 / 3 then
            self.rockSlider.value = 1 / 3
        end
    else
        if self.rockSlider.value > self.MinSize / self.myrock then
            self.rockSlider.value = self.MinSize / self.myrock
            self.rock.text = self.MinSize
        end
    end
    self.donateExp.text = math.floor((tonumber(self.wood.text) + tonumber(self.metal.text) + tonumber(self.rock.text) + tonumber(self.food.text)) / 100)
    self:OnValueChange()
end

function LeagueDonate:foodSliderChanged()

    self.food.text = math.floor(self.foodSlider.value * self.myfood)
    if self.myfood >= self.MaxSize then
        if self.foodSlider.value > 1 / 3 then
            self.foodSlider.value = 1 / 3

        end
    else
        if self.foodSlider.value > self.MinSize / self.myfood then
            self.foodSlider.value = self.MinSize / self.myfood
            self.food.text = self.MinSize

        end
    end
    self.donateExp.text = math.floor((tonumber(self.wood.text) + tonumber(self.metal.text) + tonumber(self.rock.text) + tonumber(self.food.text)) / 100)
    self:OnValueChange()
end


function LeagueDonate:OnClickconfirmBtn()

    LeagueService:Instance():SetDonateValue(math.ceil((tonumber(self.wood.text) + tonumber(self.metal.text) + tonumber(self.rock.text) + tonumber(self.food.text))))
    LeagueService:Instance():SendLeagueDonate(LeagueService:Instance():GetMyLeagueInfo().leagueid, self.woodSlider.value * self.mywood, self.metalSlider.value * self.mymetal, self.foodSlider.value * self.myfood, self.rockSlider.value * self.myrock)

end

function LeagueDonate:OnClickbackBtn()

    UIService:Instance():HideUI(UIType.LeagueDonate)

end

return LeagueDonate
-- endregion
