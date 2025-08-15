--[[---------------------------------------------------------------------------
-- Created by Dieter Stockhausen
-- Created on 09.11.23
-----------------------------------------------------------------------------]]
local LrApplication = import 'LrApplication'
local LrPathUtils = import 'LrPathUtils'
local LrDialogs = import 'LrDialogs'

-- Logger
local logger = require("Logger")

local lrutils = {}

--[[---------------------------------------------------------------------------
getCatName()
-----------------------------------------------------------------------------]]
function lrutils.getCatName()
    logger.trace("getCatName start")
    local activeCatalog = LrApplication.activeCatalog()
    local catName = LrPathUtils.removeExtension(LrPathUtils.leafName(activeCatalog:getPath()))
    local i = string.find(catName, "-v")
    logger.trace("i=" .. tostring(i))
    if (i ~= nil and i > 1) then
        catName = string.sub(catName, 1, i - 1)
    end
    return catName
end

--[[---------------------------------------------------------------------------
split()
-----------------------------------------------------------------------------]]
function lrutils.split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

--[[---------------------------------------------------------------------------
displayWarnings()
-----------------------------------------------------------------------------]]
function lrutils.displayWarnings(photosNotOnICloudDrive)
    if (photosNotOnICloudDrive > 0) then
        if (photosNotOnICloudDrive == 1) then
            LrDialogs.message(LOC(
                    "$$$/LRCloud/Msg/NotAllPhotosAreOnICloudDrive1=One photo is not on iCloud drive."),
                LOC("$$$/LRCloud/Msg/NothingChanged1=It is unchanged."))
        else
            LrDialogs.message(LOC(
                "$$$/LRCloud/Msg/NotAllPhotosAreOnICloudDrive2=^1 photos are not on iCloud drive.",
                photosNotOnICloudDrive), LOC("$$$/LRCloud/Msg/NothingChanged2=They are unchanged."))
        end
    end
end

return lrutils
