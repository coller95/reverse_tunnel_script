#!/usr/bin/expect -f
set timeout -1
set USERNAMEID [lindex $argv 0];
set PORT_REVERSE [lindex $argv 1];
set PubFile /home/jumpserver/$USERNAMEID.pub
set prompt "#|%|>|\\\$ $"
spawn mkdir -p ./keys/$USERNAMEID/key
spawn mkdir -p ./keys/$USERNAMEID/port
spawn touch ./keys/$USERNAMEID/port/$PORT_REVERSE
spawn ssh-keygen -t rsa -b 4096 -N "" -f ./keys/$USERNAMEID/key/$USERNAMEID
expect {
        "*:~$ ";exp_continue
        -re $prompt 
}
spawn scp -P 40000 -i login/login ./keys/$USERNAMEID/key/$USERNAMEID.pub jumpserver@xxxxxx.com:/home/jumpserver/.
expect {
        "*:~$ ";exp_continue
        -re $prompt 
}
spawn ssh -i ./login/login -p 40000 jumpserver@xxxxxx.com
send "sudo useradd -m -d /home/$USERNAMEID -s /bin/bash $USERNAMEID \r"
expect "*password for jumpserver: "
send "password\r"
expect {
	"*:~$ ";exp_continue
	-re $prompt 
}
send "sudo mkdir -p /home/$USERNAMEID/.ssh \r"
send "sudo chmod 0700 /home/$USERNAMEID/.ssh \r"
send "sudo chown $USERNAMEID /home/$USERNAMEID/.ssh \r"
send "sudo chgrp $USERNAMEID /home/$USERNAMEID/.ssh \r"
send "sudo mv /home/jumpserver/$USERNAMEID.pub /home/$USERNAMEID/.ssh/authorized_keys \r"
send "sudo chmod 0600 /home/$USERNAMEID/.ssh/authorized_keys \r"
send "sudo chown $USERNAMEID /home/$USERNAMEID/.ssh/authorized_keys \r"
send "sudo chgrp $USERNAMEID /home/$USERNAMEID/.ssh/authorized_keys \r"
send "exit\r"
expect eof
