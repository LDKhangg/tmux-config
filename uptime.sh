#!/bin/sh
# Uptime ngan gon cho tmux bar. Goi qua #(...) bang path tuyet doi,
# khong chua ngoac/pipe/space de tranh loi parse format cua tmux.
uptime -p | cut -c 4-
