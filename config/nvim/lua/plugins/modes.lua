return {
	'mvllow/modes.nvim',
	-- event = "VeryLazy",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require('modes').setup()
	end
}
