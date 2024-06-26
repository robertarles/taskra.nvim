local M = {}

M.syntax_rules = {}
M.text_functions = {}
M.workflow_functions = {}

function M.add_syntax_rule(pattern, highlight_group)
	table.insert(M.syntax_rules, { pattern = pattern, group = highlight_group })
end

function M.add_text_function(name, func)
	M.text_functions[name] = func
end

function M.add_workflow_function(name, func)
	M.workflow_functions[name] = func
end

local ns_id = vim.api.nvim_create_namespace("TaskRa")

local function apply_syntax_highlighting(bufnr, start_line, end_line)
	bufnr = bufnr or 0
	start_line = start_line or 0
	end_line = end_line or -1

	-- check start_line and end_line to ensure they are valid for this buffer
	if start_line < 0 then
		start_line = 0
	end
	if end_line > vim.api.nvim_buf_line_count(bufnr) then
		end_line = vim.api.nvim_buf_line_count
	end

	-- Get the lines in the specified range
	local lines = vim.api.nvim_buf_get_lines(bufnr, start_line, end_line, false)

	-- Clear existing highlights only for the changed lines
	vim.api.nvim_buf_clear_namespace(bufnr, ns_id, start_line, end_line)

	-- Apply custom syntax rules
	for i, line in ipairs(lines) do
		local line_num = start_line + i - 1
		for _, rule in ipairs(M.syntax_rules) do
			for captures in line:gmatch(rule.pattern) do
				if captures then
					local s, e = line:find(captures, 1, true)
					if s then
						vim.api.nvim_buf_add_highlight(bufnr, ns_id, rule.group, line_num, s - 1, e or -1)
					end
				end
			end
		end
	end
end

local function setup_autocommands()
	local group = vim.api.nvim_create_augroup("TaskRa", { clear = true })

	vim.api.nvim_create_autocmd({ "BufEnter", "BufRead", "BufNewFile" }, {
		group = group,
		callback = function(ev)
			apply_syntax_highlighting(ev.buf)
		end,
	})

	vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
		group = group,
		callback = function(ev)
			local changed_start = vim.fn.getpos("'[")[2] - 1
			local changed_end = vim.fn.getpos("']")[2]
			apply_syntax_highlighting(ev.buf, changed_start, changed_end)
		end,
	})
end

local function setup_mappings()
	for name, func in pairs(M.text_functions) do
		vim.keymap.set("n", "<Leader>it" .. name, func, {
			noremap = true,
			desc = "Text function: " .. name,
		})
	end

	for name, func in pairs(M.workflow_functions) do
		vim.keymap.set("n", "<Leader>ik" .. name, func, {
			noremap = true,
			desc = "Workflow function: " .. name,
		})
	end
end

function M.setup(opts)
	opts = opts or {}

	vim.api.nvim_set_hl(0, "RaModHighlight", { fg = "#00FF00", bold = true })
	setup_autocommands()
	setup_mappings()

	-- You can add more setup logic here
end

return M
