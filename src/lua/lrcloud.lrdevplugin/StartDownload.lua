--[[----------------------------------------------------------------------------
StartDownload.lua
------------------------------------------------------------------------------]]
-- Access the Lightroom SDK namespaces.
local LrFunctionContext = import 'LrFunctionContext'
local LrApplication = import 'LrApplication'
local LrProgressScope = import 'LrProgressScope'
local LrTasks = import 'LrTasks'
local LrPrefs = import "LrPrefs"
local LrDialogs = import "LrDialogs"

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
    logger.trace("photos selected=" .. tostring(#photos))

    local progress = LrProgressScope({
        title = LOC("$$$/LRCloud/Menu/Library/KeepDownloadedPhotos=Start download for ^1 photos", #photos),
        functionContext = context
    })

    local photosThatNeedDownload = {}
    local alreadyDownloaded = 0
    for _, photo in ipairs(photos) do
        local path = tostring(photo:getRawMetadata("path"))
        local isLocalAvailableCommand = "'" .. prefs.isLocalAvailableScript .. "' '" .. path .. "'"
        logger.trace("Check if needs download...")
        logger.trace("cmd=" .. isLocalAvailableCommand)
        local result = LrTasks.execute(isLocalAvailableCommand)
        logger.trace("result=" .. tostring(result))
        if (result == 0) then
            alreadyDownloaded = alreadyDownloaded + 1
            logger.trace("Photo is already available.")
            progress:setPortionComplete(alreadyDownloaded, #photos)
        else
            logger.trace("Photo must be downloaded.")
            table.insert(photosThatNeedDownload, path)
        end
    end
    logger.trace("photosThatNeedDownload=" .. tostring(#photosThatNeedDownload))
    logger.trace("alreadyDownloaded=" .. tostring(alreadyDownloaded))

    if (#photosThatNeedDownload == 0) then
        LrDialogs.message(LOC(
            "$$$/LRCloud/Msg/AllPhotosAlreadyDownloaded=All photos are already downloaded.", nil, "info"))
    else
        local photosNotOnICloudDrive = 0
        logger.trace("Start download")
        for idx, path in ipairs(photosThatNeedDownload) do
            logger.trace("file=" .. path)
            local cmd = "'" .. prefs.cloudfileExeuteable .. "' '" .. path .. "' materialize"
            logger.trace("execute " .. cmd)
            local result = LrTasks.execute(cmd)
            logger.trace("result=" .. tostring(result))
            if result ~= 0 then
                logger.trace("Download failed")
            else
                logger.trace("Download started")
            end

            progress:setPortionComplete(idx + alreadyDownloaded, #photos)
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
LrFunctionContext.callWithContext("keepDownloaded", function(context)
    LrFunctionContext.postAsyncTaskWithContext("Start download photos and keep them", TaskFunc)
end) -- end main function
