#!/bin/bash


# ------------------------- Цвета / Colors ------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
GRAY='\033[0;90m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m' # No Color

# ------------------------- Язык / Language -----------------------------------
LANG_CHOICE="ru"

# t <key> — возвращает перевод для текущего языка
t() {
    local key="$1"
    local ru en
    case "$key" in
        choose_lang)      ru="Выберите язык";                                   en="Choose your language" ;;
        lang_prompt)      ru="Ваш выбор (1-2)";                                 en="Your choice (1-2)" ;;
        title)            ru="Установка Remnawave Node + Selfsteal";            en="Remnawave Node + Selfsteal Installer" ;;
        select_component) ru="Выберите компонент для установки:";               en="Select a component to install:" ;;
        opt_node)         ru="Remnawave Node (Шаг 7)";                          en="Remnawave Node (Step 7)" ;;
        opt_selfsteal)    ru="Selfsteal SNI (Шаг 8)";                           en="Selfsteal SNI (Step 8)" ;;
        opt_both)         ru="Оба компонента";                                  en="Both components" ;;
        your_choice)      ru="Ваш выбор (1-3)";                                 en="Your choice (1-3)" ;;
        invalid_choice)   ru="Неверный выбор!";                                 en="Invalid choice!" ;;
        field_required)   ru="Это поле обязательно!";                           en="This field is required!" ;;
        step7)            ru="Шаг 7: Настройка Remnawave Node";                 en="Step 7: Remnawave Node setup" ;;
        step8)            ru="Шаг 8: Настройка Selfsteal (SNI)";                en="Step 8: Selfsteal (SNI) setup" ;;
        updating)         ru="Обновление системы и установка curl...";          en="Updating system and installing curl..." ;;
        update_err)       ru="Ошибка при обновлении системы";                   en="Failed to update the system" ;;
        update_ok)        ru="Система обновлена, curl установлен";              en="System updated, curl installed" ;;
        docker_install)   ru="Установка Docker...";                             en="Installing Docker..." ;;
        docker_err)       ru="Ошибка при установке Docker";                     en="Failed to install Docker" ;;
        docker_ok)        ru="Docker установлен";                               en="Docker installed" ;;
        mkdir_project)    ru="Создание директории проекта...";                  en="Creating project directory..." ;;
        dir_created)      ru="Директория создана:";                             en="Directory created:" ;;
        paste_compose)    ru="Теперь нужно вставить содержимое docker-compose.yml"; en="Now paste the contents of docker-compose.yml" ;;
        paste_hint)       ru="Вставьте весь контент и нажмите Ctrl+D на новой строке для завершения:"; en="Paste all content and press Ctrl+D on a new line to finish:" ;;
        compose_created)  ru="Файл docker-compose.yml создан";                  en="docker-compose.yml created" ;;
        run_node)         ru="Запустить контейнер Remnawave Node?";             en="Start the Remnawave Node container?" ;;
        starting)         ru="Запуск контейнера...";                            en="Starting the container..." ;;
        mkdir_work)       ru="Создание рабочей директории...";                  en="Creating working directory..." ;;
        creating_caddy)   ru="Создание Caddyfile...";                           en="Creating Caddyfile..." ;;
        caddy_created)    ru="Caddyfile создан";                                en="Caddyfile created" ;;
        env_setup)        ru="Настройка переменных окружения...";               en="Configuring environment variables..." ;;
        enter_domain)     ru="Введите ваш домен (например, steel.domain.com)";  en="Enter your domain (e.g. steel.domain.com)" ;;
        enter_port)       ru="Введите порт для Selfsteal";                      en="Enter the port for Selfsteal" ;;
        env_created)      ru="Файл .env создан с доменом:";                      en=".env created with domain:" ;;
        and_port)         ru="и портом:";                                       en="and port:" ;;
        creating_compose) ru="Создание docker-compose.yml...";                  en="Creating docker-compose.yml..." ;;
        run_selfsteal)    ru="Запустить Selfsteal контейнер?";                  en="Start the Selfsteal container?" ;;
        logs_hint)        ru="Логи контейнера (Ctrl+C для выхода):";            en="Container logs (Ctrl+C to exit):" ;;
        creating_page)    ru="Создание placeholder сайта...";                   en="Creating placeholder site..." ;;
        page_created)     ru="Placeholder сайт создан в";                       en="Placeholder site created at" ;;
        done)             ru="Установка завершена!";                            en="Installation complete!" ;;
        check_logs)       ru="Для проверки логов используйте:";                 en="To check logs use:" ;;
        node_label)       ru="Remnawave Node:";                                 en="Remnawave Node:" ;;
        selfsteal_label)  ru="Selfsteal:";                                      en="Selfsteal:" ;;
        html_label)       ru="HTML:";                                           en="HTML:" ;;
        domain_label)     ru="Домен:";                                          en="Domain:" ;;
        *)                ru="$key";                                            en="$key" ;;
    esac
    if [ "$LANG_CHOICE" = "ru" ]; then
        printf '%s' "$ru"
    else
        printf '%s' "$en"
    fi
}

# ------------------------- Вывод / Output helpers ----------------------------
print_success() { echo -e "  ${GREEN}✓${NC} $1"; }
print_error()   { echo -e "  ${RED}✗${NC} ${RED}$1${NC}"; }
print_info()    { echo -e "  ${CYAN}ℹ${NC} $1"; }
print_warning() { echo -e "  ${YELLOW}⚠${NC} ${YELLOW}$1${NC}"; }
print_step()    { echo -e "\n${BOLD}${MAGENTA}❯ $1${NC}\n"; }

# Рамка / boxed banner
print_banner() {
    local text="$1"
    local width=62
    local pad=$(( (width - ${#text}) / 2 ))
    echo -e "${CYAN}"
    echo    "  ╔══════════════════════════════════════════════════════════════╗"
    printf  "  ║%*s%s%*s║\n" $pad "" "$text" $(( width - pad - ${#text} )) ""
    echo    "  ╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_divider() {
    echo -e "  ${GRAY}────────────────────────────────────────────────────────────${NC}"
}

# ------------------------- Ввод / Input helpers ------------------------------
# Читаем из /dev/tty для работы с curl | bash
ask_input() {
    local prompt="$1"
    local var_name="$2"
    local default="$3"

    if [ -n "$default" ]; then
        echo -ne "  ${ORANGE}❯${NC} ${prompt} ${DIM}[${default}]${NC}: " > /dev/tty
        read -r input < /dev/tty
        input=${input:-$default}
    else
        echo -ne "  ${ORANGE}❯${NC} ${prompt}: " > /dev/tty
        read -r input < /dev/tty
        while [ -z "$input" ]; do
            print_error "$(t field_required)"
            echo -ne "  ${ORANGE}❯${NC} ${prompt}: " > /dev/tty
            read -r input < /dev/tty
        done
    fi

    eval "$var_name='$input'"
}

ask_confirm() {
    local prompt="$1"
    echo -ne "  ${ORANGE}❯${NC} ${prompt} ${DIM}(y/n)${NC}: " > /dev/tty
    read -r confirm < /dev/tty
    [[ "$confirm" =~ ^[Yy]$ ]]
}

# =============================================================================
#  Выбор языка / Language selection
# =============================================================================
clear 2>/dev/null
echo -e "${CYAN}"
echo "  ╔══════════════════════════════════════════════════════════════╗"
echo "  ║            Remnawave Node + Selfsteal Installer              ║"
echo "  ╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

echo -e "  ${BOLD}Choose your language / Выберите язык:${NC}"
echo -e "    ${CYAN}1)${NC} 🇬🇧 English"
echo -e "    ${CYAN}2)${NC} 🇷🇺 Русский"
echo -ne "  ${ORANGE}❯${NC} Your choice (1-2): " > /dev/tty
read -r lang_input < /dev/tty
case $lang_input in
    2) LANG_CHOICE="ru" ;;
    *) LANG_CHOICE="en" ;;
esac
echo ""

# =============================================================================
#  Баннер / Banner
# =============================================================================
print_banner "$(t title)"

# ------------------------- Выбор компонента ----------------------------------
echo -e "  ${BOLD}$(t select_component)${NC}"
echo -e "    ${CYAN}1)${NC} $(t opt_node)"
echo -e "    ${CYAN}2)${NC} $(t opt_selfsteal)"
echo -e "    ${CYAN}3)${NC} $(t opt_both)"
echo -ne "  ${ORANGE}❯${NC} $(t your_choice): " > /dev/tty
read -r install_choice < /dev/tty

install_node=false
install_selfsteal=false

case $install_choice in
    1) install_node=true ;;
    2) install_selfsteal=true ;;
    3) install_node=true; install_selfsteal=true ;;
    *) print_error "$(t invalid_choice)"; exit 1 ;;
esac

echo ""

# =============================================================================
#  STEP 7: Remnawave Node
# =============================================================================
if [ "$install_node" = true ]; then
    print_step "$(t step7)"

    # Обновление системы
    print_info "$(t updating)"
    if ! apt update > /dev/null 2>&1 && apt install -y curl > /dev/null 2>&1; then
        print_error "$(t update_err)"
        exit 1
    fi
    print_success "$(t update_ok)"
    echo ""

    # Установка Docker
    print_info "$(t docker_install)"
    if ! curl -fsSL https://get.docker.com | sh > /dev/null 2>&1; then
        print_error "$(t docker_err)"
        exit 1
    fi
    print_success "$(t docker_ok)"
    echo ""

    # Создание директории проекта
    print_info "$(t mkdir_project)"
    mkdir -p /opt/remnanode && cd /opt/remnanode
    print_success "$(t dir_created) /opt/remnanode"
    echo ""

    # Запрос содержимого docker-compose.yml
    print_info "$(t paste_compose)"
    print_info "$(t paste_hint)"
    echo ""

    COMPOSE_CONTENT=""
    while IFS= read -r line; do
        COMPOSE_CONTENT+="$line"$'\n'
    done < /dev/tty

    # Сохранение docker-compose.yml
    echo -e "$COMPOSE_CONTENT" > docker-compose.yml
    print_success "$(t compose_created)"
    echo ""

    # Запуск контейнера
    if ask_confirm "$(t run_node)"; then
        print_info "$(t starting)"
        docker compose up -d && docker compose logs -f
    fi
    echo ""
fi

# =============================================================================
#  STEP 8: Selfsteal (SNI) Setup
# =============================================================================
if [ "$install_selfsteal" = true ]; then
    print_step "$(t step8)"

    # Создание директории
    print_info "$(t mkdir_work)"
    mkdir -p /opt/selfsteel && cd /opt/selfsteel
    print_success "$(t dir_created) /opt/selfsteel"
    echo ""

    # Создание Caddyfile
    print_info "$(t creating_caddy)"
    cat > Caddyfile << 'EOF'
{
    https_port {$SELF_STEAL_PORT}
    default_bind 127.0.0.1
    servers {
        listener_wrappers {
            proxy_protocol {
                allow 127.0.0.1/32
            }
            tls
        }
    }
    auto_https disable_redirects
}

http://{$SELF_STEAL_DOMAIN} {
    bind 0.0.0.0
    redir https://{$SELF_STEAL_DOMAIN}{uri} permanent
}

https://{$SELF_STEAL_DOMAIN} {
    root * /var/www/html
    try_files {path} /index.html
    file_server

}


:{$SELF_STEAL_PORT} {
    tls internal
    respond 204
}

:80 {
    bind 0.0.0.0
    respond 204
}
EOF
    print_success "$(t caddy_created)"
    echo ""

    # Настройка переменных окружения
    print_info "$(t env_setup)"
    ask_input "$(t enter_domain)" DOMAIN
    ask_input "$(t enter_port)" PORT "9443"

    cat > .env << EOF
SELF_STEAL_DOMAIN=$DOMAIN
SELF_STEAL_PORT=$PORT
EOF
    print_success "$(t env_created) $DOMAIN $(t and_port) $PORT"
    echo ""

    # Создание docker-compose.yml
    print_info "$(t creating_compose)"
    cat > docker-compose.yml << 'EOF'
services:
  caddy:
    image: caddy:latest
    container_name: caddy-remnawave
    restart: unless-stopped
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile
      - ../html:/var/www/html
      - ./logs:/var/log/caddy
      - caddy_data_selfsteal:/data
      - caddy_config_selfsteal:/config
    env_file:
      - .env
    network_mode: "host"

volumes:
  caddy_data_selfsteal:
  caddy_config_selfsteal:
EOF
    print_success "$(t compose_created)"
    echo ""

    # Запуск и проверка
    if ask_confirm "$(t run_selfsteal)"; then
        print_info "$(t starting)"
        docker compose up -d
        sleep 2
        print_info "$(t logs_hint)"
        docker compose logs -f -t
    fi
    echo ""

    # Создание placeholder сайта
    print_info "$(t creating_page)"
    mkdir -p /opt/html
    printf '%s\n' '<!doctype html><meta charset="utf-8"><title>Selfsteal</title><h1>It works.</h1>' \
      > /opt/html/index.html
    print_success "$(t page_created) /opt/html/index.html"
    echo ""
fi

# =============================================================================
#  Завершение / Completion
# =============================================================================
print_divider
print_banner "$(t done)"

if [ "$install_node" = true ]; then
    echo -e "  ${GREEN}●${NC} $(t node_label) ${BOLD}/opt/remnanode${NC}"
fi

if [ "$install_selfsteal" = true ]; then
    echo -e "  ${GREEN}●${NC} $(t selfsteal_label) ${BOLD}/opt/selfsteel${NC}"
    echo -e "  ${GREEN}●${NC} $(t html_label) ${BOLD}/opt/html${NC}"
    echo -e "  ${GREEN}●${NC} $(t domain_label) ${BOLD}$DOMAIN:$PORT${NC}"
fi

echo ""
print_info "$(t check_logs)"
if [ "$install_node" = true ]; then
    echo -e "    ${GRAY}cd /opt/remnanode && docker compose logs -f${NC}"
fi
if [ "$install_selfsteal" = true ]; then
    echo -e "    ${GRAY}cd /opt/selfsteel && docker compose logs -f${NC}"
fi
echo ""
