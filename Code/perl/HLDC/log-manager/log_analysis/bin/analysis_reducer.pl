#!/usr/bin/perl
use strict;

my $m_0_1_S_count=0;
my $m_0_1_F_count=0;

my $m_1_15_S_count=0;
my $m_1_15_F_count=0;

my $m_15_3_S_count=0;
my $m_15_3_F_count=0;

my $m_3_S_count=0;
my $m_3_F_count=0;


my $r_0_2_S_count=0;
my $r_0_2_F_count=0;

my $r_2_3_S_count=0;
my $r_2_3_F_count=0;

my $r_3_4_S_count=0;
my $r_3_4_F_count=0;

my $r_4_S_count=0;
my $r_4_F_count=0;


while(<>){
		chomp();
		my @elems = split(/\t/,$_);
		my $type = $elems[0];
		my $pmem = $elems[7];
		my $status = $elems[6];
		
		if($type eq "MAP"){
			if($status eq "SUCCEEDED"){
				if($pmem < 1){
					$m_0_1_S_count++;
				}elsif($pmem >=1 &&$pmem < 1.5){
					$m_1_15_S_count++;
				}elsif($pmem >=1.5 && $pmem <3){
					$m_15_3_S_count++;
				}else{
					$m_3_S_count++;
				}
			}else {
				if($pmem < 1){
					$m_0_1_F_count++;
				}elsif($pmem >= 1 && $pmem <1.5){
					$m_1_15_F_count++;
				}elsif($pmem >=1.5 && $pmem <3){
					$m_15_3_F_count++;
				}else{
					$m_3_F_count++;
				}
			}
			
		}else{
			if($status eq "SUCCEEDED"){
				if($pmem < 2){
					$r_0_2_S_count++;
				}elsif($pmem >= 2 && $pmem <3){
					$r_2_3_S_count++;
				}elsif($pmem >=3 && $pmem <4){
					$r_3_4_S_count++;
				}else{
					$r_4_S_count++;
				}
			}else {
				if($pmem < 2){
					$r_0_2_F_count++;
				}elsif($pmem >=2 && $pmem <3){
					$r_2_3_F_count++;
				}elsif($pmem >=3 && $pmem <4){
					$r_3_4_F_count++;
				}else{
					$r_4_F_count++;
				}
			}
		}
		
}
my $m_0_1_total = $m_0_1_S_count + $m_0_1_F_count;
my $m_1_15_total = $m_1_15_S_count + $m_1_15_F_count;
my $m_15_3_total = $m_15_3_S_count + $m_15_3_F_count;
my $m_3_total = $m_3_S_count + $m_3_F_count;
my $map_total = $m_0_1_total + $m_1_15_total + $m_15_3_total + $m_3_total;

my $r_0_2_total = $r_0_2_S_count + $r_0_2_F_count;
my $r_2_3_total = $r_2_3_S_count + $r_2_3_F_count;
my $r_3_4_total = $r_3_4_S_count + $r_3_4_F_count;
my $r_4_total = $r_4_S_count + $r_4_F_count;
my $reduce_total = $r_0_2_total + $r_2_3_total + $r_3_4_total + $r_4_total;


my $map_success = $m_0_1_S_count + $m_1_15_S_count + $m_15_3_S_count + $m_3_S_count;
my $map_failed = $m_0_1_F_count + $m_1_15_F_count + $m_15_3_F_count + $m_3_F_count;

my $reduce_success = $r_0_2_S_count + $r_2_3_S_count + $r_3_4_S_count + $r_4_S_count;
my $reduce_failed = $r_0_2_F_count + $r_2_3_F_count + $r_3_4_F_count + $r_4_F_count;


 
print "-----------------------------------------------------------------------------------------------------------------------\n";
print "                        Hadoop  Map_Reduce Physical MemoryUsed Analysis Table     \n";
print "-----------------------------------------------------------------------------------------------------------------------\n";
print "        |    0~1 GB     |    1~1.5GB    |   1.5~3 GB    |     >3 GB     |     Total   |            Ratio            \n";
print "        ---------------------------------------------------------------------------------------------------------------\n";
printf "        |  S  |%8d |  S  |%8d |  S  |%8d |  S  |%8d |  %9d  |%6.2f%|%6.2f%|%6.2f%|%6.2f%|\n",$m_0_1_S_count,$m_1_15_S_count,$m_15_3_S_count,$m_3_S_count,$map_success,$map_success==0? 0:$m_0_1_S_count/$map_success*100,$map_success==0? 0:$m_1_15_S_count/$map_success*100,$map_success==0? 0:$m_15_3_S_count/$map_success*100,$map_success==0? 0:$m_3_S_count/$map_success*100;
print "   MAP  ---------------------------------------------------------------------------------------------------------------\n";
printf "        |  F  |%8d |  F  |%8d |  F  |%8d |  F  |%8d |  %9d  |%6.2f%|%6.2f%|%6.2f%|%6.2f%|\n",$m_0_1_F_count,$m_1_15_F_count,$m_15_3_F_count,$m_3_F_count,$map_failed,$map_failed==0? 0:$m_0_1_F_count/$map_failed*100,$map_failed==0? 0:$m_1_15_F_count/$map_failed*100,$map_failed==0? 0:$m_15_3_F_count/$map_failed*100,$map_failed==0? 0:$m_3_F_count/$map_failed*100;
print "        ---------------------------------------------------------------------------------------------------------------\n";
printf "        |m_01t|%8d |m_12t|%8d |m_23t|%8d |m_3_t|%8d |  %9d  |%6.2f%|%6.2f%|%6.2f%|%6.2f%|\n",$m_0_1_total ,$m_1_15_total,$m_15_3_total,$m_3_total,$map_total,$map_total==0 ? 0:$m_0_1_total/$map_total*100,$map_total==0 ? 0:$m_1_15_total/$map_total*100,$map_total==0 ? 0:$m_15_3_total/$map_total*100,$map_total==0 ? 0:$m_3_total/$map_total*100;
print "-----------------------------------------------------------------------------------------------------------------------\n";
printf " S/Total|        %6.2f%|        %6.2f%|        %6.2f%|        %6.2f%|      %6.2f%|                       \n",$m_0_1_total==0 ? 0:$m_0_1_S_count/$m_0_1_total*100,$m_1_15_total==0 ? 0:$m_1_15_S_count/$m_1_15_total*100,$m_15_3_total==0 ? 0:$m_15_3_S_count/$m_15_3_total*100,$m_3_total==0 ? 0:$m_3_S_count/$m_3_total*100,$map_total==0 ? 0:$map_success/$map_total*100;
print "-----------------------------------------------------------------------------------------------------------------------\n";
print "-----------------------------------------------------------------------------------------------------------------------\n";
print "        |    0~2 GB     |    2~3 GB     |    3~4 GB     |     >4 GB     |     Total   |            Ratio            \n";
print "        ---------------------------------------------------------------------------------------------------------------\n";
printf "        |  S  |%8d |  S  |%8d |  S  |%8d |  S  |%8d |  %9d  |%6.2f%|%6.2f%|%6.2f%|%6.2f%|\n",$r_0_2_S_count,$r_2_3_S_count,$r_3_4_S_count,$r_4_S_count,$reduce_success,$reduce_success==0 ? 0:$r_0_2_S_count/$reduce_success*100,$reduce_success==0 ? 0:$r_2_3_S_count/$reduce_success*100,$reduce_success==0 ? 0:$r_3_4_S_count/$reduce_success*100,$reduce_success==0 ? 0:$r_4_S_count/$reduce_success*100;
print " REDUCE ---------------------------------------------------------------------------------------------------------------\n";
printf "        |  F  |%8d |  F  |%8d |  F  |%8d |  F  |%8d |  %9d  |%6.2f%|%6.2f%|%6.2f%|%6.2f%|\n",$r_0_2_F_count,$r_2_3_F_count,$r_3_4_F_count,$r_4_F_count,$reduce_failed,$reduce_failed==0 ? 0:$r_0_2_F_count/$reduce_failed*100,$reduce_failed==0 ? 0:$r_2_3_F_count/$reduce_failed*100,$reduce_failed==0 ? 0:$r_3_4_F_count/$reduce_failed*100,$reduce_failed==0 ? 0:$r_4_F_count/$reduce_failed*100;
print "        ---------------------------------------------------------------------------------------------------------------\n";
printf "        |r_02t|%8d |r_23t|%8d |r_34|%8d |r_4_t|%8d |  %9d  |%6.2f%|%6.2f%|%6.2f%|%6.2f%|\n",$r_0_2_total,$r_2_3_total,$r_3_4_total,$r_4_total,$reduce_total,$reduce_total==0 ? 0:$r_0_2_total/$reduce_total*100,$reduce_total==0 ? 0:$r_2_3_total/$reduce_total*100,$reduce_total==0 ? 0:$r_3_4_total/$reduce_total*100,$reduce_total==0 ? 0:$r_4_total/$reduce_total*100;
print "-----------------------------------------------------------------------------------------------------------------------\n";
printf " S/Total|        %6.2f%|        %6.2f%|        %6.2f%|        %6.2f%|      %6.2f%|                       \n",$r_0_2_total==0 ? 0:$r_0_2_S_count/$r_0_2_total*100 ,$r_2_3_total==0 ? 0:$r_2_3_S_count/$r_2_3_total*100,$r_3_4_total==0 ? 0:$r_3_4_S_count/$r_3_4_total*100,$r_4_total==0 ? 0:$r_4_S_count/$r_4_total*100,$reduce_total==0 ? 0:$reduce_success/$reduce_total*100;
print "-----------------------------------------------------------------------------------------------------------------------\n";
