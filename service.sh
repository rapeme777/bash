#!/bin/bash

SERVICE_NAME="balooproxy"
SERVICE_PATH="/etc/systemd/system/${SERVICE_NAME}.service"
BIN_PATH="/root/main"

# Проверка наличия бинарника
if [[ ! -f "$BIN_PATH" ]]; then
  echo "❌ Не найден бинарник: $BIN_PATH"
  exit 1
fi

# Создание systemd-сервиса
cat <<EOF | sudo tee "$SERVICE_PATH" > /dev/null
[Unit]
Description=BalooProxy Service
After=network.target

[Service]
Type=simple
ExecStart=${BIN_PATH}
WorkingDirectory=/root
User=root
Restart=always
RestartSec=1
LimitNOFILE=65535
LimitNPROC=65535

[Install]
WantedBy=multi-user.target
EOF

# Применение и запуск
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable $SERVICE_NAME
sudo systemctl restart $SERVICE_NAME

echo "✅ Сервис '$SERVICE_NAME' установлен и запущен!"
systemctl status $SERVICE_NAME --no-pager
