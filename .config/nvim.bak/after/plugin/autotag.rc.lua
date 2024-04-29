local status, autotag = pcall(require, "nvim-autotag") 
if(not status) then return end

autotag.setup({})
