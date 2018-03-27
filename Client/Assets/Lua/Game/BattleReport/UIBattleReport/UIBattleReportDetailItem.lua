--[[ÓÎÏ·Ö÷½çÃæ]]

local UIBase= require("Game/UI/UIBase");
local UIBattleReportDetailItem=class("UIBattleReportDetailItem",UIBase);
local List = require("common/List");
function UIBattleReportDetailItem:ctor()
    UIBattleReportDetailItem.super.ctor(self)
    self.FrontBlank = nil;
    self.image1 = nil;
    self.Lable1 = nil;
    self.image2 = nil;
    self.Lable2 = nil;
    self.image3 = nil;
    self.Lable3 = nil;
    self.image4 = nil;
    self.Lable4 = nil;
    self.image5 = nil;
    self.Lable5 = nil;
    self.image6 = nil;
    self.Lable6 = nil;
    self.image7 = nil;
    self.Lable7 = nil;
    self.image8 = nil;
    self.Lable8 = nil;
    self.image9 = nil;
    self.Lable9 = nil;
    self.InfoList = List.new()
end

--×¢²á¿Ø¼þ
function UIBattleReportDetailItem:DoDataExchange()
    self.FrontBlank = self:RegisterController(UnityEngine.UI.Text,"Layout/FrontBlank")
    self.image1 = self:RegisterController(UnityEngine.UI.Image,"Layout/Image1")
    self.Lable1 = self:RegisterController(UnityEngine.UI.Text,"Layout/des1")
    self.image2 = self:RegisterController(UnityEngine.UI.Image,"Layout/Image2")
    self.Lable2 = self:RegisterController(UnityEngine.UI.Text,"Layout/des2")
    self.image3 = self:RegisterController(UnityEngine.UI.Image,"Layout/Image3")
    self.Lable3 = self:RegisterController(UnityEngine.UI.Text,"Layout/des3")
    self.image4 = self:RegisterController(UnityEngine.UI.Image,"Layout/Image4")
    self.Lable4 = self:RegisterController(UnityEngine.UI.Text,"Layout/des4")
    self.image5 = self:RegisterController(UnityEngine.UI.Image,"Layout/Image5")
    self.Lable5 = self:RegisterController(UnityEngine.UI.Text,"Layout/des5")
    self.image6 = self:RegisterController(UnityEngine.UI.Image,"Layout/Image6")
    self.Lable6 = self:RegisterController(UnityEngine.UI.Text,"Layout/des6")
    self.image7 = self:RegisterController(UnityEngine.UI.Image,"Layout/Image7")
    self.Lable7 = self:RegisterController(UnityEngine.UI.Text,"Layout/des7")
    self.image8 = self:RegisterController(UnityEngine.UI.Image,"Layout/Image8")
    self.Lable8 = self:RegisterController(UnityEngine.UI.Text,"Layout/des8")
    self.image9 = self:RegisterController(UnityEngine.UI.Image,"Layout/Image9")
    self.Lable9 = self:RegisterController(UnityEngine.UI.Text,"Layout/des9")
    self.InfoList:Push(self.image1);self.InfoList:Push(self.Lable1);
    self.InfoList:Push(self.image2);self.InfoList:Push(self.Lable2);
    self.InfoList:Push(self.image3);self.InfoList:Push(self.Lable3);
    self.InfoList:Push(self.image4);self.InfoList:Push(self.Lable4);
    self.InfoList:Push(self.image5);self.InfoList:Push(self.Lable5);
    self.InfoList:Push(self.image6);self.InfoList:Push(self.Lable6);
    self.InfoList:Push(self.image7);self.InfoList:Push(self.Lable7);
    self.InfoList:Push(self.image8);self.InfoList:Push(self.Lable8);
    self.InfoList:Push(self.image9);self.InfoList:Push(self.Lable9);
end

--ÉèÖÃÇ°ÃæµÄ¿Õ¸ñ ºÃÈÃÕûÌåÍùºóÒ»µã
function UIBattleReportDetailItem:SetinnerPosition()
    self.FrontBlank.text = "  "
end

--³õÊ¼»¯ÄÚÈÝ
function UIBattleReportDetailItem:InitImageAndText(image1,text1,image2,text2,image3,text3)
    self.FrontBlank.text = ""
    self:SetImage(self.image1,image1);self:SetLabel(self.Lable1,text1);
    self:SetImage(self.image2,image2);self:SetLabel(self.Lable2,text2);
    self:SetImage(self.image3,image3);self:SetLabel(self.Lable3,text3);
    self:SetImage(self.image4,image4);self:SetLabel(self.Lable4,text4);
    self:SetImage(self.image5,image5);self:SetLabel(self.Lable5,text5);
    self:SetImage(self.image6,image6);self:SetLabel(self.Lable6,text6);
    self:SetImage(self.image7,image7);self:SetLabel(self.Lable7,text7);
    self:SetImage(self.image8,image8);self:SetLabel(self.Lable8,text8);
    self:SetImage(self.image9,image9);self:SetLabel(self.Lable9,text9);
end

--±éÀúÁÐ±í»ñÈ¡×ÊÔ´
function UIBattleReportDetailItem:InitGetRescouse(rescouseList)
    self.FrontBlank.text = ""
    local count = self.InfoList:Count()
    for index = 1,count do
        local ui = self.InfoList:Get(index)
        local res = rescouseList:Get(index)
        if(index%2==1) then
            self:SetImage(ui,res);
        else
            self:SetLabel(ui,res);
        end
    end
end

--ÉèÖÃÍ¼Æ¬
function UIBattleReportDetailItem:SetImage(image,imageSprite)
    if(imageSprite == nil or imageSprite == "") then
        image.gameObject:SetActive(false)
    else
        image.gameObject:SetActive(true)
        image.sprite = GameResFactory.Instance():GetResSprite(imageSprite);
    end
end

--ÉèÖÃÎÄ±¾
function UIBattleReportDetailItem:SetLabel(label,text)
    if(text == nil or text == "") then
        label.gameObject:SetActive(false)
    else
        label.gameObject:SetActive(true)
        label.text = text;
    end
end

return UIBattleReportDetailItem
