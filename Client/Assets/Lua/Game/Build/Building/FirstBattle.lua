--region *.lua
--Date
local UIBase = require("Game/UI/UIBase");
local FirstBattle = class("FirstBattle",UIBase)

function FirstBattle:ctor()
    
    FirstBattle.super.ctor(self)

        -- 首战奖励UI界面
    self.firstBattleInfo = nil;
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


function FirstBattle:DoDataExchange()
 -- 首战奖励UI界面
    
    self.leaguename = self:RegisterController(UnityEngine.UI.Text, "firstBattleInfo/firstleague");
    self.leagueleader = self:RegisterController(UnityEngine.UI.Text, "firstBattleInfo/firstleader");

    self.firstkill = self:RegisterController(UnityEngine.UI.Text, "firstBattleInfo/firstkill");
    self.secondkill = self:RegisterController(UnityEngine.UI.Text, "firstBattleInfo/secondkill");
    self.thirdkill = self:RegisterController(UnityEngine.UI.Text, "firstBattleInfo/thirdkill");


    self.firstkillnum = self:RegisterController(UnityEngine.UI.Text, "firstBattleInfo/firstkillnum");
    self.secondkillnum = self:RegisterController(UnityEngine.UI.Text, "firstBattleInfo/secondkillnum");
    self.thirdkillnum = self:RegisterController(UnityEngine.UI.Text, "firstBattleInfo/thirdkillnum");

    self.fatkcity = self:RegisterController(UnityEngine.UI.Text, "firstBattleInfo/firstatkcity");
    self.satkcity = self:RegisterController(UnityEngine.UI.Text, "firstBattleInfo/secondatkcity");
    self.tatkcity = self:RegisterController(UnityEngine.UI.Text, "firstBattleInfo/thirdatkcity");

    self.fatkcitynum = self:RegisterController(UnityEngine.UI.Text, "firstBattleInfo/firstatkcitynum");
    self.satkcitynum = self:RegisterController(UnityEngine.UI.Text, "firstBattleInfo/secondatkcitynum");
    self.tatkcitynum = self:RegisterController(UnityEngine.UI.Text, "firstBattleInfo/thirdatkcitynum");
    
end

function FirstBattle:DoEventAdd()

    

end


function FirstBattle:OnShow(bd)
            
            self.transform.parent =  self.gameObject.transform:Find("WildernesUI/");
            self.transform.localPosition = Vector3.New(30.-580,0) 
            self.leagueid = bd.leagueid
            self.leaguename.text = bd.leaguename
            self.leagueleader.text = bd.leagueleader

            self.firstkill.text = bd.firstkill
            self.secondkill.text = bd.secondkill
            self.thirdkill.text = bd.thirdkill


            self.firstkillnum.text = bd.firstkillnum
            self.secondkillnum.text = bd.secondkillnum
            self.thirdkillnum.text = bd.thirdkillnum

            self.fatkcity.text = bd.fatkcity
            self.satkcity.text = bd.satkcity
            self.tatkcity.text = bd.tatkcity

            self.fatkcitynum.text = bd.fatkcitynum
            self.satkcitynum.text = bd.satkcitynum
            self.tatkcitynum.text = bd.tatkcitynum;
end


return FirstBattle