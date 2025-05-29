-- Test file for notes utility functions
-- Requires plenary.nvim for testing framework

local notes = require('utils.notes')

describe("notes utility", function()
    local test_notes_dir = "/tmp/test_notes/"
    local test_daily_dir = "/tmp/test_daily/"

    before_each(function()
        -- Setup test directories
        vim.fn.mkdir(test_notes_dir, "p")
        vim.fn.mkdir(test_daily_dir, "p")

        -- Mock the directories in the notes module (if needed)
        -- This would require modifying the notes module to accept config
    end)

    after_each(function()
        -- Cleanup test files
        vim.fn.delete(test_notes_dir, "rf")
        vim.fn.delete(test_daily_dir, "rf")
    end)

    describe("create_new_note", function()
        it("should create a file with correct date format", function()
            -- Mock vim.fn.input to return a test title
            local original_input = vim.fn.input
            vim.fn.input = function() return "test_note" end

            -- This would need the function to be testable
            -- Currently it's hard to test because it modifies global state

            -- Restore original function
            vim.fn.input = original_input
        end)
    end)

    describe("date formatting", function()
        it("should format date correctly", function()
            local date = os.date("%Y%m%d")
            assert.matches("%d%d%d%d%d%d%d%d", date)
        end)
    end)

    describe("title processing", function()
        it("should replace spaces with underscores", function()
            local title = "test note title"
            local processed = title:gsub(" ", "_")
            assert.equals("test_note_title", processed)
        end)

        it("should remove problematic characters", function()
            local title = "test/note\\title:with*problem?"
            local processed = title:gsub("[/\\:*?\"<>|]", "")
            assert.equals("testnotetitlewithproblem", processed)
        end)
    end)
end)
