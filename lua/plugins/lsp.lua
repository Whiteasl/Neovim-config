-- lsp-0.11.lua (neovim >= 0.11 专用)
-- -----------------------------------
-- 公共回调：每个服务器都会跑这段代码
require('mason').setup()
require('mason-lspconfig').setup { enable_installed = { 'lua_ls', 'clangd', 'pyright', 'codebook' } }
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
            pythonPath = '.venv/bin/python',
            venvPath = '.venv',
        },
    },
})

-- C/CPP
lsp.config('clangd', {
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = { 'clangd', '--background-index', '--clang-tidy' },
})

-- 启动
lsp.enable('lua_ls')
lsp.enable('clangd')
lsp.enable('pyright')
