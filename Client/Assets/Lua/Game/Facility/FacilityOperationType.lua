
FacilityOperationType = 
{
     --升级设施成功
     UpgradeFacilitySuccess = 1,
  
     --没有足够资源
     HaveNotEnoughResource = 2,
     
      --没有足够玉
     HaveNotEnoughJade = 3,

     -- 已达最高等级
     AlreadyMaxLevel = 4,
  
     -- 未到达建造条件
      CanNotBuild = 5,
  
     --建筑不属于该玩家
      BulidingNotBeyondPlayer = 6,

      AlreadyUpgradeIng = 7,

      FacilityNotInUpgrade = 8, 

      ClientSendTitleIsnull = 9,

      AlreadyExpand = 10,

      CanNotUpgradeAddition = 11,
  
     --最大值
      Max;
}

return FacilityOperationType;