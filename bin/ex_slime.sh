#!/bin/sh

# Example to make menu program

. sentaku -n

_SENTAKU_NOHEADER=0
_SENTAKU_NONUMBER=0

_MENU="戦う
魔法
逃げる
アイテム"
_MENU_EN="FIGHT
SPELL
RUN
ITEM"

_YOUR_NAME="アレフ"
_YOUR_NAME_EN="Alef"
_YOUR_HP=30
_YOUR_WEAPON="ロトの剣"
_YOUR_WEAPON_EN="Erdrick's Sword"
_YOUR_WEAPON_POWER=(6 10)
_YOUR_WEAPON_MISS=10
_YOUR_MP=6
_YOUR_SPELLS=("ホイミ" "ギラ")
_YOUR_SPELLS_EN=("Heal" "Hurt")
_YOUR_SPELLS_MP=(4 2)
_YOUR_HURT=(5 15)
_YOUR_HEAL=(10 17)
_SLIME_NAME="スライム"
_SLIME_NAME_EN="Slime"
_SLIME_MIN_HP=10
_SLIME_MAX_HP=40
_SLIME_HP=40
_SLIME_POWER=(1 15)
_SLIME_POWER_MISS=10

sudden_death=5

_s_help="
Usage: ex_slime.sh [-je]

Arguments:
   -j   Use Japanese (Default)
   -e   Use English
   -h   Print this HELP and exit
"

_sf_set_header_mine () { # {{{
  local slime=""
  local message="$_s_message"
  if [ $_s_lines -ge 28 ];then
    slime="
              66
              66
              66
            666666
          6666666666
      666666666666666666
    7777666666666666666666
  77776666666666666666666666
667766666777766667777666666666
666666667766776677667766666666
666666667766776677667766666666
666666006777766667777600666666
666666000066666666660000666666
  66666600000000000000666666
    666666666666666666666
"
    slime="$(echo "$slime"|sed 's/\([0-9]\)/\\e[4\1m \\e[m/g')"
    message="${slime}

${_s_message}"
  fi
  _s_header="${message}

$_s_your_info"
} # }}}

_sf_set_header () { # {{{
  _sf_set_header_mine
} # }}}

_sf_sudden_death () { # {{{
  _s_your_hp=0
  if [ $_s_lang = "ja" ];then
    _s_message="\e[41m
＿人人人人人人＿
＞　突然の死　＜
￣Y^Y^Y^Y^Y^Y^￣
\e[m
"
  else
    _s_message="\e[41m
_/\/\/\/\/\/\/\_
> Sudden Death <
 \/\/\/\/\/\/\/ 
\e[m
"
  fi
  _sf_set_header
  _sf_echo "$_s_header"
  _sf_lose
} # }}}

_sf_execute () { # {{{
  :
} # }}}

_sf_check_args () { # {{{
  # Get arguments
  _s_continue=0
  while [ $# -gt 0 ];do
    case $1 in
      "-j" ) _s_lang="ja";shift;;
      "-e" ) _s_lang="en";shift;;
      "-h" )
        echo "$_s_help" >/dev/tty
        _sf_wait
        return 0
        ;;
      * )
        echo "$_s_help" >/dev/tty
        _sf_wait
        return 1
        ;;
    esac
  done
  if [ $_s_lang = "en" ];then
    _s_your_name="${_YOUR_NAME_EN}"
    _s_weapon=$_YOUR_WEAPON_EN
    _s_weapon_message="Weapon: $_s_weapon"
    _s_your_spells=("${_YOUR_SPELLS_EN[@]}")
    _s_spell_message="Spell:
$(for ((i=0; i<${#_s_your_spells[@]}; i++));do \
      echo " ${_s_your_spells[$i]}: MP ${_YOUR_SPELLS_MP[$i]} Required";done)"
    _s_spells_message="Spell: ${_s_spells[@]}"
    _s_item_message="No Item"
    _s_command=" Command:"
    _s_your_info=" $_s_your_name HP: $_s_your_hp MP: $_s_your_mp"
    _s_message=" A $_SLIME_NAME_EN Draws Near! $_s_command
"
    _s_fight_command=" ${_s_your_name} attacks!"
    _sf_spell_command () { echo " ${_s_your_name} casts $1!";}
    _s_run_command=" Failed to escape!"
    _s_item_command=" No Item!"
    _s_slime_fight=" The $_SLIME_NAME_EN attacks!"
    _s_damage="damage!"
    _sf_cured () { echo "HP ${1} cured!";}
    _s_failed=" Failed!"
    _s_nomp=" No enough MP remained!"
    _s_attacks="

$_s_command"
  fi
  _s_continue=1
  return 0

} # }}}

_sf_get_values () { # {{{
  if [ $_s_lang = "ja" ];then
    _s_inputs=($(echo $_MENU))
  else
    _s_inputs=($(echo $_MENU_EN))
  fi
  _s_n=${#_s_inputs[@]}
} # }}}

_sf_initialize_user () { # {{{
  _s_your_hp=$_YOUR_HP
  _s_your_hp_max=$_YOUR_HP
  _s_your_mp=$_YOUR_MP
  _s_slime_hp=$((_SLIME_MIN_HP+RANDOM%(_SLIME_MAX_HP-_SLIME_MIN_HP+1)))
  _s_slime_this_max_hp=$_s_slime_hp
  [ $_s_slime_hp -eq 0 ] && _s_slime_hp=1
  _s_lang="ja"

  _s_your_name="$_YOUR_NAME"
  _s_weapon="$_YOUR_WEAPON"
  _s_weapon_message="武器: $_s_weapon"
  _s_your_spells=("${_YOUR_SPELLS[@]}")
  _s_spell_message="魔法:
$(for ((i=0; i<${#_s_your_spells[@]}; i++));do \
    echo " ${_YOUR_SPELLS[$i]}: 消費MP ${_YOUR_SPELLS_MP[$i]}";done)"
  _s_item_message="何も持ってない"
  _s_command=" コマンド:"
  _s_your_info=" $_s_your_name HP: $_s_your_hp MP: $_s_your_mp"
  _s_message=" ${_SLIME_NAME}があらわれた! $_s_command
"
  _s_fight_command=" ${_s_your_name}の攻撃!"
  _sf_spell_command () { echo " ${_s_your_name}は${1}を唱えた!";}
  _s_run_command=" 逃げだした! しかし回りこまれた!"
  _s_item_command=" アイテムを持ってない!"
  _s_slime_fight=" ${_SLIME_NAME}の攻撃!"
  _s_damage="のダメージ!"
  _sf_cured () { echo "HP ${1} 回復!";}
  _s_failed=" かわされた!"
  _s_nomp=" しかしMPがたりない!"
  _s_attacks="

$_s_command"
  _s_message_tmp=""
  _s_first_message=""
  _s_second_message=""

  _s_your_attack=0
  _s_slime_attack=0
} # }}}

_sf_finzlize_user () { # {{{
  :
} # }}}

_sf_win () { # {{{
  _s_message="\e[1;5;35;42m
 __     __          __          ___       _ 
 \ \   / /          \ \        / (_)     | |
  \ \_/ /__  _   _   \ \  /\  / / _ _ __ | |
   \   / _ \| | | |   \ \/  \/ / | |  _ \| |
    | | (_) | |_| |    \  /\  /  | | | | |_|
    |_|\___/ \__,_|     \/  \/   |_|_| |_(_)
\e[m
"
  _sf_set_header
  _sf_echo "$_s_header"
  _sf_quit 0
} # }}}

_sf_lose () { # {{{
  _s_message="\e[1;5;31;44m
 __     __           _                    _ 
 \ \   / /          | |                  | |
  \ \_/ /__  _   _  | |     ___  ___  ___| |
   \   / _ \| | | | | |    / _ \/ __|/ _ \ |
    | | (_) | |_| | | |___| (_) \__ \  __/_|
    |_|\___/ \__,_| |______\___/|___/\___(_)
\e[m
"
  _sf_set_header
  _sf_echo "$_s_header"
  _sf_quit 1
} # }}}

_sf_rand () { # _sf_rand min max [miss] {{{
  local min=$1
  local max=$2
  local miss=${3:-0}
  if [ $max -ne 0 ];then
    if [ $miss -eq 0 ] || [ $((RANDOM%miss)) -ne 0 ];then
      echo $((min+RANDOM%(max-min+1)))
      return
    fi
  fi
  echo 0
  return
} # }}}

_sf_attacks () { # your_min your_max your_miss slime_min slime_max slime_miss {{{
  _s_your_attack=$(_sf_rand $1 $2 $3)
  _s_slime_attack=$(_sf_rand $4 $5 $6)
} # }}}

_sf_your_attack () { # {{{
  if [ $_s_your_attack -eq 0 ];then
    _s_message_tmp="$1 $_s_failed"
    return
  fi
  _s_slime_hp=$((_s_slime_hp-_s_your_attack))
  [ $_s_slime_hp -lt 0 ] && _s_slime_hp=0
  _s_message_tmp="$1 $_s_your_attack $_s_damage"
} # }}}

_sf_your_heal () { # {{{
  local cur_hp=$_s_your_hp
  _s_your_hp=$((_s_your_hp+_s_your_heal))
  [ $_s_your_hp -gt $_s_your_hp_max ] && _s_your_hp=$_s_your_hp_max
  _s_message_tmp="$1 $(_sf_cured $((_s_your_hp-cur_hp)))"
} # }}}

_sf_slime_attack () { # {{{
  if [ $_s_slime_attack -eq 0 ];then
    _s_message_tmp="$1 $_s_failed"
    return
  fi
  _s_your_hp=$((_s_your_hp-_s_slime_attack))
  _s_message_tmp="$1 $_s_slime_attack $_s_damage"
} # }}}

_sf_your_info () { # {{{
  if [ $_s_your_hp -lt 0 ];then
    _s_your_hp=0
    _s_your_info=" \e[34m$_s_your_name HP: $_s_your_hp MP: $_s_your_mp\e[m"
  elif [ $_s_your_hp -lt 10 ];then
    _s_your_info=" \e[31m$_s_your_name HP: $_s_your_hp MP: $_s_your_mp\e[m"
  else
    _s_your_info=" $_s_your_name HP: $_s_your_hp MP: $_s_your_mp"
  fi
} # }}}

_sf_slime_heal () { # {{{
  local cur_hp=$_s_slime_hp
  _s_slime_hp=$((_s_slime_hp+_s_slime_heal))
  [ $_s_slime_hp -gt $_s_slime_this_max_hp ] && _s_slime_hp=$_s_slime_this_max_hp
  _s_message_tmp="$1"
  _s_message_tmp="$1 $(_sf_cured $((_s_slime_hp-cur_hp)))"
} # }}}

_sf_check_hp () { # {{{
  [ $_s_your_hp -le 0 ] && _sf_lose
  [ $_s_slime_hp -le 0 ] && _sf_win
} # }}}

_sf_new_message () { # {{{
  _s_message="$1"
  _sf_your_info
  _sf_setview
  _sf_echo "${_s_header}"
} # }}}

_sf_command_reset () { # {{{
  _s_message="$_s_command
"
} # }}}

_sf_message () { # is_you_first your_message is_attack slime_message is_attack {{{
  _s_first_message=$2
  if [ $1 -eq 0 ];then
    _s_first_message=$4
  fi
  _sf_new_message "$_s_first_message
"

  if [ $1 -eq 1 -a "$3" -eq 1 ] || [ $1 -eq 0 -a "$5" -eq 1 ] ;then
    if [ $1 -eq 1 ];then
      _sf_your_attack "$2"
    else
      _sf_slime_attack "$4"
    fi
    _s_first_message=$_s_message_tmp
    _sf_new_message "$_s_first_message
"
    _sf_check_hp
    [ $_s_break -eq 1 ] && return
  elif [ $1 -eq 1 -a "$3" -eq 2 ] || [ $1 -eq 0 -a "$5" -eq 2 ] ;then
    if [ $1 -eq 1 ];then
      _sf_your_heal "$2"
    else
      _sf_slime_heal "$4"
    fi
    _s_first_message=$_s_message_tmp
    _sf_new_message "$_s_first_message
"
  elif [ $1 -eq 1 -a "$3" -eq 3 ] || [ $1 -eq 0 -a "$5" -eq 3 ] ;then
    if [ $1 -eq 1 ];then
      _s_first_message="$2 $_s_nomp"
    else
      _s_first_message="$4 $_s_nomp"
    fi
    _sf_new_message "$_s_first_message
"
  fi

  _s_second_message="$4"
  if [ $1 -eq 0 ];then
    _s_second_message="$2"
  fi
  _sf_new_message "$_s_first_message
$_s_second_message"
  if [ $1 -eq 0 -a "$3" -eq 1 ] || [ $1 -eq 1 -a "$5" -eq 1 ] ;then
    if [ $1 -eq 1 ];then
      _sf_slime_attack "$4"
    else
      _sf_your_attack "$2"
    fi
    _s_second_message=$_s_message_tmp
    _sf_new_message "$_s_first_message
$_s_second_message"
    _sf_check_hp
    [ $_s_break -eq 1 ] && return
  elif [ $1 -eq 0 -a "$3" -eq 2 ] || [ $1 -eq 1 -a "$5" -eq 2 ] ;then
    if [ $1 -eq 1 ];then
      _sf_slime_heal "$4"
    else
      _sf_your_heal "$2"
    fi
    _s_second_message=$_s_message_tmp
    _sf_new_message "$_s_first_message
$_s_second_message"
  elif [ $1 -eq 0 -a "$3" -eq 3 ] || [ $1 -eq 1 -a "$5" -eq 3 ] ;then
    if [ $1 -eq 1 ];then
      _s_second_message="$4 $_s_nomp"
    else
      _s_second_message="$2 $_s_nomp"
    fi
    _sf_new_message "$_s_first_message
$_s_second_message"
  fi
  _sf_command_reset
} # }}}

_sf_0 () { # FIGHT {{{
  local first=$((RANDOM%2))
  _sf_attacks ${_YOUR_WEAPON_POWER[0]} ${_YOUR_WEAPON_POWER[1]} $_YOUR_WEAPON_MISS \
              ${_SLIME_POWER[0]} ${_SLIME_POWER[1]} $_SLIME_POWER_MISS
  _sf_message $first "$_s_fight_command" 1 "$_s_slime_fight" 1
} # }}}

_sf_1 () { # SPELL {{{
  local first=$((RANDOM%2))
  local spell=$(_sf_spell)
  #_sf_hide
  local is_attack=2
  if [ "$spell" = "${_s_your_spells[0]}" ];then
    local s_m=$(_sf_spell_command "$spell")
    if [ $_s_your_mp -lt ${_YOUR_SPELLS_MP[0]} ];then
      _s_your_heal=0
      is_attack=3
    else
      _s_your_heal=$(_sf_rand ${_YOUR_HEAL[0]} ${_YOUR_HEAL[1]})
      _s_your_mp=$((_s_your_mp-${_YOUR_SPELLS_MP[0]}))
    fi
    _sf_attacks 0 0 0\
                ${_SLIME_POWER[0]} ${_SLIME_POWER[1]} $_SLIME_POWER_MISS
    _sf_message $first "$s_m" $is_attack "$_s_slime_fight" 1
  elif [ "$spell" = "${_s_your_spells[1]}" ];then
    local s_m=$(_sf_spell_command "$spell")
    local min=0
    local max=0
    local miss=0
    if [ $_s_your_mp -lt ${_YOUR_SPELLS_MP[1]} ];then
      is_attack=3
    else
      is_attack=1
      min=${_YOUR_HURT[0]}
      max=${_YOUR_HURT[1]}
      _s_your_mp=$((_s_your_mp-${_YOUR_SPELLS_MP[1]}))
    fi
    _sf_attacks $min $max $miss\
                ${_SLIME_POWER[0]} ${_SLIME_POWER[1]} $_SLIME_POWER_MISS
    _sf_message $first "$s_m" $is_attack "$_s_slime_fight" 1
  fi
  _sf_command_reset
} # }}}

_sf_spell () { # {{{
  . sentaku -n -c

  _sf_set_header () {
    _sf_set_header_mine
  }

  _sf_s () {
    local i
    for((i=0; i<${#_s_your_spells[@]}; i++));do
      if [ $_s_current_n -eq $i ];then
        _sf_new_message " ${_s_your_spells[$i]}: MP ${_YOUR_SPELLS_MP[$i]}"
        _sf_command_reset
        break
      fi
    done
  }

  echo "${_s_your_spells[@]}"| _sf_main
} # }}}

_sf_2 () { # RUN {{{
  if [ $((RANDOM%sudden_death)) -eq 0 ];then
    _sf_sudden_death
  else
    _sf_attacks 0 0 0\
                ${_SLIME_POWER[0]} ${_SLIME_POWER[1]} $_SLIME_POWER_MISS
    _sf_message 1 "$_s_run_command" 0 "$_s_slime_fight" 1
  fi
} # }}}

_sf_3 () { # ITEM {{{
  _sf_new_message "$_s_item_command
"
  _sf_command_reset
} # }}}

_sf_s () { # {{{
  if [ $_s_current_n -eq 0 ];then
    _sf_new_message "$_s_weapon_message
"
  elif [ $_s_current_n -eq 1 ];then
    _sf_new_message "$_s_spell_message
"
  elif [ $_s_current_n -eq 2 ];then
    :
  elif [ $_s_current_n -eq 3 ];then
    _sf_new_message "$_s_item_message
"
  fi
  _sf_command_reset
} # }}}

_sf_q () { # {{{
  :
} # }}}

_sf_select () { # {{{
  if [ $_s_current_n -eq 0 ];then
    _sf_0
  elif [ $_s_current_n -eq 1 ];then
    _sf_1
  elif [ $_s_current_n -eq 2 ];then
    _sf_2
  elif [ $_s_current_n -eq 3 ];then
    _sf_3
  fi
  _s_is_print=1
} # }}}

_sf_main "$@"
