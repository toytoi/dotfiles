local M = {}

local query = vim.treesitter.query

local html_script_type_languages = {
   ["importmap"] = "json",
   ["module"] = "javascript",
   ["application/ecmascript"] = "javascript",
   ["text/ecmascript"] = "javascript",
}

local non_filetype_match_injection_language_aliases = {
   ex = "elixir",
   pl = "perl",
   sh = "bash",
   ts = "typescript",
   uxn = "uxntal",
}

local function first_node(match, capture_id)
   local capture = match[capture_id]
   if not capture then
      return nil
   end
   if capture.range then
      return capture
   end
   return capture[1]
end

local function get_parser_from_markdown_info_string(injection_alias)
   local match = vim.filetype.match { filename = "a." .. injection_alias }
   return match or non_filetype_match_injection_language_aliases[injection_alias] or injection_alias
end

function M.setup()
   local opts = { force = true }

   query.add_predicate("nth?", function(match, _pattern, _bufnr, pred)
      local node = first_node(match, pred[2])
      local n = tonumber(pred[3])
      if node and n and node:parent() and node:parent():named_child_count() > n then
         return node:parent():named_child(n) == node
      end
      return false
   end, opts)

   query.add_predicate("is?", function(match, _pattern, bufnr, pred)
      local node = first_node(match, pred[2])
      if not node then
         return true
      end

      local locals = require "nvim-treesitter.locals"
      local _, _, kind = locals.find_definition(node, bufnr)
      return vim.tbl_contains({ unpack(pred, 3) }, kind)
   end, opts)

   query.add_predicate("kind-eq?", function(match, _pattern, _bufnr, pred)
      local node = first_node(match, pred[2])
      if not node then
         return true
      end
      return vim.tbl_contains({ unpack(pred, 3) }, node:type())
   end, opts)

   query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
      local node = first_node(match, pred[2])
      if not node then
         return
      end

      local type_attr_value = vim.treesitter.get_node_text(node, bufnr)
      local configured = html_script_type_languages[type_attr_value]
      if configured then
         metadata["injection.language"] = configured
      else
         local parts = vim.split(type_attr_value, "/", {})
         metadata["injection.language"] = parts[#parts]
      end
   end, opts)

   query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
      local node = first_node(match, pred[2])
      if not node then
         return
      end

      local injection_alias = vim.treesitter.get_node_text(node, bufnr):lower()
      metadata["injection.language"] = get_parser_from_markdown_info_string(injection_alias)
   end, opts)

   query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
      local capture_id = pred[2]
      local node = first_node(match, capture_id)
      if not node then
         return
      end

      local node_metadata = metadata[capture_id]
      local text = vim.treesitter.get_node_text(node, bufnr, { metadata = node_metadata }) or ""
      metadata[capture_id] = node_metadata or {}
      metadata[capture_id].text = text:lower()
   end, opts)
end

return M
