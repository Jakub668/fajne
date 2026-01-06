@echo off
echo Uruchamianie Diskpart...
diskpart <<EOF
select disk 1
clean
create partition primary
format fs=ntfs quick
assign letter=F
exit
EOF
echo Operacja Diskpart zakończona.
diskpart <<EOF
select disk 3
clean
create partition primary
format fs=ntfs quick
assign letter=F
exit
EOF
echo Operacja Diskpart zakończona.
diskpart <<EOF
select disk 2
clean
create partition primary
format fs=ntfs quick
assign letter=F
exit
EOF
echo Operacja Diskpart zakończona.
diskpart <<EOF
select disk 4
clean
create partition primary
format fs=ntfs quick
assign letter=F
exit
EOF
echo Operacja Diskpart zakończona.
diskpart <<EOF
select disk 5
clean
create partition primary
format fs=ntfs quick
assign letter=F
exit
EOF
echo Operacja Diskpart zakończona.
pause
