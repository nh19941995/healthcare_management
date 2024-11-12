import 'package:flutter/cupertino.dart';
import 'package:healthcare_management_app/apis/Qa_api.dart';
import 'package:healthcare_management_app/models/Qa.dart';

class QaProvider with ChangeNotifier {
  final QaApi qaApi;
  QaProvider({required this.qaApi}) {
    getAllQa(); // Tải dữ liệu khi khởi tạo
  }

  final List<Qa> _list = [];
  List<Qa> get list => _list;

  Future<void> getAllQa() async {
    final qa = await qaApi.getAllQa();
    _list.clear();
    _list.addAll(qa);

    // In ra danh sách _list để kiểm tra
    print('Danh sách các qa:');
    for (var qa in _list) {
      print(qa); // Sử dụng toString() của Qa hoặc in ra các thuộc tính cụ thể
    }

    notifyListeners();
  }
}
