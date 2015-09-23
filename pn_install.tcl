#!/usr/bin/tclsh
lappend auto_path /home/shubha/PN_INS 
package require gw
package require utils
package require unit
package require postIns
#puts $auto_path 
#############################################################
### Procedure for Installation of UNITS #####################

if { $argc != 2 } {
        puts "The pn_install.tcl script requires two numbers to be inputed."
        puts "For example, tclsh pn_install < Buid Number i.e. PN422_SRV_LNX_20150624_0918_440 > <userfile e.g. ./userFiles/bgl.txt>"
        puts "Please try again."
        exit
    }
set fName [lindex $argv 1]
set ipAdd [ utils::getValue "gwIp" "$fName"] 
puts $fName
puts $ipAdd
gw::install "$ipAdd" "[lindex $argv 0]" "$fName"
#set db [ postIns::db_pwd ]
#puts "pwd is $db"
unit::install "10.76.82.102" "[lindex $argv 0]" "$fName"
unit::install "10.76.82.103" "[lindex $argv 0]" "$fName"

