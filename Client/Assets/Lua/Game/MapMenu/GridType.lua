--[[
    大地图物理格子信息
--]]

local GridType = class("GridType");

--构造函数
function GridType:ctor()
    self._land=nil;  
    self._fortland = nil;
    self._cityland = nil;
    self._mountain = nil;
    self._river = nil;
end

--
function GridType:_TheGridType(position,tiledResource,tiledResType,mObject)
    --山脉
    if tiledResType == 1 then
        local UIMountain = require("Game/MapMenu/UIMountain").new();
        if self._mountain == nil then
            GameResFactory.Instance():GetUIPrefab("UIPrefab_mountains",mObject.transform,UIMountain, function(go)
                local mLand=UIMountain.gameObject;        
                UIMountain:Init();
                mLand.gameObject.transform.localPosition = Vector3.New(position.x,position.y,0);                                    
                self._mountain = UIMountain;
            end );
        else
            self._mountain.gameObject.transform.localPosition = Vector3.New(position.x,position.y,0);
        end
    end
    --河流
    if tiledResType == 2 then
        local UIMountain = require("Game/MapMenu/UIMountain").new();
        if self._river == nil then
            GameResFactory.Instance():GetUIPrefab("UIPrefab_mountains",mObject.transform,UIMountain, function(go)
                local mLand=UIMountain.gameObject;        
                UIMountain:Init();
                mLand.gameObject.transform.localPosition = Vector3.New(position.x,position.y,0);                                    
                self._river = UIMountain;
            end );
        else
            self._river.gameObject.transform.localPosition = Vector3.New(position.x,position.y,0);
        end
    end
    --资源地
    if tiledResType == 3 then
        local UIWildernes = require("Game/MapMenu/UIWildernes").new();
        if  self._land==nil then 
            GameResFactory.Instance():GetUIPrefab("UIPrefab_WildernesUI",mObject.transform,UIWildernes, function(go)
                local mLand=UIWildernes.gameObject;        
                UIWildernes:Init();
                mLand.gameObject.transform.localPosition = Vector3.New(position.x,position.y,0);                    
                UIWildernes:_LoadLandTypeMenu(tiledResource,mLand);
                self._land = UIWildernes;
            end );
        else        
            local _wood = self._land.gameObject.transform:Find("WildLand/WoodImage");           
            _wood.gameObject:SetActive(false);
            local _food = self._land.gameObject.transform:Find("WildLand/FoodImage");           
            _food.gameObject:SetActive(false);
            local _iron = self._land.gameObject.transform:Find("WildLand/IronImage");           
            _iron.gameObject:SetActive(false);
            local _stone = self._land.gameObject.transform:Find("WildLand/StoneImage");           
            _stone.gameObject:SetActive(false);            
            self._land.gameObject.transform.localPosition = Vector3.New(position.x,position.y,0);             
            if self._land then 
                self._land:_LoadLandTypeMenu(tiledResource,self._land);
            end 

        end
    end
    --野城中心
    if tiledResType == 4 then
    end
    --野城皮
    if tiledResType == 5 then
    end
    --野外要塞
    if tiledResType == 6 then
    end
    --野外军营
    if tiledResType == 7 then
    end
    --低级码头
    if tiledResType == 8 then
    end
    --关卡石邑
    if tiledResType == 9 then
    end
    --关卡码头
    if tiledResType == 10 then
    end
    --道路
    if tiledResType == 11 then
        local UIWildernes = require("Game/MapMenu/UIWildernes").new();
        if  self._land==nil then 
            GameResFactory.Instance():GetUIPrefab("UIPrefab_WildernesUI",mObject.transform,UIWildernes, function(go)
                local mLand=UIWildernes.gameObject;        
                UIWildernes:Init();
                mLand.gameObject.transform.localPosition = Vector3.New(position.x,position.y,0);                    
                UIWildernes:_LoadLandTypeMenu(tiledResource,mLand);
                self._land = UIWildernes;
            end );
        else        
            local _wood = self._land.gameObject.transform:Find("WildLand/WoodImage");           
            _wood.gameObject:SetActive(false);
            local _food = self._land.gameObject.transform:Find("WildLand/FoodImage");           
            _food.gameObject:SetActive(false);
            local _iron = self._land.gameObject.transform:Find("WildLand/IronImage");           
            _iron.gameObject:SetActive(false);
            local _stone = self._land.gameObject.transform:Find("WildLand/StoneImage");           
            _stone.gameObject:SetActive(false);            
            self._land.gameObject.transform.localPosition = Vector3.New(position.x,position.y,0);             
            if self._land then 
                self._land:_LoadLandTypeMenu(tiledResource,self._land);
            end 

        end
    end
    --玩家城池
    if tiledResType == 51 then
        local CityShow = require("Game/MapMenu/CityShow").new();
        if self._cityland == nil then
            GameResFactory.Instance():GetUIPrefab("UIPrefab_UILand",mObject.transform,CityShow, function(go)
            local mLand=CityShow.gameObject;      
            CityShow:Init();  
            mLand.gameObject.transform.localPosition = Vector3.New(position.x,position.y,0); 
            self._cityland = CityShow;       
            end );
        else
            self._cityland.gameObject.transform.localPosition = Vector3.New(position.x,position.y,0);
        end
    end
    --玩家城区
    if tiledResType == 52 then
    end
    
    --这是自建要塞
--    if tiledResType == xx then
--        local UISelfFort = require("Game/MapMenu/UISelfFort").new();
--        if self._fortland == nil then             
--            GameResFactory.Instance():GetUIPrefab("UIPrefab_SelfFort",mObject.transform,UISelfFort, function(go)
--                local mLand=UISelfFort.gameObject;      
--                UISelfFort:Init();  
--                mLand.gameObject.transform.localPosition = Vector3.New(position.x,position.y,0); 
--                --UISelfFort:_LoadLandTypeMenu(tiledResource,mLand);
--                self._fortland = UISelfFort;       
--            end );
--        else
--            self._fortland.gameObject.transform.localPosition = Vector3.New(position.x,position.y,0);             
--        end
--    end
end

return GridType;
