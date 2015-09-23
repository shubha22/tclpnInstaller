#!/usr/bin/tclsh
package require Expect
package require Tcl

namespace eval utils {
     set version 0.1
 }
proc utils::rfile { } {
  set infile [open "file.txt" r]
  # read the line till eof 
  while { [ gets	$infile line ] >= 0 } {
   if { [ string first "#" $line ] != 0 } {
     set val [ split $line ":" ]
     set varName [lindex $val 0]
     set varVal [lindex $val 1]
     puts "\nVariable name is => $varName"
     puts "\nVariable val is => $varVal"
   }
  } 
}


proc utils::getval  { varname } {
puts "its ok"

}

proc utils::getValue { vName fName} {
  #set infile [open "./userFile/10.76.80.251.txt" r]
  set infile [open "$fName" r]
  set varName $vName
  # read the line till eof
  while { [ gets $infile line ] >= 0 } {
   if { [ string first "#" $line ] != 0 } {
     set val [ split $line ":" ]
     set val_0 [lindex $val 0]
     if { [ string equal -length -1 $val_0 $varName ] } {
      set varVal [lindex $val 1]
      #puts "\nVariable name is => $varName  Variable val is => $varVal"
      return $varVal
     }
   }
  }
} 

#set ora_home [ utils::getValue "oracleHome" ]
#puts "ora home : $ora_home"

#utils::rfile

package provide utils $utils::version
