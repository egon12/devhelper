extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension PathWithoutSlash on Uri {
  // return path without slash
  String get pathOnly {
    if (path.isEmpty) return path;
    if (path[0] == '/') return path.substring(1);
    return path;
  }

  String get username {
    if (userInfo.isEmpty) return '';
    return userInfo.split(':')[0];
  }

  String get password {
    if (userInfo.isEmpty) return '';
    var infos = userInfo.split(':');
    if (infos.length > 1) return infos[1];
    return '';
  }
}
