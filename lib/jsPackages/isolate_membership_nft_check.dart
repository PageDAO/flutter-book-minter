import 'package:flutter/services.dart';
import 'package:isolated_worker/js_isolated_worker.dart';
import 'dart:convert';

class MembershipNFT {
  late JsIsolatedWorker worker;
  MembershipNFT() {
    worker = JsIsolatedWorker();
    worker.importScripts(_jsScripts);
  }

  static const List<String> _jsScripts = <String>[
    'fetch_function.js',
  ];

  void close() {
    worker.close();
  }

  Future<dynamic> checkNFT(String address, String tokenID) async {
    dynamic abi = await readJson();
    bool? hasMembershipNFT;
    print("Verifying NFT...");

    hasMembershipNFT = await worker.run(
      functionName: 'checkNFT',
      arguments: <String, Object?>{
        'address': address,
        'tokenID': tokenID,
        'abi': abi,
      },
    ) as bool?;
    print("Ran function");
    return hasMembershipNFT;
  }
}

// Fetch content from the json file
Future<dynamic> readJson() async {
  print("loading json");
  final String response =
      await rootBundle.loadString('assets/abi/Membership721ABI.json');
  final data = await json.decode(response);
  // print(data);
  return data;
}
