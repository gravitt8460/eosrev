
Merriment test keys:
Private key: 5KQ5U3Xvb7429z64Fe2ZzVeKwk5zVhp7hyx7McNEXgMydj1LodS
Public key: EOS89iko8FKqqqKowkLsYsZjV6ghiAq7TxyNez2FUtutJouqXidEt


# Merriment Accounts on Jungle
mmtareserve
mmtcontract1
mmttokenmain
merriconfig1
mmt4advisors
mmt4founders
mmtpublisher
mmtteamdistr
mmtsuccesspa
mmsuccesspa1
mmtbusiness1
mmtaffiliate
mmtcharities
mmtbagateway
mmtfoundatio
mmtreferrer1
mmtreferrer2
advisorchild
founderchild
operationch


cleos system delegatebw mmtareserve mmtareserve "1000.0000 EOS" "1000.0000 EOS"
cleos system delegatebw mmtcontract1 mmtcontract1 "1000.0000 EOS" "1000.0000 EOS"
cleos system delegatebw mmttokenmain mmttokenmain "1000.0000 EOS" "1000.0000 EOS"
cleos system delegatebw merriconfig1 merriconfig1 "1000.0000 EOS" "1000.0000 EOS"
cleos system delegatebw mmt4advisors mmt4advisors "1000.0000 EOS" "1000.0000 EOS"
cleos system delegatebw mmt4founders mmt4founders "1000.0000 EOS" "1000.0000 EOS"
cleos system delegatebw mmtpublisher mmtpublisher "1000.0000 EOS" "1000.0000 EOS"
cleos system delegatebw mmtsuccesspa mmtsuccesspa "1000.0000 EOS" "1000.0000 EOS"
cleos system delegatebw mmsuccesspa1 mmsuccesspa1 "1000.0000 EOS" "1000.0000 EOS"
cleos system delegatebw mmtbusiness1 mmtbusiness1 "1000.0000 EOS" "1000.0000 EOS"
cleos system delegatebw mmtteamdistr mmtteamdistr "1000.0000 EOS" "1000.0000 EOS"
cleos system delegatebw mmtaffiliate mmtaffiliate "1000.0000 EOS" "1000.0000 EOS"
cleos system delegatebw mmtcharities mmtcharities "1000.0000 EOS" "1000.0000 EOS"
cleos system delegatebw mmtbagateway mmtbagateway "1000.0000 EOS" "1000.0000 EOS"
cleos system delegatebw mmtfoundatio mmtfoundatio "1000.0000 EOS" "1000.0000 EOS"
cleos system delegatebw mmtoperation mmtoperation "1000.0000 EOS" "1000.0000 EOS"
cleos system delegatebw mmtreferrer1 mmtreferrer1 "1000.0000 EOS" "1000.0000 EOS"
cleos system delegatebw mmtreferrer2 mmtreferrer2 "1000.0000 EOS" "1000.0000 EOS"
cleos system delegatebw advisorchild advisorchild "1000.0000 EOS" "1000.0000 EOS"
cleos system delegatebw founderchild founderchild "1000.0000 EOS" "1000.0000 EOS"
cleos system delegatebw operationch operationch "1000.0000 EOS" "1000.0000 EOS"


cleos system buyram mmtareserve mmtareserve "1000.0000 EOS"
cleos system buyram mmtcontract1 mmtcontract1 "1000.0000 EOS"
cleos system buyram mmttokenmain mmttokenmain "1000.0000 EOS" 
cleos system buyram merriconfig1 merriconfig1 "1000.0000 EOS"
cleos system buyram mmt4advisors mmt4advisors "1000.0000 EOS"
cleos system buyram mmt4founders mmt4founders "1000.0000 EOS"
cleos system buyram mmtpublisher mmtpublisher "1000.0000 EOS"
cleos system buyram mmtsuccesspa mmtsuccesspa "1000.0000 EOS"
cleos system buyram mmsuccesspa1 mmsuccesspa1 "1000.0000 EOS"
cleos system buyram mmtbusiness1 mmtbusiness1 "1000.0000 EOS"
cleos system buyram mmtaffiliate mmtaffiliate "1000.0000 EOS"
cleos system buyram mmtteamdistr mmtteamdistr "1000.0000 EOS"
cleos system buyram mmtcharities mmtcharities "1000.0000 EOS"
cleos system buyram mmtbagateway mmtbagateway "1000.0000 EOS"
cleos system buyram mmtfoundatio mmtfoundatio "1000.0000 EOS"
cleos system buyram mmtoperation mmtoperation "1000.0000 EOS"
cleos system buyram mmtreferrer1 mmtreferrer1 "1000.0000 EOS"
cleos system buyram mmtreferrer2 mmtreferrer2 "1000.0000 EOS"
cleos system buyram advisorchild advisorchild "1000.0000 EOS"
cleos system buyram founderchild founderchild "1000.0000 EOS"
cleos system buyram operationch operationch "1000.0000 EOS"



#cleos set contract mmpteamdistr /eosdev/merriment/dist
# Compile Distributor Source Code
eosiocpp -g /eosdev/merriment/dist/dist.abi /eosdev/merriment/dist/dist.hpp && eosiocpp -o /eosdev/merriment/dist/dist.wast /eosdev/merriment/dist/dist.cpp 

# Create the token account
cleos set contract mmptcontract1 /eosdev/merriment/eosio.token
cleos push action mmtcontract1 create '["mmttokenmain", "30000000000.000000 MMT"]' -p mmtcontract1

# PRIMARY ACCOUNT TO RECEIVE DIST CODE AND HANDLE THE DISTRIBUTION
cleos set contract mmtteamdistr /eosdev/merriment/dist

# config / revenue processor
#cleos set contract merriconfig /eosdev/merriment/merriment

# Initialize
cleos push action mmtteamdistr init '["mmtcontract1", "MMT", 6]' -p mmtteamdistr
cleos push action mmtteamdistr addparent '["Merriment Advisors", "mmt4advisors", 16]' -p mmtteamdistr
cleos push action mmtteamdistr addparent '["Merriment Founders", "mmt4founders", 16]' -p mmtteamdistr
cleos push action mmtteamdistr addparent '["Merriment Operation", "mmtoperation", 68]' -p mmtteamdistr

cleos push action mmtteamdistr addchild '["mmt4advisors", "advisorchild", 100]' -p mmtteamdistr
cleos push action mmtteamdistr addchild '["mmt4founders", "founderchild", 100]' -p mmtteamdistr
cleos push action mmtteamdistr addchild '["operationch", "operationch", 100]' -p mmtteamdistr

# Parents give authority to the distribution contract
cleos push action eosio updateauth '{"account":"mmt4advisors","permission":"active","parent":"owner","auth":{"keys":[{"key":"EOS89iko8FKqqqKowkLsYsZjV6ghiAq7TxyNez2FUtutJouqXidEt", "weight":1}],"threshold":1,"accounts":[{"permission":{"actor":"mmtteamdistr","permission":"eosio.code"},"weight":1}],"waits":[]}}' -p mmt4advisors
cleos push action eosio updateauth '{"account":"mmt4founders","permission":"active","parent":"owner","auth":{"keys":[{"key":"EOS89iko8FKqqqKowkLsYsZjV6ghiAq7TxyNez2FUtutJouqXidEt", "weight":1}],"threshold":1,"accounts":[{"permission":{"actor":"mmtteamdistr","permission":"eosio.code"},"weight":1}],"waits":[]}}' -p mmt4founders
cleos push action eosio updateauth '{"account":"mmtteamdistr","permission":"active","parent":"owner","auth":{"keys":[{"key":"EOS89iko8FKqqqKowkLsYsZjV6ghiAq7TxyNez2FUtutJouqXidEt", "weight":1}],"threshold":1,"accounts":[{"permission":{"actor":"mmtteamdistr","permission":"eosio.code"},"weight":1}],"waits":[]}}' -p mmpteamdistr
cleos push action eosio updateauth '{"account":"mmtoperation","permission":"active","parent":"owner","auth":{"keys":[{"key":"EOS89iko8FKqqqKowkLsYsZjV6ghiAq7TxyNez2FUtutJouqXidEt", "weight":1}],"threshold":1,"accounts":[{"permission":{"actor":"mmtteamdistr","permission":"eosio.code"},"weight":1}],"waits":[]}}' -p mmtoperation
# Initial Transfers
cleos push action mmptcontract issue '["mmpcharities", "5000000.000000 MMT"]' -p mmptokenmain
cleos push action mmptcontract issue '["mmpcommunity", "10000000.000000 MMT"]' -p mmptokenmain
cleos push action mmptcontract issue '["mmfoundation", "15000000.000000 MMT"]' -p mmptokenmain
cleos push action mmptcontract issue '["mmt4advisors", "20000000.000000 MMT"]' -p mmptokenmain
cleos push action mmptcontract issue '["mmt4founders", "50000000.000000 MMT"]' -p mmptokenmain
cleos push action mmptcontract issue '["mmpopreserve", "100000000.000000 MMT"]' -p mmptokenmain

#cleos get table mmptcontract merrimenttm1 accounts

eosiocpp -g /eosdev/merriment/merriment/merriment.abi /eosdev/merriment/merriment/merriment.hpp && eosiocpp -o /eosdev/merriment/merriment/merriment.wast /eosdev/merriment/merriment/merriment.cpp && cleos set contract merriconfig1 /eosdev/merriment/merriment

cleos push action eosio updateauth '{"account":"bizaccoun1","permission":"active","parent":"owner","auth":{"keys":[{"key":"EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn", "weight":1}],"threshold":1,"accounts":[{"permission":{"actor":"merriconfig","permission":"eosio.code"},"weight":1}],"waits":[]}}' -p bizaccoun1
eosiocpp -g /eosdev/merriment/merriment/merriment.abi /eosdev/merriment/merriment/merriment.hpp && eosiocpp -o /eosdev/merriment/merriment/merriment.wast /eosdev/merriment/merriment/merriment.cpp && cleos set contract merriconfig1 /eosdev/merriment/merriment

cleos push action eosio updateauth '{"account":"mmtbusiness1","permission":"active","parent":"owner","auth":{"keys":[{"key":"EOS89iko8FKqqqKowkLsYsZjV6ghiAq7TxyNez2FUtutJouqXidEt", "weight":1}],"threshold":1,"accounts":[{"permission":{"actor":"merriconfig","permission":"eosio.code"},"weight":1}],"waits":[]}}' -p mmtbusiness1
cleos push action eosio updateauth '{"account":"mmtaffiliate","permission":"active","parent":"owner","auth":{"keys":[{"key":"EOS89iko8FKqqqKowkLsYsZjV6ghiAq7TxyNez2FUtutJouqXidEt", "weight":1}],"threshold":1,"accounts":[{"permission":{"actor":"merriconfig","permission":"eosio.code"},"weight":1}],"waits":[]}}' -p mmtaffiliate

cleos push action eosio updateauth '{"account":"mmtsuccesspa","permission":"active","parent":"owner","auth":{"keys":[{"key":"EOS89iko8FKqqqKowkLsYsZjV6ghiAq7TxyNez2FUtutJouqXidEt", "weight":1}],"threshold":1,"accounts":[{"permission":{"actor":"merriconfig","permission":"eosio.code"},"weight":1}],"waits":[]}}' -p successpa1
cleos push action eosio updateauth '{"account":"mmsuccesspa1","permission":"active","parent":"owner","auth":{"keys":[{"key":"EOS89iko8FKqqqKowkLsYsZjV6ghiAq7TxyNez2FUtutJouqXidEt", "weight":1}],"threshold":1,"accounts":[{"permission":{"actor":"merriconfig","permission":"eosio.code"},"weight":1}],"waits":[]}}' -p successpa2

cleos push action eosio updateauth '{"account":"mmtreferrer1","permission":"active","parent":"owner","auth":{"keys":[{"key":"EOS89iko8FKqqqKowkLsYsZjV6ghiAq7TxyNez2FUtutJouqXidEt", "weight":1}],"threshold":1,"accounts":[{"permission":{"actor":"merriconfig","permission":"eosio.code"},"weight":1}],"waits":[]}}' -p mmtreferrer1
cleos push action eosio updateauth '{"account":"mmtreferrer2","permission":"active","parent":"owner","auth":{"keys":[{"key":"EOS89iko8FKqqqKowkLsYsZjV6ghiAq7TxyNez2FUtutJouqXidEt", "weight":1}],"threshold":1,"accounts":[{"permission":{"actor":"merriconfig","permission":"eosio.code"},"weight":1}],"waits":[]}}' -p mmtreferrer2

# Setup Merriment Configuration Contract
cleos push action merriconfig1 addconfig '["mmpareserve", "mmtcontract1", "MMTT", 6, 90, 9000, 100, 50, 700, 8500, 100, 50, 1150, "mmtteamdistr", 1000, "25000.000000 MMT"]' -p merriconfig1
cleos push action merriconfig1 newcountdist '["mmttokenmain", "mmtteamdistr", "40000.000000 MMTT", 5000, 100000]' -p merriconfig1

cleos push action merriconfig1 newmaccount '[1, "bizaccoun1","my_web_acct","mmtreferrer1","mmtsuccesspa"]' -p merriconfig1
cleos push action merriconfig1 newmaccount '[1, "affiliate1","my_web_acct","mmtreferrer2","mmsuccesspa1"]' -p merriconfig1

#cleos push action mmtcontract1 issue '["mmtteamdistr", "10000.000000 MMTT"]' -p mmttokenmain

cleos push action merriconfig revenueevent '[0, "bizaccoun1", "affiliate1", "1000.000000 MMTT", "publisher", 1000]' -p merriconfig

cleos get table mmptcontract affiliate1 accounts
cleos get table mmptcontract bizaccoun1 accounts
cleos get table mmptcontract successpa1 accounts
cleos get table mmptcontract successpa2 accounts
cleos get table mmptcontract referrer1 accounts
cleos get table mmptcontract referrer2 accounts
cleos get table mmptcontract mmpteamdistr accounts

cleos push action mmtteamdistr distribute '[]' -p mmtteamdistr
