-- 点击类型

ClickType = 
{
    -- 野城
    WildBuilding = 0,

    -- 野城 城区
    WildTown = 1, 

    -- 资源地
    Resource = 2, 

    -- 山 
    Moutain = 3, 

    -- 边界
    Border = 4, 

    -- 河流
    River = 5, 

    -- 玩家城市
    PlayerBuilding = 6,

    -- 玩家城区
    PlayerTown = 7, 

    --野外军营
    WildBarracks = 8,
    
    --野外要塞
    WildFort = 9,

    --自建要塞
    SelfFort = 10,

    -- 玩家拥有的地
    OwnerLand = 11,

    -- 公有界面
    PublicType = 12,

    -- 其他玩家城池
    OtherCity = 13,

    -- 其他玩家的城池
    OtherCityTown = 14,

    -- 分城
    PlayerPointsCityBuilding = 15,

    -- 被占领的其他玩家的城池
    OccupyOtherCityTown = 16,

    -- 在建中建筑物
    OnBuilding = 17,

    -- 其他玩家要塞
    OtherFort = 18,

    -- 被占领的自己的城区
    OccupyMyCityTown = 19,

    OccupyWildFort = 20,
    -- 在建中的分城城皮
    OnSubCity = 21,

    OtherWildFort = 22,

    DerelictionWildFort = 23,

    -- 码头
    Boat = 24,

    -- 关卡码头
    CampBoat = 25,

    -- 野外军营
    WildMilitaryCamp = 26,

    
    NoOccupyWildMilitaryCamp = 27,
}

return ClickType;
