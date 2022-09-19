import 'package:flutter/foundation.dart';

class NotesProvider extends ChangeNotifier {
  bool _isShowContent = true;
  bool get isShowContent => _isShowContent;

  void toggleShowContent() {
    _isShowContent = !_isShowContent;
    notifyListeners();
  }
}
