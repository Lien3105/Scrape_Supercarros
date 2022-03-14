pacman::p_load(tidyverse)

# El siguiente analisis exploratorio de datos (EDA) esta basado en la guia
# "Exploratory Data Analysis for Feature Selection in Machine Learning"

## Cargar el dataset
supercarros <- read.csv("C:/Users/NeilCarvajal/Documents/GitHub/Scrape_Supercarros/supercarros.csv")

# Data Cleaning

# Primero quitemos las comas de la columna price. Esto impide que se interpreten
# como numeros

supercarros$Price <- gsub(",", "", supercarros$Price, fixed = TRUE)
supercarros$Price <- as.numeric(supercarros$Price)

# Como tenemos dos tipos de monedas distintas seria bueno dividir los datos en 
# dos sets diferentes

supercarros_dolares <- supercarros %>% filter(Currency == "US")
supercarros_pesos <- supercarros %>% filter(Currency =='RD')

# Al tener un mayor numero de observaciones con precios en dolares
# Procedere a trabajar esa

summary(supercarros_dolares) # vemos precios irreales, quitemoslos

supercarros_dolares <- supercarros_dolares %>% filter(Price > 100)
