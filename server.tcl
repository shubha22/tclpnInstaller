#!/usr/bin/tclsh
package require Expect 
package require Tcl

namespace eval server {
     set version 0.1
 }

puts "hello Shubhadeep lets start "

proc server::ssh_login { i u p } {
 set ipAdd $i
 set uName $u
 set pWord $p
 set timeout -1
 spawn ssh $uName@$ipAdd
 set sid $spawn_id	
 expect -exact  "root@$ipAdd's password: "  # Need to add proper expression
 send "$pWord\r"
 expect -re "# $"
 return $sid
 }
proc server::send_cmd { cmd sid} {
 set timeout -1 
 set spawn_id  $sid
 exp_send "$cmd \r"
 expect -re "# $"
 }

proc server::cp_DBfile { sid } {
 set timeout -1 
 set dbFileLocation "/DB_files"
 set spawn_id  $sid
 exp_send "cd $dbFileLocation \r"
 expect -re "# $"
 exp_send "cp -r *.zip /export/home/pn422/local/scripts/embedded_oracle/ \r"
 expect -re "# $"
 close -i $spawn_id
 }
package provide server $server::version
#ssh_login "172.18.79.18" "root" "cisco123"
