--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local UIBase = require("Game/UI/UIBase")

local RechargeUI = class("RechargeUI",UIBase)
local UIService = require("Game/UI/UIService")
local UIType = require("Game/UI/UIType")
local DataRecharge = require("Game/Table/model/DataRecharge");

function RechargeUI:ctor()
	RechargeUI.super.ctor(self)
	
    self.gridTransform = nil ;
    self.exitBtn = nil;

    self.rechargeItemDics = {};             --键：DataRecharge中ID           值：DataRecharge
    self.rechargeObjDics = {};              --键：RechargeItem GameObject    值: DataRecharge
    self.rechargeInfoDic = {};              --键：ID    值: RechargeItem
end

function  RechargeUI:DoDataExchange(args)
    self.gridTransform = self:RegisterController(UnityEngine.RectTransform,"Scroll/Gird");
    self.exitBtn = self:RegisterController(UnityEngine.UI.Button,"ExitBtn");
end

function RechargeUI:DoEventAdd(args)
    self:AddOnClick(self.exitBtn,self.OnCilckExitBtn);
end

function RechargeUI:OnShow()
    self:ShowRechargeItem();
    --print("now jade:"..PlayerService.Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Jade):GetValue())
end

function RechargeUI:ShowRechargeItem()
    self.gridTransform.localPosition= Vector3.zero;
    local size = #DataRecharge;
    for k,v in pairs(DataRecharge) do  
        if self.rechargeItemDics[v.ID] == nil then
            local dataConfig = DataUIConfig[UIType.RechargeItem];
            local uiBase = require(dataConfig.ClassName).new();
            GameResFactory.Instance():GetUIPrefab(dataConfig.ResourcePath, self.gridTransform, uiBase, function(go)
                uiBase:Init();
                if uiBase.gameObject then
                    uiBase:SetRechargrItemInfo(v);
                end
                uiBase.gameObject:SetActive(true);           
                self.rechargeItemDics[v.ID] = v;
                self.rechargeObjDics[uiBase.gameObject] = v;
                self.rechargeInfoDic[v.ID] = uiBase;
            end);
        else
            --print("充值item ID为"..v.ID.."  的已加载");
            self.rechargeInfoDic[v.ID]:SetRechargrItemInfo(v);
        end       
    end
end

--关闭充值界面
function RechargeUI:OnCilckExitBtn()
	UIService:Instance():HideUI(UIType.RechargeUI);
    if UIService.Instance():GetOpenedUI(UIType.UIMainCity) == false then
        UIService:Instance():ShowUI(UIType.UIGameMainView);
    end
end

return RechargeUI;
