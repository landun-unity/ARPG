--[[
    点击自建要塞界面
--]]

local UIBase= require("Game/UI/UIBase");
local UISelfFort=class("UISelfFort",UIBase);        
local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");
require("Game/Table/InitTable");

--构造函数
function UISelfFort:ctor()    
    UISelfFort.super.ctor(self);
    self.fortBtn = nil;
    self.position = nil;  
    self.stateText = nil;
    self.nameText = nil;  
    self.numTable = {};
end

--注册控件
function UISelfFort:DoDataExchange()
  self.fortBtn=self:RegisterController(UnityEngine.UI.Button,"fort");
  self.position = self:RegisterController(UnityEngine.UI.Text,"FortName/place/Coord");
  self.stateText = self:RegisterController(UnityEngine.UI.Text,"FortName/place/roomText");
  self.nameText = self:RegisterController(UnityEngine.UI.Text,"FortName/place/roomText1");
end

--注册控件点击事件
function UISelfFort:DoEventAdd()    
  self:AddListener(self.fortBtn.gameObject,self.OnClickFortBtn);  
end

--点击要塞
function UISelfFort:OnClickFortBtn()    
    UIService:Instance():ShowUI(UIType.UITheFort);
    UIService:Instance():HideUI(UIType.UISelfFort);
end

--加载资源
function UISelfFort:ShowTiled(tiled)    
    local positionx = tiled:GetX();
    local positiony = tiled:GetY();
    self.position.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text= positionx .. " , " .. positiony;
    --刷州郡
    local thename = nil;
    local thestate = nil;
    local region = tiled:GetRegion();    
    local state = region.StateID; 
    local mapId = region.TiledMapTileID;    
    local nameTable = {};           
    local mystate = DataState[state];    
    nameTable = mystate.RegionID;    
    for key,var in pairs(nameTable) do        
        if var == mapId then            
            thename = region.Name;                             
        end
    end    
    thestate = mystate.Name;
    self.stateText.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text=thestate;
    self.nameText.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text=thename;
end

return UISelfFort;
