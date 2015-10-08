#!/usr/bin/tclsh
#lappend auto_path /home/shubha/PN_INS
#package require server
package require Expect
package require Tcl

namespace eval postIns {
     set version 0.1
}
 
################################################################################
##POST installation script i						    ####
##1. Executing cre_dbf.sql                                                  ####          
##2. Execute : add_emdb_storage.pl                                          ####
##3. Update the max allowed connections to the gateway:                     ####      
##4. Run the following to change the default registry values:               ####    
##5. Increased max threads to 700 (added since 4.1):i                       ####
##6. Run the following to increase AVM35, AVM0 and AVM11 allocated memory:  ####
################################################################################
################################################################################

#log_user 0
#exp_internal 1
puts "\nIn postIns"

proc postIns::db_pwd { } {
#Get thse password of :
#su - pn421
#cd /export/home/pn421/Main/scripts
#./runRegTool.sh localhost get persistency/general/EmbeddedDBSystemPass
#
  spawn su - pn421
  expect "% $"
  send "cd /export/home/pn421/Main/scripts\r"
  expect "% $"
  send "./runRegTool.sh localhost get persistency/general/EmbeddedDBSystemPass\r"
  expect "*CORRECT* "
  send "y \r"
  expect "% $"
  #set db_pwd $expect_out(buffer)
  set lines [split $expect_out(buffer) \n]
  set db_pwd [lindex $lines 1]
  return $db_pwd
  send "exit \r"
}

proc cre_dbf { user pwd } {
# Executing cre_dbf.sql
#
#1. cp cre_dbf_pn421.sql /export/home/oracle/cre_dbf.sql
#2. su – oracle
#3. sqlplus <user>/<pwd>
  puts "\n user :  $user   pwd : $pwd"
  spawn su - oracle
  expect "oracle*"
  #cp /home/shubha/cre_dbf_pn421.sql abc.sql  
  #chown oracle:dba abc.sql
  send "sqlplus $user/$pwd \r"
  expect "SQL>"
  send "@abc.sql \r"
  expect "SQL>"
}

proc add_emdb { } {
#Execute : add_emdb_storage.pl
#su - pn421 
#cd Main/scripts/embedded_db/ 
#add_emdb_storage.pl < Need to be interactive >
  spawn su - pn421
  expect "% $"
  send "cd Main/scripts/embedded_db/\r"
  expect "% $"
  #send "add_emdb_storage.pl \r"
  #expect "% $" 
  puts "Executing add_emdb"	
}
proc max_con { user num } {
  spawn su - oracle
  expect "oracle*"
  send "sqlplus $user/Admin123# \r"
  expect "SQL>"
 # send "update bosuser set ALLOWEDCONNECTIONNUMBER=$num; \r"
 # expect "SQL>"
 #send "commit; \r"
 # expect "SQL>"
 puts "\nuser : $user num : $num"
}

proc run_reg { } {
  spawn su - pn421
  expect "% $"
  send "cd /export/home/pn421/Main/scripts\r"
  expect "% $"
  send "./runRegTool.sh -gs 127.0.0.1 set 0.0.0.0 site/mmvm/services/bqlServer/allowRemoteUnsecured  true \r"
  expect "*CORRECT* "
  send "y \r"
  expect "% $"
  send "./runRegTool.sh -gs 127.0.0.1 set 0.0.0.0 trap/agents/trap/generators/snmp-generator/proxy_mode true \r"
  expect "*CORRECT* "
  send "y \r"
  expect "% $"
  send "./runRegTool.sh -gs 127.0.0.1 set 0.0.0.0 cvm/information/client/TomSawyerConfig/antiAliasing false \r"
  expect "*CORRECT* "
  send "y \r"
  expect "% $"
  send "./runRegTool.sh -gs 127.0.0.1 set 0.0.0.0 site/eventmanager/types/\"layer 2 tunnel down\"/\"layer 2 tunnel down\"/default eventmanager/templates/sub-event/ignore-template \r"
  expect "*CORRECT* "
  send "y \r"
  expect "% $"
  send "./runRegTool.sh -gs 127.0.0.1 set 127.0.0.1 avm11/services/plugin/BosManagePlugin/defaultSettings/defaultPollingMode 2 \r"
  expect "*CORRECT* "
  send "y \r"
  expect "% $"
  send "./runRegTool.sh -gs 127.0.0.1 set 0.0.0.0 active-ticket-archive-threshold/ticketRnedThresholdAmount 50000 \r"
  expect "*CORRECT* "
  send "y \r"
  expect "% $"
  send "./runRegTool.sh -gs localhost set 0.0.0.0 site/mmvm/services/scheduler/maxThreads/main 700 \r"
  expect "*CORRECT* "
  send "y \r"
  expect "% $"
  send "././runRegTool.sh -gs 127.0.0.1 set 127.0.0.1 \"avm99/services/bsm/avm35/maxmem\" 30000 \r"
  expect "*CORRECT* "
  send "y \r"
  expect "% $"
  send "./runRegTool.sh -gs 127.0.0.1 set 127.0.0.1 \"avm99/services/bsm/avm0/maxmem\" 2000 \r"
  expect "*CORRECT* "
  send "y \r"
  expect "% $"
  send "./runRegTool.sh -gs 127.0.0.1 set 127.0.0.1 \"avm99/services/bsm/avm11/maxmem\" 10000 \r"
  expect "*CORRECT* "
  send "y \r"
  expect "% $"
  send "./runRegTool.sh -gs localhost add 0.0.0.0 \"site/ciscorouter2/ciscoASR1002/ipcore/software versions/startswith 03.12\" \r"
  expect "*CORRECT* "
  send "y \r"
  expect "% $"
  send "./runRegTool.sh -gs localhost set 0.0.0.0 \"site/ciscorouter2/ciscoASR1002/ipcore/software versions/startswith 03.12/default\" \"site/ciscorouter2/ciscoASR1002/ipcore/software versions/gt 15.4(3)S\" \r"
  expect "*CORRECT* "
  send "y \r"
  expect "% $"
  send "./runRegTool.sh -gs localhost add 0.0.0.0 \"site/ciscorouter2/ciscoASR1002/ipcore/software versions/startswith 03.13\" \r"
  expect "*CORRECT* "
  send "y \r"
  expect "% $"
  send "./runRegTool.sh -gs localhost set 0.0.0.0 \"site/ciscorouter2/ciscoASR1002/ipcore/software versions/startswith 03.13/default\" \"site/ciscorouter2/ciscoASR1002/ipcore/software versions/gt 15.4(3)S\" \r"
  expect "*CORRECT* "
  send "y \r"
  expect "% $"
}
### Building the main flow 
if { 0 } {
set user "system"
set pwd [ db_pwd ]
set ana_user_name "pn421"
set timeout -1
puts "\n+++++++++++++++++++++++++++++++++++"
puts "\n Executing cre_dbf.sql script "
#cre_dbf $user $pwd
puts "\n Executing add_emdb_storage.pl "
#add_emdb
puts "\n Update the max allowed connections to the gateway: "
#max_con $ana_user_name 400
puts "\n Modifying registry values"
run_reg
puts "\n+++++++++++++++++++++++++++++++++++"
}


package provide postIns $postIns::version
