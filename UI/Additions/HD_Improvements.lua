ExposedMembers.DLHD = ExposedMembers.DLHD or {};
ExposedMembers.DLHD.Utils = ExposedMembers.DLHD.Utils or {};
Utils = ExposedMembers.DLHD.Utils;

-- 是否允许建造改良
-- 判断是否为自己的地块，是否有区域或者其他改良
function CanBuildSelfImprovement(playerId, plot)
  if playerId == plot:GetOwner() and plot:GetDistrictType() == -1 and plot:GetImprovementType() == -1 then
    return true;
  end
  return false;
end

-- 针对原本每城限1座，后续条件解锁额外建造的改良
function CanBuildExtraImprovement(improvementType, city)
  for _, info in ipairs(Utils.improvementNeedCountList) do
    if improvementType == info.ImprovementType then
      local builtNum = city:GetProperty("HD_CITY_IMPROVEMENT_NUM_" .. info.ImprovementType) or 0
      local extraNum = city:GetProperty("HD_CITY_ALLOW_EXTRA_" .. info.ImprovementType) or 0
      print("HD_EXTRA_BUILT_IMPROVEMENT", improvementType, builtNum .. "/" .. extraNum + 1)
      return extraNum >= builtNum;
    end
  end
  return true;
end
-----------------------------------------------------
-- 在特定地形地貌上改良资源
-- 陆地圩田、梯田
local needCheck = {}
local validTerrains = {}
local validFeatures = {}
function Initialize()
  for iRow in GameInfo.ImprovementsRules_HD() do
    table.insert(needCheck, {
      ImprovementType = iRow.ImprovementType,
      Hash = GameInfo.Improvements[iRow.ImprovementType].Hash
    })

    for tRow in GameInfo.Improvement_ValidTerrains() do
      if iRow.ImprovementType == tRow.ImprovementType then
        table.insert(validTerrains, {
          ImprovementType = tRow.ImprovementType,
          TerrainType = GameInfo.Terrains[tRow.TerrainType].Index
        })
      end
    end

    for fRow in GameInfo.Improvement_ValidFeatures() do
      if iRow.ImprovementType == fRow.ImprovementType then
        table.insert(validFeatures, {
          ImprovementType = fRow.ImprovementType,
          FeatureType = GameInfo.Features[fRow.FeatureType].Index
        })
      end
    end
  end
end
Initialize()

function IsNeedCheckImprovement(improvementType)
  for _, i in pairs(needCheck) do
    if i.ImprovementType == improvementType or i.Hash == improvementType then
      return true
    end
  end
  return false
end

function CanBuildOnResourceWithSpecificTerrainOrFeature(improvementType, plot)
  for _, i in pairs(needCheck) do
    if i.ImprovementType == improvementType or i.Hash == improvementType then
      if plot:GetResourceType() ~= -1 then
        for _, t in pairs(validTerrains) do
          if t.ImprovementType == i.ImprovementType and t.TerrainType == plot:GetTerrainType() then
            return true;
          end
        end
  
        for _, f in pairs(validFeatures) do
          if f.ImprovementType == i.ImprovementType and f.FeatureType == plot:GetFeatureType() then
            return true;
          end
        end

        return false;
      end
      return true;
    end
  end
  return true;
end

function CanBuildOnTerrainOrFeatureWithoutResource(improvementType, plot)
  if plot:GetResourceType() == -1 then
    for _, t in pairs(validTerrains) do
      if t.ImprovementType == improvementType and t.TerrainType == plot:GetTerrainType() and plot:GetFeatureType() == -1 then
        return true;
      end
    end

    for _, f in pairs(validFeatures) do
      if f.ImprovementType == improvementType and f.FeatureType == plot:GetFeatureType() then
        return true;
      end
    end

    return false;
  end

  return false;
end