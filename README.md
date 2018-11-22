# auto-inhibit

**auto-inhibit** manages symbolic links to itself named after programs to be run
with an inhibition lock via **systemd-inhibit**.

## Usage

```
usage: auto-inhibit [options] [command]

options:
  -h        Show help message
  -d DIR    Operate on DIR

commands:
  list      List symlinks
  generate  Create symlinks
  check     Check symlinks
  remove    Remove symlinks
  status    List active inhibitors
```

## Configuration

Options in the configuration file _/etc/auto-inhibit.conf_ are passed directly
as flags to **systemd-inhibit**.

Given _example.conf_:

```
[aria2c]
why=Download in progress
```

Running `aria2c` via the symlink will result in:

`systemd-inhibit --why='Download in progress' aria2c`

## License

This project is licensed under the MIT License (see [LICENSE](LICENSE)).
