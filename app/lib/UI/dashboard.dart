import 'package:app/UI/feed.dart';
import 'package:app/UI/license.dart';
import 'package:app/UI/location.dart';
import 'package:app/UI/profile.dart';
import 'package:app/model/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
    const Dashboard({super.key});

    @override
    State<Dashboard> createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {

  final List<Widget> pages = const [
    License(), Location(), Feed() 
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: const Text("svas", style: TextStyle(color: Colors.black87),),
            backgroundColor: Colors.white,
            elevation: 0,
            actions: [
              CircleAvatar(
                child: IconButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Profile())),
                  icon: const Icon(Icons.person) 
                ),
              ),
              const SizedBox(width: 16)
            ],
        ), 
        body: Center(child: pages.elementAt(_selectedIndex)),
        bottomNavigationBar: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.black12, width: 1.0))
            ),
            child: BottomNavigationBar(
                backgroundColor: Colors.white,
                selectedItemColor: Colors.blue,
                unselectedItemColor: Colors.black26,
                selectedFontSize: 12,
                showUnselectedLabels: true,
                currentIndex: _selectedIndex,
                elevation: 0,
                onTap: (int index) {
                    setState(() {
                        _selectedIndex = index;
                    });
                },
                items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.badge),
                      label: "License"
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.store),
                      label: "Locations"
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.newspaper),
                      label: "Feed"
                    )
                ],
        ),
      )
    );
  }
}