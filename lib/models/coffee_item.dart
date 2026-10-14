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
  CoffeeItem(
    name: 'Lavender Latte',
    description: 'Smooth latte with floral lavender',
    price: 145,
    image: 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=500',
    category: 'Coffee',
  ),
  CoffeeItem(
    name: 'Spanish Latte',
    description: 'Espresso with creamy sweet milk',
    price: 135,
    image: 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=500',
    category: 'Coffee',
  ),
  CoffeeItem(
    name: 'Caramel Macchiato',
    description: 'Espresso with sweet caramel',
    price: 150,
    image: 'https://images.unsplash.com/photo-1485808191679-5f86510681a2?w=500',
    category: 'Coffee',
  ),
  CoffeeItem(
    name: 'Iced Mocha',
    description: 'Coffee blended with chocolate',
    price: 140,
    image: 'https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=500',
    category: 'Coffee',
  ),
  CoffeeItem(
    name: 'Cappuccino',
    description: 'Espresso topped with milk foam',
    price: 120,
    image: 'https://images.unsplash.com/photo-1534778101976-62847782c213?w=500',
    category: 'Coffee',
  ),
  CoffeeItem(
    name: 'Cafe Americano',
    description: 'Classic espresso and water',
    price: 100,
    image: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=500',
    category: 'Coffee',
  ),
  CoffeeItem(
    name: 'Vanilla Latte',
    description: 'Creamy latte with vanilla',
    price: 135,
    image: 'https://images.unsplash.com/photo-1570968915860-54d5c301fa9f?w=500',
    category: 'Coffee',
  ),
  CoffeeItem(
    name: 'Caramel Latte',
    description: 'Milky coffee with caramel',
    price: 140,
    image: 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=500',
    category: 'Coffee',
  ),
  CoffeeItem(
    name: 'Strawberry Milk',
    description: 'Sweet and creamy strawberry milk',
    price: 120,
    image: 'assets/images/strawberrymilk.jpg',
    category: 'Drinks',
  ),
  CoffeeItem(
    name: 'Chocolate Frappe',
    description: 'Chilled chocolate blended drink',
    price: 145,
    image: 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=500',
    category: 'Drinks',
  ),
  CoffeeItem(
    name: 'Matcha Latte',
    description: 'Earthy matcha with creamy milk',
    price: 135,
    image: 'https://images.unsplash.com/photo-1515823064-d6e0c04616a7?w=500',
    category: 'Drinks',
  ),
  CoffeeItem(
    name: 'Mango Smoothie',
    description: 'Refreshing sweet mango blend',
    price: 125,
    image: 'https://images.unsplash.com/photo-1505252585461-04db1eb84625?w=500',
    category: 'Drinks',
  ),
  CoffeeItem(
    name: 'Blueberry Soda',
    description: 'Refreshing blueberry sparkling drink',
    price: 95,
    image: 'assets/images/blueberrysoda.jpg',
    category: 'Drinks',
  ),
  CoffeeItem(
    name: 'Iced Chocolate',
    description: 'Rich chocolate over ice',
    price: 130,
    image: 'assets/images/icedchoclate.jpg',
    category: 'Drinks',
  ),
  CoffeeItem(
    name: 'Butter Croissant',
    description: 'Flaky and buttery pastry',
    price: 85,
    image: 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=500',
    category: 'Snacks',
  ),
  CoffeeItem(
    name: 'Chocolate Cake',
    description: 'Soft cake with chocolate frosting',
    price: 110,
    image: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=500',
    category: 'Snacks',
  ),
  CoffeeItem(
    name: 'Strawberry Donut',
    description: 'Sweet donut with strawberry icing',
    price: 65,
    image: 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=500',
    category: 'Snacks',
  ),
  CoffeeItem(
    name: 'Chocolate Cookies',
    description: 'Crunchy cookies with chocolate chips',
    price: 55,
    image: 'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=500',
    category: 'Snacks',
  ),
  CoffeeItem(
    name: 'Belgian Waffles',
    description: 'Golden waffles served with toppings',
    price: 100,
    image: 'https://images.unsplash.com/photo-1562376552-0d160a2f238d?w=500',
    category: 'Snacks',
  ),
  CoffeeItem(
    name: 'Cinnamon Roll',
    description: 'Soft roll with cinnamon sweetness',
    price: 90,
    image: 'https://images.unsplash.com/photo-1509365465985-25d11c17e812?w=500',
    category: 'Snacks',
  ),
];