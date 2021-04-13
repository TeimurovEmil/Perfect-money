class ExpenseTrack {
  int id;
  String name;
  String expense;
  String date;

  ExpenseTrack(this.id, this.name, this.expense, this.date);

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map['id'] = id;
    map['name'] = name;
    map['expense'] = expense;
    map['date'] = date;

    return map;
  }

  ExpenseTrack.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    expense = map['expense'].toString();
    date = map['date'];
  }
}
