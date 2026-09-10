


################################################################################
# IMPORT DATA
################################################################################


###################################
# READ IN SURVEY | DHS | PATHWAYS

# WOMAN'S RECODE
if (file.exists(paste0(data_path, config::get("dhs_ir_file")))) {
  IR <- data.table(read.dta13(file = paste0(data_path, config::get("dhs_ir_file")), fromEncoding="utf-8")) %>% dplyr::mutate(survey = config::get("survey_name"))
}

# BIRTH RECODE
if (file.exists(paste0(data_path, config::get("dhs_br_file")))) {
  BR <- data.table(read.dta13(file = paste0(data_path, config::get("dhs_br_file")), fromEncoding="utf-8")) %>% dplyr::mutate(survey = config::get("survey_name"))
}

# CHILD RECODE
if (file.exists(paste0(data_path, config::get("dhs_kr_file")))) {
  KR <- data.table(read.dta13(file = paste0(data_path, config::get("dhs_kr_file")), fromEncoding="utf-8")) %>% dplyr::mutate(survey = config::get("survey_name"))
}

# HOUSEHOLD RECODE
if (file.exists(paste0(data_path, config::get("dhs_hh_file")))) {
  HH <- data.table(read.dta13(file = paste0(data_path, config::get("dhs_hh_file")), fromEncoding="utf-8")) %>% dplyr::mutate(survey = config::get("survey_name"))
}

# MEN'S RECODE
if (file.exists(paste0(data_path, config::get("dhs_mr_file")))) {
  MR <- data.table(read.dta13(file = paste0(data_path, config::get("dhs_mr_file")), fromEncoding="utf-8")) %>% dplyr::mutate(survey = config::get("survey_name"))
}

# HH MEMBER'S RECODE
if (file.exists(paste0(data_path, config::get("dhs_pr_file")))) {
  PR <- data.table(read.dta13(file = paste0(data_path, config::get("dhs_pr_file")), fromEncoding="utf-8")) %>% dplyr::mutate(survey = config::get("survey_name"))
}

# ###################################
# ADD ADMIN 1 VALUES FROM SHP FILE TO IR FILE

# inspect admin_1 names in shapefile
df_shp <- read_sf(paste0("data/",config::get("shp_file")))
sort(unique(df_shp$NAME_1))

# Example from Nigeria DHS.
# create state and region variables for down stream processing.
# names in survey must match shp_file names
data_state_var <- config::get("data_state_var")
IR <- IR %>%
  dplyr::mutate(region = as.character(eval(parse(text = data_state_var))),
                region = stringr::str_to_title(trimws(gsub(pattern = "rurale|urbain|rural|urban|nc|ne|nw|,","", state))),
                region = case_when(state == "Fct" ~ "Federal Capital Territory",
                                  TRUE ~ region))

# check that shape file and IR file now have the same admin 1 names


if (!setequal(IR$region, df_shp$NAME_1)) {
  stop("Names in IR file and shapefile don't match. Must fix before proceeding")
}




###################################
# SAVE AS RDS

if (exists("IR")) {saveRDS(IR, file = paste0(data_path, "IR.rds"))}
if (exists("BR")) {saveRDS(BR, file = paste0(data_path, "BR.rds"))}
if (exists("KR")) {saveRDS(KR, file = paste0(data_path, "KR.rds"))}
if (exists("HH")) {saveRDS(HH, file = paste0(data_path, "HH.rds"))}
if (exists("MR")) {saveRDS(MR, file = paste0(data_path, "MR.rds"))}
if (exists("PR")) {saveRDS(PR, file = paste0(data_path, "PR.rds"))}
# saveRDS(survey, file = )


###################################
print("1_import_data.R script complete!  Survey data can now be loaded directly in 2_data_cleaning.R")





