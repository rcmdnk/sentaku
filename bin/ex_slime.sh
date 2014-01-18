#!/bin/sh

# Example to make menu program

. sentaku -n

_SENTAKU_NOHEADER=0
_SENTAKU_NONUMBER=0

menu="戦う
魔法
逃げる
アイテム"
menu_en="FIGHT
SPELL
RUN
ITEM"

your_name="アレフ"
your_name_en="Alef"
your_hp=30
your_wepon="ロトの剣"
your_wepon_en="Erdrick's Sword"
your_wepon_power=(6 10)
your_wepon_miss=10
your_spell="ホイミ"
your_spell_en="Heal"
your_mp=6
your_heal=(10 17)
heal_mp=4
slime_name="スライム"
slime_name_en="Slime"
slime_min_hp=10
slime_max_hp=40
slime_hp=40
slime_power=(1 15)
slime_power_miss=10

sudden_death=20

_s_help="
Usage: ex_slime.sh [-je]

Arguments:
   -j   Use Japanese (Default)
   -e   Use English
   -h   Print this HELP and exit
"

_sf_setheader () { # {{{
  local slime="
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
  _s_header="$slime


$_s_message

 $_s_your_name HP: $_s_your_hp MP: $_s_your_mp
"
} # }}}

_sf_sudden_death () { # {{{
  if [ $_s_lang = "ja" ];then
    local death="
＿人人人人人人＿
＞　突然の死　＜
￣Y^Y^Y^Y^Y^Y^￣
"
  else
    local death="
_/\/\/\/\/\/\/\_
> Sudden Death <
 \/\/\/\/\/\/\/
"
  fi
  _sf_echo "$death"
  _sf_quit 1
} # }}}

_sf_execute () { # {{{
  :
} # }}}

_sf_check_args () { # {{{
  # Get arguments
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
    _s_command=" Command:"
    _s_message=" A $slime_name_en Draws Near! $_s_command
"
    _s_your_name="${your_name_en}"
    _s_wepon=$your_wepon_en
    _s_wepon_message="Wepon: $_s_wepon"
    _s_spell="$your_spell_en"
    _s_spell_message="Spell: $_s_spell"
    _s_item_message="No Item"
    _s_fight_command=" ${_s_your_name} attacks!"
    _s_spell_command=" ${_s_your_name} casts $_s_spell!"
    _s_run_command=" Failed to escape!"
    _s_item_command=" No Item!"
    _s_slime_fight=" The $slime_name_en attacks!"
    _s_damage=" damage!"
    _s_failed=" Failed!"
    _s_nomp=" No MP remained!"
    _s_attacks="

$_s_command"
  fi
  return 10

} # }}}

_sf_get_values () { # {{{
  if [ $_s_lang = "ja" ];then
    _s_inputs=($(echo $menu))
  else
    _s_inputs=($(echo $menu_en))
  fi
  _s_n=${#_s_inputs[@]}
} # }}}

_sf_initialize_user () { # {{{
  _s_your_hp=$your_hp
  _s_your_mp=$your_mp
  _s_slime_hp=$((slime_min_hp+RANDOM%(slime_max_hp-slime_min_hp+1)))
  slime_hp=$_s_slime_hp
  [ $_s_slime_hp -eq 0 ] && _s_slime_hp=1
  _s_lang="ja"

  _s_your_name=$your_name
  _s_weapon=$your_weapon
  _s_weapon_message="武器: $_s_weapon"
  _s_spell="$your_spell"
  _s_spell_message="魔法: $_s_spell"
  _s_item_message="何も持ってない"
  _s_command=" コマンド:"
  _s_message=" ${slime_name}があらわれた! $_s_command
"
  _s_fight_command=" ${_s_your_name}の攻撃!"
  _s_spell_command=" ${_s_your_name}は${_s_spell}を唱えた!"
  _s_run_command=" 逃げだした! しかし回りこまれた!"
  _s_item_command=" アイテムを持ってない!"
  _s_slime_fight=" ${slime_name}の攻撃!"
  _s_damage=" のダメージ!"
  _s_failed=" かわされた!"
  _s_nomp=" しかしMPがたりない!"
  _s_menu="$menu_ja"
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
  local you_win="
 __     __          __          ___       _
 \ \   / /          \ \        / (_)     | |
  \ \_/ /__  _   _   \ \  /\  / / _ _ __ | |
   \   / _ \| | | |   \ \/  \/ / | |  _ \| |
    | | (_) | |_| |    \  /\  /  | | | | |_|
    |_|\___/ \__,_|     \/  \/   |_|_| |_(_)
"
  _sf_echo "$you_win"
  _sf_quit 0
} # }}}

_sf_lose () { # {{{
  local you_lose="
 __     __           _                    _
 \ \   / /          | |                  | |
  \ \_/ /__  _   _  | |     ___  ___  ___| |
   \   / _ \| | | | | |    / _ \/ __|/ _ \ |
    | | (_) | |_| | | |___| (_) \__ \  __/_|
    |_|\___/ \__,_| |______\___/|___/\___(_)
"
  _sf_echo "$you_lose"
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
  _s_slime_attack=$(_sf_rand $4 $5 $3)
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
  _s_your_hp=$((_s_your_hp+_s_your_heal))
  [ $_s_your_hp -gt $your_hp ] && _s_your_hp=$your_hp
  _s_message_tmp="$1"
} # }}}

_sf_slime_attack () { # {{{
  if [ $_s_slime_attack -eq 0 ];then
    _s_message_tmp="$1 $_s_failed"
    return
  fi
  _s_your_hp=$((_s_your_hp-_s_slime_attack))
  [ $_s_your_hp -lt 0 ] && _s_your_hp=0
  _s_message_tmp="$1 $_s_slime_attack $_s_damage"
} # }}}

_sf_slime_heal () { # {{{
  _s_slime_hp=$((_s_slime_hp+_s_slime_heal))
  [ $_s_slime_hp -gt $slime_hp ] && _s_slime_hp=$slime_hp
  _s_message_tmp="$1"
} # }}}

_sf_check_hp () { # {{{
  [ $_s_your_hp -le 0 ] && _sf_lose
  [ $_s_slime_hp -le 0 ] && _sf_win
} # }}}

_sf_new_message () { # {{{
  _s_message="$1"
  _sf_printall
  _sf_wait
} # }}}

_sf_message () { # is_you_first your_message is_attack slime_message is_attack {{{
  _s_first_message=$2
  if [ $1 -eq 0 ];then
    _s_first_message=$4
  fi
  _sf_new_message="$_s_first_message
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
  fi
  _sf_command_reset
} # }}}

_sf_command_reset () { # {{{
  _s_message="$_s_command
"
  _sf_printall
} # }}}

_sf_0 () { # FIGHT {{{
  local first=$((RANDOM%2))
  _sf_attacks ${your_weapon_power[0]} ${your_weapon_power[1]} $your_weapon_miss\
              ${slime_power[0]} ${slime_power[1]} $slime_power_miss
  _sf_message $first "$_s_fight_command" 1 "$_s_slime_fight" 1
} # }}}

_sf_1 () { # SPELL {{{
  local first=$((RANDOM%2))
  local y_m=$_s_spell_command
  if [ $_s_your_mp -lt $heal_mp ];then
    _s_your_heal=0
    y_m="$_s_spell_command $_s_nomp"
  else
    _s_your_heal=$(_sf_rand ${your_heal[0]} ${your_heal[1]})
    _s_your_mp=$((_s_your_mp-heal_mp))
  fi
  _sf_attacks 0 0 0\
              ${slime_power[0]} ${slime_power[1]} $slime_power_miss
  _sf_message $first "$y_m" 2 "$_s_slime_fight" 1
} # }}}

_sf_2 () { # RUN {{{
  if [ $((RANDOM%sudden_death)) -eq 0 ];then
    _sf_sudden_death
  else
    _sf_attacks 0 0 0\
                ${slime_power[0]} ${slime_power[1]} $slime_power_miss
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
} # }}}

_sf_main $*
