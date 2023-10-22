# analysis_setup
analysis_setup<-readr::read_delim(analysis_setup_file,delim='\t')
analysis_setup<-setNames(as.list(analysis_setup$value), analysis_setup$param)
# read input VCFs
input_vcfs_dir<-list.files(analysis_setup$input_vcfs_path,recursive = T,full.names = T,pattern = '.*vcf.gz$')
input_vcfs<-data.frame(name=stringr::str_replace(basename(input_vcfs_dir),'.vcf.gz',''),
                       file=input_vcfs_dir)
