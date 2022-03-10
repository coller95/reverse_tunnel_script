#!/usr/bin/expect -f
set timeout -1
set USERNAMEID [lindex $argv 0];
set PubFile /home/jumpserver/$USERNAMEID.pub
set prompt "#|%|>|\\\$ $"
spawn ssh -i ./login/login -p 40000 jumpserver@xxxxxx.com
expect {
        "*:~$ ";exp_continue
        -re $prompt 
}
send "sudo userdel $USERNAMEID \r"
expect "*password for jumpserver: "
send "password\r"
expect {
	"*:~$ ";exp_continue
	-re $prompt 
}
send "sudo rm -rf /home/$USERNAMEID \r"
send "exit\r"
expect eof
