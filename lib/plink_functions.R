# a function that takes in a vcf file and converts it into the plink binary files
vcf_to_plink_bfiles<-function(plink_path,vcf_file,bfiles_prefix,build){
  make_bed_command<-glue('{plink_path} --vcf {vcf_file} --make-bed --split-x "{build}" --out {bfiles_prefix}')
  command_output<-system(make_bed_command,intern = T)
  return(command_output)
}

# run plink's check-sex command on the bfiles generated after the split-x command was ran. 
# the male and female thresh should be set according to the dataset (so should be ran twice, once to get the F stats and second to set the threshs)
# gender is calculated by if F<female_thresh than female (2) and if F higher than male threshold than male (1)
run_plink_check_sex<-function(plink_path,bfiles_prefix,female_thresh=0.2,male_thresh=0.8){
  # first get the F stats
  check_sex_command<-glue('{plink_path} --check-sex {female_thresh} {male_thresh} --bfile {bfiles_prefix} --out {bfiles_prefix}')
  system(check_sex_command)
}

parse_plink_check_sex_output<-function(check_sex_output_file){
  check_sex_output<-readr::read_table(check_sex_output_file)
  check_sex_output%>%count(SNPSEX)
  return(check_sex_output)
}

check_for_gender_outliers<-function(check_sex_output){
  # calculate Z score
  check_sex_output<-check_sex_output%>%group_by(SNPSEX)%>%reframe(id=IID,F=F,z=(F-mean(F))/sd(F))
  check_sex_output<-check_sex_output%>%mutate(outlier=abs(z)>1.96)
  return(check_sex_output)
}