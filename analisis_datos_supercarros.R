library(tidyverse)
library(plotly)

## Importar datos
supercarros <- read.csv("supercarros_2022-04-22.csv") %>% select(-Fecha)

## Ver summary
summary(supercarros) 

## Cambiar formato de precios
supercarros$Price <- as.numeric(str_replace_all(supercarros$Price, ",", ""))

## Cambiar nombre de electricos y barcos
supercarros$Fuel <- str_replace_all(supercarros$Fuel, "ElÃ©ctrico", "Electrico")
supercarros$Fuel <- str_replace_all(supercarros$Fuel, "HÃ­brido", "Hibrido")

# Explorando categorical data
table(supercarros$Type, supercarros$Fuel) # Ver relacion entre tipo y combustibles
ggplot(supercarros, aes(x = Type, fill = Fuel)) + geom_bar() # graficar

## Ver distribucion en combustibles
prop.table(table(supercarros$Fuel))

## Ver distribucion de combustibles por cada tipo
dist_fuel_types <- ggplot(supercarros, aes(x = Type, fill = Fuel)) +
  geom_bar(position = "fill") +
  ylab("proportion")
ggplotly(dist_fuel_types)

## Ver vehiculos por condicion
prop.table(table(supercarros$Type, supercarros$Condition), 2)

ve_condition <- supercarros %>% filter(Condition != " Siniestro/Accidentado ") %>% 
  ggplot(aes(x = Type)) +
  geom_bar() +
  facet_wrap(~Condition)
ggplotly(ve_condition)

# Explorando precios
## Llevar todo a dolares
supercarros1 <- supercarros %>% mutate(Precio_US = ifelse(Currency == "RD", 
                                                         Price/55.5, Price)) %>% 
  filter(Precio_US < 600000 & Precio_US > 400 & Condition != " Siniestro/Accidentado ")

plot <- ggplot(supercarros1, aes(x = Precio_US)) + geom_boxplot() + facet_wrap(~Condition)

ggplotly(plot)
supercarros1 %>% arrange(Precio_US) %>% top_n(10)
