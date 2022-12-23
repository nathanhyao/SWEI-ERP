import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextStyle cardTextStyle = const TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    return Scaffold(
      body: Stack(
        // Widgets are created from top to bottom of screen, centered
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            // Header background image
            height: size.height * 0.20,
            color: Theme.of(context).colorScheme.primary,
          ),

          // Safe area prevents children from falling off screen
          SafeArea(
            child: ConstrainedBox(
              // UI Constraints for computer screens
              constraints: const BoxConstraints(
                minWidth: 250,
                maxWidth: 500,
                minHeight: 500,
                maxHeight: 1000,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    // Header information container: profile pic and user info
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      height: 64,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        // Display user's profile picture (need?)
                        children: <Widget>[
                          const CircleAvatar(
                            radius: 32,
                            backgroundImage: NetworkImage(
                                'https://st3.depositphotos.com/6672868/13701/v/600/depositphotos_137014128-stock-illustration-user-profile-icon.jpg'),
                          ),
                          const SizedBox(
                            width: 16,
                          ),

                          // Display user information (e.g., Name, Clocked in?)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const <Widget>[
                              Text(
                                'John Smith',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                'Not Clocked In',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),

                    ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            // Pay Period
                            Expanded(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/icons8-wallet-96.png',
                                        height: 60,
                                        width: 60,
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
                            ),

                            // Tasks Board
                            Expanded(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/icons8-todo-list-96.png',
                                        height: 60,
                                        width: 60,
                                      ),
                                      Text(
                                        'Tasks Board',
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
                        Row(
                          children: <Widget>[
                            // Calendar
                            Expanded(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/icons8-calendar-96.png',
                                        height: 60,
                                        width: 60,
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
                            ),

                            // Team Chat
                            Expanded(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/icons8-chat-96.png',
                                        height: 60,
                                        width: 60,
                                      ),
                                      Text(
                                        'Team Chat',
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
                        Row(
                          children: <Widget>[
                            // Shift Trades
                            Expanded(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/icons8-synchronize-96.png',
                                        height: 60,
                                        width: 60,
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
                            ),

                            // Team Members (list)
                            Expanded(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/icons8-member-96.png',
                                        height: 60,
                                        width: 60,
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
                            ),
                          ],
                        ),
                      ],
                    ),

                    Card(
                      margin: const EdgeInsets.only(top: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset('assets/images/icons8-clock-96.png',
                                height: 60, width: 60),
                            Text(
                              'Clock In/Out',
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
            ),
          )
        ],
      ),
    );
  }
}
