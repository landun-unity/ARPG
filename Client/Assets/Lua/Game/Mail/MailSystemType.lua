--系统邮件分类
MailSystemType = 
{
    None = 0,
	FirstOccupation = 1,            --首占全盟奖励
    KillEnemy = 2,                  --杀敌奖励
    Demolition = 3,                 --拆迁奖励           
    OfficialAppointment = 4,        --官员任命
	OfficialRecall = 5,             --官员罢免
	PrefectAppointment = 6,         --太守任命
	PrefectRecall = 7,              --太守罢免
    InLeagueGroup = 8,              --加入同盟分组
    OutLeagueGroup = 9 ,            --退出同盟分组
    DissolutionLeagueGroup = 10,    --主动解散同盟分组
    DissolutionedLeagueGroup = 11,  --被动解散同盟分组
    InChatGroup = 12,               --加入聊天分组
    OutChatGroup = 13,              --退出聊天分组
    DissolutionChatGroup = 14,      --主动解散聊天分组
    DissolutionedChatGroup = 15,    --被动解散聊天分组
    LeaderAppointment = 16,         --禅让盟主
    WorldTendency = 17,             --天下大势
    Maneuver = 18,                  --演武活动奖励
    CameBack = 19,                  --回归奖励
    DeleteLeagueSign = 20,          --删除同盟标记
}

return MailSystemType
