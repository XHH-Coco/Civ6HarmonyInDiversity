-- INSTRUCTIONS:

-- 0. Ignore These Lines
-- Do not alter or modify the following two lines of code. Skip down to Step 1.

if not ExposedMembers.MOD_VERSION_CHECKER then ExposedMembers.MOD_VERSION_CHECKER = {} end
if not ExposedMembers.MOD_VERSION_CHECKER.ModVersionData then ExposedMembers.MOD_VERSION_CHECKER.ModVersionData = {} end

-- 1. Import This File Into Your Project
-- Create a /UI/ folder in your project, if you don't already have one, then drop this file into it and import it into your project.

-- 2. Rename This File
-- Rename this file using this format: "MVC_Your Mod Name.lua",  where "Your Mod Name" is the name of your mod.
-- The name should be formatted exactly as it appears in Project > Properties > Mod Info > Mod Name, which is also
-- exactly how it appears in the multiplayer staging room under the list of active mods.
--
-- This step is VERY important; the filename must be a perfect match to the name of your mod or else Mod Version Checker will not be able to find it.

-- 3. Include This File As A FrontEnd Action
-- In ModBuddy, open up Project > Properties > FrontEnd Actions.
-- On the left half of the menu, add a new Action and select it.
-- On the right half fo the menu, set the Type to "ImportFiles", then click "Add" next to the (currently empty) list of files.
-- Find this file (again, it should be named "MVC_Your Mod Name.lua", with "Your Mod Name" replaced by your mod's name) and add it.

-- 4. Update This Line Of Code
-- Replace "Your Mod Name" with your mod's name. Once again, this must be a perfect match to the name set in Project > Properties > Mod Info > Mod Name.
-- Change the value of VERSION to match your mod's actual version (or leave it at 1 if it's a new mod).
-- The version number you use here doesn't necessarily have to match the version number you use in Project > Properties > Mod Info > Version, but it's probably easier that way.

local VERSION = 2000
ExposedMembers.MOD_VERSION_CHECKER.ModVersionData["521b8777-0977-4859-a5ee-3e411a732e5c"] = VERSION

-- 5. Keep It Updated
-- Any time you make a big change to your mod, come back to this file and update the version to a higher number. MVC will start flagging anyone with an older version of the mod.
-- If you forget to update the version for a build, that's okay - just update the number, republish, and reupload a new build. MVC will catch all the old builds.
-- It's especially important to update the version if you make any changes that could cause desyncs (i.e. anything that affects gameplay / stats / the database).
