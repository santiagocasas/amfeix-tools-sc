#!/bin/bash

echo "Checking for configuration files..."
infuria_file="./infuria_addr.config"
if [ -f "$infuria_file" ]; then
    echo "$infuria_file exists"
    source $infuria_file
    if [[ $infuriaProjectID == '' ]]; then echo "Infuria config file does not contain Project ID."; exit 1; fi
    echo "Infuria Ethereum Access ID: $infuriaProjectID"
    api_node_url="$infuria_api$infuriaProjectID"
    echo "API NODE URL: $api_node_url"
else 
    echo "$infuria_file does not exist. Using Standard MyCrypto API."
    api_node_url="https://api.mycryptoapi.com/eth"
    echo "API NODE URL: $api_node_url"
fi

#exit 0
investor_file="./investor_addr.config"
if [ -f "$investor_file" ]; then
    echo "$investor_file exists"
    source $investor_file
    if [[ $investorAddress == '' ]]; then echo "Investor config file does not contain Investor Address."; exit 1; fi
    echo "Investor ETH address: $investorAddress"
else
    echo "No Investor address provided in investor_addr.config, file not found."
    exit 1
fi

if [ $1 == 'investor' ]
then
investorAddress=$investorAddress
suffix="_balance.php"
elif [ $1 == 'fund' ]
then
investorAddress=""
suffix="_performance.php"
fi

if [ $2 == 'txt' ]
then
  php="fund$suffix"
  savefile="performance_$1_amfeix.txt"
  echo "Exporting $1 balance to txt"
elif [ $2 == 'json' ]
then
  php="json_fund$suffix"
  savefile="performance_$1_amfeix.json"
  echo "Exporting $1 balance to JSON"
else
  echo "Passed argument must be either 'txt' or 'json' "
fi

php "$php" "$api_node_url" $investorAddress | tee "$savefile"

if [ $? -ne 0 ]
then
    echo "PHP script returned error"
else
echo "Succesful. Results exported to $savefile"
fi


exit 0

