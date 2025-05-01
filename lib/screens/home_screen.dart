import 'package:flutter/material.dart';
import 'package:sport_shop/services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> categories = [
    'Football',
    'Basketball',
    'Badminton',
    'Baseball',
    'Cricket'
  ];
  String selectedCategory = 'Football';

  final TextEditingController searchController = TextEditingController();

  final List<Map<String, String>> allProducts = [
    {'name': 'Football 1', 'category': 'Football', 'image': 'football1.jpeg'},
    {'name': 'Football 2', 'category': 'Football', 'image': 'football2.jpeg'},
    {'name': 'Football 3', 'category': 'Football', 'image': 'football3.jpg'},
    {'name': 'Football 4', 'category': 'Football', 'image': 'football4.jpeg'},
    {'name': 'Football 5', 'category': 'Football', 'image': 'football5.jpeg'},
    {'name': 'Football 6', 'category': 'Football', 'image': 'football6.jpeg'},
    {
      'name': 'Basketball 1',
      'category': 'Basketball',
      'image': 'basketball1.jpeg'
    },
    {
      'name': 'Basketball 2',
      'category': 'Basketball',
      'image': 'basketball2.jpg'
    },
    {
      'name': 'Badminton 1',
      'category': 'Badminton',
      'image': 'badminton1.webp'
    },
    {
      'name': 'Badminton 2',
      'category': 'Badminton',
      'image': 'bandminton2.jpeg'
    },
    {
      'name': 'Badminton 3',
      'category': 'Badminton',
      'image': 'badminton3.jpeg'
    },
    {'name': 'Baseball 1', 'category': 'Baseball', 'image': 'baseball1.png'},
    {'name': 'Baseball 2', 'category': 'Baseball', 'image': 'baseball2.jpeg'},
    {'name': 'Cricket 1', 'category': 'Cricket', 'image': 'cricket1.png'},
    {'name': 'Cricket 2', 'category': 'Cricket', 'image': 'cricket2.jpg'},
    {'name': 'Cricket 3', 'category': 'Cricket', 'image': 'cricket3.png'},
    {'name': 'Cricket 4', 'category': 'Cricket', 'image': 'cricket4.jpeg'},
    {'name': 'Cricket 5', 'category': 'Cricket', 'image': 'cricket5.png'},
    {'name': 'Cricket 6', 'category': 'Cricket', 'image': 'cricket6.jpeg'},
  ];

  final String userName = "John Doe";
  final String userEmail = "johndoe@example.com";
  final String userAvatar = "assets/images/user_avatar.jpg";

  @override
  Widget build(BuildContext context) {
    final filteredProducts = allProducts
        .where((p) => p['category'] == selectedCategory)
        .where((p) => p['name']!
            .toLowerCase()
            .contains(searchController.text.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sport Shop'),
        backgroundColor: Colors.deepPurple,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(userName),
              accountEmail: Text(userEmail),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage(userAvatar),
              ),
              decoration: const BoxDecoration(
                color: Colors.deepPurple,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => Navigator.pushReplacementNamed(context, '/home'),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () => Navigator.pushNamed(context, '/profile'),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                AuthService().signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Categories:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 50,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final isSelected = selectedCategory == category;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory = category;
                            });
                          },
                          child: Chip(
                            label: Text(
                              category,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                            backgroundColor: isSelected
                                ? Colors.deepPurple
                                : Colors.grey[300],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search products...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onChanged: (value) => setState(() {}),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Products in $selectedCategory:',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
            ),
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = filteredProducts[index];
                  return ProductCard(product: product);
                },
                childCount: filteredProducts.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: 0.75,
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SizedBox(height: 20),
                  Text(
                    'All Products:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = allProducts[index];
                  return ProductCard(product: product);
                },
                childCount: allProducts.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: 0.75,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Map<String, String> product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 5,
      shadowColor: Colors.grey.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/${product['image']}',
              height: 120,
              width: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            product['name']!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            product['category']!,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
