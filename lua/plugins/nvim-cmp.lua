-- PLUGIN: The 'nvim-cmp' plugin provide auto-completion support for many programming and markup languages.
return {
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      "L3MON4D3/LuaSnip",
    },
    config = function()
      require('cmp').setup()
      -- nvim-cmp setup
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = {
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'path' },
          { name = 'luasnip' },
        },
      })
    end,
  },
  {
    'hrsh7th/cmp-nvim-lsp', -- LSP source for cmp
    after = 'nvim-cmp',     -- Load after nvim-cmp
  },
  {
    'hrsh7th/cmp-buffer', -- Buffer source for cmp
    after = 'nvim-cmp',
  },
  {
    'hrsh7th/cmp-path', -- Path source for cmp
    after = 'nvim-cmp',
  },
  {
    'saadparwaiz1/cmp_luasnip', -- Luasnip source for cmp
    after = 'nvim-cmp',
  },
  {
    'L3MON4D3/LuaSnip', -- LuaSnip for snippets
    after = 'nvim-cmp',
  },
}
