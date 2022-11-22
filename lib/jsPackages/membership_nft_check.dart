import 'dart:math';
import 'package:js/js.dart';
import 'package:pagedao/constants/membership721ABI.dart';
import 'dart:convert';

import 'package:flutter/services.dart';

@JS('window')
external dynamic get window;
@JS('window.ethereum')
external dynamic get ethereum;
@JS('window.hasToken')
external dynamic get _hasToken;
@JS('eval')
external dynamic get eval;
@JS('window.address')
external dynamic _address;
@JS('window.tokenID')
external dynamic _tokenID;

@JS('window.abi')
external dynamic _abi;

// ref: https://ethereum.stackexchange.com/questions/92136/retrieving-web3-contract-ownerof-nft-erc721
// Answer: This is how I'm checking for the owner of an NFT in my dApp
// async whoOwnThisToken(tokenId) {
//     const contract = new web3.eth.Contract(abi, address);
//     // Don't forget to use await and .call()
//     const owner = await contract.methods.ownerOf(tokenId).call();
// }

// Error: You must provide the json interface of the contract when instantiating a contract object.
// define abi

// Fetch content from the json file
Future<dynamic> readJson() async {
  print("loading json");
  final String response =
      await rootBundle.loadString('assets/abi/Membership721ABI.json');
  final data = await json.decode(response);
  return data;
}

Future<bool> checkNFT(String address, String tokenID) async {
  // List<Map> abi = Membership721ABI().abi;
  _abi = await readJson();
  print(_abi);
  print(_abi.runtimeType);
  print(_abi.length);

  _address = address;
  _tokenID = tokenID;

  eval('''
      async function setter(){
        // console.log("$address");
        console.log("$tokenID");
        console.log("New");
        console.log(window.tokenID);
        console.log(window.abi);
        console.log(typeof window.abi);
        var web3 = new Web3("https://polygon-rpc.com"); //"https://polygon-rpc.com"
        console.log("Loaded");
        const contract = new web3.eth.Contract(window.abi, window.tokenID);
        console.log("made contract object");
        console.log(contract.methods);
        // This ERROR
        // Uncaught (in promise) TypeError: contract.methods.balanceOf is not a function
        const tokenOwner = await contract.methods.balanceOf(window.address).call()
        
        // .then(res => {
        //             const hasMembership = (res > 0) ? true : false
        //         });
        
        // .call(function (err, res) {
        //   if (err) {
        //     console.log("An error occured", err);
        //   }
        //   console.log("The balance is: ", res);
        // });
        console.log(tokenOwner);
        const hasToken = tokenOwner > 0;
        console.log("Has token");
        console.log(hasToken);
        window.hasToken = "$address" === tokenOwner;
      }
      setter();
      ''');
  return _hasToken;
}
