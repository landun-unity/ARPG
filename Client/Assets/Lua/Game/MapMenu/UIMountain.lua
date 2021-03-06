--[[
    山川
--]]

local UIBase= require("Game/UI/UIBase");
local UIMountain=class("UIMountain",UIBase);        
local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");
require("Game/Table/InitTable");
--构造方法
function UIMountain:ctor()
    UIMountain.super.ctor(self);
    self.position = nil;
    self.belongText = nil; 
    self.numTable = {};   
end

--初始化
function UIMountain:DoDataExchange()
    self.position = self:RegisterController(UnityEngine.UI.Text,"stateName/belongText/position");
    self.belongText = self:RegisterController(UnityEngine.UI.Text,"stateName/belongText");
end

--加载资源
function UIMountain:ShowTiled(tiled)
    self.gameObject.transform.localScale = Vector3.New(1.52,1.52,1.52);
    local positionx = tiled:GetX();
    local positiony = tiled:GetY();    
    self.position.text= positionx .. " , " .. positiony;
    --刷州 
    local thestate = nil;
    local region = tiled:GetRegion();  

    local state = region.StateID; 
--    local mapId = region.TiledMapTileID;    
--    local nameTable = {};        
    local mystate = DataState[state];    

--    nameTable = mystate.RegionID;    
--    for key,var in pairs(nameTable) do        
--        if var == mapId then            
--            thename = region.Name;                             
--        end
--    end    
    thestate = mystate.Name;
    
    self.belongText.text = thestate;
    --self.stateText.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text=thestate;       
end

return UIMountain;
