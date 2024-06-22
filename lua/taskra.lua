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

-- Function to apply syntax highlighting
local function apply_syntax_highlighting(bufnr)
	bufnr = bufnr or 0

	-- Clear existing highlights
	vim.api.nvim_buf_clear_namespace(bufnr, -1, 0, -1)

	-- Apply custom syntax rules
	for _, rule in ipairs(M.syntax_rules) do
		vim.fn.matchadd(rule.group, rule.pattern)
	end

	-- Highlight "ra_mod" in green
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	for lnum, line in ipairs(lines) do
		local start = 1
		while true do
			local s, e = line:find("ra_mod", start, true)
			if not s then
				break
			end
			vim.api.nvim_buf_add_highlight(bufnr, -1, "RaModHighlight", lnum - 1, s - 1, e)
			start = e + 1
		end
	end
end

-- Function to set up autocommands
local function setup_autocommands()
	local group = vim.api.nvim_create_augroup("taskra", { clear = true })

	vim.api.nvim_create_autocmd({ "BufEnter", "BufRead", "BufNewFile" }, {
		group = group,
		callback = function(ev)
			apply_syntax_highlighting(ev.buf)
		end,
	})

	vim.api.nvim_create_autocmd("BufWritePost", {
		group = group,
		callback = function(ev)
			apply_syntax_highlighting(ev.buf)
			print("Buffer saved!")
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
