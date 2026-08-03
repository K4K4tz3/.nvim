local ls = require("luasnip")

local snippet = ls.snippet
local text = ls.text_node
local insert = ls.insert_node

return {
  snippet("class", {
    text("class "),
    insert(1, "ClassName"),
    text({ " {", "public:", " " }),
    insert(2),
    text({ "", "};" }),
    insert(0),
  }),
  snippet("sgetter", {
    text("void set_"),
    insert(1, "type"),
    text("(const "),
    insert(2, "Type"),
    text(" &a_"),
    rep(1),
    text(") { m_"),
    rep(1),
    text(" = a_"),
    rep(1),
    text({ "; };", "" }),
    rep(2),
    text(" get_"),
    rep(1),
    text("() const { return m_"),
    rep(1),
    text("; };"),
    insert(0),
  }),
}
