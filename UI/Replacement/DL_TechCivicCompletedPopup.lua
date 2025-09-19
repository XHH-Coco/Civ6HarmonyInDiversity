-- Copyright 2016-2018, Firaxis Games

-- ===========================================================================
--	Popups when a Tech or Civic are completed
-- ===========================================================================
include("TechCivicCompletedPopup");

-- ===========================================================================
Base_StopSound = StopSound;
function StopSound()
	UI.PlaySound("Stop_Speech_CivicsHD");
	UI.PlaySound("Stop_Speech_TechsHD");
	Base_StopSound();
    -- print('stop sound');
end

Base_RealizeNextPopup = RealizeNextPopup;
function RealizeNextPopup()
    StopSound();
    Base_RealizeNextPopup();
end
