import 'package:flutter/material.dart';
import 'package:healthcare_management_app/dto/user_dto.dart';
import 'package:healthcare_management_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<UserDTO> filteredFacilities = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = context.read<UserProvider>();
      userProvider.getAllUser().then((_) {
        setState(() {
          filteredFacilities = userProvider.list;
        });
      });
    });
  }

  // Trả về tất cả các vai trò của người dùng dưới dạng chuỗi
  String getRoles(UserDTO user) {
    if (user.roles == null || user.roles!.isEmpty) return 'No Roles';
    return user.roles!.map((role) => role.name).join(', '); // Gộp tất cả các vai trò thành một chuỗi
  }

  // Filter users by name
  void filterUsers(String query) {
    setState(() {
      filteredFacilities = context.read<UserProvider>().list.where((user) {
        return user.fullName?.toLowerCase().contains(query.toLowerCase()) ?? false;
      }).toList();
    });
  }

  Future<void> changeUserRole(BuildContext context, UserDTO user) async {
    String? selectedRole = user.roles?.isNotEmpty == true
        ? user.roles!.first.name
        : 'PATIENT'; // Mặc định là 'PATIENT' nếu không có role.

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Change User Role',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Select a new role for ${user.fullName}:',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  DropdownButton<String>(
                    value: selectedRole,
                    isExpanded: true, // Cho dropdown chiếm toàn bộ chiều ngang
                    items: ['ADMIN', 'DOCTOR', 'PATIENT', 'RECEPTIONIST']
                        .map((role) => DropdownMenuItem(
                      value: role,
                      child: Text(
                        role,
                        style: TextStyle(fontSize: 14),
                      ),
                    ))
                        .toList(),
                    onChanged: (newRole) {
                      setState(() {
                        selectedRole = newRole; // Cập nhật role ngay lập tức
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (selectedRole == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select a role before confirming.')),
                  );
                  return;
                }

                try {
                  // Cập nhật quyền người dùng
                  user.roles?.clear();
                  user.roles?.add(Role(name: selectedRole));

                  // Cập nhật vai trò người dùng
                  await context.read<UserProvider>().updateUserRole(user.username!, selectedRole!);

                  // Lấy lại danh sách người dùng
                  await context.read<UserProvider>().getAllUser();

                  // Cập nhật lại filteredFacilities
                  setState(() {
                    filteredFacilities = context.read<UserProvider>().list;
                  });

                  // Hiển thị thông báo thành công
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Role updated successfully for ${user.fullName}!')),
                  );

                  Navigator.pop(context);
                } catch (error) {
                  // Hiển thị lỗi
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update role: $error')),
                  );
                }
              },
              child: Text(
                'Confirm',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }




  // Delete user with confirmation dialog
  void deleteUser(BuildContext context, UserDTO user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete User'),
          content: Text('Bạn có chắc chắn muốn xóa ${user.fullName} không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await context.read<UserProvider>().deleteUser(user.username!);
                  setState(() {
                    filteredFacilities.remove(user);
                  });
                } catch (error) {
                  // Thông báo lỗi nếu có
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Xóa không thành công')),
                  );
                }
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
              onChanged: (query) => filterUsers(query), // Call filter function on text change
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredFacilities.length,
              itemBuilder: (context, index) {
                final user = filteredFacilities[index];
                return ListTile(
                  title: Text(user.fullName ?? 'Tên'),
                  subtitle: Text('Roles: ${getRoles(user)}'), // Hiển thị tất cả vai trò
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
