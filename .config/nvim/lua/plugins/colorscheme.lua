return {
  -- Nord colorscheme with transparent background
  {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.nord_disable_background = true
      vim.g.nord_italic = false
      require("nord").set()

      -- Force dark mode always
      vim.o.background = "dark"

      -- Main editor: fully transparent (terminal shows through)
      local transparent = { bg = "NONE" }
      local groups = {
        "Normal", "NormalNC", "SignColumn", "EndOfBuffer",
        "MsgArea", "WinSeparator",
        "LineNr", "CursorLineNr", "FoldColumn",
      }
      for _, group in ipairs(groups) do
        vim.api.nvim_set_hl(0, group, transparent)
      end

      -- Bottom bar (statusline, tabline, bufferline) - Nord dark
      local bar_bg = { bg = "#2e3440", fg = "#d8dee9" }
      local bar_groups = {
        "StatusLine", "StatusLineNC",
        "TabLine", "TabLineFill", "TabLineSel",
        "lualine_transitional", "WinBar", "WinBarNC",
      }
      for _, group in ipairs(bar_groups) do
        local existing = vim.api.nvim_get_hl(0, { name = group })
        vim.api.nvim_set_hl(0, group, vim.tbl_extend("force", existing, bar_bg))
      end

      -- Floating panels / popups: darker semi-transparent Nord background
      -- Uses Nord's darkest polar night color
      local panel_bg = { bg = "#242933" }
      local panel_groups = {
        "NormalFloat", "FloatBorder", "FloatTitle",
        "TelescopeNormal", "TelescopeBorder",
        "TelescopePromptNormal", "TelescopePromptBorder",
        "TelescopeResultsNormal", "TelescopeResultsBorder",
        "TelescopePreviewNormal", "TelescopePreviewBorder",
        "LazyNormal", "MasonNormal",
        "NeoTreeNormal", "NeoTreeNormalNC", "NeoTreeEndOfBuffer",
        "NoicePopup", "NoiceCmdlinePopup",
        "Pmenu", "PmenuSel", "PmenuSbar",
        "WhichKeyFloat",
      }
      for _, group in ipairs(panel_groups) do
        local existing = vim.api.nvim_get_hl(0, { name = group })
        vim.api.nvim_set_hl(0, group, vim.tbl_extend("force", existing, panel_bg))
      end

      -- Enable blending on floating windows for transparency effect
      vim.o.winblend = 15
      vim.o.pumblend = 15
    end,
  },

  -- Set Nord as the colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "nord",
    },
  },

  -- Force lualine to use nord theme
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = "nord",
      },
    },
  },
}
