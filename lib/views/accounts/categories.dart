import 'package:flutter/material.dart';
import 'package:ledgerly/notifiers/account_notifier.dart';
import 'package:ledgerly/views/accounts/add_category_screen.dart';
import 'package:ledgerly/views/utility/transaction_formatting.dart';
import 'package:provider/provider.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600.0),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Consumer<AccountNotifier>(
          builder: (context, accountNotifier, child) =>
              accountNotifier.categories.isEmpty
                  ? const Text('No categories added yet.')
                  : _CategoriesListView(
                      accountNotifier: accountNotifier,
                    ),
        ),
      ),
    );
  }
}

class _CategoriesListView extends StatelessWidget {
  final AccountNotifier accountNotifier;

  const _CategoriesListView({
    required this.accountNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final category = accountNotifier.categories[index];
        return ListTile(
          title: Text(category.name),
          subtitle:
              category.description == null ? null : Text(category.description!),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => AddOrModifyCategoryScreen(
                      category: category,
                    )),
          ),
          trailing: IconButton(
            onPressed: () => accountNotifier.areAnyTransactionsLinkedToCategory(
                    categoryId: category.id)
                ? showDialog(
                    context: context,
                    builder: (context) => _CategoryDeletionCascadingAlertDialog(
                      accountNotifier: accountNotifier,
                      categoryId: category.id,
                    ),
                  )
                : accountNotifier.deleteCategory(categoryId: category.id),
            icon: Icon(Icons.delete),
          ),
          leading: getIconForTransactionType(category.type),
        );
      },
      itemCount: accountNotifier.categories.length,
      separatorBuilder: (context, index) => SizedBox.fromSize(
        size: Size.fromHeight(8.0),
      ),
    );
  }
}

class AddCategoryFAB extends StatelessWidget {
  const AddCategoryFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => AddOrModifyCategoryScreen())),
      label: const Text('Add Category'),
      icon: const Icon(Icons.add),
    );
  }
}

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      floatingActionButton: const AddCategoryFAB(),
      body: const CategoriesPage(),
    );
  }
}

class _CategoryDeletionCascadingAlertDialog extends StatelessWidget {
  const _CategoryDeletionCascadingAlertDialog({
    required this.accountNotifier,
    required this.categoryId,
  });

  final AccountNotifier accountNotifier;
  final int categoryId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog.adaptive(
      title: Text('Warning'),
      content: Container(
        constraints: BoxConstraints(
          maxWidth: 600,
        ),
        child: Text(
          'There are transaction that are assigned this category. Deleting this category will make the category for such acounts un-assigned.\n\nDo you want to continue?',
          softWrap: true,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            accountNotifier.deleteCategory(categoryId: categoryId);
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.error,
          ),
          child: Text('Yes, Delete'),
        )
      ],
    );
  }
}
