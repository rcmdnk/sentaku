#!/usr/bin/env bats

setup() {
  load ./bats-assert/load
  load ./bats-support/load
  tmpdir=$(mktemp -d)
  cd "$tmpdir"
  . sentaku -n
  _sf_initialize
}

teardown() {
  rm -rf "$tmpdir"
}

@test "_sf_help" {
  run _sf_help
  assert_success
  assert [ "$output" != "" ]
}

@test "_sf_initialize" {
  assert_equal "$_s_n" 0
}

@test "_sf_initialize_user" {
  skip
}

@test "_sf_finalize" {
  skip
  _sf_finalize
  assert_equal "$_s_n" ""
}

@test "_sf_finalize_user" {
  skip
}

@test "_sf_execute" {
  _s_inputs=(0 1 2 3 4 5 6 7 8 9 10)
  _s_v_selected=(0 1 0 1 1 0 1 0 0 0 0)
  _s_n=${#_s_inputs[@]}
  _s_s=" "
  _s_current_n=5
  _s_visual=-1
  run _sf_execute
  assert_output "5"
  _s_visual=1
  run _sf_execute
  assert_output "1 3 4 6"
}

@test "_sf_hide" {
  skip
  #run _sf_hide
  #assert_success
}

@test "_sf_clear" {
  skip
  #run _sf_clear
  #assert_success
}

@test "_sf_nth" {
  run _sf_nth 1
  assert_output "1st"
  run _sf_nth 2
  assert_output "2nd"
  run _sf_nth 3
  assert_output "3rd"
  run _sf_nth 4
  assert_output "4th"
}

@test "_sf_read" {
  skip
}

@test "_sf_wait" {
  skip
}

@test "_sf_yn" {
  skip
}

@test "_sf_check_args" {
  skip
}

@test "_sf_get_values_wrapper" {
  skip
}

@test "_sf_get_values" {
  _s_use_file=1
  _s_file=./test_inputs.txt
  printf "aaa\nbbb\nccc\nddd\neee" > $_s_file
  _sf_get_values 0 0
  assert_equal "$_s_n" 5
  assert_equal "${_s_inputs[0]}" "aaa"
  assert_equal "${_s_inputs[2]}" "ccc"

  _s_max=4
  _sf_align_values 1
  assert_equal "$_s_n" 4
  assert_equal "${_s_inputs[1]}" "aaa"

  _s_current_n=1
  _sf_delete
  assert_equal "$_s_n" 3
  assert_equal "${_s_inputs[1]}" "ccc"

  rm -f $_s_file
}

@test "_sf_align_values" {
  : # combined with _sf_get_values
}

@test "_sf_delete" {
  : # combined with _sf_get_values
}

@test "_sf_remove" {
  _s_inputs=(0 1 2 3 4 5)
  _s_n=${#_s_inputs[@]}
  _s_current_n=1
  _s_visual=-1
  _sf_remove
  assert_equal "${_s_inputs[*]}" "0 2 3 4 5"
  _s_visual=1
  _s_v_selected=(0 1 1 0 0)
  _sf_remove
  assert_equal "${_s_inputs[*]}" "0 4 5"
}

@test "_sf_rm_del" {
  skip
}

@test "_sf_add_spaces" {
  x="test"
  _sf_add_spaces x 3
  assert_equal "$x" "test   "
  x="test"
  _sf_add_spaces x 3 1
  assert_equal "$x" "   test"
}

@test "_sf_cut_word" {
  x="123456789"
  _sf_cut_word x 5
  assert_equal "$x" "12345"
  x="123456789"
  _sf_cut_word x 5 1
  assert_equal "$x" "56789"
}

@test "_sf_get_content" {
  file=./test_inputs.txt
  dir=./test_dir
  echo test > $file
  mkdir -p $dir

  _s_inputs=($file $dir)
  _s_current_n=0
  run _sf_get_content
  assert_output "test"
  _s_current_n=1
  run _sf_get_content
  assert_output "Not a text file"

  rm -rf $file $dir
}

@test "_sf_content" {
  skip
}

@test "_sf_show" {
  skip
}

@test "_sf_printline" {
  skip
}

@test "_sf_print_current_line" {
  skip
}

@test "_sf_printall" {
  skip
}

@test "_sf_print" {
  skip
}

@test "_sf_echo" {
  skip
}

@test "_sf_echoln" {
  skip
}

@test "_sf_echo_debug" {
  skip
}

@test "_sf_echoln_debug" {
  skip
}

@test "_sf_echo_printall" {
  skip
}

@test "_sf_set_header" {
  skip
}

@test "_sf_setview" {
  skip
}

@test "_sf_n_down" {
  skip
}

@test "_sf_n_up" {
  skip
}

@test "_sf_item_move_up" {
  skip
}

@test "_sf_item_move_down" {
  skip
}

@test "_sf_quit" {
  skip
}

@test "_sf_select" {
  skip
}

@test "_sf_search" {
  skip
}

@test "_sf_search_check" {
  skip
}

@test "_sf_reset" {
  skip
}

@test "_sf_visual_start" {
  skip
}

@test "_sf_gG" {
  skip
}

@test "_sf_n_move_inc" {
  skip
}

@test "_sf_0" {
  skip
}

@test "_sf_1" {
  skip
}

@test "_sf_2" {
  skip
}

@test "_sf_3" {
  skip
}

@test "_sf_4" {
  skip
}

@test "_sf_5" {
  skip
}

@test "_sf_6" {
  skip
}

@test "_sf_7" {
  skip
}

@test "_sf_8" {
  skip
}

@test "_sf_9" {
  skip
}

@test "_sf_a" {
  skip
}

@test "_sf_b" {
  skip
}

@test "_sf_c" {
  skip
}

@test "_sf_d" {
  skip
}

@test "_sf_e" {
  skip
}

@test "_sf_f" {
  skip
}

@test "_sf_g" {
  skip
}

@test "_sf_h" {
  skip
}

@test "_sf_i" {
  skip
}

@test "_sf_j" {
  skip
}

@test "_sf_k" {
  skip
}

@test "_sf_l" {
  skip
}

@test "_sf_m" {
  skip
}

@test "_sf_n" {
  skip
}

@test "_sf_o" {
  skip
}

@test "_sf_p" {
  skip
}

@test "_sf_q" {
  skip
}

@test "_sf_r" {
  skip
}

@test "_sf_s" {
  skip
}

@test "_sf_t" {
  skip
}

@test "_sf_u" {
  skip
}

@test "_sf_v" {
  skip
}

@test "_sf_w" {
  skip
}

@test "_sf_x" {
  skip
}

@test "_sf_y" {
  skip
}

@test "_sf_z" {
  skip
}

@test "_sf_A" {
  skip
}

@test "_sf_B" {
  skip
}

@test "_sf_C" {
  skip
}

@test "_sf_D" {
  skip
}

@test "_sf_E" {
  skip
}

@test "_sf_F" {
  skip
}

@test "_sf_G" {
  skip
}

@test "_sf_H" {
  skip
}

@test "_sf_I" {
  skip
}

@test "_sf_J" {
  skip
}

@test "_sf_K" {
  skip
}

@test "_sf_L" {
  skip
}

@test "_sf_M" {
  skip
}

@test "_sf_N" {
  skip
}

@test "_sf_O" {
  skip
}

@test "_sf_P" {
  skip
}

@test "_sf_Q" {
  skip
}

@test "_sf_R" {
  skip
}

@test "_sf_S" {
  skip
}

@test "_sf_T" {
  skip
}

@test "_sf_U" {
  skip
}

@test "_sf_V" {
  skip
}

@test "_sf_W" {
  skip
}

@test "_sf_X" {
  skip
}

@test "_sf_Y" {
  skip
}

@test "_sf_Z" {
  skip
}

@test "_sf_c_a" {
  skip
}

@test "_sf_c_b" {
  skip
}

@test "_sf_c_c" {
  skip
}

@test "_sf_c_d" {
  skip
}

@test "_sf_c_e" {
  skip
}

@test "_sf_c_f" {
  skip
}

@test "_sf_c_g" {
  skip
}

@test "_sf_c_h" {
  skip
}

@test "_sf_c_i" {
  skip
}

@test "_sf_c_j" {
  skip
}

@test "_sf_c_k" {
  skip
}

@test "_sf_c_l" {
  skip
}

@test "_sf_c_m" {
  skip
}

@test "_sf_c_n" {
  skip
}

@test "_sf_c_o" {
  skip
}

@test "_sf_c_p" {
  skip
}

@test "_sf_c_q" {
  skip
}

@test "_sf_c_r" {
  skip
}

@test "_sf_c_s" {
  skip
}

@test "_sf_c_t" {
  skip
}

@test "_sf_c_u" {
  skip
}

@test "_sf_c_v" {
  skip
}

@test "_sf_c_w" {
  skip
}

@test "_sf_c_x" {
  skip
}

@test "_sf_c_y" {
  skip
}

@test "_sf_c_z" {
  skip
}

@test "_sf_esc" {
  skip
}

@test "_sf_space" {
  skip
}

@test "_sf_enter" {
  skip
}

@test "_sf_slash" {
  skip
}

@test "_sf_push" {
  skip
}

@test "_sf_main" {
  skip
}

