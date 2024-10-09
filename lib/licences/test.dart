class SendOtpModel {

  final int id;
  final String? name;
  final List<String>? listStrings;
  final List<ListMapsModel> listMaps;

  SendOtpModel._({
    required this.id,
    required this.name,
    this.listStrings,
    required this.listMaps,
  });

  factory SendOtpModel.fromJson(Map<String, dynamic> json) {
    return SendOtpModel._(
      id: json['id'],
      name: json['name'],
      listStrings: json['list_strings'] != null ? List<String>.from(json['list_strings']) : null,
      listMaps: List<ListMapsModel>.from(json['list_maps'].map((x) => ListMapsModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (listStrings != null) { data['list_strings'] = listStrings; }
    data['list_maps'] = listMaps.map((x) => x.toJson()).toList();
    return data;
  }

}
class ListMapsModel {

  final int id;
  final String? name;
  final double? virgule;

  ListMapsModel._({
    required this.id,
    this.name,
    this.virgule,
  });

  factory ListMapsModel.fromJson(Map<String, dynamic> json) {
    return ListMapsModel._(
      id: json['id'],
      name: json['name'],
      virgule: json['virgule'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (name != null) { data['name'] = name; }
    if (virgule != null) { data['virgule'] = virgule; }
    return data;
  }

}
