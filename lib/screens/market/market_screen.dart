import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);

  @override
  void initState() {
    themeMode = Provider.of<ValueNotifier<ThemeMode>>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const <Widget>[
            SizedBox(
              height: 25,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "General Marketplace ",
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ],
    );
  }
}
