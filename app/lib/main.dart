import 'package:app/UI/auth.dart';
import 'package:app/UI/dashboard.dart';
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
  //TODO: Automatic Login
  Certificate cert = Certificate();
  if (auth.id != null) {
    cert.getCertificate(auth.id);
  }
	runApp(MultiProvider(
        providers: [
            ChangeNotifierProvider<token.Auth>(create: (_) => auth),
            ChangeNotifierProvider<Certificate>(create: (_) => cert),
        ],
        builder: (context, child) => const App(),
        ),
    );
}

class App extends StatelessWidget {
	const App({super.key});

  	@override
  	Widget build(BuildContext context) {
        String? authToken = Provider.of<token.Auth>(context).token;
  	  	return MaterialApp(
  	  	    title: 'Flutter Demo',
  	  	    theme: ThemeData(
  	  	      	primarySwatch: Colors.blue,
                canvasColor: Colors.white
  	  	    ),
  	  	    home: authToken == null ? const Auth() : Dashboard(),
		);
  	}
}
