--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local UIBase = require("Game/UI/UIBase")

local RechargeItem = class("RechargeItem",UIBase)
local UIService = require("Game/UI/UIService")
local UIType = require("Game/UI/UIType")

function RechargeItem:ctor()
	RechargeItem.super.ctor(self)
	
    self.needMoneyText = nil;
    self.getGemsText = nil;
    self.icon = nil;
    self.recommendIcon = nil;
    self.desText = nil ;
    self.rechargeBtn = nil;

    self.rechargeData = nil;        --DataRecharge 表数据
end

function  RechargeItem:DoDataExchange(args)
    self.needMoneyText = self:RegisterController(UnityEngine.UI.Text,"PayText");
    self.getGemsText = self:RegisterController(UnityEngine.UI.Text,"GetText");
    self.desText = self:RegisterController(UnityEngine.UI.Text,"DesText");
    self.icon = self:RegisterController(UnityEngine.UI.Image,"Icon");
    self.recommendIcon = self:RegisterController(UnityEngine.UI.Image,"RecommendImage");
    self.rechargeBtn = self:RegisterController(UnityEngine.UI.Button,"RechargeBtn");
end

function RechargeItem:DoEventAdd()
    self:AddListener(self.rechargeBtn,self.OnClickRecharge);
end

-- param : 一条 DataRecharge 数据
function RechargeItem:SetRechargrItemInfo(param)
    if param ~= nil then
        self.rechargeData  = param;
        self.needMoneyText.text = "¥"..param.Price;
        self.getGemsText.text = param.Name;
        --每个充值档次的图片
        --self.icon.sprite = GameResFactory.Instance():GetResSprite(param.picture);

        local isFirstRecharged =  RechargeService:Instance():CheckInfoItemFirstRecharge(param.ID);
        if isFirstRecharged == true then 
            if param.Type == 1 then
                local isOpen =  RechargeService:Instance():CheckMonthCardOpen();
                if isOpen == true then
                    local leftTime =  RechargeService:Instance():GetMonthCardleftTime(true);
                    if leftTime < param.Time then
                        self.recommendIcon.gameObject:SetActive(true);
                    else
                        self.recommendIcon.gameObject:SetActive(false);
                    end
                    if leftTime > 3 then
                        local showTime  = math.floor(leftTime);
                        self.desText.text = param.Des.."\n".."有效期剩余<color=#FFFF00>"..showTime.."</color>天"; 
                    else
                        local showTime = math.floor(RechargeService:Instance():GetMonthCardleftTime(false));
                        self.desText.text = param.Des.."\n".."有效期剩余<color=#FFFF00>"..showTime.."</color>小时"; 
                    end
                end
            else
                self.desText.text = param.Des;
                self.recommendIcon.gameObject:SetActive(false);
            end
        else
            --print(param.ID.." 没有冲过一次！！！！！！！！！！！");
            self.recommendIcon.gameObject:SetActive(true);
            self.desText.text = param.FirstBuyDes;
        end
        
    end
end

function RechargeItem:OnClickRecharge(args)
    --print("点击item  ID： "..self.rechargeData.ID.."  充值金额:"..self.rechargeData.Price);
    if self.rechargeData.Type == 1 then
        local leftDay  =  RechargeService:Instance():GetMonthCardleftTime(true);
        if leftDay > self.rechargeData.Time then
            --print("月卡剩余时间已超出30天，不可继续充月卡！！！！！！！！！！");
            UIService:Instance():ShowUI(UIType.UICueMessageBox,109);
            return;
        end
    end
    local msg = require("MessageCommon/Msg/C2L/Recharge/RechargeOnce").new();
    --充值消息
    msg:SetMessageId(C2L_Recharge.RechargeOnce);
    msg.rechargeId = self.rechargeData.ID;
    NetService:Instance():SendMessage(msg)
    --print("发送充值消息，msg.rechargeId : ".. msg.rechargeId);
end

return RechargeItem;
