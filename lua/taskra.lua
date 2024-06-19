-- Define the plugin's name and entry point
local M = {}

-- Define the highlight group
local highlight_group = vim.api.nvim_create_augroup("LetterCodeHighlight", { clear = true })

-- Define the pattern to match
local pattern = "- \\[.\\] [. ]{0,2}([A-Za-z])\\d"

-- Define the highlight function
local function highlight_letter_code(line)
	-- Find the letter code in the line
	local letter_code = line:match(pattern)

	-- If a letter code was found, highlight it
	if letter_code then
		-- Get the start and end positions of the letter code
		local start, finish_pos = line:find(pattern)
		if start and finish_pos then
			local finish = finish_pos - 1

			-- Define the highlight color based on the letter code
			local highlight_color
			if letter_code:lower() == "a" then
				highlight_color = "ErrorMsg"
			elseif letter_code:lower() == "b" then
				highlight_color = "WarningMsg"
			else
				highlight_color = "MoreMsg"
			end

			-- Define the highlight
			vim.api.nvim_buf_add_highlight(0, highlight_group, highlight_color, start, finish, 0)
		end
	end
end

-- Define the function to setup the plugin
function M.setup()
	-- Attach the highlight function to the buffer
	vim.api.nvim_buf_attach(0, true, {
		on_lines = function(_, _, _, _, _)
			local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
			for _, line in ipairs(lines) do
				highlight_letter_code(line)
			end
		end,
	})
end
