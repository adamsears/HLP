===================================================================
#                                                                 #
#                Thank you for reading this file                  #
#          This is a Map_Red Analysis proccess Documents          #
#                         @author yaxu                            #
#                    email: yaxu@iflytek.com                      #
===================================================================

1.File folder:
	--- log-analysis/
	------
	--- log-analysis/bin/              #which includes all map-reduce perl scripts.
	--- log-analysis/sbin/             #which includes all hadoop streaming scripts,with number ahead can be executed in numerical order (others should test)
	--- log-analysis/readme.txt        #what you have just read, a brief introduction.


2.we now present a automatic perl script "run_analysis.pl"
        ------
        ---log-analysis/sbin/run_analysis.pl

        all the other test procedure have been put in ---log-analysis/sbin/test
	#if you want run them one by one ,please reput them in ---log-analysis/sbin and change#
	#some values.#

3.Hadoop streaming procedure:
  
  Streaming procedure now is : {<1>&<2>&<3>} ==>    {<4>}   ==>   {<5>||<6>}     ==>      {<7>} 
                                Extract Procedure        Union Procedure             Analysis Procedure
	<1> Extract memory used info from HDFS:
			inputfile  :   "/logfile/*.tar.gz"                         
			mapper     :   "cat_mapper.pl"                   
			reducer    :   "get_container_max_reducer.pl"       
			outputfile :   /yaxu/1_mem_ext_out/                      
    Hadoop Streaming Command : log-manager/sbin/1_mem_ext.sh
    
  <2> Extract jhist info from HDFS:
			inputfile  :   "/logfile/jhist/"        ##only mapred_jobhistory file                 
			mapper     :   "jhist_mapper.pl"    
			reducer    :   "jhist_reducer.pl"                
			outputfile :   /yaxu/2_jhist_ext_out/                      
    Hadoop Streaming Command : log-manager/sbin/2_jhist_ext.sh
    
    REMIND: each compute node need to install a small module of Perl -- JSON.
    
	<3> Extract jobsummary info from HDFS:
			inputfile  :   "/logfile/*.tar.gz"        ##only mapred_jobhistory file                 
			mapper     :   "job_sum_mapper.pl"                    
			outputfile :   /yaxu/3_jobsum_ext_out/                      
    Hadoop Streaming Command : log-manager/sbin/3_jobsum_ext.sh	
    
	<4> Union jhist info&mem info from HDFS:
			inputfile  :   /yaxu/1_mem_ext_out/,/yaxu/2_jhist_ext_out/                         
			mapper     :   "union_ctn_jhi_mapper.pl"     `              
			reducer    :   "union_ctn_jhi_reducer.pl"       
			outputfile :   /yaxu/4_jhist_mem_union_out/                      
    Hadoop Streaming Command : log-manager/sbin/4_jhist_mem_union.sh
    
	<5> Union task info & container info from HDFS:
			inputfile  :   /yaxu/4_jhist_mem_union_out/                         
			mapper     :   "task_mapper.pl"     `              
			reducer    :   "task_reducer.pl"       
			outputfile :   /yaxu/5_task_ctn_union_out/                     
    Hadoop Streaming Command : log-manager/sbin/5_task_container_union.sh
        
##	<6> Union memory_info&job_info from HDFS:
##			inputfile  :   "/outputtest5/,/outputtest6/"                         
##			mapper     :   "union_mapper.pl"     `                            |doesn't matter <7>
##			reducer    :   "union_reducer.pl"       
##			outputfile :   /outputtest7/                      
##    Hadoop Streaming Command : log-manager/sbin/run_union_cmd.sh
        
	<7> Analyse Map_Reduce With memory used in different scope from HDFS:
			inputfile  :   /yaxu/5_task_ctn_union_out/                        
			mapper     :   "analysis_mapper.pl"                   
			reducer    :   "analysis_reducer.pl"       
			outputfile :   /yaxu/7_analysis_mr_mem_out/                      
    Hadoop Streaming Command : log-manager/sbin/7_analysis_mr_mem.sh   

    
    
3.Soon we will give each outputfile's attribute meaning.

4.All tests on 4 nodes (1 namenode  && 3 datanode)
    
