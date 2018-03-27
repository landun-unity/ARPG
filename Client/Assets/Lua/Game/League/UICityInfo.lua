-- region *.lua
-- Date
local UIBase = require("Game/UI/UIBase");
local UICityInfo = class("UICityInfo", UIBase)

function UICityInfo:ctor()

    UICityInfo.super.ctor(self)

    self.Name = nil;
    self.NameBtn = nil;
    self.Pro = nil;
    self.Citytype = nil;
    self.Coordx = nil;
    self.x = nil;
    self.y = nil;
    self.Coordy = nil;
    self.CoordBtn = nil;
    self.targetId = nil;
    self._tiledManage = require("Game/Map/TiledManage").new();
end


function UICityInfo:DoDataExchange()
    self.Name = self:RegisterController(UnityEngine.UI.Text, "cityname/Text");
    self.NameBtn = self:RegisterController(UnityEngine.UI.Button, "cityname");
    self.Pro = self:RegisterController(UnityEngine.UI.Text, "Pro");
    self.Citytype = self:RegisterController(UnityEngine.UI.Text, "citytype");
    self.Coordx = self:RegisterController(UnityEngine.UI.Text, "coord/coordx");
    self.Coordy = self:RegisterController(UnityEngine.UI.Text, "coord/coordy");
    self.CoordBtn = self:RegisterController(UnityEngine.UI.Button, "coord");
end

function UICityInfo:DoEventAdd()

    self:AddListener(self.NameBtn.gameObject, self.OnClickNameBtn);
    self:AddListener(self.CoordBtn.gameObject, self.OnClickCoordBtn);

end


function UICityInfo:OnShow()



end

function UICityInfo:SetCityInfo(args)

    self.targetId = args._owner;
    self.Name.text = args._dataInfo.Name;
    self.Pro.text = DataState[args._dataInfo.StateCN[1]].Name;
    -- 大城=1;中城=2;小城=3;郡城=4;首府=5;国都=6;关卡=7;码头=8
    if args._dataInfo.CityType == 1 then
        self.Citytype.text = "城池"
    end
    if args._dataInfo.CityType == 2 then
        self.Citytype.text = "城池"
    end
    if args._dataInfo.CityType == 3 then
        self.Citytype.text = "城池"
    end
    if args._dataInfo.CityType == 4 then
        self.Citytype.text = "郡城"
    end
    if args._dataInfo.CityType == 5 then
        self.Citytype.text = "首府"
    end
    if args._dataInfo.CityType == 6 then
        self.Citytype.text = "国都"
    end
    if args._dataInfo.CityType == 7 then
        self.Citytype.text = "关卡"
        self.Pro.text = "--"
    end
    if args._dataInfo.CityType == 8 then
        self.Pro.text = "--"
        self.Citytype.text = "码头"
    end
    self.x = args._dataInfo.Coordinatex
    self.y = args._dataInfo.Coordinatey
    self.Coordx.text = "(" .. args._dataInfo.Coordinatex .. ",";
    self.Coordy.text = args._dataInfo.Coordinatey .. ")";

end


function UICityInfo:OnClickNameBtn()
    local playerId = nil;
    LeagueService:Instance():SendPlayerInfo(playerId, self.targetId)
end


function UICityInfo:OnClickCoordBtn()


    self.temp = { };
    self.temp[1] = "是否跳转到坐标（" .. self.Coordx.text ..",".. self.Coordy.text..")";
    self.temp[2] = self;
    self.temp[3] = self.ConfirmGoto;
    UIService:Instance():ShowUI(UIType.CommonGoToPosition, self.temp)

end


function UICityInfo:ConfirmGoto()

    local tiledIndex = self._tiledManage:GetTiledIndex(self.x, self.y);
    MapService:Instance():ScanTiled(tiledIndex)
    UIService:Instance():HideUI(UIType.LeagueInfluence)
    UIService:Instance():ShowUI(UIType.UIGameMainView)
    UIService:Instance():HideUI(UIType.LeagueExistUI)

end



return UICityInfo