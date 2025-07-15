return {
    {
        'nvim-orgmode/orgmode',
        lazy = false,
        ft = { 'org' },
        config = function()
            -- Setup orgmode
            require('orgmode').setup({
                org_agenda_files = '~/notes/**/*',
                org_default_notes_file = '~/notes/refile.org',
                win_split_mode = {'float', 0.8}
            })
        end,
    }
}
