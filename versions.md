# V1.0.1

2023-06-05: Add `--word-regexp` to grep in `init-tmux-project`. If a project has a part of another projects name, it thinks it is already running
    Example: Having projects `OETL_socket` and `OETL`, if project `OETL_socket` is active and `OETL` is to be initialized.
    `echo "OETL_socket" | grep "OETL"` has a match on `OETL` while it is not initialized yet.
2023-06-12: Add `.venv` to the exclusions for backup scripts. Python virtual environment is excluded from backups
2023-06-19: Add some `project_files` (.clang-tidy, .eslintrc.yml, .pylint)
