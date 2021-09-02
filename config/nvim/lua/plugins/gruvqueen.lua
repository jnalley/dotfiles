local errormsg = {fg="red", bg="NONE", style="NONE"}

require("gruvqueen").setup{
  config = {
    transparent_background = true
  },
  base = {
    Folded = {fg="#008080", bg="NONE"},
    SpellBad = {fg="red"},
    VertSplit = {fg="#353535", bg="NONE", style="NONE"},
    Error = errormsg,
    ErrorMsg = errormsg,
    NvimInternalError = errormsg,
  }
}
