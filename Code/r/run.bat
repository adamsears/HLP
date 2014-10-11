:: R CMD BATCH --vanilla --slave .\mem_fail_percent.R .\out\mem_fail_percent.txt

:: test script
:: cd .\test
:: Rscript.exe .\test.R
:: cd ..

:: Fail Task Percent By Memory Error
cd .\mem_fail_percent
Rscript.exe .\mem_fail_percent.R
cd ..
rem Rscript.exe

cd .\time_ratio
Rscript.exe .\time_ratio.R
cd ..

cd .\mem_time_1min
Rscript.exe .\mem_time_1min.R
cd ..

cd .\queue_capacity_used
Rscript.exe .\queue_capacity_used.R
cd ..

cd .\mapred_set_analysis
Rscript.exe .\mapred_set_analysis.R
cd ..

cd .\user_queue_ratio
Rscript.exe .\user_queue_ratio.R
cd ..

cd .\hdfs_report
Rscript.exe .\hdfs_report.R
cd ..

cd .\cluster_usage_report
Rscript.exe .\cluster_usage_report.R
cd ..