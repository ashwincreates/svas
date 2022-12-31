import 'package:app/UI/auth.dart';
import 'package:app/UI/dashboard.dart';
import 'package:app/model/license.dart';
import 'package:app/model/area.dart';
import 'package:app/model/auth.dart' as token;
import 'package:app/model/certificate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load();
  String? authToken = await const FlutterSecureStorage().read(key: "jwt");
  token.Auth auth = token.Auth(authToken);

  //TODO: Automatic Login using Token

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<token.Auth>(create: (_) => auth),
        // ChangeNotifierProvider<Certificate>(create: (_) => cert),
        // ChangeNotifierProxyProvider<token.Auth, License>(create: (_) => lic),
        ChangeNotifierProxyProvider<token.Auth, Certificate>(
            create: (_) => Certificate(),
            update: (context, auth, certificate) {
              debugPrint("Auth Update");
              if (certificate != null) {
                certificate.getCertificate(auth.id);
              }
              return certificate!;
            }),
        ChangeNotifierProxyProvider2<token.Auth, Certificate, License>(
            create: (_) => License(),
            update: (context, auth, certificate, license) {
              debugPrint("Certificate Update");
              if (license != null && certificate.certificateId != null && auth.id != null) {
				license.auth = auth;
                license.getLicenses();
              }
              return license!;
            }),
        ChangeNotifierProvider<Area>(create: (_) => Area()),
      ],
      builder: (context, child) => const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // String? authToken = Provider.of<token.Auth>(context).token;
    num? vendorId = Provider.of<token.Auth>(context).id;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, canvasColor: Colors.white),
      home: vendorId == null ? const Auth() : const Dashboard(), // TODO: Replace with Token later
    );
  }
}
