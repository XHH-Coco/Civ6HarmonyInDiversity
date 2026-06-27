-- ===========================================================================
-- Utils
-- ===========================================================================
ExposedMembers.DLHD = ExposedMembers.DLHD or {};
ExposedMembers.DLHD.Utils = ExposedMembers.DLHD.Utils or {};
Utils = ExposedMembers.DLHD.Utils;

local MAGNANIMOUS_INTRODUCE_POPULATION_TAG = 'HD_MAGNANIMOUS_INTRODUCE_POPULATION';
local MAGNANIMOUS_INTRODUCE_PARAM_TAG = 'HD_MAGNANIMOUS_INTRODUCE_PARAM';


local MAGNANIMOUS_INTRODUCE_GREAT_PERSON_PERCENTAGE = GlobalParameters.HD_MAGNANIMOUS_INTRODUCE_GREAT_PERSON_PERCENTAGE or 0;
local MAGNANIMOUS_INTRODUCE_TYCOON_PERCENTAGE = GlobalParameters.HD_MAGNANIMOUS_INTRODUCE_TYCOON_PERCENTAGE or 0;
local MAGNANIMOUS_INTRODUCE_INVESTOR_PERCENTAGE = GlobalParameters.HD_MAGNANIMOUS_INTRODUCE_INVESTOR_PERCENTAGE or 0;

local TYCOON_INFO = GameInfo.Units['UNIT_LEU_TYCOON'];
local INVESTOR_INFO = GameInfo.Units['UNIT_LEU_INVESTOR'];
-- ===========================================================================
-- Base Functions
-- ===========================================================================
function MagnanimousButtonReset()
  -- 获取城市对象，玩家当前UI选中的城市
  local city = UI.GetHeadSelectedCity()
  -- 判断是否显示按钮
  if city then
    local playerId = city:GetOwner();
    local player = Players[playerId];
    
    if player and Utils.LeaderHasTrait(playerId, 'TRAIT_LEADER_MAGNANIMOUS') then
      local amount = Utils.GetPlayerProperty(playerId, MAGNANIMOUS_INTRODUCE_POPULATION_TAG) or 0;
      if amount > 0 then
        local toolTipStr = Locale.Lookup('LOC_TRAIT_LEADER_MAGNANIMOUS_INTRODUCE_TEXT');

        local param = Utils.GetPlayerProperty(playerId, MAGNANIMOUS_INTRODUCE_PARAM_TAG);
        if not param then
          print("佩德罗二世 玩家没有引进数据 开始生成");
          param = {};

          -- 伟人引进概率
          local greatPersonList = {};
          local pastTimeLine = Game.GetGreatPeople():GetPastTimeline();
          for i, entry in ipairs(pastTimeLine) do
            if entry.Claimant and entry.Claimant ~= playerId and entry.Individual then
              local gpInfo = GameInfo.GreatPersonIndividuals[entry.Individual];
              if gpInfo and gpInfo.GreatPersonClassType ~= 'GREAT_PERSON_CLASS_PROPHET' and not Utils.GreatWorkGreatPersonList[gpInfo.Index] then
                local classInfo = GameInfo.GreatPersonClasses[gpInfo.GreatPersonClassType];
                if classInfo and classInfo.AvailableInTimeline == true then
                  table.insert(greatPersonList, {
                    CivName = PlayerConfigurations[entry.Claimant]:GetCivilizationShortDescription(),
                    ClassId = classInfo.Index,
                    IndividualId = gpInfo.Index
                  });
                  print("佩德罗二世 可供引进的伟人：" .. Locale.Lookup(gpInfo.Name));
                end
              end
            end
          end

          if #greatPersonList > 0 then
            local randomFactor = Utils.GetRandNum(101, "Random Magnanimous GpPercentage Factor " .. playerId) + 50;
            local gpPercentage = MAGNANIMOUS_INTRODUCE_GREAT_PERSON_PERCENTAGE * randomFactor / 100;

            local randomIndex = Utils.GetRandNum(#greatPersonList, "Random Magnanimous Gp " .. playerId) + 1;
            param.GpData = greatPersonList[randomIndex];
            param.GpPercentage = math.min(gpPercentage, 100);
          end

          -- 大亨引进概率
          if TYCOON_INFO then
            local prereqTechInfo = GameInfo.Technologies[TYCOON_INFO.PrereqTech];
            local prereqCivicInfo = GameInfo.Civics[TYCOON_INFO.PrereqCivic];

            if (not prereqTechInfo or player:GetTechs():HasTech(prereqTechInfo.Index)) and (not prereqCivicInfo or player:GetCulture():HasCivic(prereqCivicInfo.Index)) then
              local randomFactor = Utils.GetRandNum(101, "Random Magnanimous TycoonPercentage Factor " .. playerId) + 50;
              local tycoonPercentage = MAGNANIMOUS_INTRODUCE_TYCOON_PERCENTAGE * randomFactor / 100;

              param.TycoonPercentage = math.min(tycoonPercentage, 100);
            end
          end

          -- 投资人引进概率
          if INVESTOR_INFO then
            local prereqTechInfo = GameInfo.Technologies[INVESTOR_INFO.PrereqTech];
            local prereqCivicInfo = GameInfo.Civics[INVESTOR_INFO.PrereqCivic];

            if (not prereqTechInfo or player:GetTechs():HasTech(prereqTechInfo.Index)) and (not prereqCivicInfo or player:GetCulture():HasCivic(prereqCivicInfo.Index)) then
              local randomFactor = Utils.GetRandNum(101, "Random Magnanimous InvestorPercentage Factor " .. playerId) + 50;
              local investorPercentage = MAGNANIMOUS_INTRODUCE_INVESTOR_PERCENTAGE * randomFactor / 100;

              param.InvestorPercentage = math.min(investorPercentage, 100);
            end
          end

          -- 记录数据
          Utils.SetPlayerProperty(playerId, MAGNANIMOUS_INTRODUCE_PARAM_TAG, param);
        end

        -- 参数文本
        local paramToolTipList = {};
        if param.GpPercentage and param.GpPercentage > 0 then
          local data = param.GpData or {};
          local classInfo = GameInfo.GreatPersonClasses[data.ClassId];
          table.insert(paramToolTipList, Locale.Lookup('LOC_TRAIT_LEADER_MAGNANIMOUS_INTRODUCE_PERCENTAGE_TEXT', param.GpPercentage, classInfo.Name));
        end
        if TYCOON_INFO and param.TycoonPercentage and param.TycoonPercentage > 0 then
          table.insert(paramToolTipList, Locale.Lookup('LOC_TRAIT_LEADER_MAGNANIMOUS_INTRODUCE_PERCENTAGE_TEXT', param.TycoonPercentage, TYCOON_INFO.Name));
        end
        if INVESTOR_INFO and param.InvestorPercentage and param.InvestorPercentage > 0 then
          table.insert(paramToolTipList, Locale.Lookup('LOC_TRAIT_LEADER_MAGNANIMOUS_INTRODUCE_PERCENTAGE_TEXT', param.InvestorPercentage, INVESTOR_INFO.Name));
        end

        if #paramToolTipList > 0 then
          toolTipStr = toolTipStr .. '[NEWLINE]';
          for _, str in ipairs(paramToolTipList) do
            toolTipStr = toolTipStr .. '[NEWLINE]' .. str;
          end
        end

        -- 剩余次数
        toolTipStr = toolTipStr .. '[NEWLINE][NEWLINE]' .. Locale.Lookup('LOC_TRAIT_LEADER_MAGNANIMOUS_INTRODUCE_TIMES_TEXT', amount);

        Controls.Magnanimous_Button_Stack:SetHide(false);
        Controls.Magnanimous_Button:SetToolTipString(toolTipStr);
      else
        Controls.Magnanimous_Button_Stack:SetHide(true);
      end
    else
      Controls.Magnanimous_Button_Stack:SetHide(true);
    end
  else
    Controls.Magnanimous_Button_Stack:SetHide(true);
  end
end

function MagnanimousButtonClick()
  -- 获取玩家当前UI选中的城市对象
  local city = UI.GetHeadSelectedCity()
  if city then
    local playerId = city:GetOwner();
    local player = Players[playerId];

    local param = Utils.GetPlayerProperty(playerId, MAGNANIMOUS_INTRODUCE_PARAM_TAG);
    if param and playerId == Game.GetLocalPlayer() then
      UI.RequestPlayerOperation(
        Game.GetLocalPlayer(),
        PlayerOperations.EXECUTE_SCRIPT,
        {
          CityId = city:GetID(),
          GpData = param.GpData,
          GpPercentage = param.GpPercentage,
          TycoonPercentage = param.TycoonPercentage,
          InvestorPercentage = param.InvestorPercentage,
          OnStart = 'HD_Magnanimous_Introduce_Population'
        }
      );
    end

    UI.PlaySound("ALERT_POSITIVE");
    Utils.SetPlayerProperty(playerId, MAGNANIMOUS_INTRODUCE_PARAM_TAG, nil);
  end
end

-- ===========================================================================
-- Events Functions
-- ===========================================================================
--添加按钮到城市面板
function AddMagnanimousButton()
  local context = ContextPtr:LookUpControl("/InGame/CityPanel/ActionStack")
  if context then
      Controls.Magnanimous_Button_Stack:ChangeParent(context)
      Controls.Magnanimous_Button:RegisterCallback(Mouse.eLClick, MagnanimousButtonClick)
      Controls.Magnanimous_Button:RegisterCallback(Mouse.eMouseEnter, function()
        UI.PlaySound("Main_Menu_Mouse_Over")
      end)
      -- 刷新按钮
      MagnanimousButtonReset()
  end
end

-- 城市选中时
function MagnanimousCitySelectChange(ownerId, cityId, i, j, k, isSelected)
  -- 获得本地玩家
  local loaclPlayerId = Game.GetLocalPlayer()
  -- 本地玩家是否与触发该事件的玩家一致，是否选中城市
  if ownerId == loaclPlayerId and isSelected then
      -- 是，且选中城市
      -- 刷新按钮
      MagnanimousButtonReset()
  end
  -- 这个函数似乎有点多余
end

-- ===========================================================================
-- Initialize
-- ===========================================================================
function Initialize()
  -------------------Events-------------------
  Events.LoadGameViewStateDone.Add(AddMagnanimousButton)
  Events.CitySelectionChanged.Add(MagnanimousCitySelectChange)
  -------------------Resets-------------------
  -- 本地玩家换了后刷新一遍
  Events.LocalPlayerChanged.Add(MagnanimousButtonReset)

  -- 刷新按钮的时机
  Events.CityAddedToMap.Add(MagnanimousButtonReset)
  Events.CityProductionQueueChanged.Add(MagnanimousButtonReset)
  Events.CityProductionUpdated.Add(MagnanimousButtonReset)
  Events.CityProductionChanged.Add(MagnanimousButtonReset)
  Events.CityProductionCompleted.Add(MagnanimousButtonReset)
  Events.CityPopulationChanged.Add(MagnanimousButtonReset)
  Events.TurnEnd.Add(MagnanimousButtonReset)

  --------------------------------------------
  print('Initial success!')
end

Initialize()