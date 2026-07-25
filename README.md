<div align="center">

# Remnawave Node Script

Интерактивный установщик Remnawave Node + Selfsteal (SNI)

<br>

[🇷🇺 Русский](#русский) &nbsp;&nbsp;|&nbsp;&nbsp; [🇬🇧 English](#english)

</div>

---

<br>

## Русский

### Что это

Bash-скрипт для быстрой установки **Remnawave Node** и **Selfsteal (SNI)** на сервер. Поддерживает два языка, красивый интерфейс с цветным выводом.

### Установка

Одна команда:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/reactuss/remawave-node-script/main/remnawave_install.sh)
```

Или скачать вручную:

```bash
curl -fsSL -O https://raw.githubusercontent.com/reactuss/remawave-node-script/main/remnawave_install.sh
chmod +x remnawave_install.sh
./remnawave_install.sh
```

> Запускать от `root` или через `sudo`.

### Что устанавливает

| Вариант | Компонент | Путь |
|---------|-----------|------|
| 1 | Remnawave Node | `/opt/remnanode` |
| 2 | Selfsteal SNI | `/opt/selfsteel` |
| 3 | Оба | `/opt/remnanode` + `/opt/selfsteel` |

### Шаги

1. Выберите язык — **1** English / **2** Русский
2. Выберите компонент для установки
3. Для **Node** — вставьте `docker-compose.yml`, затем `Ctrl+D`
4. Для **Selfsteal** — введите домен и порт (по умолчанию `9443`)
5. Подтвердите запуск контейнера

---

<br>

## English


### What is this

A Bash script for quick setup of **Remnawave Node** and **Selfsteal (SNI)** on a server. Bilingual, with a clean colored interface.

### Install

One command:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/reactuss/remawave-node-script/main/remnawave_install.sh)
```

Or manually:

```bash
curl -fsSL -O https://raw.githubusercontent.com/reactuss/remawave-node-script/main/remnawave_install.sh
chmod +x remnawave_install.sh
./remnawave_install.sh
```

> Run as `root` or with `sudo`.

### What it installs

| Option | Component | Path |
|--------|-----------|------|
| 1 | Remnawave Node | `/opt/remnanode` |
| 2 | Selfsteal SNI | `/opt/selfsteel` |
| 3 | Both | `/opt/remnanode` + `/opt/selfsteel` |

### Steps

1. Choose language — **1** English / **2** Русский
2. Select what to install
3. For **Node** — paste your `docker-compose.yml`, finish with `Ctrl+D`
4. For **Selfsteal** — enter your domain and port (default `9443`)
5. Confirm container startup when prompted
