--判断单位类型
local faithBuilderType = GameInfo.Units['UNIT_CITADEL_OF_GOD'].Index
local eReason_1        = DB.MakeHash("FAITH_BUILDER_COMPLETED")


--定义全局变量，方便调用
g_districtDetails = {
    cityID   = nil,
    TypeName = nil,
    Cost     = 0
}

--计算信仰值消耗
function FaithBuilderFaithCost(pCity, districtType)
    --获取城市生产队列、区域造价和区域进度
    local cityBuildQueue = pCity:GetBuildQueue()
    local cost           = cityBuildQueue:GetDistrictCost(districtType)
    local progress       = cityBuildQueue:GetDistrictProgress(districtType)
    --返回信仰值消耗
    return 2 * (cost - progress)
end

function FaithBuilderButtonDisable(pUnit)
    --判断单位类型
    if pUnit and pUnit:GetType() == faithBuilderType then
        --获取单元格
        local pPlot = Map.GetPlot(pUnit:GetX(), pUnit:GetY())
        if pPlot == nil then
            return true, Locale.Lookup('LOC_CITADEL_OF_GOD_NO_DISTRICTS')
        end
        --获得区域id和城市对象
        local districtID, pCity = pPlot:GetDistrictID(), Cities.GetPlotPurchaseCity(pPlot:GetIndex())
        if districtID > 0 and pCity and pCity:GetOwner() == pUnit:GetOwner() then
            --获取区域对象
            local pDistrict = pCity:GetDistricts():FindID(districtID)
            --对象不存在或者区域已经完成
            if pDistrict == nil or pDistrict:IsComplete() then
                return true, Locale.Lookup('LOC_CITADEL_OF_GOD_NO_DISTRICTS')
            end
            --获取区域名、区域类型和区域名
            local districtType     = pDistrict:GetType()
            local districtInfo     = GameInfo.Districts[pDistrict:GetType()]
            local districtTypeName = districtInfo.DistrictType
            local districtName     = districtInfo.Name
            --判断城市当前正在进行的生产
            if ExposedMembers.FaithBuilder.CurrentlyBuildingMacth(pCity:GetOwner(), pCity:GetID(), districtTypeName) then
                local pPlayer      = Players[pUnit:GetOwner()]
                --获取信仰值消耗
                local faithCost    = FaithBuilderFaithCost(pCity, districtType)
                local iPlayerFaith = pPlayer:GetReligion():GetFaithBalance() or 0
                if iPlayerFaith >= faithCost then
                    --变更全局变量
                    g_districtDetails.cityID   = pCity:GetID()
                    g_districtDetails.TypeName = districtTypeName
                    g_districtDetails.Cost     = faithCost
                    return false, { faithCost, districtName }
                else
                    return true, Locale.Lookup('LOC_CITADEL_OF_GOD_NO_FAITH', faithCost)
                end
            else
                return true, Locale.Lookup('LOC_CITADEL_OF_GOD_NO_DISTRICTS')
            end
        else
            return true, Locale.Lookup('LOC_CITADEL_OF_GOD_NO_DISTRICTS')
        end
    else
        return true, Locale.Lookup('LOC_CITADEL_OF_GOD_DISABLE_NO_UNIT')
    end
end

function FaithBuilderReset(pUnit)
    --获取按钮可用性
    local disabled, result = FaithBuilderButtonDisable(pUnit)
    --设置按钮可用性
    Controls.FaithBuilder_Button:SetDisabled(disabled)
    Controls.FaithBuilder_Button:SetAlpha((disabled and 0.4) or 1)
    --好了，设置按钮的tooltip
    local tooltip = Locale.Lookup('LOC_CITADEL_OF_GOD_NAME')
    if disabled then
        tooltip = tooltip .. '[NEWLINE][NEWLINE]' .. Locale.Lookup('LOC_CITADEL_OF_GOD_DESCRIPTION') ..
            '[NEWLINE][NEWLINE]' .. Locale.Lookup('LOC_CITADEL_OF_GOD_DISABLED') .. '[NEWLINE]' .. result
    else
        tooltip = tooltip .. '[NEWLINE][NEWLINE]' .. Locale.Lookup('LOC_CITADEL_OF_GOD_DETAIL', result[1], result[2])
    end
    Controls.FaithBuilder_Button:SetToolTipString(tooltip)
end

--按钮是否可见
function FaithBuilderResetGrid(playerID)
    if playerID ~= Game.GetLocalPlayer() then
        Controls.FaithBuilder_Grid:SetHide(true)
        return
    end
    local pUnit = UI.GetHeadSelectedUnit()
    if pUnit and pUnit:GetType() == faithBuilderType then
        Controls.FaithBuilder_Grid:SetHide(false)
        FaithBuilderReset(pUnit)
    else
        Controls.FaithBuilder_Grid:SetHide(true)
    end
end

function OnFaithBuilderButtonClicked()
    --获取单位
    local pUnit = UI.GetHeadSelectedUnit()
    --我们可以利用全局变量偷巧
    UI.RequestPlayerOperation(Game.GetLocalPlayer(),
        PlayerOperations.EXECUTE_SCRIPT, {
            unitID  = pUnit:GetID(),
            detail  = g_districtDetails,
            OnStart = 'FaithBuilderCompleteDistrict'
        })
end

function OnFaithBuilderUnitSelectionChanged(playerId, unitId, locationX, locationY, locationZ, isSelected)
    if isSelected then FaithBuilderResetGrid(playerId) end
end

function FaithBuilderUnitActive(owner, unitID, x, y, eReason)
    local pUnit = UnitManager.GetUnit(owner, unitID);
    if eReason == eReason_1 then
        FaithBuilderResetGrid(owner)
        SimUnitSystem.SetAnimationState(pUnit, "ACTION_1", "SPAWN")
    end
end

function FaithBuilderOnPhaseBegin()
    local pUnit = UI.GetHeadSelectedUnit()
    if pUnit then
        FaithBuilderResetGrid(pUnit:GetOwner())
    end
end

function FaithBuilderOnLoadGameViewStateDone()
    local pContext = ContextPtr:LookUpControl("/InGame/UnitPanel/StandardActionsStack")
    if pContext ~= nil then
        Controls.FaithBuilder_Grid:ChangeParent(pContext)
        Controls.FaithBuilder_Button:RegisterCallback(Mouse.eLClick, OnFaithBuilderButtonClicked)
        FaithBuilderResetGrid(Game.GetLocalPlayer())
    end
end

function Initialize()
    Events.LoadGameViewStateDone.Add(FaithBuilderOnLoadGameViewStateDone)
    Events.UnitActivate.Add(FaithBuilderUnitActive)
    Events.UnitSelectionChanged.Add(OnFaithBuilderUnitSelectionChanged)
    -----------------------------------------------------
    Events.UnitOperationSegmentComplete.Add(FaithBuilderResetGrid)
    Events.UnitCommandStarted.Add(FaithBuilderResetGrid)
    Events.UnitDamageChanged.Add(FaithBuilderResetGrid)
    Events.UnitMoveComplete.Add(FaithBuilderResetGrid)
    Events.UnitChargesChanged.Add(FaithBuilderResetGrid)
    Events.UnitPromoted.Add(FaithBuilderResetGrid)
    Events.UnitOperationsCleared.Add(FaithBuilderResetGrid)
    Events.UnitOperationAdded.Add(FaithBuilderResetGrid)
    Events.UnitOperationDeactivated.Add(FaithBuilderResetGrid)
    Events.UnitMovementPointsChanged.Add(FaithBuilderResetGrid)
    Events.UnitMovementPointsCleared.Add(FaithBuilderResetGrid)
    Events.UnitMovementPointsRestored.Add(FaithBuilderResetGrid)
    Events.UnitAbilityLost.Add(FaithBuilderResetGrid)
    -----------------------------------------------------
    Events.PhaseBegin.Add(FaithBuilderOnPhaseBegin)
    -----------------------------------------------------
    print('FaithBuilder_UI Initial success!')
end

Initialize()
