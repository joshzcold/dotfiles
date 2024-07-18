vim.api.nvim_create_user_command("BasedPyRightChangeTypeCheckingMode", function(opts)
  local clients = vim.lsp.get_clients({
    bufnr = vim.api.nvim_get_current_buf(),
    name = "basedpyright",
  })
  for _, client in ipairs(clients) do
    client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
      basedpyright = {
        analysis = {
          typeCheckingMode = opts.args,
        },
      },
    })
    print(vim.inspect(client.config.settings))
    client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
  end
end, {
  nargs = 1,
  count = 1,
  complete = function()
    return { "off", "basic", "standard", "strict", "all" }
  end,
})

local function swenv_set_venv(venv_path)
  if venv_path then
    local swenv_api = require("swenv.api")
    local current_venv_name = nil
    local current_venv = swenv_api.get_current_venv()
    if current_venv then
      current_venv_name = current_venv.name
    end
    if venv_path ~= current_venv_name then
      swenv_api.set_venv(venv_path)
    end
  end
end

local function search_up(dir_or_file)
  local found = nil
  local dir_to_check = nil
  local dir_template = "%:p:h"
  while not found and dir_to_check ~= "/" do
    dir_to_check = vim.fn.expand(dir_template)
    local check_path = dir_to_check .. "/" .. dir_or_file
    if vim.fn.isdirectory(check_path) == 1 or vim.fn.filereadable(check_path) == 1 then
      found = dir_to_check .. "/" .. dir_or_file
    else
      dir_template = dir_template .. ":h"
    end
  end
  return found
end

local function pdm_sync(pdm_lock_path)
  local Job = require("plenary.job")
  vim.notify("Starting pdm sync at: " .. pdm_lock_path, vim.log.levels.INFO)
  local dir_name = vim.fs.dirname(pdm_lock_path)
  Job:new({
    command = "pdm",
    args = { "sync" },
    cwd = dir_name,
    on_exit = function(j, return_val)
      vim.schedule(function()
        if j.code ~= 0 then
          vim.notify(vim.inspect(j._stderr_results), vim.log.levels.ERROR)
        else
          local venv_path = dir_name .. "/" .. ".venv"
          swenv_set_venv(venv_path)
          vim.notify("Set venv: " .. venv_path, vim.log.levels.INFO)
        end
      end)
    end,
  }):start()
end

local function pip_install_with_venv(requirements_path)
  local Job = require("plenary.job")
  local dir_name = vim.fs.dirname(requirements_path)
  local venv_path = dir_name .. "/" .. ".venv"
  vim.notify("Starting pip install at: " .. requirements_path .. " in venv: " .. venv_path, vim.log.levels.INFO)
  local python_app = "python3"
  if vim.fn.executable(python_app) ~= 1 then
    python_app = "python"
  end
  print(python_app)
  Job:new({
    command = python_app,
    args = { "-m", "venv", venv_path },
    cwd = dir_name,
    on_exit = function(j, return_val)
      vim.schedule(function()
        if j.code ~= 0 then
          vim.notify(vim.inspect(j._stderr_results .. j._stdout_results), vim.log.levels.ERROR)
        else
          local pip_path = venv_path .. "/" .. "bin/pip"
          local install_args = { "install", "-r", requirements_path }
          if requirements_path == "pyproject.toml" then
            install_args = { "install", "." }
          end
          Job:new({
            command = pip_path,
            args = install_args,
            cwd = dir_name,
            on_exit = function(k, return_val)
              vim.schedule(function()
                if k.code ~= 0 then
                  vim.notify(vim.inspect(k._stderr_results), vim.log.levels.ERROR)
                else
                  swenv_set_venv(venv_path)
                  vim.notify("Set venv: " .. venv_path, vim.log.levels.INFO)
                end
              end)
            end,
          }):start()
        end
      end)
    end,
  }):start()
end

local function auto_set_python_venv(nested_opts)
  if vim.bo[nested_opts.buf].filetype == "python" then
    local venv_path = search_up(".venv")
    local pdm_lock_path = search_up("pdm.lock")
    local requirements_txt = search_up("requirements.txt")
    local dev_requirements_txt = search_up("dev-requirements.txt")
    local pyproject_toml = search_up("pyproject.toml")

    if venv_path then
      swenv_set_venv(venv_path)
    end
    if pdm_lock_path then
      pdm_sync(pdm_lock_path)
      return
    end
    if dev_requirements_txt then
      pip_install_with_venv(dev_requirements_txt)
    elseif requirements_txt then
      pip_install_with_venv(requirements_txt)
    elseif pyproject_toml then
      pip_install_with_venv(pyproject_toml)
    end
  end
end

return {
  {
    "AckslD/swenv.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- Should return a list of tables with a `name` and a `path` entry each.
      -- Gets the argument `venvs_path` set below.
      -- By default just lists the entries in `venvs_path`.
      get_venvs = function(venvs_path)
        return require("swenv.api").get_venvs(venvs_path)
      end,
      -- Path passed to `get_venvs`.
      venvs_path = vim.fn.expand("~/.virtualenvs"),
      -- Something to do after setting an environment, for example call vim.cmd.LspRestart
      -- post_set_venv = nil,
      post_set_venv = function()
        local client = vim.lsp.get_clients({ name = "basedpyright" })[1]
        if not client then
          return
        end
        local venv = require("swenv.api").get_current_venv()
        if not venv then
          return
        end
        local venv_python = venv.path .. "/bin/python"
        if client.settings then
          client.settings = vim.tbl_deep_extend("force", client.settings, { python = { pythonPath = venv_python } })
        else
          client.config.settings =
              vim.tbl_deep_extend("force", client.config.settings, { python = { pythonPath = venv_python } })
        end
        client.notify("workspace/didChangeConfiguration", { settings = nil })
      end,
    },
    config = function(_, opts)
      require("swenv").setup(opts)
      vim.api.nvim_create_autocmd({ "BufEnter" }, {
        callback = auto_set_python_venv,
        group = vim.api.nvim_create_augroup("python_venv", { clear = true }),
      })
    end,
  },
}
