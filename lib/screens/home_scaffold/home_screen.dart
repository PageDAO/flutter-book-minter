import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pagedao/constants/contractAddr.dart';
import 'package:pagedao/jsPackages/isolate_membership_nft_check.dart';
import 'package:pagedao/jsPackages/metamask.dart';
import 'package:provider/provider.dart';
// import 'package:metamask/metamask.dart'; // With keplr https://docs.keplr.app/api/
import 'package:flutter_svg/flutter_svg.dart';

// import '../../jsPackages/metamask.dart';

class HomeScaffold extends StatefulWidget {
  const HomeScaffold({super.key, required this.title});

  final String title;

  @override
  State<HomeScaffold> createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
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

  ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);
  ValueNotifier<bool> hasMembershipNFT = ValueNotifier(false);

  @override
  void initState() {
    themeMode = Provider.of<ValueNotifier<ThemeMode>>(context, listen: false);
    super.initState();
  }

  var metamask = MetaMask();

  Future<bool> _loginWithMetaMask() async {
    bool success = await metamask.login();

    if (success) {
      debugPrint('MetaMask address: ${metamask.address}');
      debugPrint('MetaMask signature: ${metamask.signature}');
      debugPrint('MetaMask network: ${metamask.network}');
      // TODO Check if wallet has NFT
      MinterContracts minterContracts =
          MinterContracts().getMinterContracts(metamask.network!)!;
      debugPrint(
          'NFT 721 Address: ${minterContracts.membership721ContractAddr}');
      debugPrint('NFT Address: ${minterContracts.membershipContractAddr}');
      hasMembershipNFT.value = await MembershipNFT().checkNFT(
          metamask.address!, minterContracts.membership721ContractAddr!);
      // bool hasToken = await checkNFT(
      //     metamask.address!, minterContracts.membership721ContractAddr!);
      debugPrint("${hasMembershipNFT.value}");
      // https://docs.openzeppelin.com/contracts/2.x/api/token/erc721#IERC721-ownerOf-uint256-
      // https://ethereum.stackexchange.com/questions/118854/how-would-i-go-about-finding-out-whether-an-address-owns-a-specific-nft-or-not
      // https://ethereum.stackexchange.com/questions/96614/how-can-i-verify-ownership-to-allow-resale-of-nfts
      // https://ethereum.stackexchange.com/questions/98233/how-to-find-all-erc721-compliant-nfts-owned-by-an-address-web3-js
    } else {
      debugPrint('MetaMask login failed');
    }
    setState(() {});
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
    return SelectionArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Row(
                  //   children: [
                  //     ValueListenableBuilder<bool>(
                  //         valueListenable: hasMembershipNFT,
                  //         builder: (context, hasNFT, _) {
                  //           return Row(
                  //             children: [
                  //               CircleAvatar(
                  //                 backgroundColor: Colors.yellow[50]!,
                  //                 radius: 35,
                  //                 child: const Icon(Icons.person),
                  //               ),
                  //               const SizedBox(
                  //                 width: 4,
                  //               ),
                  //               Text(hasNFT
                  //                   ? "Welcome Member!"
                  //                   : "Get your membership NFT to Mint books and join the DAO"),
                  //             ],
                  //           );
                  //         })
                  //   ],
                  // ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Page DAO Presents the',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Readme Books NFTBook Minter',
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: themeMode.value.name == "light"
                                      ? Colors.black54
                                      : Colors.white,
                                  width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(9))),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(9),
                            onTap: () {},
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 18.0, horizontal: 23),
                              child: Text("Create Your NFT"),
                            ),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      Image.asset(
                        'assets/page_dao.png',
                        // fit: BoxFit.fill,
                        width: 70,
                        height: 70,
                      ),
                      Text(
                        'Create your NFT',
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        constraints: BoxConstraints(maxWidth: 450),
                        child: const Text(
                          "The PageDAO ReadMe Books NFTBook Minter is designed to give PageDAO Members the opportunity to collaborate in the creation of an NFTBook Collection the DAO owns on OpenSea.io. 1/3 of Royalties received by the DAO go to buy \$PAGE. *This open source technology is in beta, and does not like large files.",
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        " Get started now.",
                        textAlign: TextAlign.justify,
                      ),
                      Center(
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 490),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              if (metamask.address != null)
                                Text('address: ${metamask.address}'),
                              if (metamask.signature != null)
                                Text('signed: ${metamask.signature}'),
                              Text(
                                metamask.address == null
                                    ? 'You are not logged in'
                                    : "You are logged in to ${metamask.network}",
                              ),
                              Text('Metamask support ${metamask.isSupported}'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(color: Colors.transparent, width: 50, height: 15),
                  Row(
                    children: [
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(35))),
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
                                      if (metamask.address != null)
                                        Row(
                                          children: [
                                            Tooltip(
                                              message: "Copy to Clipboard",
                                              child: InkWell(
                                                  onTap: () {
                                                    Clipboard.setData(
                                                        ClipboardData(
                                                            text: metamask
                                                                .address));
                                                  },
                                                  child: Icon(
                                                    Icons.copy,
                                                    size: 16,
                                                    color:
                                                        themeMode.value.name ==
                                                                "light"
                                                            ? Colors.black
                                                            : Colors.white,
                                                  )),
                                            ),
                                            const SizedBox(
                                              width: 12,
                                            ),
                                            Container(
                                                constraints:
                                                    const BoxConstraints(
                                                        maxWidth: 80),
                                                child: Text(
                                                  '${metamask.address}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )),
                                          ],
                                        ),
                                      if (metamask.address == null)
                                        const Text(
                                          "Connect Wallet",
                                        ),
                                    ],
                                  ),
                                ),
                              )),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
