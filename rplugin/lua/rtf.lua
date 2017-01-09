package.path = '../../../hxrtflib/output/luahxrtflib/?.lua;' .. package.path

local hxmodule = require "hxrtflib"
local Hxrtflib = hxmodule.hxrtflib.Hxrtflib
local Globals = hxmodule.Hxrtflib.Globals

local inspect = require "inspect"

IGNORE_KEYS = {'Left',
               'Down',
               'Right',
               'Up',
               'BackSpace',
               'Escape',}

MODS = ('Control',
        'Alt',
        'Shift',
        'Super')

NvimRtf = {_fonts = {},
           tag_prefix = 'luahxrtflib',
           buf = nil,
           ns = nil}

-- buf:number of nvim buffer
-- ns:string or nil
function NvimRtf:new (o, buf, namespace)
  o = o or {}
  setmetatable(o, self)
  self._index = self

  if (type(buf) ~= number) then
    print("buffer required as a number..")
    return
  end

  self.buf = buf

  if (type(namespace) ~= string) then
    print("ns required as a string..")
    return
  end

  -- TODO this can fail if already allocated
  self.ns = nvim:request("nvim_init_tag_ns", namespace)

  o.rtflib = Hxrtflib:new()
  o.rtflib:setup(NvimRtf._is_selected,
                 NvimRtf._first_selected_index,
                 NvimRtf._char_at_index,
                 NvimRtf._tag_at_index,
                 NvimRtf._tag_add,
                 NvimRtf._last_col,
                 NvimRtf._ignore_keys,
                 NvimRtf._insert_cursor_get,
                 NvimRtf._create_style,
                 NvimRtf._modify_style,
                 NvimRtf._sel_index_get)

  -- nvim:request("autocmd InsertCharPre", self._insert_char)

  -- TODO gui implementer will have to do the mouse
  -- nvim:request("autocmd InsertCharPre", self._mouse_click)

  return o
end

-- Functions for working with neovim
function NvimRtf:set_tag(id, lower, upper)
  return nvim:request('nvim_buf_set_tag', self.buf, self.ns, id , lower, upper)
end
function NvimRtf:unset_tag(id, lower, upper)
  return nvim:request('nvim_buf_unset_tag', self.buf, self.ns, id , lower, upper)
end
function NvimRtf:get_tags(index)
  return nvim:request('nvim_buf_get_tags', self.buf, self.ns, index)
end
function NvimRtf:get_tags(index)
  return nvim:request('nvim_buf_get_tags', self.buf, self.ns, index)
end
function NvimRtf:get_tag_ranges(id)
  return nvim:request('nvim_buf_get_tag_ranges', self.buf, self.ns, id)
end

function NvimRtf:getcurpos()
  result = nvim:request('nvim_buf_getcurpos')
  return {result[2], result[3]}
end

-- Active functions calling hxrtflib
function NvimRtf:_mouse_click()
    cursor = self._insert_cursor_get()
    self.rtflib.on_mouse_click(cursor[1], cursor[2])
end

function NvimRtf:_insert_char(event)
    cursor = self.getcurpos()
    self.rtflib.on_char_insert(event, cursor[1], cursor[2])
end

-- Reactive functions for hxrtflib
function NvimRtf:_is_selected(row, col)
  print("is_selected")
  --TODO has to be implemented by the gui
end

function NvimRtf:_first_selected_index(row, col)
  print("first_selected_index")
  --TODO has to be implemented by the gui
end

function NvimRtf:_char_at_index(row, col)
  print("_char_at_index")
  line = nvim:request('nvim_buf_getline', row)
  return line[col+1]
end

function NvimRtf:_tag_at_index(row, col)
  print("tag_at_index")
  tags = self.get_tags({row, col})

  -- test TODO
  if (tags == nil or tags == {}) then
    return Globals.NOTHING
  else
    return tags[#tags]
  end
end

function NvimRtf:_tag_add(tag, row, col)
  print("_tag_add")
  -- NOTE: This is called before the char is inserted, does it work?
  -- TODO so the gui implementer needs to use after method
  -- SEND tag_update event out to the gui
end

function NvimRtf:_last_col(row)
  print("last_col")
  line = nvim:request('nvim_buf_getline', row)
  return #line - 1
end

function NvimRtf:_ignore_keys(event)
  print("ignore_keys")
  for i, #IGNORE_CHARS do
    if (event == IGNORE_KEYS[i]) then
      return true
    end
  end

  for i #MODS do
    if (event == MODS[i]) then
      return true
  end
  return false
end

function NvimRtf:_insert_cursor_get()
  print("insert_cursor_get")
  return self.getcurpos()
end

function NvimRtf:_create_style(tag)
  print("create_style")
  -- TODO gui has to handle this
end

function NvimRtf:_modify_style(tag, change_style, change)
  print("modify_style")
  -- TODO gui has to hanlde this
end

function NvimRtf:_sel_index_get(row, col)
  print("sel_index_get")
  -- TODO gui has to hanlde this
end

return NvimRtf
