onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /program/main_clk
add wave -noupdate /program/main_reset
add wave -noupdate -radix unsigned /program/ALU_DATA_INPUT_A
add wave -noupdate -radix unsigned /program/ALU_DATA_INPUT_B
add wave -noupdate -radix unsigned /program/ALU_DATA_OUTPUT
add wave -noupdate /program/Salu
add wave -noupdate -radix unsigned /program/REGISTER_DATA_INPUT
add wave -noupdate -radix unsigned /program/RAM_DATA
add wave -noupdate -radix unsigned /program/RAM_ADRESS_INPUT
add wave -noupdate -radix unsigned /program/REGISTER_ADRESS_OUTPUT
add wave -noupdate /program/S_ALU_A
add wave -noupdate /program/S_ALU_B
add wave -noupdate /program/S_ALU_Y
add wave -noupdate /program/Sid
add wave -noupdate /program/Sadr
add wave -noupdate /program/WR_FromBusint
add wave -noupdate /program/RD_FromBusInt
add wave -noupdate /program/Smar
add wave -noupdate /program/Smbr
add wave -noupdate /program/CONTROL_1/state
add wave -noupdate -radix unsigned /program/IR
add wave -noupdate -radix unsigned /program/REGISTER_1/line__22/PC
add wave -noupdate -radix unsigned /program/REGISTER_1/line__22/TMP
add wave -noupdate -radix unsigned /program/REGISTER_1/line__22/A
add wave -noupdate /program/REGISTER_1/line__22/SP
add wave -noupdate /program/main_clk
add wave -noupdate /program/main_reset
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 282
configure wave -valuecolwidth 191
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {839 ps}
view wave 
wave clipboard store
wave create -driver freeze -pattern clock -initialvalue 0 -period 20ps -dutycycle 50 -starttime 0ps -endtime 1000ps sim:/program/main_clk 
wave modify -driver freeze -pattern clock -initialvalue 0 -period 50ps -dutycycle 50 -starttime 0ps -endtime 1000ps Edit:/program/main_clk 
wave create -driver freeze -pattern clock -initialvalue 0 -period 25ps -dutycycle 50 -starttime 0ps -endtime 1000ps sim:/program/ram_clk 
wave create -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 1000ps sim:/program/main_reset 
wave modify -driver freeze -pattern constant -value 1 -starttime 0ps -endtime 50ps Edit:/program/main_reset 
wave modify -driver freeze -pattern clock -initialvalue 0 -period 50ps -dutycycle 50 -starttime 0ps -endtime 10000ps Edit:/program/main_clk 
wave modify -driver freeze -pattern constant -value 0 -starttime 50ps -endtime 10000ps Edit:/program/main_reset 
WaveCollapseAll -1
wave clipboard restore
