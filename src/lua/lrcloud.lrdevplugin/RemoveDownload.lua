--[[----------------------------------------------------------------------------
StartDownload.lua
------------------------------------------------------------------------------]]
-- Access the Lightroom SDK namespaces.
local LrFunctionContext = import 'LrFunctionContext'
local LrApplication = import 'LrApplication'
local LrProgressScope = import 'LrProgressScope'
local LrTasks = import 'LrTasks'
local LrPrefs = import("LrPrefs")

-- Logger
local logger = require("Logger")


--[[---------------------------------------------------------------------------
Async task
-----------------------------------------------------------------------------]]
function TaskFunc(context)
    logger.trace("TaskFunc")
    local prefs = LrPrefs.prefsForPlugin()

    local activeCatalog = LrApplication.activeCatalog()
    local photos = activeCatalog:getTargetPhotos()
    logger.trace("photos=" .. tostring(#photos))

    local progress = LrProgressScope({
        title = LOC("$$$/LRCloud/Menu/Library/RemoveDownloadOfPhotos=Remove download for ^1 photos", #photos),
        functionContext = context
    })
    logger.trace("Start removing download")
    for idx, photo in ipairs(photos) do
        local path = tostring(photo:getRawMetadata("path"))
        logger.trace("file=" .. path)
        local cmd = "'" .. prefs.cloudfileExeuteable .. "' '" .. path .. "' evict"
        logger.trace("execute " .. cmd)
        local result = LrTasks.execute(cmd)
        logger.trace("result=" .. tostring(result))
        if result ~= 0 then
            if result == 65280 then
                logger.trace("Photo is not located in a cloud directory.")
            else
                logger.trace("Error: Download could not be removed")
            end
        else
            logger.trace("Download removed")
        end
        progress:setPortionComplete(idx, #photos)
    end
    progress:done()
end

--[[---------------------------------------------------------------------------
Main function
-----------------------------------------------------------------------------]]
LrFunctionContext.callWithContext("removeDownload", function(context)
    LrFunctionContext.postAsyncTaskWithContext("Remove download", TaskFunc)
end) -- end main function
