import 'package:flutter/material.dart';
import '../../models/app_data.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  String selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order History')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: ['All', 'Completed', 'Cancelled', 'Upcoming']
                  .map(
                    (filter) => Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(filter),
                        selected: selectedFilter == filter,
                        onSelected: (selected) {
                          setState(() {
                            selectedFilter = filter;
                          });
                        },
                        selectedColor: Colors.amber,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Expanded(
            child: AppData.orders.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No orders yet',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: AppData.orders.length,
                    itemBuilder: (context, index) {
                      final order = AppData.orders[index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: ExpansionTile(
                          title: Text('Order #${order.id.substring(0, 8)}'),
                          subtitle: Text(
                            '${order.date.day}/${order.date.month}/${order.date.year} • \$${order.total.toStringAsFixed(2)}',
                          ),
                          trailing: Chip(
                            label: Text(order.status),
                            backgroundColor: Colors.green.shade100,
                          ),
                          children: order.items
                              .map(
                                (item) => ListTile(
                                  leading: Text(
                                    item.food.image,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  title: Text(item.food.name),
                                  subtitle: Text('Quantity: ${item.quantity}'),
                                  trailing: Text(
                                    '\$${(item.food.price * item.quantity).toStringAsFixed(2)}',
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
