#' tidyVIF
#' @param modelObject A model object
#' @import dplyr ggplot2
#' @importFrom car vif
#' @importFrom stringr str_extract
#' @return plot of VIF
#' @export

tidyVIF<-function(modelObject){
  car..vif.modelObject.<-NULL
  VAR<-NULL
  VIFs<-NULL
  vifs <- data.frame(car::vif(modelObject))
   vifs%>%
    mutate(VAR=row.names(vifs))%>%
     mutate(VAR= stringr::str_extract(string=VAR, pattern = "(?<=\\().*(?=\\))"))%>%
     mutate(VAR=gsub("\\):scale\\(",":", VAR),
            VIFs=car..vif.modelObject.)%>%
     ggplot()+geom_point(aes(x=VAR, y=VIFs))+
     geom_hline(yintercept = 2, linetype="dashed", col="red")+
     theme_bw()+
     ylab("VIF")+
     xlab("Variable")+
     theme(axis.text.x = element_text(angle = 90))

}
