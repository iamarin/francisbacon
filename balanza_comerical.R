# Composicion de la balanza comercial
# @elcontrafactual

# Librerias
library(dplyr)
library(readr)
library(ggplot2)

## Los acentos se omiten intencionalmente

# PATH

# Cargar datos
bc19 <- read_csv(paste0(bases,'bcmm_mensual_tr_cifra_2019.csv'))
glimpse(bc19)

# Valor mensual
bc19 %>% 
  filter(TIPO == 'Exportaciones') %>% 
  group_by(MES, CONCEPTO) %>% 
  summarise(
    total = sum(VAL_USD,na.rm = TRUE)
  ) %>% 
    ggplot(aes(x = MES, y =total)) + geom_col()

# Exportaciones totales
total19 <- bc19 %>% 
  filter(TIPO =='Exportaciones') %>% 
  arrange(MES) %>% 
  select(MES,CONCEPTO,VAL_USD) %>% 
  filter(CONCEPTO =='Exportaciones Totales')

# Valor de las exportaciones por concepto de exportacion
bc19 %>% 
  filter(TIPO =='Exportaciones') %>%
  filter(CONCEPTO=="Petroleras" |  CONCEPTO=="No Petroleras") %>% 
  ggplot(aes(x = MES, y =VAL_USD,color=CONCEPTO, group=CONCEPTO))+geom_line()

# Conceptos
table(bc19$CONCEPTO)

# Variacion mensial de las exportacione no petroleras
bc19 %>% 
  filter(TIPO=='Exportaciones') %>% 
  filter((CONCEPTO=='Agropecuarias'|CONCEPTO=='Extractivas'|CONCEPTO=='Manufactureras')) %>% 
  select(MES,CONCEPTO,VAL_USD) %>% 
  arrange(CONCEPTO) %>% 
  group_by(CONCEPTO) %>% 
  mutate(
    diff = 100*((VAL_USD - lag(VAL_USD))/VAL_USD)
  ) %>% 
  ggplot(aes(x=MES,y=diff,group = CONCEPTO, color = CONCEPTO)) +
  geom_line()

