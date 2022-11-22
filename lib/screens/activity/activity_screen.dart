import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
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
              "Activity",
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ],
    );
  }
}
