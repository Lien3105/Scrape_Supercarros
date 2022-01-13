pacman::p_load(tidyverse)

sedan <- read.csv("./Scrape_Supercarros/12.csv")
hatchback <- read.csv("./Scrape_Supercarros/28.csv")
jeepeta <- read.csv("./Scrape_Supercarros/42.csv")
camioneta <- read.csv("./Scrape_Supercarros/58.csv")
coupe_deportivo <- read.csv("./Scrape_Supercarros/80.csv")
motores <- read.csv("./Scrape_Supercarros/87.csv")
barcos <- read.csv("./Scrape_Supercarros/93.csv")
vehiculos_pesados <- read.csv("./Scrape_Supercarros/102.csv")

## Binding
supercarros <- rbind(sedan, hatchback, jeepeta, camioneta, coupe_deportivo, motores, barcos, vehiculos_pesados)

## Cleaning data
supercarros <- supercarros %>% 
  mutate(brand = str_split_fixed(Brand_Model, " ", 2)[,1], 
         model = str_split_fixed(Brand_Model, " ", 2)[,2],
         fuel = str_split_fixed(Info, "-", 4)[,2],
         fuel = str_replace_all(fuel, "ElÃ©ctrico", "Electrico"),
         fuel = str_replace_all(fuel, "HÃbrido", "Hibrido"),
         condition = str_split_fixed(Info, "-", 4)[,3],
         type = ifelse(str_detect(Type, "/") == TRUE, str_split_fixed(Type, "/", 2)[,2], Type),
         price = Price, 
         year = Year,
         info =  Info,
         currency = Currency) %>% 
  select(brand, model, year, price, currency, type, fuel, condition, info)

write.csv(supercarros,"./supercarros_full.csv")

