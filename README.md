# Kbot
Telegram Bot for DevOps101 course (week 2 module 2)

Version: 1.0.2

https://t.me/dmytroa_kbot_bot

Commands:
- `hello` – show current version;

## Examples:
Input:
```text
/start hello
```
Output:
```text
Hello I'm Kbot v1.0.2
```

## Dependencies:
- [Git](https://git-scm.com/)
- [GoLang](https://golang.org/)

## Build & Run
```bash
go build -ldflags "-X="github.com/brokerUA/kbot/cmd.appVersion=VERSION & ./kbot start
```
Where **VERSION** is current version, ex: v1.0.2.
