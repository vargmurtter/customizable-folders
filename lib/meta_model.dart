class MetaModel {
  MetaModel({required this.backgroundName, this.symbol});

  final String backgroundName;
  final String? symbol;

  factory MetaModel.fromMap(Map<String, dynamic> map) {
    return MetaModel(
      backgroundName: map['backgroundName'] as String,
      symbol: map['symbol'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {'backgroundName': backgroundName, 'symbol': symbol};
  }
}
