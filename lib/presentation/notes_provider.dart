import 'package:flutter/foundation.dart';

class NotesProvider extends ChangeNotifier {
  int _editOrDeleteIndex = -1;

  int get editOrDeleteIndex => _editOrDeleteIndex;

  bool _isShowContent = true;
  bool get isShowContent => _isShowContent;

  void toggleShowContent() {
    _isShowContent = !_isShowContent;
    notifyListeners();
  }

  void changeIndex(int index) {
    if (index == _editOrDeleteIndex) {
      _editOrDeleteIndex = -1;
    } else {
      _editOrDeleteIndex = index;
    }
    notifyListeners();
  }
}
