-- 聊天内容类型

ChatContentType =
{
   --（聊天内容）
   StringType = 1;
   --（战争事件）
   --同盟与同盟
   FightAAType = 2;
   --同盟与野城
   FightAWType = 3;
   --战报类型
   BattleReportType = 4;
   --（系统事件）
   --加入同盟
   JoinAllianceType = 5;
   --退出同盟
   SignAllianceType = 6;
   --征兵完成
   ConscriptionType = 7;
   --与玩家交战
   PlayerBattleType = 8;
   --打地
   LandBattleType = 9;
   --打野城
   CityBattleType = 10;
   --屯田
   MitaType = 11;
   --练兵
   TrainingType = 12;
   --卡包
   CardType = 13;
   --经验书
   ExperienceType = 14;
   --设施建造完成
   FacilityType = 15;
   --自建建筑建造完成
   PlayerFacilityType = 16;
   --建立势力
   EstablishType = 17;
   --脱离附属
   OutAttachmentType = 18;
   --全盟沦陷
   FallAllianceType = 19;
   --建筑战报
   WildBattleReportType = 20;
   --贼兵
   ThiefEnemyType = 21;
   --失去领地
   LoseLandType = 22;
   --首次攻城(世界)
   FirstWildBattleWType = 23;
   --首次攻城(州)
   FirstWildBattleSType = 24;
   --被解救
   RescueType = 25;
   --个人沦陷
   PlayerFallType = 26;
}

return ChatContentType;