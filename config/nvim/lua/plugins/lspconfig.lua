local vim = vim
local lspconfig = require "lspconfig"

vim.lsp.handlers["textDocument/publishDiagnostics"] =
  vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  {
    signs = true,
    underline = true,
    update_in_insert = false,
    virtual_text = false
  }
)

lspconfig["efm"].setup{
  init_options = {documentFormatting = true},
  root_dir = vim.loop.cwd,
  filetypes = {
    "python",
    "sh",
    "yaml"
  },
  settings = {
    languages = {
      python = {
        {
          formatCommand = "black --line-length 79 -",
          formatStdin = true
        },
        {
          lintCommand = "flake8 --ignore=E203,E266,E501,W503 --per-file-ignores=__init__.py:F401 --max-line-length 79 --format '%(path)s:%(row)d:%(col)d: %(code)s %(code)s %(text)s' --stdin-display-name ${INPUT} -",
          lintStdin = true,
          lintIgnoreExitCode = true,
          lintFormats = {"%f:%l:%c: %t%n%n%n %m"},
          lintSource = "flake8"
        },
        {
          formatCommand = "isort --stdout --profile black -",
          formatStdin = true
        }
      },
      sh = {
        {
          lintCommand = "shellcheck -f gcc -x -",
          lintStdin = true,
          lintFormats = {
            "%f:%l:%c: %trror: %m",
            "%f:%l:%c: %tarning: %m",
            "%f:%l:%c: %tote: %m"
          },
          lintSource = "shellcheck"
        },
        {
          formatCommand = "shfmt -ci -i 2 -s -bn",
          formatStdin = true
        }
      },
      yaml = {
        {
          lintCommand = "yamllint -f parsable -",
          lintStdin = true
        }
      }
    }
  }
}

lspconfig["jedi_language_server"].setup{}
lspconfig["solargraph"].setup{}
lspconfig["bashls"].setup{}
