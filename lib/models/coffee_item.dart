class CoffeeItem {
  final String name;
  final String description;
  final double price;
  final String image;
  final String category;

  const CoffeeItem({
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
  });
}

const List<CoffeeItem> coffeeMenu = [
  CoffeeItem(name: 'Lavender Latte', description: 'Lavender and espresso', price: 145, image: 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=500', category: 'Coffee'),
  CoffeeItem(name: 'Spanish Latte', description: 'Sweet creamy espresso', price: 135, image: 'https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=500', category: 'Coffee'),
  CoffeeItem(name: 'Caramel Macchiato', description: 'Espresso with caramel', price: 150, image: 'https://images.unsplash.com/photo-1485808191679-5f86510681a2?w=500', category: 'Coffee'),
  CoffeeItem(name: 'Iced Mocha', description: 'Chocolate and espresso', price: 140, image: 'https://images.unsplash.com/photo-1512568400610-62da28bc8a13?w=500', category: 'Coffee'),
  CoffeeItem(name: 'Butter Croissant', description: 'Flaky buttery pastry', price: 85, image: 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=500', category: 'Snack'),
  CoffeeItem(name: 'Chocolate Cake', description: 'Rich chocolate cake', price: 110, image: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=500', category: 'Snack'),
  CoffeeItem(name: 'Strawberry Donut', description: 'Sweet strawberry donut', price: 75, image: 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=500', category: 'Snack'),
  CoffeeItem(name: 'Chocolate Cookies', description: 'Freshly baked cookies', price: 65, image: 'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=500', category: 'Snack'),
];
