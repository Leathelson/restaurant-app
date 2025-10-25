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
      appBar: AppBar(
        title: Text('Order History'),
      ),
      body: Column(
        children: [
          // Filter chips row
          Padding(
            padding: EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              children: ['All', 'Completed', 'Cancelled', 'Upcoming']
                  .map(
                    (filter) => ChoiceChip(
                      label: Text(filter),
                      selected: selectedFilter == filter,
                      onSelected: (selected) {
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                      selectedColor: Colors.amber,
                    ),
                  )
                  .toList(),
            ),
          ),

          // Order list
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

                      // Apply filter
                      if (selectedFilter != 'All' &&
                          order.status != selectedFilter) {
                        return SizedBox.shrink();
                      }

                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        child: ExpansionTile(
                          title: Text(
                            'Order #${order.id.substring(0, 8)}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${order.date.day}/${order.date.month}/${order.date.year} • Rs ${order.total.toStringAsFixed(2)}',
                          ),
                          trailing: Chip(
                            label: Text(order.status),
                            backgroundColor: Colors.green.shade100,
                          ),
                          children: [
                            Divider(),
                            ...order.items.map(
                              (item) => ListTile(
                                leading: Image.asset(
                                  item.food.image,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                                title: Text(
                                  item.food.name,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis, // prevent overflow
                                ),
                                subtitle: Text(
                                  'Quantity: ${item.quantity}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: 80),
                                  child: Text(
                                    'Rs ${(item.food.price * item.quantity).toStringAsFixed(2)}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                          ],
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
