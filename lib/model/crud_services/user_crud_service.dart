import 'package:ledgerly/model/crud_services/crud_service.dart';
import 'package:ledgerly/model/data_classes.dart';

class UserCrudService extends CrudService<User> {
  UserCrudService(super.schema);

  int register({
    required final String name,
    required final int currencyPrecision,
    required final String currency,
  }) =>
      insert(User(
        id: -1,
        name: name,
        currencyPrecision: currencyPrecision,
        currency: currency,
        cloudUser: null,
      ));
}
