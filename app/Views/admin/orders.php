<div class="max-w-6xl mx-auto p-6">
    <h1 class="text-3xl font-bold mb-6">Orders</h1>
   
    <div class="bg-white rounded-lg shadow p-6">
        <?php if (!empty($recentOrders)): ?>
            <div class="overflow-x-auto">
                <table class="w-full border-collapse">
                    <thead>
                        <tr class="border-b">
                            <th class="text-left p-3">Order ID</th>
                            <th class="text-left p-3">Customer</th>
                            <th class="text-left p-3">Taken By</th>
                            <th class="text-left p-3">Date</th>
                            <th class="text-left p-3">Payment</th>
                            <th class="text-left p-3">Status</th>
                            <th class="text-left p-3">Total</th>
                            <th class="text-left p-3">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($recentOrders as $order): ?>
                            <tr class="border-b">
                                <td class="p-3"><?= htmlspecialchars($order['order_id']) ?></td>
                                <td class="p-3">
                                    <?= htmlspecialchars($order['customer_first_name'] . ' ' . $order['customer_last_name']) ?>
                                </td>
                                <td class="p-3">
                                    <?= htmlspecialchars($order['staff_first_name'] . ' ' . $order['staff_last_name']) ?>
                                </td>
                                <td class="p-3"><?= htmlspecialchars($order['ordered_at']) ?></td>
                                <td class="p-3"><?= htmlspecialchars(ucfirst($order['payment_method'])) ?></td>
                                <td class="p-3"><?= htmlspecialchars(ucfirst($order['status'])) ?></td>
                                <td class="p-3">£<?= number_format((float) $order['total_gbp'], 2) ?></td>

                                <!-- Actions -->
                                <td class="p-3">
                                    <div class="flex gap-2">
                                        <!-- Edit Button -->
                                        <button
                                            class="bg-blue-500 hover:bg-blue-600 text-white text-sm px-3 py-1.5 rounded-lg">
                                            Edit
                                        </button>

                                        <!-- Delete Button -->
                                        <button
                                            class="bg-red-500 hover:bg-red-600 text-white text-sm px-3 py-1.5 rounded-lg">
                                            Delete
                                        </button>
                                    </div>
                                </td>

                            </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        <?php else: ?>
            <p>No recent orders found.</p>
        <?php endif; ?>
    </div>
</div>