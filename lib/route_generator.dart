import 'package:flutter/material.dart';
import 'package:shay_app/add_calender_event_page.dart';
import 'package:shay_app/chat_page.dart';
import 'package:shay_app/chat_rooms_page.dart';
import 'package:shay_app/clock_page.dart';
import 'package:shay_app/create_event_page.dart';
import 'package:shay_app/register_page.dart';
import 'package:shay_app/create_task_page.dart';
import 'package:shay_app/home_page.dart';
import 'package:shay_app/login_page.dart';
import 'package:shay_app/reset_password_page.dart';
import 'package:shay_app/selected_event_page.dart';
import 'package:shay_app/shift_trades_page.dart';
import 'package:shay_app/task_page.dart';
import 'package:shay_app/settings_page.dart';
import 'package:shay_app/calendar_page.dart';
import 'package:shay_app/team_page.dart';
import 'package:shay_app/blank_page.dart';
import 'package:shay_app/pay_period_page.dart';

/// Route Generator - Idea
///
/// Use this page to define page navigation for the app.
///
/// Each page should have its own route (e.g., '/' for initial route, '/home'
/// for home screen, etc.). Tutorials on route generation will be helpful.

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Get arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => BlankPage());

      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage());

      case '/login/reset':
        return MaterialPageRoute(builder: (_) => ResetPasswordPage());

      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterPage());

      case '/home':
        return MaterialPageRoute(builder: (_) => HomePage());

      case '/home/clock':
        return MaterialPageRoute(builder: (_) => ClockPage());

      case '/home/task':
        return MaterialPageRoute(builder: (_) => TaskPage());

      case '/home/task/create':
        return MaterialPageRoute(builder: (_) => CreateTaskPage());

      case '/home/calendar':
        return MaterialPageRoute(builder: (_) => CalendarPage());

      case '/home/team':
        return MaterialPageRoute(builder: (_) => TeamPage());

      case '/home/settings':
        return MaterialPageRoute(builder: (_) => SettingsPage());

      case '/home/pay':
        return MaterialPageRoute(builder: (_) => PayPeriodPage());

      case '/home/chat':
        return MaterialPageRoute(builder: (_) => RoomsPage());

      case '/home/calendar/create':
        return MaterialPageRoute(builder: (_) => CreateEventPage());

      case '/home/trade':
        return MaterialPageRoute(builder: (_) => ShiftTradePage());

      default:
        // If there is no such named route
        return _errorRoute();
    }
  }

  // _errorRoute() generates a default static page for any invalid routes.

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Route Error'),
          ),
          body: const Center(
            child: Text('Route Error'),
          ),
        );
      },
    );
  }
}
