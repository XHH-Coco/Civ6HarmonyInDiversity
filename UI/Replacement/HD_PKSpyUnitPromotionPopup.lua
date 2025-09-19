
-- HD_PKSpyUnitPromotionPopup
-- Author: 皮皮凯
-- DateCreated: 2024/7/24 00:07:47
--------------------------------------------------------------

include("Civ6Common");
include("InstanceManager");
	
-- ===========================================================================
--	CONSTANTS
-- ===========================================================================
-- ExposedMembers.DLHD = ExposedMembers.DLHD or {};
-- ExposedMembers.DLHD.Utils = ExposedMembers.DLHD.Utils or {};
-- Utils = ExposedMembers.DLHD.Utils;

-- ===========================================================================
--	MEMBERS
-- ===========================================================================
local m_PromotionListInstanceMgr			:table	= InstanceManager:new( "PromotionSelectionInstance",			"PromotionSelection",	Controls.PromotionContainer );
local m_CompletedPromotionListInstanceMgr	:table	= InstanceManager:new( "CompletedPromotionSelectionInstance",	"PromotionSelection",	Controls.PromotionContainer );
local m_kLineIM		:table	= InstanceManager:new( "LineImageInstance", 					"LineImage",			Controls.PromotionContainer );

-- ===========================================================================
--	FUNCTIONS
-- ===========================================================================
-- 皮皮凯：一个简单的实现技能层级升级的UI面板，需求是实现 4 层 ，每层有 5 种技能， 
-- 遗憾的是这里是一个死板的4X5技能树横向，不是灵活的自动计算排列的技能面板
-- 这个面板允许玩家在单位升级时选择不同的技能分支
-- 每个层级有多个技能可供选择，但高级技能至少需要一个上一层的晋升
local SkillTree = {} -- 总技能表，数组表，元素是子表，每个子表代表一个层级的技能
local SkillLevelNum = 4 -- 技能树分支数量，存储每个层级的技能选项
local NumLevelSkills = 5 -- 每个层级技能数量
local keyByIndex = {} -- 技能索引表，用于快速查找技能索引，用不到删除相关即可

local SpySkillType = {}
for i = 1, SkillLevelNum do 
	SpySkillType[i] = {}
	local j = 1;
	for row in GameInfo.UnitPromotions() do

		if row.PromotionClass == "PROMOTION_CLASS_SPY" and row.Level == i then
			SpySkillType[i][j] = row;
			j = j+1;
		end
	end
end
-- 这是更多是个示范吧，这些是UI正常需要，显示技能名字，描述用来作UI提示，技能图标用来显示技能图标
for i = 1, SkillLevelNum do -- 4个层级
    SkillTree[i] = {} -- 子表初始化
	for j = 1, NumLevelSkills do -- 每个层级5个技能
		local index = SpySkillType[i][j].Index -- 技能索引,或许需要用到，如果是需要间谍单位存储自己的技能拥有情况
		SkillTree[i][j] = {
			Name = SpySkillType[i][j].Name, -- 技能名称
			Describe = SpySkillType[i][j].Description, -- 技能描述
			Icon = "ICON_" .. SpySkillType[i][j].UnitPromotionType, -- 技能图标
			Index = index,
			Can = i == 1,  -- 是否可解锁, 第一层升级打开页面时，所有技能都可以解锁，亦或者有其他判定技能是否可以升级
			Unlock = false, -- 是否是以升级的解锁状态
			UnlockCallback = function(iPlayerID, iUnitID, I,J) -- 这里可以设置解锁回调函数既升级接口
				local pPlayer = Players[iPlayerID];
				local pUnit = UnitManager.GetUnit(iPlayerID, iUnitID);
				local spyname = pUnit:GetName();
				
				-- 这里待补充：具体的升级效果接口
				-- XXXX(iPlayerID, iUnitID, I,J)
				if pPlayer then
					if (pUnit ~= nil) then
						local tParameters = {};
						tParameters[UnitCommandTypes.PARAM_PROMOTION_TYPE] = SpySkillType[I][J].Hash;
						UnitManager.RequestCommand( pUnit, UnitCommandTypes.PROMOTE, tParameters );
					end
				end
				-- 现在更新技能树
				-- SkillTree[I][J].Unlock = true -- 技能解锁
				-- if SkillTree[I + 1] then -- 更改下一层的解锁状态
				-- 	for _, skill in pairs(SkillTree[I + 1]) do 
				-- 		skill.Can = true
				-- 	end
				-- end

				-- Gamelua 存表 我不知道HD的Gamelua存单位表接口
				ExposedMembers.SPYPROMOTION.SetSpySkillTreeUnlock(iPlayerID, I,J, spyname)
				-- local pUnit = UnitManager.GetUnit(iPlayerID, iUnitID);
				-- pUnit:SetProperty("SPY_SKILL_TREE", SkillTree) -- 技能树存表
				-- Gamelua 存表
				-- 实际游戏中的分格应该是关闭面板，这里是为了演示，直接刷新技能树
				OnPromoteUnitPopup() -- 刷新技能树
				Close() -- 关闭技能升级面板
			end,  
		}
		keyByIndex[index] = {i, j} -- 技能索引表，用于快速查找技能索引
	end
end

-- ===========================================================================
--	Closes the immediate popup, will raise more if queued.
-- ===========================================================================
function Close()
	if UIManager:IsInPopupQueue(ContextPtr) then
		UIManager:DequeuePopup( ContextPtr );
	end
end

-- ===========================================================================
--	UI Callback
-- ===========================================================================
function OnClose()
	Close();
end

-- =======================================================================================
function OnShow()
    local pUnit:table = UI.GetHeadSelectedUnit();
	if GameInfo.Units[pUnit:GetType()].UnitType ~= "UNIT_SPY" then
	-- if not Utils.IsUnitPromotion(pUnit:GetType(), "PROMOTION_CLASS_SPY") then
		UIManager:DequeuePopup( ContextPtr );
	else
		UIManager:DequeuePopup( ContextPtr:LookUpControl("/InGame/WorldPopups/UnitPromotionPopup") )
	end
end

-- =======================================================================================

function OnPromoteUnitPopup()
    local pUnit:table = UI.GetHeadSelectedUnit();
    local unitExperience = pUnit:GetExperience();
    local currentPromotionList:table = unitExperience:GetPromotions();
    local promotionClass = GameInfo.Units[pUnit:GetUnitType()].PromotionClass;

    local strengthString:string = "";
    local experienceString:string = "";
    if pUnit:GetCombat() > 0 then
        strengthString = strengthString .. "[ICON_Strength]" .. pUnit:GetCombat()
    end
    if pUnit:GetRangedCombat() > 0 then
        strengthString = strengthString .. "[ICON_Ranged]" .. pUnit:GetRangedCombat()
    end
    if pUnit:GetBombardCombat() > 0 then
        strengthString = strengthString .. "[ICON_Bombard]" .. pUnit:GetBombardCombat()
    end
    if pUnit:GetAntiAirCombat() > 0 then
        strengthString = strengthString .. "[ICON_AntiAir_Large]" .. pUnit:GetAntiAirCombat()
    end
    if pUnit:GetReligiousStrength() > 0 then
        strengthString = strengthString .. "[ICON_Religion]" .. pUnit:GetReligiousStrength()
    end
    if pUnit:GetMaxMoves() > 0 then
        strengthString = strengthString .. "[ICON_Movement]" .. pUnit:GetMaxMoves()
    end

    experienceString = Locale.Lookup("LOC_HUD_UNIT_PANEL_XP") .. " " .. unitExperience:GetExperiencePoints();

    Controls.StrMoveLabel:SetText(Locale.Lookup(strengthString));
    Controls.ExperienceLabel:SetText(Locale.Lookup(experienceString));

    m_PromotionListInstanceMgr:ResetInstances();
    m_CompletedPromotionListInstanceMgr:ResetInstances();
    m_kLineIM:ResetInstances();

	skillTreeRefresh (pUnit)	
	-- 遍历技能树并创建UI元素
	-- 是横向的所以先遍历列，再遍历行 ，当时写SkillTree向竖向的，但考虑最好大小不要超出 1024 X 768(文明6最小显示分辨率)，所以改成横向遍历
    for j = 1, NumLevelSkills do
    	for i = 1, SkillLevelNum do
			local skill = SkillTree[i][j]
            -- local skill = SkillTree[i][j] -- pUnit:GetProperty("SPY_SKILL_TREE") -- SkillTree是演示案例，实际应该每个间谍单位都有这个单独的技能情况
            local promotionInstance = skill.Unlock and m_CompletedPromotionListInstanceMgr:GetInstance() or m_PromotionListInstanceMgr:GetInstance();

            promotionInstance.PromotionSelection:SetOffsetVal((i - 1) * 252, (j - 1) * 131); -- 212,106
            promotionInstance.PromotionName:SetText(Locale.ToUpper(Locale.Lookup(skill.Name)));
            promotionInstance.PromotionDescription:SetText(Locale.Lookup(skill.Describe));

            local iconName = skill.Icon; -- 我这里模拟的图标是虚假的所以 textureOffsetX 为nil
            local textureOffsetX, textureOffsetY, textureSheet = IconManager:FindIconAtlas(iconName, 32);
            if (textureOffsetX ~= nil) then
                promotionInstance.PromotionIcon:SetTexture(textureOffsetX, textureOffsetY, textureSheet);
            end

            if skill.Can and not skill.Unlock then
                promotionInstance.PromotionSlot:SetDisabled(false);					promotionInstance.PromotionSlot:SetVoid1( ePromotion );
				promotionInstance.PromotionSlot:SetVoids( pUnit:GetOwner(), pUnit:GetID() );
				promotionInstance.PromotionSlot:RegisterCallback(Mouse.eLClick, function(iPlayerID, iUnitID) skill.UnlockCallback(iPlayerID, iUnitID, i, j) end)
            else
                promotionInstance.PromotionSlot:SetDisabled(true);
            end
        end
    end

	-- 连接技能形成树
	for i = 1, SkillLevelNum-1 do --3
		for j = 1, NumLevelSkills do
			local inst	:table = m_kLineIM:GetInstance();
			local line1	:table = inst.LineImage;
			
			-- 212,106
			line1:SetOffsetVal(252 * i - 40, 131 * (j - 1) + 33);
			line1:SetSizeVal(40, 40);

			if j ~= NumLevelSkills and  j ~= 1  then
				inst = m_kLineIM:GetInstance();
				local line2:table = inst.LineImage;
				line2:SetTexture("Controls_TreePathDashNS"); -- 上下
				line2:SetOffsetVal(252 * i - 40, 131 * (j - 1) + 33);
				line2:SetSizeVal(40, 40);
			end
			if j~= NumLevelSkills then
				inst = m_kLineIM:GetInstance();
				local line3:table = inst.LineImage;
				inst = m_kLineIM:GetInstance();
				local line4:table = inst.LineImage;
				line3:SetTexture("Controls_TreePathDashNE"); -- 右下
				line3:SetOffsetVal(252 * i - 40, 131 * (j - 1) + 33);
				line3:SetSizeVal(40, 40);

				line4:SetTexture("Controls_TreePathDashES"); -- 左下
				line4:SetOffsetVal(252 * i - 40, 131 * (j - 1) + 33);
				line4:SetSizeVal(40, 40);

				
				inst = m_kLineIM:GetInstance();
				local line7:table = inst.LineImage;
				line7:SetTexture("Controls_TreePathDashNS");
				line7:SetOffsetVal(252 * i - 40, 131 * (j - 1) + 33 +40);
				line7:SetSizeVal(40, 91);
			end
			if j ~= 1 then
				inst = m_kLineIM:GetInstance();
				local line5:table = inst.LineImage;
				inst = m_kLineIM:GetInstance();
				local line6:table = inst.LineImage;
				line5:SetTexture("Controls_TreePathDashSE"); -- 右上
				line5:SetOffsetVal(252 * i - 40, 131 * (j - 1) + 33);
				line5:SetSizeVal(40, 40);

				line6:SetTexture("Controls_TreePathDashEN"); -- 左上
				line6:SetOffsetVal(252 * i - 40, 131 * (j - 1) + 33);
				line6:SetSizeVal(40, 40);
			end
		end
	end

    Controls.PromotionScrollPanel:CalculateSize();
    UIManager:QueuePopup(ContextPtr, PopupPriority.Low)
end

-- ===========================================================================
function OnLocalPlayerTurnEnd()
	if(GameConfiguration.IsHotseat()) then
		Close();
	end
end

-- ===========================================================================
function OnInputHandler( pInputStruct:table )
	local uiMsg = pInputStruct:GetMessageType();
	if uiMsg == KeyEvents.KeyUp then
		if pInputStruct:GetKey() == Keys.VK_ESCAPE then
			OnClose();
			return true;
		end
	end
	return false;
end

-- ===========================================================================
function OnCitySelectionChanged( ownerPlayerID:number, cityID:number, i:number, j:number, k:number, isSelected:boolean, isEditable:boolean)
	OnClose();
end

-- ===========================================================================
function OnShutdown()
	Events.CitySelectionChanged.Remove( OnCitySelectionChanged );

	LuaEvents.UnitPanel_PromoteUnit.Remove(OnPromoteUnitPopup);
	LuaEvents.UnitPanel_HideUnitPromotion.Remove(OnClose);
end

-- ===========================================================================
function OnInit( isReload:boolean )
	LateInitialize();

	if isReload then
		local pSelectedUnit:table = UI.GetHeadSelectedUnit();
		if pSelectedUnit then
			OnPromoteUnitPopup();
		end
	end
end

-- ===========================================================================
function skillTreeRefresh (pUnit)
	local unitId = pUnit:GetID();
	local playerId = pUnit:GetOwner();
	local spyname = pUnit:GetName();

	--初始化技能树
	for i = 1, SkillLevelNum do
		for j = 1, NumLevelSkills do
			SkillTree[i][j].Can = i == 1
			SkillTree[i][j].Unlock = false
		end
	end
	--根据间谍解锁的技能确定可解锁的技能
	for i = 1, SkillLevelNum do
		for j = 1, NumLevelSkills do
			local pskillUnlock = ExposedMembers.SPYPROMOTION.GetSpySkillTreeUnlock (playerId, i, j, spyname)
			if pskillUnlock then 
				SkillTree[i][j].Unlock = pskillUnlock 
			end
			if SkillTree[i][j].Unlock == true and SkillTree[i + 1] then -- 更改下一层的解锁状态
				for _, pskill in pairs(SkillTree[i + 1]) do 
					pskill.Can = true
				end
			end
		end
	end
end

--间谍活动失败后删除对应间谍名升级树信息
function SpyDeadResetPromotion (playerId,    missionId)
	local pPlayer = Players[playerId];
	local pPlayerDiplomacy = pPlayer:GetDiplomacy();
	local tMission:table = pPlayerDiplomacy:GetMission(playerId,    missionId);
	local SpyName = tMission.Name;
	local InitialResult = tMission.InitialResult
	local EscapeResult = tMission.EscapeResult;
	if InitialResult == EspionageResultTypes.KILLED or EscapeResult == EspionageResultTypes.KILLED then 
		for i = 1, SkillLevelNum do
			for j = 1, NumLevelSkills do
				ExposedMembers.SPYPROMOTION.SetSpySkillTreelock(playerId, i,j, SpyName)
				if i > 1 then 
					SkillTree[i][j].Can = false;
				end 
			end
		end
	end 
end
-- ===========================================================================
function LateInitialize()
	Controls.HeaderLabel:SetText(Locale.ToUpper("[ICON_Therefore]" ..Locale.Lookup("LOC_HUD_UNIT_CHOOSE_PROMOTION_TEXT") .. "[ICON_Therefore]"))

	Controls.CloseButton:RegisterCallback( Mouse.eLClick, OnClose );
	--Controls.PromotionContainer:RegisterSizeChanged( OnPromotionContainerSizeChanged );

	Events.CitySelectionChanged.Add( OnCitySelectionChanged );
	Events.SpyMissionCompleted.Add(SpyDeadResetPromotion);

	LuaEvents.UnitPanel_PromoteUnit.Add(OnPromoteUnitPopup);
	LuaEvents.UnitPanel_HideUnitPromotion.Add(OnClose);
end

-- ===========================================================================
function Initialize()
	ContextPtr:SetInitHandler( OnInit );
	ContextPtr:SetShutdown( OnShutdown );
	ContextPtr:SetShowHandler( OnShow );
	ContextPtr:SetInputHandler( OnInputHandler, true );
end
Initialize();
