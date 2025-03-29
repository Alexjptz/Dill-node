#!/bin/bash

tput reset
tput civis

show_orange() {
    echo -e "\e[33m$1\e[0m"
}

show_blue() {
    echo -e "\e[34m$1\e[0m"
}

show_green() {
    echo -e "\e[32m$1\e[0m"
    echo
}

show_red() {
    echo -e "\e[31m$1\e[0m"
}

exit_script() {
    show_red "Скрипт остановлен (Script stopped)"
        echo
        exit 0
}

incorrect_option () {
    echo
    show_red "Неверная опция. Пожалуйста, выберите из тех, что есть."
    echo
    show_red "Invalid option. Please choose from the available options."
    echo
}

process_notification() {
    local message="$1"
    show_orange "$message"
    sleep 1 && echo
}

run_commands() {
    local commands="$*"

    if eval "$commands"; then
        sleep 1
        echo
        show_green "Успешно (Success)"
        echo
    else
        sleep 1
        echo
        show_red "Ошибка (Fail)"
        echo
    fi
}

print_logo () {
    echo
    show_orange "  _______   __   __       __ " && sleep 0.1
    show_orange " |       \ |  | |  |     |  | " && sleep 0.1
    show_orange " |  .--.  ||  | |  |     |  | " && sleep 0.1
    show_orange " |  |  |  ||  | |  |     |  | " && sleep 0.1
    show_orange " |  '--'  ||  | |   ----.|   ----. " && sleep 0.1
    show_orange " |_______/ |__| |_______||_______| " && sleep 0.1
    echo
    sleep 1
}

while true; do
    print_logo
    show_green "------ MAIN MENU ------ "
    echo "1. Установка (Installation)"
    echo "2. Управление (Operational menu)"
    echo "3. Логи (Logs)"
    echo "4. Удаление (Delete)"
    echo "5. Выход (Exit)"
    echo
    read -p "Выберите опцию (Select option): " option

    case $option in
        1)
            # INSTALLATION
            process_notification "Начинаем подготовку (Starting preparation)..."
            run_commands "cd $HOME && sudo apt update && sudo apt upgrade -y && apt install unzip screen nano mc"
            echo

            process_notification "Установка (Installation)..."
            cd $HOME
            curl -sO https://raw.githubusercontent.com/DillLabs/launch-dill-node/main/dill.sh
            chmod +x dill.sh
            ./dill.sh
            rm -rv $HOME/dill.sh

            show_green "--- УСТАНОВКА ЗАВЕРШЕНА. INSTALLATION COMPLETED ---"
            ;;
        2)
            # OPERATIONAL MENU
            echo
            while true; do
                show_green "------ OPERATIONAL MENU ------ "
                echo "1. Зaпустить (Start)"
                echo "2. Остановить (Stop)"
                echo "3. Посмотреть (show) PubKey"
                echo "4. Выход (Exit)"
                echo
                read -p "Выберите опцию (Select option): " option
                echo
                cd $HOME/dill
                case $option in
                    1)
                        # START
                        ./start_dill_node.sh
                        ;;
                    2)
                        # STOP
                        ./stop_dill_node.sh
                        ;;
                    3)
                        # SHOW PUBKEY
                        ./show_pubkey.sh
                        ;;
                    4)
                        # EXIT
                        break
                        ;;
                    *)
                        incorrect_option
                        ;;
                esac
            done
            ;;
        3)
            # LOGS
            cd $HOME/dill && ./health_check.sh -v
            ;;
        4)
            # DELETE
            process_notification "Удаление (Deleting)..."
            echo

            while true; do
                read -p "Удалить ноду? Delete node? (yes/no): " option

                case "$option" in
                    yes|y|Y|Yes|YES)
                        cd $HOME
                        process_notification "Останавливаем (Stopping)..."
                        run_commands "./stop_dill_node.sh"

                        process_notification "Чистим (Cleaning)..."
                        run_commands "rm -rvf dill"

                        show_green "--- НОДА УДАЛЕНА. NODE DELETED. ---"
                        break
                        ;;
                    no|n|N|No|NO)
                        process_notification "Отмена (Cancel)"
                        echo ""
                        break
                        ;;
                    *)
                        incorrect_option
                        ;;
                esac
            done
            ;;
        5)
            exit_script
            ;;
        *)
            incorrect_option
            ;;
    esac
done
