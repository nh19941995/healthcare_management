import 'package:flutter/material.dart';

class MedicalExaminationScreen extends StatefulWidget {
  @override
  _MedicalExaminationScreenState createState() => _MedicalExaminationScreenState();
}

class _MedicalExaminationScreenState extends State<MedicalExaminationScreen> {
  List<String> _statusOptions = ['Tất cả', 'Đang xử lý', 'Từ chối', 'Chấp nhận'];
  String _selectedStatus = 'Tất cả';
  String _searchQuery = '';

  // Updated booking data with phone numbers
  List<Map<String, String>> bookings = [
    {
      'id': '01',
      'title': 'Tạo module mới',
      'patient': 'Nguyen Van A',
      'doctor': 'Nguyen Van B',
      'date': '12/06/2023',
      'status': 'Đang xử lý',
      'phone': '0123456789', // New field
    },
    {
      'id': '02',
      'title': 'Nút mua hàng lỗi',
      'patient': 'Nguyen Van C',
      'doctor': 'Nguyen Van D',
      'date': '12/06/2023',
      'status': 'Đang xử lý',
      'phone': '0987654321', // New field
    },
    {
      'id': '03',
      'title': 'Giỏ hàng tải chậm',
      'patient': 'Nguyen Van E',
      'doctor': 'Nguyen Van F',
      'date': '12/06/2023',
      'status': 'Từ chối',
      'phone': '0112233445', // New field
    },
    {
      'id': '04',
      'title': 'Tạo module chat',
      'patient': 'Nguyen Van G',
      'doctor': 'Nguyen Van H',
      'date': '12/06/2023',
      'status': 'Chấp nhận',
      'phone': '0998877665', // New field
    },
  ];

  List<Map<String, String>> get _filteredBookings {
    return bookings.where((booking) {
      final matchesStatus = _selectedStatus == 'Tất cả' || booking['status'] == _selectedStatus;
      final matchesSearch = booking['patient']!.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesStatus && matchesSearch;
    }).toList();
  }

  void _updateStatus(String newStatus, int index) {
    setState(() {
      bookings[index]['status'] = newStatus;
    });
  }


  Color _getStatusColor(String status) {
    switch (status) {
      case 'Đang xử lý':
        return Colors.amber;
      case 'Từ chối':
        return Colors.red;
      case 'Chấp nhận':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _showConfirmationDialog(String newStatus, int index) {
    String _rejectionReason = ''; // Biến để lưu lý do từ chối

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận thay đổi trạng thái'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Bạn có chắc chắn muốn thay đổi trạng thái thành "$newStatus"?'),
              if (newStatus == 'Từ chối') // Hiển thị TextField nếu trạng thái là "Từ chối"
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Lý do từ chối',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _rejectionReason = value; // Cập nhật lý do từ chối
                    },
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                if (newStatus == 'Từ chối' && _rejectionReason.isEmpty) {
                  // Nếu người dùng chưa nhập lý do từ chối, hiển thị thông báo lỗi
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Vui lòng nhập lý do từ chối.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                Navigator.of(context).pop();
                _updateStatus(newStatus, index);
                if (newStatus == 'Từ chối') {
                  // Xử lý lý do từ chối (ví dụ: lưu lý do vào dữ liệu)
                  print('Lý do từ chối: $_rejectionReason');
                }
              },
              child: Text('Xác nhận'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách thẻ khám bệnh'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // Search and Filter Row
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Tìm kiếm theo tên bệnh nhân',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      DropdownButton<String>(
                        value: _selectedStatus,
                        items: _statusOptions.map((String status) {
                          return DropdownMenuItem<String>(
                            value: status,
                            child: Text(status),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  var booking = _filteredBookings[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Info booking',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          Text('Booking Id: ${booking['id']}'),
                                          Text('Tên bệnh nhân: ${booking['patient']}'),
                                          Text('Tiêu đề: ${booking['title']}'),
                                          Text('Tên bác sĩ: ${booking['doctor']}'),
                                          Text('Ngày đặt lịch: ${booking['date']}'),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            'Current Status',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 4.0),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                backgroundColor: _getStatusColor(booking['status']!),
                                                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                                textStyle: TextStyle(fontSize: 12),
                                              ),
                                              onPressed: () {},
                                              child: Text(booking['status']!),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: _statusOptions
                                      .where((status) => status != 'Tất cả')
                                      .map((status) {
                                    return Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: _getStatusColor(status),
                                            padding: EdgeInsets.symmetric(vertical: 12.0),
                                            textStyle: TextStyle(fontSize: 12),
                                          ),
                                          onPressed: () {
                                            _showConfirmationDialog(status, index);
                                          },
                                          child: Text(status),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                childCount: _filteredBookings.length,
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

}
