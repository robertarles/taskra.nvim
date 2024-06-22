local M = {}

-- Table to store syntax highlighting rules
M.syntax_rules = {}

-- Table to store text manipulation functions
M.text_functions = {}

-- Table to store workflow functions
M.workflow_functions = {}

-- Function to add syntax highlighting rules
function M.add_syntax_rule(pattern, highlight_group)
	table.insert(M.syntax_rules, { pattern = pattern, group = highlight_group })
end

-- Function to add text manipulation functions
function M.add_text_function(name, func)
	M.text_functions[name] = func
end

-- Function to add workflow functions
function M.add_workflow_function(name, func)
	M.workflow_functions[name] = func
end


ocal function apply_syntax_highlighting(bufnr, start_line, end_line)
  bufnr = bufnr or 0
  start_line = start_line or 0
  end_line = end_line or -1

  -- Clear existing highlights in the specified range
  vim.api.nvim_buf_clear_namespace(bufnr, -1, start_line, end_line)

  -- Get the lines in the specified range
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_line, end_line, false)

  -- Apply custom syntax rules
  for _, rule in ipairs(M.syntax_rules) do
    for i, line in ipairs(lines) do
      for captures in line:gmatch(rule.pattern) do
        if captures then
          -- Find the position of the first capture group
          local s, e = line:find(captures, 1, true)
          if s then
            vim.api.nvim_buf_add_highlight(bufnr, -1, rule.group, start_line + i - 1, s - 1, e)
          end
        end
      end
    end
  end
end


-- Function to set up autocommands
local function setup_autocommands()
	local group = vim.api.nvim_create_augroup("TaskRa", { clear = true })

	vim.api.nvim_create_autocmd({ "BufEnter", "BufRead", "BufNewFile" }, {
		group = group,
		callback = function(ev)
			apply_syntax_highlighting(ev.buf)
		end,
	})

	-- Watch for changes and update highlighting
	vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
		group = group,
		callback = function(ev)
			local start_line = vim.fn.line("w0") - 1
			local end_line = vim.fn.line("w$")
			apply_syntax_highlighting(ev.buf, start_line, end_line)
		end,
	})
end

-- Function to set up key mappings
local function setup_mappings()
	for name, func in pairs(M.text_functions) do
		vim.api.nvim_set_keymap("n", "<Leader>t" .. name, "", {
			noremap = true,
			callback = func,
			desc = "Text function: " .. name,
		})
	end

	for name, func in pairs(M.workflow_functions) do
		vim.api.nvim_set_keymap("n", "<Leader>w" .. name, "", {
			noremap = true,
			callback = func,
			desc = "Workflow function: " .. name,
		})
	end
end

-- Main setup function
function M.setup(opts)
	opts = opts or {}

	vim.api.nvim_set_hl(0, "RaModHighlight", { fg = "#00FF00", bold = true })
	setup_autocommands()
	setup_mappings()

	-- You can add more setup logic here
end

return M
