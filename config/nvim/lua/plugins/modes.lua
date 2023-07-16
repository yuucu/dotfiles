return {
	'mvllow/modes.nvim',
	event = "VeryLazy",
	config = function()
		require('modes').setup()
	end
}
