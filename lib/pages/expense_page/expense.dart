import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_personal_money_app/db/db_exp.dart';
import 'package:my_personal_money_app/models/expense_model.dart';

class ExpenseScreen extends StatefulWidget {
  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formStateKeys = GlobalKey<FormState>();
  final GlobalKey<FormState> _formStateKeyss = GlobalKey<FormState>();
  final _expNameController = TextEditingController();
  final _moneyExpController = TextEditingController();
  final _expDateController = TextEditingController();

  Future<List<ExpenseTrack>> _expList;
  String _expName;
  String _expMoney;
  String _expDate;
  int total;
  bool isUpdate = false;
  int expIdForUpdate;

  @override
  void initState() {
    super.initState();
    updateMoneyList();
  }

  updateMoneyList() {
    setState(() {
      _expList = DBProviderExp.db.getExpMoney();
    });
  }

  DateTime _datetime = DateTime.now();
  _selectedData(BuildContext context) async {
    var _pickedData = await showDatePicker(
        context: context,
        initialDate: _datetime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (_pickedData != null) {
      setState(() {
        _datetime = _pickedData;
        _expDateController.text =
            DateFormat('dd-MM-yyyy').format(_pickedData).toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          'Расход',
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: <Widget>[
            Form(
              key: _formStateKey,
              // ignore: deprecated_member_use
              autovalidate: true,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: TextFormField(
                      style: TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Введите Категорию';
                        }
                        if (value.trim() == "")
                          return "Нельзя создавать пустоту!";
                        return null;
                      },
                      onSaved: (value) {
                        _expName = value;
                      },
                      controller: _expNameController,
                      decoration: InputDecoration(
                        focusedBorder: new UnderlineInputBorder(
                          borderSide: new BorderSide(
                              color: Colors.greenAccent,
                              width: 2,
                              style: BorderStyle.solid),
                        ),
                        labelText: "Категория",
                        icon: Icon(
                          Icons.restaurant,
                          color: Colors.deepPurple,
                        ),
                        fillColor: Colors.black,
                        labelStyle: TextStyle(
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Form(
              key: _formStateKeys,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Укажите сумму';
                        }
                        if (value.trim() == "")
                          return "Нельзя создавать пустоту!";
                        return null;
                      },
                      onSaved: (value) {
                        _expMoney = value;
                      },
                      controller: _moneyExpController,
                      decoration: InputDecoration(
                        focusedBorder: new UnderlineInputBorder(
                          borderSide: new BorderSide(
                              color: Colors.greenAccent,
                              width: 2,
                              style: BorderStyle.solid),
                        ),
                        labelText: "Укажите сумму",
                        icon: Icon(
                          Icons.attach_money,
                          color: Colors.deepPurple,
                        ),
                        fillColor: Colors.white,
                        labelStyle: TextStyle(
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Form(
              key: _formStateKeyss,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Укажите дату';
                        }
                        if (value.trim() == "")
                          return "Нельзя создавать пустоту!";
                        return null;
                      },
                      onSaved: (value) {
                        _expDate = value;
                      },
                      onTap: () => _selectedData(context),
                      controller: _expDateController,
                      decoration: InputDecoration(
                        focusedBorder: new UnderlineInputBorder(
                          borderSide: new BorderSide(
                              color: Colors.greenAccent,
                              width: 2,
                              style: BorderStyle.solid),
                        ),
                        labelText: "Укажите дату",
                        icon: Icon(
                          Icons.date_range,
                          color: Colors.deepPurple,
                        ),
                        fillColor: Colors.white,
                        labelStyle: TextStyle(
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green)),
                  child: Text(
                    (isUpdate ? 'Обновить' : 'Добавить'),
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    if (isUpdate) {
                      if (_formStateKey.currentState.validate() ||
                          _formStateKeys.currentState.validate() ||
                          _formStateKeyss.currentState.validate()) {
                        _formStateKey.currentState.save();
                        _formStateKeys.currentState.save();
                        _formStateKeyss.currentState.save();
                        DBProviderExp.db
                            .updateMoney(ExpenseTrack(
                                expIdForUpdate, _expName, _expMoney, _expDate))
                            .then((data) {
                          setState(() {
                            isUpdate = false;
                          });
                        });
                      }
                    } else {
                      if (_formStateKey.currentState.validate() ||
                          _formStateKeys.currentState.validate() ||
                          _formStateKeyss.currentState.validate()) {
                        _formStateKey.currentState.save();
                        _formStateKeys.currentState.save();
                        _formStateKeyss.currentState.save();
                        DBProviderExp.db.insertMoney(
                            ExpenseTrack(null, _expName, _expMoney, _expDate));
                      }
                    }
                    _expNameController.text = '';
                    _moneyExpController.text = '';
                    _expDateController.text = '';
                    updateMoneyList();
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red)),
                  child: Text(
                    (isUpdate ? 'Отменить' : 'Очистить'),
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    _expNameController.text = '';
                    _moneyExpController.text = '';
                    _expDateController.text = '';
                    setState(() {
                      isUpdate = false;
                      expIdForUpdate = null;
                    });
                  },
                ),
              ],
            ),
            const Divider(
              height: 5.0,
            ),
            Expanded(
              child: Container(
                child: FutureBuilder(
                  future: _expList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return generateList(snapshot.data);
                    }
                    if (snapshot.data == null || snapshot.data.lenght == 0) {
                      return Text('Данные не найдены!');
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView generateList(List<ExpenseTrack> expenses) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          child: DataTable(
            columns: [
              DataColumn(
                label: Text(
                  'Категория',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                      color: Colors.red[400], fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text('Сумма',
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                        color: Colors.red[400], fontWeight: FontWeight.bold)),
              ),
              DataColumn(
                label: Text('Дата',
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                        color: Colors.red[400], fontWeight: FontWeight.bold)),
              ),
              DataColumn(
                  label: Text('Удалить',
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                          color: Colors.red[400],
                          fontWeight: FontWeight.bold))),
            ],
            rows: expenses
                .map((money) => DataRow(cells: [
                      DataCell(Text(money.name), onTap: () {
                        setState(() {
                          isUpdate = true;

                          expIdForUpdate = money.id;
                        });
                        _moneyExpController.text = money.expense.toString();
                        _expNameController.text = money.name;
                        _expDateController.text = money.date;
                      }),
                      DataCell(Text("-${money.expense.toString()} сом"),
                          onTap: () {
                        setState(() {
                          isUpdate = true;
                          expIdForUpdate = money.id;
                        });
                        _moneyExpController.text = money.expense.toString();
                        _expNameController.text = money.name;
                        _expDateController.text = money.date;
                      }),
                      DataCell(Text(money.date.toString()), onTap: () {
                        setState(() {
                          isUpdate = true;
                          expIdForUpdate = money.id;
                        });
                        _moneyExpController.text = money.expense.toString();
                        _expNameController.text = money.name;
                        _expDateController.text = money.date;
                      }),
                      DataCell(IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.deepPurple,
                        ),
                        onPressed: () {
                          setState(() {
                            DBProviderExp.db.deleteMoney(money.id);
                            updateMoneyList();

                            DBProviderExp.db.calculateTotal();
                          });
                        },
                      ))
                    ]))
                .toList(),
          ),
        ),
      ),
    );
  }
}
