--[[
    筑城说明
    Author: zzy
    Data:2016.12.2
--]]

local UIBase = require("Game/UI/UIBase");
local UIFortificationExplain = class("UIFortificationExplain",UIBase);
local UIService=require("Game/UI/UIService")
local UIType=require("Game/UI/UIType")

--构造函数
function UIFortificationExplain:ctor()
    UIFortificationExplain.super.ctor(self);
    self.Imagebtn = nil;
    self.confirmawakebtn = nil;
    self.text = nil;
    self.text1 = nil;
    self.text2 = nil;
    self.text3 = nil;
    self.text4 = nil;
    self.text5 = nil;
    self.text6 = nil;
    self.text7 = nil;
    self.text8 = nil;
    self.text9 = nil;
    self.text10 = nil;
    self.text11 = nil;
    self.text12 = nil;
    self.text13 = nil;
    self.text14 = nil;
    self.text15 = nil;
    self.text16 = nil;
    self.text17 = nil;
    self.text18 = nil;
    self.text19 = nil;
    self.text20 = nil;
    self.text21 = nil;
    self.text22 = nil;
    self.text23 = nil;
    self.text24 = nil;
    self.text25 = nil;
    self.text26 = nil;
    self.text27 = nil;
    self.text28 = nil;
    self.text29 = nil;


      self.texts  = nil
      self.texts1 = nil
      self.texts2= nil
      self.texts3= nil
      self.texts4 = nil
      self.texts5= nil
      self.texts6= nil
      self.texts7= nil
      self.texts8= nil
      self.texts9= nil
      self.texts10= nil
      self.texts11= nil
      self.texts12= nil
      self.texts13= nil
      self.texts14= nil
      self.texts15= nil
      self.texts16= nil
      self.texts17= nil
      self.texts18= nil
      self.texts19= nil
      self.texts20= nil
      self.texts21= nil
      self.texts22= nil
      self.texts23= nil
      self.texts24= nil
      self.texts25= nil
      self.texts26= nil
      self.texts27= nil
      self.texts28= nil
      self.texts29= nil

      self.city1 = nil
      self.city2 = nil
      self.city3 = nil
      self.city4 = nil
      self.city5 = nil
      self.city6 = nil
      self.city7 = nil
      self.city8 = nil
      self.city9 = nil
      self.city10 = nil

      self.citys1 = nil
      self.citys2 = nil
      self.citys3 = nil
      self.citys4 = nil
      self.citys5 = nil
      self.citys6 = nil
      self.citys7 = nil
      self.citys8 = nil
      self.citys9 = nil
      self.citys10 = nil

end

--注册控件
function UIFortificationExplain:DoDataExchange()
  self.Imagebtn=self:RegisterController(UnityEngine.UI.Button,"Image");
  self.confirmawakebtn=self:RegisterController(UnityEngine.UI.Button,"confirmawake");
  self.text = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/A1")
  self.text1 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/A2")
  self.text2 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/B1")
  self.text3 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/B2")
  self.text4 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/C1")
  self.text5 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/C2")
  self.text6 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/D1")
  self.text7 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/D2")
  self.text8 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/E1")
  self.text9 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/E2")
  self.text10 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/F1")
  self.text11 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/F2")
  self.text12 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/G1")
  self.text13 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/G2")
  self.text14 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/H1")
  self.text15 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/H2")
  self.text16 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/I1")
  self.text17 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/I2")
  self.text18 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/J1")
  self.text19 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/J2")
  self.text20 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/K1")
  self.text21 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/K2")
  self.text22 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/L1")
  self.text23 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/L2")
  self.text24 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/M1")
  self.text25 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/M2")
  self.text26 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/N1")
  self.text27 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/N2")
  self.text28 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/O1")
  self.text29 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/O2")

  self.texts = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/A1 (1)")
  self.texts1 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/A2 (1)")
  self.texts2 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/B1 (1)")
  self.texts3 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/B2 (1)")
  self.texts4 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/C1 (1)")
  self.texts5 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/C2 (1)")
  self.texts6 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/D1 (1)")
  self.texts7 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/D2 (1)")
  self.texts8 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/E1 (1)")
  self.texts9 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/E2 (1)")
  self.texts10 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/F1 (1)")
  self.texts11 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/F2 (1)")
  self.texts12 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/G1 (1)")
  self.texts13 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/G2 (1)")
  self.texts14 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/H1 (1)")
  self.texts15 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/H2 (1)")
  self.texts16 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/I1 (1)")
  self.texts17 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/I2 (1)")
  self.texts18 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/J1 (1)")
  self.texts19 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/J2 (1)")
  self.texts20 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/K1 (1)")
  self.texts21 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/K2 (1)")
  self.texts22 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/L1 (1)")
  self.texts23 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/L2 (1)")
  self.texts24 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/M1 (1)")
  self.texts25 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/M2 (1)")
  self.texts26 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/N1 (1)")
  self.texts27 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/N2 (1)")
  self.texts28 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/O1 (1)")
  self.texts29 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text1/O2 (1)")




  self.city1 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text3/A1");
  self.city2 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text3/A2");
  self.city3 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text3/B1");
  self.city4 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text3/B2");
  self.city5 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text3/C1");
  self.city6 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text3/C2");
  self.city7 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text3/D1");
  self.city8 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text3/D2");
  self.city9 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text3/E1");
  self.city10 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text3/E2");

  self.citys1 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text3/A1 (1)");
  self.citys2 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text3/A2 (1)");
  self.citys3 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text3/B1 (1)");
  self.citys4 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text3/B2 (1)");
  self.citys5 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text3/C1 (1)");
  self.citys6 = self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text3/C2 (1)");
  self.citys7= self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text3/D1 (1)");
  self.citys8= self:RegisterController(UnityEngine.UI.Text,"Image/Scroll View/Viewport/Content/Text3/D2 (1)");

end

--注册点击事件
function UIFortificationExplain:DoEventAdd()
  self:AddListener(self.Imagebtn,self.OnClickImagebtn);
  self:AddListener(self.confirmawakebtn,self.OnClickConfirmawakebtn);
end

function UIFortificationExplain:OnShow()
    
  self:GetFame()
  self:CityFame()

end

function UIFortificationExplain:GetFame()
  local renown = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Rnown):GetValue();
  tab = {self.text,self.text2,self.text4,self.text6,self.text8,self.text10,self.text12,self.text14,self.text16,self.text18,self.text20,self.text22,self.text24,self.text26,self.text28,self.texts,self.texts2,self.texts4,self.texts6,self.texts8,self.texts10,self.texts12,self.texts14,self.texts16,self.texts18,self.texts20,self.texts22,self.texts24,self.texts26,self.texts28}
  local j = 16;
  for i=1, #tab do
    if renown >= DataCharacterFame[j].Fame then
      tab[i].text = "<color=#6eaf47>"..i.."</color>"
    else 
      tab[i].text = i;
    end
    j = j + 1;
  end
  local z = 16;
  tabs =  {self.text1,self.text3,self.text5,self.text7,self.text9,self.text11,self.text13,self.text15,self.text17,self.text19,self.text21,self.text23,self.text25,self.text27,self.text29,self.texts1,self.texts3,self.texts5,self.texts7,self.texts9,self.texts11,self.texts13,self.texts15,self.texts17,self.texts19,self.texts21,self.texts23,self.texts25,self.texts27,self.texts29}
  for i=1,#tabs do
    if renown >= DataCharacterFame[z].Fame then
      tabs[i].text = "<color=#6eaf47>"..DataCharacterFame[z].Fame.."</color>"
    else
      tabs[i].text = DataCharacterFame[z].Fame
    end
    z = z + 1;
  end
end

function UIFortificationExplain:CityFame()
  local renown = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Rnown):GetValue();
  local x = 20;
  tabs = {self.city1,self.city3,self.city5,self.city7,self.city9,self.citys1,self.citys3,self.citys5,self.citys7}
  for i=1,#tabs do
    if renown >= DataCharacterFame[x].Fame then
      tabs[i].text = "<color=#6eaf47>"..i.."</color>"
    else 
      tabs[i].text = i
    end
    x = x + 3;
  end

  local t = 20;
  tabs = {self.city2,self.city4,self.city6,self.city8,self.city10,self.citys2,self.citys4,self.citys6,self.citys8}
  for i=1,#tabs do
    if renown >= DataCharacterFame[t].Fame then
      tabs[i].text = "<color=#6eaf47>"..DataCharacterFame[t].Fame.."</color>"
    else 
      tabs[i].text = DataCharacterFame[t].Fame
    end
    t = t + 3;
  end

end

--点击事件
function UIFortificationExplain:OnClickImagebtn()
    UIService:Instance():HideUI(UIType.UIFortificationExplain);
end

function UIFortificationExplain:OnClickConfirmawakebtn()
    UIService:Instance():HideUI(UIType.UIFortificationExplain);
end

return UIFortificationExplain