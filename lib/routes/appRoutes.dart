import 'package:canknow_aggregate_app/pages/IndexPage.dart';
import 'package:canknow_aggregate_app/pages/task/AICreateTaskPage.dart';
import 'package:flutter/cupertino.dart';
import '../pages/login/LoginPage.dart';
import '../pages/me/BindPhonePage.dart';
import '../pages/me/MePage.dart';
import '../pages/setting/SettingsPage.dart';
import '../pages/setting/LanguageSettingPage.dart';
import '../pages/setting/ThemeSettingPage.dart';
import '../pages/setting/NotificationSettingPage.dart';
import '../pages/interestSetting/InterestSettingPage.dart';
import '../pages/task/CreateTaskPage.dart';
import '../pages/task/MakeUpCheckInPage.dart';
import '../pages/task/MyTaskPage.dart';
import '../pages/task/TaskDetailPage.dart';
import '../pages/task/TaskPage.dart';
import '../pages/task/TaskSearchPage.dart';
import 'package:go_router/go_router.dart';
import '../pages/me/EditProfilePage.dart';
import '../pages/home/HomeSearchPage.dart';
import '../pages/about/AboutUsPage.dart';
import '../pages/task/TaskTemplateSelectPage.dart';
import '../pages/splash/SplashPage.dart';
import '../pages/protocol/PrivacyPolicyPage.dart';
import '../pages/protocol/UserAgreementPage.dart';
import '../pages/splash/AdPage.dart';
import '../pages/taskTopic/TaskTopicPage.dart';
import '../pages/discover/DiscoverSearchPage.dart';
import '../pages/me/AccountSecurityPage.dart';
import '../pages/task/TaskCategoryAllPage.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String ad = '/ad';
  static const String home = '/';
  static const String login = '/login';
  static const String verificationCode = '/login/verification';
  static const String me = '/me';
  static const String bindPhone = '/me/bindPhone';
  static const String settings = '/settings';
  static const String interestSetting = '/interest-setting';
  static const String editProfile = '/me/edit';
  static const String createTask = '/task/create';
  static const String createTaskByAI = '/task/createByAI';
  static const String myTask = '/task/my';
  static const String taskDetail = '/task/detail/:id';
  static const String taskList = '/task/list';
  static const String taskSearch = '/task/search';
  static const String homeSearch = '/home-search';
  static const String about = '/about';
  static const String templateSelect = '/task/template-select';
  static const String makeUpCheckIn = '/make-up-check-in';
  static const String privacyPolicy = '/privacy-policy';
  static const String userAgreement = '/user-agreement';
  static const String themeSetting = '/theme-setting';
  static const String languageSetting = '/language-setting';
  static const String notificationSetting = '/notification-setting';
  static const String taskTopic = '/task-topic';
  static const String discoverSearch = '/discover-search';
  static const String accountSecurity = '/account-security';
  static const String taskCategoryAll = '/task-category-all';

  static List<GoRoute> getRoutes() {
    return [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: home,
        builder: (context, state) => IndexPage(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => LoginPage(),
      ),
      GoRoute(
        path: me,
        builder: (context, state) => MePage(),
      ),
      GoRoute(
        path: bindPhone,
        builder: (context, state) => BindPhonePage(),
      ),
      GoRoute(
        path: settings,
        builder: (context, state) => SettingsPage(),
      ),
      GoRoute(
        path: themeSetting,
        builder: (context, state) => const ThemeSettingPage(),
      ),
      GoRoute(
        path: languageSetting,
        builder: (context, state) => const LanguageSettingPage(),
      ),
      GoRoute(
        path: notificationSetting,
        builder: (context, state) => const NotificationSettingPage(),
      ),
      GoRoute(
        path: interestSetting,
        builder: (context, state) => InterestSettingPage(),
      ),
      GoRoute(
        path: editProfile,
        builder: (context, state) => EditProfilePage(),
      ),
      GoRoute(
        path: createTask,
        builder: (context, state) => CreateTaskPage(),
      ),
      GoRoute(
        path: createTaskByAI,
        builder: (context, state) => AICreateTaskPage(),
      ),
      GoRoute(
        path: myTask,
        builder: (context, state) => MyTaskPage(),
      ),
      GoRoute(
        path: taskList,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return TaskPage(
            title: extra?['title'] as String? ?? '任务列表',
            filterParams: extra?['filterParams'] as Map<String, dynamic>?,
          );
        },
      ),
      GoRoute(
        path: taskDetail,
        builder: (BuildContext context, GoRouterState state) {
          final String id = state.pathParameters['id']!;
          return TaskDetailPage(id: id);
        },
      ),
      GoRoute(
        path: taskSearch,
        builder: (context, state) => TaskSearchPage(),
      ),
      GoRoute(
        path: homeSearch,
        builder: (context, state) => HomeSearchPage(),
      ),
      GoRoute(
        path: about,
        builder: (context, state) => AboutUsPage(),
      ),
      GoRoute(
        path: templateSelect,
        builder: (context, state) => TaskTemplateSelectPage(),
      ),
      GoRoute(
        path: makeUpCheckIn,
        builder: (context, state) => MakeUpCheckInPage(),
      ),
      GoRoute(
        path: privacyPolicy,
        builder: (context, state) => PrivacyPolicyPage(),
      ),
      GoRoute(
        path: userAgreement,
        builder: (context, state) => UserAgreementPage(),
      ),
      GoRoute(
        path: ad,
        builder: (context, state) => AdPage(),
      ),
      GoRoute(
        path: taskTopic,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          final recommend = args?['recommend'] == true;
          return TaskTopicPage(recommend: recommend);
        },
      ),
      GoRoute(
        path: discoverSearch,
        builder: (context, state) => DiscoverSearchPage(),
      ),
      GoRoute(
        path: accountSecurity,
        builder: (context, state) => const AccountSecurityPage(),
      ),
      GoRoute(
        path: taskCategoryAll,
        builder: (context, state) => TaskCategoryAllPage(),
      ),
    ];
  }

  static List<String> getPublicRoutes() {
    return [
      splash,
      ad,
      login,
      verificationCode,
      privacyPolicy,
      userAgreement,
    ];
  }

  static bool isLoginRoute(String routeName) {
    return routeName == login;
  }

  static bool isPublicRoute(String routeName) {
    return getPublicRoutes().contains(routeName);
  }

  static List<String> getRouteNames() {
    return getRoutes().map((route) => route.path).toList();
  }
}
