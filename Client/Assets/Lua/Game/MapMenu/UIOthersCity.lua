--[[
    其他玩家主城
--]]

local UIBase = require("Game/UI/UIBase");
local UIOthersCity = class("UIOthersCity", UIBase);
local UIService = require("Game/UI/UIService");
local UIType = require("Game/UI/UIType");
local SelfLand = require("Game/MapMenu/SelfLand");
local LayerType = require("Game/Map/LayerType")
local UICueMessageType = require("Game/UI/UICueMessageType");
require("Game/Table/InitTable");
require("Game/League/LeagueTitleType")
-- 构造函数
function UIOthersCity:ctor()
    UIOthersCity.super.ctor(self);

    --名字
    self.playerName = nil;
    --同盟名字
    self.LeagueName = nil;
    -- 当前点击格子
    self.curTiledIndex = nil

    self.signImage = nil;
    self.FloodImage= nil;
    self.signImage1 = nil;
    self.tiled = nil;
    self.diplomacy = nil;
    self.amity = nil;
    self.HangFlagsImage = nil;
    self.defendersImage = nil;
    self.textInfo = nil;
    self.PersonageImage = nil;
    self.defendersText = nil;
    self.presentText = nil;
    self.Personal = nil;
    self.mailBtn = nil;
    self.leftParent = nil;
    self.redif = nil;
end

-- 注册控件
function UIOthersCity:DoDataExchange()
    self.playerName = self:RegisterController(UnityEngine.UI.Text, "OthersCityLand/Personal/PersonageImage/NameText");
    self.LeagueName = self:RegisterController(UnityEngine.UI.Text, "OthersCityLand/Personal/HangFlagsImage/NameText");
    self.HangFlagsImage = self:RegisterController(UnityEngine.UI.Image, "OthersCityLand/Personal/HangFlagsImage");
    self.PersonageImage = self:RegisterController(UnityEngine.UI.Image,"OthersCityLand/Personal/PersonageImage")
    self.signImage = self:RegisterController(UnityEngine.UI.Button,"signImage")
    self.signImage1 = self:RegisterController(UnityEngine.UI.Button,"signImage1")
    self.FloodImage= self:RegisterController(UnityEngine.UI.Image,"FloodImage")
    self.diplomacy = self:RegisterController(UnityEngine.UI.Image,"OthersCityLand/Personal/HangFlagsImage/diplomacy")
    self.amity = self:RegisterController(UnityEngine.UI.Image,"OthersCityLand/Personal/HangFlagsImage/amity")
    self.defendersImage = self:RegisterController(UnityEngine.UI.Image,"OthersCityLand/Personal/Image")
    self.textInfo = self:RegisterController(UnityEngine.RectTransform,"OthersCityLand/Personal/textInfo")
    self.defendersText = self:RegisterController(UnityEngine.UI.Text,"OthersCityLand/Personal/Image/Text")
    self.presentText = self:RegisterController(UnityEngine.UI.Text,"OthersCityLand/Personal/textInfo/Text")
    self.Personal = self:RegisterController(UnityEngine.UI.Image,"OthersCityLand/Personal")
    self.mailBtn = self:RegisterController(UnityEngine.UI.Button,"OthersCityLand/Personal/PersonageImage/Image")
    self.leftParent = self:RegisterController(UnityEngine.RectTransform, "OthersCityLand/Personal");
    self.redif = self:RegisterController(UnityEngine.UI.Image,"OthersCityLand/Personal/redif")
end

-- 注册控件点击事件
function UIOthersCity:DoEventAdd()
    self:AddListener(self.signImage, self.OnClickSignBtn);
    self:AddListener(self.signImage1, self.OnClickUndoSignBtn)
    self:AddListener(self.mailBtn, self.OnClickMailBtn)
end

-- 加载土地资源产量
function UIOthersCity:ShowTiled(tiled)
    self.gameObject.transform.localScale = Vector3.New(1.52,1.52,1.52);
    self.curTiledIndex = tiled:GetIndex();
    self:SetLeagueName(tiled);
    if tiled.tiledInfo ~= nil then
        if tiled.tiledInfo.superiorLeagueId ~= 0 then
            self.FloodImage.transform.localPosition = Vector3.New(self.FloodImage.transform.localPosition.x, self.leftParent.localPosition.y + self.leftParent.sizeDelta.y/2, 0);
            self.FloodImage.gameObject:SetActive(true)
        else
            self.FloodImage.gameObject:SetActive(false)
        end
        self.mailBtn.gameObject:SetActive(true)
    else
        self.FloodImage.gameObject:SetActive(false)
        self.mailBtn.gameObject:SetActive(false);
    end
    self:Diplomacy(tiled)


  ClickService:Instance():GetCurClickUI(Vector3.New(self.leftParent.transform.localPosition.x, self.leftParent.transform.localPosition.y  - CommonService:Instance():GetChildCount(self.leftParent.transform) * 22-113, 0))
end


function UIOthersCity:OnClickMailBtn()
    CommonService:Instance():RequestPlayerInfo(self.tiled.tiledInfo.ownerId);
end

function UIOthersCity:Diplomacy(tiled)
    self.amity.gameObject:SetActive(false)
    self.diplomacy.gameObject:SetActive(false)
    if tiled ~= nil then
        if PlayerService:Instance():GetLeagueId()==0 then 
            self.amity.gameObject:SetActive(false)
            self.diplomacy.gameObject:SetActive(false)
            return;
        end 

        if tiled.tiledInfo ~= nil and tiled.tiledInfo.leagueId ~= PlayerService:Instance():GetLeagueId() then
            if  PlayerService:Instance():GetLeagueRelation(tiled.tiledInfo.leagueId) == 1 then
                self.amity.gameObject:SetActive(true)
            elseif PlayerService:Instance():GetLeagueRelation(tiled.tiledInfo.leagueId) == 2 then
                self.diplomacy.gameObject:SetActive(true)
            else
                self.amity.gameObject:SetActive(false)
                self.diplomacy.gameObject:SetActive(false) 
            end
        end
    end
end


function UIOthersCity:SetLeagueName(tiled)
    self.HangFlagsImage.gameObject:SetActive(true)
    self.PersonageImage.gameObject:SetActive(true)
    self.defendersImage.gameObject:SetActive(false);
    self.textInfo.gameObject:SetActive(false)
    self:FlushMainCityInfo(tiled)
    self.tiled = tiled;
    self:WildFort(tiled)
    if tiled.tiledInfo == nil then
        return 
    end
    local building = tiled:GetBuilding();
    self.playerName.text = "<color=#71b448>"..tiled.tiledInfo.ownerName.."</color>";

    local town = tiled:GetTown();
        if town ~= nil then
            local building = town._building
            if building ~= nil then
                --print("aaaa:"..building._leagueId.."  "..building._leagueName) 
                if tiled.tiledInfo.leagueId ~= 0 then
                    self.LeagueName.text = "<color=#71b448>"..tiled.tiledInfo.leagueName.."</color>";
                elseif tiled.tiledInfo.leagueId == 0 then
                    self.LeagueName.text = "<color=#BF3636FF>在野</color>";
                else
                    self.LeagueName.text = "<color=#BF3636FF>" .. tiled.tiledInfo.superiorLeagueName .. "</color>";
                end
                if tiled.tiledInfo.ownerId == 0 then
                    self.Personal.gameObject:SetActive(false);
                else 
                    self.Personal.gameObject:SetActive(true)
                end
            end
            return
        end

    if building ~= nil then
        
        if tiled.tiledInfo.leagueId ~= 0 then
            self.LeagueName.text = "<color=#71b448>"..tiled.tiledInfo.leagueName.."</color>";
        elseif tiled.tiledInfo.leagueId == 0 then
            self.LeagueName.text = "<color=#BF3636FF>在野</color>";
        else
            self.LeagueName.text = "<color=#BF3636FF>" .. tiled.tiledInfo.superiorLeagueName .. "</color>";
        end
    end

end

function UIOthersCity:WildFort(tiled)
    local building = tiled:GetBuilding();
    if building ~= nil and building._dataInfo.Type == BuildingType.WildFort then
        self.defendersImage.gameObject:SetActive(true);
        self.textInfo.gameObject:SetActive(true)
        if tiled._building._owner == 0 then
            self.HangFlagsImage.gameObject:SetActive(false)
            self.PersonageImage.gameObject:SetActive(false)
            self.defendersText.text = "守军强度 Lv " .. DataTile[DataTileCut[tiled:GetImageId(LayerType.WildFort)].TileID].NPCTroopLv
            self.presentText.text = "个人占领,可通过调动放置5支部队"
        elseif tiled._building._owner ~= 0 then
            if tiled._building._leagueId == 0 then
                self.playerName.text = tiled.tiledInfo.ownerName
                self.LeagueName.text = "<color=#BF3636FF>在野</color>";
                self.defendersText.text = "守军强度 Lv " .. DataTile[DataTileCut[tiled:GetImageId(LayerType.WildFort)].TileID].NPCTroopLv
                self.presentText.text = "个人占领,可通过调动放置5支部队"
            else
                self.playerName.text = tiled.tiledInfo.ownerName
                self.LeagueName.text = "<color=#71b448>"..tiled.tiledInfo.leagueName.."</color>";
                self.defendersText.text = "守军强度 Lv " .. DataTile[DataTileCut[tiled:GetImageId(LayerType.WildFort)].TileID].NPCTroopLv
                self.presentText.text = "个人占领,可通过调动放置5支部队"
            end
        end
    elseif building ~= nil and building._dataInfo.Type == BuildingType.WildGarrisonBuilding then
        self.redif.gameObject:SetActive(true);
        self.HangFlagsImage.gameObject:SetActive(false)
        self.PersonageImage.gameObject:SetActive(false)
        self.defendersImage.gameObject:SetActive(true);
        self.textInfo.gameObject:SetActive(true)
        if tiled._building._owner == 0 then
            self.defendersText.text = "守军强度 Lv " .. DataTile[DataTileCut[tiled:GetImageId(LayerType.WildFort)].TileID].NPCTroopLv
            self.presentText.text = "个人占领,可通过调动放置5支部队,存在少量预备兵"
        end
    end
end

function UIOthersCity:OnClickSignBtn()
    local name = nil;
    local tiledInfo = MapService:Instance():GetDataTiled(self.tiled)
    if tiledInfo ~= nil then
        local building = self.tiled._building 
        local town = self.tiled._town
        if building ~= nil and town == nil and building._dataInfo.Type ~= BuildingType.WildFort then
            name = building._name.." (Lv."..self.tiled:GetResource().TileLv..")"
        elseif town ~= nil then
            name = town._building._name.."-城区"
        elseif building ~= nil and building._dataInfo.Type == BuildingType.WildFort and building._owner == 0 then
            name = "野外要塞".." (Lv."..self.tiled:GetResource().TileLv..")"
        elseif building ~= nil and building._dataInfo.Type == BuildingType.WildFort and building._owner ~= 0 then
            name = building._name.." (Lv."..self.tiled:GetResource().TileLv..")"
        end 
    end
    local msg = require("MessageCommon/Msg/C2L/Player/RequestMarkTiled").new();
    msg:SetMessageId(C2L_Player.RequestMarkTiled);
    msg.name = name
    msg.tiledIndex = self.curTiledIndex;
    NetService:Instance():SendMessage(msg);
    self.gameObject:SetActive(false);
    MapService:Instance():HideTiled()
end

function UIOthersCity:OnClickUndoSignBtn()
    local msg = require("MessageCommon/Msg/C2L/Player/RequestUndoMarker").new();
    msg:SetMessageId(C2L_Player.RequestUndoMarker);
    msg.tiledIndex = self.curTiledIndex;
    NetService:Instance():SendMessage(msg);
    self.gameObject:SetActive(false);
    MapService:Instance():HideTiled()
end

-- 是否已标记 
function UIOthersCity:FlushMainCityInfo(tiled)
    local isMarked = UIService:Instance():IsMarked(tiled);
    if isMarked then
        self.signImage1.gameObject:SetActive(true);
        self.signImage.gameObject:SetActive(false);
    else
        self.signImage1.gameObject:SetActive(false);
        self.signImage.gameObject:SetActive(true);
    end
end

-- 检测是否有相邻地块
function UIOthersCity:CheckTiledIsForBattle()
    local x, y = MapService:Instance():GetTiledCoordinate(self.curTiledIndex)
    local ownerId = nil
    for i = x - 1, x + 1 do
        for j = y - 1, y + 1 do
            local tempIndex = MapService:Instance():GetTiledIndex(i, j)
            local tiled = MapService:Instance():GetTiledByIndex(tempIndex)
            local tempTiledInfo = tiled.tiledInfo
            if tempTiledInfo ~= nil then
                ownerId = tempTiledInfo.ownerId
            end
            if PlayerService:Instance():GetPlayerId() == ownerId then
                return true
            end
        end
    end
    return false
end

return UIOthersCity;
