local LrView = import("LrView")
local LrPrefs = import("LrPrefs")
--[[----------------------------------------------------------------------------
-----------------------------------------------------------------------------]]
local logger = require("Logger")
local InfoProvider = {}
--[[----------------------------------------------------------------------------
-----------------------------------------------------------------------------]]
function InfoProvider.sectionsForTopOfDialog(f, _)
    logger.trace("sectionsForTopOfDialog")

    local prefs = LrPrefs.prefsForPlugin()
    local bind = LrView.bind
    --
    -- macOS
    --
    return {
        {
            title = LOC("$$$/LRCloud/Settings/PluginSettings=Plugin Settings"),
            bind_to_object = prefs,
            -- Path to pureraw
            f:row({
                f:checkbox {
                    title = LOC("$$$/LRCloud/Settings/displayWarnings=Display Warnings"),
                    value = bind("displayWarnings"),
                },
            }),

        }
    }
end

--[[----------------------------------------------------------------------------
-----------------------------------------------------------------------------]]
return InfoProvider
