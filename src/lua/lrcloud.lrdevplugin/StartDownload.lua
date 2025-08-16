--[[----------------------------------------------------------------------------
StartDownload.lua
------------------------------------------------------------------------------]]
-- Access the Lightroom SDK namespaces.
local LrFunctionContext = import 'LrFunctionContext'
local LrApplication = import 'LrApplication'
local LrProgressScope = import 'LrProgressScope'
local LrTasks = import 'LrTasks'
local LrPrefs = import "LrPrefs"

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
    logger.trace("photos selected=" .. tostring(#photos))

    local progress = LrProgressScope({
        title = LOC("$$$/LRCloud/Menu/Library/KeepDownloadedPhotos=Start download for ^1 photos", #photos),
        functionContext = context
    })
    logger.trace("Start download")
    for idx, photo in ipairs(photos) do
        local path = tostring(photo:getRawMetadata("path"))
        logger.trace("file=" .. path)
        local cmd = "'" .. prefs.cloudfileExeuteable .. "' '" .. path .. "' materialize"
        logger.trace("execute " .. cmd)
        local result = LrTasks.execute(cmd)
        logger.trace("result=" .. tostring(result))
        if result ~= 0 then
            if result == 65280 then
                logger.trace("Photo is not located in a cloud directory.")
            else
                logger.trace("Download failed")
            end
        else
            logger.trace("Download started")
        end

        progress:setPortionComplete(idx, #photos)
    end

    progress:done()
end

--[[---------------------------------------------------------------------------
Main function
-----------------------------------------------------------------------------]]
LrFunctionContext.callWithContext("keepDownloaded", function(context)
    LrFunctionContext.postAsyncTaskWithContext("Start download photos and keep them", TaskFunc)
end) -- end main function
