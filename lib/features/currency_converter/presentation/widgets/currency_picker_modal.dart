import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/core.dart';
import '../providers/currency_list_provider.dart';
import '../../domain/entities/currency.dart';

class CurrencyPickerModal extends ConsumerStatefulWidget {
  final bool isFromCurrency;
  final Function(Currency) onCurrencySelected;
  final AppLocalizations localizations;

  const CurrencyPickerModal({
    super.key,
    required this.isFromCurrency,
    required this.onCurrencySelected,
    required this.localizations,
  });

  @override
  ConsumerState<CurrencyPickerModal> createState() =>
      _CurrencyPickerModalState();
}

class _CurrencyPickerModalState extends ConsumerState<CurrencyPickerModal> {
  final TextEditingController _searchController = TextEditingController();
  List<Currency> _filteredCurrencies = [];
  List<Currency> _allCurrencies = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCurrencies = _allCurrencies;
      } else {
        _filteredCurrencies = _allCurrencies
            .where(
              (currency) =>
                  currency.name.toLowerCase().contains(query) ||
                  currency.code.toLowerCase().contains(query),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyListAsync = ref.watch(currencyListProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.isFromCurrency
                      ? widget.localizations.fromCurrencyLabel
                      : widget.localizations.toCurrencyLabel,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          // Search field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search currencies...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primaryHeader),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Currency list
          Expanded(
            child: currencyListAsync.when(
              data: (currencies) {
                if (_allCurrencies.isEmpty) {
                  _allCurrencies = currencies;
                  _filteredCurrencies = currencies;
                }

                if (_filteredCurrencies.isEmpty &&
                    _searchController.text.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.localizations.noCurrenciesFound,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.localizations.tryDifferentSearch,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final currency = _filteredCurrencies[index];
                        return Column(
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              leading: CurrencyFlag(
                                currencyCode: currency.code,
                                size: 40,
                              ),
                              title: Text(
                                currency.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(currency.code),
                              trailing: currency.symbol.isNotEmpty
                                  ? Text(
                                      currency.symbol,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryHeader,
                                      ),
                                    )
                                  : null,
                              onTap: () => widget.onCurrencySelected(currency),
                            ),
                            if (index < _filteredCurrencies.length - 1)
                              const Divider(
                                height: 1,
                                thickness: 0.5,
                                color: Color(0xFFE7E7EE),
                              ),
                          ],
                        );
                      }, childCount: _filteredCurrencies.length),
                    ),
                  ],
                );
              },
              loading: () => _buildSkeletonLoader(),
              error: (error, stack) => _buildErrorState(error, ref),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    // Generate a list of placeholder currencies for skeleton loading
    final skeletonCurrencies = List.generate(
      8,
      (index) => Currency(
        code: 'USD',
        name: 'United States Dollar',
        symbol: '\$',
        flag: '',
      ),
    );

    return Skeletonizer(
      enabled: true,
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final currency = skeletonCurrencies[index];
              return Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    leading: CurrencyFlag(
                      currencyCode: currency.code,
                      size: 40,
                    ),
                    title: Text(
                      currency.name,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(currency.code),
                    trailing: currency.symbol.isNotEmpty
                        ? Text(
                            currency.symbol,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryHeader,
                            ),
                          )
                        : null,
                    onTap: () {}, // Disabled during loading
                  ),
                  if (index < skeletonCurrencies.length - 1)
                    const Divider(
                      height: 1,
                      thickness: 0.5,
                      color: Color(0xFFE7E7EE),
                    ),
                ],
              );
            }, childCount: skeletonCurrencies.length),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.localizations.failedToLoadCurrencies,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your internet connection and try again.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Refresh the currency list
                ref.invalidate(currencyListProvider);
              },
              icon: const Icon(Icons.refresh),
              label: Text(widget.localizations.retry),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryHeader,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
