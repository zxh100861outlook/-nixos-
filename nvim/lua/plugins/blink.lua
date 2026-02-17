-- ~/.config/nvim/lua/plugins/blink.lua
return {
  "saghen/blink.cmp",
  optional = true,

  opts = {
    completion = {
      trigger = {
        show_on_keyword = true,
        show_on_trigger_characters = true,
      },
      keyword = { range = "full" },
      list = {
        selection = { preselect = false },  -- 只这一行控制不预选
      },
    },

    keymap = {
      preset = 'default',  -- 别改成 enter/super-tab，避免冲突

      -- 不要清空 <CR>/<Tab>，改用 abort/cancel 行为
      ["<CR>"]  = { "accept", "fallback" },  -- 保留 accept，但 preselect=false 后 Enter 基本不插入
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },

      -- 手动确认 + 取消
      ["<C-y>"] = { "select_and_accept" },
      ["<C-e>"] = { "cancel" },
      ["<C-Space>"] = { "show", "fallback" },
    },

    -- 重要：禁用 Rust fuzzy（用 Lua 版，避免 segfault/crash）
    fuzzy = { implementation = "lua" },
  },
}