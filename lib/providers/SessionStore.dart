import 'package:canknow_aggregate_app/apis/authorization/AuthorizationApis.dart';
import 'package:canknow_aggregate_app/services/TokenServices.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../apis/user/UserApis.dart';

class SessionState {
  final bool isLoggedIn;
  final Map<String, dynamic>? userInfo;
  final bool isLoading;
  final String? error;

  SessionState({
    this.isLoggedIn = false,
    this.userInfo,
    this.isLoading = false,
    this.error,
  });

  SessionState copyWith({
    bool? isLoggedIn,
    Map<String, dynamic>? userInfo,
    bool? isLoading,
    String? error,
  }) {
    return SessionState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      userInfo: userInfo ?? this.userInfo,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

final sessionStore = StateNotifierProvider<SessionNotifier, SessionState>((ref) => SessionNotifier());

class SessionNotifier extends StateNotifier<SessionState> {
  final AuthorizationApis authorizationApis = AuthorizationApis();
  final UserApis userApis = UserApis();

  SessionNotifier() : super(SessionState()) {
    _initializeAsync();
  }

  Future<void> _initializeAsync() async {
    try {
      if (TokenServices.isAuthorized) {
        await getCurrentLoginInformation();
      }
    }
    catch (e) {
      // 静默处理初始化错误，避免应用崩溃
      print('SessionNotifier initialization error: $e');
    }
  }

  setPhoneNumber(String phoneNumber) {
    state.userInfo!['phoneNumber'] = phoneNumber;
  }

  setUserDataInitialized() {
    state.userInfo!['userDataInitialized'] = true;
  }

  Future<void> getCurrentLoginInformation() async {
    try {
      state = state.copyWith(isLoading: true);
      Map<String, dynamic> result = await userApis.currentUser();
      state = state.copyWith(
        isLoading: false,
        isLoggedIn: true,
        userInfo: result['user'],
      );
    }
    catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoggedIn: false,
        error: e.toString(),
      );
    }
  }

  // 登录
  login(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      Map<String, dynamic> response = await authorizationApis.token(data);
      TokenServices.setToken(response['accessToken']);
      getCurrentLoginInformation();
    }
    catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  // 清除错误信息
  void clearError() {
    state = state.copyWith(error: null);
  }

  Future<void> logout() async {
    await TokenServices.clearToken();
    state = state.copyWith(
      isLoggedIn: false,
      userInfo: null,
      error: null,
    );
  }
}