import 'package:ledgerly/model/crud_services/account_crud_service.dart';
import 'package:ledgerly/model/crud_services/crud_service.dart';
import 'package:ledgerly/model/schemas.dart';
import 'package:ledgerly/model/crud_services/user_crud_service.dart';

final accountCrudService = AccountCrudService(accountSchema);
final budgetCrudService = CrudService(budgetSchema);
final cloudUserCrudService = CrudService(cloudUserSchema);
final transactionCategoryCrudService = CrudService(transactionCategorySchema);
final transactionCrudService = CrudService(transactionSchema);
final userCrudService = UserCrudService(userSchema);
