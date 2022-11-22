import 'package:flutter/material.dart';
import 'package:pagedao/jsPackages/metamask.dart';
import 'package:provider/provider.dart';

class MainProvider extends StatefulWidget {
  final Widget child;
  const MainProvider({required this.child, super.key});

  @override
  State<MainProvider> createState() => _MainProviderState();
}

class _MainProviderState extends State<MainProvider> {
  ///
  ///    All the values that need to be stored and fetched throughout the
  ///    rest of the application.
  ///

  ValueNotifier<bool> hasMembershipNFT = ValueNotifier(false);
  ValueNotifier<MetaMask> metamask = ValueNotifier(MetaMask());

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<ValueNotifier<bool>>.value(
        value: hasMembershipNFT,
      ),
      ChangeNotifierProvider<ValueNotifier<MetaMask>>.value(
        value: metamask,
      ),
    ], child: widget.child);
  }
}
