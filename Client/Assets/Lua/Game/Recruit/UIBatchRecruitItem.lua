--[[游戏主界面]]

local UIBase= require("Game/UI/UIBase");
local UIBatchRecruitItem=class("UIBatchRecruitItem",UIBase);

function UIBatchRecruitItem:ctor()
    UIBatchRecruitItem.super.ctor(self)   
end

--注册控件
function UIBatchRecruitItem:DoDataExchange()
    self.LeftLebel = self:RegisterController(UnityEngine.UI.Text,"Label")
    self.CountLabel = self:RegisterController(UnityEngine.UI.Text,"RightObj/CountLabel")
    self.Tips = self:RegisterController(UnityEngine.UI.Text,"RightObj/Tips")
    self.CoinObj = self:RegisterController(UnityEngine.UI.Image,"RightObj/Coin")
    self.PowerObj = self:RegisterController(UnityEngine.Transform,"RightObj/Power")
end

--复位
function UIBatchRecruitItem:ResetItem()
    self.LeftLebel.text = ""
    self.CountLabel.text = ""
    self.Tips.text = ""
    self.CoinObj.gameObject:SetActive(false)
    self.PowerObj.gameObject:SetActive(false)
end

--初始化
function UIBatchRecruitItem:InitItem(text1,text2,text3,coin,power)
    if(text1 == nil or text1 == "") then self.LeftLebel.text = ""
    else self.LeftLebel.text = text1; end
    if(text2 == nil or text2 == "") then self.CountLabel.text = ""
    else self.CountLabel.text = text2; end
    if(text3 == nil or text3 == "") then self.Tips.text = ""
    else self.Tips.text = text3; end
    if(coin~=nil) then self.CoinObj.gameObject:SetActive(true)
        self.CoinObj.sprite = GameResFactory.Instance():GetResSprite(coin);
    else 
        self.CoinObj.gameObject:SetActive(false)        
    end
    if(power~=nil) then self.PowerObj.gameObject:SetActive(true)
    else self.PowerObj.gameObject:SetActive(false) end
end

return UIBatchRecruitItem;
--endregion