-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
-- Anchor:Dr
-- Date 16/9/14
-- 同盟信息类
local BuildingFirstBattleInfo = class("BuildingFirstBattleInfo");

function BuildingFirstBattleInfo:ctor()

    self.leagueid = 0;
    self.leaguename = "";
    self.leagueleader = 0;

    self.firstkill = "";
    self.secondkill = "";
    self.thirdkill = ""


    self.firstkillnum = 0;
    self.secondkillnum = 0
    self.thirdkillnum = 0;

    self.fatkcity = ""
    self.satkcity = ""
    self.tatkcity = ""

    self.fatkcitynum = 0
    self.satkcitynum = 0
    self.tatkcitynum = 0;

end


return BuildingFirstBattleInfo;
