return {

    LrSdkVersion = 3.0,
    LrSdkMinimumVersion = 2.0,
    LrToolkitIdentifier = 'at.homebrew.lrcloud',

    LrPluginName = LOC "$$$/LRCloud/Metadata/CusLabel=LRCloud",
    LrLibraryMenuItems = {
        {
            title = LOC "$$$/LRCloud/Menu/Library/RemoveDownload=Remove Download",
            file = "RemoveDownload.lua",
            enabledWhen = "anythingSelected",
        },
        {
            title = LOC "$$$/LRCloud/Menu/Library/KeepDownloaded=Keep Downloaded",
            file = "StartDownload.lua",
            enabledWhen = "anythingSelected",
        },
    },

    LrInitPlugin = "InitPlugin.lua",

    VERSION = { major = 1, minor = 1, revision = 0, build = 0, },

}
