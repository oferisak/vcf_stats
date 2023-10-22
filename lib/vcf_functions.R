merge_vcfs<-function(bcftools_path,vcf_files,output_folder,merged_file_prefix){
  bcftools_merge_command<-glue('{bcftools_path} merge {paste0(vcf_files,collapse=" ")} > {output_folder}/{merged_file_prefix}.vcf')
  # run merge command
  message(glue('Running {bcftools_merge_command}'))
  system(bcftools_merge_command)
  message(glue('BGZip {merged_file_prefix}.vcf'))
  system(glue('bgzip {output_folder}/{merged_file_prefix}.vcf'))
  message(glue('indexing {merged_file_prefix}.vcf.gz'))
  system(glue('tabix {output_folder}/{merged_file_prefix}.vcf.gz'))
  return(as.character(glue('{output_folder}/{merged_file_prefix}.vcf.gz')))
}

vcf_to_tidy<-function(input_vcf,format_fields=c('GT','AD','DP')){
  input_vcfR<-read.vcfR(input_vcf)
  merged_cohort_tidy<-vcfR2tidy(
    input_vcfR,
    format_fields = format_fields,
    format_types = TRUE
  )
  return(merged_cohort_tidy)
}