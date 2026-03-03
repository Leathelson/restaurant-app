import 'package:flutter/material.dart';
import '../../models/app_data.dart';
import '../../models/food_model.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  String selectedFilter = 'All';
  final List<String> filters = ['All', 'Completed', 'Cancelled', 'Upcoming'];

  @override
  void initState() {
    super.initState();
    if (AppData.orders.isEmpty) {
      AppData.orders = [
        Order(
          id: 'ORD-001',
          status: 'Completed',
          date: DateTime(2026, 10, 10),
          total: 2600.0,
          items: [
            CartItem(
              food: FoodModel(
                id: 'f1',
                name: 'Beluga Caviar', // Key for translation
                image: '',
                shortdescription: 'Fresh local beluga caviar.',
                longdescription: 'Premium beluga caviar with a rich flavor.',
                rating: 4.8,
                category: 'Non-Veg',
                price: 1300.0,
                imagePath: '',
              ),
              quantity: 2,
              unitPrice: 1300.0,
            ),
          ],
        ),
        Order(
          id: 'ORD-002',
          status: 'Completed',
          date: DateTime(2026, 09, 15),
          total: 2600.0,
          items: [
            CartItem(
              food: FoodModel(
                id: 'f2',
                name:
                    'Citrus-Infused East Coast Oysters', // Key for translation
                image: '',
                shortdescription: 'Fresh local oysters.',
                longdescription: 'Premium oysters infused with citrus.',
                rating: 4.8,
                category: 'Non-Veg',
                price: 1300.0,
                imagePath: '',
              ),
              quantity: 2,
              unitPrice: 1300.0,
            ),
          ],
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color maroonColor = Color(0xFF63210B);
    const Color goldColor = Color(0xFFB8860B);
    const Color darkCardColor = Color(0xFF2C3E50);

    final filteredOrders = AppData.orders.where((order) {
      if (selectedFilter == 'All') return true;
      return order.status.toLowerCase() == selectedFilter.toLowerCase();
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppData.trans('Order History'),
          style: const TextStyle(
            color: maroonColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildFilterTabs(goldColor),
          Expanded(
            child: filteredOrders.isEmpty
                ? Center(child: Text(AppData.trans('No orders yet')))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];

                      // Match the design: Sept 15 is the Dark Purple card
                      bool isSpecial =
                          order.date.day == 15 && order.date.month == 9;

                      return _buildOrderCard(
                          order, isSpecial ? darkCardColor : goldColor);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs(Color goldColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: filters.map((filter) {
          bool isSelected = selectedFilter == filter;
          return GestureDetector(
            onTap: () => setState(() => selectedFilter = filter),
            child: Column(
              children: [
                Text(
                  AppData.trans(filter),
                  style: TextStyle(
                    color: isSelected ? goldColor : const Color(0xFF34495E),
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (isSelected)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    height: 2,
                    width: 20,
                    color: goldColor,
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOrderCard(Order order, Color bgColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${order.date.day} ${AppData.trans(_getMonthName(order.date.month))}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    AppData.trans(order.status),
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // FIXED: Wrapped item name in AppData.trans()
                ...order.items.map((item) => Text(
                      "- ${AppData.trans(item.food.name)} x${item.quantity}",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    )),
              ],
            ),
          ),
          Text(
            "Rs ${order.total.toInt()}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return months[month - 1];
  }
}
