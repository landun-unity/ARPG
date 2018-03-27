--[[
	producer:ww
	date 16-12-29
	--出征
]]

local UIBase = require("Game/UI/UIBase");
local UIType = require("Game/UI/UIType");
local UIService = require("Game/UI/UIService");
local SelfLand = require("Game/MapMenu/SelfLand");
local UIOneselfSoilObj = require("Game/MapMenu/UIOneselfSoilObj");
local UIButton_Battle = class("UIButton_Battle",UIBase);

function UIButton_Battle:ctor()
	UIButton_Battle.super.ctor(self);
	self.curTiledIndex = nil 
	self.curTiled = nil 
end

function UIButton_Battle:DoEventAdd()
	self:AddListener(self.gameObject:GetComponent(typeof(UnityEngine.UI.Button)),self.ButtonOnClick);
end

function UIButton_Battle:ShowButton(tiled)
	self.curTiledIndex = tiled:GetIndex()
	self.curTiled = tiled
end

--按钮点击事件
function UIButton_Battle:ButtonOnClick()
    if PlayerService:Instance():IsHaveCanSendArmy() == false then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 144);
        return;
    end

	if self:CheckTiledIsForBattle() == false then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.HaveNoBorderTiled);
        return
    end

    
    if MapService:Instance():IsFriendTiled(self.curTiled) then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.IsAreadyOccupy)
        return
    end

    if self:IsAvoidBattle() == false then
    	UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.InAvoidTime)
    	return
    end

    if self:IsHaveEnoughTile() == true then
        CommonService:Instance():ShowOkOrCancle(self,function()  self:CommonOk() end,function() self:CommonCancle() end,"领地上限不足","可能无法占领该领地","确认","取消");
        return;
    end


    MapService:Instance():HideTiled()
    local param = { }
    param.troopsNum = 1
    param.troopType = SelfLand.battle
    param.tiledIndex = self.curTiledIndex;
    UIService:Instance():ShowUI(UIType.UISelfLandFunction, param);
    UIService:Instance():HideUI(UIType.UIGameMainView)
end

function UIButton_Battle:IsHaveEnoughTile()
	if self.curTiled._building ~= nil then
		return false
	end
	if self.curTiled._town ~= nil then
		return false
	end
	if PlayerService:Instance():GetTiledIdListCount() >= math.floor(PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Rnown):GetValue()/DataGameConfig[516].OfficialData) then
		return true
	end
	return false
end

function UIButton_Battle:CheckTiledIsForBattle()
    if self.curTiled._building ~= nil and self.curTiled._building._dataInfo ~= nil then
        if self.curTiled._building._dataInfo.Type == BuildingType.LevelBoat or self.curTiled._building._dataInfo.Type == BuildingType.Boat then
            if self:IsBorderTiled(self.curTiledIndex) then
                return true
            else
                local childBoatIndex = self.curTiled._building._childBoat._index
                return self:IsBorderTiled(childBoatIndex)
            end
        end
    end
    return self:IsBorderTiled(self.curTiledIndex)
end

-- 检测是否有相邻地块
function UIButton_Battle:IsBorderTiled(index)
    local x, y = MapService:Instance():GetTiledCoordinate(index)
    local ownerId = 0
    local ownerLeagueId = 0
    local superiorLeagueId = 0
    for i = x - 1, x + 1 do
        for j = y - 1, y + 1 do
            local tempIndex = MapService:Instance():GetTiledIndex(i, j)
            local tiled = MapService:Instance():GetTiledByIndex(tempIndex)
            local tempTiledInfo = tiled.tiledInfo
            if tempTiledInfo ~= nil then
                ownerId = tempTiledInfo.ownerId
                superiorLeagueId = tempTiledInfo.superiorLeagueId
                ownerLeagueId = tempTiledInfo.leagueId
            end
            if PlayerService:Instance():GetPlayerId() == ownerId then
                return true
            end
            if PlayerService:Instance():GetLeagueId() == superiorLeagueId and superiorLeagueId ~= 0 and PlayerService:Instance():GetsuperiorLeagueId()==0 then
            	return true
            end
            if PlayerService:Instance():GetLeagueId() == ownerLeagueId and ownerLeagueId ~= 0 and superiorLeagueId==0 then
            	return true
            end
        end
    end
    return false
end

-- 是否处于免战时间
function UIButton_Battle:IsAvoidBattle()
	if self.curTiled.tiledInfo == nil then
		return true
	end
	local avoidTime = self.curTiled.tiledInfo.avoidWarTime
	local localTime = PlayerService:Instance():GetLocalTime()
    local myPlayerId = PlayerService:Instance():GetPlayerId();
	if avoidTime >= localTime and self.curTiled.tiledInfo.guideAvoidWarOwnerId ~= myPlayerId then
		return false
	end
	return true
end

function UIButton_Battle:CommonOk()
    if self:CheckTiledIsForBattle() == false then
        if UIService:Instance():GetOpenedUI(UIType.UICueMessageBox) == true then
            return;
        else
            UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.HaveNoBorderTiled);
            return;
        end
    end

    if self:IsAvoidBattle() == false then
        if UIService:Instance():GetOpenedUI(UIType.UICueMessageBox) == true then
            return;
        else
            UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.InAvoidTime)
            return
        end
    end

    if PlayerService:Instance():IsHaveCanSendArmy() == false then
        if UIService:Instance():GetOpenedUI(UIType.UICueMessageBox) == true then
            return;
        else
            UIService:Instance():ShowUI(UIType.UICueMessageBox, 144);
            return;
        end
    end

    MapService:Instance():HideTiled()
    local param = { }
    param.troopsNum = 1
    param.troopType = SelfLand.battle
    param.tiledIndex = self.curTiledIndex;
    UIService:Instance():ShowUI(UIType.UISelfLandFunction, param);
    UIService:Instance():HideUI(UIType.UIGameMainView)
end

function UIButton_Battle:CommonCancle()
    UIService:Instance():HideUI(UIType.CommonOkOrCancle);
end

return UIButton_Battle;