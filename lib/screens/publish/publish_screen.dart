import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PublishScreen extends StatefulWidget {
  const PublishScreen({super.key});

  @override
  State<PublishScreen> createState() => _PublishScreenState();
}

class _PublishScreenState extends State<PublishScreen> {
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
          children: <Widget>[
            const SizedBox(
              height: 25,
            ),
            // Container(
            //     decoration: BoxDecoration(
            //         border: Border.all(
            //             color: themeMode.value.name == "light"
            //                 ? Colors.black54
            //                 : Colors.white,
            //             width: 1),
            //         borderRadius: BorderRadius.all(Radius.circular(9))),
            //     child: InkWell(
            //       borderRadius: BorderRadius.circular(9),
            //       onTap: () {},
            //       child: const Padding(
            //         padding:
            //             EdgeInsets.symmetric(vertical: 18.0, horizontal: 23),
            //         child: Text("Create Your NFT"),
            //       ),
            //     )),
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
          ],
        ),
      ],
    );
  }
}
