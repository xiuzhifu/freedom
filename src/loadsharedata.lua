skynet = require "skynet"
sharedata = require "sharedata"
buildconf = require "build_conf"

skynet.start(
    function()
        sharedata.new("buildconf", buildconf.base)
        skynet.exit()
    end
)
