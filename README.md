# hashbackup-benchmarks
Benchmarks for HashBackup

Scripts are PowerShell targeting PS Core for Linux.

# Guidelines
- All backups should be run with logging and a memory/cpu profiler.
- All backups will be run on WSL on the same machine.
- Tests requiring Fusermount will be run in Hyper-V with Ubuntu 18.04.
- Make best effort to create apples-to-apples comparisons.
