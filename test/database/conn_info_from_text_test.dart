import 'package:devhelper/edit_db.dart';
import 'package:test/test.dart';

void main() {
  test('conninfo from text', () {
    var result = extractDbUrl(emailtext: """
Dear me

This is your user and password to access database my-database-prod production, please keep this secret

Username: myusername
Password: mypassword-with-dash
IP: some-host-in-the-amazon-in-something
Expiry Time: 2022-01-21 00:00:00

For further information and support, please send your inquiry to slack channel #help_dba and call @dba-oncall.

Best Regards
Database Administrator Team 
    """);
    expect(result.toString(),
        '//myusername:mypassword-with-dash@some-host-in-the-amazon-in-something/my-database-prod');
  });
}
