# V1.0.1

* 2023-06-05: Add `--word-regexp` to grep in `init-tmux-project`. If a project has a part of another projects name, it thinks it is already running
    Example: Having projects `OETL_socket` and `OETL`, if project `OETL_socket` is active and `OETL` is to be initialized.
    `echo "OETL_socket" | grep "OETL"` has a match on `OETL` while it is not initialized yet.
* 2023-06-12: Add `.venv` to the exclusions for backup scripts. Python virtual environment is excluded from backups
* 2023-06-19: Add some `project_files` (`.clang-tidy`, `.eslintrc.yml`, `.pylint`)
* 2023-10-26: If project folder is encrypted with `fscrypt`, it needs to be unlocked before use. If forgotten projects will abort initialization.
* 2023-10-26: If session already exist, it listed every available session. This now is filtered to only show relevant sessions.
* 2023-12-22: Fixed `reload_project` (renamed from `reloadp`) reloading involves sourcing the projects `envrc` which can only be done in the projects folder itself (it has to do the finding the envrc scripts location if you are not in the project directory when using Docker or another environment. Doing it this way makes everything more reliable).
* 2023-12-22: Added creation of `.env/bin` and  `.env/lib` to creation of projects as from experience I always use it that way.
* 2023-12-22: Added `PROJECT_BIN` and `PROJECT_LIB` to the `exports.sh` template.
* 2023-12-22: Prepend `${PROJECT_PATH}/.env/bin` to `$PATH` environment variable to include scripts in `main.sh` template.
* 2024-01-11: Fixed `tml`, it only showed the first session instead of all of them
* 2024-01-11: Added more exclusions for the `__tar` command in `utils.sh`
