<?php

require "vendor/autoload.php";

use ARandomInvestor\AMFEIX\StorageContract;
use Web3\Web3;

date_default_timezone_set("UTC");

if($argc < 2){
    echo "Usage: " . escapeshellarg(PHP_BINARY) . " " . escapeshellarg($argv[0]) ." <HTTP Web3 endpoint>\n";
    echo "\t<HTTP Web3 endpoint>: Could be your local node, or a remote one like https://infura.io/\n";
    exit(1);
}

$web3 = new Web3(new \Web3\Providers\HttpProvider(new \Web3\RequestManagers\HttpRequestManager($argv[1], 10)));

$ob = new StorageContract($web3->getProvider());


echo "Acquiring AMFEIX index\n";

$ob->getFundPerformace(function ($index) {
    echo json_encode($index, JSON_PRETTY_PRINT) . PHP_EOL;
});
