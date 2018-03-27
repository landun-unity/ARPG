
-- 地图信息
local minMapWidth = 2250 
local minMapHeight = 1200
local MapWidth = 1250
local MapHeight = 750
local UIBase = require("Game/UI/UIBase")
local UIPic = class("UIPic", UIBase);
local guodu = "Capital";
local shoufu = "CentralCity"
local juncheng = "BigCities";
local zhongcheng = "MediumCities";
local xiaocheng = "SmallCity";
local Mark = "Sign"
local pass = "Censorship"
local mycity = "MyCity";
local LeagueMarkPic = "Sign";
local MySecondCity = "PointsCity";
local MyFort = "Fortress";
local TiledImage = "White";
local List = require("common/List");

function UIPic:ctor()

    UIPic.super.ctor(self)
    self.pic = "";
    self.pi = nil;
    self.pos = nil;
    self.obj = nil;
    self.WildBDPic = { };

end

function UIPic:DoDataExchange()
    self.pi = self:RegisterController(UnityEngine.UI.Image, "Image")

end

function UIPic:SetPicMessage(data, obj)
    self.obj = obj;
    local x = data.Coordinatex;
    local y = data.Coordinatey;
    local index = MapService:Instance():GetTiledIndex(x, y)
    local pos = self:GetUGUIPos(x, y)
    self.transform.localPosition = Vector3.New(- pos.x, pos.y, 0)
    local isfisrt = PmapService:Instance():GetIsFirstMap();
    if isfisrt then
        self.transform.localScale = Vector3.one * 0.4
    else
        self.transform.localScale = Vector3.one * 0.2
    end
    self.pi.sprite = GameResFactory.Instance():GetResSprite(data.CityMapIcon);
    if self:CheckIsMyWD(index) then
        self.pi.color = Color.blue
        if PlayerService.Instance():GetsuperiorLeagueId() ~= 0 then
            self.pi.color = Color.red
        end
    else
        if self:CheckIsOtherWD(index) then
            self.pi.color = Color.red
        else
            self.pi.color = Color.white
        end
    end
end

-- 检查是否在我的野城列表中
function UIPic:CheckIsMyWD(index)
    local list = BuildingService:Instance():GetBeOwnedWildCityList()
    if list ~= nil then
        for k, v in pairs(list._list) do
            if v.index == index and v.occupyLeagueId == PlayerService:Instance():GetLeagueId() then
                return true
            end
        end
    end
    return false
end

-- 检查是否在地方的野城列表中
function UIPic:CheckIsOtherWD(index)
    local list = BuildingService:Instance():GetBeOwnedWildCityList()
    if list ~= nil then
        for k, v in pairs(list._list) do
            if v.index == index and v.occupyLeagueId ~= PlayerService:Instance():GetLeagueId() then
                return true
            end
        end
    end
    return false
end

function UIPic:SetPicMinMessage(data, obj)
    self.obj = obj;
    local x, y = MapService:Instance():GetTiledCoordinate(data);
    local pos = self:GetMinUGUIPos(x, y)
    self.transform.localPosition = Vector3.New(- pos.x, pos.y, 0)
    self.transform.localScale = Vector3.one * 0.1
    self.transform:SetAsFirstSibling();
    self.pi.color = Color.green
    if self:CheckIsMyFort(data) then
        self.pi.sprite = GameResFactory.Instance():GetResSprite(MyFort);
        self.transform.localScale = Vector3.one * 0.2
    end
end

function UIPic:CheckIsMyFort(index)
    local cityTable = PlayerService:Instance():GetPlayerCityList();
    local matelist = List.new();
    for k, v in pairs(cityTable) do
        matelist:Push(v)
    end
    for i = 1, PlayerService:Instance():GetFortCount() do
        matelist:Push(PlayerService:Instance():GetFort(i));
    end
    for k, v in pairs(matelist._list) do
        if v._tiledId == index or v.tiledId == index then
            return true
        end
    end
    return false
end


function UIPic:SetMinWildPicMessage(data, obj)
    self.obj = obj;
    local x = data.Coordinatex;
    local y = data.Coordinatey;
    local index = MapService:Instance():GetTiledIndex(x, y);
    local pos = self:GetMinUGUIPos(x, y)
    self.transform.localPosition = Vector3.New(- pos.x, pos.y, 0)
    self.transform.localScale = Vector3.one * 0.15
    if self:CheckIsMyWD(index) then
        self.pi.color = Color.blue
    else
        if self:CheckIsOtherWD(index) then
            self.pi.color = Color.red
        else
            self.pi.color = Color.white
        end
    end
end



function UIPic:SetSelfPicMessage(index, obj)
    self.obj = obj;
    local x, y = MapService:Instance():GetTiledCoordinate(index);
    local pos = self:GetUGUIPos(x, y)
    self.transform.localPosition = Vector3.New(- pos.x, pos.y, 0)
    local isfisrt = PmapService:Instance():GetIsFirstMap();
    if isfisrt then
        self.transform.localScale = Vector3.one * 0.3
    else
        self.transform.localScale = Vector3.one * 0.1
    end
    self.pi.color = Color.green;
    if index == PlayerService:Instance():GetMainCityTiledId() then
        self.pi.sprite = GameResFactory.Instance():GetResSprite(mycity);
        self.pi.gameObject.transform:SetAsLastSibling()
        return
    end
    local cityTable = PlayerService:Instance():GetPlayerCityList();
    local fortList = List.new();
    for i = 1, PlayerService:Instance():GetFortCount() do
        fortList:Push(PlayerService:Instance():GetFort(i));
    end
    for k, v in pairs(cityTable) do
        if v.tiledId == index then
            self.pi.sprite = GameResFactory.Instance():GetResSprite(MySecondCity);
            return
        end
    end
    for k, v in pairs(fortList._list) do
        if v._tiledId == index then
            self.pi.sprite = GameResFactory.Instance():GetResSprite(MyFort);
            return
        end
    end

end

function UIPic:SetMemberPicMessage(data, obj)
    self.obj = obj;
    local x, y = MapService:Instance():GetTiledCoordinate(data.coord);
    local pos = self:GetUGUIPos(x, y)
    self.transform.localPosition = Vector3.New(- pos.x, pos.y, 0)
    local isfisrt = PmapService:Instance():GetIsFirstMap();
    if isfisrt then
        self.transform.localScale = Vector3.one * 0.3
    else
        self.transform.localScale = Vector3.one * 0.2
    end
    if data.coord == PlayerService:Instance():GetMainCityTiledId() then
        self.pi.gameObject:SetActive(false)
    else
        self.pi.color = Color.blue;
        self.pi.sprite = GameResFactory.Instance():GetResSprite(mycity);
    end
end

function UIPic:OnShow()



end

function UIPic:SetMarkPicMessage(data, obj)
    self.obj = obj;
    local x, y = MapService:Instance():GetTiledCoordinate(data.coord);
    local pos = self:GetUGUIPos(x, y)
    self.transform.localPosition = Vector3.New(- pos.x, pos.y, 0)
    local isfisrt = PmapService:Instance():GetIsFirstMap();
    self.pi.sprite = GameResFactory.Instance():GetResSprite(LeagueMarkPic);
    if isfisrt then
        self.transform.localScale = Vector3.one * 0.3
    else
        self.transform.localScale = Vector3.one * 0.15
    end
    self.pi.color = Color.blue;
end

-- 小地图UGUI坐标
function UIPic:GetMinUGUIPos(x, y)
    local UIPosX, UIPosY;
    UIPosX =(x - y) * minMapWidth / MapLoad:GetWidth() / 2
    UIPosY = -(y + x + 1) * minMapHeight / MapLoad:GetHeight() / 2 + minMapHeight / 2
    return Vector3.New(UIPosX, UIPosY, 0)
end


-- T弹出地图UGUI坐标
function UIPic:GetUGUIPos(x, y)
    local UIPosX, UIPosY;
    UIPosX =(x - y) * MapWidth / MapLoad:GetWidth() / 2
    UIPosY = -(y + x + 1) * MapHeight / MapLoad:GetHeight() / 2 + MapHeight / 2
    return Vector3.New(UIPosX, UIPosY, 0)
end

return UIPic