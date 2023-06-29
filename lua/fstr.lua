---todo: apply infra.Regulator

local jelly = require("infra.jellyfish")("squirrel.fstr", vim.log.levels.DEBUG)
local prefer = require("infra.prefer")

local nuts = require("squirrel.nuts")

local api = vim.api

---@return TSNode?
local function find_str_at_cursor(winid)
  ---@type TSNode?
  local node = nuts.get_node_at_cursor(winid)
  ---todo: ""| what about chunk?
  local retry = 5
  for _ = 1, retry do
    if node == nil then return end
    if node:type() == "string" then return node end
    node = node:parent()
  end
  return jelly.info("no string around by ascending %d levels", retry)
end

---toggle fstr. only for python buffer
return function()
  local winid = api.nvim_get_current_win()
  local bufnr = api.nvim_win_get_buf(winid)

  if prefer.bo(bufnr, "filetype") ~= "python" then error("only support lua buffer") end

  local str_node = find_str_at_cursor(winid)
  if str_node == nil then return end

  local start_line, start_col, stop_line = str_node:range()
  stop_line = stop_line + 1

  local start_char = api.nvim_buf_get_text(bufnr, start_line, start_col, start_line, start_col + 1, {})[1]
  if start_char == "f" then
    api.nvim_buf_set_text(bufnr, start_line, start_col, start_line, start_col + 1, { "" })
  else
    api.nvim_buf_set_text(bufnr, start_line, start_col, start_line, start_col, { "f" })
  end
end
