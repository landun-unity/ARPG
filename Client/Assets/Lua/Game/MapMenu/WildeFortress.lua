--[[
    野外军营
--]]

local UIBase= require("Game/UI/UIBase");
local WildeFortress=class("WildeFortress",UIBase);        
local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");
require("Game/Table/InitTable");

--构造函数
function WildeFortress:ctor()
    WildeFortress.super.ctor(self);
    self.position = nil;
    self.stateText = nil;
    self.nameText = nil;
    self.numTable = {};
    self.grideNum = nil;
end

--初始化
function WildeFortress:DoDataExchange()    
    self.position = self:RegisterController(UnityEngine.UI.Text,"LandName/place/Coord");
    self.stateText = self:RegisterController(UnityEngine.UI.Text,"LandName/place/roomText");
    self.nameText = self:RegisterController(UnityEngine.UI.Text,"LandName/place/roomText1");
    self.grideNum = self:RegisterController(UnityEngine.UI.Text,"LandName/landGrade/Num");
end

--加载资源
function WildeFortress:ShowTiled(tiled)    
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
    --刷土地等级
    local resource = tiled:GetResource();
    local gride = resource.TileLv;
    self.grideNum.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text="Lv."..gride;
end

return WildeFortress;
