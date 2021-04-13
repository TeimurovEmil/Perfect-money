import 'package:flutter/material.dart';
import 'package:my_personal_money_app/db/db.dart';
import 'package:my_personal_money_app/models/income_model.dart';
import 'package:intl/intl.dart';

class IncomeScreen extends StatefulWidget {
  @override
  _IncomeScreenState createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formStateKeys = GlobalKey<FormState>();
  final GlobalKey<FormState> _formStateKeyss = GlobalKey<FormState>();
  final _moneyNameController = TextEditingController();
  final _moneyIncomeController = TextEditingController();
  final _dateIncomeController = TextEditingController();

  Future<List<MoneyTrack>> _moneyList;
  String _incomeName;
  String _incomeMoney;
  String _incomeDate;

  int total;
  bool isUpdate = false;
  int moneyIdForUpdate;

  @override
  void initState() {
    super.initState();
    updateMoneyList();
  }

  updateMoneyList() {
    setState(() {
      _moneyList = DBProvider.db.getMoney();
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
        _dateIncomeController.text =
            DateFormat('dd-MM-yyyy').format(_pickedData).toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
              DBProvider.db.calculateTotal();
            }),
        title: Text(
          'Доход',
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
                        _incomeName = value;
                      },
                      controller: _moneyNameController,
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
                        _incomeMoney = value;
                      },
                      controller: _moneyIncomeController,
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
                      onTap: () => _selectedData(context).toString(),
                      keyboardType: TextInputType.datetime,
                      style: TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Выберите дату!';
                        }
                        if (value.trim() == "")
                          return "Нельзя создавать пустоту!";
                        return null;
                      },
                      onSaved: (value) {
                        _incomeDate = value.toString();
                      },
                      controller: _dateIncomeController,
                      decoration: InputDecoration(
                        focusedBorder: new UnderlineInputBorder(
                          borderSide: new BorderSide(
                              color: Colors.greenAccent,
                              width: 2,
                              style: BorderStyle.solid),
                        ),
                        labelText: "Укажите дату",
                        icon: Icon(Icons.date_range, color: Colors.deepPurple),
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
                        DBProvider.db
                            .updateMoney(MoneyTrack(moneyIdForUpdate,
                                _incomeName, _incomeMoney, _incomeDate))
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
                        DBProvider.db.insertMoney(MoneyTrack(
                            null, _incomeName, _incomeMoney, _incomeDate));
                      }
                    }
                    _moneyNameController.text = '';
                    _moneyIncomeController.text = '';
                    _dateIncomeController.text = '';
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
                    _moneyNameController.text = '';
                    _moneyIncomeController.text = '';
                    _dateIncomeController.text = '';
                    setState(() {
                      isUpdate = false;
                      moneyIdForUpdate = null;
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
                  future: _moneyList,
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

  SingleChildScrollView generateList(List<MoneyTrack> moneys) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          child: DataTable(
            horizontalMargin: 15,
            columns: [
              DataColumn(
                label: Text(
                  'Категория',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text('Сумма',
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.bold)),
              ),
              DataColumn(
                label: Text('Дата',
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.bold)),
              ),
              DataColumn(
                label: Text('Удалить',
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.bold)),
              ),
            ],
            rows: moneys
                .map((incomes) => DataRow(cells: [
                      DataCell(Text(incomes.name), onTap: () {
                        setState(() {
                          isUpdate = true;
                          isUpdate = true;
                          moneyIdForUpdate = incomes.id;
                        });
                        _moneyIncomeController.text = incomes.income.toString();
                        _moneyNameController.text = incomes.name;
                        _dateIncomeController.text = incomes.date;
                      }),
                      DataCell(Text("${incomes.income.toString()} сом"),
                          onTap: () {
                        setState(() {
                          isUpdate = true;
                          moneyIdForUpdate = incomes.id;
                        });
                        _moneyIncomeController.text = incomes.income.toString();
                        _moneyNameController.text = incomes.name;
                        _dateIncomeController.text = incomes.date;
                      }),
                      DataCell(Text(incomes.date.toString()), onTap: () {
                        setState(() {
                          isUpdate = true;
                          moneyIdForUpdate = incomes.id;
                        });
                        _moneyIncomeController.text = incomes.income.toString();
                        _moneyNameController.text = incomes.name;
                        _dateIncomeController.text = incomes.date;
                      }),
                      DataCell(IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.deepPurple,
                        ),
                        onPressed: () {
                          setState(() {
                            DBProvider.db.deleteMoney(incomes.id);
                            updateMoneyList();

                            DBProvider.db.calculateTotal();
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
