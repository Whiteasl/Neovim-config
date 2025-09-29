-- 公共回调：每个服务器启动时都会跑这段代码
require('mason').setup()
require('mason-lspconfig').setup { ensure_installed = { 'lua_ls' } }
local on_attach = function(_, bufnr)
    -- bufnr = 当前缓冲区编号
    local buf = vim.lsp.buf     -- 官方 API 快捷变量
    
    -- 以下代码功能：把 LSP 功能绑定到按键上
    local keymap = vim.keymap
    keymap.set('n', 'gd', buf.definition, { buffer = bufnr} )       -- gd = go to definition,按 gd 光标跳到定义
    keymap.set('n', '<leader>rn', buf.rename, { buffer = bufnr })   -- 重命名变量/函数，全项目同步改 
    keymap.set('n', 'K', buf.hover, { buffer = bufnr })             -- K = 查看函数文档（hover）
    keymap.set('n', 'gr', buf.references, { buffer = bufnr })       -- 列出所有引用位置
    keymap.set('n', '<leader>ca', buf.code_action, { buffer = bufnr})   --代码动作（快速修复、提取函数等）
end

local cmp = require('cmp')
cmp.setup {
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)        -- 选中补全项后把片段展开

        end
    },
    mapping = cmp.mapping.preset.insert {
        ['<CR>'] = cmp.mapping.confirm { select = true },   -- 回车即插入
    },
    sources = cmp.config.sources(
        { { name = 'nvim_lsp' }, { name = 'luasnip' } },    -- 优先 LSP + 片段
        { { name = 'buffer'   }, { name = 'path'   } }     -- 次优先 缓冲区 + 路径
    ), 
}

-- 敲字 → cmp 同时问多个 source →
-- nvim_lsp 返回函数列表 → cmp 弹菜单 →
-- 回车 → LuaSnip 把片段补全 → 插入文本

-- 批量启动服务器
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local servers = { 'lua_ls', 'pyright', 'clangd' }
for _, srv in ipairs(servers) do
    require('lspconfig')[srv].setup {
        on_attach = on_attach,              -- 公用按键
        capabilities = capabilities,        -- 补全能力
        -- 下面可以放单独设置，后面想到再加
    }
end
