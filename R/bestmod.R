#' @title internal_model
#' @description A glm model of the \link[InterEco]{ants_data}
#' @format A glm model object
#' @details Call:  glmer(richness~scale(lt_clim)*scale(woody) +scale(lt_clim)*scale(perc_clay)+  scale(lt_clim)*scale(bare)+ scale(lui) +scale(exotic_grnd)  + (1|farm_id), family="poisson", data=dat)
"bestmod"
