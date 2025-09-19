-- Copyright 2020, Firaxis Games

-- This file is being included into the base GreatWorkShowcase file using the wildcard include setup in GreatWorkShowcase.lua
-- Refer to the bottom of GreatWorkShowcase.lua to see how that's happening
-- DO NOT include any GreatWorkShowcase files here or it will cause problems

-- ===========================================================================
-- CACHE BASE FUNCTIONS
-- ===========================================================================
local BASE_HideScreen = HideScreen;
local BASE_OnPreviousGreatWork = OnPreviousGreatWork;
local BASE_OnNextGreatWork = OnNextGreatWork;

-- ===========================================================================
function StopSpeechGreatWritingHD()
    UI.PlaySound("Stop_Speech_GreatWriting_HD");
end

function HideScreen()
    StopSpeechGreatWritingHD();
    BASE_HideScreen();
end

function OnPreviousGreatWork()
    local numGreatWorks:number = table.count(m_GreatWorks);
    if numGreatWorks > 1 then
        StopSpeechGreatWritingHD();
    end
    BASE_OnPreviousGreatWork();
end
function OnNextGreatWork()
    local numGreatWorks:number = table.count(m_GreatWorks);
    if numGreatWorks > 1 then
        StopSpeechGreatWritingHD();
    end
    BASE_OnNextGreatWork();
end
