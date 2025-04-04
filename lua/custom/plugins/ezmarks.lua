local M = {}

local bookmarks = {}
local git_branch = ""
local bookmark_file = vim.fn.stdpath('data') .. '/bookmarks.json'

-- Helper function to load bookmarks from file
local function load_bookmarks()
    local file = io.open(bookmark_file, "r")
    if file then
        local content = file:read("*a")
        file:close()
        local ok, data = pcall(vim.fn.json_decode, content)
        if ok and data then
            bookmarks = data
        end
    end
end

-- Helper function to save bookmarks to file
local function save_bookmarks()
    local file = io.open(bookmark_file, "w")
    if file then
        file:write(vim.fn.json_encode(bookmarks))
        file:close()
    end
end

-- Helper function to get current git branch
local function get_git_branch()
    local handle = io.popen("git rev-parse --abbrev-ref HEAD")
    if handle then
        local branch = handle:read("*a"):gsub("\n", "")
        handle:close()
        return branch
    end
    return ""
end

-- Helper function to get git remote URL for the file and line number
local function get_git_remote_url(file, line)
    local handle = io.popen("git config --get remote.origin.url")
    if handle then
        local remote_url = handle:read("*a"):gsub("\n", "")
        handle:close()
        if remote_url:find("^http") then
            return string.format("%s/blob/%s/%s#L%d", remote_url, git_branch, file, line)
        else
            return string.format("https://%s/blob/%s/%s#L%d", remote_url:gsub(":", "/"):gsub("git@", ""), git_branch, file, line)
        end
    end
    return ""
end

-- Add a bookmark
function M.add_bookmark(tags_and_name)
    local file = vim.fn.expand("%:p")
    local line = vim.fn.line(".")

    -- Separate tags and name
    local tags, name = tags_and_name:match("^(.-)%s+(.*)$")
    if not tags then
        tags = tags_and_name
        name = ""
    end

    if tags == "" then
        tags = git_branch
    else
        tags = tags .. "," .. git_branch
    end

    local tag_list = {}
    for tag in string.gmatch(tags, "[^,]+") do
        table.insert(tag_list, vim.trim(tag))
    end

    local url = get_git_remote_url(file, line)

    -- Combine all tags into a single string for the unique file + line combination
    local key = file .. ":" .. line
    if not bookmarks[key] then
        bookmarks[key] = {
            tags = {},
            name = name,
            file = file,
            line = line,
            url = url
        }
    end

    if not bookmarks[key].tags then
        bookmarks[key].tags = {}
    end

    for _, tag in ipairs(tag_list) do
        if not vim.tbl_contains(bookmarks[key].tags, tag) then
            table.insert(bookmarks[key].tags, tag)
        end
    end

    save_bookmarks()
    print("Bookmark added: " .. name .. " [" .. table.concat(bookmarks[key].tags, ",") .. "]")
end

-- View bookmarks in a floating window
function M.view_bookmarks(tag_filter)
    tag_filter = tag_filter or git_branch

    local output = {}
    table.insert(output, string.format("%-40s %-10s %-15s %-10s", "File:Line", "Name", "Tags", "URL"))
    table.insert(output, string.rep("-", 80))

    for key, entry in pairs(bookmarks) do
        if not entry.tags then
            entry.tags = {}
        end

        local tags = table.concat(entry.tags, ",")
        if not tag_filter or tag_filter == "all" or tags:find(tag_filter) then
            table.insert(output, string.format(
                "%-40s %-10s %-15s %-10s",
                entry.file .. ":" .. entry.line,
                entry.name,
                tags,
                entry.url
            ))
        end
    end

    -- Create a floating window
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)

    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local opts = {
        relative = "editor",
        width = width,
        height = height,
        col = math.floor((vim.o.columns - width) / 2),
        row = math.floor((vim.o.lines - height) / 2),
        style = "minimal",
        border = "single",
    }

    vim.api.nvim_open_win(buf, true, opts)
end

-- Initialize plugin
function M.setup()
    git_branch = get_git_branch()
    load_bookmarks()

    vim.api.nvim_create_user_command("AddBookmark", function(opts)
        M.add_bookmark(opts.args)
    end, { nargs = 1 })

    vim.api.nvim_create_user_command("ViewBookmarks", function(opts)
        M.view_bookmarks(opts.args)
    end, { nargs = "?" })
end

return M
