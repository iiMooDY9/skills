local normalize_line = function(line)
  return line:gsub("^%s+", ""):gsub("%s+$", ""):gsub("%s+", " ")
end

local extract_function_definitions = function(text)
  local lines = vim.split(text, "\n")
  local result = {}
  local seen = {}

  for _, line in ipairs(lines) do
    for tag in line:gmatch("%*([^%*]+)%*") do
      if tag:match("^vim%.lsp[%w_%.:]*%b()") then
        local signature = normalize_line(tag)
        if not seen[signature] then
          seen[signature] = true
          table.insert(result, signature)
        end
      end
    end
  end

  return table.concat(result, "\n")
end

local read = {}

table.insert(read, "# Neovim LSP API Reference")
table.insert(read, "")
table.insert(read, "This document contains function definitions from Neovim's LSP help docs.")
table.insert(read, "Use this as a reference when working with LSP in Neovim Lua.")
table.insert(read, "")
table.insert(read, "---")
table.insert(read, "")
table.insert(read, "## lsp")
table.insert(read, "")
table.insert(read, "Functions extracted from `lsp.txt`.")
table.insert(read, "")
table.insert(read, "```lua")

local file = vim.api.nvim_get_runtime_file("doc/lsp.txt", false)[1]
if file then
  local lines = vim.fn.readfile(file)
  local text = table.concat(lines, "\n")
  text = extract_function_definitions(text)
  table.insert(read, text)
else
  io.stderr:write("Warning: Could not find doc/lsp.txt\n")
end

table.insert(read, "```")
table.insert(read, "")

local result = table.concat(read, "\n")
local output_path = arg[1] or (os.getenv("HOME") .. "/.behaviors/vim.lsp.md")
local dir = output_path:match("(.*/)")
if dir then
  os.execute("mkdir -p " .. dir)
end

local output_file = io.open(output_path, "w")
if output_file then
  output_file:write(result)
  output_file:close()
  print("Generated: " .. output_path)
else
  io.stderr:write("Error: Could not write to " .. output_path .. "\n")
  os.exit(1)
end
