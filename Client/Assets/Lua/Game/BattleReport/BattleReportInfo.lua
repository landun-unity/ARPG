
--Õ½±¨ÐÅÏ¢ Õâ¸öÊÇÓÃÀ´¹ÜÀíµÄÕ½±¨ÐÅÏ¢
local BattleReportInfo = class("BattleReportInfo")

function BattleReportInfo:ctor()

    --
    -- Î¨Ò»ID
    --
    self._iD = 0;
    
	--
    -- Õ½¶·ÀàÐÍ ÊÇ¹¥»÷µÄ»¹ÊÇ·ÀÊØ
    --
    self._battleType = 0;
    
    --
    -- Õ½¶··¢ÉúÎ»ÖÃÊÇÍÁµØ»¹ÊÇ³Ç³Ø
    --
    self._placeType = 0;
    
    --
    -- Õ½¶·Î»ÖÃ
    --
    self._tileIndex = 0;
    
    --
    -- Õ½¶·Ê±¼ä
    --
    self._fightTime = 0;
    
    --
    -- ¹¥»÷·½µÄ±íID
    --
    self._aCardTableID = 0;
    
    --
    -- ¹¥»÷·½µÄµÈ¼¶
    --
    self._aCardLevel = 0;

    --
    -- ¹¥»÷·½µÄ½ø½×ÐÇ¼¶
    --
    self._aAdvanceStar = 0;
    
    --
    -- ·ÀÊØµÄ±íID
    --
    self._dCardTableID = 0;
    
    --
    -- ·ÀÊØ·½µÄµÈ¼¶
    --
    self._dCardLevel = 0;
    
    --
    -- ·ÀÊØ·½µÄ½ø½×ÐÇ¼¶
    --
    self._dAdvanceStar = 0;

    --
    -- ¹¥»÷·½µÄÃû×Ö
    --
    self._aPlayerName = "";
    
    --
    -- ¹¥»÷·½µÄÁªÃËÃû×Ö
    --
    self._aleagueName = "";
    
    --
    -- ·ÀÊØµÄÃû×Ö
    --
    self._dPlayerName = "";
    
    --
    -- ·ÀÊØµÄÁªÃËÃû×Ö
    --
    self._dleagueName = "";
    
    --
    -- ¹¥»÷·½µÄ±øÁ¦
    --
    self._aTroopNum = 0;
    
    --
    -- ·ÀÊØ·½µÄ±øÁ¦
    --
    self._dTroopNum = 0;
    
    --
    -- Õ½¶·½á¹û£º Ó®  Êä  Æ½
    --
    self._resultType = 0;
    
    --
    -- Õ½±¨¶þ½øÖÆÁ÷µÄÎ¨Ò»ID
    --
    self._byteArryID = 0;
    
    --
    -- Õ½±¨ÊÇ·ñÒÑ¶Á
    --
    self._isRead = false;

    --战报类型
    self._reportType = 0;

    --战平次数
    self._drawTimes = 0;

    --是否是连续战报
    self._isContinueReport = false;

    --若是连续战报则是连续战报的个数
    self._continueReportCount = 0;

    --若是连续战报则是index
    self._continueIndex = 0;

    --是否展开
    self._isOpen = false;

end

return BattleReportInfo

