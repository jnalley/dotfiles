local vim = vim
local lspconfig = require "lspconfig"
local lspinstall = require "lspinstall"

lspinstall.setup()

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    signs = true,
    underline = true,
    update_in_insert = false,
    virtual_text = false,
  }
)

local settings = {
  efm = {
    init_options = {documentFormatting = true},
    root_dir = vim.loop.cwd,
    filetypes = {
      "python",
      "sh"
    },
    settings = {
      languages = {
        python = {
          {
            formatCommand = "black --fast -",
            formatStdin = true
          },
          {
            lintCommand = "flake8 --max-line-length 160 --format '%(path)s:%(row)d:%(col)d: %(code)s %(code)s %(text)s' --stdin-display-name ${INPUT} -",
            lintStdin = true,
            lintIgnoreExitCode = true,
            lintFormats = {"%f:%l:%c: %t%n%n%n %m"},
            lintSource = "flake8"
          },
          {
            formatCommand = "isort --stdout --profile black -",
            formatStdin = true
          },
        },
        sh = {
          {
            lintCommand = "shellcheck -f gcc -x -",
            lintStdin = true,
            lintFormats = {"%f:%l:%c: %trror: %m", "%f:%l:%c: %tarning: %m", "%f:%l:%c: %tote: %m"},
            lintSource = "shellcheck"
          },
          {
            formatCommand = "shfmt ${-i:tabWidth}"
          }
        }
      }
    }
  }
}

local manual  = { "efm" }
local servers = vim.list_extend(lspinstall.installed_servers(), manual)

for _, server in ipairs(servers) do
  if lspconfig[server] ~= nil then
    lspconfig[server].setup(settings[server] or {})
  else
    vim.notify(string.format("Unable to enable language server: %s", server), "ERROR")
  end
end
