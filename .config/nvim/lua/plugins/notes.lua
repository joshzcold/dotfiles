return {
    {
        'nvim-orgmode/orgmode',
        lazy = false,
        ft = { 'org' },
        opts = {
            org_agenda_files = '~/notes/**/*',
            org_default_notes_file = '~/notes/refile.org',
            win_split_mode = { 'float', 0.8 },
            org_startup_folded = "showeverything",
            mappings = {
                org_return_uses_meta_return = true
            },
        }
    }
}
