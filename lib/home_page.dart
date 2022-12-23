import 'package:flutter/material.dart';
import 'package:shay_app/models/option_item.dart';
import 'package:shay_app/models/option_items.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shay_app/services/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';

// Firebase Core 1.6.0 Usage: FirebaseChatCore.instance.createUserInFirestore
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

/// Home Page

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _announcementController = TextEditingController();
  final double iconSize = 70;
  String announcement = 'Placeholder Announcement';

  TextStyle cardTextStyle = const TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  BoxDecoration background = const BoxDecoration(
    image: DecorationImage(
      alignment: Alignment.topCenter,
      image: AssetImage('assets/images/blue-gradient-background.jpg'),
    ),
  );

  @override
  void initState() {
    fetchAnnouncement().then((value) {
      setState(() {});
    });
    super.initState();
  }

  Future fetchAnnouncement() async {
    http.Response response;
    try {
      response = await http.post(
        Uri.parse(globals.httpURL),
        body: json.encode(
          {
            'key': 'announcement_fetch',
            'teamID': globals.currentTeam.teamID,
          },
        ),
      );
      // debugPrint(response.body);
    } catch (e) {
      globals.showSnackBar(context, 'Network Communication Error');
      return;
    }

    if (response.statusCode == 200) {
      debugPrint('Fetching Announcement: http.get OK');
      final decoded = json.decode(response.body) as Map<String, dynamic>;
      announcement = decoded['announcement'];
      _announcementController.text = decoded['announcement'];
    } else if (response.statusCode == 400) {
      debugPrint('Fetching Announcement: http.get BAD');
    } else {
      debugPrint('Something went wrong. Check server http status codes');
    }
  }

  void saveAnnouncement() {
    Navigator.of(context).pop(_announcementController.text);
  }

  Future<String?> openDialog() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Edit Announcement'),
          content: TextField(
            autofocus: true,
            controller: _announcementController,
            decoration: const InputDecoration(
              hintText: 'Edit Announcement',
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: saveAnnouncement,
              child: const Text('SAVE'),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => globals.isLoggedIn ? false : true,
      child: Scaffold(
        body: Stack(
          // Widgets are created from top to bottom of screen, centered
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              ///////////////////
              /// Header Background
              ///////////////////
              height: size.height * 0.30,
              width: double.infinity,
              color: Theme.of(context).colorScheme.primary,
              // decoration: background, // Custom image for background
            ),

            // Safe area prevents children from falling off screen
            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  // UI Constraints for computer screens
                  constraints: const BoxConstraints(
                    minWidth: 300,
                    maxWidth: 450,
                    minHeight: 500,
                    maxHeight: 930,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        ///////////////////
                        /// User Information (Page Header)
                        ///////////////////
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          height: 60,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            // Display user's profile picture (need?)
                            children: <Widget>[
                              ///////////////////
                              /// User Circle Avatar
                              ///////////////////
                              const CircleAvatar(
                                radius: 32,
                                backgroundImage: AssetImage(
                                    'assets/images/blank-user-profile-2.jpg'),
                              ),

                              const SizedBox(width: 16),

                              ///////////////////
                              /// User's Name and Current Team
                              ///////////////////
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const SizedBox(height: 15),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          globals.currentUser.name,
                                          style: const TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 22,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Expanded(
                                    //   child: SingleChildScrollView(
                                    //     scrollDirection: Axis.horizontal,
                                    //     child: Text(
                                    //       globals.currentTeam.name,
                                    //       style: const TextStyle(
                                    //         fontFamily: 'Inter',
                                    //         fontWeight: FontWeight.bold,
                                    //         color: Colors.white,
                                    //         fontSize: 15,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),

                              ///////////////////
                              /// Options Menu
                              ///////////////////
                              const PopUpMenu(
                                menuList: OptionItems.itemsFirst,
                                icon: Icon(
                                  Icons.list,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 40,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,

                            // Display user's profile picture (need?)
                            children: <Widget>[
                              ///////////////////
                              /// User's Name and Current Team
                              ///////////////////
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Text(
                                    'Announcement: $announcement',
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),

                              //////////////////
                              /// Refresh Button (For Loading Announcements)
                              ///////////////////
                              IconButton(
                                tooltip: 'Refresh',
                                color: Colors.white,
                                icon: const Icon(Icons.refresh),
                                onPressed: () {
                                  //////////////////////////////////////////////
                                  /// Yes, we're going to use the homepage
                                  /// refresh button as a checker for Firebase
                                  /// Authentication.
                                  //////////////////////////////////////////////
                                  FirebaseAuth.instance
                                      .authStateChanges()
                                      .listen((User? user) {
                                    if (user != null) {
                                      debugPrint(user.uid);
                                    } else {
                                      debugPrint(
                                          'Firebase User Not Authenticated Yet');
                                      debugPrint(globals.errorMessage);
                                    }
                                  });

                                  // Re-fetch Announcements
                                  fetchAnnouncement().then((value) {
                                    setState(() {});
                                  });
                                },
                              ),

                              //////////////////
                              /// Global Announcements Edit Dialogue
                              ///////////////////
                              IconButton(
                                tooltip: 'Edit',
                                color: Colors.white,
                                icon: const Icon(Icons.edit, size: 24),
                                onPressed: () async {
                                  // TextField should contains announcement
                                  _announcementController.text =
                                      this.announcement;

                                  // Announcement Updates Here!
                                  final announcement = await openDialog();
                                  if (announcement == null) return;

                                  http.Response response;
                                  try {
                                    response = await http.post(
                                      Uri.parse(globals.httpURL),
                                      body: json.encode(
                                        {
                                          'key': 'announcement_save',
                                          'teamID': globals.currentTeam.teamID,
                                          'newAnnouncement': announcement,
                                        },
                                      ),
                                    );
                                    // debugPrint(response.body);
                                  } catch (e) {
                                    // ignore: use_build_context_synchronously
                                    globals.showSnackBar(
                                        context, 'Network Communication Error');
                                    return;
                                  }

                                  if (response.statusCode == 200) {
                                    // ignore: use_build_context_synchronously
                                    globals.showSnackBar(
                                      context,
                                      'Announcement Saved',
                                    );
                                    debugPrint(
                                        'Saving Announcement: http.get OK');
                                  } else if (response.statusCode == 400) {
                                    debugPrint(
                                        'Saving Announcement: http.get BAD');
                                  } else {
                                    debugPrint(
                                        'Something went wrong. Check server http status codes');
                                  }

                                  // Refresh page to display new announcement
                                  setState(() {
                                    this.announcement = announcement;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        Expanded(
                          child: GridView.count(
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            crossAxisCount: 2,
                            children: <Widget>[
                              ///////////////////
                              /// Pay Period
                              ///////////////////
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed('/home/pay');
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 7,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/justicon-wallet-icon.png',
                                        height: iconSize,
                                        width: iconSize,
                                      ),
                                      Text(
                                        'Pay Period',
                                        textAlign: TextAlign.center,
                                        style: cardTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              ///////////////////
                              /// Task Board
                              ///////////////////
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed('/home/task');
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 7,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/flaticon-to-do-list.png',
                                        height: iconSize,
                                        width: iconSize,
                                      ),
                                      Text(
                                        'Task Board',
                                        textAlign: TextAlign.center,
                                        style: cardTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              ///////////////////
                              /// Calendar
                              ///////////////////
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed('/home/calendar');
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 7,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/freepik-schedule-calendar.png',
                                        height: iconSize,
                                        width: iconSize,
                                      ),
                                      Text(
                                        'Calendar',
                                        textAlign: TextAlign.center,
                                        style: cardTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              ///////////////////
                              /// Team Chat (Now "Messages")
                              ///////////////////
                              GestureDetector(
                                onTap: () async {
                                  // Create the group room

                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pushNamed('/home/chat');
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 7,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/freepik-chat-icon.png',
                                        height: iconSize,
                                        width: iconSize,
                                      ),
                                      Text(
                                        'Messages',
                                        textAlign: TextAlign.center,
                                        style: cardTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              ///////////////////
                              /// Shift Trades
                              ///////////////////
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed('/home/trade');
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 7,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/freepik-cycle-trading-icon.png',
                                        height: iconSize,
                                        width: iconSize,
                                      ),
                                      Text(
                                        'Shift Trades',
                                        textAlign: TextAlign.center,
                                        style: cardTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              ///////////////////
                              /// Team Members
                              ///////////////////
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed('/home/team');
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 7,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/freepik-team-icon.png',
                                        height: iconSize,
                                        width: iconSize,
                                      ),
                                      Text(
                                        'Team Members',
                                        textAlign: TextAlign.center,
                                        style: cardTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        ///////////////////
                        /// Clock In/Out
                        ///////////////////
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed('/home/clock');
                          },
                          child: Card(
                            margin: const EdgeInsets.only(top: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 7,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                                bottom: 20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                      'assets/images/freepik-clock-icon.png',
                                      height: iconSize,
                                      width: iconSize),
                                  Text(
                                    'Clock In/Out',
                                    textAlign: TextAlign.center,
                                    style: cardTextStyle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PopUpMenu extends StatelessWidget {
  final List<OptionItem> menuList;
  final Widget? icon;

  const PopUpMenu({super.key, required this.menuList, this.icon});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<OptionItem>(
      tooltip: 'Options Menu',
      onSelected: (item) => onSelected(context, item),
      itemBuilder: (context) => [
        ...OptionItems.itemsFirst.map(buildItem).toList(),
        const PopupMenuDivider(),
        ...OptionItems.itemsSecond.map(buildItem).toList(),
      ],
      icon: icon,
    );
  }

  PopupMenuItem<OptionItem> buildItem(OptionItem item) =>
      PopupMenuItem<OptionItem>(
        value: item,
        child: Row(
          children: [
            Icon(item.icon, size: 20),
            const SizedBox(width: 12),
            Text(item.text),
          ],
        ),
      );

  void onSelected(BuildContext context, OptionItem item) {
    switch (item) {
      case OptionItems.itemSettings:
        Navigator.of(context).pushNamed('/home/settings');
        break;
      case OptionItems.itemSignOut:
        signOut(context);
        break;
    }
  }
}

void signOut(BuildContext context) async {
  globals.isLoggedIn = false;
  Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
  await FirebaseAuth.instance.signOut();
}
