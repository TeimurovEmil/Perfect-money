import 'package:flutter/material.dart';
import 'package:my_personal_money_app/db/db.dart';
import 'package:my_personal_money_app/db/db_exp.dart';
import 'components/main_buttons.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    updateTotalSum();
  }

  updateTotalSum() async {
    await DBProvider.db.calculateTotal();
    await DBProviderExp.db.calculateTotal();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        title: Text(
          'Учет расходов и доходов',
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bgimage.png'),
              fit: BoxFit.cover),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Доход: ',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                            ),
                            DBProvider.db.incomeSum == null
                                ? Text(
                                    "0 сом",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400),
                                  )
                                : Text(
                                    "${context.watch<DBProvider>().incomeSum.toString()} сом",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(
                                            color: Colors.green[400],
                                            fontWeight: FontWeight.w400),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Расход: ',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                            ),
                            DBProviderExp.db.expSum == null
                                ? Text(
                                    "0 сом",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400),
                                  )
                                : Text(
                                    "-${context.watch<DBProviderExp>().expSum} сом",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(
                                            color: Colors.red[400]
                                                .withOpacity(0.9),
                                            fontWeight: FontWeight.w500),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Разница: ',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                            ),
                            if (DBProviderExp.db.expSum == null)
                              Text(
                                "0 сом",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400),
                              )
                            else
                              Container(
                                child: Text(
                                  "${context.watch<DBProvider>().incomeSum == null ? "-${context.watch<DBProviderExp>().expSum}" : context.watch<DBProvider>().incomeSum - context.watch<DBProviderExp>().expSum} сом",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5
                                      .copyWith(
                                          color: context
                                                      .watch<DBProvider>()
                                                      .incomeSum !=
                                                  null
                                              ? context
                                                              .watch<
                                                                  DBProvider>()
                                                              .incomeSum -
                                                          context
                                                              .watch<
                                                                  DBProviderExp>()
                                                              .expSum <
                                                      0
                                                  ? Colors.red
                                                  : Colors.green
                                              : Colors.white,
                                          fontWeight: FontWeight.w400),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  buttons(context, '/expense', Colors.red.shade600,
                      Icons.remove, Colors.red.shade600),
                  buttons(context, '/income', Colors.green, Icons.add,
                      Colors.green),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
