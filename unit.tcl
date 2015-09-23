#!/usr/bin/tclsh
lappend auto_path /home/shubha/PN_INS 
package require server
package require utils
package require Expect 
package require Tcl

namespace eval unit {
     set version 0.1 
}

proc unit::install { i bNo fNa } {
#puts $auto_path 
#############################################################
### Procedure for Installation of UNITS #####################
#############################################################
 set ipAdd $i
 set bNumber $bNo
 set fName $fNa
 set gwIp [ utils::getValue "gwIp" "$fName" ]
 set DEBUG 1
 set multipleNetwork [ utils::getValue "multipleNetwork" "$fName" ]
 set fiLocation [ utils::getValue "fiLocation" "$fName" ]
 set sid [ server::ssh_login "$ipAdd" "root" "cisco123" ]
 set spawn_id $sid
 exp_send "cd $fiLocation \r"
 expect -re "# $"
 exp_send "cd $bNumber \r"
 expect -re "# $"
 exp_send "cd image \r"
 expect -re "# $"
 exp_send "pwd \r"
 expect -re "# $"
 exp_send "perl install.pl -user pn422 -override_ports -uninstall_previous_versions \r"
 set timeout -1
 expect -re "Would you like to configure Prime Network now?"
 exp_send "\r"
 expect -re "Press Enter to choose"
 exp_send "1 \r"
 expect -re "- Enter the gateway IP address"
 exp_send "$gwIp \r"
 expect -re "- Enter the Prime Network administrator username"
 exp_send "\r" 
 expect -re "- Enter the Prime Network administrator password"
 exp_send "Admin123#\r" 
 if { $multipleNetwork } {
   puts "Multiple Network"
   expect -re "Choose"
   exp_send "1 \r"
 }
 expect -re "- Enter your choice"
 exp_send "1 \r"
 expect -re "- Is this a standby unit"
 exp_send "\r"
 expect -re "- Enter a unique name for this unit"
 exp_send "$ipAdd \r"
 expect -re "Enable Unit Protection"
 exp_send "\r"
 expect -re "Would you like to start Prime Network unit"
 exp_send "\r"
 set timeout -1
 expect -re "# $"
 set pw  $expect_out(buffer)
 puts "\n----\n $pw \n-----\n"
 #exp_send "su - pn422 \r"
 #expect -regexp "pn422@rtp6-nmtg-lnx05"
 #exp_send "network-conf \r"
 #wait 5
 #exp_send "1 \r"
 #expect -re "% $"
 
 
# server::send_cmd "ls" "$sid"
 #server::send_cmd "pwd" "$sid"
}

package provide unit $unit::version
