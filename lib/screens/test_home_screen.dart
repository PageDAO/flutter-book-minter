import 'package:flutter/material.dart';
import 'package:pagedao/screens/activity/activity_screen.dart';
import 'package:pagedao/screens/home_scaffold/top_bar.dart';
import 'package:pagedao/screens/market/market_screen.dart';
import 'package:pagedao/screens/publish/publish_screen.dart';
import 'package:provider/provider.dart';
// import 'package:metamask/metamask.dart'; // With keplr https://docs.keplr.app/api/

import '../jsPackages/metamask.dart';

class TestHomeScaffold extends StatefulWidget {
  const TestHomeScaffold({super.key});

  @override
  State<TestHomeScaffold> createState() => _TestHomeScaffoldState();
}

class _TestHomeScaffoldState extends State<TestHomeScaffold> {
  ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);
  ValueNotifier<bool> hasMembershipNFT = ValueNotifier(false);
  ValueNotifier<String> activeScreen = ValueNotifier("Publish");
  ValueNotifier<MetaMask> metamask = ValueNotifier(MetaMask());
  ValueNotifier<String> screenSize = ValueNotifier("desktop");

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
    hasMembershipNFT = Provider.of<ValueNotifier<bool>>(context, listen: false);
    metamask = Provider.of<ValueNotifier<MetaMask>>(context, listen: false);
    super.initState();
  }

  void getScreenSize(Size size) {
    double width = size.width;
    if (width < 600) {
      screenSize.value = "mobile";
    } else if (width >= 600) {
      screenSize.value = "desktop";
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    getScreenSize(size);
    return ValueListenableBuilder<String>(
        valueListenable: screenSize,
        builder: (context, screen, _) {
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
                        child: ValueListenableBuilder<MetaMask>(
                            valueListenable: metamask,
                            builder: (context, _metamask, _) {
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 45,
                                  ),
                                  // Top Section
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 35),
                                    constraints:
                                        const BoxConstraints(maxWidth: 900),
                                    child: screen == "desktop"
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: ValueListenableBuilder<
                                                        bool>(
                                                    valueListenable:
                                                        hasMembershipNFT,
                                                    builder:
                                                        (context, hasNFT, _) {
                                                      return Column(
                                                        children: [
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              CircleAvatar(
                                                                backgroundImage: hasNFT
                                                                    ? const AssetImage(
                                                                        'assets/no_member.png')
                                                                    : null,
                                                                backgroundColor:
                                                                    Colors.yellow[
                                                                        50]!,
                                                                radius: 35,
                                                                child: hasNFT
                                                                    ? Container()
                                                                    : const Icon(
                                                                        Icons
                                                                            .star,
                                                                        size:
                                                                            48,
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
                                                            height: 14,
                                                          ),
                                                          Center(
                                                            child: Container(
                                                              constraints:
                                                                  const BoxConstraints(
                                                                      maxWidth:
                                                                          490),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: <
                                                                    Widget>[
                                                                  if (metamask
                                                                          .value
                                                                          .address !=
                                                                      null)
                                                                    Text(
                                                                        'address: ${_metamask.address}'),
                                                                  Text(
                                                                    _metamask.address ==
                                                                            null
                                                                        ? 'You are not logged in'
                                                                        : "You are logged in to ${_metamask.network}",
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
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline4,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              ValueListenableBuilder<bool>(
                                                  valueListenable:
                                                      hasMembershipNFT,
                                                  builder:
                                                      (context, hasNFT, _) {
                                                    return Column(
                                                      children: [
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            CircleAvatar(
                                                              backgroundImage: hasNFT
                                                                  ? const AssetImage(
                                                                      'assets/no_member.png')
                                                                  : null,
                                                              backgroundColor:
                                                                  Colors.yellow[
                                                                      50]!,
                                                              radius: 35,
                                                              child: hasNFT
                                                                  ? Container()
                                                                  : const Icon(
                                                                      Icons
                                                                          .star,
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
                                                          height: 14,
                                                        ),
                                                        Center(
                                                          child: Container(
                                                            constraints:
                                                                const BoxConstraints(
                                                                    maxWidth:
                                                                        490),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                if (metamask
                                                                        .value
                                                                        .address !=
                                                                    null)
                                                                  Text(
                                                                      'address: ${_metamask.address}'),
                                                                Text(
                                                                  _metamask.address ==
                                                                          null
                                                                      ? 'You are not logged in'
                                                                      : "You are logged in to ${_metamask.network}",
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
                                              Column(
                                                children: [
                                                  const Text(
                                                    'Page DAO Presents the',
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    'Readme Books NFTBook Minter',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline4,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                  ),
                                ],
                              );
                            }),
                      ),
                      // Tab Bar
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
                                                  child: Center(
                                                      child: Text("Publish"))),
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
                                                  child: Center(
                                                      child: Text("Market"))),
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
                            margin: const EdgeInsets.symmetric(
                              horizontal: 35,
                            ),
                            constraints: const BoxConstraints(maxWidth: 835),
                            height: 1,
                            color: Colors.black87,
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
                  TopAppBar(onLogin: (bool hasMembership) {
                    setState(() {});
                  })
                ],
              ),
            ),
          );
        });
  }
}
