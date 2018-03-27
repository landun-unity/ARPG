
local GamePart = require("FrameWork/Game/GamePart")

local MarqueeManage = class("MarqueeManage",GamePart)
local DataRecharge = require("Game/Table/model/DataRecharge");
local CityBaseType = require("Game/Build/Building/CityBaseType");
local MarqueeType = require("Game/Marquee/MarqueeType");

function MarqueeManage:ctor()
    
    MarqueeManage.super.ctor(self)    
end

-- 初始化
function MarqueeManage:_OnInit()
end

-- 心跳
function MarqueeManage:_OnHeartBeat()
    
end

-- 停止
function MarqueeManage:_OnStop()
    
end

--接收跑马灯消息
function MarqueeManage:ReceiveMarqueeInfos(msg)
    local showContent = "";
    --  1、首占    2、 招募五星武将   3、天下大势  4、同盟攻城   5、占领高级地    
    if msg.marqueeType == MarqueeType.FirstOccupyLand then
        --local tilegData = DataTile[msg.parmter]
        showContent = showContent.."恭喜<color=#FFFF00>"..msg.name.."</color>首占<color=#FFFF00>"..msg.parmter.."级土地</color>";   
    elseif msg.marqueeType == MarqueeType.RecruitFiveStarCard then
        --print("招募到五星武将！！！"..msg.parmter)
        local heroInfo =  DataHero[msg.parmter];
        if heroInfo == nil then 
            print("error! hero is nil which hero id = "..msg.parmter);
            return;
        end
        showContent = showContent.."恭喜<color=#FFFF00>"..msg.name.."</color>抽到5星神将<color=#FFFF00>"..DataHero[msg.parmter].Name.."</color>";
    elseif msg.marqueeType == MarqueeType.WorldTendency then 
        local worldTendencyData = DataEpicEvent[msg.parmter];
        if worldTendencyData == nil then
            print("can't find table data in DataEpicEvent which id = "..msg.parmter);
        else
            --print(worldTendencyData.Name);
            showContent = showContent..worldTendencyData.NameDisplay.."达成天下大势<color=#FFFF00>"..worldTendencyData.Name.."</color>";
        end
    elseif msg.marqueeType == MarqueeType.LeagueOccupyCity then 
        local buildingData = DataBuilding[msg.parmter];
        if buildingData.CityType == CityBaseType.passcity then
            showContent =  showContent.."恭喜同盟<color=#FFFF00>"..msg.name.."</color>占领关卡<color=#FFFF00>"..buildingData.Name.."</color>";
        elseif buildingData.CityType == CityBaseType.boat then
            showContent =  showContent.."恭喜同盟<color=#FFFF00>"..msg.name.."</color>占领码头<color=#FFFF00>"..buildingData.Name.."</color>";
        else
            showContent =  showContent.."恭喜同盟<color=#FFFF00>"..msg.name.."</color>占领城池<color=#FFFF00>"..buildingData.Name.."</color>";
        end
    elseif msg.marqueeType == MarqueeType.OccupyHighLevelLand then 
        --local tilegData = DataTile[msg.parmter]
        showContent =  showContent.."恭喜<color=#FFFF00>"..msg.name.."</color>占领<color=#FFFF00>"..msg.parmter.."级土地</color>";
    end

    local baseClass = UIService:Instance():GetUIClass(UIType.GameBulletinBoardUI);
    local isopen = UIService:Instance():GetOpenedUI(UIType.GameBulletinBoardUI);
    if baseClass == nil or isopen == false then
        UIService:Instance():ShowUI(UIType.GameBulletinBoardUI,showContent);
    else
        baseClass:AddListInformation(showContent);
    end
end

return MarqueeManage