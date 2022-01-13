
from bs4 import BeautifulSoup
import pandas as pd
import requests
import re


types = ['carros/sedan', 'carros/hatchback', 'carros/jeepeta', 'carros/camioneta', 'carros/coupe-deportivo', 'motores', 'barcos', 'v.pesados']
n = 0
for type_ in types:
    n += len(type_)
    print(f"Scrapping {type_}...")
    ## Create lists
    currency_list = []
    price_list = []
    year_list = []
    brand_model_list = []
    info_list = []
    types_list = []
    for i in range(0, 42):
        num = i
        print(f'Scrapping page {num}...')
        ## Web page request
        html_text = requests.get(f'https://www.supercarros.com/{type_}/?PagingPageSkip={num}')
        ## The soup
        soup = BeautifulSoup(html_text.text, 'lxml')
        big_search = soup.find('div', id = 'bigsearch-results-inner-container')
        
        info = big_search.find_all('li', class_ = "normal")
        
        for li in info:
            precio_full = li.find('div', class_ = 'price').text
            moneda = re.match('[^$]*', precio_full).group(0)
            currency_list.append(moneda)
            precio = re.search('(?<= ).*', precio_full).group(0)
            price_list.append(precio)
            year = li.find('div', class_ = 'year').text
            year_list.append(year)
            marca_modelo = li.find('div', class_ = 'title1').text
            brand_model_list.append(marca_modelo)
            datos = li.find('div', class_ = 'title2').text
            info_list.append(datos)
            types_list.append(type_)
            
    dictionary = {
        'Currency' : currency_list,
        'Price' :price_list,
        'Year' : year_list,
        'Brand_Model' : brand_model_list,
        'Info' : info_list,
        'Type' : types_list,
    }
    
    df = pd.DataFrame(dictionary)
    df.to_csv(f"./{n}.csv", index = False)