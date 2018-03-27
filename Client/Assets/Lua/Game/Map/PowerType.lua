
-- 势力类型
PowerType = 
{
    -- 空
    Empty = 0, 

    -- 友方
    Friend = 1, 

    -- 友方被沦陷
    FriendBeFalled = 2,

    -- 敌方被沦陷
    EnemyBeFalled = 3,

    -- 自身
    Self = 4,

    -- 上级盟
    SuperLeague = 5,

    -- 敌方
    Enemy = 6,  

    -- 被我的同盟沦陷（我的下级盟）
    BeFalledByMyLeague = 7,

    -- 无
    Null = 8, 
}

return PowerType;