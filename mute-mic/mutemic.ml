(* amixer seems to work fine for distro:
     PRETTY_NAME="Ubuntu 24.04.2 LTS"
     NAME="Ubuntu"
     VERSION_ID="24.04"
     VERSION="24.04.2 LTS (Noble Numbat)"
     VERSION_CODENAME=noble
     ID=ubuntu
     ID_LIKE=debian
     HOME_URL="https://www.ubuntu.com/"
     SUPPORT_URL="https://help.ubuntu.com/"
     BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
     PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
     UBUNTU_CODENAME=noble
     LOGO=ubuntu-logo *)

type state = Muted | Unmuted

let mic_state_to_string = function Muted -> "MUTED" | Unmuted -> "UNMUTED"
let run_cmd cmd = match Sys.command cmd with 0 -> true | _ -> false

let mutemic_linux mic_state =
  let os = "Linux" in
  let cmd, output =
    match mic_state with
    | Muted -> ("amixer set Capture nocap", "mic successfully muted")
    | Unmuted -> ("amixer set Capture cap", "mic successfully unmuted")
  in
  if run_cmd cmd then
    Printf.printf "[%s] %s (%s)\n" os output (mic_state_to_string mic_state)
  else
    Printf.printf "[%s] Failed to change mic state: %s\n" os
      (mic_state_to_string mic_state)

let mutemic_macos mic_state =
  let os = "MacOS" in
  let cmd =
    match mic_state with
    | Muted -> "osascript -e 'set volume input muted true'"
    | Unmuted -> "osascript -e 'set volume input muted false'"
  in
  if run_cmd cmd then
    Printf.printf "[%s] Mic successfully %s\n" os
      (mic_state_to_string mic_state)
  else
    Printf.printf "[%s] Failed to change mic state: %s\n" os
      (mic_state_to_string mic_state)

let mutemic mic_state =
  match Sys.os_type with
  | "Unix" -> mutemic_linux mic_state
  | "MacOS" -> mutemic_macos mic_state
  | os -> Printf.printf "Unsupported OS: %s\n" os

let print_help () =
  let help_text =
    {|
NAME
    mutemic - mutes or unmutes the microphone.

SYNOPSIS
    mutemic [OPTION]

DESCRIPTION
    -u, --unmute
        Unmute the microphone.

    --no-unmute
        Mute the microphone. Same as running with no arguments.

    -h, --help
        Display this help message.
|}
  in
  print_endline help_text

let () =
  if Array.length Sys.argv = 1 then mutemic Muted
  else
    match Sys.argv.(1) with
    | "" | "--no-unmute" -> mutemic Unmuted
    | "-u" | "--unmute" -> mutemic Unmuted
    | "-h" | "--help" -> print_help ()
    | arg -> Printf.eprintf "Unexpected argument: %s\n" arg
