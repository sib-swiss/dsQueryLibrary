
devtools::load_all()
library(dsSwissKnifeClient)
builder <- newDSLoginBuilder()
builder$append(server="server1", url='https://localhost:7843', user='guest', password= 'guest123', driver = "OpalDriver", options="list(ssl_verifyhost=0,ssl_verifypeer=0)")
builder$append(server="server2", url='https://localhost:8843', user='guest', password= 'guest123', driver = "OpalDriver", options="list(ssl_verifyhost=0,ssl_verifypeer=0)")
#builder$append(server="server2", url='http://192.168.254.129:8080/', user='administrator', password= 'password', driver = "OpalDriver", options="list(ssl_verifyhost=0,ssl_verifypeer=0)")

logindata <- builder$build()
opals <<- datashield.login(logins = logindata)
datashield.assign.resource(opals, 'db', 'omop_test.db')
#datashield.assign.resource(opals, 'db', 'sophia.db')
dssSetOption(list('cdm_schema' = 'synthea_omop'))
dssSetOption(list('vocabulary_schema' = 'omop_vocabulary'))
dssSetOption(list('dsQueryLibrary.enforce_strict_privacy' = FALSE))
dssGetOption('dsQueryLibrary.enforce_strict_privacy')

x <- dsqShowQueries(TRUE)

y <- dsqRun('person', 'PE03..Number.of.patients.grouped.by.gender', db_connection='db')
y <- dsqRun('person', 'PE07', db_connection='db')

dsqRun
devtools::install_github('sib-swiss/dsResource')
opal.projects(opals[[1]]@opal)
opal.resources(opals[[1]]@opal,'omop_test')

options()[grepl('^w',names(options()))]
dssSetOption(list('datashield.privacyLevel'=2))


builder2 <- newDSLoginBuilder()
builder2$append(server="server1", url='https://localhost:7843', user='dummy', password= 'dummy123', driver = "OpalDriver", options="list(ssl_verifyhost=0,ssl_verifypeer=0)")

#builder$append(server="server1", url='https://sophia-fdb.vital-it.ch/colaus', user='idragan', password= '3xC@libur', driver = "OpalDriver", options="list(ssl_verifyhost=0,ssl_verifypeer=0)")
logindata2 <- builder2$build()
opals2 <<- datashield.login(logins = logindata2)

opals2$server1@opal$authorization  <- opals$server1@opal$authorization
opals2$server1@opal$handle$url <- opals$server1@opal$handle$url
#opals2$server1@opal$handle$handle <-curl::new_handle()
opals2$server1@opal$profile <- opals$server1@opal$profile
opals2$server1@opal$sid<- opals$server1@opal$sid
opals2$server1@opal$rid<- opals$server1@opal$rid
opals2$server1@opal$username <- opals$server1@opal$username
datashield.symbols(opals2)
str(opals2$server1@opal$config)

curl:::handle_cookies(opals2$server1@opal$handle$handle)
x <- curl:::handle_cookies(opals$server1@opal$handle$handle)
curl::handle_setopt(opals2$server1@opal$handle$handle,.list = list(cookiefile = '',cookie = ck))
curl::handle_setopt(opals2$server1@opal$handle$handle,.list = list(cookie = ck))
ck <- paste0(Reduce(function(x,y) paste0(x,';',y),sapply(names(x), function(y) paste0(y, '=',x[y]))), ';')
curl:::handle_getheaders(opals2$server1@opal$handle$handle)
