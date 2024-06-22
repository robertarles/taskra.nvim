local M = {}

-- ... (keep the rest of the plugin code as is)

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

-- ... (keep the rest of the plugin code as is)

function M.setup(opts)
	opts = opts or {}

	-- Define the highlight group for "ra_mod"
	vim.api.nvim_set_hl(0, "RaModHighlight", { fg = "#00FF00", bold = true })

	setup_autocommands()
	setup_mappings()

	-- You can add more setup logic here
end

return M

