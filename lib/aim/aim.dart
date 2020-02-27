class Aim {
  String _index;
  String _aimTitle;
  String _aimContent;
  String _valid;


  Aim(String title, String content, String valid, String index)
      : _index = index,
        _aimTitle = title,
        _aimContent = content,
        _valid = valid;

  String get getTitle => _aimTitle;
  String get getContent => _aimContent;
  String get isValid => _valid;
  String get getIndex => _index;

  set setIndex(String index) => this._index = index;
  set setTitle(String title) => this._aimTitle = title;
  set setContent(String content) => this._aimContent = content;
  set setValid(String valid) => this._valid = valid;

  Aim.fromJson(Map<String, dynamic> jsonMap)
      : _aimTitle = jsonMap['aimTitle'],
        _aimContent = jsonMap['content'],
        _valid = jsonMap['valid'],
        _index = jsonMap['index'];

  Map<String, dynamic> toJson() {
    return {
      "index": this._index,
      "aimTitle": this._aimTitle,
      "content": this._aimContent,
      "valid": this._valid
    };
  }
}
