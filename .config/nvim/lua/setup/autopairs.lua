require('nvim-autopairs').setup{}
local npairs = require'nvim-autopairs'
local Rule   = require'nvim-autopairs.rule'
local cond = require('nvim-autopairs.conds')

require('nvim-autopairs').remove_rule('"')
require('nvim-autopairs').remove_rule("'")
require('nvim-autopairs').remove_rule("`")

npairs.add_rules {
    Rule("'", "'")
        :with_pair(cond.not_before_regex_check("%S"))
        :with_pair(cond.not_after_regex_check("%S")),
    Rule('"', '"')
        :with_pair(cond.not_before_regex_check("%S"))
        :with_pair(cond.not_after_regex_check("%S")),
  Rule(' ', ' ')
    :with_pair(function (opts)
      local pair = opts.line:sub(opts.col - 1, opts.col)
      return vim.tbl_contains({ '()', '[]', '{}' }, pair)
    end),
  Rule('( ', ' )')
      :with_pair(function() return false end)
      :with_move(function(opts)
          return opts.prev_char:match('.%)') ~= nil
      end)
      :use_key(')'),
  Rule('{ ', ' }')
      :with_pair(function() return false end)
      :with_move(function(opts)
          return opts.prev_char:match('.%}') ~= nil
      end)
      :use_key('}'),
  Rule('[ ', ' ]')
      :with_pair(function() return false end)
      :with_move(function(opts)
          return opts.prev_char:match('.%]') ~= nil
      end)
      :use_key(']')
}
