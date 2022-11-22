import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pagedao/constants/contractAddr.dart';
import 'package:pagedao/jsPackages/isolate_membership_nft_check.dart';
import 'package:pagedao/jsPackages/membership_nft_check.dart';
import 'package:pagedao/screens/activity/activity_screen.dart';
import 'package:pagedao/screens/market/market_screen.dart';
import 'package:pagedao/screens/publish/publish_screen.dart';
import 'package:provider/provider.dart';
// import 'package:metamask/metamask.dart'; // With keplr https://docs.keplr.app/api/
import 'package:flutter_svg/flutter_svg.dart';

import '../jsPackages/metamask.dart';

class TestHomeScaffold extends StatefulWidget {
  const TestHomeScaffold({super.key});

  @override
  State<TestHomeScaffold> createState() => _TestHomeScaffoldState();
}

class _TestHomeScaffoldState extends State<TestHomeScaffold> {
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
  ValueNotifier<String> activeScreen = ValueNotifier("Activity");

  Widget getScreen(String screen) {
    switch (screen) {
      case "Activity":
        return const ActivityScreen();
      case "Publish":
        return const PublishScreen();
      case "Market":
        return const MarketScreen();
      default:
        return const ActivityScreen();
    }
  }

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
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 185,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 45,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        constraints: const BoxConstraints(maxWidth: 900),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: ValueListenableBuilder<bool>(
                                  valueListenable: hasMembershipNFT,
                                  builder: (context, hasNFT, _) {
                                    return Column(
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: hasNFT
                                                  ? const AssetImage(
                                                      'assets/no_member.png')
                                                  : null,
                                              backgroundColor:
                                                  Colors.yellow[50]!,
                                              radius: 35,
                                              child: hasNFT
                                                  ? Container()
                                                  : const Icon(
                                                      Icons.star,
                                                      size: 48,
                                                    ),
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Text(hasNFT
                                                ? "Welcome Member!"
                                                : "Get your membership \nNFT to Mint books \nand join the DAO"),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Center(
                                          child: Container(
                                            constraints: const BoxConstraints(
                                                maxWidth: 490),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                if (metamask.address != null)
                                                  Text(
                                                      'address: ${metamask.address}'),
                                                Text(
                                                  metamask.address == null
                                                      ? 'You are not logged in'
                                                      : "You are logged in to ${metamask.network}",
                                                ),
                                                // Text(
                                                //     'Metamask support ${metamask.isSupported}'),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  const Text(
                                    'Page DAO Presents the',
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Readme Books NFTBook Minter',
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 35, vertical: 6),
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: ValueListenableBuilder<String>(
                          valueListenable: activeScreen,
                          builder: (context, screen, _) {
                            return Row(
                              children: [
                                SelectionContainer.disabled(
                                  child: InkWell(
                                    onTap: () {
                                      activeScreen.value = "Publish";
                                    },
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                            height: 25,
                                            width: 65,
                                            child:
                                                Center(child: Text("Publish"))),
                                        Container(
                                          height: 2,
                                          width: 65,
                                          color: screen == "Publish"
                                              ? Colors.black87
                                              : Colors.transparent,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SelectionContainer.disabled(
                                  child: InkWell(
                                    onTap: () {
                                      activeScreen.value = "Activity";
                                    },
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                            height: 25,
                                            width: 65,
                                            child: Center(
                                                child: Text("Activity"))),
                                        Container(
                                          height: 2,
                                          width: 65,
                                          color: screen == "Activity"
                                              ? Colors.black87
                                              : Colors.transparent,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SelectionContainer.disabled(
                                  child: InkWell(
                                    onTap: () {
                                      activeScreen.value = "Market";
                                    },
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                            height: 25,
                                            width: 65,
                                            child:
                                                Center(child: Text("Market"))),
                                        Container(
                                          height: 2,
                                          width: 65,
                                          color: screen == "Market"
                                              ? Colors.black87
                                              : Colors.transparent,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 35, vertical: 6),
                      constraints: const BoxConstraints(maxWidth: 1000),
                      height: 2,
                      color: Colors.grey[300],
                    )
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: ValueListenableBuilder<String>(
                        valueListenable: activeScreen,
                        builder: (context, screen, _) {
                          Widget widget = getScreen(screen);
                          return widget;
                        }),
                  ),
                ),
              ],
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
