import 'package:flutter/material.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final List<Map<String, dynamic>> users = [
    {'id': '001', 'name': 'User A', 'role': 'User'},
    {'id': '002', 'name': 'User B', 'role': 'Admin'},
    {'id': '003', 'name': 'Doctor C', 'role': 'Bác sĩ'},
    // Thêm các người dùng khác
  ];
  List<Map<String, dynamic>> filteredUsers = []; // Danh sách người dùng sau khi lọc
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredUsers = users; // Khởi tạo danh sách lọc ban đầu bằng toàn bộ người dùng
  }

  void filterUsers(String query) {
    setState(() {
      filteredUsers = users.where((user) {
        return user['name'].toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void changeUserRole(BuildContext context, Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) {
        String selectedRole = user['role'];
        return AlertDialog(
          title: Text('Change User Role'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Chọn quyền mới cho ${user['name']}:'),
              DropdownButton<String>(
                value: selectedRole,
                items: ['User', 'Admin', 'Bác sĩ'].map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (newRole) {
                  setState(() {
                    selectedRole = newRole!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  user['role'] = selectedRole;
                });
                Navigator.pop(context);
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void deleteUser(BuildContext context, Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete User'),
          content: Text('Bạn có chắc chắn muốn xóa ${user['name']} không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  users.remove(user);
                  filteredUsers = users; // Cập nhật danh sách sau khi xóa
                });
                Navigator.pop(context);
              },
              child: Text('Yes'),
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
        title: Text('List User'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search by name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (query) => filterUsers(query), // Gọi hàm lọc khi thay đổi nội dung
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return ListTile(
                  title: Text(user['name']),
                  subtitle: Text('Role: ${user['role']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => changeUserRole(context, user),
                        tooltip: 'Change Role',
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => deleteUser(context, user),
                        tooltip: 'Delete User',
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
