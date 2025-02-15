import 'package:ledgerly/model/crud_services/crud_service.dart';
import 'package:ledgerly/model/data_classes.dart';

class AccountCrudService extends CrudService<Account> {
  AccountCrudService(super.schema);

  int create({
    required final String name,
    required final User user,
    required final int initialBalance,
    final String? description,
  }) =>
      insert(Account(
        id: -1,
        name: name,
        user: user,
        initialBalance: initialBalance,
        currentBalance: initialBalance,
        description: description,
      ));
}
