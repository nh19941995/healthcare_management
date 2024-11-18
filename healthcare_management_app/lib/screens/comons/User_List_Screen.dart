import 'package:flutter/material.dart';
import 'package:healthcare_management_app/dto/user_dto.dart';
import 'package:healthcare_management_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../dto/role_dto.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<UserDTO> filteredFacilities = [];
  final TextEditingController searchController = TextEditingController();
  String selectedStatus = 'NONDELETED'; // Giá trị logic mặc định là NONDELETED

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  // Hàm để tải người dùng và cập nhật trạng thái danh sách người dùng
  Future<void> _loadUsers() async {
    final userProvider = context.read<UserProvider>();
    await userProvider.getUserActive();
    setState(() {
      filteredFacilities = userProvider.list;
    });
  }
  // Trả về tất cả các vai trò của người dùng dưới dạng chuỗi
  String getRoles(UserDTO user) {
    if (user.roles == null || user.roles!.isEmpty) return 'No Roles';
    return user.roles!.map((role) => role.name).join(', ');
  }

  // Lọc người dùng theo tên
  void filterUsers(String query) {
    setState(() {
      filteredFacilities = context.read<UserProvider>().list.where((user) {
        return user.fullName?.toLowerCase().contains(query.toLowerCase()) ?? false;
      }).toList();
    });
  }

  // Đổi vai trò người dùng
  Future<void> changeUserRole(BuildContext context, UserDTO user) async {
    String? selectedRole = user.roles?.isNotEmpty == true
        ? user.roles!.first.name
        : 'PATIENT';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Change User Role'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return DropdownButton<String>(
                value: selectedRole,
                isExpanded: true,
                items: ['ADMIN', 'DOCTOR', 'PATIENT', 'RECEPTIONIST']
                    .map((role) => DropdownMenuItem(
                  value: role,
                  child: Text(role),
                ))
                    .toList(),
                onChanged: (newRole) {
                  setState(() {
                    selectedRole = newRole!;
                  });
                },
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (selectedRole == null) return;
                try {
                  user.roles?.clear();
                  user.roles?.add(Role(name: selectedRole));

                  await context.read<UserProvider>().updateUserRole(user.username!, selectedRole!);
                  await context.read<UserProvider>().getUserActive();

                  setState(() {
                    filteredFacilities = context.read<UserProvider>().list;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Role updated successfully for ${user.fullName}!')),
                  );

                  Navigator.pop(context);
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update role: $error')),
                  );
                }
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  // Khóa tài khoản
  // Cập nhật lại hàm blockUser với việc đảm bảo cập nhật giao diện ngay sau khi thay đổi
  Future<void> blockUser(BuildContext context, UserDTO user) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(user.lockReason != "shit" ? 'Block User' : 'Unblock User'),
          content: Text(user.lockReason != "shit"
              ? 'Bạn có chắc chắn muốn khóa tài khoản ${user.fullName} không?'
              : 'Bạn có chắc chắn muốn mở lại tài khoản ${user.fullName} không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  if (user.lockReason != "shit") {
                    // Khóa tài khoản
                    await context.read<UserProvider>().blockOrUnblockUser(user.username, "shit");
                  } else {
                    // Mở lại tài khoản
                    await context.read<UserProvider>().blockOrUnblockUser(user.username, "active");
                  }
                  // Cập nhật lại danh sách người dùng ngay lập tức
                  await _loadUsers(); // Cập nhật danh sách người dùng
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(user.lockReason != "shit" ? 'Đã khóa tài khoản' : 'Đã mở lại tài khoản')),
                  );
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Thao tác không thành công: $error')),
                  );
                }
                Navigator.pop(context);
              },
              child: Text(user.lockReason != "shit" ? 'Yes' : 'Unblock'),
            ),
          ],
        );
      },
    );
  }

  // Xóa tài khoản
  void permanentlyDeleteUser(BuildContext context, UserDTO user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete User'),
          content: Text('Bạn có chắc chắn muốn xóa vĩnh viễn tài khoản ${user.fullName} không?'),
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
                    // Cập nhật danh sách
                    filteredFacilities.remove(user);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tài khoản ${user.fullName} đã bị xóa!')),
                  );
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Xóa không thành công: $error')),
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
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search by name',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (query) => filterUsers(query),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<String>(
                    value: selectedStatus,
                    decoration: InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) async {
                      if (value != null) {
                        setState(() {
                          selectedStatus = value == 'ALL' ? 'NONDELETED' : value;
                        });

                        if (selectedStatus == 'NONDELETED') {
                          await context.read<UserProvider>().getUserActive();
                        } else {
                          await context.read<UserProvider>().getUsersByStatus(selectedStatus);
                        }

                        setState(() {
                          filteredFacilities = context.read<UserProvider>().list;
                        });
                      }
                    },
                    items: [
                      DropdownMenuItem(
                        value: 'NONDELETED',
                        child: Text('ALL'),
                      ),
                      DropdownMenuItem(
                        value: 'ACTIVE',
                        child: Text('ACTIVE'),
                      ),
                      DropdownMenuItem(
                        value: 'LOCKED',
                        child: Text('LOCKED'),
                      ),
                      DropdownMenuItem(
                        value: 'DELETED',
                        child: Text('DELETED'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredFacilities.length,
              itemBuilder: (context, index) {
                final user = filteredFacilities[index];
                return ListTile(
                  title: Text(user.fullName ?? 'Tên'),
                  subtitle: Text('Roles: ${getRoles(user)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => changeUserRole(context, user),
                        tooltip: 'Change Role',
                      ),
                      // Hiển thị icon khóa mở nếu user.lockReason != "shit"
                      IconButton(
                        icon: Icon(
                          user.lockReason != "shit"
                              ? Icons.lock_open
                              : Icons.lock, // Hình khóa mở hoặc khóa
                          color: user.lockReason != "shit" ? Colors.green : Colors.red, // Màu sắc biểu tượng
                        ),
                        onPressed: () => blockUser(context, user),
                        tooltip: user.lockReason != "shit" ? 'Unlock User' : 'Lock User',
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => permanentlyDeleteUser(context, user),
                        tooltip: 'Delete User',
                      ),
                    ],
                  ),
                );
              },
            ),
          )

        ],
      ),
    );
  }
}
