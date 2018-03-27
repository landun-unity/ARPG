--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local UIBase = require("Game/UI/UIBase");
local UIArmyFlag = class("UIArmyFlag", UIBase);

-- 构造函数
function UIArmyFlag:ctor()
    UIArmyFlag.super.ctor(self);
    self._choosePanel = nil;
    self._isEnemy = false;
    -- 自己部队的产生建筑
    self._cityId = nil;
    -- 自己部队保存槽位 别人部队保存line的id
    self._armyIndex = 0;
    
    self.curLine = nil;
    
    self.goPositionY = 120;
    self.backPositionY = -54;
    self.slantPositionY = 100;

    self.yDistance = 130;
    self.xDistance = 210;
    self.yPosition = -20;        --水平y轴偏移
    self.yDisPositionUp = 60;

    self.diaDisPositionUp = 30;
    self.diaxDistanece = 170;
    self.diayDistanece = 80;

    self.startFrameCount = 0;    --初始帧
    self.perFrame = 3;           --每张图片的播放帧率
    self.allFrameCount = 30;     --整个动画的播放帧率
    self.imageTables = {};
end

-- 控件查找
function UIArmyFlag:DoDataExchange(args)
    self._choosePanel = self:RegisterController(UnityEngine.Transform, "Choose");
    self.animationParent = self:RegisterController(UnityEngine.Transform, "WalkingImageParent");
    for i =1 ,self.animationParent.childCount do
        local item = self.animationParent:GetChild(i-1);
        if self.imageTables[i] == nil then
            self.imageTables[i] = item.gameObject;
        end
    end
end

-- 控件事件添加
function UIArmyFlag:DoEventAdd()
    self:AddListener(self.transform:GetComponent(typeof(UnityEngine.UI.Button)),self.OnChooseArmy);
end

function UIArmyFlag:_OnHeartBeat()
    --实现部队行走动画效果
    if self.gameObject.activeSelf == true then
        if (Time.frameCount - self.startFrameCount) % self.perFrame == 0 then
            for i =1 ,#self.imageTables do            
                if i == math.floor((Time.frameCount- self.startFrameCount)/self.perFrame) then
                    self.imageTables[i]:SetActive(true);
                    if i>1 and i<=#self.imageTables then
                        self.imageTables[i-1]:SetActive(false);
                    else
                        self.imageTables[#self.imageTables]:SetActive(false);
                    end
                end
            end
        end
        if (Time.frameCount - self.startFrameCount) % self.allFrameCount == 0 then
            self.startFrameCount = Time.frameCount;
        end
        --self:SetChooseCirclePosition();
    end
end

function UIArmyFlag:InitValue(lineId)
    self._choosePanel.gameObject:SetActive(false);
    local line = LineService:Instance():GetLine(lineId);
    if line ~= nil then
        self.curLine = line;
        --print("！！！！！！！！！！！！！！！！！！！！！！！！！线的角度:"..line.angle);
        self.startFrameCount = Time.frameCount;
        self._cityId = line.buildingId;
        self._isEnemy = line:IsOtherArmy();
        if self._isEnemy == true then
            self._armyIndex = line.id;
            self._choosePanel:FindChild("Green").gameObject:SetActive(false);
            local myLeagueId = PlayerService:Instance():GetLeagueId();
            local mySuperLeagueId = PlayerService:Instance():GetsuperiorLeagueId();
            if mySuperLeagueId == 0 and myLeagueId ~= 0 and myLeagueId == line.leagueId then
                self._choosePanel:FindChild("Red").gameObject:SetActive(false);
                self._choosePanel:FindChild("Blue").gameObject:SetActive(true);
            else
                self._choosePanel:FindChild("Red").gameObject:SetActive(true);
                self._choosePanel:FindChild("Blue").gameObject:SetActive(false);
            end
        else
            self._armyIndex = line.armySlotIndex;
            self._choosePanel:FindChild("Green").gameObject:SetActive(true);
            self._choosePanel:FindChild("Red").gameObject:SetActive(false);
            self._choosePanel:FindChild("Blue").gameObject:SetActive(false);
        end
        --设置部队行走动画图片
        self:SetArmyWalkImage(line.angle);
        self:SetChooseCirclePosition();
    end
end

function UIArmyFlag:OnChooseArmy()
    if self._isEnemy == true then
        local enemyLine = LineService:Instance():GetLine(self._armyIndex);
        if enemyLine ~= nil then
            self:EnterDetailUI();
        end
    else
        local armyInfo = ArmyService:Instance():GetArmyInCity(self._cityId, self._armyIndex);
        if armyInfo ~= nil then
            self:EnterDetailUI();
        end
    end
end

function UIArmyFlag:EnterDetailUI()
    local param = {};
    param.isEnemy = 0;
    param.index = self._armyIndex;
    param.cityid = self._cityId;
    if self._isEnemy == true then
        param.isEnemy = 1;
        -- 若为敌方部队详情 param.cityid参数为1时是点击大地图上部队进来的 为0时是点击左侧敌方提示进来的 为2是点击左侧敌方战平提示进来
        param.cityid = 1;
    end
    UIService:Instance():HideUI(UIType.UIArmyDetailGrid);
    UIService:Instance():ShowUI(UIType.UIArmyBattleDetail, param);
    if self._isEnemy == true then
         LineService:Instance():ChooseArmyLine(self._isEnemy, self._armyIndex, 0);
    else
         LineService:Instance():ChooseArmyLine(self._isEnemy, self._armyIndex, self._cityId);
    end
end

function UIArmyFlag:ShowChoosePanel()
    if self._choosePanel.gameObject.activeSelf == true then
        return;
    end

    self._choosePanel.gameObject:SetActive(true);
end

function UIArmyFlag:HideChoosePanel()
    if self._choosePanel.gameObject.activeSelf == false then
        return;
    end

    self._choosePanel.gameObject:SetActive(false);
end

function UIArmyFlag:SetArmyWalkImage(angle)
    self:SetArmyPosition(angle);
    local path = "Troops_";
    local rotationY = 0;
    if  angle > 12.5 and angle < 62.5 then
        path = path.."45_";
        rotationY = 180;
    elseif angle >= 62.5 and angle < 127.5 then
        path = path.."0_";
        rotationY = 0;
    elseif angle >= 127.5 and angle < 167.5 then
        path = path.."45_";
        rotationY = 0;
    elseif angle >= 167.5 and angle < 192.5 then
        path = path.."90_";
        rotationY = 0;
    elseif angle >= 192.5 and angle < 242.5 then
        path = path.."135_";
        rotationY = 180; 
    elseif angle >= 242.5 and angle < 307.5 then
        path = path.."180_";
        rotationY = 0;
    elseif angle >= 307.5 and angle < 347.5 then
        path = path.."135_";
        rotationY = 0;
    elseif (angle >= 347.5 and angle <= 360) or angle < 12.5 then
        path = path.."90_";
        rotationY = 180;
    end
    for i =1 ,#self.imageTables do
        if i < #self.imageTables then
            self.imageTables[i]:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(path.."0"..i);
        else
            self.imageTables[i]:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(path..i);    
        end
        self.imageTables[i].transform.localRotation = Quaternion.Euler(Vector3.New(0,rotationY,0));
    end
end

function UIArmyFlag:SetArmyPosition(angle)
    if angle >=242.5 and angle<307.5 then                                           --下
        self.animationParent.localPosition = Vector3.New(0,self.goPositionY,0);
    elseif angle >=62.5 and angle<127.5 then                                        --上   
        self.animationParent.localPosition = Vector3.New(0,self.backPositionY,0);
    elseif(angle >=0 and angle<12.5) or  (angle >=347.5 and angle<=360) then        --右
        self.animationParent.localPosition = Vector3.New(-self.goPositionY,-self.backPositionY/2,0);
    elseif angle >=167.5 and angle<192.5 then                                       --左  
        self.animationParent.localPosition = Vector3.New(self.goPositionY,-self.backPositionY/2,0);
    elseif angle >=12.5 and angle<62.5 then                                         --右上 
        self.animationParent.localPosition = Vector3.New(-self.slantPositionY,0,0);
    elseif angle >=127.5 and angle<167.5 then                                       --左上 
        self.animationParent.localPosition = Vector3.New(self.goPositionY,0,0);
    elseif angle >=307.5 and angle<347.5 then                                       --右下
        self.animationParent.localPosition = Vector3.New(-self.slantPositionY,self.slantPositionY,0);
    elseif angle >=192.5 and angle<242.5 then                                       --左下
        self.animationParent.localPosition = Vector3.New(self.goPositionY,self.goPositionY,0); 
    end
end

--选中部队行走动画时底座图片的位置设置
function UIArmyFlag:SetChooseCirclePosition()
    local curTimeStamp = PlayerService:Instance():GetLocalTime();
    --local coeCount = (curTimeStamp-self.curLine.startTime)/(self.curLine.endTime - self.curLine.startTime);
    local coeCount = 0;
    if self.curLine ~= nil then
        local angle = self.curLine.angle;
        if angle >=242.5 and angle<307.5 then                                           --下
            self._choosePanel.localPosition = Vector3.New(0,self.animationParent.localPosition.y  - self.diaxDistanece * coeCount,0);
        elseif angle >=62.5 and angle<127.5 then                                        --上   
            self._choosePanel.localPosition = Vector3.New(0,self.animationParent.localPosition.y - self.yDisPositionUp + self.yDistance * coeCount,0);
        elseif(angle >=0 and angle<12.5) or  (angle >=347.5 and angle<=360) then         --右
            self._choosePanel.localPosition = Vector3.New(self.animationParent.localPosition.x - self.yDisPositionUp + self.xDistance * coeCount,self.yPosition,0);
        elseif angle >=167.5 and angle<192.5 then                                       --左  
             self._choosePanel.localPosition = Vector3.New(self.animationParent.localPosition.x + self.yDisPositionUp - self.xDistance * coeCount,self.yPosition,0);
        elseif angle >=12.5 and angle<62.5 then                                         --右上 
            self._choosePanel.localPosition = Vector3.New(self.animationParent.localPosition.x - self.yDisPositionUp + self.diaxDistanece * coeCount,
                self.animationParent.localPosition.y - self.yDisPositionUp + self.diayDistanece * coeCount,0);
        elseif angle >=127.5 and angle<167.5 then                                       --左上 
            self._choosePanel.localPosition = Vector3.New(self.animationParent.localPosition.x + self.diaDisPositionUp - self.diaxDistanece * coeCount,
                 self.animationParent.localPosition.y - self.yDisPositionUp + self.diayDistanece * coeCount,0);
        elseif angle >=307.5 and angle<347.5 then                                       --右下
            self._choosePanel.localPosition = Vector3.New(self.animationParent.localPosition.x - self.yDisPositionUp + self.diaxDistanece * coeCount,
                self.animationParent.localPosition.y - self.diayDistanece * coeCount,0);
        elseif angle >=192.5 and angle<242.5 then                                       --左下
            self._choosePanel.localPosition = Vector3.New(self.animationParent.localPosition.x + self.diaDisPositionUp - self.diaxDistanece * coeCount,
                self.animationParent.localPosition.y - self.diayDistanece * coeCount,0);
        end
    end
end

return UIArmyFlag;
