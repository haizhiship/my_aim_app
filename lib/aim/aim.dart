class Aim {
  String _aimTitle;
  String _aimContent;

  Aim(String title, String content)
      : _aimTitle = title,
        _aimContent = content;

  String get getTitle => _aimTitle;
  String get getContent => _aimContent;

  set setTitle(String title) => this._aimTitle = title;
  set setContent(String content) => this._aimContent = content;

  Aim.fromJson(Map<String, dynamic> jsonMap)
      : _aimTitle = jsonMap['aimTitle'],
        _aimContent = jsonMap['content'];

  Map<String, dynamic> toJson(){
    return{
      "aimTitle" : this._aimTitle,
      "content" : this._aimContent
    };
  }
}
