run_king_relatedness_analysis<-function(king_path,plink_bed){
  king_relatedness_command<-glue('{king_path} -b {plink_bed} --related')
  king_output<-system(king_relatedness_command,intern = T)
  return(king_output)
}

