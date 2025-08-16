--
-- Created by IntelliJ IDEA.
-- User: Dieter Stockhausen
-- Date: 29.10.2023
-- To change this template use File | Settings | File Templates.
-------------------------------------------------------------------------------

local LrPrefs = import "LrPrefs"
local LrPathUtils = import "LrPathUtils"

local logger = require("Logger")
-------------------------------------------------------------------------------

local InitProvider = {}

-------------------------------------------------------------------------------

local function resetPrefs()
    local prefs = LrPrefs.prefsForPlugin()
     for key, value in pairs(prefs["< contents >"]) do
            prefs[key] = nil
     end
end

-------------------------------------------------------------------------------

local function init()
    logger.trace("init start")
    --resetPrefs()
    local prefs = LrPrefs.prefsForPlugin()
    if prefs.cloudfileExeuteable == nil then
       prefs.cloudfileExeuteable = LrPathUtils.child(_PLUGIN.path, "cloudfile")
    end
    logger.trace("init end")
end

-------------------------------------------------------------------------------

init()

