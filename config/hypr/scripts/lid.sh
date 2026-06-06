if hyprctl monitors | grep -q 'DP-1'; then
  if [[ "$1" == "close" ]]; then
    #desactiva la pantalla del portatil cuando esta cerrado
    hyprctl keyword monitor "eDP-1, disable"

  elif [[ "$1" == "open" ]]; then
    #activa la pantalla del portatil cuando es abierta
    hyprctl keyword monitor "eDP-1, preferred, auto, 1"
fi
