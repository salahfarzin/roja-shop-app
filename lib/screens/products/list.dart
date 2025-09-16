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
  @override
  void initState() {
    super.initState();
    // Fetch products from server via provider (which uses ProductService)
    Future.microtask(
      () =>
          Provider.of<ProductProvider>(context, listen: false).fetchProducts(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final products = provider.products;

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
        body: provider.status == ProductStatus.loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () async {
                  await Provider.of<ProductProvider>(
                    context,
                    listen: false,
                  ).fetchProducts();
                },
                child: Builder(
                  builder: (context) {
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
                                Provider.of<ProductProvider>(
                                  context,
                                  listen: false,
                                ).fetchProducts();
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
                    } else if (products.isEmpty) {
                      return ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          const SizedBox(height: 200),
                          Center(child: Text('no products'.tr())),
                          const SizedBox(height: 24),
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
                                Provider.of<ProductProvider>(
                                  context,
                                  listen: false,
                                ).fetchProducts();
                              },
                            ),
                          ),
                        ],
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: GridView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: products.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 18,
                              crossAxisSpacing: 18,
                              childAspectRatio: 0.72,
                            ),
                        itemBuilder: (context, index) {
                          return ProductCard(product: products[index]);
                        },
                        cacheExtent:
                            500, // Only keep 500 pixels worth of widgets in memory
                      ),
                    );
                  },
                ),
              ),
        bottomNavigationBar: const CustomBottomNavBar(),
      ),
    );
  }
}
