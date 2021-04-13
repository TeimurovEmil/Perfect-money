import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_personal_money_app/db/db.dart';
import 'package:my_personal_money_app/db/db_exp.dart';
import 'package:provider/provider.dart';
import 'pages/expense_page/expense.dart';
import 'pages/home_page/homepage.dart';
import 'pages/income_page/income.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DBProvider>(create: (context) => DBProvider.db),
        ChangeNotifierProvider<DBProviderExp>(
            create: (context) => DBProviderExp.db)
      ],
      child: MaterialApp(
        title: 'Perfect Money',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Colors.deepPurple[700],
            textTheme:
                GoogleFonts.openSansTextTheme(Theme.of(context).textTheme)),
        initialRoute: '/home',
        routes: {
          '/home': (context) => HomePage(),
          '/expense': (context) => ExpenseScreen(),
          '/income': (context) => IncomeScreen(),
        },
      ),
    );
  }
}
