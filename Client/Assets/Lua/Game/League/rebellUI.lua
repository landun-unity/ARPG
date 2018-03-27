-- region *.lua
-- Date
local UIBase = require("Game/UI/UIBase");
local rebellUI = class("rebellUI", UIBase)
local DataAlliesLevel = require("Game/Table/model/DataAlliesLevel")

function rebellUI:ctor()

    rebellUI.super.ctor(self)
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
    self.enough = nil;

    self.data = nil;
    -- 木石铁粮
    self.mywood = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Wood):GetValue(wood)
    self.mymetal = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Iron):GetValue(iron)
    self.myrock = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Stone):GetValue(stone)
    self.myfood = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Grain):GetValue(grain)

    self.maxValue = nil;

end


function rebellUI:DoDataExchange()

    self.introUI = self:RegisterController(UnityEngine.Transform, "IntroUI")
    self.ok = self:RegisterController(UnityEngine.UI.Button, "IntroUI/ok")
    self.enough = self:RegisterController(UnityEngine.Transform, "enough")
    self.intro = self:RegisterController(UnityEngine.UI.Button, "Button")

    self.donateExp = self:RegisterController(UnityEngine.UI.Text, "rebellExp")
    self.superLeagueBtn = self:RegisterController(UnityEngine.UI.Button, "superLeagueName")
    self.level = self:RegisterController(UnityEngine.UI.Text, "superLeagueName/upLeagueName")
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
    self.confirmBtnText = self:RegisterController(UnityEngine.UI.Text, "confirm/Text")

end

function rebellUI:DoEventAdd()
    self:AddListener(self.ok, self.OnClickokBtn)
    self:AddListener(self.intro, self.OnClickintroBtn)
    self:AddListener(self.confirmBtn, self.OnClickconfirmBtn)
    self:AddListener(self.backBtn, self.OnClickbackBtn)
    self:AddSliderOnValueChanged(self.woodSlider, self.woodSliderChanged);
    self:AddSliderOnValueChanged(self.metalSlider, self.metalSliderChanged);
    self:AddSliderOnValueChanged(self.rockSlider, self.rockSliderChanged);
    self:AddSliderOnValueChanged(self.foodSlider, self.foodSliderChanged);
    self:AddListener(self.superLeagueBtn, self.OnClickSuperLeagueName)

end


function rebellUI:OnShow(data)

    self.data = data
    self:ReShow();

end


function rebellUI:OnClickintroBtn()

    self.introUI.gameObject:SetActive(true)

end

function rebellUI:OnClickokBtn()

    self.introUI.gameObject:SetActive(false)

end


function rebellUI:OnClickSuperLeagueName()
    local superLeagueId = PlayerService:Instance():GetsuperiorLeagueId()
    LeagueService:Instance():SendOpenAppiontLeague(nil, superLeagueId)
end


function rebellUI:ReShow()



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
    self.level.text = PlayerService:Instance():GetsuperiorName()
    self.Maxexp.text = self.data.curRevolt .. "/" .. self.data.maxRevolt
    self.expSlider.value = self.data.curRevolt / self.data.maxRevolt
    if self.expSlider.value > 1 then
        self.expSlider.value = 1
    end
    self.woodmax.text = self.mywood
    self.metalmax.text = self.mymetal
    self.rockmax.text = self.myrock
    self.foodmax.text = self.myfood
    if self.data.curRevolt >= self.data.maxRevolt then
        self.confirmBtnText.text = "确认反叛"
        self.enough.gameObject:SetActive(true)
        return;
    else
        self.confirmBtnText.text = "捐献"
        self.enough.gameObject:SetActive(false)
    end
end

function rebellUI:woodSliderChanged()
    if (self.woodSlider.value * self.mywood) >= self.data.maxRevolt then
        self.wood.text = self.data.maxRevolt
    end
    if self.woodSlider.value * self.mywood >= self.data.maxRevolt - self.foodSlider.value * self.myfood - self.rockSlider.value * self.myrock - self.metalSlider.value * self.mymetal then
        self.woodSlider.value =(self.data.maxRevolt - self.foodSlider.value * self.myfood - self.rockSlider.value * self.myrock - self.metalSlider.value * self.mymetal - self.data.curRevolt) / self.mywood;
    end
    self.wood.text = math.floor(self.woodSlider.value * self.mywood+0.5)
    self.donateExp.text = math.floor((tonumber(self.wood.text) + tonumber(self.metal.text) + tonumber(self.rock.text) + tonumber(self.food.text)))
end

function rebellUI:metalSliderChanged()
    if (self.metalSlider.value * self.mymetal) >= self.data.maxRevolt then
        self.metal.text = self.data.maxRevolt
    end
    if self.metalSlider.value * self.mymetal >= self.data.maxRevolt - self.foodSlider.value * self.myfood - self.rockSlider.value * self.myrock - self.woodSlider.value * self.mywood then
        self.metalSlider.value =(self.data.maxRevolt - self.foodSlider.value * self.myfood - self.rockSlider.value * self.myrock - self.woodSlider.value * self.mywood - self.data.curRevolt) / self.mymetal
    end
    self.metal.text = math.floor(self.metalSlider.value * self.mymetal+0.5)
    self.donateExp.text = math.floor((tonumber(self.wood.text) + tonumber(self.metal.text) + tonumber(self.rock.text) + tonumber(self.food.text)))
end

function rebellUI:rockSliderChanged()
    if (self.rockSlider.value * self.myrock) >= self.data.maxRevolt then
        self.rock.text = self.data.maxRevolt
    end
    if self.rockSlider.value * self.myrock >= self.data.maxRevolt - self.foodSlider.value * self.myfood - self.metalSlider.value * self.mymetal - self.woodSlider.value * self.mywood then

        self.rockSlider.value =(self.data.maxRevolt - self.foodSlider.value * self.myfood - self.metalSlider.value * self.mymetal - self.woodSlider.value * self.mywood - self.data.curRevolt) / self.myrock
    end
    self.rock.text = math.floor(self.rockSlider.value * self.myrock+0.5)
    self.donateExp.text = math.floor((tonumber(self.wood.text) + tonumber(self.metal.text) + tonumber(self.rock.text) + tonumber(self.food.text)))
end

function rebellUI:foodSliderChanged()
    if (self.foodSlider.value * self.myfood) >= self.data.maxRevolt then
        self.food.text = self.data.maxRevolt
    end
    if self.foodSlider.value * self.myfood >= self.data.maxRevolt - self.rockSlider.value * self.myrock - self.metalSlider.value * self.mymetal - self.woodSlider.value * self.mywood then

        self.foodSlider.value =(self.data.maxRevolt - self.rockSlider.value * self.myrock - self.metalSlider.value * self.mymetal - self.woodSlider.value * self.mywood - self.data.curRevolt) / self.myfood
    end
    self.food.text = math.floor(self.foodSlider.value * self.myfood+0.5)
    self.donateExp.text = math.floor((tonumber(self.wood.text) + tonumber(self.metal.text) + tonumber(self.rock.text) + tonumber(self.food.text)))
end





function rebellUI:OnClickconfirmBtn()

    local id = PlayerService:Instance():GetsuperiorLeagueId();
    if self.data.curRevolt >= self.data.maxRevolt then
        LeagueService:Instance():SendEnsureRevoltRequest()
    else
        -- 确认上交
        LeagueService:Instance():RebellDonate(id, tonumber(self.wood.text), tonumber(self.metal.text), tonumber(self.rock.text), tonumber(self.food.text))
    end
end

function rebellUI:OnClickbackBtn()

    UIService:Instance():HideUI(UIType.rebellUI)

end

return rebellUI
-- endregion
