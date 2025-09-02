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

type msg = Unmuted | Muted

let handle_msg = function
    | Muted   -> "MUTED"
    | Unmuted -> "UNMUTED"


let mutemic_linux mute_flag =
    let os = "Linux" in
    let mutemsg = if mute_flag then Muted else Unmuted in

    let cmd = if mute_flag then "amixer set Capture nocap"
              else "amixer set Capture cap" 
    in

    let status = Sys.command cmd in

    print_endline "";
    if status = 0 then
        Printf.printf "[%s] Mic successfully %s\n" os (handle_msg mutemsg)
    else
        Printf.printf "[%s] Mic failed to: %s\n" os (handle_msg mutemsg)
;;

let mutemic_macos mute_flag =
    failwith "Not implemented."

let mute_microphone mute =
    let os = Sys.os_type in
    match os with
    | "Unix" -> mutemic_linux mute
    | "MacOS" -> mutemic_macos mute
    | _ -> failwith "Unsupported OS: %s\n"
;;

let help_msg =
    let msg = 
        "NAME\n"
        ^ "\tmutemic - mutes or unmutes mic\n"
        ^ "SYNOPSIS\n"
        ^ "\t mutemic [OPTION]\n"
        ^ "DESCRIPTION\n"
        ^ "\t-u, --unmute\n"
        ^ "\t\t unmutes the mic\n"
        ^ "\t-h, --help\n"
        ^ "\t\t prints this message\n"
        ^ "\t--no-unmute\n"
        ^ "\t\t unmutes the mic. Same as when running with no args.\n"
    in
    print_endline msg
;;


let () =
    if Array.length Sys.argv = 1 then
        mute_microphone true
    else
        let arg = Sys.argv.(1) in
        match arg with
        | ""            -> mute_microphone true
        | "-h"          -> help_msg
        | "--help"      -> help_msg
        | "--no-unmute" -> mute_microphone true
        | "-u"          -> mute_microphone false
        | "--unmute"    -> mute_microphone false
        | _             -> Printf.eprintf "Unexpected err. Arg: %s" arg
