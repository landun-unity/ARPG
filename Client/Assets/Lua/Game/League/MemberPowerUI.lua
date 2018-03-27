--region *.lua
--Date
local UIBase= require("Game/UI/UIBase")

local UIService=require("Game/UI/UIService")

local MemberPowerUI = class("MemberPowerUI",UIBase)



function MemberPowerUI:ctor()

    MemberPowerUI.super.ctor(self);
    self.title =nil;
    self.targetId =nil;
    self.LeagueBackBtn=nil;
    self.QuitLeagueBtn=nil;
    self.memberQuitLeague =1;
end



--ע���ؼ�
function MemberPowerUI:DoDataExchange()

    self.LeagueBackBtn=self:RegisterController(UnityEngine.UI.Button,"Back")
    self.QuitLeagueBtn=self:RegisterController(UnityEngine.UI.Button,"Button")

end

--ע�������¼�
function MemberPowerUI:DoEventAdd()

    self:AddListener(self.LeagueBackBtn,self.OnClickLeagueBackBtn)
    self:AddListener(self.QuitLeagueBtn,self.OnClickQuitLeagueBtn)

end
    

function MemberPowerUI:OnClickLeagueBackBtn()

    UIService:Instance():HideUI(UIType.MemberPowerUI)

end

function MemberPowerUI:OnClickQuitLeagueBtn()

    local data = { self, self.QuitLeague,self.memberQuitLeague,"1.退出同盟将清空同盟贡献，并失去同盟所有收益\n2.退出同盟不需要盟主同意，确认退出后将立即退出同盟\n3.未加入同盟的势力将不能攻打城池和附属其他势力\n4.沦陷状态的势力退出同盟后将不能再创建或加入同盟\n5.退出同盟24小时候才能再创建或加入同盟\n6.退出同盟并不会解除沦陷状态","退出同盟","请在下方输入“退出”来确认本次操作"}
    UIService:Instance():ShowUI(UIType.ConfirmQuitLeague, data)


end

function MemberPowerUI:QuitLeague()

    LeagueService:Instance():SendQuitLeague(PlayerService:Instance():GetPlayerId());
    UIService:Instance():HideUI(UIType.MemberPowerUI)

end


return MemberPowerUI

