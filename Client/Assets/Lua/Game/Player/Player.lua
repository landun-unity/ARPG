--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
-- Anchor:Dr
-- Date 16/9/14
-- 同盟信息类
local Player = class("Player");

function Player:ctor()

    Player.super.ctor(self);
    --
    -- 名称
    --
    self.name = "";
    
    --
    -- 主城的格子
    --
    self.mainCityTiledId = 0;
    
    --
    -- 主城的表Id
    --
    self.mainCityTableId = 0;
    
    --
    -- 主城的Id
    --
    self.mainCityId = 0;
    
    --
    -- 上级盟id
    --
    self.superiorLeagueId = 0;
    
    --
    -- 自己盟id
    --
    self.leagueId = 0;
    
    --
    -- 自己在盟中的职位
    --
    self.title = 0;



    self.leagueLevel = 0;
   
end



return Player;


--endregion
