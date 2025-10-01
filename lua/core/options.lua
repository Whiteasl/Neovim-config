local opt = vim.opt

-- 行号
opt.relativenumber = true
opt.number = true

-- 缩进
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- 段落
opt.wrap = true
opt.linebreak = true
opt.breakindent = true
opt.showbreak = '↪ '

-- 光标行
opt.cursorline = true

-- 鼠标
opt.mouse:append("a")

-- 系统剪贴板
opt.clipboard:remove{ "unnamedplus" }

-- 默认新窗口在右边和下边
opt.splitright = true
opt.splitbelow = true

-- 搜索（是否区分大小写）
opt.ignorecase = false      -- 区分大小写

-- 外观
opt.termguicolors = true
opt.signcolumn = 'yes'
vim.cmd[[colorscheme tokyonight-night]]     -- 主题可选：night,day,moon,storm

-- 插件
--require('lspconfig').lua_ls.setup {
--    on_attach = on_attach,
--    capabilities = capabilities,
--}
