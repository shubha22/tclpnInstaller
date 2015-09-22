#!/usr/bin/tclsh
lappend auto_path /home/shubha/PN_INS 
package require server
package require utils 
package require Expect 
package require Tcl


namespace eval gw {
     set version 0.1 
}

proc gw::install { i bNo fNa} {
#puts $auto_path 
#############################################################
### Procedure for Installation of UNITS #####################
#############################################################
 global ipAdd
 set ipAdd $i
 set bNumber $bNo
 set fName $fNa
 set fiLocation [ utils::getValue "fiLocation" "$fName" ]
 set builtInUser [ utils::getValue "builtInUser" "$fName" ]
 set osRootUser [ utils::getValue "osRootUser" "$fName" ]
 set osUserData [ utils::getValue "osUserData" "$fName" ]
 set oracleHome [ utils::getValue "oracleHome" "$fName" ]
 set dbProfile [ utils::getValue "dbProfile" "$fName" ]
 set multipleNetwork [ utils::getValue "multipleNetwork" "$fName" ] 
 set dataFiles [ utils::getValue "dataFiles" "$fName" ]
 set redoLogs [ utils::getValue "redoLogs" "$fName" ]
 set arcLogs [ utils::getValue "arcLogs" "$fName" ]
 set backLogs [ utils::getValue "backLogs" "$fName" ]
 set smtpHost [ utils::getValue "smtpHost" "$fName" ]
 set sid [ server::ssh_login "$ipAdd" "root" "cisco123" ]
 set spawn_id $sid
 exp_send "cd $fiLocation \r"
 expect -re "# $"
 exp_send "cd $bNumber \r"
 expect -re "# $"
 exp_send "cd image  \r"
 expect -re "# $"
 exp_send "pwd  \r"
 expect -re "# $"
 set timeout -1
 exp_send "perl install.pl -user pn422 -override_ports -uninstall_previous_versions \r"
 expect -re "Would you like to configure Prime Network now?"
 exp_send "yes \r"
 expect -re "Press Enter to choose"
 exp_send "2 \r "
 expect -re "- Enter the password for all built-in users:"
 exp_send "$builtInUser\r"
 expect -re "- Enter the password again for verification:"
 exp_send "$builtInUser\r"
 expect -re "Would you like Prime Network to install the database?"
 exp_send "yes \r"
 expect -re "Hit the 'Enter' key when ready to continue or 'Ctrl C' to quit" 
 #puts "+++++++++++++++++++++++++++++++++++++++++++++++++++++ "
 set sid_db [ server::ssh_login "$ipAdd" "root" "cisco123" ]
 server::cp_DBfile "$sid_db"
 #puts "+++++++++++++++++++++++++++++++++++++++++++++++++++++ "
 puts "waiting ....."
 sleep 5
 puts "Copy done .... hitting enter"
 exp_send "\r"
 expect -re "- Would you like to install the database on a remote server?"
 exp_send "no \r"
 if { $multipleNetwork } {
   puts "Multiple network"
   expect -re "Enter option:"
   exp_send "1 /r"
 }
 expect -re "- Enter the password for OS root user:"
 exp_send "$osRootUser\r"
 expect -re "- Enter a name for the OS user of the database"
 exp_send "$osUserData\r"
 expect -re "- Enter the home directory of the user"
 exp_send "$oracleHome\r"
 #Need to check if it is required or optional 
 expect -re "- Would you like to remove the database currently installed under /export/home/oracle?"
 exp_send "\r"
 expect -re "Enter option"
 exp_send "$dbProfile \r"
 expect -re " - Enter the location for the database's datafiles"
 exp_send "$dataFiles\r"
 expect -re " - Enter the location for the redo logs"
 exp_send "$redoLogs\r"
 expect -re "- Would you like Prime Network to run automatic database backups"
 exp_send "\r"
 expect -re "- Enter the destination for the archive logs"
 exp_send "$arcLogs\r"
 expect -re "- Enter the destination for the backup files"
 exp_send "$backLogs\r"
 expect -re "- Enter your SMTP server IP/Hostname"
 exp_send "$smtpHost\r"
 #exp_send "no \r"
 if { $multipleNetwork } {
   puts "Multiple network"
   expect -re "Enter option:"
   exp_send "1 /r"
 }
 expect -re "Is Prime Network being installed as part of the Prime IP-NGN Suite"
 exp_send "\r"
 expect -re "- Enter an email for receiving alerts"
 exp_send "shubsen@cisco.com \r"
 expect -re "Would you like to start Prime Network"
 exp_send "\r"
 set timeout -1 
 expect -re "# $"
  set pw $expect_out(buffer)
 puts "\n  *** \n $pw \n **** \n" 
}

package provide gw $gw::version
