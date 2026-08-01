# Samsung TV Codes

Коды шлются через `script.ir_tv` в топик `zigbee2mqtt/0xa49e69fffee74a38/set`.

## On/Off

Кнопка питания — тоггл, поэтому `script.tv_power_on` шлёт код только когда
`media_player.samsung_au7002_50_tv` не в состоянии `on`.

Код, который используется в `script.tv_power_on`:

```
B7cRtxEzApwG4AED4AsB4Bsf4Acr4Acb4AsXwA8BCrjgfYc=
```

Более ранняя запись той же кнопки (не используется):

```
B7cRtxEzApwG4AED4AsB4BcfQAHAI8ABwA/AB8AB4AcPQAEHCri3EbcRMwLAG0AH4AsBQBfAA+APAeAHH8APwAfAAeAHD0AB4EeH4A8BQHtAAUAH4AgDAgYzAg==
```

## Остальное

Выключение, источники и громкость идут не по ИК, а через интеграцию samsungtv
(`media_player.turn_off`, `media_player.select_source`, `remote.send_command`).
ИК остался только для включения — по websocket телевизор не разбудить.
