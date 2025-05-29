-- Simple test helpers for notes utility
local M = {}

-- Test title processing function
function M.test_title_processing()
    print("=== Title Processing Tests ===")

    local tests = {
        { input = "日次会議", expected = "日次会議" },
        { input = "test note", expected = "test_note" },
        { input = "file/with\\bad:chars*", expected = "filewithbadchars" },
        { input = "", expected = "untitled" },
    }

    for i, test in ipairs(tests) do
        local title = test.input
        if title == "" then
            title = "untitled"
        end

        local processed = title:gsub(" ", "_"):gsub("[/\\:*?\"<>|]", "")

        local result = processed == test.expected and "✅ PASS" or "❌ FAIL"
        print(string.format("Test %d: '%s' → '%s' (expected: '%s') %s",
            i, test.input, processed, test.expected, result))
    end
end

-- Test date formatting
function M.test_date_formatting()
    print("\n=== Date Formatting Tests ===")

    local date = os.date("%Y%m%d")
    local year = os.date("%Y")

    print("Current date:", date)
    print("Current year:", year)
    print("Date format valid:", string.match(date, "^%d%d%d%d%d%d%d%d$") and "✅ PASS" or "❌ FAIL")
end

-- Test file path generation
function M.test_file_paths()
    print("\n=== File Path Tests ===")

    local NOTES_DIR = "/Users/s09104/ghq/github.com.yuucu/yuucu/life/notes/"
    local DAILY_DIR = "/Users/s09104/ghq/github.com.yuucu/yuucu/life/docs/journal/"

    local date = os.date("%Y%m%d")
    local year = os.date("%Y")

    local note_path = NOTES_DIR .. date .. "_test.md"
    local daily_path = DAILY_DIR .. year .. "/Daily/" .. date .. ".md"

    print("Note path:", note_path)
    print("Daily path:", daily_path)
end

-- Run all tests
function M.run_all_tests()
    print("🧪 Running Notes Utility Tests\n")
    M.test_title_processing()
    M.test_date_formatting()
    M.test_file_paths()
    print("\n✨ Tests completed!")
end

-- Test markdown header generation
function M.test_markdown_headers()
    print("\n=== Markdown Header Tests ===")

    local title = "test_note"
    local header = {
        "# " .. title:gsub("_", " "),
        "",
        "Date: " .. os.date("%Y-%m-%d %H:%M:%S"),
        "",
        "## Content",
        "",
    }

    print("Generated header:")
    for i, line in ipairs(header) do
        print(string.format("%d: %s", i, line))
    end
end

return M
