

cleos create account eosio distgrp1 EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn
cleos create account eosio distgrp2 EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn
cleos create account eosio distgrp3 EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn
cleos create account eosio distacct1 EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn
cleos create account eosio distacct2 EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn
cleos create account eosio distacct3 EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn
cleos create account eosio default EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn


cleos create account eosio dist22 EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn
cleos set contract dist22 /eosdev/merriment/dist

cleos push action eosio updateauth '{"account":"dist22","permission":"active","parent":"owner","auth":{"keys":[{"key":"EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn", "weight":1}],"threshold":1,"accounts":[{"permission":{"actor":"dist22","permission":"eosio.code"},"weight":1}],"waits":[]}}' -p dist22
cleos push action eosio updateauth '{"account":"distgrp1","permission":"active","parent":"owner","auth":{"keys":[{"key":"EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn", "weight":1}],"threshold":1,"accounts":[{"permission":{"actor":"dist22","permission":"eosio.code"},"weight":1}],"waits":[]}}' -p distgrp1
cleos push action eosio updateauth '{"account":"distgrp2","permission":"active","parent":"owner","auth":{"keys":[{"key":"EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn", "weight":1}],"threshold":1,"accounts":[{"permission":{"actor":"dist22","permission":"eosio.code"},"weight":1}],"waits":[]}}' -p distgrp2
cleos push action eosio updateauth '{"account":"distgrp3","permission":"active","parent":"owner","auth":{"keys":[{"key":"EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn", "weight":1}],"threshold":1,"accounts":[{"permission":{"actor":"dist22","permission":"eosio.code"},"weight":1}],"waits":[]}}' -p distgrp3

cleos create account eosio merritok4 EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn EOS7ckzf4BMgxjgNSYV22rtTXga8R9Z4XWVhYp8TBgnBi2cErJ2hn
cleos set contract merritok4 /eosdev/merriment/eosio.token
cleos push action merritok4 create '["dist22", "100000000.0000 MRM"]' -p merritok4
cleos push action merritok4 issue '["dist22", "1000.0000 MRM"]' -p dist22


cleos push action dist22 init '["merritok4"]' -p dist22
cleos push action dist22 addparent '["Parent 1","distgrp1",50]' -p dist22
cleos push action dist22 addparent '["Parent 2","distgrp2",30]' -p dist22
cleos push action dist22 addparent '["Parent 3","distgrp3",20]' -p dist22


cleos push action dist22 addchild '["distgrp1","distacct1",10]' -p dist22
cleos push action dist22 addchild '["distgrp1","distacct2",10]' -p dist22
cleos push action dist22 addchild '["distgrp1","distacct3",10]' -p dist22

cleos push action dist22 addchild '["distgrp2","distacct2",40]' -p dist22
cleos push action dist22 addchild '["distgrp2","distacct3",60]' -p dist22

cleos push action dist22 addchild '["distgrp3","distacct1",100]' -p dist22


