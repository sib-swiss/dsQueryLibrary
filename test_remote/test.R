
devtools::load_all()
library(dsSwissKnifeClient)
builder <- newDSLoginBuilder()
builder$append(server="server1", url='https://localhost:7843', user='guest', password= 'guest123', driver = "OpalDriver", options="list(ssl_verifyhost=0,ssl_verifypeer=0)")
#builder$append(server="server2", url='http://192.168.254.129:8080/', user='administrator', password= 'password', driver = "OpalDriver", options="list(ssl_verifyhost=0,ssl_verifypeer=0)")

#builder$append(server="server1", url='https://sophia-fdb.vital-it.ch/colaus', user='idragan', password= '3xC@libur', driver = "OpalDriver", options="list(ssl_verifyhost=0,ssl_verifypeer=0)")
logindata <- builder$build()
opals <<- datashield.login(logins = logindata)
datashield.assign.resource(opals, 'db', 'omop_test.db')
#datashield.assign.resource(opals, 'db', 'sophia.db')
dssSetOption(list('cdm_schema' = 'synthea_omop'))
dssSetOption(list('vocabulary_schema' = 'omop_vocabulary'))
x <- dsqShowQueries()

y <- dsqRun('person', 'PE02..Number.of.patients.of.specific.gender.in.the.dataset', db_connection='db', input=8532)
y <- dsqRun('person', 'PE03', db_connection='db')

dsqRun
devtools::install_github('sib-swiss/dsResource')
opal.projects(opals[[1]]@opal)
opal.resources(opals[[1]]@opal,'omop_test')