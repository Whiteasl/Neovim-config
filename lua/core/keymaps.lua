vim.g.mapleader = " "

local keymap = vim.keymap

-- ------- 插入模式 ---------
keymap.set("i", "jk", "<ESC>")
keymap.set("i", "Jk", "<ESC>")
keymap.set("i", "jK", "<ESC>")
keymap.set("i", "JK", "<ESC>")

-- ------- 视觉模式 ---------
keymap.set("v", "J", ":m '>+1<CR>gv=gv'")
keymap.set("v", "K", ":m '>-2<CR>gv=gv'")

-- ------- 正常模式 ---------
-- 窗口
keymap.set("n", "<leader>sv", "<C-w>v")     -- 水平新增代码
keymap.set("n", "<leader>sh", "<C-w>s")     -- 垂直新增代码

-- 取消高亮
keymap.set("n", "<leader>nh", ":nohl<CR>")

-- 插件
keymap.set("n", "<leader>e", ":Neotree toggle<CR>", {silent = true })
require('neo-tree').setup {
    window = {
        mappings = {
            -- 文件/目录都用 o 打开
            ['o'] = 'open',
            -- 目录用 tap 展开/折叠
            ['tap'] = 'toggle_node',
            -- 禁用默认的 order-by，防止误触
            ['<C-o>'] = 'none',
            -- h 键设为返回上一级目录
            ['h'] = 'navigate_up',
            -- H 关闭 neo-tree
            ['H'] = 'close_window',
        },
    },
}
