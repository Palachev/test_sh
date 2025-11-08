# Мониторинг процесса test

Скрипт для мониторинга процесса test и отправки уведомлений.

## Что делает скрипт

1. Проверяет работу процесса test
2. Если процесс работает:
   - Отправляет запрос на https://test.com/monitoring/test/api
   - Записывает в лог, если сервер недоступен
3. Если процесс перезапускался - пишет в лог


## Файлы проекта

- `monitor_test.sh` - скрипт мониторинга
- `monitor_test.service` - сервис для запуска скрипта
- `monitor_test_timer.service` - таймер для запуска каждую минуту
- `dummy_test.service` - тестовый процесс

## Как установить

1. Копируем скрипт:
```bash
cp monitor_test.sh /usr/local/bin/
chmod +x /usr/local/bin/monitor_test.sh
```

2. Копируем файлы сервисов:
```bash
cp monitor_test.service /etc/systemd/system/
cp monitor_test_timer.service /etc/systemd/system/
cp dummy_test.service /etc/systemd/system
```

3. Запускаем:
```bash
systemctl daemon-reload
systemctl enable monitor_test_timer.service
systemctl start monitor_test_timer.service
```

## Как проверить работу

Смотрим логи:
```bash
cat /var/log/monitoring.log
```

Проверяем статус:
```bash
systemctl status monitor_test_timer.service
```
Так же добавил файл `/etc/logrotate.d/monitor_test.conf` - со следующими настройками:
- Проверка и ротация раз в день
- Хранить 3 старых лог-файла
- Ротация произойдёт, если лог превысит 10 МБ
- Старые логи архивируются (compress)
- Сжатие задержано на следующую ротацию (delaycompress)

## Установка и настройка logrotate
```bash
sudo apt install logrotate
sudo cp monitor_test.conf /etc/logrotate.d/
```
