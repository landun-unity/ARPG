--region *.lua
--Date 16/10/12
--同盟UI界面

    local UIBase= require("Game/UI/UIBase")
    local LeagueUI=class("LeagueUI",UIBase)
    local UIType=require("Game/UI/UIType")


function LeagueUI:ctor( )
    LeagueUI.super.ctor(self);

end


--注册控件
function LeagueUI:DoDataExchange()

    --print("LeagueUI".."RegisterController")
    startBtn=self:RegisterController(UnityEngine.UI.Button,"Button")
    testText=self:RegisterController(UnityEngine.UI.Text,"Text")

end

    
--注册控件点击事件
function LeagueUI:DoEventAdd()

  self:AddListener(startBtn,self.OnClickStartBtn)

end


--点击开始游戏按钮逻辑
function LeagueUI:OnClickStartBtn()

  --同盟存在情况
  --向服务器发送是否存在同盟

   --print(PlayerService:Instance():GetPlayerId());

end

    return LeagueUI
--endregion
