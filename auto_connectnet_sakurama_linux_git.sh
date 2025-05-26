#!/bin/bash
set -u
export LANG="C"

# SSIDとパスワードをスクリプト内に埋め込む
INTERFACE_NAME="wlan0"  # 使用するインターフェース名
NETWORK_SSID="aaa"  # 接続するWi-FiのSSID
PASSWORD="BBB"  # Wi-Fiのパスワード

# 指定されたインターフェースが存在するか調べる
iwconfig $INTERFACE_NAME > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Device named '$INTERFACE_NAME' not found."
  exit 2
fi

# すでに接続されていれば終了
iwconfig $INTERFACE_NAME | grep -wq "ESSID:\"$NETWORK_SSID\"" && ifconfig $INTERFACE_NAME | grep -q 'inet addr'
if [ $? -eq 0 ]; then
  echo "Already connected."
  exit 0
fi

# インターフェースを再起動
ifconfig $INTERFACE_NAME down
ifconfig $INTERFACE_NAME up
if [ $? -ne 0 ]; then
  echo "Failed to activate interface $INTERFACE_NAME"
  exit 4
fi

# 指定のSSIDを持つアクセスポイントがあるか調べる
iwlist $INTERFACE_NAME scan | grep -wq "ESSID:\"$NETWORK_SSID\""
if [ $? -ne 0 ]; then
  echo "The wi-fi network with SSID:'$NETWORK_SSID' not found."
  exit 3
fi

# wpa_supplicantが動いていたら殺す
pkill -f "wpa_supplicant.+-i *$INTERFACE_NAME .*"

# SSIDを設定
iwconfig $INTERFACE_NAME essid $NETWORK_SSID

# WPA認証タイムアウト秒数
WPA_AUTH_TIMEOUT=20
is_connected=false
current_time=$(date +%s)
# wpa_supplicantをnohupで起動し接続。stdbufはバッファリングを防止するために必要
while read -t ${WPA_AUTH_TIMEOUT} line; do
  echo "  $line"
  echo $line | grep -wq 'CTRL-EVENT-CONNECTED'
  if [ $? -eq 0 ]; then
    is_connected=true
    break
  fi
  # タイムアウト判定
  if [ $(($(date +%s) - ${current_time})) -gt ${WPA_AUTH_TIMEOUT} ]; then
    echo "Timeout."
    break
  fi
done < <(nohup bash -c "wpa_passphrase $NETWORK_SSID $PASSWORD | stdbuf -oL wpa_supplicant -i $INTERFACE_NAME -D wext -c /dev/stdin 2>&1 &")
if ! $is_connected; then
  echo 'WPA authentication failed.'
  pkill -f "wpa_supplicant.+-i *$INTERFACE_NAME .*"
  exit 5
fi

# IPアドレス割り当て
ifconfig $INTERFACE_NAME | grep -q 'inet addr'
if [ $? -ne 0 ]; then
  dhclient $INTERFACE_NAME
  ifconfig $INTERFACE_NAME | grep -q 'inet addr'
  if [ $? -ne 0 ]; then
    echo 'IP address cannot be assigned.'
    exit 6
  fi
fi

echo 'Connected successfully.'
exit 0
