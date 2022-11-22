import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pagedao/constants/contractAddr.dart';
import 'package:pagedao/jsPackages/isolate_membership_nft_check.dart';
import 'package:pagedao/jsPackages/metamask.dart';
import 'package:provider/provider.dart';

class TopAppBar extends StatefulWidget {
  final onLogin;
  const TopAppBar({this.onLogin, super.key});

  @override
  State<TopAppBar> createState() => _TopAppBarState();
}

class _TopAppBarState extends State<TopAppBar> {
  ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);
  ValueNotifier<bool> hasMembershipNFT = ValueNotifier(false);
  ValueNotifier<MetaMask> metamask = ValueNotifier(MetaMask());

  void _switchTheme() {
    if (themeMode.value.name == "light") {
      setState(() {
        themeMode.value = ThemeMode.dark;
      });
    } else if (themeMode.value.name == "dark") {
      setState(() {
        themeMode.value = ThemeMode.light;
      });
    }
  }

  @override
  void initState() {
    themeMode = Provider.of<ValueNotifier<ThemeMode>>(context, listen: false);
    hasMembershipNFT = Provider.of<ValueNotifier<bool>>(context, listen: false);
    metamask = Provider.of<ValueNotifier<MetaMask>>(context, listen: false);
    super.initState();
  }

  Future<bool> _loginWithMetaMask() async {
    bool success = await metamask.value.login();

    if (success) {
      debugPrint('MetaMask address: ${metamask.value.address}');
      debugPrint('MetaMask signature: ${metamask.value.signature}');
      debugPrint('MetaMask network: ${metamask.value.network}');
      // TODO Check if wallet has NFT
      MinterContracts minterContracts =
          MinterContracts().getMinterContracts(metamask.value.network!)!;
      debugPrint(
          'NFT 721 Address: ${minterContracts.membership721ContractAddr}');
      debugPrint('NFT Address: ${minterContracts.membershipContractAddr}');
      hasMembershipNFT.value = await MembershipNFT().checkNFT(
          metamask.value.address!, minterContracts.membership721ContractAddr!);
      debugPrint("${hasMembershipNFT.value}");
      // https://docs.openzeppelin.com/contracts/2.x/api/token/erc721#IERC721-ownerOf-uint256-
      // https://ethereum.stackexchange.com/questions/118854/how-would-i-go-about-finding-out-whether-an-address-owns-a-specific-nft-or-not
      // https://ethereum.stackexchange.com/questions/96614/how-can-i-verify-ownership-to-allow-resale-of-nfts
      // https://ethereum.stackexchange.com/questions/98233/how-to-find-all-erc721-compliant-nfts-owned-by-an-address-web3-js
    } else {
      debugPrint('MetaMask login failed');
    }
    setState(() {});
    widget.onLogin(hasMembershipNFT.value);
    return success;
  }

  void openDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Center(
          child: Container(
              decoration: BoxDecoration(
                  color: themeMode.value.name == "light"
                      ? Colors.white
                      : Colors.grey[800],
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              constraints: const BoxConstraints(maxWidth: 400),
              height: 300,
              child: Material(
                color: Colors.transparent,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          bool success = await _loginWithMetaMask();
                          if (success) {
                            Navigator.of(context).pop();
                          }
                        },
                        child: SizedBox(
                          height: 150,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 8,
                              ),
                              SvgPicture.asset(
                                'assets/metamask_logo.svg',
                                // fit: BoxFit.fill,
                                width: 60,
                                height: 60,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                'MetaMask',
                                style: Theme.of(context).textTheme.headline2,
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Text(
                                'Connect your MetaMask Wallet',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(color: Colors.transparent, width: 50, height: 15),
          Row(children: [
            IconButton(
                onPressed: () => _switchTheme(),
                icon: Icon(
                  Icons.light_mode,
                  color: themeMode.value.name == "light"
                      ? Colors.black
                      : Colors.white,
                )),
            // const Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 10.0),
            //   child: Text("Activity"),
            // ),
            SelectionContainer.disabled(
                child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 14.0),
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: themeMode.value.name == "light"
                                    ? Colors.black54
                                    : Colors.white,
                                width: 1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(35))),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(35),
                          onTap: () {
                            openDialog(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 13),
                            child: Row(
                              children: [
                                if (metamask.value.address != null)
                                  Row(
                                    children: [
                                      Tooltip(
                                        message: "Copy to Clipboard",
                                        child: InkWell(
                                            onTap: () {
                                              Clipboard.setData(ClipboardData(
                                                  text:
                                                      metamask.value.address));
                                            },
                                            child: Icon(
                                              Icons.copy,
                                              size: 16,
                                              color: themeMode.value.name ==
                                                      "light"
                                                  ? Colors.black
                                                  : Colors.white,
                                            )),
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Container(
                                          constraints: const BoxConstraints(
                                              maxWidth: 80),
                                          child: Text(
                                            '${metamask.value.address}',
                                            overflow: TextOverflow.ellipsis,
                                          )),
                                    ],
                                  ),
                                if (metamask.value.address == null)
                                  const Text(
                                    "Connect Wallet",
                                  ),
                              ],
                            ),
                          ),
                        ))))
          ])
        ]));
  }
}
