local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- add LazyVim and import its plugins
  -- import/override with your plugins
  -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
  -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
  -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
  -- have outdated releases, which may break your Neovim install. -- always use the latest git commit
  -- version = "*", -- try installing the latest stable version for plugins that support semver -- check for plugin updates periodically -- notify on update -- automatically check for plugin updates
  -- disable some rtp plugins
  -- "matchit",
  -- "matchparen",
  -- "netrwPlugin",
  spec = { {
    "LazyVim/LazyVim",
    import = "lazyvim.plugins",
  }, { import = "plugins" } },
  defaults = {
    lazy = false,
    version = false,
  },
  install = {
    colorscheme = { "tokyonight", "habamax" },
  },
  checker = {
    enabled = true,
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
