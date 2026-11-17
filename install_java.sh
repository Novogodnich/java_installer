#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Требуются права root"
  exit 1
fi

echo "=== Установка Java из официальных бинарников Adoptium ==="

echo "Выберите тип пакета:"
echo "1. JDK(средства разработки)"
echo "2. JRE(среда выполнения программ -- рекомендуется для простых пользователей)"
read -p "Введите номер: " type_choice

if [ "$type_choice" = "2" ]; then
  JAVA_TYPE="jre"
else
  JAVA_TYPE="jdk"
fi

echo "Выберите версию Java (например: 17, 21, 23, 25):"
read -p "Версия: " java_version

if [[ -z "$java_version" ]]; then
  echo "Версия не указана. Выход."
  exit 1
fi

ARCH=$(uname -m)
case "$ARCH" in
  x86_64|amd64)
    ARCH_URL="x64"
    ;;
  aarch64|arm64)
    ARCH_URL="aarch64"
    ;;
  *)
    echo "Неподдерживаемая архитектура: $ARCH"
    exit 1
    ;;
esac

DOWNLOAD_URL="https://api.adoptium.net/v3/binary/latest/${java_version}/ga/linux/${ARCH_URL}/${JAVA_TYPE}/hotspot/normal/eclipse?project=jdk"

INSTALL_DIR="/usr/lib/jvm"
TMP_DIR="/tmp/java_install"

if ! curl --output /dev/null --silent --head --fail "$DOWNLOAD_URL"; then
  echo "Ошибка: Версия Java $java_version не найдена на серверах Adoptium."
  echo "Возможно, версия еще не выпущена или указана неверно."
  exit 1
fi

mkdir -p "$INSTALL_DIR"
mkdir -p "$TMP_DIR"

echo "Скачивание Java $java_version ($ARCH_URL)..."
curl -L "$DOWNLOAD_URL" -o "$TMP_DIR/java.tar.gz"

echo "Распаковка архива..."
TARGET_FOLDER_NAME=$(tar -tf "$TMP_DIR/java.tar.gz" | head -n 1 | cut -f1 -d"/")
tar -xzf "$TMP_DIR/java.tar.gz" -C "$INSTALL_DIR"
FINAL_PATH="$INSTALL_DIR/$TARGET_FOLDER_NAME"

echo "Интеграция в систему (update-alternatives)..."
update-alternatives --install /usr/bin/java java "$FINAL_PATH/bin/java" 100
if [ -f "$FINAL_PATH/bin/javac" ]; then
  update-alternatives --install /usr/bin/javac javac "$FINAL_PATH/bin/javac" 100
fi

update-alternatives --set java "$FINAL_PATH/bin/java"
if [ -f "$FINAL_PATH/bin/javac" ]; then
  update-alternatives --set javac "$FINAL_PATH/bin/javac"
fi

rm -r "$TMP_DIR"

echo "=== Установка успешно завершена! ==="
java -version
