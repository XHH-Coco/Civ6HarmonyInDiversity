-- =================================================================================
-- Import base file
-- =================================================================================
local files = {
    "WorldViewIconsManager_RAD.lua",
    "WorldViewIconsManager_CQUI.lua",
    "WorldViewIconsManager.lua",
}

for _, file in ipairs(files) do
    include(file)
    if Initialize then
        print("DL_WorldViewIconsManager Loading " .. file .. " as base file");
        break
    end
end

include("HD_Improvements");
include("FarmsOnFreshHills_Common");

local KEY_CURRENT_ICON_INFO		:string = "currentIcon";
local KEY_PREVIOUS_ICON_INFO	:string = "prevIcon";
local m_isShowResources :boolean = UserConfiguration.ShowMapResources();

-- ===========================================================================
--  Cache base functions
-- ===========================================================================
BASE_AddImprovementRecommendationsForCity = AddImprovementRecommendationsForCity;
BASE_OnShutdown = OnShutdown;

-- =================================================================================
-- Overrides
-- =================================================================================
local m_RecommendedImprovementPlots :table = {};

-- Copied from original WorldViewIconsManager.lua.
function ClearImprovementRecommendations()
    -- Hide previous recommendations
    for i,plotIndex in ipairs(m_RecommendedImprovementPlots) do
        local pRecommendedPlotInstance = GetInstanceAt(plotIndex);
        pRecommendedPlotInstance.ImprovementRecommendationBackground:SetHide(true);
    end

    -- Clear table
    m_RecommendedImprovementPlots = {};
end

function AddImprovementRecommendationsForCity( pCity:table, pSelectedUnit:table )
    local pCityAI:table = pCity:GetCityAI();
    if pCityAI then
        local recommendList:table = pCityAI:GetImprovementRecommendationsForBuilder(pSelectedUnit:GetComponentID());
        for key, value in pairs(recommendList) do
            local pRecommendedPlotInstance = GetInstanceAt(value.ImprovementLocation);

            -- Get improvement info
            local pImprovementInfo:table = GameInfo.Improvements[value.ImprovementHash];
            local improvementIcon = pImprovementInfo.Icon;
            local improvementName = pImprovementInfo.Name;
            local plot = Map.GetPlotByIndex(value.ImprovementLocation);
            if pImprovementInfo.ImprovementType == "IMPROVEMENT_FARM" then
                -- Perform fresh water hill farm check.
                local playerID = Game.GetLocalPlayer();
                if playerID ~= nil and playerID ~= -1 then
                    local player = Players[playerID];
                    
                    -- 处理淡水丘陵农场
                    if ShouldDisableHillFarm(plot, player) then
                        -- A non fresh water hill farm is being recommended but the player cannot place it.
                        -- Check if the player can place mine, i.e. has TECH_MINING.
                        improvementIcon = nil;
                        improvementName = nil;
                    end
                end
            else
                -- 处理特定地形地貌上的资源
                if not CanBuildOnResourceWithSpecificTerrainOrFeature(pImprovementInfo.ImprovementType, plot) then
                    improvementIcon = nil;
                    improvementName = nil;
                else
                    -- 针对原本每城限1座，后续条件解锁额外建造的改良
                    if not CanBuildExtraImprovement(pImprovementInfo.ImprovementType, pCity) then
                        improvementIcon = nil;
                        improvementName = nil;
                    end
                end
            end

            if improvementIcon ~= nil and improvementName ~= nil then
                -- Update icon
                pRecommendedPlotInstance.ImprovementRecommendationIcon:TrySetIcon(improvementIcon, 256);

                -- Update tooltip
                pRecommendedPlotInstance.ImprovementRecommendationIcon:SetToolTipString(Locale.Lookup("LOC_TOOLTIP_IMPROVEMENT_RECOMMENDATION", improvementName));

                -- Show recommendation and add to list for clean up later
                pRecommendedPlotInstance.ImprovementRecommendationBackground:SetHide(false);
                table.insert(m_RecommendedImprovementPlots, value.ImprovementLocation);
            end
        end
    end
end

function SetResourceIcon( pInstance:table, pPlot, type, state)
	local resourceInfo = GameInfo.Resources[type];
	if (pPlot and resourceInfo ~= nil) then
		local resourceType:string = resourceInfo.ResourceType;
		local featureType :string;
		local terrainType :string;

		local feature = GameInfo.Features[pPlot:GetFeatureType()];
		if(feature) then
			featureType = feature.FeatureType;
		end

		local terrain = GameInfo.Terrains[pPlot:GetTerrainType()];
		if(terrain) then
			terrainType = terrain.TerrainType;
		end

		local iconName = "ICON_" .. resourceType;
		if (state == RevealedState.REVEALED) then
			iconName = iconName .. "_FOW";
		end
		local textureOffsetX, textureOffsetY, textureSheet = IconManager:FindIconAtlas(iconName, 256);
		if (textureSheet ~= nil) then						
			pInstance[KEY_PREVIOUS_ICON_INFO] = DeepCopy( pInstance[KEY_CURRENT_ICON_INFO] );
			if pInstance[KEY_PREVIOUS_ICON_INFO] ~= nil then
				pInstance.ResourceIcon:SetTexture( pInstance[KEY_PREVIOUS_ICON_INFO].textureOffsetX, pInstance[KEY_PREVIOUS_ICON_INFO].textureOffsetY, pInstance[KEY_PREVIOUS_ICON_INFO].textureSheet );
				pInstance.ResourceIcon:SetHide( not m_isShowResources );
			else
				pInstance.ResourceIcon:SetHide( true );
			end			
			pInstance.NextResourceIcon:SetTexture( textureOffsetX, textureOffsetY, textureSheet );
			pInstance.NextResourceIcon:SetHide( false );
			pInstance[KEY_CURRENT_ICON_INFO] = {
				textureOffsetX = textureOffsetX, 
				textureOffsetY = textureOffsetY,
				textureSheet  = textureSheet
			}
			pInstance.AlphaAnim:SetHide(false);
			pInstance.AlphaAnim:SetToBeginning();
			pInstance.AlphaAnim:Play();
			
			-- Add some tooltip information about the resource
			local toolTipItems:table = {};
			table.insert(toolTipItems, Locale.Lookup(resourceInfo.Name));
			if (resourceInfo.ResourceClassType == "RESOURCECLASS_BONUS") then
				table.insert(toolTipItems, Locale.Lookup("LOC_TOOLTIP_BONUS_RESOURCE"));
			elseif (resourceInfo.ResourceClassType == "RESOURCECLASS_LUXURY") then
				table.insert(toolTipItems, Locale.Lookup("LOC_TOOLTIP_LUXURY_RESOURCE"));
			elseif (resourceInfo.ResourceClassType == "RESOURCECLASS_STRATEGIC") then
				table.insert(toolTipItems, Locale.Lookup("LOC_TOOLTIP_STRATEGIC_RESOURCE"));
			elseif (resourceInfo.ResourceClassType == "RESOURCECLASS_ARTIFACT") then
				table.insert(toolTipItems, Locale.Lookup("LOC_TOOLTIP_ARTIFACT_RESOURCE"));
				table.insert(toolTipItems, Locale.Lookup("LOC_TOOLTIP_ARTIFACT_RESOURCE_DETAILS"));
			end

			local tValidImprovements:table = {}
			for row in GameInfo.Improvement_ValidResources() do
                if row.ImprovementType ~= 'IMPROVEMENT_CORPORATION'
                    and row.ImprovementType ~= 'IMPROVEMENT_INDUSTRY'
                    and row.ImprovementType ~= 'IMPROVEMENT_LEU_TRANSNATIONAL'
                    and row.ImprovementType ~= 'IMPROVEMENT_LEU_TRANSNATIONAL_SEA'
                then
                    if (row.ResourceType == resourceType) and (GameInfo.Improvements[row.ImprovementType].TraitType == nil) then
                        if( terrainType == "TERRAIN_COAST") then
                            if ("DOMAIN_SEA" == GameInfo.Improvements[ row.ImprovementType].Domain) then
                                table.insert(tValidImprovements, row.ImprovementType);
                            elseif ("DOMAIN_LAND" == GameInfo.Improvements[ row.ImprovementType].Domain) then
                                valid_domain = false;
                            end
                        else
                            if ("DOMAIN_SEA" == GameInfo.Improvements[ row.ImprovementType].Domain) then
                                valid_domain = false;
                            elseif ("DOMAIN_LAND" == GameInfo.Improvements[ row.ImprovementType].Domain) then
                                table.insert(tValidImprovements, row.ImprovementType);
                            end
                        end
                    end
                end
			end

			local resourceTechType;
			local resourceCivicType;
            local resourceImprovementType;
			if (table.count(tValidImprovements) > 0) then
				if (table.count(tValidImprovements) > 1) then
					for i, improvement in ipairs(tValidImprovements) do
						local improvementType = improvement;

						local has_feature = false;
						local valid_feature = false;
						for inner_row in GameInfo.Improvement_ValidFeatures() do
							if(inner_row.ImprovementType == improvementType) then
								has_feature = true;
								if(inner_row.FeatureType == featureType) then
									valid_feature = true;
								end
							end
						end
						valid_feature = not has_feature or valid_feature;

						local has_terrain = false;
						local valid_terrain = false;
						for inner_row in GameInfo.Improvement_ValidTerrains() do
							if(inner_row.ImprovementType == improvementType) then
								has_terrain = true;
								if(inner_row.TerrainType == terrainType) then
									valid_terrain = true;
								end
							end
						end
						valid_terrain = not has_terrain or valid_terrain;

						-- if we match the resource in Improvement_ValidResources it's a get-out-of-jail-free card for feature and terrain checks
						local valid_resources = false;
						for inner_row in GameInfo.Improvement_ValidResources() do
							if(inner_row.ImprovementType == improvementType) then
								if(inner_row.ResourceType == resourceType) then
									valid_resources = true;
									break;
								end
							end
						end

						if ((valid_feature == true and valid_terrain == true) or (valid_resources == true)) then
							resourceTechType = GameInfo.Improvements[improvementType].PrereqTech;
							resourceCivicType = GameInfo.Improvements[improvementType].PrereqCivic;
							resourceImprovementType = improvementType;
                            break;
						end
					end
				else
					local improvementType = tValidImprovements[1];
					resourceTechType = GameInfo.Improvements[improvementType].PrereqTech;
					resourceCivicType = GameInfo.Improvements[improvementType].PrereqCivic;
                    resourceImprovementType = improvementType;
                end
			end

			if (resourceTechType ~= nil) then
				local localPlayer	= Players[Game.GetLocalPlayer()];
				if (localPlayer ~= nil) then
					local playerTechs	= localPlayer:GetTechs();
					local techType = GameInfo.Technologies[resourceTechType];
					if (techType ~= nil and not playerTechs:HasTech(techType.Index)) then
						table.insert(toolTipItems,"[COLOR:Civ6Red](".. Locale.Lookup("LOC_TOOLTIP_REQUIRES") .. " " .. Locale.Lookup(techType.Name) .. ")[ENDCOLOR]");
					end
				end
			end

			if (resourceCivicType ~= nil) then
				local localPlayer	= Players[Game.GetLocalPlayer()];
				if (localPlayer ~= nil) then
					local playerCulture	= localPlayer:GetCulture();
					local civicType = GameInfo.Civics[resourceCivicType];
					if (civicType ~= nil and not playerCulture:HasCivic(civicType.Index)) then
						table.insert(toolTipItems,"[COLOR:Civ6Red](".. Locale.Lookup("LOC_TOOLTIP_REQUIRES") .. " " .. Locale.Lookup(civicType.Name) .. ")[ENDCOLOR]");
					end
				end
			end

            -- Add some tooltip information about the resource
            if resourceImprovementType ~= nil then
                local improvementString = Locale.Lookup(GameInfo.Improvements[resourceImprovementType].Name);
                table.insert(toolTipItems, Locale.Lookup("LOC_TOOLTIP_RESOURCE_IMPROVED_BY") .. improvementString);
                if GameInfo.HDMonopolyResourceEffects ~= nil then
                    local corpInfo = GameInfo.HDMonopolyResourceEffects[resourceType];
                    if corpInfo ~= nil then
                        local categoryString = Locale.Lookup("LOC_HD_PEDIA_CATEGORY_" .. corpInfo.Category .. "_NAME")
                        table.insert(toolTipItems, Locale.Lookup("LOC_TOOLTIP_RESOURCE_CORP_CATEGORY") .. categoryString);
                    end
                end
            end

			table.insert(toolTipItems, resourceString)
			pInstance.ResourceIcon:SetToolTipString(table.concat(toolTipItems, "[NEWLINE]"));
		end
	end
end

function RestoreResourceIconState_HD()
	local bChangedValue = UserConfiguration.ShowMapResources();
	if (bChangedValue ~= m_isShowResources) then
		m_isShowResources = bChangedValue;
	end
end

function OnShutdown()
    Events.UserOptionChanged.Remove(RestoreResourceIconState_HD);
    Events.UserOptionsActivated.Remove(RestoreResourceIconState_HD);
    print('DL_WorldViewIconsManager OnShutdown');
    BASE_OnShutdown();
end

function Init_HD()
    ContextPtr:SetShutdown( OnShutdown );
    
    Events.UserOptionChanged.Add(RestoreResourceIconState_HD);
    Events.UserOptionsActivated.Add(RestoreResourceIconState_HD);
end
Init_HD()