return {
  settings = {

    Lua = {
      diagnostics = {
        globals = { "vim", "fs_stat" },
      },
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.stdpath("config") .. "/lua"] = true,
        },
      },
    },
  },
}
