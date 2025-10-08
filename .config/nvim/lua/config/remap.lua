local opts = { noremap = true, silent = true }

-- Project wide grep
vim.keymap.set('n', '<leader>ps', function()
    local ok, input = pcall(vim.fn.input, "Grep > ")
    if not ok then return end
    input = vim.fn.shellescape(input)

    local rg = "rg"
    if vim.o.grepprg:sub(1, #rg) == rg then
        vim.cmd("grep " .. input .. " .")
    else
        vim.cmd("grep -rn " .. input .. " .")
    end
    vim.cmd('cw')
end)

vim.keymap.set('n', "<leader>t", "<cmd>Term<CR>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set("v", "p", [["_dp]])

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>f", "<cmd>Format<CR>")
vim.keymap.set("n", "<leader>F", "<cmd>Format<CR>")

vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>qr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>sw", [[<C-*>``]])
vim.keymap.set("n", "<leader>cs", "<cmd>noh<CR>")

-- navigate parent/child tags
vim.keymap.set("n", "]t", [[vatatov]])
vim.keymap.set("n", "[t", [[vatatv]])

-- Switch between last two buffers
vim.keymap.set('n', '<leader><leader>', '<Cmd>b#<CR>')

-- Resize with arrows
-- delta: 2 lines
vim.keymap.set('n', '<C-Up>', ':resize -2<CR>')
vim.keymap.set('n', '<C-Down>', ':resize +2<CR>')
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>')
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>')
