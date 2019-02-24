# backup-benchmarks
Benchmarks for HashBackup and other backup programs.

- [backup-benchmarks](#backup-benchmarks)
- [General Info](#general-info)
  - [Resources](#resources)
  - [Backup Programs](#backup-programs)
  - [Guidelines](#guidelines)
  - [Datasets](#datasets)

# General Info

## Resources
- [Spreadsheet used for some things](https://docs.google.com/spreadsheets/d/1lhG4BlRDmIAaWCvJH8_Xeh_AYj9SynP9T_TGcmwTGcQ/edit#gid=2101403833)

## Backup Programs
| Name          | Link                                 |
|---------------|--------------------------------------|
| Restic        | https://restic.net/                  |
| Duplicity     | http://duplicity.nongnu.org/         |
| HashBackup    | http://hashbackup.com                |
| Duplicati 2.0 | https://www.duplicati.com/           |
| Duplicacy     | https://duplicacy.com/backblaze.html |

## Guidelines
- All backups should be run with logging and a memory/cpu profiler.
- All backups will be run on WSL on the same machine.
- Tests requiring Fusermount will be run in Hyper-V with Ubuntu 18.04.
- Make best effort to create apples-to-apples comparisons.

## Datasets
There will be multiple datasets that will be tested with to see how each program handles different use-cases.

- Git mirror to test backing up millions of small, easily dedupable/compressible data. A large number of repositories are downloaded and then updated before each backup to gather many changes.

- Virtual Machines: a Windows 10 VM will be used to test VM backups, installing many different programs and downloading data to generate changes.

