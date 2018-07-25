#TODO: 

# 1. Switch distribution account asset to just symbol
# 2. Add support for counting new accounts
# 3. After account 1,000, start issuing with 25k tokens
# 4. After account 5,000, start transfering 40,000 tokens from x to y

# Compile Distributor Source Code
eosiocpp -g /eosdev/merriment/dist/dist.abi /eosdev/merriment/dist/dist.hpp && eosiocpp -o /eosdev/merriment/dist/dist.wast /eosdev/merriment/dist/dist.cpp

# Issuer / "Bank" Account 
cleos create account eosio mmptokenmain EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn

# Create the token account
cleos create account eosio mmptcontract EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn
cleos set contract mmptcontract /eosdev/merriment/eosio.token
cleos push action mmptcontract create '["mmptokenmain", "40000000000.000000 MMT"]' -p mmptcontract

# Create the *mostly* static accounts
cleos create account eosio mmpbareserve EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn
cleos create account eosio mmptokensale EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn
cleos create account eosio mmpbagateway EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn
cleos create account eosio mmpopreserve EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn
cleos create account eosio mmpteamdistr EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn

cleos create account eosio mmpcharities EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn
cleos create account eosio mmpcommunity EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn
cleos create account eosio mmfoundation EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn


# Dynamic Accounts
# Groups
cleos create account eosio mmp4advisors EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn
cleos create account eosio mmp4founders EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn
cleos create account eosio mmpoperation EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn

# Children
cleos create account eosio merrimentad1 EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn
cleos create account eosio merrimentad2 EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn
cleos create account eosio merrimentad3 EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn

cleos create account eosio merrimentfr1 EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn
cleos create account eosio merrimentfr2 EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn

cleos create account eosio merrimenttm1 EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn
cleos create account eosio merrimenttm2 EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn


# PRIMARY ACCOUNT TO RECEIVE DIST CODE AND HANDLE THE DISTRIBUTION
cleos set contract mmpteamdistr /eosdev/merriment/dist

# Initialize
cleos push action mmpteamdistr init '["mmptcontract", "1.000000 MMT"]' -p mmpteamdistr

# Add Advisors Parent and Children
cleos push action mmpteamdistr addparent '["Merriment Advisors", "mmp4advisors", 10]' -p mmpteamdistr
cleos push action mmpteamdistr addchild '["mmp4advisors", "merrimentad1", 33]' -p mmpteamdistr
cleos push action mmpteamdistr addchild '["mmp4advisors", "merrimentad2", 33]' -p mmpteamdistr
cleos push action mmpteamdistr addchild '["mmp4advisors", "merrimentad3", 33]' -p mmpteamdistr

# Add Founders Parent and Children
cleos push action mmpteamdistr addparent '["Merriment Founders", "mmp4founders", 30]' -p mmpteamdistr
cleos push action mmpteamdistr addchild '["mmp4founders", "merrimentfr1", 50]' -p mmpteamdistr
cleos push action mmpteamdistr addchild '["mmp4founders", "merrimentfr2", 50]' -p mmpteamdistr

# Add Team Parent and Children
cleos push action mmpteamdistr addparent '["Merriment Team", "mmpoperation", 60]' -p mmpteamdistr
cleos push action mmpteamdistr addchild '["mmpoperation", "merrimenttm1", 30]' -p mmpteamdistr
cleos push action mmpteamdistr addchild '["mmpoperation", "merrimenttm2", 30]' -p mmpteamdistr
cleos push action mmpteamdistr addchild '["mmpoperation", "mmpopreserve", 40]' -p mmpteamdistr

# Parents give authority to the distribution contract
cleos push action eosio updateauth '{"account":"mmp4advisors","permission":"active","parent":"owner","auth":{"keys":[{"key":"EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn", "weight":1}],"threshold":1,"accounts":[{"permission":{"actor":"mmpteamdistr","permission":"eosio.code"},"weight":1}],"waits":[]}}' -p mmp4advisors
cleos push action eosio updateauth '{"account":"mmp4founders","permission":"active","parent":"owner","auth":{"keys":[{"key":"EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn", "weight":1}],"threshold":1,"accounts":[{"permission":{"actor":"mmpteamdistr","permission":"eosio.code"},"weight":1}],"waits":[]}}' -p mmp4founders
cleos push action eosio updateauth '{"account":"mmpoperation","permission":"active","parent":"owner","auth":{"keys":[{"key":"EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn", "weight":1}],"threshold":1,"accounts":[{"permission":{"actor":"mmpteamdistr","permission":"eosio.code"},"weight":1}],"waits":[]}}' -p mmpoperation
cleos push action eosio updateauth '{"account":"mmpteamdistr","permission":"active","parent":"owner","auth":{"keys":[{"key":"EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn", "weight":1}],"threshold":1,"accounts":[{"permission":{"actor":"mmpteamdistr","permission":"eosio.code"},"weight":1}],"waits":[]}}' -p mmpteamdistr

# Initial Transfers
cleos push action mmptcontract issue '["mmpcharities", "5000000.000000 MMT"]' -p mmptokenmain
cleos push action mmptcontract issue '["mmpcommunity", "10000000.000000 MMT"]' -p mmptokenmain
cleos push action mmptcontract issue '["mmfoundation", "15000000.000000 MMT"]' -p mmptokenmain
cleos push action mmptcontract issue '["mmp4advisors", "20000000.000000 MMT"]' -p mmptokenmain
cleos push action mmptcontract issue '["mmp4founders", "50000000.000000 MMT"]' -p mmptokenmain
cleos push action mmptcontract issue '["mmpopreserve", "100000000.000000 MMT"]' -p mmptokenmain

# Deposit 1,000 tokens to mmpteamdistr
cleos push action mmptcontract issue '["mmpteamdistr", "1000.000000 MMT"]' -p mmptokenmain

# Distribute tokens
cleos push action mmpteamdistr distribute '[]' -p mmpteamdistr

