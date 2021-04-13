class MoneyTrack {
  int id;
  String name;
  String income;
  String date;

  MoneyTrack(this.id, this.name, this.income, this.date);

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map['id'] = id;
    map['name'] = name;
    map['income'] = income;
    map['date'] = date;

    return map;
  }

  MoneyTrack.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    income = map['income'].toString();
    date = map['date'];
  }
}
