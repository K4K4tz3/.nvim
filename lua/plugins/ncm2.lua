return {
  -- requirements
  { "roxma/nvim-yarp" },

  {
    "ncm2/ncm2",
    config = function()
      vim.opt.completeopt = { "noinsert", "menuone", "noselect" }

      vim.api.nvim_create_autocmd({'BufEnter'}, {
        pattern = {'*'},
        callback = function(ev)
          vim.call('ncm2#enable_for_buffer')
        end
      })
    end,
  },

  -- NOTE: you need to install completion sources to get completions. Check
  -- our wiki page for a list of sources: https://github.com/ncm2/ncm2/wiki
  { 'ncm2/ncm2-bufword' },
  { 'ncm2/ncm2-path' },
}
