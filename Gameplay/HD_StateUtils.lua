-- ===========================================================================
-- STATE / CACHE
-- 
--  Modified from BlackDeathScenario/Scripts/BlackDeathScenario_StateUtils.lua
-- ===========================================================================

g_PropertyKeys_HD = {
    TempFlags = {
        isSyncFavor = "HD_IsSyncFavor",
    },
    PlayerFlags = {
        HaveGrantWalls = "HD_HaveGrantWalls",
    },
    CityFlags = {
        HasAssignedGovernor = "HD_HasAssignedGovernor",
        HasDipFavor = 'HD_HasDipFavor',
    },
    UnitFlags = {
        PromotionAvailable = "HD_PromotionAvailable",
    },
};

-- Every time SetObjectState is called, the script-side cache is updated to prevent unnecessary
-- calls down to gamecore.
local USE_CACHE : boolean = true;
local g_ObjectStateCache = {};

-- ===========================================================================
function SetObjectState(pObject : object, sPropertyName : string, value)
    if (sPropertyName == nil) then
        return nil;
    end

    if (pObject == nil) then
        print("HD_StateUtils SetObjectState: ERROR: object is nil!");
        return nil;
    end

    if (USE_CACHE == true) then
        if (g_ObjectStateCache[pObject] == nil) then
            g_ObjectStateCache[pObject] = {};
        end

        -- update cache
        g_ObjectStateCache[pObject][sPropertyName] = value;
    end
    -- update gamecore

    -- print('property', sPropertyName, 'set to', value)

    if UI ~= nil then
        -- We are on the UI side of things.  We must sent a command to change the game state
        local kParameters:table = {};
        kParameters.propertyName = sPropertyName;
        kParameters.value = value;
        kParameters.objectID = pObject:GetComponentID();
        -- Send this GameEvent when processing the operation
        kParameters.OnStart = "OnPlayerCommandSetObjectState";

        UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.EXECUTE_SCRIPT, kParameters);
    else
        if (pObject.SetProperty ~= nil) then
            pObject:SetProperty(sPropertyName, value);
        end
    end
end

-- ===========================================================================
function OnPlayerCommandSetObjectStateHandler(ePlayer : number, params : table)

    local pObject = Game.GetObjectFromComponentID(params.objectID);

    if pObject ~= nil then
        SetObjectState(pObject, params.propertyName, params.value);
    end
        
end

-- This file gets includes on both the UI and GameCore side, we only want to handle the event on the Game Core side.
if UI == nil then
    GameEvents.OnPlayerCommandSetObjectState.Add( OnPlayerCommandSetObjectStateHandler );
end

-- ===========================================================================
function GetObjectState(pObject : object, sPropertyName : string, bCacheCheckOnly : boolean)
    if (sPropertyName == nil) then
        return nil;
    end

    if (pObject == nil) then
        print("HD_StateUtils SetObjectState: ERROR: object is nil!");
        return nil;
    end

    bCacheCheckOnly = bCacheCheckOnly or false;

    if (USE_CACHE == true) then
        if (g_ObjectStateCache[pObject] == nil) then
            g_ObjectStateCache[pObject] = {};
        end

        if (g_ObjectStateCache[pObject][sPropertyName] ~= nil) then
            return g_ObjectStateCache[pObject][sPropertyName];
        else
            if (bCacheCheckOnly) then
                return nil;
            else
                return RefreshObjectState(pObject, sPropertyName);
            end
        end
    else
        return pObject:GetProperty(sPropertyName);
    end
end

-- ===========================================================================
-- Forces a call to gamecore and cache update.
function RefreshObjectState(pObject : object, sPropertyName : string)
    if (sPropertyName == nil) then
        return nil;
    end

    if (pObject.GetProperty == nil) then
        return nil;
    end 

    local propResult = pObject:GetProperty(sPropertyName);

    if (g_ObjectStateCache[pObject] == nil) then
        g_ObjectStateCache[pObject] = {};
    end

    g_ObjectStateCache[pObject][sPropertyName] = propResult;
    return propResult;
end
