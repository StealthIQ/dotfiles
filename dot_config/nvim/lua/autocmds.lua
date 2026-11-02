require "nvchad.autocmds"

-- Smart save handler
-- Prompts for filename and missing directories on write
-- Aborts cleanly on ESC or invalid input
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(args)
    -- 1. Handle unnamed buffers
    if args.file == "" then
      vim.cmd "redraw"
      local fname = vim.fn.input "No filename. Save as: "

      -- ESC or empty input → abort silently
      if fname == nil or fname == "" then
        vim.cmd "abort"
        return
      end

      -- Set filename and update args.file
      vim.cmd("file " .. vim.fn.fnameescape(fname))
      args.file = vim.fn.expand "%:p"
    end

    -- 2. Handle missing directories
    local dir = vim.fn.fnamemodify(args.file, ":p:h")

    if vim.fn.isdirectory(dir) == 0 then
      vim.cmd "redraw"
      local input = vim.fn.input("Directory does not exist:\n" .. dir .. "\nCreate and save? [y/N]: ")

      -- ESC returns empty string
      if not input or input == "" then
        vim.cmd "abort"
        return
      end

      input = input:lower()

      if input:sub(1, 1) == "y" then
        vim.fn.mkdir(dir, "p")
      else
        vim.cmd "abort"
        return
      end
    end
  end,
})
