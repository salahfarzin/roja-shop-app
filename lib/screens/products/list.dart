import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../providers/product_provider.dart';
import '../../components/product_card.dart';
import '../../components/bottom_navbar.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final int _pageSize = 6;
  int _currentPage = 0;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  DateTime _lastLoadTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialProducts();
    });
  }

  void _loadInitialProducts() async {
    _currentPage = 0;
    _hasMore = true;
    await Provider.of<ProductProvider>(
      context,
      listen: false,
    ).fetchMoreProducts(page: _currentPage, limit: _pageSize);
    final provider = Provider.of<ProductProvider>(context, listen: false);
    _hasMore = provider.products.length == _pageSize;
    setState(() {}); // Only update once after initial load
  }

  void _onScroll() async {
    final now = DateTime.now();
    if (_isLoadingMore || !_hasMore) return;
    if (now.difference(_lastLoadTime).inMilliseconds < 700) return;
    _lastLoadTime = now;
    setState(() => _isLoadingMore = true);
    _currentPage++;
    await Provider.of<ProductProvider>(
      context,
      listen: false,
    ).fetchMoreProducts(page: _currentPage, limit: _pageSize);
    final provider = Provider.of<ProductProvider>(context, listen: false);
    _hasMore = provider.products.length >= (_currentPage + 1) * _pageSize;
    setState(() => _isLoadingMore = false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'app title'.tr(),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add, size: 28),
              tooltip: 'Add Product',
              onPressed: () {
                Navigator.of(context).pushNamed('/add-product');
              },
            ),
            IconButton(
              icon: const Icon(Icons.search, size: 28),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.notifications_none, size: 28),
              onPressed: () {},
            ),
          ],
        ),
        body: Consumer<ProductProvider>(
          builder: (context, provider, _) {
            final products = provider.products;
            if (provider.status == ProductStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (provider.status == ProductStatus.error) {
              return ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(height: 32),
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: Text('try again'.tr()),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () {
                        _loadInitialProducts();
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Center(
                      child: Text(
                        provider.errorMessage ?? 'error_loading'.tr(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            if (products.isEmpty) {
              return ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(height: 200),
                  Center(child: Text('no products'.tr())),
                  const SizedBox(height: 24),
                ],
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                _loadInitialProducts();
              },
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (!_isLoadingMore &&
                      _hasMore &&
                      scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent - 200) {
                    _onScroll();
                  }
                  return false;
                },
                child: GridView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(left: 7, right: 7),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: products.length + (_isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < products.length) {
                      final product = products[index];
                      return ProductCard(
                        key: Key(product.id),
                        product: product,
                      );
                    } else {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                  },
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: const CustomBottomNavBar(),
      ),
    );
  }
}
