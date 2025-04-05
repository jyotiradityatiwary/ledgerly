import 'package:ledgerly/model/crud_services/account_crud_service.dart';
import 'package:ledgerly/model/crud_services/crud_service.dart';
import 'package:ledgerly/model/crud_services/transaction_crud_service.dart';
import 'package:ledgerly/model/schemas.dart';
import 'package:ledgerly/model/crud_services/user_crud_service.dart';

final accountCrudService = AccountCrudService(
  accountSchema,
  transactionSchema: transactionSchema,
);
final budgetCrudService = CrudService(budgetSchema);
final cloudUserCrudService = CrudService(cloudUserSchema);
final transactionCategoryCrudService =
    UserOwnedCrudService(transactionCategorySchema);
final transactionCrudService = TransactionCrudService(
  transactionSchema,
  accountSchema: accountSchema,
);
final userCrudService = UserCrudService(userSchema);
