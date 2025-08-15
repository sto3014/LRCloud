--[[----------------------------------------------------------------------------
StartDownload.lua
------------------------------------------------------------------------------]]
-- Access the Lightroom SDK namespaces.
local LrFunctionContext = import 'LrFunctionContext'
local LrApplication = import 'LrApplication'
local LrProgressScope = import 'LrProgressScope'
local LrTasks = import 'LrTasks'
local LrDialogs = import "LrDialogs"

local LrPrefs = import("LrPrefs")

local utils = require("LrUtils")

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

    local downloadMustBeRemoved = {}
    local alreadyRemoved = 0
    for _, photo in ipairs(photos) do
        local path = tostring(photo:getRawMetadata("path"))
        local isLocalAvailableCommand = "'" .. prefs.isLocalAvailableScript .. "'" .. " " .. "'" .. path .. "'"
        logger.trace("Check if download must be removed ...")
        logger.trace("cmd=" .. isLocalAvailableCommand)
        local result = LrTasks.execute(isLocalAvailableCommand)
        logger.trace("result=" .. tostring(result))
        if (result == 0) then
            logger.trace("Download must be removed.")
            table.insert(downloadMustBeRemoved, path)
        else
            alreadyRemoved = alreadyRemoved + 1
            logger.trace("Download is already removed.")
            progress:setPortionComplete(alreadyRemoved, #photos)
        end
    end
    logger.trace("downloadMustBeRemoved=" .. tostring(#downloadMustBeRemoved))
    logger.trace("alreadyRemoved=" .. tostring(alreadyRemoved))

    if (#downloadMustBeRemoved == 0) then
        LrDialogs.message(LOC(
            "$$$/LRCloud/Msg/AllDownloadsAlreadyRemoved=All downloads are already removed.", nil, "info"))
    else
        local photosNotOnICloudDrive = 0
        for idx, path in ipairs(downloadMustBeRemoved) do
            logger.trace("file=" .. path)
            logger.trace("Photo is in iCloud folder")
            local cmd = "'" .. prefs.cloudfileExeuteable .. "' '" .. path .. "' evict"
            logger.trace("execute " .. cmd)
            local stat = LrTasks.execute(cmd)
            if stat ~= 0 then
                logger.trace("Error: Download could not be removed")
            else
                logger.trace("Download removed")
            end
            progress:setPortionComplete(idx + alreadyRemoved, #photos)
        end

        if (prefs.displayWarnings) then
            utils.displayWarnings(photosNotOnICloudDrive)
        end
    end
    progress:done()
end

--[[---------------------------------------------------------------------------
Main function
-----------------------------------------------------------------------------]]
LrFunctionContext.callWithContext("removeDownload", function(context)
    LrFunctionContext.postAsyncTaskWithContext("Remove download", TaskFunc)
end) -- end main function
