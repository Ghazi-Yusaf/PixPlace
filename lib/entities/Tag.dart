class Tag {
  final String tagID;
  final String name;
  final String ownerID;

  Tag({this.tagID, this.name, this.ownerID});

  Tag.fromJson(Map<String, dynamic> json)
      : tagID = json['tagID'],
        name = json['name'],
        ownerID = json['ownerID'];

  Map<String, dynamic> toJson() =>
      {'tagID': tagID, 'name': name, 'ownerID': ownerID};
}
