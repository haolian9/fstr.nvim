---design choices
---* when cursor is placed outside of string, `|""` or `""|`, triggers not

local jelly = require("infra.jellyfish")("squirrel.fstr", vim.log.levels.DEBUG)
local prefer = require("infra.prefer")

local nuts = require("squirrel.nuts")

local api = vim.api

---@return TSNode?
local function find_str_at_cursor(winid)
  ---@type TSNode?
  local node = nuts.get_node_at_cursor(winid)
  for _ = 1, 5 do
    if node == nil then break end
    if node:type() == "string" then return node end
    node = node:parent()
  end
  return jelly.info("no string around")
end

---toggle fstr. only for python buffer
return function()
  local winid = api.nvim_get_current_win()
  local bufnr = api.nvim_win_get_buf(winid)

  if prefer.bo(bufnr, "filetype") ~= "python" then return jelly.err("only support python buffer") end

  local str_node = find_str_at_cursor(winid)
  if str_node == nil then return end

  local start_line, start_col = str_node:range()
  local start_char = api.nvim_buf_get_text(bufnr, start_line, start_col, start_line, start_col + 1, {})[1]

  if start_char == "f" then
    api.nvim_buf_set_text(bufnr, start_line, start_col, start_line, start_col + 1, { "" })
  else
    api.nvim_buf_set_text(bufnr, start_line, start_col, start_line, start_col, { "f" })
  end
end
