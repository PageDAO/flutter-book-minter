import 'dart:math';
import 'package:js/js.dart';

@JS('window')
external dynamic get window;
@JS('window.ethereum')
external dynamic get ethereum;
@JS('window.address')
external dynamic get _address;
@JS('window.sign')
external dynamic get _sign;
@JS('window.network')
external dynamic get _network;
@JS('eval')
external dynamic get eval;

String randomId() {
  var number = '';
  for (var i = 0; i < 4; i++) {
    number += '${Random().nextInt(10)}';
  }
  return number;
}

class MetaMask {
  String? address;
  String? signature;
  String? network;

  bool get isSupported => ethereum != null;

  Future<bool> login() async {
    try {
      if (ethereum == null) {
        return false;
      }
      var id = randomId();
      var message = 'Please log in to MetaMask $id';

      eval('''
      async function setter(){
        var provider = new ethers.providers.Web3Provider(window.ethereum);
        await provider.send("eth_requestAccounts", []);
        window.address = await provider.getSigner().getAddress();
        window.sign = await provider.getSigner().signMessage("$message");
        const network = await provider.getNetwork(); // https://docs.ethers.io/v5/api/providers/types/#providers-Network
        const name = network.name;
        window.network = name;
      }
      setter();
      ''');
      while (_address == null || _sign == null) {
        //|| _network == null
        await Future.delayed(const Duration(milliseconds: 100));
      }
      address = _address.toString();
      signature = _sign.toString();
      network = _network.toString();
      return true;
    } catch (e) {
      return false;
    }
  }
}
