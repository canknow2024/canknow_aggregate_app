import 'dart:math';

import 'package:canknow_aggregate_app/providers/SessionStore.dart';
import 'package:canknow_aggregate_app/utils/AvatarUtil.dart';
import 'package:canknow_aggregate_app/utils/ToastUtil.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:canknow_aggregate_app/apis/profile/ProfileApis.dart';
import 'package:canknow_aggregate_app/widgets/GenderSelector.dart';
import 'package:canknow_aggregate_app/widgets/PhoneNumberInputField.dart';
import 'dart:convert';
import '../../apis/file/FileApis.dart';
import 'package:intl/intl.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late TextEditingController _nicknameController;
  late TextEditingController _phoneController;
  File? _avatarFile;
  int? _gender;
  DateTime? _birthday;
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    final user = ref.read(sessionStore).userInfo;
    _nicknameController = TextEditingController(text: user?['userName']);
    _phoneController = TextEditingController(text: user?['phoneNumber']);
    _gender = user?['gender'];
    _birthday = user?['birthday'] != null ? DateTime.parse(user!['birthday']) : null;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        Map<String, dynamic> result = {};

        if (kIsWeb) {
          // Web端通过bytes转base64
          final bytes = await pickedFile.readAsBytes();
          String base64 = base64Encode(bytes);
          result = await FileApis().uploadBase64ByOssId(base64, pickedFile.name);
          
          if (result['url'] != null) {
            setState(() {
              _avatarUrl = result['url'];
              _avatarFile = null; // Web端不使用File
            });
          }
        }
        else {
          // 移动端使用File
          setState(() {
            _avatarFile = File(pickedFile.path);
          });
          
          result = await FileApis().upload(await MultipartFile.fromFile(pickedFile.path, filename: pickedFile.name));
          
          if (result['url'] != null) {
            setState(() {
              _avatarUrl = result['url'];
            });
          }
        }
      }
      catch (e) {
        ToastUtil.showError('头像上传失败: $e');
      }
    }
  }

  void _saveProfile() async {
    final user = ref.read(sessionStore).userInfo;
    
    // 使用intl格式化生日为 yyyy-MM-dd 格式
    String? formattedBirthday;
    if (_birthday != null) {
      formattedBirthday = DateFormat('yyyy-MM-dd').format(_birthday!);
    }
    
    final data = {
      'avatar': _avatarUrl ?? (user?['avatar'] ?? null),
      'phoneNumber': _phoneController.text,
      'email': user?['email'],
      'fullName': user?['fullName'],
      'nickName': _nicknameController.text,
      'gender': _gender ?? 0,
      'birthday': formattedBirthday,
    };
    try {
      await ProfileApis().updateProfile(data);
      // 更新本地用户信息
      await ref.read(sessionStore.notifier).getCurrentLoginInformation();
      if (mounted) Navigator.of(context).pop();
    }
    catch (e) {
      ToastUtil.showError('保存失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(sessionStore).userInfo;

    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        title: const Text('编辑个人资料'),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text('保存'),
          ),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _avatarUrl != null ? NetworkImage(_avatarUrl!) : (_avatarFile != null ? FileImage(_avatarFile!) : AvatarUtil.getAvatarImage(user?['avatar'])),
                    child: _avatarUrl == null && _avatarFile == null && (user?['avatar'] == null || user!['avatar']!.isEmpty) ? const Icon(Icons.person, size: 50) : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Center(
            child: Text('点击更换头像', style: TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 30),
          _buildInfoTile(
            label: '用户名',
            value: user?['userName'],
            showArrow: false,
          ),
          _buildInfoTile(
            label: '用户编号',
            value: user?['number'],
            showArrow: false,
          ),
          _buildInfoTile(
            label: '昵称',
            value: _nicknameController.text,
            onTap: () => _editNickname(context),
          ),
          _buildInfoTile(
            label: '手机号',
            value: _phoneController.text.isNotEmpty ? _phoneController.text : '未设置',
            onTap: () => _editPhone(context),
          ),
          _buildInfoTile(
            label: '邮箱',
            value: user?['email'] ?? '未设置',
            showArrow: false,
          ),
          _buildInfoTile(
            label: '性别',
            value: _gender == 1 ? '女' : _gender == 2 ? '男' : '未选择',
            onTap: () => _selectGender(context),
          ),
          _buildInfoTile(
            label: '生日',
            value: _birthday != null ? '${_birthday!.year}-${_birthday!.month}-${_birthday!.day}' : '未选择',
            onTap: () => _selectBirthday(context),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({required String label, required String value, VoidCallback? onTap, bool showArrow = true,}) {
    return ListTile(
      onTap: onTap,
      title: Text(label),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value),
          if (showArrow) SizedBox(width: 4),
          if (showArrow) Icon(Icons.chevron_right, color: Colors.grey[300]),
        ],
      ),
    );
  }

  Future<void> _editNickname(BuildContext context) async {
    final newNickname = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: _nicknameController.text);
        return AlertDialog(
          title: const Text('修改昵称'),
          content: TextField(
            controller: controller,
            autofocus: true,
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('取消')),
            TextButton(onPressed: () => Navigator.of(context).pop(controller.text), child: const Text('确定')),
          ],
        );
      },
    );
    if (newNickname != null && newNickname.isNotEmpty) {
      setState(() {
        _nicknameController.text = newNickname;
      });
    }
  }
  
  Future<void> _selectGender(BuildContext context) async {
    final selectedGender = await GenderSelector.show(context, value: _gender);
    if (selectedGender != null) {
      setState(() {
        _gender = selectedGender;
      });
    }
  }

  Future<void> _selectBirthday(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthday ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _birthday) {
      setState(() {
        _birthday = picked;
      });
    }
  }

  Future<void> _editPhone(BuildContext context) async {
    final newPhone = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: _phoneController.text);
        return AlertDialog(
          title: const Text('修改手机号'),
          content: PhoneNumberInputField(
            controller: controller,
            hintText: '请输入手机号',
            autofocus: true,
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('取消')),
            TextButton(
              onPressed: () {
                final cleanPhone = controller.text.replaceAll(RegExp(r'[^\d]'), '');
                Navigator.of(context).pop(cleanPhone);
              }, 
              child: const Text('确定')
            ),
          ],
        );
      },
    );
    if (newPhone != null && newPhone.isNotEmpty) {
      setState(() {
        _phoneController.text = newPhone;
      });
    }
  }
} 