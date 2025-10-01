-- lsp-0.11.lua (neovim >= 0.11 专用)
-- -----------------------------------
-- 公共回调：每个服务器都会跑这段代码
require('mason').setup()
require('mason-lspconfig').setup({ automatic_setup = false })
-- 定义公共能力
local capabilities =
require('cmp_nvim_lsp').default_capabilities()

-- 定义“公共按键回调”
local on_attach = function(_, bufnr)
    local buf = vim.lsp.buf
    local keymap = vim.keymap
    keymap.set('n', 'gd', buf.definition, { buffer = bufnr })   -- gd = go to definition,按 gd 光标跳到定义
    keymap.set('n', 'K', buf.hover, { buffer = bufnr})         -- K = 查看函数文档（hover） 
    keymap.set('n', 'gr', buf.references, { buffer = bufnr})    -- 列出所有引用位置
    keymap.set('n', '<leader>rn', buf.rename, { buffer = bufnr })   -- 重命名变量/函数，全项目同步改
    keymap.set('n', '<leader>ca', buf.code_action, { buffer = bufnr })  -- 代码动作（快速修复、提取函数等）
end

-- --------------------------------------
-- 注册服务器
--      语法：vim.lsp.config('服务器', {配置})

local lsp = vim.lsp

-- 定义 nvim_lsp 的来源
local cmp = require('cmp')
cmp.setup {
    mapping = cmp.mapping.preset.insert {
        ['<CR>'] = cmp.mapping.confirm { select = true },       -- 回车选中
        ['<C-Space>'] = cmp.mapping.complete(),                 -- 手动触发，注释则取消功能
        ['<TAP>'] = cmp.mapping.select_next_item(),             -- TAP 用来进行上下选择
    },
    sources = cmp.config.sources(
        { { name = 'nvim_lsp' }, { name = 'luasnip' } },        -- 优先使用 LSP
        { { name = 'buffer' }, {name = 'path' } }               -- 候补选项 （输入过的文本等）
    ),
}


-- Lua
lsp.config('lua_ls', {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { 'vim' } },
            workspace = { library = vim.api.nvim_get_runtime_file('',true) },
            telemetry = { enable = false },
        },
    },
})

-- Python
lsp.config('pyright', {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        python = {
            pythonPath = vim.fn.exepath('python3'),
        },
    },
})

-- C/CPP
lsp.config('clangd', {
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = { 'clangd', '--background-index', '--clang-tidy' },
    root_dir = vim.fs.root(0, { '.git', 'compile_commands.json', 'Makefile' }) or vim.fn.getcwd(),
})

-- 启动
lsp.enable('lua_ls')
lsp.enable('clangd')
lsp.enable('pyright')
