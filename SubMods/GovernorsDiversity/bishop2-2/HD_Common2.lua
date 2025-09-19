ExposedMembers.FaithBuilder = ExposedMembers.FaithBuilder and ExposedMembers.FaithBuilder or {}

function FaithBuilderCurrentlyBuildingMacth(playerID, cityID, Name)
    local pCity = CityManager.GetCity(playerID, cityID)
    return pCity:GetBuildQueue():CurrentlyBuilding() == Name
end

ExposedMembers.FaithBuilder.CurrentlyBuildingMacth = FaithBuilderCurrentlyBuildingMacth

function FaithBuilderCompleteDistrict(playerID, param)
    print('Yes!')
    --获取玩家
    local pPlayer = Players[playerID]
    if pPlayer == nil then return end
    --获取单位
    local pUnit = UnitManager.GetUnit(playerID, param.unitID)
    if pUnit == nil then return end
    --获取细节
    local detail = param.detail
    if detail ~= nil then
        --获取城市
        local pCity = CityManager.GetCity(playerID, detail.cityID)
        --获取城市生产队列
        local cityBuildQueue = pCity and pCity:GetBuildQueue()
        --再判断一次
        if cityBuildQueue and cityBuildQueue:CurrentlyBuilding() == detail.TypeName then
            --完成生产
            cityBuildQueue:FinishProgress()
            --扣信仰
            pPlayer:GetReligion():ChangeFaithBalance(-detail.Cost)
            --报告单位激活，然后移除单位
            UnitManager.ReportActivation(pUnit, "FAITH_BUILDER_COMPLETED")
            -- --扣除单位传教次数
            -- pUnit:GetReligion():ChangeSpreadCharges(-1)
            -- if pUnit:GetReligion():GetSpreadCharges() == 0 then
            --     --没次数了？移除
                UnitManager.Kill(pUnit)
            -- end
        end
    end
end

GameEvents.FaithBuilderCompleteDistrict.Add(FaithBuilderCompleteDistrict)
