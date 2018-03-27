--[[
    确定建造分城界面
--]]
local UIBase= require("Game/UI/UIBase");
local UIConfirmBuild=class("UIConfirmBuild",UIBase);        
local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");
local DataBuilding = require("Game/Table/model/DataBuilding")
local TiledManage = require("Game/Map/TiledManage")
local LoadResourcesPrefab = require("Game/Util/LoadResourcesPrefab")
local MapLoad = require("Game/Map/MapLoad")
local DataBannedWord = require("Game/Table/model/DataBannedWord")

--构造方法
function UIConfirmBuild:ctor()
    UIConfirmBuild.super.ctor(self);
    self._backBtn = nil;
    self._confirmBtn = nil;
    self._InputField = nil;
    self.coordinateText = nil;
    self.curTiledIndex = nil;
    self.cityName = nil;
    self._drawLoadResourcesPrefab = LoadResourcesPrefab.new()
    self._UISignObject = nil;   
    self._requestTimerTable = {};
    self._text = nil;
end

--注册控件
function UIConfirmBuild:DoDataExchange()
    self._backBtn = self:RegisterController(UnityEngine.UI.Button,"BackGround/backBtn");
    self._confirmBtn = self:RegisterController(UnityEngine.UI.Button,"BackGround/confirmBtn")
    self._InputField = self:RegisterController(UnityEngine.UI.InputField,"BackGround/InputField")
    self.coordinateText = self:RegisterController(UnityEngine.UI.Text,"BackGround/ChineseImage/BottomFiveImage/coordinateText")
    self.text = self:RegisterController(UnityEngine.UI.Text,"BackGround/ChineseImage/BottomFiveImage/Text")
end

--注册按钮点击事件
function UIConfirmBuild:DoEventAdd()
    self:AddListener(self._backBtn,self.OnClickBackBtn);
    self:AddListener(self._confirmBtn,self.OnClickConfirmBtn);
end

function UIConfirmBuild:OnShow(curTiledIndex)
    self.curTiledIndex = curTiledIndex
    self:SetCoords()
    self._InputField.text = "";
end

--取消按钮
function UIConfirmBuild:OnClickBackBtn()
    self._InputField.text = "";
    UIService:Instance():HideUI(UIType.UIConfirmBuild)
end

--确定按钮
function UIConfirmBuild:OnClickConfirmBtn()
    self.cityName = self._InputField.text
    local inputLength = self:CalcInputLength(self.cityName);
    LogManager:Instance():Log("输入长度:"..inputLength);
    if inputLength >18 then
        UIService:Instance():ShowUI(UIType.UICueMessageBox,UICueMessageType.cityName);
        return
    elseif CommonService:Instance():LimitText(self._InputField.text) == true then
        self._InputField.text = "";
        UIService:Instance():ShowUI(UIType.UICueMessageBox,7002);
        return;
    elseif self:DetectionTirm(self.cityName) ~= nil then
        UIService:Instance():ShowUI(UIType.UICueMessageBox,8010);
        return
    end
    -- 不能包含空格
    
    -- 发消息
    local msg = require("MessageCommon/Msg/C2L/Building/CreatePlayerSubCity").new();
    msg:SetMessageId(C2L_Building.CreatePlayerSubCity);
    msg.playerId = PlayerService:Instance():GetPlayerId();
    msg.tiledIndex = self.curTiledIndex;
    msg.name = self.cityName;
    msg.nameNum = 1
    -- msg.nameNum = PlayerService:Instance():GetFortNum();
    NetService:Instance():SendMessage(msg);


    -- self:BuildingSubCity();
    UIService:Instance():HideUI(UIType.UIConfirmBuild)
end

function UIConfirmBuild:DetectionTirm(str)
    return string.find(str, " ")
end

function UIConfirmBuild:CalcInputLength(inputstr)
    -- 计算字符串宽度
    -- 可以计算出字符宽度，用于显示使用
    local lenInByte = #inputstr
    local width = 0
    local i = 1
    while (i<=lenInByte) 
    do
        local curByte = string.byte(inputstr, i)
        local byteCount = 1;
        if curByte>0 and curByte<=127 then
            byteCount = 1;                                             --1字节字符
        elseif curByte>=192 and curByte<223 then
            byteCount = 2                                               --双字节字符
        elseif curByte>=224 and curByte<239 then
            byteCount = 3                                               --汉字
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4                                               --4字节字符
        end
         
        --local char = string.sub(inputstr, i, i+byteCount-1)
        --print(char .. "   " .. byteCount)                                                          --看看这个字是什么
        i = i + byteCount                                              -- 重置下一字节的索引
        width = width + byteCount                                             -- 字符的个数（长度）
    end
    return width
end

function UIConfirmBuild:SetCoords()
    local tiled = MapService:Instance():GetTiledByIndex(self.curTiledIndex)
    local resource = tiled:GetResource()
    local tiledLv = resource.TileLv;
    local tiledX = tiled:GetX()
    local tiledY = tiled:GetY()
    self.coordinateText.text = "是否在土地Lv."..tiledLv;
    self.text.text  = "(".."<color=#6BA0D3FF>"..tiledX.."</color>"..",".."<color=#6BA0D3FF>"..tiledY.."</color>"..")".."<color=#816C3AFF>建造分城</color>"
end

function UIConfirmBuild:BuildingSubCity(index,endTime)
    local tiled = MapService:Instance():GetTiledByIndex(self.curTiledIndex);
    
    self._drawLoadResourcesPrefab:SetResPath("Map/SubCityImage")
    self._drawLoadResourcesPrefab:Load(parent, function (UISignObject)
        -- self._UISignObject = UISignObject
        PlayerService:Instance():InsertFortMap(self.curTiledIndex, UISignObject)
        self:_OnShowMarkSign(UISignObject, parent, tiled,index,endTime)
    end)
end

function UIConfirmBuild:_OnShowMarkSign(UISignObject, parent, tiled,index,endTime)
    UISignObject:SetActive(false)
    UISignObject:SetActive(true)
    tiled:SetTiledImage(LayerType.Building, UISignObject.transform);
    
    self:_OnShowSubCity(UISignObject,parent,index,endTime)
end



function UIConfirmBuild:BuildCitEnd(timeText,obj)
    timeText.gameObject:SetActive(false);
    -- obj.gameObject:SetActive(false);
end

return UIConfirmBuild;