-- 自动安装Packer --
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- 自动更新和安装插件
vim.cmd([[
    augroup packer_user_config
        autocmd!
        autocmd! BufWritePost plugins-setup.lua source <afile> | PackerSync
    augroup end
]])

-- 插件
return require('packer').startup(function(use)

  use 'wbthomason/packer.nvim'
  use 'folke/tokyonight.nvim'   -- 主题
  use {
  'nvim-lualine/lualine.nvim',      -- 状态栏
  requires = { 'nvim-tree/nvim-web-devicons', opt = true },     -- 图标
  config = function()
      require('lualine').setup({ options = { theme = 'auto' } })
  end
}
-- 结束
  -- 文件管理
  use({
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  requires = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons", -- optional, but recommended
  }
})
-- 结束
-- 把‘代码’变成‘语法树’，所有后续智能功能（高亮、折叠、跳转、文本对象等）都建立在这棵树上
  use {
  'nvim-treesitter/nvim-treesitter',
  run = ':TSUpdate',                -- 装完顺手拉取所有已启用 parser
  config = function()
    require('nvim-treesitter.configs').setup {
      ensure_installed = { 'vim' }, -- 只装 vim 语言即可，也可写 'all'
      highlight = { enable = true },
      
      close_if_last_window = true,  -- 当侧边栏成最后一窗时自动关闭
      filesystem = {
        follow_current_file = { enable = true },    -- 跟随当前文件
        use_libuv_file_watcher = true,  -- 外部改动实时更新
      },
    }
  end,
}
  -- 结束

  use 'christoomey/vim-tmux-navigator'
  -- 可以在编辑时就看到我写入的颜色
  use("catgoose/nvim-colorizer.lua")

  -- LSP 代码补全
  use {
      'williamboman/mason.nvim',    -- 类似“应用商店”，提供服务器列表
      'neovim/nvim-lspconfig',      -- 官方 LSP 客户端
      'williamboman/mason-lspconfig.nvim',  -- 自动把商店中装好的服务器接到 lspconfig

--      config = function()
--          require('mason').setup()  -- 初始化商店页面
--          require('mason-lspconfig').setup {
--              ensure_installed = { 'lua_ls', 'pyright', 'clangd'},
--          }
  }
  -- 结束
  -- 括号补全
  use {
      'windwp/nvim-autopairs',
      config = function ()
          require('nvim-autopairs').setup {
              disable_filetype = { 'TelescopPrompt', 'vim' },   -- 黑名单
              map_cr = true,                                    -- 回车自动补全括号
              map_bs = true,                                    -- Backspace 自动删除括号
          }
      end
  }

  -- 补全四件套：让 LSP 的提示能“弹出来”+“选中即插入”
  use {
      'hrsh7th/nvim-cmp',        -- 核心引擎（负责弹出菜单）
      'hrsh7th/cmp-nvim-lsp',    -- 数据源：把 LSP 返回的值传给 cmp
      'hrsh7th/cmp-buffer',      -- 备选源：当前缓冲区单词
      'hrsh7th/cmp-path',        --备选源：文件路径
      'L3MON4D3/LuaSnip',        -- 代码片段引擎（snippet）
      'saadparwaiz1/cmp_luasnip',-- 把 LuaSnip 的片段也塞进补全菜单
  }
  -- 结束

  if packer_bootstrap then
    require('packer').sync()
  end
end)

