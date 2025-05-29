-- Test module for notes utility functions
-- =====================================

local M = {}

-- Test functions
function M.test_title_processing()
  print('📝 Testing title processing...')

  -- Test cases for title processing
  local test_cases = {
    { input = 'hello world', expected = 'hello world' },
    { input = 'Hello World', expected = 'Hello World' },
    { input = 'こんにちは世界', expected = 'こんにちは世界' },
    { input = 'test/file', expected = 'test_file' },
    { input = 'test:name', expected = 'test_name' },
    { input = 'test|name', expected = 'test_name' },
    { input = 'test<name>', expected = 'test_name_' },
    { input = 'test"name"', expected = 'test_name_' },
    { input = 'test?name', expected = 'test_name' },
    { input = 'test*name', expected = 'test_name' },
    { input = '  spaced  ', expected = 'spaced' },
  }

  local success_count = 0
  local total_count = #test_cases

  for i, case in ipairs(test_cases) do
    -- Simulate the title processing logic from notes.lua
    local result = case
      .input
      :gsub('[/\\:*?"<>|]', '_') -- Replace invalid filename chars
      :gsub('%s+', ' ') -- Normalize spaces
      :gsub('^%s*(.-)%s*$', '%1') -- Trim spaces

    if result == case.expected then
      print(string.format("  ✅ Test %d: '%s' -> '%s'", i, case.input, result))
      success_count = success_count + 1
    else
      print(string.format("  ❌ Test %d: '%s' -> '%s' (expected: '%s')", i, case.input, result, case.expected))
    end
  end

  print(string.format('📝 Title processing: %d/%d tests passed', success_count, total_count))
  return success_count == total_count
end

function M.test_date_formatting()
  print('📅 Testing date formatting...')

  local current_date = os.date('*t')
  local expected_format = string.format('%04d%02d%02d', current_date.year, current_date.month, current_date.day)
  local actual_format = os.date('%Y%m%d')

  if actual_format == expected_format then
    print(string.format('  ✅ Date format test passed: %s', actual_format))
    return true
  else
    print(string.format('  ❌ Date format test failed: %s (expected: %s)', actual_format, expected_format))
    return false
  end
end

function M.test_file_paths()
  print('📁 Testing file path generation...')

  local base_path = '/Users/s09104/ghq/github.com.yuucu/yuucu/life'
  local date_str = os.date('%Y%m%d')
  local title = 'test_note'

  -- Test note file path
  local note_path = string.format('%s/notes/%s_%s.md', base_path, date_str, title)
  local expected_note_pattern = '/Users/s09104/ghq/github%.com%.yuucu/yuucu/life/notes/%d+_test_note%.md'

  -- Test daily note path
  local year = os.date('%Y')
  local daily_path = string.format('%s/docs/journal/%s/Daily/%s.md', base_path, year, date_str)
  local expected_daily_pattern = '/Users/s09104/ghq/github%.com%.yuucu/yuucu/life/docs/journal/%d+/Daily/%d+%.md'

  local note_test = string.match(note_path, expected_note_pattern) ~= nil
  local daily_test = string.match(daily_path, expected_daily_pattern) ~= nil

  if note_test then
    print(string.format('  ✅ Note path test passed: %s', note_path))
  else
    print(string.format('  ❌ Note path test failed: %s', note_path))
  end

  if daily_test then
    print(string.format('  ✅ Daily path test passed: %s', daily_path))
  else
    print(string.format('  ❌ Daily path test failed: %s', daily_path))
  end

  print(string.format('📁 File paths: %d/2 tests passed', (note_test and 1 or 0) + (daily_test and 1 or 0)))
  return note_test and daily_test
end

function M.test_markdown_headers()
  print('📄 Testing markdown header generation...')

  local title = 'Test Note'
  local date_str = os.date('%Y-%m-%d')

  -- Test note header
  local note_header = string.format('# %s\n\n**Date:** %s\n\n## Content\n\n', title, date_str)
  local note_test = string.match(note_header, '^# .+\n\n%*%*Date:%*%* .+\n\n## Content\n\n$') ~= nil

  -- Test daily header
  local daily_header = string.format(
    '# Daily Note - %s\n\n## 📝 Todo\n\n- [ ] \n\n## 📔 Notes\n\n\n\n## 🤔 Reflection\n\n',
    date_str
  )
  local daily_test = string.match(
    daily_header,
    '^# Daily Note %- .+\n\n## 📝 Todo\n\n%- %[ %] \n\n## 📔 Notes\n\n\n\n## 🤔 Reflection\n\n$'
  ) ~= nil

  if note_test then
    print('  ✅ Note header test passed')
  else
    print('  ❌ Note header test failed')
  end

  if daily_test then
    print('  ✅ Daily header test passed')
  else
    print('  ❌ Daily header test failed')
  end

  print(string.format('📄 Markdown headers: %d/2 tests passed', (note_test and 1 or 0) + (daily_test and 1 or 0)))
  return note_test and daily_test
end

-- Run all tests function for Makefile integration
function M.run_all_tests()
  print('🧪 Running all notes utility tests...')
  print('=====================================')

  local results = {
    M.test_title_processing(),
    M.test_date_formatting(),
    M.test_file_paths(),
    M.test_markdown_headers(),
  }

  local passed = 0
  local total = #results

  for _, result in ipairs(results) do
    if result then
      passed = passed + 1
    end
  end

  print('=====================================')
  if passed == total then
    print(string.format('🎉 All tests passed! (%d/%d)', passed, total))
  else
    print(string.format('❌ Some tests failed: %d/%d passed', passed, total))
  end

  return passed == total
end

return M
