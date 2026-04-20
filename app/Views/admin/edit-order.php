<div class="max-w-3xl mx-auto p-6">
    <h1 class="text-3xl font-bold mb-6">Edit Order</h1>

    <?php if (!empty($errors)): ?>
        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-6">
            <ul class="list-disc list-inside">
                <?php foreach ($errors as $error): ?>
                    <li><?= htmlspecialchars($error) ?></li>
                <?php endforeach; ?>
            </ul>
        </div>
    <?php endif; ?>

    <div class="bg-white rounded-lg shadow p-6">
        <form method="POST" action="">
            <div class="mb-4">
                <label class="block text-sm font-medium mb-2">Order ID</label>
                <input type="text"
                       value="<?= htmlspecialchars($order['order_id']) ?>"
                       class="w-full border rounded-lg px-3 py-2 bg-gray-100"
                       readonly>
            </div>

            <div class="mb-4">
                <label class="block text-sm font-medium mb-2">Ordered At</label>
                <input type="text"
                       value="<?= htmlspecialchars($order['ordered_at']) ?>"
                       class="w-full border rounded-lg px-3 py-2 bg-gray-100"
                       readonly>
            </div>

            <div class="mb-4">
                <label for="payment_method" class="block text-sm font-medium mb-2">Payment Method</label>
                <input type="text"
                       id="payment_method"
                       name="payment_method"
                       value="<?= htmlspecialchars($_POST['payment_method'] ?? $order['payment_method']) ?>"
                       class="w-full border rounded-lg px-3 py-2">
            </div>

            <div class="mb-4">
                <label for="status" class="block text-sm font-medium mb-2">Status</label>
                <input type="text"
                       id="status"
                       name="status"
                       value="<?= htmlspecialchars($_POST['status'] ?? $order['status']) ?>"
                       class="w-full border rounded-lg px-3 py-2">
            </div>

            <div class="mb-6">
                <label for="total_gbp" class="block text-sm font-medium mb-2">Total (£)</label>
                <input type="number"
                       step="0.01"
                       id="total_gbp"
                       name="total_gbp"
                       value="<?= htmlspecialchars($_POST['total_gbp'] ?? $order['total_gbp']) ?>"
                       class="w-full border rounded-lg px-3 py-2">
            </div>

            <div class="flex gap-3">
                <button type="submit"
                        class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg">
                    Update Order
                </button>

                <a href="/orders"
                   class="bg-gray-300 hover:bg-gray-400 text-gray-800 px-4 py-2 rounded-lg">
                    Cancel
                </a>
            </div>
        </form>
    </div>
</div>