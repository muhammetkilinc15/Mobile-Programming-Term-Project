class HomeService {
  Future<String> getHomeData() async {
    await Future.delayed(Duration(seconds: 2));

    return 'Home Data';
  }
}
