# 230803  TW  New script to generate SQL table creation script from CSV data file header

# $ awk -f generate_create_or_replace_table_script.awk csv_table_name.csv > csv_table_name.sql
# $ awk -f generate_create_or_replace_table_script.awk *.csv > script.sql

BEGIN {
#	RS="\r\n";
#	ORS="\r\n";
	FS="|";
}

FNR == 1 {
	cor="CREATE OR REPLACE TABLE ";
	tablename=gensub(".csv","","g",FILENAME);
	columns=gensub(/\|/," VARCHAR, ","g",$0);
	terminator1=" (\r\n";
	terminator2=" VARCHAR\r\n)\r\n;\r\n";
	print cor tablename terminator1 columns terminator2;
	nextfile;
}
