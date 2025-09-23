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
            ui = {
                folds = {
                    colored = true
                }
            },
            notifications = {
                enabled = false,
                cron_enabled = true,
                repeater_reminder_time = false,
                deadline_warning_reminder_time = false,
                reminder_time = 10,
                deadline_reminder = true,
                scheduled_reminder = true,
                notifier = function(tasks)
                    local result = {}
                    for _, task in ipairs(tasks) do
                        require('orgmode.utils').concat(result, {
                            string.format('# %s (%s)', task.category, task.humanized_duration),
                            string.format('%s %s %s', string.rep('*', task.level), task.todo, task.title),
                            string.format('%s: <%s>', task.type, task.time:to_string())
                        })
                    end

                    if not vim.tbl_isempty(result) then
                        require('orgmode.notifications.notification_popup'):new({ content = result })
                    end

                    -- Example: if you use Snacks, you can do something like this (THis is not implemented)
                    Snacks.notifier.notify(table.concat(result, '\n'), vim.log.levels.INFO, {
                        title = 'Orgmode',
                        ft = 'org'
                    })
                end,
                cron_notifier = function(tasks)
                    vim.print(tasks)
                    for _, task in ipairs(tasks) do
                        local title = string.format('%s (%s)', task.category, task.humanized_duration)
                        local subtitle = string.format('%s %s %s', string.rep('*', task.level), task.todo, task.title)
                        local date = string.format('%s: %s', task.type, task.time:to_string())

                        -- Linux
                        if vim.fn.executable('notify-send') == 1 then
                            vim.system({
                                'notify-send',
                                '--icon=/home/joshua/.local/share/nvim/lazy/orgmode/assets/nvim-orgmode-small.png',
                                '--app-name=orgmode',
                                title,
                                string.format('%s\n%s', subtitle, date),
                            })
                        end

                        -- MacOS
                        if vim.fn.executable('terminal-notifier') == 1 then
                            vim.system({ 'terminal-notifier', '-title', title, '-subtitle', subtitle, '-message', date })
                        end
                    end
                end
            },
        }
    }
}
