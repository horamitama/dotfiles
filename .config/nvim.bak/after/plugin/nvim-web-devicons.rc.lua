local status, web_icon = pcall(require, "nvim-web-devicons")
if(not status) then return end

web_icon.setup({})
