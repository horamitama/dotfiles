return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = { enabled = false },
    servers = {
      -- ▼ TypeScript 設定 (vtsls推奨)
      -- LazyVimでは最近 tsserver (ts_ls) よりも vtsls が推奨されています（高速・高機能）
      vtsls = {
        settings = {
          typescript = {
            inlayHints = {
              parameterNames = { enabled = "literals" }, -- 関数の引数名を表示
              parameterTypes = { enabled = true }, -- 引数の型を表示
              variableTypes = { enabled = false },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              enumMemberValues = { enabled = true },
            },
          },
          gopls = {
            settings = {
              gopls = {
                -- 解析機能の強化
                analyses = {
                  unusedparams = true, -- 使っていない引数を警告
                  shadow = true, -- 変数のシャドーイングを警告
                },
                staticcheck = true, -- 高度な静的解析を有効化
                gofumpt = true, -- より厳格なフォーマットを使用
                usePlaceholders = true, -- 補完時にプレースホルダーを入れる
              },
            },
          },
        },
      },
    },
  },
}
