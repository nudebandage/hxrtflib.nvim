-- Neovim plugin that allows rtf capabilites
-- package.path = '../../../luahxrtflib/?.lua;' .. package.path
-- local LuaTextRtf = require "luahxrtflib"
local LuaTextRtf = require "hxrtflib.nvim"

-- When a new buffer is created run this...
-- plugin.func {
  -- name = "TimTest",
  -- func = function()
    -- return 0909
  -- end,
-- }

plugin.command {
  name = 'Hello',
  func = function() nvim.command('echo "World"') end
}

plugin.func {
  name = 'rtflib_init_buffer',
}

plugin.func {
  name = 'style_change',
}

plugin.command {
  name = "FromLua",
  func = function()
      print("hihi")
  end
}
